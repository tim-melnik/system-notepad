; Image of hard drive with the Notepad and a pages

format binary as "img"

    file "boot.bin"     ; Sector1 (code)

    times 510 db 0      ; Sector2 (page 1)
    db 0x55, 0xAA

    times 510 db 0      ; Sector3 (page 2)
    db 0x55, 0xAA

    db "Hello!"
    times 504 db 0      ; Sector4 (page 3)
    db 0x55, 0xAA

    times 510 db 'A'      ; Sector5 (page 4)
    db 0x55, 0xAA

    times 510 db 'B'      ; Sector6 (page 5)
    db 0x55, 0xAA

    times 510 db 'C'     ; Sector7 (page 6)
    db 0x55, 0xAA

    times 510 db 0      ; Sector8 (page 7)
    db 0x55, 0xAA

    times 510 db 0      ; Sector9 (page 8)
    db 0x55, 0xAA

    times 510 db 0      ; Sector10 (page 9)
    db 0x55, 0xAA

    times 510 db 0      ; Sector11 (page 10)
    db 0x55, 0xAA