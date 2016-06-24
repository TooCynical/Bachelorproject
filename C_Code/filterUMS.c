#include "filterUMS.h"

/* Creates the associated bipartite graph for a
 * simplex of FULL dimension using v_k as origin */
igraph_t *associated_graph(Simplex *s, int k) {
	
	/* Create a 2n x 2n all-zeroes matrix. */
	igraph_matrix_t m;
	igraph_matrix_init(&m, 2 * (*s).dim, 2 * (*s).dim);
	igraph_matrix_null(&m);
	
	int vk;
	if (k != -1)
		vk = (*s).cols[k];
	else 
		vk = 0;

	/* Place ones were required */
	int i,j;
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
	igraph_t *g = calloc(1, sizeof(igraph_t));
	igraph_adjacency(g, &m, IGRAPH_ADJ_UNDIRECTED);
	return g;
}

/* Creates the associated bipartite graph for a
 * simplex of FULL dimension for each origin */
igraph_t **associated_graphs(Simplex *s) {
	igraph_t **ss = calloc((*s).dim, sizeof(igraph_t*));
	int i;
	for (i = 0; i < (*s).dim; i++)
		ss[i] = associated_graph(s, i);
	return ss;
}

int check_01equivalent(int n, igraph_t **ss, igraph_t **rr) {
	int i, iso;
	for (i = 0; i < n; i++) {
		igraph_isomorphic(ss[i], rr[0], &iso);
		if (iso)
			return 1;
	}
	return 0;
}

void filterUMS(int n, int k, Simplex **simplices) {
	sort_simplices(k, simplices);
	igraph_t ***o = calloc(k, sizeof(igraph_t**));
	int i, j;
	for (i = 0; i < k; i++) {
		o[i] = associated_graphs(simplices[i]);
		// print_simplex_clean(simplices[i]);
	}
	for (i = 1; i <= k; i++) {
		for (j = 0; j <= k-i; j++) {
			if (j==k-i) {
				printf("GOOD: ");
				print_simplex_clean(simplices[k-i]);
				break;
			}
			if (check_01equivalent(n, o[k-i], o[j])){
				// printf("---\n");
				printf("BAD: ");
				print_simplex_clean(simplices[k-i]);
				// print_simplex_clean(simplices[j]);
				// printf("---\n\n");
				break;
			}
		}
	}
}

int main(void)
{
	// int n = 5;
	// Simplex *t1 = make_tet(n, 3, 5, 14);
	// add_vertex(t1, 22);
	// add_vertex(t1, 25);
	// Simplex *t2 = make_tet(n, 3, 5, 9);
	// add_vertex(t2, 17);
	// add_vertex(t2, 30);
	// Simplex *t3 = make_tet(n, 3, 13, 21);
	// add_vertex(t3, 25);
	// add_vertex(t3, 30);

	// Simplex **simplices = calloc(3, sizeof(Simplex*));
	// simplices[0] = t1;
	// simplices[1] = t3;
	// simplices[2] = t2;
	// int i;
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
	return 0;
}