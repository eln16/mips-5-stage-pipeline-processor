`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/05/2025 04:49:55 PM
// Design Name: 
// Module Name: actlb
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


module actlb(

input logic [2:0] ib_actlb_op,
input logic [5:0] ib_actlb_funct,

output logic [3:0] ob_actlb_ctr
    );
    
    always_comb begin
        case(ib_actlb_op)
            3'b000: begin   //addi,lw,sw,ib,sb
            ob_actlb_ctr = 4'b0110; // assign add
            end
             
            3'b001: begin   //beq,bne
            ob_actlb_ctr = 4'b1110; // assign sub
            end
            
            3'b011: begin   //andi
            ob_actlb_ctr = 4'b0000; // assign and
            end
            
            3'b010: begin   //ori
            ob_actlb_ctr = 4'b0001; // assign or
            end
            
            3'b101: begin   //slti
            ob_actlb_ctr = 4'b1111; // assign slt
            end

            3'b110: begin   // lui
            ob_actlb_ctr = 4'b1000; // Special code for lui
            end
            
            3'b100: begin
                case (ib_actlb_funct)

                    6'b100000: ob_actlb_ctr = 4'b0110; //assign add
                    6'b100010: ob_actlb_ctr = 4'b1110; //assign sub
                    6'b100100: ob_actlb_ctr = 4'b0000; //assign and
                    6'b100101: ob_actlb_ctr = 4'b0001; //assign or
                    6'b100111: ob_actlb_ctr = 4'b0011; //assign nor
                    6'b100110: ob_actlb_ctr = 4'b0010; //assign xor
                    6'b000000: ob_actlb_ctr = 4'b0100; //assign sll
                    6'b000010: ob_actlb_ctr = 4'b0101; //assign srl
                    6'b010000: ob_actlb_ctr = 4'b0110; //mfhi assign add
                    6'b010010: ob_actlb_ctr = 4'b0110; //mflo assign add
                    6'b101010: ob_actlb_ctr = 4'b1111; //assign slt
                    6'b001000: ob_actlb_ctr = 4'b0110; //jr assign add
                    6'b001001: ob_actlb_ctr = 4'b0110; //jalr assign add

                    default: ob_actlb_ctr = 4'b0110;
                endcase
            end

            default: ob_actlb_ctr = 4'b0110;

          endcase
       end
    
endmodule
