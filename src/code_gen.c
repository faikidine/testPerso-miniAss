#include "code_gen.h"
#include "semantic_check.h"
#include <stdio.h>
#include <stdlib.h>

FILE *output_file; // fichier de sortie

// initialisation codeGen
void init_code_generator(const char *filename) {
    output_file = fopen(filename, "w"); // ouvrir le fichier de sortie
    if (!output_file) {
        perror("failed to open output file");
        exit(1);
    }
    fprintf(output_file, "#include <stdio.h>\n");
    fprintf(output_file, "int main() {\n");
    declare_variables(); // déclarer les variables au début
}

// déclarer les variables collectées dans la table des symboles
void declare_variables(void) {
    for (int i = 0; i < symbol_count; i++) {
        fprintf(output_file, "    int %s;\n", symbol_table[i].name); // toutes les variables sont des int
    }
}

// instructions générées
void generate_mov(const char *dest, const char *src) {
    fprintf(output_file, "    %s = %s;\n", dest, src);
}

void generate_add(const char *dest, const char *src) {
    fprintf(output_file, "    %s += %s;\n", dest, src);
}

void generate_sub(const char *dest, const char *src) {
    fprintf(output_file, "    %s -= %s;\n", dest, src);
}

// fermer fichier
void close_code_generator(void) {
    fprintf(output_file, "    return 0;\n");
    fprintf(output_file, "}\n");
    fclose(output_file);
}