## Por que aprender assembly?

 - Entender como os programas funcionam
 - Entender como o SO funciona
 - Entender como o hardware Funciona
 - Otimização de programas
 - Engenharia reversa e testes de segurança
 - Programação "bare metal"
 - Programação de microconsoladores
 - Programação de drivers

## Notas
 - Ele é diferente de tudo, e não tem o conceito de tipos de dados
 - Abstração também é um conceito mais rarefeita. Existe sim a abstração, a própria linguagem, mas não tem a abstração da linguagem de alto nível
 - Não existe a pré definição de tipos. Para o processador e para a linguagem não interessa.
 - Não tem também estrutura de decisão, é feito tudo por flags, registrador específico
 - Não existe variável, é trabalhado diretamente na memória
 - Não existe parâmetros também

> Objetivo é manipular dados da memória principal e dos registradores usandos instruções da CPU

## Ferrametas
- Editor de texto: VIM
- Montador (assembler): NASM
- Linkador (linker): GNU ld
- Compilador: GNU GCC
- Makefiles: GNU MAKE
- Depurador: GNU debugger (GDB)

- Editor hexadecimal: hexeditor
- Hex Editor: xxd

## Código de operação
código que é usado pela máquina para executar as suas próprias operações

```asm
    MOV EAX, 1
    MOV EBX, 0
```
é um exemplo de código de operação. Neste exemplo estaria passando o número 1 para o registrador EAX e o número 0 para o EBX.

Em código de máquina seria:
```
MOV EAX = b8
1       = 01 00 00 00 (Little ending)
MOV EBX = bb
0       = 00 00 00 00
```

> Diferente de endereço de memória registrador tem nome. 

## O que é assembly?

É uma linguagem de montagem, que permite humanos entenderem a linguagem de máquina.

### Linguagem de montagem (Assembly)
- Nomes para instruções da CPU
- Nomes para registradores da CPU
- Rótulos para endereços da memória
- Dados como números

### Montador (Assembler)
- Produz arquivos binários (objeto)
- Código do programa
- Dados utilizados pelo ligador

### Ligador (Linker)
- Gera binários executáveis
- Organiza seções e símbolos

