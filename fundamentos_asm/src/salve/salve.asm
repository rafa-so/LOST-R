section .data
    msg: db "Salve Simpatia", 0 ; 'msg' - Rótulo dos dados definido
                                 ; 'db'  - Os dados são definidos como
                                 ; uma caideia de bytes
    len: equ $ - msg             ; 'len' - Rótulo do tamanho da mensagem
                                 ; 'equ' - Pseudo-instrução para definir constantes
                                 ; '$'   - Endereço do último byte escrito em memória
                                 ; 'msg' - Endereço do primeiro byte da mensagem

section .text
    global _start                ; A diretiva 'global' torna o rótulo '_start'
                                 ; visível de qualquer parte do programa

_start:                          ; Aqui está o início do programa
    mov rax, 1                   ; Chamada de systema 'sys_write'
    mov rdi, 1                   ; Descritor de arquivos 1 (stdout)
    mov rsi, msg                 ; Ponteiro para string em memória
    mov rdx, len                 ; Constante com o tamanho da string
    syscall                      ; Invoca a chamada de sistema com os
                                 ; dados nos Registradores

_end: