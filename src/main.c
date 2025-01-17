#include <stdio.h>
#include <stdlib.h>
#include "code_gen.h"

extern FILE *yyin;

int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "usage: %s <source file>\n", argv[0]);
        return 1;
    }

    yyin = fopen(argv[1], "r");
    if (!yyin) {
        perror("failed to open file");
        return 1;
    }

    init_code_generator("home/output.c");
    yyparse();
    close_code_generator();
    fclose(yyin);

    printf("compilation successful: home/output.c generated\n");
    return 0;
}
