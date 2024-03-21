section .data

    msg1: db "Digite o seu nome: "
    len1: equ $ - msg1

    msg2: db "Muito prazer, "
    len2: equ $ - msg2

    msg3: db `!\n`
    len3: equ $ - msg3

section .bss

    name: resb 50

section .text

    global _start

_start:

    ; Impessão da mensagem 01
    mov rax, 1
    mov rdi, 1
    mov rsi, msg1
    mov rdx, len1
    syscall

    ; Inclusão de dados do teclado
    mov rax, 0
    mov rdi, 0
    mov rsi, name
    mov rdx, 50
    syscall

    ; Apresenta a segunda mensagem
    mov rax, 1
    mov rdi, 1
    mov rsi, msg2
    mov rdx, len2
    syscall

    mov r8, name

    _print:
        mov rax, 1
        mov rdi, 1
        mov rsi, r8
        mov rdx, 1
        syscall

        inc r8
        cmp byte[r8], 10
        jne _print 

    ; Apresenta com a mensagem final
    mov rax, 1
    mov rdi, 1
    mov rsi, msg3
    mov rdx, len3
    syscall

_end:

    mov rax, 60
    mov rdi, 0
    syscall

