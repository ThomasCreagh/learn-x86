#include <stdio.h>

extern int add(int a, int b);

int main() {
  int a = 12, b = 30;
  int c = add(a, b);
  printf("Result of %d + %d = %d\n", a, b, c);
  return 0;
}
