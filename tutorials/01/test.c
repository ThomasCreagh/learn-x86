#include <stdio.h>

extern int g;
extern int add_g(int x);
extern int min(int a,int b,int c);

int g = 4; // also defined in C to satisfy the linker
int main() {
	printf("add_g(10) = %d\n", add_g(10));
	printf("min(7,5,9) = %d\n", min(7,5,9));
	return 0;
}

