#ifndef SEMANTIC_CHECK_H
#define SEMANTIC_CHECK_H

void add_variable(const char *name, const char *type);
void check_variable(const char *name);
void initialize_variable(const char *name);

typedef struct {
    char name[50];
    char type[10];
} Variable;

extern Variable symbol_table[100];
extern int symbol_count;

#endif
