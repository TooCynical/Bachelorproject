make:
	gcc UMS.c simplex.c combs.c -lm -o UMS
parallel:
	gcc UMS.c simplex.c combs.c -lm -fopenmp -o UMSp
graph:
	gcc -I/usr/local/include/igraph -L/usr/local/lib filterUMS.c simplex.c combs.c -lm -ligraph -o graph 
clean:
	rm UMS UMSp graph
 