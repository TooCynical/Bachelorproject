#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include "combs.h"
#define BITGET(var,pos) !!((var) & (1<<(pos)))

typedef struct {
	int dim;
	
	int n_cols;
	int* cols;
	int* rows;
	
	int n_ext;
	int* ext;

} Simplex;

Simplex *make_simplex(int);
Simplex *copy_simplex(Simplex*);
Simplex *make_tet(int, int, int, int);

int *calc_rows(int, int, int, int);

int check_ultrametric(Simplex*, int);
int check_ultrametric_tet(int, int, int, int);
int popcount(int, int);

void add_vertex(Simplex*, int);
void print_simplex(Simplex *s, int verb);
