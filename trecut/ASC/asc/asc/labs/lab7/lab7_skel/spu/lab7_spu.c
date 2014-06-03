#include <stdio.h>
#include <spu_intrinsics.h>


void print_vector(vector float *v, int length);
float dot_product(float *a, float *b, int n);
void complex_mult(float *in1, float *in2, float *out, int n);

/* array examples for ex 3 */
#define N  16	
#define M 8
float in1[N] __attribute__ ((aligned(16))) = { 1.1, 2.2, 4.4, 5.5,
6.6, 7.7, 8.8, 9.9,
2.2, 3.3, 3.3, 2.2,
5.5, 6.6, 6.6, 5.5}; 

float in2[N] __attribute__ ((aligned(16))) = { 1.1, 2.2, 4.4, 5.5,	 
	5.5, 6.6, 6.6, 5.5,	 
	2.2, 3.3, 3.3, 2.2,	 
	6.6, 7.7, 8.8, 9.9};
float out[N] __attribute__ ((aligned(16))); 

int main(unsigned long long speid, unsigned long long argp, unsigned long long envp)
{

	printf("Hello World! from Cell (0x%llx) with argp (0x%llx) \n", speid, argp); // TODO use argp

	float a[M] __attribute__ ((aligned(16))) = {10, 20, 0, 0, 0, 0, 0, 0};
	
	float b[M] __attribute__ ((aligned(16))) = {1, 2, 0, 0, 0, 0, 0, 0};
	

	float c[M] __attribute__ ((aligned(16)));
	printf("%f\n", dot_product(a, b, M));
	complex_mult (in1, in2, out, N);

	return 0;
}

void print_vector(vector float *v, int length)
{
        int i;
        for (i = 0; i < length; i+=1)
           printf("%.2lf %.2lf %.2lf %.2lf ", v[i][0], v[i][1], v[i][2], v[i][3]);
        printf("\n");
}


float dot_product(float *a, float *b, int n)
{
	float dot_product = 0.0;

	/* create vector arrays for a and b */
	vector float *va = (vector float *) a;	
	vector float *vb = (vector float *) b;	
	vector float vc = (vector float) {0,0,0,0} ;	

	/* multiply the vector arrays */
	int m = M/(16/sizeof(float));
	int i;
	for(i = 0; i < m; i++)
		vc += va[i] * vb[i];
	
	/* compute dot product */

	dot_product = vc[0] + vc[1] + vc[2] + vc[3];

	return dot_product;

}
void complex_mult(float *in1, float *in2, float *out, int n)
{

	/* create vector arrays for in1, in2 and out */

	//vector float *vin1  = (vector float *) in1;	
	//vector float *vain2 = (vector float *) in2;	
	//vector float *vaout = (vector float *) out;	
	
		
	//vector unsigned char pattern1 = (vector unsigned char) {};	
	//vector unsigned char pattern2 = (vector unsigned char) {};	
	//vector unsigned char pattern3 = (vector unsigned char) {};	
	
	int nv = n >> 2; // N/4 -> sizeof (float) = 4,  vector float has 128 bytes
	int i; 
	for (i = 0; i < nv; i+=1){
		/* Shuffle and compute */
			
	}
}



