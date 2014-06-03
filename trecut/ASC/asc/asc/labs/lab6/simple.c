#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <libspe2.h>
#include <pthread.h>
 
extern spe_program_handle_t simple_spu;
 
#define MAX_SPU_THREADS 16
 
void *ppu_pthread_function(void *arg) {
	spe_context_ptr_t ctx;
	unsigned int entry = SPE_DEFAULT_ENTRY;
	 
	ctx = *((spe_context_ptr_t *)arg);
	if (spe_context_run(ctx, &entry, 0, NULL, NULL, NULL) < 0) {
		perror ("Failed running context");
		exit (1);
	}
	pthread_exit(NULL);
}
 
int main()
{
	int i, spu_threads;
	spe_context_ptr_t ctxs[MAX_SPU_THREADS];
	pthread_t threads[MAX_SPU_THREADS];
	 
	/*
	  * Determine the number of SPE threads to create.
	  */
	 
	spu_threads = spe_cpu_info_get(SPE_COUNT_USABLE_SPES, -1);
	if (spu_threads > MAX_SPU_THREADS) spu_threads = MAX_SPU_THREADS;
	 
	/*
	  * Create several SPE-threads to execute 'simple_spu'.
	  */
	 
	for(i=0; i<spu_threads; i++) {
		/* Create context */
		if ((ctxs[i] = spe_context_create (0, NULL)) == NULL) {
			perror ("Failed creating context");
			exit (1);
		}
	 
		/* Load program into context */
		if (spe_program_load (ctxs[i], &simple_spu)) {
			perror ("Failed loading program");
			exit (1);
		}
		 
		/* Create thread for each SPE context */
		if (pthread_create (&threads[i], NULL, &ppu_pthread_function, &ctxs[i])) {
			perror ("Failed creating thread");
			exit (1);
		}
	}
		 
		/* Wait for SPU-thread to complete execution. */
	for (i=0; i<spu_threads; i++) {
		if (pthread_join (threads[i], NULL)) {
			perror("Failed pthread_join");
			exit (1);
		}
		 
		/* Destroy context */
		if (spe_context_destroy (ctxs[i]) != 0) {
			perror("Failed destroying context");
			exit (1);
		}
	}
	 
	printf("\nThe program has successfully executed.\n");
	return 0;
}


