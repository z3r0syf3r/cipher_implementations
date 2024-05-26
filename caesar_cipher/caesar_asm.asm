section .data
    plaintext db "HELLO", 0       ; Input plaintext
    key db 3                      ; Caesar cipher key
    ciphertext db 6 dup(0)        ; Output ciphertext
    len equ $ - plaintext         ; Length of the plaintext

section .text
    global _start

_start:
    ; Loop through the plaintext
    mov esi, plaintext        ; Load address of plaintext
    mov edi, ciphertext       ; Load address of ciphertext
    mov ecx, len              ; Load length of plaintext
    
encrypt_loop:
    mov al, [esi]             ; Load character from plaintext
    cmp al, 0                 ; Check for end of string
    je end_encrypt_loop       ; If end of string, exit loop
    
    add al, key               ; Shift character by the key
    mov [edi], al             ; Store encrypted character
    inc esi                   ; Move to next character in plaintext
    inc edi                   ; Move to next character in ciphertext
    loop encrypt_loop         ; Repeat loop for remaining characters
    
end_encrypt_loop:
    mov byte [edi], 0         ; Null-terminate the ciphertext
    
    ; Print ciphertext
    mov eax, 4                ; System call for sys_write
    mov ebx, 1                ; File descriptor 1 (stdout)
    mov ecx, ciphertext       ; Address of ciphertext
    call print_string
    
    ; Exit program
    mov eax, 1                ; System call for sys_exit
    xor ebx, ebx              ; Exit code 0
    int 0x80                  ; Call kernel
    
print_string:
    ; Function to print a null-terminated string
    pushad                    ; Save registers
    mov edx, len              ; Length of string
    int 0x80                  ; System call
    popad                     ; Restore registers
    ret                       ; Return

