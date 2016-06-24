make:
	gcc UMS.c simplex.c combs.c -lm -o UMS
parallel:
	gcc UMS.c simplex.c combs.c -lm -fopenmp -o UMSp
filterUMS:
	gcc -I/usr/local/include/igraph -L/usr/local/lib filterUMS.c simplex.c combs.c -lm -ligraph -o filterUMS 
clean:
	rm UMS UMSp filterUMS filterUMSp
 