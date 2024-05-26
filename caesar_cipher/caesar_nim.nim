import strutils

# Function to encrypt a single character using the Caesar cipher
proc caesarEncrypt(c: char, shift: int): char =
  if c in 'a'..'z':
    return chr((ord(c) - ord('a') + shift) mod 26 + ord('a'))
  elif c in 'A'..'Z':
    return chr((ord(c) - ord('A') + shift) mod 26 + ord('A'))
  else:
    return c

# Main program
proc main() =
  let shift = parseInt(commandLine[1])
  let str = commandLine[2]
  var encryptedStr = ""

  for c in str:
    encryptedStr.add(caesarEncrypt(c, shift))

  echo "Encrypted string: ", encryptedStr

when isMainModule:
  main()

