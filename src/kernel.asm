[BITS 16]          ; Define que o código será executado em modo real de 16 bits
[ORG 0000h]        ; Define a origem do código em 0x0800, onde o boot.asm pula para executar o código carregado

jmp OSMain         ; Pula para a sub-rotina OSMain

;--------------------------------------------------------
; Directives and inclusions
%INCLUDE "src/hardware/monitor.lib"
;-------------------------------------------------------

;-------------------------------------------------------
; Starting the System
OSMain:
    call ConfigSegment      ; Chama a sub-rotina ConfigSegment para configurar os segmentos
    call ConfigStack        ; Chama a sub-rotina ConfigStack para configurar a pilha
    call VGA.SetVideoMode   ; Chama a sub-rotina VGA.SetVideoMode para configurar o modo de vídeo
    call DrawBackground     ; Chama a sub-rotina DrawBackground para pintar o fundo da tela
    call EffectInit         ; Chama a sub-rotina EffectInit para inicializar os efeitos

    jmp END                 ; Pula para a sub-rotina END
;-------------------------------------------------------

;-------------------------------------------------------
; Kernel functions
ConfigSegment:
    mov ax, es              ; Move o valor do segmento extra (ES) para AX            
    mov ds, ax              ; Move o valor de AX para o segmento de dados (DS)
ret                         ; Retorna da sub-rotina

ConfigStack:
    mov ax, 7D00h           ; Move o valor 0x7D00 para AX
    mov ss, ax              ; Configura o segmento de pilha (SS) com o valor de AX
    mov sp, 03FEh           ; Configura o ponteiro de pilha (SP) com o valor 0x03FE
ret                         ; Retorna da sub-rotina

END:
    mov ah, 0000h           ; Move o valor 0x00 para AH
    int 16h                 ; Chama a interrupção 16h
    mov ax, 0040h           ; Move o valor 0x0040 para AX
    mov ds, ax              ; Move o valor de AX para o segmento de dados (DS)
    mov ax, 1234h           ; Move o valor 0x1234 para AX
    mov [0072h], ax         ; Move o valor de AX para o endereço 0x0072
    jmp 0FFFFh:0000h        ; Pula para o endereço 0xFFFF:0000    
;-------------------------------------------------------
