org 0x7c00
bits 16

main:
    ; Apresenta uma carinha feliz na tela
    mov al, 0x02
    mov ah, 0x0e
    mov bh, 0
    int 0x10 ; Interrupção que afeta serviços de vídeo
halt:
    ; Parada da CPU
    hlt
    jmp halt

times 510-($-$$) db 0
dw 0xaa55