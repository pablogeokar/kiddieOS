[BITS 16]          ; Define que o código será executado em modo real de 16 bits
[ORG 0800h]        ; Define a origem do código em 0x0800, onde o boot.asm pula para executar o código carregado

jmp OSMain          ; Pula para a sub-rotina OSMain

BackWidth db 0      ; Define a largura da tela
BackHeight db 0     ; Define a altura da tela
Pagination db 0     ; Define a paginação da tela

OSMain:
    call ConfigSegment      ; Chama a sub-rotina ConfigSegment para configurar os segmentos
    call ConfigStack        ; Chama a sub-rotina ConfigStack para configurar a pilha
    call TEXT.SetVideoMode  ; Chama a sub-rotina SetVideoMode para configurar o modo de vídeo

ConfigSegment:
    mov ax, es              ; Move o valor do segmento extra (ES) para AX
    mov ds, ax              ; Move o valor de AX para o segmento de dados (DS)
ret                         ; Retorna da sub-rotina

ConfigStack:
    mov ax, 7D00h           ; Move o valor 0x7D00 para AX
    mov ss, ax              ; Configura o segmento de pilha (SS) com o valor de AX
    mov sp, 03FEh           ; Configura o ponteiro de pilha (SP) com o valor 0x03FE
ret                         ; Retorna da sub-rotina

TEXT.SetVideoMode:
    mov ah, 00h             ; Função 00h da interrupção 10h: Configurar modo de vídeo
    mov al, 03h             ; Modo de vídeo 03h: 80x25 texto, 16 cores
    int 10h                 ; Chama a interrupção 10h para configurar o modo de vídeo
    mov byte[BackWidth],  80; Define a largura da tela como 80 colunas
    mov byte[BackHeight], 20; Define a altura da tela como 20 linhas
ret