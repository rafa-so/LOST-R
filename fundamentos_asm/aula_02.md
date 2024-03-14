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
