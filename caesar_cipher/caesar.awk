#!/usr/bin/awk -f

# Function to get the ASCII value of a character
function ord(char) {
    return sprintf("%d", char)
}

# Function to encrypt a single character using the Caesar cipher
function caesar_encrypt(char, shift) {
    if (char >= "a" && char <= "z") {
        return sprintf("%c", ((ord(char) - ord("a") + shift) % 26) + ord("a"))
    } else if (char >= "A" && char <= "Z") {
        return sprintf("%c", ((ord(char) - ord("A") + shift) % 26) + ord("A"))
    } else {
        return char
    }
}

BEGIN {
    if (ARGC != 3) {
        print "Usage: awk -f caesar_cipher.awk <shift> <string>"
        exit 1
    }

    shift = ARGV[1] + 0  # Convert shift to number
    str = ARGV[2]

    encrypted_str = ""

    for (i = 1; i <= length(str); i++) {
        char = substr(str, i, 1)
        encrypted_str = encrypted_str caesar_encrypt(char, shift)
    }

    print encrypted_str
    exit 0
}

