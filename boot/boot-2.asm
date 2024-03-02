;
; BIOS Service - Impressão de caractere como TTY
; AH 0eH
; AL Caracter to Write
; BL (Graphics only mode) foreground color number

bits 16
org 0x7c00

main:


dw 0xaa55