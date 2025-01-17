#include "error_handling.h"
#include <stdio.h>
#include <stdlib.h>

// affiche erreur syntaxique
void syntax_error(const char *msg, int line) {
    fprintf(stderr, "syntax error at line %d: %s\n", line, msg);
    exit(1);
}

// affiche erreur sémantique
void semantic_error(const char *msg) {
    fprintf(stderr, "semantic error: %s\n", msg);
    exit(1);
}

// afficher erreur de base
void general_error(const char *msg) {
    fprintf(stderr, "error: %s\n", msg);
    exit(1);
}
