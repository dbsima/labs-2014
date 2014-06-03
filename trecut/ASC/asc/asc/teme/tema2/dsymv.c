#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/time.h>  

#include "cblas.h"

#define max(a,b) ((a) >= (b) ? (a) : (b))

int dsymv_(char *uplo, long int *n, double *alpha, double *a, 
			long int *lda, double *x, long int *incx, double 
			*beta, double *y, long int *incy)
{
    long int a_dim1, a_offset, i__1, i__2;

    static long int info;
    static double temp1, temp2;
    static long int i, j;
    static long int ix, iy, jx, jy, kx, ky;

/*
    DSYMV  performs the matrix-vector  operation   

       y := alpha*A*x + beta*y,   

    where alpha and beta are scalars, x and y are n element vectors and   
    A is an n by n symmetric matrix.   


	UPLO = 'U' or 'u'   Only the upper triangular part of A is to be referenced.   
       	UPLO = 'L' or 'l'   Only the lower triangular part of A is to be referenced.   

	N specifies the order of the matrix A (N must be at least zero)   

	ALPHA specifies the scalar alpha.   

    	A - array of DIMENSION LDA*n ).   
             Before entry with  UPLO = 'U' or 'u', the leading n by n   
             upper triangular part of the array A must contain the upper 
             triangular part of the symmetric matrix and the strictly   
             lower triangular part of A is not referenced.   
             
		Before entry with UPLO = 'L' or 'l', the leading n by n   
             lower triangular part of the array A must contain the lower 
             triangular part of the symmetric matrix and the strictly   
             upper triangular part of A is not referenced.   

   	LDA - the first dimension of A (LDA must be at least max( 1, n ))

    	X - array of dimension at least (1 + (n - 1)*abs(INCX))
    
	INCX - the increment for the elements of X (INCX must not be zero)   

   	BETA - the scalar beta (when BETA is supplied as zero then Y need not be set on input)   

    	Y - array of dimension at least (1 + (n - 1)*abs(INCY)).   

        INCY the increment for the elements of Y (INCY must not be zero)   
*/

#define X(I) x[(I)-1]
#define Y(I) y[(I)-1]

#define A(I,J) a[(I)-1 + ((J)-1)* ( *lda)]
	/* checking if the passing params are correct */
    info = 0;
    if ((*uplo != 'U') && (*uplo != 'L')) {
	info = 1;
    } else if (*n < 0) {
	info = 2;
    } else if (*lda < max(1,*n)) {
	info = 5;
    } else if (*incx == 0) {
	info = 7;
    } else if (*incy == 0) {
	info = 10;
    }
    if (info != 0) {
    	printf("** On entry to DSYMV, parameter number %2ld had an illegal value\n", info);
	return 0;
    }

	/* Quick return if possible. */

    if (*n == 0 || *alpha == 0. && *beta == 1.) {
	return 0;
    }

	/* Set up the start points in  X  and  Y. */

    if (*incx > 0) {
	kx = 1;
    } else {
	kx = 1 - (*n - 1) * *incx;
    }
    if (*incy > 0) {
	ky = 1;
    } else {
	ky = 1 - (*n - 1) * *incy;
    }

/*     Start the operations. In this version the elements of A are   
       accessed sequentially with one pass through the triangular part   
       of A.   

       First form  y := beta*y. */

    if (*beta != 1.) {
	if (*incy == 1) {
	    if (*beta == 0.) {
		i__1 = *n;
		for (i = 1; i <= *n; ++i) {
		    Y(i) = 0.;
/* L10: */
		}
	    } else {
		i__1 = *n;
		for (i = 1; i <= *n; ++i) {
		    Y(i) = *beta * Y(i);
/* L20: */
		}
	    }
	} else {
	    iy = ky;
	    if (*beta == 0.) {
		i__1 = *n;
		for (i = 1; i <= *n; ++i) {
		    Y(iy) = 0.;
		    iy += *incy;
/* L30: */
		}
	    } else {
		i__1 = *n;
		for (i = 1; i <= *n; ++i) {
		    Y(iy) = *beta * Y(iy);
		    iy += *incy;
/* L40: */
		}
	    }
	}
    }
    if (*alpha == 0.) {
	return 0;
    }
    if (*uplo == 'U') {

/*        Form  y  when A is stored in upper triangle. */

	if (*incx == 1 && *incy == 1) {
	    i__1 = *n;
	    for (j = 1; j <= *n; ++j) {
		temp1 = *alpha * X(j);
		temp2 = 0.;
		i__2 = j - 1;
		for (i = 1; i <= j-1; ++i) {
		    Y(i) += temp1 * A(i,j);
		    temp2 += A(i,j) * X(i);
/* L50: */
		}
		Y(j) = Y(j) + temp1 * A(j,j) + *alpha * temp2;
/* L60: */
	    }
	} else {
	    jx = kx;
	    jy = ky;
	    i__1 = *n;
	    for (j = 1; j <= *n; ++j) {
		temp1 = *alpha * X(jx);
		temp2 = 0.;
		ix = kx;
		iy = ky;
		i__2 = j - 1;
		for (i = 1; i <= j-1; ++i) {
		    Y(iy) += temp1 * A(i,j);
		    temp2 += A(i,j) * X(ix);
		    ix += *incx;
		    iy += *incy;
/* L70: */
		}
		Y(jy) = Y(jy) + temp1 * A(j,j) + *alpha * temp2;
		jx += *incx;
		jy += *incy;
/* L80: */
	    }
	}
    } else {

/*        Form  y  when A is stored in lower triangle. */

	if (*incx == 1 && *incy == 1) {
	    i__1 = *n;
	    for (j = 1; j <= *n; ++j) {
		temp1 = *alpha * X(j);
		temp2 = 0.;
		Y(j) += temp1 * A(j,j);
		i__2 = *n;
		for (i = j + 1; i <= *n; ++i) {
		    Y(i) += temp1 * A(i,j);
		    temp2 += A(i,j) * X(i);
/* L90: */
		}
		Y(j) += *alpha * temp2;
/* L100: */
	    }
	} else {
	    jx = kx;
	    jy = ky;
	    i__1 = *n;
	    for (j = 1; j <= *n; ++j) {
		temp1 = *alpha * X(jx);
		temp2 = 0.;
		Y(jy) += temp1 * A(j,j);
		ix = jx;
		iy = jy;
		i__2 = *n;
		for (i = j + 1; i <= *n; ++i) {
		    ix += *incx;
		    iy += *incy;
		    Y(iy) += temp1 * A(i,j);
		    temp2 += A(i,j) * X(ix);
/* L110: */
		}
		Y(jy) += *alpha * temp2;
		jx += *incx;
		jy += *incy;
/* L120: */
	    }
	}
    }
    return 0;
}

