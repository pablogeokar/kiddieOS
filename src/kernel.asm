[BITS 16]
[ORG 0x1000]

start:
    ; Garantir que DS está correto
    push cs
    pop ds
    
    ; Configurar modo de vídeo (limpar tela)
    mov ax, 0003h   ; Modo texto 80x25 colorido
    int 10h
    
    ; Imprimir mensagem inicial (usando BIOS)
    mov si, msg_debug
    call print_string
    
    ; Aguardar um pouco
    mov cx, 0xFFFF
.delay:
    loop .delay
    
    ; Imprimir mensagem de boas-vindas
    mov si, msg_welcome
    call print_string
    
    ; Loop infinito
    jmp $

; Função simples para imprimir string
print_string:
    mov ah, 0Eh     ; Função teletype do BIOS
    mov bh, 0       ; Página 0
.loop:
    lodsb           ; Carregar próximo caractere
    test al, al     ; Verificar se é 0 (fim da string)
    jz .done        ; Se for 0, terminou
    int 10h         ; Chamar BIOS para imprimir
    jmp .loop       ; Continuar para próximo caractere
.done:
    ret

; Mensagens
msg_debug:   db 'Kernel iniciado em 0x1000', 13, 10, 0
msg_welcome: db 'Bem-vindo ao KiddieOS!', 13, 10, 0

; Preencher o resto do setor com zeros
times 512-($-$$) db 0