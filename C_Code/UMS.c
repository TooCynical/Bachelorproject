#include "simplex.h"
#include "combs.h"

int count = 0;

void extend(Simplex *s) {
	int i,j;

	if ((*s).dim == (*s).n_cols) {
		count ++;
		print_simplex_clean(s);
		free_simplex(s);
		return;
	}

	/* Remove possible extensions that are smaller than the 
	 * last vertex */
	j = 0;
	for (i = 0; i < (*s).n_ext; i++) {
		if ((*s).ext[i] >= (*s).cols[(*s).n_cols - 1]) {
			(*s).ext[j] = (*s).ext[i];
			j++;
		}
	}
	(*s).n_ext = j;

	/* Remove possible extensions that are have too few 
	 * ones in the last vertex */
	j = 0;
	for (i = 0; i < (*s).n_ext; i++) {
		if (__builtin_popcount((*s).ext[i]) >= 
			__builtin_popcount((*s).cols[0])) {
			(*s).ext[j] = (*s).ext[i];
			j++;
		}
	}
	(*s).n_ext = j;

	/* Remove possible extensions that are not ultrametric */ 
	j = 0;
	for (i = 0; i < (*s).n_ext; i++) {
		if (check_ultrametric(s, (*s).ext[i])) {
			(*s).ext[j] = (*s).ext[i];
			j++;
		}
	}
	(*s).n_ext = j;
	
	/* Extend the simplices that keep row order */
	Simplex *temp;
	for (i = 0; i < (*s).n_ext; i++) {
	 	temp = copy_simplex(s);
	 	add_vertex(temp, (*s).ext[i]);
	 	if (check_row_order(temp))
	 		extend(temp);
	 	else
	 		free_simplex(temp);
	 }
	 free_simplex(s);
}


int main() {
	int n, k, i, a, b, c;
	Simplex *t;
	scanf("%d %d\n", &n, &k);

	#pragma omp parallel for
	for (i = 0; i < k; i++) {
		scanf("%d %d %d\n", &a, &b, &c);
		t = make_tet(n, a, b, c);
		extend(t);
	}
	printf("%d\n", count);
}

