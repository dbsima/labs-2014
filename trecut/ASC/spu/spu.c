#include <spu_mfcio.h>
#include <stdio.h>
#include <libmisc.h>
#include <string.h>

#include "../common.h"

#define MY_TAG 5
#define DONE 1

void process_image_dmalist(struct image* img){
}

void process_image_double(struct image* img){
	unsigned char *input[2], *output, *temp;
	unsigned int addr1, addr2, i, j, k, r, g, b;
	int block_nr = img->block_nr;
	vector unsigned char *v1[2], *v2[2], *v3[2], *v4[2], *v5;

	int buf, nxt_buf; //index of the buffer (0/1)

	input[0] = malloc_align(NUM_CHANNELS * SCALE_FACTOR * img->width, 4);
	input[1] = malloc_align(NUM_CHANNELS * SCALE_FACTOR * img->width, 4);

	output = malloc_align(NUM_CHANNELS * img->width / SCALE_FACTOR, 4);
	temp = malloc_align(NUM_CHANNELS * img->width, 4);

	//optimization
	unsigned int num_channels_X_img_width = NUM_CHANNELS * img->width;

	v1[0] = (vector unsigned char *) &input[0][0];
	v2[0] = (vector unsigned char *) &input[0][1 * num_channels_X_img_width];
	v3[0] = (vector unsigned char *) &input[0][2 * num_channels_X_img_width];
	v4[0] = (vector unsigned char *) &input[0][3 * num_channels_X_img_width];
	v5 = (vector unsigned char *) temp;

	v1[1] = (vector unsigned char *) &input[1][0];
	v2[1] = (vector unsigned char *) &input[1][1 * num_channels_X_img_width];
	v3[1] = (vector unsigned char *) &input[1][2 * num_channels_X_img_width];
	v4[1] = (vector unsigned char *) &input[1][3 * num_channels_X_img_width];


	addr2 = (unsigned int)img->dst; //start of image
	addr2 += (block_nr / NUM_IMAGES_HEIGHT) * num_channels_X_img_width * 
		img->height / NUM_IMAGES_HEIGHT; //start line of spu block
	addr2 += (block_nr % NUM_IMAGES_WIDTH) * num_channels_X_img_width / NUM_IMAGES_WIDTH;

	addr1 = ((unsigned int)img->src);

	buf = 0; // first data transfer
	mfc_getb(input[buf], addr1, SCALE_FACTOR * num_channels_X_img_width, 0, 0, 0);

	for (i = 1; i<img->height / SCALE_FACTOR; i++){
		// get 4 lines
		nxt_buf = buf ^ 1; //ask for next data buffer from PPU
		
		//mfg_get with barrier
		addr1 = ((unsigned int)img->src) + i * num_channels_X_img_width * SCALE_FACTOR;
		mfc_getb(input[nxt_buf], addr1, SCALE_FACTOR * num_channels_X_img_width, nxt_buf, 0, 0);

		mfc_write_tag_mask(1 << buf);
		mfc_read_tag_status_all();

		// process current buffer
		for (j = 0; j < img->width * NUM_CHANNELS / 16; j++){
			v5[j] = spu_avg(spu_avg(v1[buf][j], v2[buf][j]), spu_avg(v3[buf][j], v4[buf][j]));
		}
		
		for (j = 0; j < img->width; j+=SCALE_FACTOR){
			r = g = b = 0;
			for (k = j; k < j + SCALE_FACTOR; k++) {
				r += temp[k * NUM_CHANNELS + 0];
				g += temp[k * NUM_CHANNELS + 1];
				b += temp[k * NUM_CHANNELS + 2];
			}
			r /= SCALE_FACTOR;
			b /= SCALE_FACTOR;
			g /= SCALE_FACTOR;

			output[j / SCALE_FACTOR * NUM_CHANNELS + 0] = (unsigned char) r;
			output[j / SCALE_FACTOR * NUM_CHANNELS + 1] = (unsigned char) g;
			output[j / SCALE_FACTOR * NUM_CHANNELS + 2] = (unsigned char) b;
		}

		// sent precedent buffer to PPU
		mfc_put(output, addr2, img->width / SCALE_FACTOR * NUM_CHANNELS, MY_TAG, 0, 0);
		addr2 += img->width * NUM_CHANNELS; //line inside spu block
		
		mfc_write_tag_mask(1 << MY_TAG);
		mfc_read_tag_status_all();

		buf = nxt_buf; //prepare next iteration
	}

	mfc_write_tag_mask(1 << buf);
	mfc_read_tag_status_all();

	// process last buffer
	for (j = 0; j < img->width * NUM_CHANNELS / 16; j++){
		v5[j] = spu_avg(spu_avg(v1[buf][j], v2[buf][j]), spu_avg(v3[buf][j], v4[buf][j]));
	}
	
	for (j=0; j < img->width; j+=SCALE_FACTOR){
		r = g = b = 0;
		for (k = j; k < j + SCALE_FACTOR; k++) {
			r += temp[k * NUM_CHANNELS + 0];
			g += temp[k * NUM_CHANNELS + 1];
			b += temp[k * NUM_CHANNELS + 2];
		}
		r /= SCALE_FACTOR;
		b /= SCALE_FACTOR;
		g /= SCALE_FACTOR;

		output[j / SCALE_FACTOR * NUM_CHANNELS + 0] = (unsigned char) r;
		output[j / SCALE_FACTOR * NUM_CHANNELS + 1] = (unsigned char) g;
		output[j / SCALE_FACTOR * NUM_CHANNELS + 2] = (unsigned char) b;
	}

	// send last buffer to PPU
	mfc_put(output, addr2, img->width / SCALE_FACTOR * NUM_CHANNELS, MY_TAG, 0, 0);
	addr2 += img->width * NUM_CHANNELS;

	mfc_write_tag_mask(1 << MY_TAG);
	mfc_read_tag_status_all();

	free_align(temp);
	free_align(input[0]);
	free_align(input[1]);
	free_align(output);
}

