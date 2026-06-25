        .text
        .globl main


double_num:
        addi $t0, $zero, 0    
        addi $t1, $zero, 0      

loop:
        slti $t2, $t1, 2       
        bne  $t2, $zero, body   
        j    end                

body:
        add  $t0, $t0, $a0      
        addi $t1, $t1, 1       
        j    loop

end:
        addi $v0, $t0, 0        
        jr   $ra


main:
        addi $sp, $sp, -8      
        sw   $ra, 4($sp)       
        sw   $s0, 0($sp)       

        addi $t0, $zero, 5     
        addi $t1, $zero, 3     

        # if (a > b)
        slt  $t2, $t1, $t0      
        bne  $t2, $zero, then   

else_case:
        addi $a0, $t1, 0        
        jal  double_num
        addi $s0, $v0, 0      
        j    if_end

then:
        addi $a0, $t0, 0       
        jal  double_num
        addi $s0, $v0, 0       

if_end:
        lw   $s0, 0($sp)       
        lw   $ra, 4($sp)        
        addi $sp, $sp, 8
        jr   $ra
