# LOST-R
Estudo sobre sistemas operacionais

# Instalação de ferramentas do ambiente
```bash
$ sudo apt install build-essential qemu nasm
```

## Tradução e Montagem da imagem
Aqui é o código para criação do binário
```bash
$ nasm boot.asm -f bin -o boot.bin
```

Aqui é a criação da imagem
```bash
$ cp boot.bin boot.img
```

Aqui vou deixar o tamanho igual a de um disquete
```bash
$ truncate -s 1440k boot.img
```

Aqui vou emular o disquete no QEMU:
```bash
$ qemu-system-i386 -drive file=boot.img,format=raw,index=0,if=floppy
```