void process_image_2lines(struct image* img){
	unsigned char *input, *output, *output2, *temp;
	unsigned int addr1, addr2, i, j, k, r1, g1, b1, r2, g2, b2;
	
	int block_nr = img->block_nr;
	
	vector unsigned char *v1_1, *v1_2, *v1_3, *v1_4, *v1_5;
	vector unsigned char *v2_1, *v2_2, *v2_3, *v2_4, *v2_5;

	// optimization
	unsigned int num_channels_X_img_width = NUM_CHANNELS * img->width;
	unsigned int num_channels_X_img_width_X_SCALE_FACTOR = num_channels_X_img_width * SCALE_FACTOR;
	
	input  = malloc_align(2 * num_channels_X_img_width_X_SCALE_FACTOR, 4);
	
	output  = malloc_align(num_channels_X_img_width / SCALE_FACTOR, 4);
	output2 = malloc_align(num_channels_X_img_width / SCALE_FACTOR, 4);
	
	temp = malloc_align(2 * NUM_CHANNELS * img->width, 4);

	// first line
	v1_1 = (vector unsigned char *) &input[0];
	v1_2 = (vector unsigned char *) &input[1 * num_channels_X_img_width];
	v1_3 = (vector unsigned char *) &input[2 * num_channels_X_img_width];
	v1_4 = (vector unsigned char *) &input[3 * num_channels_X_img_width];
	v1_5 = (vector unsigned char *) temp;
	
	// second line
	v2_1 = (vector unsigned char *) &input[4 * num_channels_X_img_width];
	v2_2 = (vector unsigned char *) &input[5 * num_channels_X_img_width];
	v2_3 = (vector unsigned char *) &input[6 * num_channels_X_img_width];
	v2_4 = (vector unsigned char *) &input[7 * num_channels_X_img_width];
	v2_5 = (vector unsigned char *) &temp[num_channels_X_img_width];

	addr2 = (unsigned int)img->dst; //start of image
	addr2 += (block_nr / NUM_IMAGES_HEIGHT) * img->width * NUM_CHANNELS * 
		img->height / NUM_IMAGES_HEIGHT; //start line of spu block
	addr2 += (block_nr % NUM_IMAGES_WIDTH) * NUM_CHANNELS *
		img->width / NUM_IMAGES_WIDTH;

	for (i = 0; i<img->height / SCALE_FACTOR / 2; i++){
		// get 8 lines
		addr1 = ((unsigned int)img->src) + 2 * i * num_channels_X_img_width_X_SCALE_FACTOR;
		mfc_get(input, addr1, 2 * num_channels_X_img_width * SCALE_FACTOR, MY_TAG, 0, 0);
		mfc_write_tag_mask(1 << MY_TAG);
		mfc_read_tag_status_all();

		// compute the 2 scaled line
		for (j = 0; j < num_channels_X_img_width / 16; j++){
			v1_5[j] = spu_avg(spu_avg(v1_1[j], v1_2[j]), spu_avg(v1_3[j], v1_4[j]));
			v2_5[j] = spu_avg(spu_avg(v2_1[j], v2_2[j]), spu_avg(v2_3[j], v2_4[j]));
		}

		for (j = 0; j < img->width; j += SCALE_FACTOR){
			r1 = g1 = b1 = 0;
			r2 = b2 = g2 = 0;
			for (k = j; k < j + SCALE_FACTOR; k++) {
				unsigned int k_X_NUM_CHANNELS = k * NUM_CHANNELS;
				r1 += temp[k_X_NUM_CHANNELS + 0];
				g1 += temp[k_X_NUM_CHANNELS + 1];
				b1 += temp[k_X_NUM_CHANNELS + 2];

				r2 += temp[num_channels_X_img_width + k_X_NUM_CHANNELS + 0];
				g2 += temp[num_channels_X_img_width + k_X_NUM_CHANNELS + 1];
				b2 += temp[num_channels_X_img_width + k_X_NUM_CHANNELS + 2];
			}
			r1 /= SCALE_FACTOR;
			b1 /= SCALE_FACTOR;
			g1 /= SCALE_FACTOR;
			
			r2 /= SCALE_FACTOR;
			b2 /= SCALE_FACTOR;
			g2 /= SCALE_FACTOR;
			
			output[j / SCALE_FACTOR * NUM_CHANNELS + 0] = (unsigned char) r1;
			output[j / SCALE_FACTOR * NUM_CHANNELS + 1] = (unsigned char) g1;
			output[j / SCALE_FACTOR * NUM_CHANNELS + 2] = (unsigned char) b1;
			
			output2[j / SCALE_FACTOR * NUM_CHANNELS + 0] = (unsigned char) r2;	
			output2[j / SCALE_FACTOR * NUM_CHANNELS + 1] = (unsigned char) g2;
			output2[j / SCALE_FACTOR * NUM_CHANNELS + 2] = (unsigned char) b2;
		}

		//put the scaled line back
		mfc_put(output, addr2, img->width / SCALE_FACTOR * NUM_CHANNELS, MY_TAG, 0, 0);
		addr2 += img->width * NUM_CHANNELS; //line inside spu block
		
		// trimite si al 2-lea set
		mfc_put(output2, addr2, img->width / SCALE_FACTOR * NUM_CHANNELS, MY_TAG, 0, 0);
		addr2 += img->width * NUM_CHANNELS; //line inside spu block
		
		mfc_write_tag_mask(1 << MY_TAG);
		mfc_read_tag_status_all();
	}

	free_align(temp);
	free_align(input);
	free_align(output);
	free_align(output2);
}

