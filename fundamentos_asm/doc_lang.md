# Introdução
O objetivo deste arquivo é documentar e reunir todas as instruções vistas em aulas. Vai facilitar a leitura depois, fora que deixo o contexto de aula e contexto de código bem definido.

# Chamadas de Sistema
São chamadas que o programa em `asm` fará para o kernel do `S.O.`. Existem dois tipos de chamadas. A primeira é a `siscall` e a outra é por `interrupções`.

## Syscall
A `syscall`, que requer o uso de uma série de `registradores` antes da chamada explícita de `syscall`. Ela vai usar um intermediador `libc` ou `glibc`, dependendo do `SO` usado. É uma `instrução` dedicada para chamada de sistema.

Existe uma vantagem técnica sobre as interrupções, pois elas são mais `rápidas` que essa última, e não tem conseguência direta ou indireta sobre `registradores`.

### Syscall `sys_read` ou `read` (id: 0)
Esta chamada representa a entrada de dados, que no nosso contexto atual, vai usar o arquivo principal (descritor de arquivo), que é o teclado.

Segue exemplo em `asm`:
```asm
  mov rax, 0    ; Passado o id da `syscall` que se quer usar
  mov rdi, 0    ; Identificador do `descritor de arquivo`
  mov rsi, name ; Rótulo de reserva de espaço em memória previamente feito
  mov rdx, 50   ; Valor que representa o espaço reservado pelo `rótulo`
  syscall
```




### Syscall `sys_write` ou `write` (id: 1)
Esta chamada ela é exatamente a chamada que foi feita em todos os outros códigos para apresentar valores na saída de arquivo principal, leia-se, monitor.
```
             RAX    RDI            RSI                 RDX
              ^      ^              ^                   ^
              |      |              |                   |
              |      |              |                   |
            --+-- ---+---  ---------+------------  -----+------
    ssize_t write (int fd, const void buf[.count], size_t count)
      |
      |
     RAX -> Retorno da `Chamada`  |
     RCI -> Próxima Instrução     |----| Syscall
     R!! -> Registrador de Flags  |
```
> Geralmente estas chamadas de sistema são apresentadas como protótipos, ou pegando um pouco do java.... interfaces. Não é apresentado implementação, mas é para ter uma ideia da argumentação necessária para usar a chamada.

#### Parâmetros
| Argumento | Observação | Registrador |
|-----------|------------|-------------|
| `write`   | Aqui é informado para o `syscall` qual chamada exatamente ele fará. No caso do código é por isso que é passado o `1`. O número `1` identificar que é exatamente a chamada de sistema `write` ou `sys_write` que eu desejo chamar. | `RAX` |
| `int fd`  | O descritor de arquivo aberto para escrita | `RDI` |
| `const void buf[.count]`| O endereço dos dados na memória | `RSI` |
| `size_t count` | O número de bytes que serão escritos | `RDX` |
> `buf` ou `buffer` são dados em memória que vão ser passados para um arquivo, ou persistidos de outra maneira. 

> `const` representa dados escritos mesmo de forma explícita e constante.

#### Retorno
| Item | Observação |
|------|------------|
| `ssize_t` | O número de bytes escritos, ou `-1` para erro |

O registrador `rax` recebe o retorno da chamada de sistema. Além disso, o registrador `rci`, por conta da instrução `syscall`, é atualizado com a próxima instrução que vai ser executada e o registrador `r11` é ajustado caso uma flag tenha sido modificada. Tudo isso por conta da chamada `syscall`.

A seguência de `registradores` não precisa ser respeitada na ordem, desde que todos estejam sendo usados com os valores corretos, mas no fringir dos ovos, a sequência é irrelevante.

Segue exemplo de `syscall` em `asm`:
```asm
  mov rax, 1       ; Indicação do identificador da `syscall`
  mov rdi, 1       ; Identificador do `descritor de arquivo`
  mov rsi, msg_01  ; Passagem de rótulo da mensagem definida anteriormente
  mov rdx, len_01  ; Passagem do tamanho dos bytes da mensagem 
  syscall
```

### Syscall `sys_exit` ou `exit` (id: 60)
Essa chamada de sistema informa ao `SO` e ao processador, o termino do processo atual, o término do programa.

``` 
                       RAX       RDI
                        ^         ^
                        |         |
                      --+--  -----+-----
    [[noreturn]] void _exit (int status)
```

#### Parâmetros
| Argumentos | Observações | Registradores |
|-|-|-|
| `_exit` | Aqui é passado o valor `60` para o registrador `RAX`. Este valor em `decimal` ou o valor em `hexadecimal`, já informa a saída do sistema. | `RAX`|
| `int status` | Este é o valor que vai ser informado ao `kernel` se houve sucesso ou não na execução do programa. Se for `0`, houve sucesso, e não precisará fazer nada, senão, houve algum tipo de erro. | `RDI` |

Segue um exemplo da `syscall` em `asm`:
```asm
  mov rax, 60  ; Identificador da `syscall`
  mov rdx, 0   ; Retorno com sucesso
  syscall
```

# ASM
Aqui vou descrever as instruções em `asm`.

## mov
Instrução que move valores ou referências para determinados `registradores`.

Exemplo:
```asm
  mov rax, 1
```
Move o valor `1` para o registrador `rax`, pode ser para chamar uma `syscall` mais tarde.

## syscall
Instrução que faz chamada a funções do `kernel`, conforme a parametrização dos registradores. Ver mais detalhadamente na seção de `syscalls`.

## inc
Instrução que coloca no registrador indicado a referência para o próximo espaço em memória.

Exemplo:
```asm
  mov r8, name
  inc r8
```
Aqui movimento para `r8` a primeira referência de memória do rótulo `name`. 
> Este registrador não é influenciado por flags, então ele é muito usado para valore temporários.

A instrução `inc` pega essa referência e incrementa guardando no `registrador` informado, neste caso, `r8`.

## cmp
Faz uma comparação entre o byte informado, com o valor de referência.
```asm
  section .data
    name: db "rafael", 10

  section .text
    cpm byte[name], 10
```
Aqui ele vai fazer uma comparação entre o primeiro byte que está sendo referênciado pelo rótulo `name` com o valor de referência `10` que é o caracter de quebra de linha, ou o `\n`.

## jne
Essa instrução é um `jumper`. No entanto, só vai acontecer, e a comparação antes feita não for igual. Vamos pegar exemplo anterior.
```asm
  section .data
    name: db "rafael", 10

  section .text
    mov r8, name

    _print:
      mov rax, 1
      mov rdi, 1
      mov rsi, r8
      mov rdx, 1
      syscall

      inc r8
      cmp byte[r8], 10
      jne _print
```
Se a comparação não for verdadeira,ou seja, se o `char` não for uma `quebra de linha`, o `jne` vai "pular" para a instrução informada, no caso, ela mesma. Esse exemplo, é um exemplo de recursão em `asm`.