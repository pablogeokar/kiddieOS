; kernel.asm - Kernel principal
[BITS 32]
global kernel_main

section .text
kernel_main:
    ; Limpar tela
    mov edi, 0xB8000     ; Início da memória de vídeo
    mov ecx, 2000        ; Número de caracteres (80*25)
    mov eax, 0x0720      ; Espaço em branco (atributo 07, caractere 20)
    rep stosw            ; Preenche a tela

    ; Escrever mensagem
    mov edi, 0xB8000
    mov eax, 0x0F480F48  ; 'H' em branco sobre preto
    stosd
    mov eax, 0x0F650F65  ; 'e' em branco sobre preto
    stosd
    mov eax, 0x0F6C0F6C  ; 'l' em branco sobre preto
    stosd
    mov eax, 0x0F6C0F6C  ; 'l' em branco sobre preto
    stosd
    mov eax, 0x0F6F0F6F  ; 'o' em branco sobre preto
    stosd

    ret                  ; Retorna para boot.asm