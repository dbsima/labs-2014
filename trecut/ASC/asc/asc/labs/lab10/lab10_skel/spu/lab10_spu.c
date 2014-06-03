#include <stdio.h>

typedef struct {
	int x, y;
} coord_t;

#define CACHE_NAME my_cache
#define CACHED_TYPE coord_t
#define CACHE_TYPE         CACHE_TYPE_RW /* acces de scriere si citire */

#include <cache-api.h>

int main(unsigned long long speid, unsigned long long argp, unsigned long long envp)
{
	speid = speid;			// silence warning
	coord_t* v = (coord_t*)(uint32_t)argp; // adresa de start a labirintului
	int M = (int)envp;		// dimensiunea unei linii din labirint

	//TODO implementati cautarea comorii folosind software cache
	int count = 0;
	coord_t bingo;
	while(1)
	{
		bingo = *v;
		*v = cache_rd(my_cache, v + v->x*M + v->y);
		
		if (v->x == 0 && v->y == 0)
			break;
	}
	cache_wr(my_cache, (coord_t*)(uint32_t) argp, bingo);	
	cache_flush(my_cache);

	return 0;
}

