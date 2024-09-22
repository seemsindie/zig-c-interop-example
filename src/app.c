#include "lib.h"
#include <stdio.h>

extern int zig_function(int);

int main() {
  printf("C app: calling C library function: %d\n", c_function(5));
  printf("C app: calling Zig library function: %d\n", zig_function(5));
  return 0;
}
