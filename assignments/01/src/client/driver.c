#include <stdio.h>

extern int start(int argc, char **argv);

int main(int argc, char **argv) {
    printf("calling client _start\n");
    start(argc, argv);
    printf("finished client execution\n");
    return 0;
}
