#include "simplex.h"

/* Basic initializer for a simplex. */
Simplex *make_simplex(int n) {
	Simplex *s = (Simplex*)calloc(1, sizeof(Simplex));
	
	(*s).dim = n;
	(*s).n_cols = 0;
	(*s).n_ext = 0;
	
	(*s).cols = (int*)calloc(n, sizeof(int));
	(*s).rows = NULL;
	(*s).ext = NULL;
	
	return s;
}

Simplex *copy_simplex(Simplex *s) {
	Simplex *r = (Simplex*)calloc(1, sizeof(Simplex));
	(*r).dim = (*s).dim;
	(*r).n_cols = (*s).n_cols;
	(*r).n_ext = (*s).n_ext;
	(*r).cols = (int*)calloc((*s).dim, sizeof(int));
	(*r).rows = (int*)calloc((*s).dim, sizeof(int));
	(*r).ext = (int*)calloc((*s).n_ext, sizeof(int));
	
	memcpy((*r).cols, (*s).cols, (*s).n_cols * sizeof(int));
	memcpy((*r).rows, (*s).rows, (*s).dim * sizeof(int));
	memcpy((*r).ext, (*s).ext, (*s).n_ext * sizeof(int));
	
	return r;
}

/* Returns s <= t, based on lexicographical ordering
 * of the columns. */
int cmp_simplices(Simplex *s, Simplex *t) {
	int i;	
	for (i = 0; i < (*s).n_cols; i++) {
		if ((*s).cols[i] < (*t).cols[i])
			return 1;
		if ((*s).cols[i] > (*t).cols[i])
			return 0;
	}
	return 1;
}

/* Sort an array of k simplices in ascending order, based
 * on lexicographical ordering of the columns. This uses 
 * bubble sort (O(n^2)) which is not optimal but good enough. */
void sort_simplices(int k, Simplex **simplices) {
	Simplex *temp;
	int i, j;
	for (i = 0; i < k; i++) {
		for (j = 1; j < k-i; j++) {
			if (cmp_simplices(simplices[j], simplices[j-1])) {
				temp = simplices[j];
				simplices[j] = simplices[j-1];
				simplices[j-1] = temp;
			}
		}
	}
}

/* Calculate the integer representations of the rows 
 * of a tetraeder. */
int *calc_rows(int n, int c1, int c2, int c3) {
	int* rows = (int*)calloc(n, sizeof(int));
	int i;
	for (i = 0; i < n; i++) {
		rows[i] = 4 * BITGET(c1, i) + 
				  2 * BITGET(c2, i) + 
				  1 * BITGET(c3, i);
	}
	return rows;
}

int check_row_order(Simplex *s) {
	int i;
	for (i = 0; i < (*s).dim - 1; i++){
		if ((*s).rows[i] < (*s).rows[i + 1]) {
			return 0;
		}
	}
	return 1;
}

void add_vertex(Simplex *s, int v) {
	(*s).cols[(*s).n_cols] = v;
	(*s).n_cols ++;
	int i;
	for (i = 0; i < (*s).dim; i++) {
		(*s).rows[i] = 2 * ((*s).rows[i]) + BITGET(v, i);
	}
}

/* Create a nx3 simplex (a tetraeder) given the integer
 * representations of its columns. */
Simplex *make_tet(int n, int c1, int c2, int c3) {
	Simplex *s = make_simplex(n);
	(*s).n_cols = 3;
	(*s).cols[0] = c1;
	(*s).cols[1] = c2;
	(*s).cols[2] = c3;
	(*s).rows = calc_rows((*s).dim, c1, c2, c3);

	/* Set possible extensions */
	(*s).n_ext = (int) pow(2.0, (*s).dim);
	(*s).ext = (int*)calloc((*s).n_ext, sizeof(int));
	int i;
	for (i = 0; i < (*s).n_ext; i ++) {
		(*s).ext[i] = i;
	}

	return s;
}

void print_simplex_clean(Simplex *s) {
	int i;
	for(i = 0; i < (*s).n_cols; i++) {
		if (i < (*s).n_cols - 1)
			printf("%d ", (*s).cols[i]);
		else
			printf("%d", (*s).cols[i]);
	}
	printf("\n");
}

/* Print the integer representations of the 
 * columns and rows of a simplex */
void print_simplex(Simplex *s) {
	int i;
	printf("[");
	for(i = 0; i < (*s).n_cols; i++) {
		if (i < (*s).n_cols - 1)
			printf("%d ", (*s).cols[i]);
		else
			printf("%d", (*s).cols[i]);
	}
	printf("] [");
	for(i = 0; i < (*s).dim; i++) {
		if (i < (*s).dim - 1)
			printf("%d ", (*s).rows[i]);
		else
			printf("%d", (*s).rows[i]);
	}
	printf("] ");
	printf("(%d:%d)", (*s).n_cols, (*s).dim);
	printf(" - %d exts.", (*s).n_ext);
	printf("\n");
}

void free_simplex(Simplex *s) {
	free((*s).cols);
	free((*s).rows);
	free((*s).ext);
	free(s);
}

/* Returns whether the n-tetraeder given by 
* v1, v2, v3 is ultrametric */
int check_ultrametric_tet(int n, int v1, int v2, int v3) {
	int g11, g12, g13, g22, g23, g33, i;
	int b1, b2, b3;
	g11 = g12 = g13 = g22 = g23 = g33 = 0;
	/* Calculate the Gramian. */
	for (i = 0; i < n; i++) {
		b1 = BITGET(v1, i);
		b2 = BITGET(v2, i);
		b3 = BITGET(v3, i);

		if (b1)
			g11 ++;
		if (b2)
			g22 ++;
		if (b3)
			g33 ++;
		if (b1 && b2)
			g12 ++;
		if (b1 && b3)
			g13 ++;
		if (b2 && b3)
			g23 ++;
	}
	// printf("%d %d %d\n- %d %d\n- - %d\n\n", g11, g12, g13, g22, g23, g33);
	
	/* Check maximality of diagonal elements */
	if (g11 <= g12 || g11 <= g13)
		return 0;
	if (g22 <= g12 || g22 <= g23)
		return 0;
	if (g33 <= g13 || g33 <= g23)
		return 0;

	/* Check non-unique minimum */
	if ((g12 < g13 && g12 < g23) ||
        (g13 < g12 && g13 < g23) ||
        (g23 < g12 && g23 < g13))
        return 0;

    /* If everything is fine, return 1 */
	return 1;
}

/* Returns whether s* + v3 is an ultrametric simplex,
 * assuming that s* is. */
int check_ultrametric(Simplex *s, int v3) {

	int n = (*s).n_cols;
	
	int **combs = nchoose2(n);
	int v1, v2, i;
	
	/* Check that all tetraeders containing the
	 * last vertex of s are ultrametric */
	for (i = 0; i < (n * (n - 1)) / 2; i++) {
		v1 = (*s).cols[combs[i][0]];
		v2 = (*s).cols[combs[i][1]];
		// printf("%d, %d, %d\n", v1,v2,v3);
		if (!check_ultrametric_tet((*s).dim, v1, v2, v3)) {
			free_combs(combs, n);
			return 0;
		}
			
	}

	/* If everything is fine, return 1 */
	free_combs(combs, n);
	return 1;
}