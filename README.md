`**username** : faikidine`

**Micro-assembleur**

## Introduction

**[https://github.com/faikidine/testPerso-miniAss.git](#)**

Ce rapport documente les dépendances, la structure du projet, les étapes de développement et les problèmes rencontrés. Je vais également inclure des captures d'écran à des endroits stratégiques pour illustrer les erreurs et les résultats obtenus.

---

## 1. **Dépendances du projet**

Pour exécuter et compiler ce projet, vous devez disposer des outils suivants :

- **Flex (>= 2.6.4)** : Générateur d'analyseur lexical
- **Bison (>= 3.0)** : Générateur d'analyseur syntaxique
- **GCC (>= 9.0)** : Compilateur C
- **Make** : Outil pour automatiser les builds

Assurez-vous que ces dépendances sont installées et configurées correctement dans votre environnement. Voici la commande pour vérifier leurs versions :

```bash
flex --version
bison --version
gcc --version
make --version
```

---

## 2. **Structure actuelle du projet**

### Organisation des fichiers

Le projet est organisé comme suit :

```
TestPersonnel/
├── Makefile
├── src/
│   ├── lexer.l
│   ├── parser.y
│   ├── main.c
│   ├── code_gen.c
│   ├── code_gen.h
│   ├── semantic_check.c
│   ├── semantic_check.h
│   ├── error_handling.c
│   └── error_handling.h
├── build/
│   ├── lexer.c
│   ├── parser.c
│   ├── parser.h
│   ├── lexer.o
│   ├── parser.o
│   ├── main.o
│   ├── code_gen.o
│   ├── semantic_check.o
│   └── error_handling.o
├── home/
│   ├── example1.mias
│   └── output.c
```

### Description des fichiers

- **Makefile** : Contient les règles pour compiler et nettoyer le projet.
- **src/** : Regroupe les sources du projet (lexer, parser, gestion des erreurs, génération de code, etc.).
- **build/** : Contient les fichiers générés (objets, C intermédiaires).
- **home/** : Stocke les fichiers d'entrée (.mias) et les fichiers de sortie générés (output.c).

---

## 3. **Exemple de fichier d'entrée**

Voici un exemple de fichier `.mias` utilisé comme entrée :

```mias
Var :
x : int
y : int
z : int;

Instr :
mov x, 5
add y, x
sub z, 2;
```

Ce fichier contient deux blocs :
- **Var :** Bloc de déclaration des variables, terminé par `;`.
- **Instr :** Bloc des instructions, également terminé par `;`.

---

## 4. **Erreur rencontrée**

### Problème

Lors de la génération du fichier `output.c`, les variables déclarées ne sont pas incluses dans le fichier C. Cela provoque des erreurs lors de la compilation. Voici un exemple d'erreur obtenue :

```bash
home/output.c: In function ‘main’:
home/output.c:3:5: error: ‘x’ undeclared (first use in this function)
    3 |     x = 5;
      |     ^
```

### Hypothèse

Je pense que le problème vient de la fonction `declare_variables` dans le fichier `code_gen.c`. Les variables collectées ne sont pas correctement ajoutées au fichier généré. 

Voici une capture d'écran montrant les erreurs dans le terminal :

![Erreur de compilation](https://i.ibb.co/wpQcYYb/erreurcompil.png)
---

## 5. **Grammaire et génération de code**

### Définitions principales

#### Déclarations des variables (Var : ... ;)
```yacc
var_section:
    VAR COLON declaration_list SEMICOLON
    {
        printf("variables section parsed successfully\n");
    }
;

declaration_list:
    declaration
  | declaration_list declaration
;

declaration:
    IDENTIFIER COLON IDENTIFIER
    {
        add_variable($1, $3);
        printf("variable declared: %s of type %s\n", $1, $3);
    }
;
```

#### Instructions (Instr : ... ;)
```yacc
instr_section:
    INSTR COLON instruction_list SEMICOLON
    {
        printf("instructions section parsed successfully\n");
    }
;

instruction_list:
    instruction
  | instruction_list instruction
;

instruction:
    MOV IDENTIFIER COMMA operand
    {
        check_variable($2);
        generate_mov($2, $4);
    }
  | ADD IDENTIFIER COMMA operand
    {
        check_variable($2);
        generate_add($2, $4);
    }
;
```

### Fonction de génération des variables
Actuellement, la fonction `declare_variables` dans `code_gen.c` est implémentée comme suit :

```c
void declare_variables(void) {
    for (int i = 0; i < symbol_count; i++) {
        fprintf(output_file, "    int %s;\n", symbol_table[i].name);
    }
}
```

Cependant, cette fonction ne semble pas être appelée correctement ou les variables ne sont pas collectées dans la table des symboles.

---

## 6. **Prochaines étapes**

1. **Vérifier la gestion des variables dans la table des symboles**
   - Assurez-vous que `add_variable` ajoute correctement les variables dans `symbol_table`.

2. **Corriger la fonction `declare_variables`**
   - Implémentez une boucle qui parcourt `symbol_table` et ajoute les déclarations au fichier généré.

3. **Ajouter des assertions et des logs**
   - Ajoutez des printf pour valider que les variables sont bien collectées et utilisées.

4. **Tester avec différents fichiers `.mias`**
   - Testez avec des fichiers contenant des cas limites (variables non déclarées, blocs mal terminés, etc.).

---

**Note personnelle**

Je ne sais pas encore précisément comment résoudre ce problème, mais je vais continuer à investiguer et à expérimenter. Je vais également inclure plus de captures d'écran et de logs dans la prochaine itération.

Faikidine AHMED.

