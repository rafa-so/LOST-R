bits 16
org 0x7c00

main:

print_title:
    mov ah, 0x0e
    ; Cria o count para saber o tamanho da 
    ; string que vai serapresentada na tela
    mov cx, pad - title
    mov si, title
.next_char:
    lodsb ; 
    int 0x10 ; Interrupção de vídeo
    loop .next_char ; instrução de loop que decrementa o contador 'cx'

title: db 'Bem vindo ao jogo de charada', 10

pad: times 510-($-$$) db 0

dw 0xaa55