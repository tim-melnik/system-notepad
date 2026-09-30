;System notepad using FASM for x86 (16 bit)

org 0x7C00

start:
    ;Zero out the segment registers and set stack
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    sti

    ;Set video mode and clear screen
    mov ax, 0x2
    int 0x10

    ;Print messages
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

    ;Get a page number (F1, F2, ... , F10)
input_loop:
    mov ah, 0x0
    int 0x16

    cmp ah, 0x3B    ; F1 = 0x3B
    jl input_loop   ; if (scancode < F1)
    cmp ah, 0x44    ; F10 = 0x44
    jg input_loop   ; if (scancode > F10)

    sub ah, 0x38    ; Get sector number (1-code, 2-zero-filled, 3-page1, 4-page2, ...)
                    ; ah = ah - scancode(F1) + 3

load_page_and_start_writing:

    ;   ***IT IS FOR TESTING***

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

read_or_write_sector:  ; ah: 0x2-read  0x3-write, cl - sector number
    push ax
    xor ax, ax
    mov es, ax
    pop ax
    mov bx, 0x7E00   ; 0x7E00 is the next available memory after the boot sector
    mov ch, 0
    mov dh, 0
    mov dl, 0x80   ; dl - drive number (0x80 - HDD)
    mov al, 1
    int 0x13
    ret


welcome db 'Welcome to Notepad!'
guide db 'Press a function key to open its page.'


times (510-($-$$)) db 0
db 0x55,0xAA