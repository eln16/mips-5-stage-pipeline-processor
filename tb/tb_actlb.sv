`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/05/2025 08:23:05 PM
// Design Name: 
// Module Name: tb_actlb
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

module tb_actlb;

logic [2:0] ib_actlb_op;
logic [5:0] ib_actlb_funct;
logic [3:0] ob_actlb_ctr;

actlb dut(
    .ib_actlb_op(ib_actlb_op),
    .ib_actlb_funct(ib_actlb_funct),
    .ob_actlb_ctr(ob_actlb_ctr)
);

initial begin
    
    //1. addi
    ib_actlb_op = 3'b000;
    ib_actlb_funct = 6'bx;
    #(`HALF_CLK * 2); 
    
    //2. andi
    ib_actlb_op = 3'b011;
    ib_actlb_funct = 6'bx;
    #(`HALF_CLK * 2); 
    
    //3. slti
    ib_actlb_op = 3'b101;
    ib_actlb_funct = 6'bx;
    #(`HALF_CLK * 2); 
    
    //4. ori
    ib_actlb_op = 3'b101;
    ib_actlb_funct = 6'bx;
    #(`HALF_CLK * 2); 
    
    //5.lw/sw
    ib_actlb_op = 3'b000;
    ib_actlb_funct = 6'bx;
    #(`HALF_CLK * 2); 
    
    //6. lb/sb
    ib_actlb_op = 3'b000;
    ib_actlb_funct = 6'bx;
    #(`HALF_CLK * 2); 
    
    //7. jalr
    ib_actlb_op = 3'b1xx;
    ib_actlb_funct = 6'bxx1011;
    #(`HALF_CLK * 2); 
    
    //8. beq
    ib_actlb_op = 3'b001;
    ib_actlb_funct = 6'bxxxxxx;
    #(`HALF_CLK * 2); 
    
    //9. bne
    ib_actlb_op = 3'b001;
    ib_actlb_funct = 6'bxxxxxx;
    #(`HALF_CLK * 2); 
    
    //10. add
    ib_actlb_op = 3'b1xx;
    ib_actlb_funct = 6'bxx0000;
    #(`HALF_CLK * 2); 
    
    //11. sub
    ib_actlb_op = 3'b1xx;
    ib_actlb_funct = 6'bxx0010;
    #(`HALF_CLK * 2); 
    
    //12. and
    ib_actlb_op = 3'b1xx;
    ib_actlb_funct = 6'bxx0100;
    #(`HALF_CLK * 2); 
    
    //13. or
    ib_actlb_op = 3'b1xx;
    ib_actlb_funct = 6'bxx0101;
    #(`HALF_CLK * 2); 
    
    //14. xor
    ib_actlb_op = 3'b1xx;
    ib_actlb_funct = 6'bxx0110;
    #(`HALF_CLK * 2); 
    
    //15.nor
    ib_actlb_op = 3'b1xx;
    ib_actlb_funct = 6'bxx0111;
    #(`HALF_CLK * 2); 
    
    //16. sll
    ib_actlb_op = 3'b1xx;
    ib_actlb_funct = 6'bxx1100;
    #(`HALF_CLK * 2); 
    
    //17. srl
    ib_actlb_op = 3'b1xx;
    ib_actlb_funct = 6'bxx1101;
    #(`HALF_CLK * 2); 
    
    //18. slt
    ib_actlb_op = 3'b1xx;
    ib_actlb_funct = 6'bxx1010;
    #(`HALF_CLK * 2); 
    
    
    //end simulation
    #(`HALF_CLK * 2);
    $finish;

end
endmodule
