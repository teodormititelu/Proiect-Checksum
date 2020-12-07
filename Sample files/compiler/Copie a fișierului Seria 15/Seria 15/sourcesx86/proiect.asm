.data

	n: .space 4
	m: .space 4
	mat: .space 1600
	linidx: .space 4
	colidx: .space 4
	index: .space 4
	roles: .space 80
	visited: .space 80
	queue: .space 80
	queueIndex: .space 4
	queueLength: .space 4 
	task: .space 4
	host_s: .space 4
	host_d: .space 4
	string: .space 100
	chr: .space 1
	
	switch: .asciz "switch index %d"
	switchm: .asciz "switch malitios index %d"
	host: .asciz "host index %d"
	controller: .asciz "controller index %d"
	
	yes: .asciz "Yes"
	no: .asciz "No"
	
	dpct: .asciz ": "
	pctv: .asciz "; "
	chr_a: .asciz "a"
	
	conex: .space 4
	counter: .space 4
	counter_ad: .space 4
	val: .space 4
	x: .space 4
	y: .space 4
	
	format_string: .asciz "%s"
	format_int: .asciz "%d"
	format_printf: .asciz "%d "
	newLine: .asciz "\n"

.text

.global main

main:

	push $n
	push $format_int
	call scanf
	pop %ebx
	pop %ebx
	
	push $m
	push $format_int
	call scanf
	pop %ebx
	pop %ebx
	
	lea mat, %edi 
	
	movl $0, linidx

init_mat:
	for_init_lines:
	
		movl linidx, %ecx
		cmp n, %ecx
		je read_mat
	
		movl $0, colidx
	
		for_init_columns:
	
			movl colidx, %ecx
			cmp n, %ecx
			je cont_for_init_lines
		
		movl linidx, %eax
		mull n
		addl colidx, %eax

		movl $0, (%edi, %eax, 4)

		addl $1, colidx
		jmp for_init_columns
		
cont_for_init_lines:

	addl $1, linidx
	jmp for_init_lines

read_mat:

	xor %ecx, %ecx
	mov %ecx, counter
	
for_read_mat:

	movl counter, %ecx
	addl $1, %ecx
	movl %ecx, counter
	
	push $x
	push $format_int
	call scanf
	pop %ebx
	pop %ebx
	
	push $y
	push $format_int
	call scanf
	pop %ebx
	pop %ebx
	
	movl x, %eax
	mull n
	addl y, %eax
	addl $1, (%edi, %eax, 4)
	
	movl y, %eax
	mull n
	addl x, %eax
	addl $1, (%edi, %eax, 4) 
	
	movl counter, %ecx
	cmp m, %ecx
	je init1
	
	jmp for_read_mat

init1:

	xor %ecx, %ecx
	movl %ecx, counter
	lea roles, %edi
	
for_read_roles:
	
	movl counter, %ecx
	addl $1, %ecx
	movl %ecx, counter
	
	push $x
	push $format_int
	call scanf
	pop %ebx
	pop %ebx
	
	movl counter, %ecx
	movl x, %eax
	subl $1, %ecx
	movl %eax, (%edi, %ecx, 4)
	
	movl counter, %ecx
	cmp n, %ecx
	je read_task
	
	jmp for_read_roles

read_task:

	push $task
	push $format_int
	call scanf
	pop %ebx
	pop %ebx
	
	movl task, %eax
	cmp $1, %eax
	je task1
	
	movl task, %eax
	cmp $2, %eax
	je task2
	
	movl task, %eax
	cmp $3, %eax
	je task3

task1:

	xor %ecx, %ecx
	movl %ecx, counter
	lea roles, %edi
	
