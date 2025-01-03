[BITS 16]
[ORG 0500h]

pusha
    call DefineWindow
popa
    jmp ReturnKernel

DefineWindow:
    mov ah, 0Ch     ; Função 0Ch da interrupção 10h: Definir janela de texto
    mov al, 55      ; Cor do pixel superior esquerdo
    mov cx, 50      ; Coluna do pixel superior esquerdo
    mov dx, 50      ; Linha do pixel superior esquerdo
    jmp Window

Window:
    LineUp:
        int 10h         ; Chama a interrupção 10h para mover o cursor
        inc cx          ; Incrementa CX - coluna
        cmp cx, 100     ; Compara CX com 100
        jne LineUp      ; Se CX for diferente de 100, pula para LineUp
    LineRight:
        int 10h         ; Chama a interrupção 10h para mover o cursor
        inc dx          ; Incrementa DX - linha
        cmp dx, 100     ; Compara DX com 100
        jne LineRight   ; Se DX for diferente de 100, pula para LineRight
    LineDown:
        int 10h         ; Chama a interrupção 10h para mover o cursor
        dec cx          ; Decrementa CX - coluna
        cmp cx, 50      ; Compara CX com 50
        jne LineDown    ; Se CX for diferente de 50, pula para LineDown
    LineLeft:
        int 10h         ; Chama a interrupção 10h para mover o cursor
        dec dx          ; Decrementa DX - linha
        cmp dx, 50      ; Compara DX com 50
        jne LineLeft    ; Se DX for diferente de 50, pula para LineLeft
ret                     ; Retorna da sub-rotina


ReturnKernel:
    ret