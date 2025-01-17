# les variables pour les outils et chemins
CC = gcc
LEX = flex
YACC = bison

SRC_DIR = src
HOME_DIR = home
BUILD_DIR = build
BIN = micro_assembler

LEX_FILE = $(SRC_DIR)/lexer.l
YACC_FILE = $(SRC_DIR)/parser.y
MAIN_FILE = $(SRC_DIR)/main.c
CODE_GEN_FILE = $(SRC_DIR)/code_gen.c
SEMANTIC_FILE = $(SRC_DIR)/semantic_check.c
ERROR_FILE = $(SRC_DIR)/error_handling.c

OBJS = $(BUILD_DIR)/lexer.o $(BUILD_DIR)/parser.o $(BUILD_DIR)/main.o $(BUILD_DIR)/code_gen.o $(BUILD_DIR)/semantic_check.o $(BUILD_DIR)/error_handling.o

CFLAGS = -Wall -Wextra -g -I$(SRC_DIR)

# regle par défaut
all: $(BIN)

# compilation executable
$(BIN): $(OBJS) | $(BUILD_DIR)
	@echo "linking objects to create $(BIN)..."
	$(CC) $(CFLAGS) -o $(BIN) $(OBJS)
	@echo "build successful!"

# compilation lexer avec Flex
$(BUILD_DIR)/lexer.o: $(LEX_FILE) $(BUILD_DIR)/parser.h | $(BUILD_DIR)
	@echo "generating lexer..."
	$(LEX) -o $(BUILD_DIR)/lexer.c $(LEX_FILE)
	$(CC) $(CFLAGS) -c $(BUILD_DIR)/lexer.c -o $@

# compilation parser avec Bison
$(BUILD_DIR)/parser.o: $(YACC_FILE) | $(BUILD_DIR)
	@echo "generating parser..."
	$(YACC) -d -o $(BUILD_DIR)/parser.c $(YACC_FILE)
	$(CC) $(CFLAGS) -c $(BUILD_DIR)/parser.c -o $@

#generer parser.h
$(BUILD_DIR)/parser.h: $(YACC_FILE) | $(BUILD_DIR)
	@echo "generating parser header..."
	$(YACC) -d -o $(BUILD_DIR)/parser.c $(YACC_FILE)

#compilation main
$(BUILD_DIR)/main.o: $(MAIN_FILE) $(BUILD_DIR)/parser.h | $(BUILD_DIR)
	@echo "compiling main..."
	$(CC) $(CFLAGS) -c $(MAIN_FILE) -o $@

# compilation du code generateur
$(BUILD_DIR)/code_gen.o: $(CODE_GEN_FILE) | $(BUILD_DIR)
	@echo "compiling code generator..."
	$(CC) $(CFLAGS) -c $(CODE_GEN_FILE) -o $@

# compilation du verrificateur sémantique
$(BUILD_DIR)/semantic_check.o: $(SEMANTIC_FILE) | $(BUILD_DIR)
	@echo "compiling semantic checker..."
	$(CC) $(CFLAGS) -c $(SEMANTIC_FILE) -o $@

# compilation gestion d'erreurs
$(BUILD_DIR)/error_handling.o: $(ERROR_FILE) | $(BUILD_DIR)
	@echo "compiling error handler..."
	$(CC) $(CFLAGS) -c $(ERROR_FILE) -o $@

# création build si n'existe pas déjà
$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)

# nettoyer fichiers générés
clean:
	@echo "cleaning build directory..."
	rm -rf $(BUILD_DIR) $(BIN) $(HOME_DIR)/output.c $(BUILD_DIR)/lexer.c $(BUILD_DIR)/parser.c $(BUILD_DIR)/parser.h

# generer fichier C à partir d'un .mias
generate: $(BIN)
	@echo "generating output.c..."
	@./$(BIN) $(filter-out $@, $(MAKECMDGOALS))



#cible générique pour éviter erreurs avec des arguments make
%:
	@:

.PHONY: all clean generate