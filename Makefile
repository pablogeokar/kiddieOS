# Compiladores e ferramentas
NASM = nasm
LD = ld
GRUB = grub-mkrescue

# Flags de compilação
NASMFLAGS = -f elf32
LDFLAGS = -m elf_i386 -nostdlib -Ttext 0x100000

# Diretórios
BUILD_DIR = build
ISO_DIR = iso

# Arquivos
KERNEL_SRC = src/kernel.asm
KERNEL_OBJ = $(BUILD_DIR)/kernel.o
KERNEL_BIN = $(BUILD_DIR)/kernel.bin

# Regras principais
all: iso

# Criar diretórios
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)
	mkdir -p $(ISO_DIR)/boot/grub

# Compilar kernel em objeto
$(KERNEL_OBJ): $(KERNEL_SRC)
	$(NASM) $(NASMFLAGS) $(KERNEL_SRC) -o $(KERNEL_OBJ)

# Linkar kernel
$(KERNEL_BIN): $(KERNEL_OBJ)
	$(LD) $(LDFLAGS) -o $(KERNEL_BIN) $(KERNEL_OBJ)

# Criar ISO
iso: $(BUILD_DIR) $(KERNEL_BIN)
	cp $(KERNEL_BIN) $(ISO_DIR)/boot/
	echo "menuentry \"My Kernel\" { multiboot /boot/kernel.bin boot }" > $(ISO_DIR)/boot/grub/grub.cfg
	$(GRUB) -o kernel.iso $(ISO_DIR)

clean:
	rm -rf $(BUILD_DIR) $(ISO_DIR) *.iso

.PHONY: all clean iso