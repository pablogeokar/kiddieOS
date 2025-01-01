[BITS 16]          ; Define que o código será executado em modo real de 16 bits
[ORG 0000h]        ; Define a origem do código em 0x0800, onde o boot.asm pula para executar o código carregado

jmp OSMain          ; Pula para a sub-rotina OSMain

BackWidth db 0                  ; Define a largura da tela
BackHeight db 0                 ; Define a altura da tela
Pagination db 0                 ; Define a paginação da tela
Welcome db "Bem-vindo ao KiddieOS!",0   ; Define a string a ser impressa

OSMain:
    call ConfigSegment      ; Chama a sub-rotina ConfigSegment para configurar os segmentos
    call ConfigStack        ; Chama a sub-rotina ConfigStack para configurar a pilha
    call TEXT.SetVideoMode  ; Chama a sub-rotina SetVideoMode para configurar o modo de vídeo
    jmp ShowString          ; Pula para a sub-rotina ShowString

ShowString:
    mov dh, 3               ; Define a linha onde a string será impressa
    mov dl, 2               ; Define a coluna onde a string será impressa
    call MoveCursor         ; Chama a sub-rotina MoveCursor para mover o cursor
    mov si, Welcome         ; Move o endereço da string para SI
    call PrintString        ; Chama a sub-rotina PrintString para imprimir a string
    jmp END                 ; Pula para o fim do código

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
    mov BYTE[BackWidth], 80; Define a largura da tela como 80 colunas
    mov BYTE[BackHeight], 25; Define a altura da tela como 25 linhas
ret

PrintString:
    lodsb                   ; Carrega caractere de SI para AL
    cmp al, 0              ; Verifica fim da string
    je .done               ; Se zero, termina
    mov ah, 0Eh            ; Função 0Eh - Teletype output
    mov bh, [Pagination]   ; Página
    int 10h                ; Imprime caractere
    jmp PrintString        ; Próximo caractere
.done:
    ret

; PrintString:
;     mov ah, 09h             ; Função 09h da interrupção 21h: Imprimir string
;     mov bh, [Pagination]    ; Página de vídeo (0)
;     mov bl, 40              ; Número da cord dos caracteres
;     mov cx, 1               ; Número de vezes que a string será impressa
;     mov al, [si]            ; Move o primeiro byte da string para AL
;     print:
;     int 10h                 ; Chama a interrupção 10h para imprimir o caractere em AL
;     inc si                  ; Incrementa o índice da string
;     call MoveCursor         ; Chama a sub-rotina MoveCursor para mover o cursor
;     mov ah, 09h             ; Função 09h da interrupção 21h: Imprimir string
;     mov al, [si]            ; Move o próximo byte da string para AL
;     cmp al, 0               ; Compara AL com 0 (fim da string)    
;     jne print               ; Se AL não for 0, continua imprimindo o próximo caractere        
; ret

MoveCursor:
    mov ah, 02h             ; Função 02h da interrupção 10h: Mover cursor
    mov bh, [Pagination]    ; Página de vídeo (0)
    inc dl                  ; Incrementa a coluna
    int 10h                 ; Chama a interrupção 10h para mover o cursor
ret

END:
    jmp $                   ; Loop infinito