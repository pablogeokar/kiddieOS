[org 0x7C00]
[bits 16]

start:
    ; Configuração básica
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    
    ; Salvar drive de boot
    mov [bootdrive], dl
    
    ; Mostrar mensagem inicial
    mov si, msg_load
    call print_string
    
    ; Reset do disco
    xor ax, ax
    int 0x13
    jc reset_failed
    
    ; Ler kernel
    mov bx, 0x1000  ; ES:BX = 0x0000:0x1000
    mov ah, 0x02    ; Função de leitura
    mov al, 1       ; Ler apenas 2 setores inicialmente - era 2 e mudei para 1 setor
    mov ch, 0       ; Cilindro 0
    mov cl, 2       ; Setor 2
    mov dh, 0       ; Cabeça 0
    mov dl, [bootdrive]
    int 0x13
    jc read_failed
    
    ; Sucesso - pular para o kernel
    mov si, msg_ok
    call print_string
    jmp 0x1000:0000

reset_failed:
    mov si, msg_reset_err
    call print_string
    jmp $

read_failed:
    mov si, msg_read_err
    call print_string
    mov si, msg_err_code
    call print_string
    mov al, ah      ; Código de erro está em AH
    call print_hex
    jmp $

print_string:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0E
    int 0x10
    jmp print_string
.done:
    ret

print_hex:
    push ax
    push bx
    mov ah, 0x0E
    mov bl, al
    shr al, 4
    add al, '0'
    cmp al, '9'
    jle .print_high
    add al, 7
.print_high:
    int 0x10
    mov al, bl
    and al, 0x0F
    add al, '0'
    cmp al, '9'
    jle .print_low
    add al, 7
.print_low:
    int 0x10
    pop bx
    pop ax
    ret

bootdrive: db 0
msg_load: db 'Carregando...', 13, 10, 0
msg_ok: db 'OK!', 13, 10, 0
msg_reset_err: db 'Erro no reset do disco', 13, 10, 0
msg_read_err: db 'Erro na leitura do disco', 13, 10, 0
msg_err_code: db 'Codigo: ', 0

times 510-($-$$) db 0
dw 0xAA55