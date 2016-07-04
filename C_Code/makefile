make:
	gcc UMS.c simplex.c combs.c -lm -o UMS
nofilter:
	gcc UMS_nofilter.c simplex.c combs.c -lm -o UMS_nofilter
filterUMS:
	gcc -I/usr/local/include/igraph -L/usr/local/lib filterUMS.c simplex.c combs.c -lm -ligraph -o filterUMS 
clean:
	rm UMS UMS_nofilter filterUMS
 