void process_image_simple(struct image* img){
	unsigned char *input, *output, *temp;
	unsigned int addr1, addr2, i, j, k, r, g, b;
	int block_nr = img->block_nr;
	vector unsigned char *v1, *v2, *v3, *v4, *v5 ;

	input = malloc_align(NUM_CHANNELS * SCALE_FACTOR * img->width, 4);
	output = malloc_align(NUM_CHANNELS * img->width / SCALE_FACTOR, 4);
	temp = malloc_align(NUM_CHANNELS * img->width, 4);

	v1 = (vector unsigned char *) &input[0];
	v2 = (vector unsigned char *) &input[1 * img->width * NUM_CHANNELS];
	v3 = (vector unsigned char *) &input[2 * img->width * NUM_CHANNELS];
	v4 = (vector unsigned char *) &input[3 * img->width * NUM_CHANNELS];
	v5 = (vector unsigned char *) temp;

	addr2 = (unsigned int)img->dst; //start of image
	addr2 += (block_nr / NUM_IMAGES_HEIGHT) * img->width * NUM_CHANNELS * 
		img->height / NUM_IMAGES_HEIGHT; //start line of spu block
	addr2 += (block_nr % NUM_IMAGES_WIDTH) * NUM_CHANNELS *
		img->width / NUM_IMAGES_WIDTH;

	for (i=0; i<img->height / SCALE_FACTOR; i++){
		//get 4 lines
		addr1 = ((unsigned int)img->src) + i * img->width * NUM_CHANNELS * SCALE_FACTOR;
		mfc_get(input, addr1, SCALE_FACTOR * img->width * NUM_CHANNELS, MY_TAG, 0, 0);
		mfc_write_tag_mask(1 << MY_TAG);
		mfc_read_tag_status_all();

		//compute the scaled line
		for (j = 0; j < img->width * NUM_CHANNELS / 16; j++){
			v5[j] = spu_avg(spu_avg(v1[j], v2[j]), spu_avg(v3[j], v4[j]));
		}
		for (j=0; j < img->width; j+=SCALE_FACTOR){
			r = g = b = 0;
			for (k = j; k < j + SCALE_FACTOR; k++) {
				r += temp[k * NUM_CHANNELS + 0];
				g += temp[k * NUM_CHANNELS + 1];
				b += temp[k * NUM_CHANNELS + 2];
			}
			r /= SCALE_FACTOR;
			b /= SCALE_FACTOR;
			g /= SCALE_FACTOR;

			output[j / SCALE_FACTOR * NUM_CHANNELS + 0] = (unsigned char) r;
			output[j / SCALE_FACTOR * NUM_CHANNELS + 1] = (unsigned char) g;
			output[j / SCALE_FACTOR * NUM_CHANNELS + 2] = (unsigned char) b;
		}

		//put the scaled line back
		mfc_put(output, addr2, img->width / SCALE_FACTOR * NUM_CHANNELS, MY_TAG, 0, 0);
		addr2 += img->width * NUM_CHANNELS; //line inside spu block
		mfc_write_tag_mask(1 << MY_TAG);
		mfc_read_tag_status_all();
	}

	free_align(temp);
	free_align(input);
	free_align(output);
}

