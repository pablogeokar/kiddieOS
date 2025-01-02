[BITS 16]          ; Define que o código será executado em modo real de 16 bits
[ORG 7C00h]        ; Define a origem do código em 0x7C00, onde o BIOS carrega o setor de boot

call LoadSystem    ; Chama a sub-rotina LoadSystem
jmp 0800h:0000h    ; Pula para o endereço 0x0800:0x0000 para executar o código carregado

LoadSystem:
    mov ah, 02h    ; Função 02h da interrupção 13h: Ler setores do disco
    mov al, 1      ; Número de setores a serem lidos (1 setor)
    mov ch, 0      ; Número do cilindro (parte alta)
    mov cl, 2      ; Número do setor (começa em 1, então setor 2)
    mov dh, 0      ; Cabeça do disco (0)
    mov dl, 80h    ; Unidade de disco (80h para o primeiro disco rígido)
    mov bx, 0800h  ; Segmento de destino na memória (0x0800)
    mov es, bx     ; Carrega o segmento extra (ES) com 0x0800
    mov bx, 0      ; Offset de destino na memória (0x0000)
    int 13h        ; Chama a interrupção 13h para ler o setor do disco
ret                ; Retorna da sub-rotina

times 510-($-$$) db 0 ; Preenche o restante do setor de boot com zeros até 510 bytes
dw 0xAA55             ; Assinatura de boot (0xAA55) nos últimos 2 bytes do setor

