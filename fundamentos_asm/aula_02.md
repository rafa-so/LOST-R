# Aula 02

## Seções e Segmentos de dados
### Seções
As seções `.data` e `.text` são usadas no momento da linkedição do nosso código, neste momento da compilação do código.

```asm
section .data

section .text
    global _start

_start:
    ; Código qualquer
```
De maneira geral, seções são uma forma de organizar os dados escritos no arquivo binário *durante a linkedição*.

São blocos de código usados para definir informações para o programa que vai fazer a ligação.

| Seções | Observação |
|--------|------------|
| .text  | É a seção que vai se encontrar de fato o nosso source, o nosso código que será de fato executado. O código presente nesta seção, é o que vai ser transformado em código de máquina no final do processo de compilação. |
|.rodata| No **Windows** esta seção se chamará *rdata*. O objetivo desta seção é indicar valores que serão apenas lidos. Normalmente este valores ja são imcorporados na seção *.text*, e constantes lidas antes do arquivo ser realmente executado. Por isso esta seção não é tão usada. As constantes aqui definidas vão ser incorporadas ao segmento .text no momento da linkedição, e elas também são diferentes das constantes declaradas em .data .|
|.data| Esta seção é responsável por agrupar as "variáveis" que queremos inicializar. Na verdade ela é responsável por agrupar o espaço de memória que queremos já injetar valor. Neste contexto aqui também elas são usadas mais como constantes propriamente ditas. Como valores fixos não variáveis. Além disso, o conceito aqui de `var` é mais uma analogia. Neste tipo de linguagem não tem exatamente uma formalidade de variável. Por mais que rótulos sejam usados, eles não representam exatamente variáveis e sim endereços de memória.|
|.bss| Esta seção é justamente o contrário da *.data*, ela é responsável por agrupar as "variáveis" (ou espaço de memória) que não queremos por enquanto inicializar. Vem de *Block Starting Symbol*|

Relativo a seção _start, ela está presente no binário, e é normalmente usada para informar ao linkeditor o entrypoint do programa. Isso, é uma convensão usada por padrão pelo próprio `ld`. Caso necessite mudar, é passar o parâmetro `-e` passando o nome do entrypoint para o `ld`.

==O nome dessas seções já estão pré definidas pelo NASM==
****
Estas seções acima são as seções padrões do NASm, mas pode-se criar quantas seções quisermos, com o nome que quisermos também. Estas seções padrão são as que tem seus parâmetros configurados pelo **assemblador**.

### Segmentos
Segmentos de dados são muitas vezes intercambiáveis com as seções. Elas também se referem a blocos de código, no entanto, elas partem do ponto de visto do sistema operacional que vai executar o código.

### Layout de memória
==Processos não são software em execução, são estruturas de dados==

