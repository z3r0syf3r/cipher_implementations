#include <stdio.h>
#include <string.h>
#include <ctype.h>

// Function to encrypt a single character using the Caesar cipher
char caesar_encrypt(char c, int shift) {
    if (islower(c)) {
        return (c - 'a' + shift) % 26 + 'a';
    } else if (isupper(c)) {
        return (c - 'A' + shift) % 26 + 'A';
    } else {
        return c;
    }
}

int main(int argc, char *argv[]) {
    if (argc != 3) {
        printf("Usage: %s <shift> <string>\n", argv[0]);
        return 1;
    }

    int shift = atoi(argv[1]);
    char *str = argv[2];
    char encrypted_str[100]; // Adjust size as needed
    int len = strlen(str);

    for (int i = 0; i < len; i++) {
        encrypted_str[i] = caesar_encrypt(str[i], shift);
    }
    encrypted_str[len] = '\0'; // Null-terminate the string

    printf("Encrypted string: %s\n", encrypted_str);
    return 0;
}

