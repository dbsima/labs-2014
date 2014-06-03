#include <stdio.h>
#include <spu_intrinsics.h>
#include <spu_mfcio.h>

/* TODO: adaugati define de waitag, vezi exemple DMA */
#define wait_tag(t) \
	mfc_write_tag_mask(1<<t); \
	mfc_read_tag_status_all();

typedef struct {
	float* A;	// pointer to section in first input array
	float* B;	// pointer to section in second input array
	float* C;	// pointer to section of output array
	int dim;	// dimensiune transfer DMA
} pointers_t;

void print_vector(vector float *v, int length);
	float a[5000] __attribute__ ((aligned(16)));
	float b[5000] __attribute__ ((aligned(16)));
	
int main(unsigned long long speid, unsigned long long argp, unsigned long long envp)
{

	int i=0,j=0,dim;
	pointers_t p __attribute__ ((aligned(16)));
	uint32_t tag_id = mfc_tag_reserve();
	if (tag_id==MFC_TAG_INVALID){
		printf("SPU: ERROR can't allocate tag ID\n"); return -1;
	}

	/* TODO: obtineti prin DMA structura cu pointeri si dimensiunea transferurilor (vezi cerinta 2) */ 
	
	mfc_get(&p, (uint32_t) argp, sizeof(pointers_t), tag_id, 0, 0);
	wait_tag(tag_id);
	printf("%d\n", p.dim);

	/* TODO: cititi in Local Store date din A si B (vezi cerinta 3) */

	mfc_get(a, (uint32_t)p.A, 16*1024, tag_id, 0, 0);
	mfc_get(a+4*1024, (uint32_t)(p.A + 4*1024), 20000 - 4*4096, tag_id, 0, 0);
	
	//mfc_get(b, (uint32_t)p.B, 16*1024, tag_id, 0, 0);
	//mfc_get(b+1024, (uint32_t)(p.B+16*1024), 20000 - 16*1024, tag_id, 0, 0);

	wait_tag(tag_id);
	print_vector(a, p.dim/16);
	/* TODO: adunati element cu element A si B folosind operatii vectoriale (vezi cerinta 4) */

	/* TODO: scrieti in main storage date din C (vezi cerinta 5) */

	/* TODO: repetati pasii de mai sus de cate ori este nevoie pentru a acoperi toate elementele, si semnalati un ciclu prin mailbox (vezi cerinta 6) */

	return 0;
}

void print_vector(vector float *v, int length)
{
        int i;
        for (i = 0; i < length; i+=1)
           printf("%.2lf %.2lf %.2lf %.2lf ", v[i][0], v[i][1], v[i][2], v[i][3]);
        printf("\n");
}


