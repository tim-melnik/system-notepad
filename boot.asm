;System notepad using FASM for x86 (16 bit)
;use16

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

    ;Printing messages
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

    ;Getting a page number (F1, F2, ... , F10)
input_loop:
    mov ah, 0x0
    int 0x16

    cmp ah, 0x3B    ; F1 = 0x3B
    jl input_loop   ; if (scancode < F1)
    cmp ah, 0x44    ; F10 = 0x44
    jg input_loop   ; if (scancode > F10)

    ;   ***IT IS FOR TESTING***
    inc dh
    mov ax, 0x1301
    mov bl, 0x7
    mov bp, welcome
    mov cx, 19
    int 0x10

    ;TO DO
    ;print page number
    ;zeroing buffer
    ;load sector to 0x7E00 (buffer)
    ;allow the user to write
    ;track F1-F2
    ;if 'yes' unload buffer to sector
    ;start over

    jmp input_loop

    cli
    hlt

welcome db 'Welcome to Notepad!'
guide db 'Press a function key to open its page.'


times (510-($-$$)) db 0
db 0x55,0xAA