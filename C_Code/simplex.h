/* 	Lucas Slot - lfh.slot@gmail.com
 *	University of Amsterdam
 *	simplex.h
 * 	
 *  Header file for simplex.c
 */

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
int check_row_order(Simplex*);
int cmp_simplices(Simplex *s, Simplex *t);

void add_vertex(Simplex*, int);
void print_simplex(Simplex*);
void print_simplex_clean(Simplex*);
void sort_simplices(int k, Simplex **simplices);


