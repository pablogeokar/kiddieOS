; boot.asm - Bootloader Multiboot
[BITS 32]

; Constantes Multiboot
MULTIBOOT_MAGIC      equ 0x1BADB002
MULTIBOOT_FLAGS      equ 0x00000003
MULTIBOOT_CHECKSUM   equ -(MULTIBOOT_MAGIC + MULTIBOOT_FLAGS)

; Seção Multiboot
section .multiboot
align 4
    dd MULTIBOOT_MAGIC
    dd MULTIBOOT_FLAGS
    dd MULTIBOOT_CHECKSUM

; Seção de código
section .text
global start

start:
    ; Configurar pilha (opcional neste caso)
    mov esp, stack_top
    
    ; Pular para o kernel
    jmp 0x100000

; Seção de pilha
section .bss
align 4
stack_bottom:
    resb 16384 ; 16 KB de pilha
stack_top:


; Preenche até 512 bytes
resb 512 - ($ - $$)