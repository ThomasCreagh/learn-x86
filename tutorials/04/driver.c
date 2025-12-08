#include <stdio.h>

extern int cmp_char(char a, char b);

int main() {
  char a = 'A';
  char b = 'B';

  int r1 = cmp_char(a, b);
  int r2 = cmp_char(b, a);
  int r3 = cmp_char('C', 'C');

  printf("cmp_char('%c', '%c') = %d\n", a, b, r1);
  printf("cmp_char('%c', '%c') = %d\n", b, a, r2);
  printf("cmp_char('%c', '%c') = %d\n", 'C', 'C', r3);

  return 0;
}
