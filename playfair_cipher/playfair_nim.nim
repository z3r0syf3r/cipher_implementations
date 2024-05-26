import strutils

const MATRIX_SIZE = 5

type
  Matrix = array[MATRIX_SIZE, MATRIX_SIZE, char]

proc initializeMatrix(key: string): Matrix =
  var matrix: Matrix
  var alphabet = initCountTable(26, false)

  var index = 0
  for ch in key:
    if ch == 'J': ch = 'I'
    if ch in {'A'..'Z'} and not alphabet[ch.int - 'A'.int]:
      alphabet[ch.int - 'A'.int] = true
      matrix[index div MATRIX_SIZE, index mod MATRIX_SIZE] = ch
      index.inc

  for i in 'A'..'Z':
    if i == 'J': continue
    if not alphabet[i.int - 'A'.int]:
      matrix[index div MATRIX_SIZE, index mod MATRIX_SIZE] = i
      index.inc

  result = matrix

proc findPositions(matrix: Matrix, letter: char): tuple[coords: array[2, int], found: bool] =
  for i in 0..<MATRIX_SIZE:
    for j in 0..<MATRIX_SIZE:
      if matrix[i, j] == letter:
        return ([(i, j)], true)

  result = ([], false)

proc encrypt(plaintext: string, key: string): string =
  var matrix = initializeMatrix(key)
  let paddedPlaintext = if len(plaintext) mod 2 == 1: $plaintext & "X" else: plaintext
  var ciphertext: string

  for i in 0..<len(paddedPlaintext) step 2:
    let letter1 = if paddedPlaintext[i] == 'J': 'I' else: paddedPlaintext[i]
    let letter2 = if i + 1 < len(paddedPlaintext): if paddedPlaintext[i + 1] == 'J': 'I' else: paddedPlaintext[i + 1] else: 'X'

    let (positions1, found1) = findPositions(matrix, letter1)
    let (positions2, found2) = findPositions(matrix, letter2)

    if not found1 or not found2:
      raise newException(Exception, "Letter not found in matrix")

    if positions1[0][0] == positions2[0][0]: # Same row
      ciphertext.add(matrix[positions1[0][0], (positions1[0][1] + 1) mod MATRIX_SIZE])
      ciphertext.add(matrix[positions2[0][0], (positions2[0][1] + 1) mod MATRIX_SIZE])
    elif positions1[0][1] == positions2[0][1]: # Same column
      ciphertext.add(matrix[(positions1[0][0] + 1) mod MATRIX_SIZE, positions1[0][1]])
      ciphertext.add(matrix[(positions2[0][0] + 1) mod MATRIX_SIZE, positions2[0][1]])
    else: # Rectangle
      ciphertext.add(matrix[positions1[0][0], positions2[0][1]])
      ciphertext.add(matrix[positions2[0][0], positions1[0][1]])

  result = ciphertext

# Example usage
let plaintext = "HELLO WORLD"
let key = "PLAYFAIR"
let ciphertext = encrypt(plaintext, key)
echo "Plaintext:", plaintext
echo "Key:", key
echo "Ciphertext:", ciphertext

