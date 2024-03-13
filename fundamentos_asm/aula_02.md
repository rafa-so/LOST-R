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
|.data| Esta seção é responsável por agrupar as "variáveis" que queremos inicializar. Na verdade ela é resonsável por agrupar o espaço de memória que queremos já injetar valor. Neste contexto aqui também elas são usadas mais como constantes propriamente ditas. Como valores fixos não variáveis.|
|.bss| Esta seção é justamente o contrário da *.data*, ela é responsável por agrupar as "variáveis" (ou espaço de memória) que não queremos por enquanto inicializar. Vem de *Block Starting Symbol*|

==O nome dessas seções já estão pré definidas pelo NASM==
****
Estas seções acima são as seções padrões do NASm, mas pode-se criar quantas seções quisermos, com o nome que quisermos também. Estas seções padrão são as que tem seus parâmetros configurados pelo **assemblador**.

### Segmentos
Segmentos de dados são muitas vezes intercambiáveis com as seções. Elas também se referem a blocos de código, no entanto, elas partem do ponto de visto do sistema operacional que vai executar o código.

### Layout de memória
==Processos não são software em execução, são estruturas de dados==

![layout de memória](https://i.imgur.com/eyK4MZM.png)
