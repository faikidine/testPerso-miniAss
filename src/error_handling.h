#ifndef ERROR_HANDLING_H
#define ERROR_HANDLING_H

void syntax_error(const char *msg, int line);
void semantic_error(const char *msg);
void general_error(const char *msg);

#endif
