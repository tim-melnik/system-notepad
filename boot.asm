;System notepad using FASM for x86 (16 bit)

org 0x7C00

start:
    ;Zeroing segment registers and setting stack
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    sti

    ;Setting video mode and screen clearing
    mov ax, 0x2
    int 0x10

    ;Drawing messages
    mov dx, 0
    mov ax, 0x1301
    mov bl, 0x7
    mov bp, welcome
    mov cx, 19
    int 0x10
    mov dx, 0x0100
    mov bp, guide
    mov cx, 38
    int 0x10

    cli
    hlt

welcome db 'Welcome to Notepad!'
guide db 'Press a function key to open its page.'


times (510-($-$$)) db 0
db 0x55,0xAA