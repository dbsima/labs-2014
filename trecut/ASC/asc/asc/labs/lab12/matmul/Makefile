# Alex.O, May 6th, 2011
# matrix multiplication example makefile

share:
	/usr/local/cuda/bin/nvcc -o matmul matmul.cu matmul_share.cu
noshare:
	/usr/local/cuda/bin/nvcc -o matmul matmul.cu matmul_noshare.cu
clean:
	rm matmul
