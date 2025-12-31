#include <stdio.h>

extern char starts_with(char * a);

int main() {
  char * a = "Apple";
  char * b = "Ball";

  int r1 = starts_with(a);
  int r2 = starts_with(b);

  printf("starts_with('%s') = %c\n", a, r1);
  printf("starts_with('%s') = %c\n", b, r2);

  return 0;
}
