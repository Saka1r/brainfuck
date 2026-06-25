; author: Saka1r
; license MIT
; brainfack

DEFAULT REL

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

	mov [code_len], rax

	mov rbx, tape ;data pointer
	mov rcx, code ;instruction pointer
	mov r12, [code_len]
	add r12, code 
	
main_loop:

	cmp rcx, r12
	jae exit_program

	movzx rax, byte [rcx] 

	cmp al, '>'
    je  cmd_right

    cmp	al, '<'
    je  cmd_left

    cmp al, '+'
    je  cmd_plus

    cmp al, '-'
    je  cmd_minus

    cmp al, '.'
    je  cmd_dot

    cmp al, ','
    je  cmd_comma

    cmp al, '['
    je  cmd_open_bracket

    cmp al, ']'
    je  cmd_close_bracket

	jmp	next_instruction

cmd_right:
    ; TODO: проверить, не вышли ли за конец ленты
	inc rbx
    jmp     next_instruction

cmd_left:
    ; TODO: проверить, не вышли ли за начало ленты
	dec rbx
    jmp     next_instruction

cmd_plus:
	add byte [rbx], 1
    jmp     next_instruction

cmd_minus:
	sub byte [rbx], 1
    jmp     next_instruction

cmd_dot:
	push rax
    push rbx
    push rcx
    push r11
    push rdi
    push rsi
    push rdx


	mov rax, 1 ; sys_write
	mov rdi, 1 ; stdout
	mov rsi, rbx ; address
	mov rdx, 1
	syscall

	pop rdx
    pop rsi
    pop rdi
    pop r11
    pop rcx
    pop rbx
    pop rax	

    jmp     next_instruction

cmd_comma: 
    jmp     next_instruction

cmd_open_bracket: 
    jmp     next_instruction

cmd_close_bracket: 
    jmp     next_instruction

next_instruction:
    inc rcx 
    jmp main_loop

exit_program:
    mov     rax, 60                 ; sys_exit
    xor     rdi, rdi                ; exit code = 0
    syscall
