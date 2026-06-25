	.text
        .globl main

main: 
	# IF-ELSE  
	addi $t0, $zero, 15
	addi $t1, $zero, 10
	slt $t2, $t0, $t1
	beq $t2, $zero, else
	addi $t3, $zero, 1
	j end_if
else:
	addi $t3, $zero, 4
end_if:
	nop


	# WHILE LOOP
	addi $t0, $zero, 0
	addi $t1, $zero, 1
while_loop:
	beq $t0, $t1, end_while
	addi $t0, $t0, 1
	j while_loop
	nop
end_while:
	add $t2, $t0, $zero


	# NESTED LOOP
	addi $t0, $zero, 0
	addi $t1, $zero, 1
	addi $t2, $zero, 0
	addi $t3, $zero, 1
loop_1:
	beq $t0, $t1, end_1
	addi $t2, $zero, 0
loop_2:
	beq $t2, $t3, end_2
	addi $t2, $t2, 1
	j loop_2
end_2:
	addi $t0, $t0, 1
	j loop_1
end_1:
	add $t4, $t2, $zero


	