for_roles:	
	
	movl counter, %ecx
	cmp n, %ecx
	je _exit
	
	mov (%edi, %ecx, 4), %eax
	
	cmp $3, %eax
	jne after_malitios
	
	movl counter, %ecx
	movl %ecx, index
	push %ecx
	push $switchm
	call printf
	pop %ebx
	pop %ebx
	
	push $0
	call fflush
	pop %ebx
	
	movl $4, %eax
	movl $1, %ebx
	movl $dpct, %ecx
	movl $2, %edx
	int $0x80
	
	lea mat, %edi
	xor %ecx, %ecx
	mov %ecx, counter_ad
	
	for_vecini:
		
		movl counter_ad, %ecx
		
		movl index, %eax
		mull n
		addl counter_ad, %eax
		
		movl (%edi, %eax, 4), %ebx
		
		cmp $1, %ebx
		jne cont_for_vecini
		
		lea roles, %edi
		
		movl counter_ad, %ecx
		mov (%edi, %ecx, 4), %eax
		
		mov %eax, val
		
		_host:
		
			cmp $1, %eax
			jne _switch
			
			movl counter_ad, %ecx
			push %ecx
			push $host
			call printf
			pop %ebx
			pop %ebx
	
			push $0
			call fflush
			pop %ebx
	
			movl $4, %eax
			movl $1, %ebx
			movl $pctv, %ecx
			movl $2, %edx
			int $0x80
			
			jmp cont_for_vecini
			
		_switch:
		
			movl val, %eax
			cmp $2, %eax
			jne _switchm
			
			movl counter_ad, %ecx
			push %ecx
			push $switch
			call printf
			pop %ebx
			pop %ebx
	
			push $0
			call fflush
			pop %ebx
	
			movl $4, %eax
			movl $1, %ebx
			movl $pctv, %ecx
			movl $2, %edx
			int $0x80
			
			jmp cont_for_vecini
			
		_switchm:
		
			movl val, %eax
			cmp $3, %eax
			jne _controller
			
			movl counter_ad, %ecx
			push %ecx
			push $switchm
			call printf
			pop %ebx
			pop %ebx
	
			push $0
			call fflush
			pop %ebx
	
			movl $4, %eax
			movl $1, %ebx
			movl $pctv, %ecx
			movl $2, %edx
			int $0x80
			
			jmp cont_for_vecini
			
		_controller:
		
			movl val, %eax
			cmp $4, %eax
			jne cont_for_vecini
			
			movl counter_ad, %ecx
			push %ecx
			push $controller
			call printf
			pop %ebx
			pop %ebx
	
			push $0
			call fflush
			pop %ebx
	
			movl $4, %eax
			movl $1, %ebx
			movl $pctv, %ecx
			movl $2, %edx
			int $0x80
		
	cont_for_vecini:
		
		movl counter_ad, %ecx
		addl $1, %ecx
		movl %ecx, counter_ad
		
		lea mat, %edi
		
		cmp n, %ecx
		je newline
		
		jmp for_vecini

newline:
	
	push $newLine
	push $format_string
	call printf
	pop %ebx
	pop %ebx
	
	push $0
	call fflush
	pop %ebx
	
	lea roles, %edi
	
after_malitios:
	
	movl counter, %ecx
	addl $1, %ecx
	movl %ecx, counter
	
	cmp n, %ecx
	je _exit
	
	jmp for_roles
	
task2:
	
	xor %ecx, %ecx
	mov %ecx, counter
	lea visited, %edi
	
init_visited:
	 
	movl counter, %ecx
	cmp n, %ecx
 	je after_init_visited
	
	movl counter, %ecx
	movl $0, (%edi, %ecx, 4)
	
	addl $1, %ecx
	movl %ecx, counter
	
	jmp init_visited
	
after_init_visited:
	
	lea queue, %edi
	
	xor %ecx, %ecx
	movl $0, (%edi, %ecx, 4)
	movl $0, queueIndex
	movl $1, queueLength
	
	lea visited, %edi
	
	xor %ecx, %ecx
	movl $1, (%edi, %ecx, 4)
	
for_queue:
	
	lea queue, %edi
	
	movl queueIndex, %ecx
	cmp queueLength, %ecx
	je newline2
	
	movl queueIndex, %ecx
	movl (%edi, %ecx, 4), %eax
	movl %eax, val
	
	lea roles, %edi
	
	movl val, %eax
	movl (%edi, %eax, 4), %ebx
	
	cmp $1, %ebx
	jne after_host
	
	movl val, %eax
	push %eax
	push $host
	call printf
	pop %ebx
	pop %ebx
	
	push $0
	call fflush
	pop %ebx
	
	movl $4, %eax
	movl $1, %ebx
	movl $pctv, %ecx
	movl $2, %edx
	int $0x80
	
after_host:
	
	xor %ecx, %ecx
	mov %ecx, counter
	
	for_vecini2:
		
		lea mat, %edi
		
		movl counter, %ecx
		cmp n, %ecx
		je after_for_vecini2
		
		movl val, %eax
		mull n
		movl counter, %ecx
		addl %ecx, %eax
		
		movl (%edi, %eax, 4), %ebx
		
		cmp $1, %ebx
		jne cont_for_vecini2
		
		lea visited, %edi
		
		movl counter, %ecx
		movl (%edi, %ecx, 4), %ebx
		cmp $1, %ebx
		je cont_for_vecini2
		
		movl counter, %ecx
		movl $1, (%edi, %ecx, 4)
		
		lea queue, %edi
		
		movl queueLength, %eax
		movl counter, %ecx
		mov %ecx, (%edi, %eax, 4)
		addl $1, queueLength
		
		
	cont_for_vecini2:
		
		movl counter, %ecx
		addl $1, %ecx
		movl %ecx, counter
		
		jmp for_vecini2
	
after_for_vecini2:
	
	movl queueIndex, %ecx
	addl $1, %ecx
	movl %ecx, queueIndex
	
	jmp for_queue
	
newline2:
	
	push $newLine
	push $format_string
	call printf
	pop %ebx
	pop %ebx
	
	push $0
	call fflush
	pop %ebx
	
