#include <stdio.h>
#include <stdlib.h>
#include <math.h>

__global__ void MatAdd(float* A, float* B, float* C)
{
int i = blockIdx.x * blockDim.x + threadIdx.x;
int j = blockIdx.y * blockDim.y + threadIdx.y;
 
if (i < N && j < N)
C[i*N+j] = A[i*N+j] + B[i*N+j];
}
 
int main()
{
 
float a[N*N], b[N*N], c[N*N]; // host matrices
float *A, *B, *C;	// device matrices
	int i,j;
	for (i = 0; i < N; i++ )
	cudaMalloc( (void**) &A, N *N); 
 	cudaMemcpy( A, a, N*N, cudaMemcpyHostToDevice);

	cudaMalloc( (void**) &B, N *N); 
        cudaMemcpy( B, b, N*N, cudaMemcpyHostToDevice);

	cudaMalloc( (void**) &C, N * N)); 

// Kernel invocation
dim3 dimBlock(BLK, BLK);
dim3 dimGrid((N + dimBlock.x - 1) / dimBlock.x, (N + dimBlock.y - 1) / dimBlock.y);
MatAdd<<<dimGrid, dimBlock>>>(A, B, C);
 cudaMemcpy( c, C, N*N, cudaMemcpyDeviceToHost);
}
