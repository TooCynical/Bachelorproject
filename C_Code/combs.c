#include "combs.h"

/* Returns all pairs of {0, 1, ... , n-1} */
int **nchoose2(int n) {
	int n_combs = (n * (n-1)) / 2;
	int **combs = (int**)calloc(n_combs, sizeof(int*));
	int i,j,k;
	int *t;
	j = 0;
	k = 1;
	for (i = 0; i < n_combs; i++) {
		t = calloc(2, sizeof(int));
		t[0] = j; t[1] = k;
		combs[i] = t;
		if (k == n - 1) {
			j++; 
			k = j + 1;
		}
		else 
			k ++;
	}
	return combs; 
}

/* Free int** that contains combinations,
 * given for what n they were calculated. */
void free_combs(int **combs, int n) {
	int n_combs = (n*(n-1)) / 2;
	int i;
	for (i = 0; i < n_combs; i++)
		free(combs[i]);
	free(combs);
}
