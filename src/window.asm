[BITS 16]
[ORG 0500h]

pusha
    call DefineWindow
popa
    jmp ReturnKernel

;==============================================
; Inclusion Files
;----------------------------------------------
%INCLUDE "src/hardware/wmemory.lib"

;----------------------------------------------

DefineWindow:
    mov ah, 0Ch     ; Função 0Ch da interrupção 10h: Definir janela de texto
    mov al, byte [Window_Border_Color]   ; Cor do pixel superior esquerdo
    mov cx, word [Window_PositionX]     ; Coluna do pixel superior esquerdo
    mov dx, word [Window_PositionY]     ; Linha do pixel superior esquerdo
    cmp byte [Window_Bar], 0            ; Verifica se a barra de título está ativada
    je WindowNoBar                      ; Se não estiver ativada, pula para WindowNoBar
    jmp Rets                            ; Se estiver ativada, pula para Rets

WindowNoBar:
    mov bx, word [Window_Width]         ; Largura da janela
    add bx,cx                           ; Largura da janela + coluna
    LineUp:
        int 10h                         ; Chama a interrupção 10h para mover o cursor
        inc cx                          ; Incrementa CX - coluna
        cmp cx, bx                      ; Compara CX com bx
        jne LineUp                      ; Se CX for diferente de BX, pula para LineUp
        mov bx, word [Window_Height]    ; Altura da janela
        add bx, dx                      ; Altura da janela + linha
    LineRight:
        int 10h                         ; Chama a interrupção 10h para mover o cursor
        inc dx                          ; Incrementa DX - linha
        cmp dx, bx                      ; Compara DX com bx
        jne LineRight                   ; Se DX for diferente de BX, pula para LineRight
        mov bx, word [Window_PositionX] ; Largura da coluna inicial
    LineDown:
        int 10h                         ; Chama a interrupção 10h para mover o cursor
        dec cx                          ; Decrementa CX - coluna
        cmp cx, bx                      ; Compara CX com BX        
        jne LineDown                    ; Se CX for diferente de BX, pula para LineDown
        mov bx, word [Window_PositionY] ; Altura da linha inicial
    LineLeft:
        int 10h                         ; Chama a interrupção 10h para mover o cursor
        dec dx                          ; Decrementa DX - linha
        cmp dx, bx                      ; Compara DX com BX
        jne LineLeft                    ; Se DX for diferente de 50, pula para LineLeft
Rets:                                   
    ret                                 ; Retorna da sub-rotina


ReturnKernel:
    ret                                 ; Retorna para o kernel

