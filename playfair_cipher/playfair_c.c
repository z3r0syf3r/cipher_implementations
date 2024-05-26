#include <stdio.h>
#include <string.h>
#include <ctype.h>

#define MATRIX_SIZE 5

void initializeMatrix(char key[], char matrix[MATRIX_SIZE][MATRIX_SIZE]) {
    int i, j, index = 0;
    int alphabet[26] = {0};
    
    for (i = 0; i < strlen(key); i++) {
        if (key[i] == 'J') key[i] = 'I'; // Replacing 'J' with 'I'
        if (!isalpha(key[i])) continue;
        if (!alphabet[toupper(key[i]) - 'A']) {
            alphabet[toupper(key[i]) - 'A'] = 1;
            matrix[index / MATRIX_SIZE][index % MATRIX_SIZE] = toupper(key[i]);
            index++;
        }
    }
    
    for (i = 0; i < 26; i++) {
        if (i == ('J' - 'A') || alphabet[i]) continue;
        matrix[index / MATRIX_SIZE][index % MATRIX_SIZE] = 'A' + i;
        index++;
    }
}

void findPositions(char matrix[MATRIX_SIZE][MATRIX_SIZE], char letter, int positions[]) {
    int i, j, k = 0;
    for (i = 0; i < MATRIX_SIZE; i++) {
        for (j = 0; j < MATRIX_SIZE; j++) {
            if (matrix[i][j] == letter) {
                positions[k++] = i;
                positions[k++] = j;
                return;
            }
        }
    }
}

void encrypt(char plaintext[], char key[], char ciphertext[]) {
    char matrix[MATRIX_SIZE][MATRIX_SIZE];
    initializeMatrix(key, matrix);
    
    int i, j, k = 0;
    for (i = 0; i < strlen(plaintext); i += 2) {
        char letter1 = toupper(plaintext[i]);
        char letter2 = (i + 1 < strlen(plaintext)) ? toupper(plaintext[i + 1]) : 'X'; // Padding 'X' if necessary
        
        if (letter1 == 'J') letter1 = 'I'; // Replacing 'J' with 'I'
        if (letter2 == 'J') letter2 = 'I'; // Replacing 'J' with 'I'
        
        int positions1[2], positions2[2];
        findPositions(matrix, letter1, positions1);
        findPositions(matrix, letter2, positions2);
        
        if (positions1[0] == positions2[0]) { // Same row
            ciphertext[k++] = matrix[positions1[0]][(positions1[1] + 1) % MATRIX_SIZE];
            ciphertext[k++] = matrix[positions2[0]][(positions2[1] + 1) % MATRIX_SIZE];
        } else if (positions1[1] == positions2[1]) { // Same column
            ciphertext[k++] = matrix[(positions1[0] + 1) % MATRIX_SIZE][positions1[1]];
            ciphertext[k++] = matrix[(positions2[0] + 1) % MATRIX_SIZE][positions2[1]];
        } else { // Rectangle
            ciphertext[k++] = matrix[positions1[0]][positions2[1]];
            ciphertext[k++] = matrix[positions2[0]][positions1[1]];
        }
    }
    ciphertext[k] = '\0'; // Null-terminate the ciphertext
}

int main() {
    char plaintext[] = "HELLO WORLD";
    char key[] = "PLAYFAIR";
    char ciphertext[100]; // Assuming a maximum length for ciphertext
    
    encrypt(plaintext, key, ciphertext);
    
    printf("Plaintext: %s\n", plaintext);
    printf("Key: %s\n", key);
    printf("Ciphertext: %s\n", ciphertext);
    
    return 0;
}

