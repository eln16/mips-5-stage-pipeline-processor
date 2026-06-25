`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/05/2025 04:58:26 AM
// Design Name: 
// Module Name: tb_mctlb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
    // Parameters 
    `define HALF_CLK 5

module tb_mctlb;

    logic [5:0] ib_mctlb_op;
    
    logic ob_mctlb_mem2reg; //select ALU or Memory data for write back
    logic ob_cu_multWr; //select Multiplier or ALU result for write back
    logic ob_cu_hilo; //select HI or Low register
    logic ob_mctlb_reg_wr; //Enable register file write operation
    logic ob_mctlb_mem_wr; //memory write or store operation
    logic ob_mctlb_beq; //indicates brach if equal instr
    logic ob_mctlb_use_mult; //select data to multipier or ALU
    logic [2:0] ob_mctlb_op; //ALUop code
    logic ob_mctlb_src; //select register operand or extended immediate value
    logic ob_mctlb_regdst; //select rd or rt for data write back destination
    logic ob_mctlb_jump; //indicattes jump instr
    logic ob_mctlb_extop; //select sign or zero extension
    
    mctlb dut(
    
    .ib_mctlb_op (ib_mctlb_op),
    
    .ob_mctlb_mem2reg (ob_mctlb_mem2reg),
    .ob_cu_multWr (ob_cu_multWr),
    .ob_cu_hilo (ob_cu_hilo),
    .ob_mctlb_reg_wr (ob_mctlb_reg_wr),
    .ob_mctlb_mem_rd (ob_mctlb_reg_rd),
    .ob_mctlb_mem_wr (ob_mctlb_mem_wr),
    .ob_mctlb_beq (ob_mctlb_beq),
    .ob_mctlb_use_mult (ob_mctlb_use_mult),
    .ob_mctlb_op (ob_mctlb_op),
    .ob_mctlb_src (ob_mctlb_src),
    .ob_mctlb_regdst (ob_mctlb_regdst),
    .ob_mctlb_jump (ob_mctlb_jump),
    .ob_mctlb_extop (ob_mctlb_extop)
    );
    
    initial begin
        //1. R-type
        ib_mctlb_op = 6'b000000;
        #(`HALF_CLK * 2); 
    
        //2. addi
        ib_mctlb_op = 6'b001000;
        #(`HALF_CLK * 2); 
    
        //3. andi
        ib_mctlb_op = 6'b001100;
        #(`HALF_CLK * 2); 
        
        //4. set-on-less-than
        ib_mctlb_op = 6'b001010;
        #(`HALF_CLK * 2); 
        
        //5. ori
        ib_mctlb_op = 6'b001101;
        #(`HALF_CLK * 2); 
        
        //6. lw
        ib_mctlb_op = 6'b100011;
        #(`HALF_CLK * 2); 
        
        //7. sw
        ib_mctlb_op = 6'b101011;
        #(`HALF_CLK * 2); 
        
        //8. lb
        ib_mctlb_op = 6'b100000;
        #(`HALF_CLK * 2); 
        
        //9. sb
        ib_mctlb_op = 6'b101000;
        #(`HALF_CLK * 2); 
                
        //10. beq
        ib_mctlb_op = 6'b000100;
        #(`HALF_CLK * 2); 
        
        //11. bne
        ib_mctlb_op = 6'b000101;
        #(`HALF_CLK * 2); 
        
        //12. multu
        ib_mctlb_op = 6'b100100;
        #(`HALF_CLK * 2); 
       
       //13. mfhi
        ib_mctlb_op = 6'b100101;
        #(`HALF_CLK * 2); 
        
        //14. mflo
        ib_mctlb_op = 6'b100110;
        #(`HALF_CLK * 2); 
        
        //15. j
        ib_mctlb_op = 6'b000010;
        #(`HALF_CLK * 2); 
        
        //16. jal
        ib_mctlb_op = 6'b000011;
        #(`HALF_CLK * 2); 
        
        //17. jr
        ib_mctlb_op = 6'b000110;
        #(`HALF_CLK * 2); 
               
        $finish;
    end
    
endmodule
