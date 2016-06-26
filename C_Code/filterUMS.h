/* 	Lucas Slot - lfh.slot@gmail.com
 *	University of Amsterdam
 *	filterUMS.h
 * 	
 *  Header file for filterUMS.c
 */

#include <stdio.h>
#include <stdlib.h>
#include <igraph.h>
#include "simplex.h"

igraph_t *associated_graph(Simplex*, int);

igraph_t **associated_graphs(Simplex*);

int check_01equivalent(int n, igraph_t**, igraph_t**);

void filterUMS(int n, int k, Simplex**);
void free_associated_graphs(int n, igraph_t **ss);
