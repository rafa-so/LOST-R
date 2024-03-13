bits 16
org 0x7c00

main:
    xor ax, ax
    mov ds, ax
    mov es, ax

    mov ss, ax
    mov sp, 0x7c00
    halt

print_msg:
    mov ah, 0x0e
    mov cx, pad - msg
    mov si, msg
.next_char:
    lodsb
    int 0x10
    loop .next_char

halt:
    cli
    hlt

msg: db 'Loading OS...'

pad: times 510-($-$$) db 0

sig: dw 0xaa55