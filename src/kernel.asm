; kernel.asm - Kernel Multiboot 32-bit
[BITS 32]
global start

; Constantes Multiboot
MULTIBOOT_MAGIC      equ 0x1BADB002
MULTIBOOT_FLAGS      equ 0x00000003
MULTIBOOT_CHECKSUM   equ -(MULTIBOOT_MAGIC + MULTIBOOT_FLAGS)

; Seção Multiboot
section .multiboot
align 4
    dd MULTIBOOT_MAGIC      ; magic number
    dd MULTIBOOT_FLAGS      ; flags
    dd MULTIBOOT_CHECKSUM   ; checksum

; Seção de texto
section .text
start:
    ; Limpar tela
    mov edi, 0xB8000     ; Início da memória de vídeo
    mov ecx, 500         ; Número de palavras a limpar
    mov eax, 0x0720      ; Espaço em branco
    rep stosw            ; Preenche a tela

    ; Escrever mensagem
    mov dword [0xB8000], 0x0F4B0F48  ; 'HK' em branco sobre preto

.hang:
    cli                  ; Desabilita interrupções
    hlt                  ; Para a CPU
    jmp .hang            ; Loop infinito

; Preencher o resto do setor
times 512 - ($ - $$) db 0