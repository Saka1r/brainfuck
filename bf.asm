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

	push rax
    push rbx
    push rcx
    push r11
    push rdi
    push rsi
    push rdx

	mov rax, 0 ;sys_read
	mov rdi, 0 ;stdin
	mov rsi, rbx
	mov rdx, 1 ; one byte
	syscall
	
	pop rdx
    pop rsi
    pop rdi
    pop r11
    pop rcx
    pop rbx
    pop rax	

	jmp     next_instruction

find_open:
    dec r14 
    
    cmp r14, code
    jl exit_program         
    
    movzx rax, byte [r14]
    
    cmp al, ']'
    je inc_depth_back      
    
    cmp al, '['
    je dec_depth_back      
    
    jmp find_open

inc_depth_back:
    inc r13
    jmp find_open

dec_depth_back:
    dec r13
    cmp r13, 0
    je found_match
    jmp find_open

skip_bracket:
    jmp next_instruction

inc_depth:
    inc r13                
    jmp find_close

dec_depth:
    dec r13                
    cmp r13, 0
    je found_match      
    jmp find_close

found_match:
    mov rcx, r14
	dec rcx                
    jmp next_instruction

find_close:
    inc r14                
    
    cmp r14, r12
    jge exit_program       
    
    movzx rax, byte [r14]  
    
    cmp al, '['
    je inc_depth          
    
    cmp al, ']'
    je dec_depth          
    
    jmp find_close        

cmd_open_bracket:
	cmp byte [rbx], 0
	jne skip_bracket

	mov r13, 1
	mov r14, rcx
	jmp find_close

cmd_close_bracket:
	cmp byte [rbx], 0
    je skip_bracket       
    
    mov r13, 1             
    mov r14, rcx
	jmp find_open

next_instruction:
    inc rcx 
    jmp main_loop

exit_program:
    mov     rax, 60                 ; sys_exit
    xor     rdi, rdi                ; exit code = 0
    syscall
