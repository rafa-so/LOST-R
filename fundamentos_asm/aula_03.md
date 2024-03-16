Vamos dar prosseguimento a análise do código ´salve´, assim como a análise do layout de memória.

Para efeito de layout, a instrução `global _start` vai dar por volta do endereço de memória `0x1000` (4096) e o conteúdo da seção `.data` vai ter início por volta do byte `0x2000` (8192).

# Estrutura montada X Estrutura codificada

Aqui é mais ou menos uma relação sobre o que está apresentado no código de máquina, no binário com o que foi escrito no .asm .

| Binário | ASM | Observação |
|---------|-----|------------|
|`b8 01 00 00 00` | `mov rax, 0x00000001` | Aqui o `b8` equivale a instrução `mov rax` do asm. O restante da instrução é só valor atribuído, com o caracter mais importante na frente. Esta instrução, como já falado, é uma parametrização para a chamada de sistema `sys_write`. |
|`bf 01 00 00 00`| `mov rdi, 0x00000001` | Mesmo caso do de cima, a diferença aqui é que `bf` equivale a `mov rdi` em asm. Este cara ele avisa qual descritor de arquivo queremos, que no nosso caso é a saída padrão, monitor, que é descrita pelo valor `0x01`, ou seja o `/dev/stdout`.|
| `48 be 00 20 40 00` | `mov rsi, 0x402000` | Neste caso a instrução vai ser traduzida para 2 bytes de tamanaho na montagem. `mov rsi` equivale a `48 be`. Neste caso também é passado o ponteiro que está a mensagem "salve simpatia!". Se for reparar, este endereço é exatamente o endereço em memória que a string (cadeia de caracteres) está alocada. |
| `ba 11 00 00 00 ` | `mov rdx, 0x11` | Aqui estou movendo para o registrador o valor, já pré processado, do tamanho da cadeia de caracteres. Este valor está em hexadecimal, mas se formos traduzir para decimal, fica 17, exatamente o tamanho da `string`.
| `0f 05` | `syscall` | Equivale a chamada de sistema |
> Estas são instruções que estão dentro do rótulo `_start` do nosso arquivo `salve.asm`. 

Agora vamos ver uma outra tabela contendo quase as mesmas instruções, só que na seção `_end`, que por fator de organização e legibilidade, serve para dizer ao `kernel` que a aplicação foi encerrada com sucesso.
| Binário | ASM | Observação |
|---------|-----|------------|
| `b8 c3 00 00 00` | `mov rax, 0x3c` | O hex `b8` já vimos que equivale a instrução `mov rax`. Neste contexto, a diferença é o que está sendo passado para o registrador. Aqui temos uma outra chamada de sistema que em dicimal é `60`. Esta instrução vamos fazer uma chamada ao sistema, retornando um valor a ele. 
| `bf 00 00 00 00` | `mov rdi 0x00` | Aqui temos ao invés do `descritor do arquivo`, temos um `valor de retorno`. Aqui o `kernel` espera: 0 - para execução com sucesso, ou !0 (qualquer outro valor até 255) - para qualquer coisa diferente de sucesso.
| `0f 05` | `syscall` | Equivale a chamada de sistema. Executa de fato as `chamadas de sistema`, conforme os registradores e seus repectivos valores |
> Todas as instruções que são apresentadas são uma convensão devererá ser seguida. Vai ser visto isso de uma forma melhor um pouco mais para frente, mas é importante ter isso em mente. É uma convensão.

## Layout de memória
Como vimos em outros momentos, todos os programas vão respeitar um layout de memória, que se dá pelo `processo`. Este processo é também gerenciado pelo `kernel`. Este processo vai mapear a memória e o programa não vai acessar exatamente o endereço real e físico da memória dentro do processo. Para o programa isso é completamente transparente. Tanto que eu posso ter um endereço `0x402000` sendo acessado por um processo e por outro processo que não tem relação um com o outro.

Quem faz essa gerência de endereços de `memória real` e recursos de `hardware` é o próprio `kernel` através de uma `tabela de conversão`. É um de/para de endereços reais e endereços que são vistos pelos processos.

> Um questão interessante, é que desde o `cabeçalho ELF` já é apresentado e informado a quantidade de memória necessária para alocação. Não é uma série de bytes que é apenas copiado e colado, tem informações para o kernel entender a quantidade de memória que será necessária para o binário.

