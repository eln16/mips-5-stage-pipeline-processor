	.data 0x10000000
msg1:	.asciiz "The calculated value is "

	.text
	.globl main


main:	la $a0, msg1
	li $v0, 4
	syscall

	addi $sp, $sp, -8
	sw $ra, 4($sp)
	sw $fp, 0($sp)
	
	addiu $fp, $sp, 4
	addi $t0, $zero, 1
	addi $t1, $zero, 2
	addi $t2, $zero, 3
	addi $t3, $zero, 4

	jal cal

	lw $fp, 0($sp)
	lw $ra, 4($sp)
	addi $sp, $sp, 8

	add $a0, $zero, $v0
	li $v0, 1
	syscall

exit:	li $v0, 10


cal:	addi $sp, $sp, -8
	sw $s1, 4($sp)
	sw $s0, 0($sp)

	add $s0, $t0, $t1
	add $s1, $t2, $t3
	sub $v0, $s0, $s1

	lw $s0, 0($sp)
	lw $s1, 4($sp)

	addi $sp, $sp, 8

	jr $ra