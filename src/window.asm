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
    mov al, byte [Window_Border_Color]  ; Cor do pixel superior esquerdo
    mov cx, word [Window_PositionX]     ; Coluna do pixel superior esquerdo
    mov dx, word [Window_PositionY]     ; Linha do pixel superior esquerdo
    cmp byte [Window_Bar], 0            ; Verifica se a barra de título está ativada
    je WindowNoBar                      ; Se não estiver ativada, pula para WindowNoBar
    jmp WindowWithBar                   ; Se estiver ativada, pula para WindowWithBar

WindowNoBar:
    mov bx, word [Window_Width]         ; Largura da janela
    add bx,cx                           ; Largura da janela + coluna
    LineUp:
        int 10h                         ; Chama a interrupção 10h para mover o cursor
        inc cx                          ; Incrementa CX - coluna
        cmp cx, bx                      ; Compara CX com bx
        jne LineUp                      ; Se CX for diferente de BX, pula para LineUp
        call BorderRightDown
        mov bx, word [Window_PositionY] ; Altura da linha inicial
    LineLeft:
        int 10h                         ; Chama a interrupção 10h para mover o cursor
        dec dx                          ; Decrementa DX - linha
        cmp dx, bx                      ; Compara DX com BX
        jne LineLeft                    ; Se DX for diferente de 50, pula para LineLeft
        jmp Rets                        ; Pula para Rets

WindowWithBar:
        mov al, byte [Window_Bar_Color] ; Cor da barra de título
        mov bx, word [Window_Width]     ; Cumprimento da janela
        add bx, cx                      ; Cumprimento da janela + coluna
        push ax                         ; Salva o valor de AX na pilha
        mov ax, dx                      ; Move o valor de DX para AX
        add ax, 9                       ; Adiciona 9 a AX
        mov [StateWindowBar], ax        ; Move o valor de AX para StateWindowBar
        pop ax                          ; Restaura o valor de AX da pilha
        PaintBar:
            int 10h                             ; Chama a interrupção 10h para mover o cursor
            inc cx                              ; Incrementa CX - coluna
            cmp cx, bx                          ; Compara CX com BX
            jne PaintBar                        ; Se CX for diferente de BX, pula para PaintBar
            int 10h                             ; Chama a interrupção 10h para mover o cursor
            inc dx                              ; Incrementa DX - linha
            inc al                              ; Incrementa AL
            cmp dx, word[StateWindowBar]        ; Compara DX com StateWindowBar
            jne BackColumn                      ; Se DX for diferente de StateWindowBar, pula para BackColumn
            mov al, byte [Window_Border_Color]  ; Cor da borda da janela
            call BorderRightDown                ; Chama a sub-rotina BorderRightDown
            mov bx, word [Window_PositionY]     ; Altura da linha inicial
            add bx, 8                           ; Adiciona 8 a BX
            LineLeftBar:
                int 10h                         ; Chama a interrupção 10h para mover o cursor
                dec dx                          ; Decrementa DX - linha
                cmp dx, bx                      ; Compara DX com BX
                jne LineLeftBar                 ; Se DX for diferente de BX, pula para LineLeftBar
                ; call BackColor
                ; call ButtonsBar
                jmp Rets                        ; Pula para Rets
        BackColumn:
            mov cx, word [Window_PositionX] ; Largura da coluna inicial
            mov bx, word [Window_Width]     ; Largura da janela
            add bx, cx                      ; Largura da janela + coluna
            push bx                         ; Salva o valor de BX na pilha
            mov bx, word [StateWindowBar]   ; Move o valor de StateWindowBar para BX
            sub bx, 6                       ; Subtrai 6 de BX
            cmp dx, bx                      ; Compara DX com BX
            ja IncColorAgain                ; Se DX for maior que BX, pula para IncColorA
            pop bx                          ; Restaura o valor de BX da pilha
            jmp PaintBar                    ; Pula para PaintBar
        IncColorAgain:
            pop bx                          ; Restaura o valor de BX da pilha
            inc al                          ; Incrementa AL
            jmp PaintBar                    ; Pula para PaintBar
 
BorderRightDown:
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
ret                                     ; Retorna da sub-rotina

Rets:                                   
    ret                                 ; Retorna da sub-rotina

ReturnKernel:
    ret                                 ; Retorna para o kernel

