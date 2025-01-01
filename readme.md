# 1. Dependências para desenvolvimento

- [NASM (compilador de códigos assembly)](https://www.nasm.us/)

# 2. Gerar imagem do sistema

## 2.1 Gerar os arquivos binários

```bash
nasm -f bin src/boot.asm -o bin/boot.bin
nasm -f bin src/kernel.asm -o bin/kernel.bin
```

## 2.2 Crie um Arquivo de Sistema de Arquivos

Esse comando cria um arquivo chamado disk.img com espaço suficiente para armazenar 2880 setores de 512 bytes (equivalente a um disquete de 1,44 MB).

```bash
dd if=/dev/zero of=disk.img bs=512 count=2880
dd if=bin/boot.bin of=disk.img bs=512 count=1 conv=notrunc
dd if=bin/kernel.bin of=disk.img bs=512 seek=1 conv=notrunc
```

## 2.3 Crie a Imagem ISO (opcional, utilizar Se quiser testar usando VirtualBox )

Use o utilitário mkisofs para criar uma imagem ISO bootável a partir do arquivo floppy.img:
Aqui está o que cada opção faz:

- -o bootable.iso: Define o nome do arquivo ISO de saída.
- -b disk.img: Define o arquivo de boot (emulando um disquete).
- -c boot.catalog: Cria um catálogo de boot (recomendado para compatibilidade).
- -no-emul-boot: Especifica que o arquivo de boot não é uma emulação de sistema operacional completo.

```bash
mkisofs -o bootable.iso -b disk.img -c boot.catalog -no-emul-boot -boot-load-size 4 -boot-info-table .
```

# 3. Testar na máquina virtual usando o QEMU

```bash
qemu-system-x86_64 -drive format=raw,file=disk.img
```
