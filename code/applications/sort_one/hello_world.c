#include "scall.h"
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

extern void init_comp_return();

int is_sorted(int* a , int n)
{
	printf("ENTERING IS_SORTED\n");
	for(int i=0;i<n-1;i++)
	{
		if(a[i]>a[i+1])
		{
			printf("BAD EXITING IS_SORTED\n");
			return 0;
		}
	}
	printf("EXITING IS_SORTED\n");
	return 1;
}

void sort(int* a , int n)
{
	printf("IN SORT\n");
	for(int i=0;i<n;i++)
	{
		for(int j=0;j<n-1-i;j++)
		{
			if(a[j]>a[j+1])
			{
				int b= a[j];
				a[j] = a[j+1];
				a[j+1] = b;
			}
		}
	}
	printf("EXITING SORT\n");
}

void main(){
	init_comp_return();
	printf("IN MAIN\n");
	int* a= (int *) my_alloc(1);
	for(int i=0;i<1000;i++)
	{
		a[i] = rand();
	}
	sort(a,1000);
	if(is_sorted(a,1000))
	{
		printf("CORRECTLY SORTED\n");
	}
	printf("EXITING MAIN\n");
}


