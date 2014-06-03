CC=gcc

CFLAGS_gcc=-O5
CFLAGS_opt=-march=native -O3 -fprefetch-loop-arrays -frename-registers

NEHALEMLIB="/opt/tools/libraries/atlas/3.10.1-nehalem-gcc-4.4.6/lib/"
NEHALEMINC="/opt/tools/libraries/atlas/3.10.1-nehalem-gcc-4.4.6/include/"

OPTERONLIB="/opt/tools/libraries/atlas/3.10.1-opteron-gcc-4.4.6/lib/"
OPTERONINC="/opt/tools/libraries/atlas/3.10.1-opteron-gcc-4.4.6/include/"

QUADLIB="/opt/tools/libraries/atlas/3.10.1-quad-gcc-4.4.6/lib/"
QUADINC="/opt/tools/libraries/atlas/3.10.1-quad-gcc-4.4.6/include/"

compile1:
	$(CC) -g -o dsymv_nehalem dsymv.c -L $(NEHALEMLIB) -I $(NEHALEMINC) -lcblas -latlas
	$(CC) -g -o optim_nehalem opt_dsymv.c $(CFLAGS_opt) -L $(NEHALEMLIB) -I $(NEHALEMINC) -lcblas -latlas

compile2:
	$(CC) -g -o dsymv_opteron dsymv.c -L $(OPTERONLIB) -I $(OPTERONINC) -lcblas -latlas
	$(CC) -g -o optim_opteron opt_dsymv.c $(CFLAGS_opt) -L $(OPTERONLIB) -I $(OPTERONINC) -lcblas -latlas

compile3:
	$(CC) -g -o dsymv_quad dsymv.c -L $(QUADLIB) -I $(QUADINC) -lcblas -latlas
	$(CC) -g -o optim_quad opt_dsymv.c $(CFLAGS_opt) -L $(QUADLIB) -I $(QUADINC) -lcblas -latlas


run1:
	./dsymv_nehalem
	./optim_nehalem

run2:
	./dsymv_opteron
	./optim_opteron

run3:
	./dsymv_quad
	./optim_quad
clean:
	rm -Rf out dsymv_* optim_*
