
sys_write	equ	1		; the linux WRITE syscall
sys_exit	equ	60		; the linux EXIT syscall
sys_stdout	equ	1		; the file descriptor for standard output (to print/write to)

length		equ	5		; the length of the string we wish to print (fixed string length of the arguments)

section .data
  readfile_error db "Error in read file", 0xA   ;
  format db "%s", 0xA, 0  ; Formato da string para printf
  readfIle_error_len equ $ - readfile_error            ; lenght string pointer
  
  linebreak	db	0x0A	; ASCII character 10, a line break

section .text
global my_printf, my_readfile

my_printf:
  mov rax, 1                ; sys_write (1)
  mov rdi, 1                ; stdout (1)
  syscall
  
  ret                       ; end

my_readfile:
  ; Obtém argc do topo da pilha (em [rsp])
  mov ecx, [rsp]

  ; Verifica se há pelo menos 3 argumentos (incluindo o nome do programa)
  cmp ecx, 2
  jb .argc_below_2

  ; Obtém o ponteiro para o terceiro argumento (argv[2]) da pilha
  mov rsi, [rsp + 16 + 8]  ; argv[2] está em [rsp + 8 + 16] devido ao layout da pilha

  ; Inicializa o contador de tamanho para 0
  xor rcx, rcx

  ; Calcula o tamanho da string (conta os caracteres até encontrar '\0')
.loop:
  mov al, [rsi + rcx]  ; Carrega o próximo caractere da string em AL
  cmp al, 0            ; Verifica se é o caractere de terminação de string
  je .string_end       ; Se for, a string terminou
  inc rcx              ; Incrementa o contador de tamanho
  jmp .loop            ; Repete o loop para o próximo caractere

.string_end:
  ; Agora rcx contém o tamanho da string em bytes

  ; Configura os registradores para a syscall sys_write
  mov rax, 1            ; Número da syscall para sys_write (1)
  mov rdi, 1            ; Descritor de arquivo para stdout (1)
  mov rdx, rcx          ; Tamanho do dado a ser escrito (tamanho da string)
  syscall               ; Chama o sistema para escrever a string

  ; ... (seu código para sair ou tratar o erro)

.argc_below_2:
  ; Se argc for menor que 3, faça algo ou apenas saia do programa
  xor edi, edi          ; Código de saída 0
  mov eax, 60           ; Número da syscall para sys_exit (60)
  syscall               ; Chama o sistema para sair