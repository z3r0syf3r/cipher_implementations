#!/usr/bin/awk -f

function initialize_matrix(key) {
    delete alphabet
    for (i = 65; i <= 90; i++) {
        if (i == 81) continue; # Skip 'Q'
        alphabet[sprintf("%c", i)] = 1
    }
    
    delete matrix
    index = 0
    for (i = 1; i <= length(key); i++) {
        letter = substr(key, i, 1)
        if (alphabet[letter] == 1) {
            matrix[index / 5, index % 5] = letter
            alphabet[letter] = 0
            index++
        }
    }
    
    for (i = 65; i <= 90; i++) {
        letter = sprintf("%c", i)
        if (i == 81 || alphabet[letter] == 0) continue
        matrix[index / 5, index % 5] = letter
        alphabet[letter] = 0
        index++
    }
}

function find_positions(matrix, letter, positions) {
    delete positions
    for (i = 0; i < 5; i++) {
        for (j = 0; j < 5; j++) {
            if (matrix[i, j] == letter) {
                positions[++positions[0]] = i
                positions[++positions[0]] = j
            }
        }
    }
}

function encrypt(plaintext, key) {
    initialize_matrix(key)
    gsub(/[^A-Z]/, "", plaintext)
    gsub(/J/, "I", plaintext)
    gsub(/[^A-Z]/, "", key)
    gsub(/J/, "I", key)
    
    ciphertext = ""
    for (i = 1; i <= length(plaintext); i += 2) {
        pair = substr(plaintext, i, 2)
        if (length(pair) == 1) pair = pair "X"
        
        letter1 = substr(pair, 1, 1)
        letter2 = substr(pair, 2, 1)
        
        find_positions(matrix, letter1, positions1)
        find_positions(matrix, letter2, positions2)
        
        if (positions1[1] == positions2[1]) { # Same row
            ciphertext = ciphertext matrix[positions1[1], (positions1[2] + 1) % 5] matrix[positions2[1], (positions2[2] + 1) % 5]
        } else if (positions1[2] == positions2[2]) { # Same column
            ciphertext = ciphertext matrix[(positions1[1] + 1) % 5, positions1[2]] matrix[(positions2[1] + 1) % 5, positions2[2]]
        } else { # Different row and column
            ciphertext = ciphertext matrix[positions1[1], positions2[2]] matrix[positions2[1], positions1[2]]
        }
    }
    
    return ciphertext
}

BEGIN {
    plaintext = "HELLO WORLD"
    key = "PLAYFAIR"
    ciphertext = encrypt(plaintext, key)
    print "Plaintext: " plaintext
    print "Key: " key
    print "Ciphertext: " ciphertext
}