![layout de memória](https://i.imgur.com/eyK4MZM.png)

### Chamadas de Sistema
São métodos para acessar funcionalidades do Kernel. 

Estas chamadas são definidas em libs de C padrão `libc` (UNIX) ou `glibc` (GNU/LINUX).

As convensões de chamadas de sistema são especificadas pela *Interface de Abstraçao Binária* (ABI), que determina quais registradores deverão receber os argumentos de cada chamada de sistema.

Na arquitetura x86_64, as chamadas de sistema são executadas pela instrução `Syscall`.

Na arquitetura x86 as chamadas de sistema são executadas pela instrução `int 0x80`.

### Rótulos
Eles são identificadores para endereço de memória. Servem para fazermos saltos para diferentes partes da aplicação, ou para identificarmos mesmo dados da memória. Eles podem ser criados livremente, mas o `_start`, como já explicado em uma seção anterior, é usado para identificar o entrypoint. Pelo menos o `ld` identifica o `_start` como entrypoint padrão (podendo ser alterado, como o `C Lang` faz).

#### Global
Esta diretiva é usada para expor símbolos para o código objeto. neste sentido é usado o `_start` para expor este símbolo no momento que o `ld` estiver fazendo o código objeto. Além disso, no momento da linkedição, o `linker` vai entender que este é o `entrypoint` mesmo que o arquivo esteja "importando" vários outros.

#### MSG
Nesta parte, é mais um identificador, que apenas aponta para um espaço em memória que será usado para guardar um determinado dado. Neste sentido, "Salve, simpatia\n". Além da localização, precisamos entender o tamanho em bytes que serão ocupados pelo dado.

```asm
    msg: db "Salve, Simpatia", 10
 ```

Aqui temos uma cadeia de caracteres, que em linguagem de alto nível são chamadas de `String`. Elas podem ser representadas tanto por aspas simples ou duplas. Separando por vírgula, podemos usar representação em decimal para um determinado caracter, por exemplo:

```asm
    "Salve, Simpatia", 10
 ```

 O caracter `10` representa uma quebra de linha, ou mais conhecido como `\n`. Com a vírgula na `string` podemos representar o `\n` como `10`.
 
---
Se usarmos apenas os caracteres da tabela `ASCII`, não vamos precisar nos preocupar tanto, mas com relação a outras linguas do planeta, precisamos entender que podemos ter caracteres com mais de 2 bytes de comprimento.

Na língua portuguesa temos o `ç` que possui 2 bytes. Se ignoramos isso, podemos fazer uma contagem de bytes errônea. Exemplo:

```asm
    "coração"
```
A `string` não teria apenas 7 bytes, e sim 9, pois `ç` e `ã` temos 2 bytes cada caracter. Eles são conhecidos como `caracter multibyte`.

---

#### Pseudo-instrução 'db'
Esta instrução tem como objetivo definir uma cadeia de caracteres. Ela é uma simplificação de `Define Bytes`. Existe as subvariações da mesma, que em arquitetura x86_64 podemos definir cadeias de palavas, `dw`, cadeias de palavras duplas, `dd`, cadeia de palavras quaduplas, `dq` e assim sucessivamente. Nesta arquitetura as palavras terão de 2, 4 a 8 bytes de comprimento. 

Quanto maior os bytes, maior vai ser o binário, pois isso afeta diretamente a quantidade de bytes.

```asm
    db "Salve, Simpatia!"
```

Neste contexto estou definido uma cadeia de bytes, que vai ter exatamente o tamanho da `string`. Até por que também não tenho caracteres fora da tablela ASCII nesta `string`.

#### Tamanho da Mensagem
As cadeias de bytes são definidas na memória de forma sequencial de forma que o rótulo representa o início da cadeia e o caracter `$` representa sempre o local do último valor escrito. Para entendermos o tamanho da cadeia precisamos sempre recorrer a subtração (rótulo - último byte) como por exemplo:

```asm
    msg: db "salve", 10

    len: equ $ - msg
```

Neste momento tenho um rótulo com uma cadeia de 6 bytes. Sendo mais específico o `rótulo` na verdade apontaria para o início da cadeia. Já o `$` aponta para o último endereço ocupado na memória. Esta `len` já seria pré processada pelo `ld`, ou o linker que for, com o valor da subtração entre estes termos.

Um detalhe interessante é que esta operação deve ser feita sempre que se definir uma cadeia de caracter. Pois elas são guardadas em memória de forma sequencial, e o `$` é sempre o último endereço ocupado, não importa que cadeia seja. 

> sempre que definir uma nova string, deverá ser feita essa operação de length

Este detalhe do tamanho é importante, pois tenhos que já saber o tamanho dessa cadeia para manipular ela pelo código.

#### Pseudo instrução 'equ'
Esta pseudo-instrução ela é processada, no momento da linkagem, tornando o valor absoluto, ou constante na execução do software.

## Source
O código fonte asm nada mais é do que manipulação de valores em memória, além de manipulação de registradores na CPU.

### Registradores
Registradores é uma memória para uso exclusivo do processador. No caso de registradores de uso geral, podemos usar as suas subdivisões de 32, 16 e 8 bits. No caso da arquitetura x86_64, podemos armazenar até 64 bits de espaço, ou seja, 8 bytes. 

Com relação as subdivisões, temos o registrador `rax` que podemos acessar usando os seguintes nomes: `eax` (16 bits), `ax` (8 bits) (`ah` e `al`). Ainda com subdivisões, temos a parte alta (high) do registrador (`Xh`) e a parte baixa (`Xl`), sendo `X` a respectiva letra do registrador. Estas partes de 4 bits, vão ser usadas para as mais diversas operações pelo programa.

Muitos outros registradores também seguem esse padrão de nomes para as mais diversas porções de 32, 16 e 8 btis. Isso permite retro compatibilidade com outros arquiteturas.

#### Instruções
As instruções são *mneumônicos* que facilitam o uso de certas operações com o processador, sem isso, teríamos que saber exatamente o código de máquina para realizar as operações com a própria CPU. Estas operações seriam exatamente operações com os registradores e memória.

Para cada instrução há três possibilidades de operandos , chamados de *modo de direcionamento* (adderessing mode).

##### Registradores
 - Registradores de propósito geral (`rax`, `rbx`, `rcx`, `rdx` ...)
 - Registradores de índice (`rdi`, `rsi`, `rsp`, `rdp`)
 - Registradores de inteiros (`r8`, `r15`)

##### MOV
Instrução que copia dados entre registradores e endereços de memória

##### SYSCALL
Instrução que chama operações do sistema operacional, conforme dados copiados a certos registradores. Existe uma convenção de registradores para cada tipo de chamada ao sistema.

## Chamadas de Sistema
Como comentadado na seção imediatamente anterior, é a chamada do nosso sistema a operações específicas que são controladas pelo kernel:

- Manipulações de Arquivos
- Ler ou escrever dados em dispositivos de entrada e saída de dados
- Alocar espaço em memória
- Iniciar e terminar processos

Tratando-se de `syscalls` a ordem que que atribuimos os `registradores` não importa, no entanto, se trabalhamos com C/C++ é preciso respeitar ainda outros padrões previstos na `ABI`.

---

## Apresentação de caracteres na tela

Para este tipo de impressão é importante usar a `syscall` que é usada para escrever em arquivos. Para sistemas baseados em `UNIX` tudo tem representação em forma de arquivo incluindo o próprio hardware.

Dessa forma, o `/dev/stdout` é representação em arquivo do terminal. É dita também é a saída padrão. Esta saída padrão está disponível para escrita através de outro arquivo chamado *descritor de arquivos (FD)*. 

São links simbólicos que o kernel disponibiliza para processos manipularem arquivos. Por padrão existem três:

|FD|Dispositivo|Descrição|
|--|-----------|---------|
|0|`/dev/stdin`|Entrada Padrão (Teclado)|
|1|`/dev/stdout`|Saída Padrão (Display do terminal)|
|2|`/dev/tsderr`|Saída Padrão (Erro no display do terminal)|

> Estes descritores, dependendo do contexto, também podem ser chamdados de *File Handlers*.

### Escrita em tela
```asm
    mov rax, 1   ; Chamada de sistema `sys_write`
    mov rdi, 1   ; Descritor de arquivo (FD, stdout - Saída padrão)
    mov rsi, msg ; Ponteiro para a `string` que está em memória 
    mov rdx, len ; Constante com o tamanho da string
    syscall      ; Invoca a chamada do sistema
                 ; com os dados nos registradores
```
Aqui temos a operação para parametrizar uma chamada do sistema `sys_write`. 
```asm
    mov rax, 1
```

O `rax` é um registrador para uso geral e é parametrizando nele o valor `1` que conseguimos depois invocar a `syscall` correspondente a escrita na saída padrão. 

Precisamos definir o descritor de arquivo que vamos usar. No nosso caso é o 1, que é a saída padrão mesmo.
```asm
    mov rdi, 1
```

Apontaremos para a constante de `string` que temos neste caso. A ideia aqui é ser pedagógico, mas teremos mais dinamicidade depois.
```asm
    mov rsi, msg
```
Repare que `msg` é um rótulo que aponta exatamente para o início da string que o corresponde. Este rótulo tem que já estar presente em outra seção prévia.

É necessário também explicitarmos o tamanho que esta cadeia de caracter terá
```asm
    mov rdx, len
```
Repare, que conforme outros exemplos, `len`vai ser pré processado pelo `ld`, e no binário, `len` vai ser o próprio número de bytes. Esta operação não vai existir dentro do binário.

Tudo arrumado e explicitado, chamamos a operação no kernel
```asm
    syscall
```

### Terminando a aplicação
Para teminar de forma organizada, temos que parametrizar a operação.
```asm
    mov rax, 60
```
Esta chama já indica que quero chamar o `sys_exit`, para terminar este processo.

Preciso informar um "status" de sucesso. É com este código que o `SO` vai julgar se o programa foi bem finalizado ou não.
```asm
    mov rdi, 0
```

Qualquer coisa acima de `0` e entre `255`, o SO julgará que o processo não foi bem encerrado. Por padrão, quando o programa for encerrado com sucesso, ele ter que retornar `0`.

Por fim executar a chamada para o kernal através do `syscall`.

---