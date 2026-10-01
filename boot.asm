; System notepad using FASM for x86 (16 bit)

org 0x7C00

start:
    ; Zero out the segment registers and set stack
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    sti

    ; Set video mode and clear screen
    mov ax, 0x2
    int 0x10

    ; Print messages
    mov dx, 0
    mov ax, 0x1301
    mov bx, 0x7
    mov bp, welcome
    mov cx, 19
    int 0x10
    mov dx, 0x0100
    mov bp, guide
    mov cx, 38
    int 0x10

input_loop:
    ; Get a page number (F1, F2, ... , F10)
    mov ah, 0x0
    int 0x16

    cmp ah, 0x3B    ; if (scancode < F1)   #F1 = 0x3B
    jl input_loop

    cmp ah, 0x44    ; if (scancode > F10)  #F10 = 0x44
    jg input_loop

load_page_and_start_writing:
    ;???
    ; Get sector number (1-code, 2-zero-filled, 3-page1, 4-page2, ... , 12-page10)
    ; ah = ah - scancode(F1) + 3
    sub ah, 0x38

    ;-read zero-filled sector
    ;-read page sector

    mov dx, 0x0400
    call set_cursor_position

    mov si, 0

write_loop:
    mov ah, 0x0
    int 0x16

    ;-if ah -> F1, F10 write sector and jmp load_page_...

    cmp ah, 0xE          ; Backspace = 0xE
    jz .delete_symbol

    cmp si, 255          ; 510 - Max text size  (sector = 510B + signature(2B) = 512B)
    jz write_loop        ; but si - max 255 :(

    mov [0x7E00+si], al  ; Write into the buffer (RAM adress is 0x7E00)
    inc si
    mov ah, 0x9
    mov bx, 0x7
    mov cx, 1
    int 0x10

    inc dl
    call set_cursor_position

    jmp write_loop

.delete_symbol:
    cmp dx, 0x0400       ; This is the edge of edit space (row - 4, column - 0)
    jz write_loop

    dec dl
    call set_cursor_position

    mov al, 0x20         ; Space = 0x20
    mov [0x7E00+si], al
    dec si
    mov ah, 0x9
    mov bx, 0x7
    mov cx, 1
    int 0x10

    jmp write_loop

    cli
    hlt


; This procedure reads from a sector into the buffer (0x7E00) or
; writes to sector from the buffer.
;        ah: 0x2-read  0x3-write, cl - sector number

read_or_write_sector:
    push dx
    push ax
    xor ax, ax
    mov es, ax
    pop ax
    mov bx, 0x7E00 ; 0x7E00 is the next available memory after the boot sector
    mov ch, 0
    mov dh, 0
    mov dl, 0x80   ; dl - drive number (0x80 - HDD)
    mov al, 1
    int 0x13
    pop dx
    ret

; dh - row, dl - column
set_cursor_position:
    mov ah, 0x2
    xor bh, bh
    int 0x10
    ret


welcome db 'Welcome to Notepad!'
guide db 'Press a function key to open its page.'


times (510-($-$$)) db 0
db 0x55,0xAA