int main(uint64_t speid, uint64_t argp, uint64_t envp){
	unsigned int data[NUM_STREAMS];
	unsigned int num_spus = (unsigned int)argp, i, num_images;
	struct image my_image __attribute__ ((aligned(16)));
	int mode = (int)envp;

	speid = speid; //get rid of warning

	while(1){
		num_images = 0;
		for (i = 0; i < NUM_STREAMS / num_spus; i++){
			//assume NUM_STREAMS is a multiple of num_spus
			while(spu_stat_in_mbox() == 0);
			data[i] = spu_read_in_mbox();
			if (!data[i])
				return 0;
			num_images++;
		}

		for (i = 0; i < num_images; i++){
			mfc_get(&my_image, data[i], sizeof(struct image), MY_TAG, 0, 0);
			mfc_write_tag_mask(1 << MY_TAG);
			mfc_read_tag_status_all();
			switch(mode){
				default:
				case MODE_SIMPLE:
					process_image_simple(&my_image);
					break;
				case MODE_2LINES:
					process_image_2lines(&my_image);
					break;
				case MODE_DOUBLE:
					process_image_double(&my_image);
					break;
				case MODE_DMALIST:
					process_image_dmalist(&my_image);
					break;
			}
		}	
		data[0] = DONE;
		spu_write_out_intr_mbox(data[0]);	
	}

	return 0;
}
