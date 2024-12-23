[BITS 16]
[ORG 0x7C00]

call HelloWorld
call JumpLine

call PointerString
call PrintString

call PointerBuffer
call ReadString
call PointerStringBuffer
call PrintString
;jmp $

HelloWorld:
    mov ah, 0eh ;imprime caracteres na tela
    mov al, 48h
    int 10h ;interrupção de vídeo
    ret

JumpLine:
    mov ah, 0eh
    mov al, 0ah
    int 10h
    mov al, 0dh
    int 10h
    ret

PointerString:
    mov si, hello
    ret

PrintString:
    mov ah, 0eh
    mov al, [si]
    print:
        int 10h
        inc si
        mov al, [si]
        cmp al ,0
        jne print ;jump not equal
    ret

PointerBuffer:
    mov di, buffer
    ret

 PointerStringBuffer:
    mov si, buffer
    ret

ReadString:
    mov ah, 00h
    int 16h
    mov ah, 0eh
    int 10h
    mov [di], al
    inc di
    cmp al, 0dh
    jne ReadString
    mov ah, 0eh
    mov al, 0ah
    int 10h
    ret

hello db "Hello World!",13,10,0
buffer times 20 db 0



times 510 - ($-$$) db 0
dw 0xAA55