%include 'env/_data.inc'
extern error_argv

section .text
  global my_printf, my_readfile, len_rsi

len_rsi:
  ;args [rsi: string]
  xor rcx, rcx              ; Zera rcx para usar como contador
.loop:
  cmp byte [rsi + rcx], 0  ; Compara o próximo byte com '\0' (fim da string)
  je .end                   ; Se for '\0', a string terminou, então saia do loop
  inc rcx                   ; Incrementa o contador
  jmp .loop                 ; Repete o loop para o próximo byte da string
.end:
  mov rdx, rcx              ; Move o comprimento da string para rdx
  ret


my_printf:     
  ;args [rsi: string]
  call len_rsi

  mov rdi, FORMAT_STRING          ; format string
  mov rax, WRITE                ; sys_write (1)
  mov rdi, STDOUT                ; stdout (1)
  syscall
  
  ret                       ; end

my_readfile:
  ; Obtém argc do topo da pilha (em [rsp])
  mov ecx, [rsp+16+8]

  ; Verifica se há pelo menos 3 argumentos (incluindo o nome do programa)
  cmp ecx, 3
  jb error_argv

  ; Obtém o ponteiro para o terceiro argumento (argv[2]) da pilha
  mov rsi, [rsp + 16 + 8]  ; argv[2] está em [rsp + 8 + 16] devido ao layout da pilha

  call len_rsi
  
  mov rax, WRITE            ; Número da syscall para sys_write (1)
  mov rdi, STDOUT            ; Descritor de arquivo para stdout (1)
  syscall               ; Chama o sistema para escrever a string

  ; ... (seu código para sair ou tratar o erro)
  ret