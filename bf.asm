; author: Saka1r
; license MIT
; brainfack

section .bss
	tape		resb 30000 ; Лента данных
	code		resb 65536 ; Буфер для исх. кода
	code_len	resq 1 ; Длина прочитанного кода

section .text
	global _start

_start:
	mov rdi, 0 
	mov rsi, code 
	mov rdx, 65536 
	mov rax, 0 
	syscall

	mov [code_len], rax

	mov rbx, tape ;data pointer
	mov rcx, code ;instruction pointer
	mov r12, [code_len]
	add r12, code 

	movzx rax, byte [rcx] 


