#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <libspe2.h>
#include <pthread.h>
 
#define MAX_THREADS 8
 
void *ppu_pthread_function(void *arg) {
	printf("Hello world! from PPU thread %d\n", (int)arg);
	pthread_exit(NULL);
}
 
int main()
{
	int i;
	pthread_t threads[MAX_THREADS];
	 
	for(i=0; i<MAX_THREADS; i++) {
		 
		/* Create thread for each SPE context */
		if (pthread_create (&threads[i], NULL, &ppu_pthread_function, i)) {
			perror ("Failed creating thread");
			exit (1);
		}
	}
	
	for(i=0; i<MAX_THREADS; i++) {
		 
		if (pthread_join(threads[i],NULL))
			perror ("Failed creating thread");
			exit (1);
	}
		 
	 
	printf("\nThe program has successfully executed.\n");
	return 0;
}