int main()
{	
	/* the order of the matrix A */
	long int n = 17000;

	/* the first dimension of A */
	long int lda = max(n, 1);

  	int i, j;

	/* double symmetric array of dimension lda*n */
	double **A = (double**) malloc (n * sizeof(double*));

	for (i = 0; i < n; i++)
        	A[i] = (double*) malloc(n * sizeof(double));
	
	/* array of dimension n */
	double *X = (double*) malloc(n * sizeof(double));
	
	/* array of dimension n */
	double *Y = (double*) malloc(n * sizeof(double));
	
	/* copy of the Y array */
	double *Y_cpy = (double*) malloc(n * sizeof(double));
	
	/* for each array (X, Y, A) generate random values */
	for (i = 0; i < n; i++) 
	{
		X[i] = (double) rand() / RAND_MAX; 
		Y[i] = (double) rand() / RAND_MAX; 

		/* copy the values of Y in a copy array */
		Y_cpy[i] = Y[i];

		/* A must be symmetric */
	    	for (j = 0; j < n; j++)
	        	A[i][j] = A[j][i] = (double) rand() / RAND_MAX; 
	}
	
	/* copy the values of the double array A in an array */
	double *a = (double*) malloc(n*n * sizeof(double));
	int k = 0;
	for (i = 0; i < n; i++)
		for (j = 0; j < n; j++)
			a[k++] = A[i][j];
	
	/* the scalars */
	double alpha = 656, beta = 123 ;
	
	/* the increments */
	long int incy = 1, incx = 1;

	/* upper triangle */
	char *upper = "U";
	
	struct timeval t1, t2;
    	double elapsedTime;
	
	/* compute time for dsymv */
	gettimeofday(&t1, NULL);

	dsymv_(upper, &n, &alpha, a, &lda, X, &incx, &beta, Y, &incy);

	gettimeofday(&t2, NULL);
	
	/* the elapsed time after the function was called */
	elapsedTime = (t2.tv_sec - t1.tv_sec);
    	elapsedTime += (t2.tv_usec - t1.tv_usec) / 1000.0 / 1000.0;   // us to s	

	printf("%lf %lf - %lf\n", Y[0], Y[n-1], elapsedTime);

	/* compute time for cblas_dsymv */
	gettimeofday(&t1, NULL);

	cblas_dsymv(CblasRowMajor, CblasUpper, n, alpha, a, lda, X, incx, beta, Y_cpy, incy);

	gettimeofday(&t2, NULL);

	/* the elapsed time after the function was called */
	elapsedTime = (t2.tv_sec - t1.tv_sec);   
    	elapsedTime += (t2.tv_usec - t1.tv_usec) / 1000.0 / 1000.0;   // us to s	

	printf("%lf %lf - %lf\n", Y_cpy[0], Y_cpy[n-1], elapsedTime);
	
	/* Free memory */
	free(Y);
	free(X);
	free(a);
	for (i = 0; i < n; i++)
		free(A[i]);
	free(A);
	
	return 0;
}

