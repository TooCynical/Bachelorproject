#include "simplex.h"
#include "combs.h"


void extend(Simplex *s) {
	int i,j;
	// printf("Extending: ");
	// print_simplex(s);

	if ((*s).dim == (*s).n_cols) {
		print_simplex(s, 0);
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

	/* Extend the good new simplices */
	Simplex *temp;
	for (i = 0; i < (*s).n_ext; i++) {
	 	temp = copy_simplex(s);
	 	add_vertex(temp, (*s).ext[i]);
	 	extend(temp);
	 }		
}

int main() {
	int n, k, i, a, b, c;
	Simplex *t;
	scanf("%d %d\n", &n, &k);

	for (i = 0; i < k; i++) {
		scanf("%d %d %d\n", &a, &b, &c);
		t = make_tet(n, a, b, c);
		extend(t);
	}


	// Simplex *test = make_tet(n, 3, 5, 6);
	//Simplex *copy = copy_simplex(test);

	// print_simplex(test);
	// print_simplex(copy);
	//printf("%d\n", __builtin_popcount(n));
	// extend(test);
	// printf("%d\n", check_ultrametric(test, 8));
}

