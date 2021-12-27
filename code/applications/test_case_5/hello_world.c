#include "scall.h"
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

extern void init_comp_return();

// main in compartment 6 
// foo in compartment 1

void foo(int* a){
	
	printf("INSIDE FOO\n");
	
	// testing for compartment 0
	printf("STARTED TESTING FOR COMPARTMRENT 0\n");
	a[20]=100;
	printf("%d\n",a[20]);
	printf("TESTING COMPLEATED FOR COMPARTMENT 0\n");
	
	// testing for compartment 1
	printf("STARTED TESTING FOR COMPARTMRENT 1\n");
	int * b= (int *) my_alloc(1);
	b[20]=150;
	printf("%d\n",b[20]);
	printf("TESTING COMPLEATED FOR COMPARTMENT 1\n");
	
	//testing for compartment 6
	printf("STARTED TESTING FOR COMPARTMRENT 6\n");
	int * c= (int *) my_alloc(6);
	c[20]=150;
	printf("%d\n",c[20]);
	printf("TESTING COMPLEATED FOR COMPARTMENT 6\n");
	
	//testing for compartment 5
	printf("STARTED TESTING FOR COMPARTMRENT 5\n");
	int * d= (int *) my_alloc(5);
	d[20]=150;
	printf("%d\n",d[20]);
	printf("TESTING COMPLEATED FOR COMPARTMENT 5\n");
	
	printf("Exiting FOO\n");
}	

void main(){
	init_comp_return();
	printf("ENTERING MAIN\n");
	int* a= (int *) my_alloc(0);
	foo(a);
	printf("EXITING MAIN\n");
}


