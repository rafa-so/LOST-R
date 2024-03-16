# Introdução
O objetivo deste arquivo é documentar e reunir todas as instruções vistas em aulas. Vai facilitar a leitura depois, fora que deixo o contexto de aula e contexto de código bem definido.

# Chamadas de Sistema
São chamadas que o programa em `asm` fará para o kernel do `S.O.`. Existem dois tipos de chamadas. A primeira é a `siscall` e a outra é por `interrupções`.

## Syscall
A `syscall`, que requer o uso de uma série de `registradores` antes da chamada explícita de `syscall`. Ela vai usar um intermediador `libc` ou `glibc`, dependendo do `SO` usado. É uma `instrução` dedicada para chamada de sistema.

Existe uma vantagem técnica sobre as interrupções, pois elas são mais `rápidas` que essa última, e não tem conseguência direta ou indireta sobre `registradores`.

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
