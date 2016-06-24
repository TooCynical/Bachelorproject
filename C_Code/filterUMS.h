#include <stdio.h>
#include <stdlib.h>
#include <igraph.h>
#include "simplex.h"

igraph_t *associated_graph(Simplex*, int);
igraph_t **associated_graphs(Simplex*);
int check_01equivalent(int n, igraph_t**, igraph_t**);
void filterUMS(int n, int k, Simplex**);
