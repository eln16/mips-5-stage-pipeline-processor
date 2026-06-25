	.text
        .globl main

main: 
	j main_prog       # Jump to main program
	nop                 # Delay slot


fib:
	addi $sp, $sp, -12   # Allocate stack space
	sw $ra, 8($sp)       # Save return address
	sw $a0, 4($sp)       # Save parameter n
    
    
	slti $t0, $a0, 2     # Check if n < 2
	beq $t0, $zero, fib_rec  # If not, go to recursive case
    
    
	add $v0, $a0, $zero  # return n
	j fib_return         # Jump to return
    
fib_rec:
   
	addi $a0, $a0, -1    # n-1
	jal fib              # fib(n-1)
	sw $v0, 0($sp)       # Store fib(n-1) on stack
    
	lw $a0, 4($sp)       # Restore original n
	addi $a0, $a0, -2    # n-2
	jal fib              # fib(n-2)
    
	lw $t1, 0($sp)       # Load fib(n-1)
	add $v0, $t1, $v0    # fib(n-1) + fib(n-2)

fib_return:
	lw $ra, 8($sp)       # Restore return address
	addi $sp, $sp, 12    # Deallocate stack
	jr $ra               # Return to caller
	nop                 # Delay slot


main_prog:
	addi $a0, $zero, 9   # Calculate fib(9)
    
    
	slti $t0, $a0, 0     # Check if n < 0
	bne $t0, $zero, error_handler  # If negative, handle error
    
    
	jal fib              # Call fib(9)
	j program_end        # Jump to end
    
error_handler:
	addi $v0, $zero, -1  # Return error code -1

program_end:
	nop                 # Program end

