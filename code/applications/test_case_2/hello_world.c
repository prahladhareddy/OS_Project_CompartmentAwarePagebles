#include "scall.h"
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

extern void init_comp_return();

// main in compartment 1

void main(){
	printf("ENTERING MAIN\n");
	init_comp_return();
	
	// testing for compartment 0
	printf("STARTED TESTING FOR CMPARTMENT 0\n");
	int* a= (int *) my_alloc(0);
	a[44] = 100;
	a[66] = 110;
	a[11] = a[44] + a[66];
	printf("a[11] = %d\n", a[11]);
	printf("COMPLEATED TESTING FOR COMPARTMENT 0\n");
	
	// testing for compartment 1
	printf("STARTED TESTING FOR CMPARTMENT 1\n");
	int* b= (int *) my_alloc(1);
	b[44] = 100;
	b[66] = 110;
	b[11] = b[44] + b[66];
	printf("b[11] = %d\n", b[11]);
	printf("COMPLEATED TESTING FOR COMPARTMENT 1\n");
	
	// testing for compartment 5
	printf("STARTED TESTING FOR CMPARTMENT 5\n");
	int* c= (int *) my_alloc(5);
	c[44] = 100;
	c[66] = 110;
	c[11] = c[44] + c[66];
	printf("b[11] = %d\n", c[11]);
	printf("COMPLEATED TESTING FOR COMPARTMENT 5\n");
	
	printf("EXITING MAIN\n");
}


