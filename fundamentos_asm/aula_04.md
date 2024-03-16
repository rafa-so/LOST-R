# Chamada de Sistema
Essas chamadas são tratadas pelo kernel, e mesmo assim, temos uma intermediação entre kernel e source. Quem faz essa mediação é a biblioteca `libc` ou `glibc` (essa última, se estiver usando GNU/linux).

Para vários sistemas operacionais pode haver uma ligeira portabilidade, mas sempre há a necessidade de prestar atenção em registradores que estão sendo usados ou o que está sendo passado para eles. Mas geralmente há uma portabilidade relativamente tranquila.

## Modelo
Existe um modelo já pré definido de acesso a essas `chamadas`. Vamos ter chamadas de até `6 registradores` como segue:
| id | Param 01 | Param 02 |Param 03 |Param 04 |Param 05 |Param 06 | Retorno |
|-|-|-|-|-|-|-|-|
|`rax`| `rdi` | `rsi` | `rdx` | `r10` | `r8` | `r9` | `rax` |

Sempre que usar uma syscall, esta vai ser mais ou menos os registradores que serão usados.

Estes são `registradores` que são influenciados pela `syscall`, mas não tem a ver com a função da `operação` em si.
| Próxima Instrução | Conteúdo de flags |
|-|-|
|`rcx` | `r11` |

Existe também o modela para as `interupções`:
| id | Param 01 | Param 02 |Param 03 |Param 04 |Param 05 |Param 06 | Retorno |
|-|-|-|-|-|-|-|-|
|`eax`| `ebx` | `ecx` | `edx` | `esi` | `edi` | `ebp` | `eax` |

> Lembrando que os identificadores das `syscalls` podem, e geralmente serão, bem diferentes das `interrupções`.

## Syscall `sys_write`
Chamada de sistema que é responsavel pela apresentação de dados em qualquer tipo de saída, seja ela padrão (monitor), ou arquivos. Ela é detalhada no arquivo de `doc_lang`.

## Syscall `exit`
Chamada de sitema que informa a saída, o término do processo atual. É a última linha antes do programa realmente terminar sua execução pelo sistema operacional.
Para mais detalhes, visitar o `doc_lang`.

