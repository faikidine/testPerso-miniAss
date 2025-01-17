#ifndef CODE_GEN_H
#define CODE_GEN_H

void init_code_generator(const char *filename);
void generate_mov(const char *dest, const char *src);
void generate_add(const char *dest, const char *src);
void generate_sub(const char *dest, const char *src);
void close_code_generator();

#endif
