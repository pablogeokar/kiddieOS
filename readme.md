# KiddieOS - Sistema operacional para estudos

## 1. Ambiente de desenvolvimento

Foi utilizado o Linux Ubuntu na arquitetura x86_64 com processador da linha intel, o código atual só funcionará corretamente para esta arquitetura.

Todo o código foi compilado utilizando a versão <b>2.16.01</b> do Nasm, acredito que versões anteriores e posteriores devem funcionar, até este momento do código não foi necessário nenhuma diretiva que funcione em uma função específica, é claro que precisamos manter coerência e não utilizar versões tão distantes da que utilizamos aqui.

Estes fontes são baseados na playlist [Curso "Desenvolvendo Sistemas Operacionais Simples" em Assembly](https://www.youtube.com/watch?v=Jws7BHrts6g&list=PLsoiO2Be-2z8BfsSkspJfDiuKeC9-LSca) do instrutor Francis pode conter algumas modificações e readaptações de acordo com a nossa necessidade.

- [NASM (compilador de códigos assembly)](https://www.nasm.us/)

## 2. Compilando os fontes

### 2.1 Gerar os arquivos binários

```bash
nasm -f bin src/boot.asm -o bin/boot.bin
nasm -f bin src/kernel.asm -o bin/kernel.bin
```

### 2.2 Gerando a imagem para testes

Esse comando cria um arquivo chamado disk.img com espaço suficiente para armazenar 2880 setores de 512 bytes (equivalente a um disquete de 1,44 MB).

```bash
dd if=/dev/zero of=disk.img bs=512 count=2880
dd if=bin/boot.bin of=disk.img bs=512 count=1 conv=notrunc
dd if=bin/kernel.bin of=disk.img bs=512 seek=1 conv=notrunc
dd if=bin/window.bin of=disk.img bs=512 seek=2 conv=notrunc
```

### 2.3 Gerando a imagem ISO (opcional, utilizar Se quiser testar usando VirtualBox )

Use o utilitário mkisofs para criar uma imagem ISO bootável a partir do arquivo disk.img:
Aqui está o que cada opção faz:

- -o bootable.iso: Define o nome do arquivo ISO de saída.
- -b disk.img: Define o arquivo de boot (emulando um disquete).
- -c boot.catalog: Cria um catálogo de boot (recomendado para compatibilidade).
- -no-emul-boot: Especifica que o arquivo de boot não é uma emulação de sistema operacional completo.

```bash
mkisofs -o bootable.iso -b disk.img -c boot.catalog -no-emul-boot -boot-load-size 4 -boot-info-table .
```

## 3. Testar na máquina virtual usando o QEMU

```bash
qemu-system-x86_64 -drive format=raw,file=disk.img
```

## 4. Visualização rápida dos binários em hexadecimal

```bash
hexdump -C bin/boot.bin
```

## 5. Principais dúvidas e suas soluções:

#### Tentei algumas opções na minha UEFI/BIOS, mas na máquina real, o KiddieOS só mostra um cursor piscando numa tela preta, já no VB, mostra o proposto.

R-> Tenta verificar no seu Setup da máquina real se você tem opção para ir pro Modo legado, exemplo: USB Legacy. E desativar a UEFI para ir pro modo BIOS. Isto é porque o sistema KiddieOS utiliza da BIOS, computadores que configurações mais atuais pode não permitir a execução de algumas funcionalidades do KiddieOS.
