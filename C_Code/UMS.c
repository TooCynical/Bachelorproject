#include "simplex.h"
#include "combs.h"


void extend(Simplex *s) {
	int i;
	int j = 0;

	printf("Extending: ");
	print_simplex(s);

	if ((*s).dim == (*s).n_cols)
		return;

	/* Remove possible extensions that are smaller than the 
	 * last vertex */
	for (i = 0; i < (*s).n_ext; i++) {
		if ((*s).ext[i] >= (*s).cols[(*s).n_cols - 1]) {
			(*s).ext[j] = (*s).ext[i];
			j++;
		}
	}
	(*s).n_ext = j;

	/* Extend the good new simplices */
	for (i = 0; i < (*s).n_ext; i++)
		i;
	Simplex *temp;
	for (i = 0; i < (*s).n_ext; i++) {
	 	temp = copy_simplex(s);
	 	add_vertex(temp, (*s).ext[i]);
	 	extend(temp);
	 }		
}

int main() {
	Simplex *test = make_tet(4, 1, 2, 3);
	add_vertex(test, 4);
	Simplex *copy = copy_simplex(test);

	// print_simplex(test);
	// print_simplex(copy);

	// extend(test);
	check_ultrametric(test);
}

