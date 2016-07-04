/* 	Lucas Slot - lfh.slot@gmail.com
 *	University of Amsterdam
 *	UMS_nofilter.c
 * 	
 * 	Contains a recursive function that extends 
 *  minimal ultrametric tetraeders to ultrametric
 *  simplices, without prefiltering for 0/1-minimality.
 */

#include "UMS.h"

/* Keeps track of total number of ultrametric simplices
 * outputted */
int count = 0;

/* Recursively add vertices to a non full-dimensional
 * simplex, checking that it remains ultrametric. 
 * Furthermore, check that the simplex satisfies:
 *		- Column order
 *  	- Block property (BP)
 *  	- Shorest remaining edge property (SRE) 
 *
 * Prints full-dimensional ultrametric simplices. */
void extend(Simplex *s) {
	int i,j;


	/* If the simplex is of full dimension,
	 * print it. */
	if ((*s).dim == (*s).n_cols) {
		count ++;
		print_simplex_clean(s);
		free_simplex(s);
		return;
	}

	/* Remove possible vertex extensions that result in a 
	 * simplex that is not ultrametric. */ 
	j = 0;
	for (i = 0; i < (*s).n_ext; i++) {
		if (check_ultrametric(s, (*s).ext[i])) {
			(*s).ext[j] = (*s).ext[i];
			j++;
		}
	}
	(*s).n_ext = j;
	
	/* Extend the simplices that keep row order. */
	Simplex *temp;
	for (i = 0; i < (*s).n_ext; i++) {
	 	temp = copy_simplex(s);
	 	add_vertex(temp, (*s).ext[i]);
 		extend(temp);
	 }
	 /* Free memory. */
	 free_simplex(s);
}

/* Loads minimal representatives of ultrametric
 * tetraeders in the n-cube and extends them to
 * ultrametric simplices such that the minimal
 * reprentative of each ultrametric class is 
 * present. */
int main() {
	int n, k, i, a, b, c;
	Simplex *t;
	scanf("%d %d\n", &n, &k);

	for (i = 0; i < k; i++) {
		scanf("%d %d %d\n", &a, &b, &c);
		t = make_tet(n, a, b, c);
		extend(t);
	}
	printf("%d\n", count);
}