conex_check:
	
	xor %ecx, %ecx
	mov %ecx, counter
	lea visited, %edi
	
for_conex:
	
	movl counter, %ecx
	cmp n, %ecx
	je is_conex
	
	movl counter, %ecx
	movl (%edi, %ecx, 4), %ebx
	
	cmp $0, %ebx
	je not_conex
	
	movl counter, %ecx
	addl $1, %ecx
	movl %ecx, counter
	
	jmp for_conex

not_conex:
	
	movl $4, %eax
	movl $1, %ebx
	mov $no, %ecx
	movl $3, %edx
	int $0x80
	
	jmp _exit
	
is_conex:
	
	movl $4, %eax
	movl $1, %ebx
	mov $yes, %ecx
	movl $4, %edx
	int $0x80
	
	jmp _exit
	
task3:
	
	push $host_s
	push $format_int
	call scanf
	pop %ebx
	pop %ebx
	
	push $host_d
	push $format_int
	call scanf
	pop %ebx
	pop %ebx
	
	push $string
	push $format_string
	call scanf
	pop %ebx
	pop %ebx

	xor %ecx, %ecx
	mov %ecx, counter
	lea visited, %edi
	
init_visited3:
	 
	movl counter, %ecx
	cmp n, %ecx
 	je after_init_visited3
	
	movl counter, %ecx
	movl $0, (%edi, %ecx, 4)
	
	addl $1, %ecx
	movl %ecx, counter
	
	jmp init_visited3
	
after_init_visited3:
	
	lea queue, %edi
	
	xor %ecx, %ecx
	movl host_s, %ebx
	movl %ebx, (%edi, %ecx, 4)
	movl $0, queueIndex
	movl $1, queueLength
	
	lea visited, %edi
	
	xor %ecx, %ecx
	movl $1, (%edi, %ecx, 4)
	
for_queue3:
	
	lea queue, %edi
	
	movl queueIndex, %ecx
	cmp queueLength, %ecx
	je Caesar
	
	movl queueIndex, %ecx
	movl (%edi, %ecx, 4), %eax
	movl %eax, val
	
	lea roles, %edi
	
	movl val, %eax
	movl (%edi, %eax, 4), %ebx
	
	xor %ecx, %ecx
	mov %ecx, counter
	
	for_vecini3:
		
		lea mat, %edi
		
		movl counter, %ecx
		cmp n, %ecx
		je after_for_vecini3
		
		movl val, %eax
		mull n
		movl counter, %ecx
		addl %ecx, %eax
		
		movl (%edi, %eax, 4), %ebx
		
		cmp $1, %ebx
		jne cont_for_vecini3
		
		movl counter, %ecx
		cmp host_d, %ecx
		je prep_string
		
		lea roles, %edi
		
		movl counter, %ecx
		movl (%edi, %ecx, 4), %ebx
		cmp $3, %ebx
		je cont_for_vecini3
		
		lea visited, %edi
		
		movl counter, %ecx
		movl (%edi, %ecx, 4), %ebx
		cmp $1, %ebx
		je cont_for_vecini3
		
		movl counter, %ecx
		movl $1, (%edi, %ecx, 4)
		
		lea queue, %edi
		
		movl queueLength, %eax
		movl counter, %ecx
		mov %ecx, (%edi, %eax, 4)
		addl $1, queueLength
		
		
	cont_for_vecini3:
		
		movl counter, %ecx
		addl $1, %ecx
		movl %ecx, counter
		
		jmp for_vecini3
	
after_for_vecini3:
	
	movl queueIndex, %ecx
	addl $1, %ecx
	movl %ecx, queueIndex
	
	jmp for_queue3

prep_string:
	
	lea string, %edi
	xor %ecx, %ecx
	mov %ecx, counter
	
	for_prep_string:
	
		movl counter, %ecx
		movb (%edi, %ecx, 1), %al
		
		cmp $0, %al
		je _string
		
		movl counter, %ecx
		addl $1, %ecx
		movl %ecx, counter
		
		jmp for_prep_string
		
Caesar:
	
	lea string, %edi
	xor %ecx, %ecx
	mov %ecx, counter
	
	for_caesar:
	
		movl counter, %ecx
		movb (%edi, %ecx, 1), %al
		
		cmp $0, %al
		je _string
		
		subb $10, %al
		movb %al, chr
		
		cmp chr_a, %al
		jge not_cicled
		
		movb chr, %al
		addb $26, %al
		movb %al, chr
		
		not_cicled:
		
		movb chr, %al
		movb %al, (%edi, %ecx, 1)
		
		movl counter, %ecx
		addl $1, %ecx
		movl %ecx, counter
		
		jmp for_caesar
_string:
	
	movl $4, %eax
	movl $1, %ebx
	mov $string, %ecx
	movl counter, %edx
	int $0x80
	
_exit:
	
	mov $1, %eax
	xor %ebx, %ebx
	int $0x80

