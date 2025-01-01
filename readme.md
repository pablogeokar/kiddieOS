# 1. Dependências para desenvolvimento

- NASM (compilador de códigos assembly) (https://www.nasm.us/)

# 2. Gerar imagem ISO

## 2.1 Gerar arquivo binário

```bash
nasm -f bin src/boot.asm -o bin/boot.bin
nasm -f bin src/kernel.asm -o bin/kernel.bin
```

## 2.2 Crie um Arquivo de Sistema de Arquivos

Esse comando cria um arquivo chamado floppy.img com espaço suficiente para armazenar 2880 setores de 512 bytes (equivalente a um disquete de 1,44 MB).

```bash
#dd if=/dev/zero of=img/floppy.img bs=512 count=2880
# Criar uma imagem vazia de 1.44MB (disquete)
# dd if=/dev/zero of=img/floppy.img bs=1024 count=1440
```

## 2.3 Copie o Bootloader para o Primeiro Setor

Copie o arquivo boot.bin para o início do arquivo floppy.img aqui, usamos conv=notrunc para garantir que o arquivo original não seja truncado.

```bash
#dd if=bin/bootloader.bin of=img/floppy.img bs=512 count=1 conv=notrunc
#dd if=bin/kernel.bin of=img/floppy.img bs=512 seek=1 conv=notrunc

# Escrever o bootloader no primeiro setor
#dd if=bin/bootloader.bin of=img/floppy.img conv=notrunc

# Escrever o kernel logo após o bootloader
#dd if=bin/kernel.bin of=img/floppy.img seek=1 conv=notrunc


# dd if=/dev/zero of=img/system.img bs=1024 count=1440
# dd if=bin/boot.bin of=img/system.img conv=notrunc
# dd if=bin/kernel.bin of=img/system.img seek=1 conv=notrunc


dd if=/dev/zero of=disk.img bs=512 count=2880
dd if=bin/boot.bin of=disk.img bs=512 count=1 conv=notrunc
dd if=bin/kernel.bin of=disk.img bs=512 seek=1 conv=notrunc

```

## 2.4 Crie a Imagem ISO

Use o utilitário mkisofs para criar uma imagem ISO bootável a partir do arquivo floppy.img:
Aqui está o que cada opção faz:

- -o bootable.iso: Define o nome do arquivo ISO de saída.
- -b floppy.img: Define o arquivo de boot (emulando um disquete).
- -c boot.catalog: Cria um catálogo de boot (recomendado para compatibilidade).
- -no-emul-boot: Especifica que o arquivo de boot não é uma emulação de sistema operacional completo.

```bash
# mkisofs -o iso/bootable.iso -b img/system.img -c boot.catalog -no-emul-boot -boot-load-size 4 -boot-info-table .
mkisofs -o bootable.iso -b disk.img -c boot.catalog -no-emul-boot -boot-load-size 4 -boot-info-table .

```

qemu-system-x86_64 -drive format=raw,file=disk.img

# qemu-system-x86_64 -fda img/floppy.img

# qemu-system-x86_64 -cdrom bootable.iso

nasm -f bin src/boot.asm -o bin/boot.bin
nasm -f bin src/kernel.asm -o bin/kernel.bin

dd if=/dev/zero of=disk.img bs=512 count=2880
dd if=bin/boot.bin of=disk.img bs=512 count=1 conv=notrunc
dd if=bin/kernel.bin of=disk.img bs=512 seek=1 conv=notrunc

qemu-system-x86_64 -drive format=raw,file=disk.img
