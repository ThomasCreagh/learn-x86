#include <stdio.h>

extern int g;
extern int add_g(int x);

int g = 4;

int main() {
	printf("add_g(10) = %d\n", add_g(10));
	return 0;
}
