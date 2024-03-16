; section .data
    msg:
        db "Salve Simpatia", 10      ; 'msg' - Rótulo dos dados definido
        db "teste de definicao", 10  ; 'db'  - Os dados são definidos como
                                     ; uma caideia de bytes
    len: equ $ - msg                 ; 'len' - Rótulo do tamanho da mensagem
                                     ; 'equ' - Pseudo-instrução para definir constantes
                                     ; '$'   - Endereço do último byte escrito em memória
                                     ; 'msg' - Endereço do primeiro byte da mensagem
section .bss
    name: resb 50

section .text
    global _start                ; A diretiva 'global' torna o rótulo '_start'
                                 ; visível de qualquer parte do programa

_start:                          ; Aqui está o início do programa
    mov byte[name], 0x45
    mov rax, 0x01                ; Chamada de systema 'sys_write'
    mov rdi, 0x01                ; Descritor de arquivos 1 (stdout)
    mov rsi, msg                 ; Ponteiro para string em memória
    mov rdx, len                 ; Constante com o tamanho da string
    syscall                      ; Invoca a chamada de sistema com os
                                 ; dados nos Registradores

_end:
    mov rax, 60
    mov rdi, 0x00
    syscall