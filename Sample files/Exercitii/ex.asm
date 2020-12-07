.data
	
	n: .long 1717986918
	shift: .long 0
	trei1: .long 31
	
	zero: .asciz "zero\n"
	pozitiv: .asciz "pozitiv\n"
	negativ: .asciz "negativ\n"
	
	palindrom: .asciz "palindrom\n"
	nepalindrom: .asciz "nepalindrom\n"
	
.text

.globl _start

_start:

	mov $0, %eax
	
	cmp %eax, n
	jl et_negativ
	
	cmp %eax, n
	jg et_pozitiv
	
	cmp %eax, n
	je et_zero
	
et_pozitiv:
	mov $4, %eax
	mov $1, %ebx
	mov $pozitiv, %ecx
	mov $9, %edx
	int $0x80
	jmp swap
et_negativ:
	mov $4, %eax
	mov $1, %ebx
	mov $negativ, %ecx
	mov $9, %edx
	int $0x80
	jmp swap
et_zero:
	mov $4, %eax
	mov $1, %ebx
	mov $zero, %ecx
	mov $6, %edx
	int $0x80
	jmp swap
	
swap:

	mov $5, %eax
	mov $3, %ebx
	xor %ebx, %eax
	xor %eax, %ebx
	xor %ebx, %eax
	
	mov $1, %ebx
	mov $0, %ecx
	mov n, %eax
	
	cmp $0, %eax
	je sir_b

log2:
	shr $1, %eax
	cmp $1, %eax
	je sir_b 
	
	add $1, %ecx
	jmp log2
	
sir_b:

	mov n, %eax
	mov $0, %edx
	mov $1, %ebx
reinit:
	mov $0, %ecx
	cmp $0, %eax
	je rez
loop:
	
	add $1, %ecx
	and %eax, %ebx
	shr $1, %eax
	
	cmp $1, %ebx
	je  loop
	
	sub $1, %ecx	
	
	cmp %ecx, %edx
	jge reinit
	
	mov %ecx, %edx
	
	jmp loop

rez:

pal:
	mov n, %eax
	mov $0, %ecx
	
loop2:
	mov n, %eax
	
	mov $31, %ebx
	sub %ecx, %ebx
	mov $1, %edx
	
	xor %ebx, %ecx
	xor %ecx, %ebx
	xor %ebx, %ecx
	
	shl %ecx, %edx
	 
	xor %ebx, %ecx
	xor %ecx, %ebx
	xor %ebx, %ecx
	
	mov $1, %ebx
	shl %ecx, %ebx
test:
	and %eax, %ebx
	and %eax, %edx

	mov $31, %eax
	sub %ecx, %eax
	
	xor %eax, %ecx
	xor %ecx, %eax
	xor %eax, %ecx
	
	shr %ecx, %edx
	
	xor %eax, %ecx
	xor %ecx, %eax
	xor %eax, %ecx
	
	shr %ecx, %ebx
	
	add $1, %ecx
	cmp $16, %ecx
	je et_palindrom
	
	cmp %ebx, %edx
	je loop2
	
	jmp et_nepalindrom

et_palindrom:
	mov $4, %eax
	mov $1, %ebx
	mov $palindrom, %ecx
	mov $11, %edx
	int $0x80
	jmp exit
et_nepalindrom:
	mov $4, %eax
	mov $1, %ebx
	mov $nepalindrom, %ecx
	mov $13, %edx
	int $0x80
	jmp exit
	
exit:
	mov $1, %eax
	mov $0, %ebx
	int $0x80
