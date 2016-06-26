/* 	Lucas Slot - lfh.slot@gmail.com
 *	University of Amsterdam
 *	combs.c
 * 	
 * 	Contains combinatorial functionality required to
 *  generated and filter ultrametric simplices. 
 *  Specifically the following is implemented:
 *		nchoose2(n) : returns all combinations of 
 *					  elements of {1, 2, ..., n}.
 *		fac(n)		: returns n! for 0 <= n < 17.
 * 		ehrlich(n)  : returns a table of swaps that
 *					  when performed in order generate
 *                    all the permutations of the set
 *					  {1, 2, ..., n}.
 */

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

/* Calculate n! for 0 < n < 17. */
int fac(int n) {
	if (n > 16 || n < 0)
		return -1;

	int i, k;
	k = 1;
	for (i = 0; i < n; i++)
		k *= n;
	return k;
}

/* Compute ehrlich sequence of length n!, 
 * following Even's algorithm. */
int *ehrlich(int n) {
	int k, i, temp, dir, max, max_i;
	k = fac(n);

	/* Set the initial table */
	int **table = calloc(n, sizeof(int*));
	for (i = 0; i < n; i++) {
		table[i] = calloc(2, sizeof(int));
		table[i][0] = i; table[i][1] = -1;
	}
	table[0][1] = 0; 

	/* Find largest element with nonzero direction and
	 * swap it in the indicated direction. */
	max = n + 1;
	for (i = 0; i < n; i++) {
		if (table[0][i] > max && table[1][i]) {
			max = table[0][i];
			max_i = i;
		}
	}
	dir = table[1][i];
	temp = table[0][i];
	table[0][i] = table[0][i + dir];
	table[0][i + dir] = temp;
	
	/* Change direction of swapped element */
	if (i + dir == 0 || i + dir == n - 1)
		i;
}