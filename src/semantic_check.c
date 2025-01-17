#include "semantic_check.h"
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

Variable symbol_table[100];
int symbol_count = 0;

void add_variable(const char *name, const char *type) {
    for (int i = 0; i < symbol_count; i++) {
        if (strcmp(symbol_table[i].name, name) == 0) {
            fprintf(stderr, "error: variable '%s' already declared\n", name);
            exit(1);
        }
    }
    strcpy(symbol_table[symbol_count].name, name);
    strcpy(symbol_table[symbol_count].type, type);
    symbol_count++;
}

void check_variable(const char *name) {
    for (int i = 0; i < symbol_count; i++) {
        if (strcmp(symbol_table[i].name, name) == 0) {
            return; // la variable est valide
        }
    }
    fprintf(stderr, "error: variable '%s' not declared\n", name);
    exit(1);
}