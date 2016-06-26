/* 	Lucas Slot - lfh.slot@gmail.com
 *	University of Amsterdam
 *	filterUMS.c
 * 	
 * 	Contains functionality to filter a set of 
 *  ultrametric simplices so that only minimal
 *  representatives remain, assuming they are
 *  present to start with. Makes use of graph 
 *  ismorphism to determine 0/1-equivalence.
 */

#include "filterUMS.h"

/* Creates the associated bipartite graph for a
 * simplex of FULL dimension using v_k as origin. */
igraph_t *associated_graph(Simplex *s, int k) {
	int i, j, vk;
	
	/* Create a 2nx2n all-zeroes matrix which will 
	 * become the adjacency matrix. */
	igraph_matrix_t m;
	igraph_matrix_init(&m, 2 * (*s).dim + 1, 2 * (*s).dim + 1);
	igraph_matrix_null(&m);
	
	if (k != -1)
		vk = (*s).cols[k];
	else 
		vk = 0;

	/* Place ones were required */
	for (i = 0; i < (*s).dim; i++) {
		for (j = 0; j < (*s).dim; j++) {
			/* Check if v_i XOR v_k has a set bit */
			if (j != k) {
				if (BITGET((*s).cols[j]^vk, i)) {
					igraph_matrix_set(&m, i, j + (*s).dim, 1);
					igraph_matrix_set(&m, j + (*s).dim, i, 1);
				}
			}
			/* Don't XOR the k-th vertex! */
			else {
				if (BITGET((*s).cols[j], i)) {
					igraph_matrix_set(&m, i, j + (*s).dim, 1);
					igraph_matrix_set(&m, j + (*s).dim, i, 1);
				}
			} 
		}
	}

	/* Places the extra ones needed to ensure biordered isomorphism */
	for (i = 0; i < (*s).dim + 1; i++) {
		igraph_matrix_set(&m, 2 * (*s).dim, (*s).dim + i, 1);
		igraph_matrix_set(&m, (*s).dim + i, 2 * (*s).dim, 1);
	}

	/* Create the graph from the adjaceny matrix. */
	igraph_t *g = calloc(1, sizeof(igraph_t));
	igraph_adjacency(g, &m, IGRAPH_ADJ_UNDIRECTED);

	/* Finally free memory */
	igraph_matrix_destroy(&m);
	// free(&m);

	return g;
}


/* Creates the associated bipartite graph for a
 * simplex of FULL dimension for each origin,
 * for a total of (*s).dim + 1 graphs. */
igraph_t **associated_graphs(Simplex *s) {
	igraph_t **ss = calloc((*s).dim + 1, sizeof(igraph_t*));
	int i;
	for (i = 0; i < (*s).dim + 1; i++)
		ss[i] = associated_graph(s, i-1);
	return ss;
}

/* Free up the n + 1 graphs associated to a simplex. */
void free_associated_graphs(int n, igraph_t **ss) {
	int i;
	for (i = 0; i < n + 1; i++) {
		igraph_destroy(ss[i]);
		free(ss[i]);
	}
	free(ss);
}

/* Check whether any of the associated graphs for two simplices 
 * are ismorphic. */
int check_01equivalent(int n, igraph_t **ss, igraph_t **rr) {
	int i, iso;
	for (i = 0; i < n + 1; i++) {
		igraph_isomorphic(ss[i], rr[0], &iso);
		if (iso)
			return 1;
	}
	return 0;
}

/* Prints all minimal simplices given a set of k many 
 * n-simplices, assuming that a minimal representative
 * of each class present in this set is also present in
 * the set. Makes use of the graph isomorphism method
 * to determine 0/1-equivalence. */
void filterUMS(int n, int k, Simplex **simplices) {
	int i, j;
	printf("%d\n", n);

	/* Sort the simplices, and then find the 
	 * associated graphs for each of them. */
	sort_simplices(k, simplices);
	igraph_t ***o = calloc(k, sizeof(igraph_t**));
	for (i = 0; i < k; i++)
		o[i] = associated_graphs(simplices[i]);

	/* For each simplex, check if it is 0/1-equivalent
	 * to a smaller one. If not: print it. */
	for (i = 1; i <= k; i++) {
		for (j = 0; j <= k-i; j++) {
			if (j==k-i) {
				print_simplex_clean(simplices[k-i]);
				break;
			}
			if (check_01equivalent(n, o[k-i], o[j]))
				break;
		}
	}

	/* Finally clear up the memory */
	for (i = 0; i < k; i++)
		free_associated_graphs(n, o[i]);
	free(o);
}

/* Reads simplices from an input file and prints
 * those that are minimal with respect to 0/1-equivalence. */
int main(void) {
	int a, b, c, d, i, j, k, n;

	/* Read simplices from input file. */
	scanf("%d %d\n", &n, &k);
	Simplex **simplices = calloc(k, sizeof(Simplex*));
	for (i = 0; i < k; i++) {
		scanf("%d %d %d ", &a, &b, &c);
		simplices[i] = make_tet(n, a, b, c);
		for (j = 3; j < n; j++) {
			scanf("%d ", &d);
			add_vertex(simplices[i], d);
		}
	}

	/* Filter these simplices. */
	filterUMS(n, k, simplices);

	/* Free memory */
	for (i = 0; i < k; i++)
		free_simplex(simplices[i]);
	free(simplices);
	return 0;
}