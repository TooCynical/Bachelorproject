#include "filterUMS.h"

/* Creates the associated bipartite graph for a
 * simplex of FULL dimension using v_k as origin */
igraph_t *associated_graph(Simplex *s, int k) {
	
	/* Create a 2n x 2n all-zeroes matrix. */
	igraph_matrix_t m;
	igraph_matrix_init(&m, 2 * (*s).dim + 1, 2 * (*s).dim + 1);
	igraph_matrix_null(&m);
	
	int i, j, vk;
	if (k != -1)
		vk = (*s).cols[k];
	else 
		vk = 0;

	int **mat = calloc((*s).dim * 2 + 1, sizeof(int*));
	for (i = 0; i<(*s).dim * 2 + 1; i++)
		mat[i] = calloc((*s).dim * 2 + 1, sizeof(int));

	/* Place ones were required */
	for (i = 0; i < (*s).dim; i++) {
		for (j = 0; j < (*s).dim; j++) {
			/* Check if v_i XOR v_k has a set bit */
			if (j != k) {
				if (BITGET((*s).cols[j]^vk, i)) {
					igraph_matrix_set(&m, i, j + (*s).dim, 1);
					igraph_matrix_set(&m, j + (*s).dim, i, 1);
					mat[i][j + (*s).dim] = 1;
					mat[j + (*s).dim][i] = 1;
				}
			}
			/* Don't XOR the k-th vertex! */
			else {
				if (BITGET((*s).cols[j], i)) {
					igraph_matrix_set(&m, i, j + (*s).dim, 1);
					igraph_matrix_set(&m, j + (*s).dim, i, 1);
					mat[i][j + (*s).dim] = 1;
					mat[j + (*s).dim][i] = 1;
				}
			} 
		}
	}
	/* Places the extra ones needed to ensure biordered isomorphism */
	for (i = 0; i < (*s).dim + 1; i++) {
		igraph_matrix_set(&m, 2 * (*s).dim, (*s).dim + i, 1);
		igraph_matrix_set(&m, (*s).dim + i, 2 * (*s).dim, 1);
		mat[(*s).dim + i][2 * (*s).dim] = 1;
		mat[2 * (*s).dim][(*s).dim + i] = 1;
	}

	// if (k==-1){
	// 	for (i=0; i < 2*(*s).dim + 1; i++) {
	// 		for (j=0; j < 2*(*s).dim + 1; j++) {
	// 			printf("%d ", mat[i][j]);
	// 		}
	// 		printf("\n");
	// 	}
	// printf("\n");
	// }

	igraph_t *g = calloc(1, sizeof(igraph_t));
	igraph_adjacency(g, &m, IGRAPH_ADJ_UNDIRECTED);
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

int check_01equivalent(int n, igraph_t **ss, igraph_t **rr) {
	int i, iso;
	for (i = 0; i < n + 1; i++) {
		igraph_isomorphic(ss[i], rr[0], &iso);
		if (iso) {
			// printf("Found iso for k=%d.\n", i-1);
			return 1;
		}
	}
	return 0;
}

void filterUMS(int n, int k, Simplex **simplices) {
	sort_simplices(k, simplices);
	igraph_t ***o = calloc(k, sizeof(igraph_t**));
	int i, j;
	for (i = 0; i < k; i++) {
		o[i] = associated_graphs(simplices[i]);
	}
	printf("%d\n", n);
	for (i = 1; i <= k; i++) {
		for (j = 0; j <= k-i; j++) {
			if (j==k-i) {
				// printf("MINIMAL    : ");
				print_simplex_clean(simplices[k-i]);
				break;
			}
			if (check_01equivalent(n, o[k-i], o[j])){
				// printf("NOT MINIMAL: ");
				// print_simplex(simplices[k-i]);
				// printf("           : ");
				// print_simplex(simplices[j]);
				break;
			}
		}
	}
}

int main(void) {
	int a, b, c, d, i, j, k, n;
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
	filterUMS(n, k, simplices);

	// Simplex *test = make_tet(6, 3, 5, 14);
	// add_vertex(test, 22);
	// add_vertex(test, 38);
	// add_vertex(test, 57);
	// associated_graphs(test);

	// Simplex *test2 = make_tet(6, 3, 5, 9);
	// add_vertex(test2, 30);
	// add_vertex(test2, 46);
	// add_vertex(test2, 39);
	// associated_graphs(test2);

	return 0;
}