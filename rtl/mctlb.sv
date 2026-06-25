`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/05/2025 02:42:37 AM
// Design Name: 
// Module Name: mctlb
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


module mctlb(

    input logic [5:0] ib_mctlb_op,
    input logic [5:0] ib_mctlb_funct, 
    
    output logic ob_mctlb_mem2reg, //select ALU or Memory data for write back
    output logic ob_cu_multWr, //select Multiplier or ALU result for write back
    output logic ob_cu_hilo, //select HI or Low register
    output logic ob_mctlb_reg_wr, //Enable register file write operation
    output logic ob_mctlb_mem_rd, //Enable memory read operation
    output logic ob_mctlb_mem_wr, //Enable memory write operation
    output logic ob_mctlb_beq, //indicates brach if equal instr
    output logic ob_mctlb_bne, // indicate branch not equal
    output logic ob_mctlb_use_mult, //select data to multipier or ALU
    output logic [2:0] ob_mctlb_op, //ALUop code
    output logic ob_mctlb_src, //select register operand or extended immediate value
    output logic [1:0] ob_mctlb_regdst, //select rd or rt or ra for data write back destination
    output logic ob_mctlb_is_jal,
    output logic ob_mctlb_is_jalr,
    output logic ob_mctlb_is_jr,
    output logic ob_mctlb_jump, //indicattes jump instr
    output logic ob_mctlb_extop, //select sign or zero extension
    output logic ob_mctlb_mem_mode //select is byte or word addressable
    
    ); 
    always_comb begin
        //Default all signal 0
        ob_mctlb_mem_mode = 1;
        ob_mctlb_extop = 0;
        ob_mctlb_jump = 0;
        ob_mctlb_is_jal = 0;
        ob_mctlb_is_jalr = 0;
        ob_mctlb_is_jr = 0;
        ob_mctlb_regdst = 2'b01;
        ob_mctlb_src = 0;
        ob_mctlb_op = 3'b0;
        ob_mctlb_use_mult = 0;
        ob_mctlb_beq = 0;
        ob_mctlb_bne = 0;
        ob_mctlb_mem_wr = 0;
        ob_mctlb_mem_rd = 0;
        ob_mctlb_mem2reg = 0;
        ob_mctlb_reg_wr = 0;
        ob_cu_hilo = 0;
        ob_cu_multWr = 0;
        
        case (ib_mctlb_op)

            //R-type (op = 000000)
            6'b000000: begin  
                case (ib_mctlb_funct)

                    6'b011001: begin // multu
                    ob_mctlb_mem_mode = 1; 
                    ob_mctlb_extop = 0; //zero extension
                    ob_mctlb_jump = 0; //no jump
                    ob_mctlb_regdst = 2'b10; //rd
                    ob_mctlb_src = 0; //register operand
                    ob_mctlb_op = 3'b100; //R-type
                    ob_mctlb_use_mult = 1; //transfer data to Multiplier
                    ob_mctlb_beq = 0; //no branch
                    ob_mctlb_mem_wr = 0; // disable memory write
                    ob_mctlb_mem_rd = 0; // disable memory read
                    ob_mctlb_mem2reg = 0; // select ALU result for write back
                    ob_mctlb_reg_wr = 0; // disable write reg file
                    ob_cu_hilo = 0; // low
                    ob_cu_multWr = 0; // ALU result for write back
                    end

                    6'b010000: begin // mfhi
                    ob_mctlb_mem_mode = 1; 
                    ob_mctlb_extop = 0; //zero extension
                    ob_mctlb_jump = 0; //no jump
                    ob_mctlb_regdst = 2'b10; //rd
                    ob_mctlb_src = 0; //register operand
                    ob_mctlb_op = 3'b100; //R-type
                    ob_mctlb_use_mult = 0; //transfer data to ALU
                    ob_mctlb_beq = 0; //no branch
                    ob_mctlb_mem_wr = 0; // disable memory write
                    ob_mctlb_mem_rd = 0; // disable memory read
                    ob_mctlb_mem2reg = 0; // select ALU result for write back
                    ob_mctlb_reg_wr = 1; //Enable write reg file
                    ob_cu_hilo = 1; // high
                    ob_cu_multWr = 1; // Multiplier result for write back
                    end

                    6'b010010: begin // mflo
                    ob_mctlb_mem_mode = 1; 
                    ob_mctlb_extop = 0; //zero extension
                    ob_mctlb_jump = 0; //no jump
                    ob_mctlb_regdst = 2'b10; //rd
                    ob_mctlb_src = 0; //register operand
                    ob_mctlb_op = 3'b100; //R-type
                    ob_mctlb_use_mult = 0; //transfer data to ALU
                    ob_mctlb_beq = 0; //no branch
                    ob_mctlb_mem_wr = 0; // disable memory write
                    ob_mctlb_mem_rd = 0; // disable memory read
                    ob_mctlb_mem2reg = 0; // select ALU result for write back
                    ob_mctlb_reg_wr = 1; //Enable write reg file
                    ob_cu_hilo = 0; // low
                    ob_cu_multWr = 1; // Multiplier result for write back
                    end

                    6'b001000: begin // jr
                    ob_mctlb_mem_mode = 1; 
                    ob_mctlb_extop = 0; //zero extension
                    ob_mctlb_jump = 0; //jump
                    ob_mctlb_is_jr = 1; // jump register
                    ob_mctlb_regdst = 2'b10; //rd
                    ob_mctlb_src = 0; //register operand
                    ob_mctlb_op = 3'b100; //R-type
                    ob_mctlb_use_mult = 0; //transfer data to ALU
                    ob_mctlb_beq = 0; //no branch
                    ob_mctlb_mem_wr = 0; // disable memory write
                    ob_mctlb_mem_rd = 0; // disable memory read
                    ob_mctlb_mem2reg = 0; // select ALU result for write back
                    ob_mctlb_reg_wr = 0; //Disable write reg file
                    ob_cu_hilo = 0; // low
                    ob_cu_multWr = 0; // ALU result for write back
                    end

                    6'b001001: begin // jalr
                    ob_mctlb_mem_mode = 1; 
                    ob_mctlb_extop = 0; //zero extension
                    ob_mctlb_jump = 0; //jump
                    ob_mctlb_is_jalr = 1; // jump and link
                    ob_mctlb_regdst = 2'b10; //rd
                    ob_mctlb_src = 0; //register operand
                    ob_mctlb_op = 3'b100; //R-type
                    ob_mctlb_use_mult = 0; //transfer data to ALU
                    ob_mctlb_beq = 0; //no branch
                    ob_mctlb_mem_wr = 0; // disable memory write
                    ob_mctlb_mem_rd = 0; // disable memory read
                    ob_mctlb_mem2reg = 0; // select ALU result for write back
                    ob_mctlb_reg_wr = 1; //Enable write reg file
                    ob_cu_hilo = 0; // low
                    ob_cu_multWr = 0; // ALU result for write back
                    end

                    default: begin // add, sub, and, or, nor, xor, sll, srl, slt
                    ob_mctlb_mem_mode = 1; 
                    ob_mctlb_extop = 0; //zero extension
                    ob_mctlb_jump = 0; //no jump
                    ob_mctlb_regdst = 2'b10; //rd
                    ob_mctlb_src = 0; //register operand
                    ob_mctlb_op = 3'b100; //R-type
                    ob_mctlb_use_mult = 0; //transfer data to ALU
                    ob_mctlb_beq = 0; //no branch
                    ob_mctlb_mem_wr = 0; // disable memory write
                    ob_mctlb_mem_rd = 0; // disable memory read
                    ob_mctlb_mem2reg = 0; // select ALU result for write back
                    ob_mctlb_reg_wr = 1; //Enable write reg file
                    ob_cu_hilo = 0; // low
                    ob_cu_multWr = 0; // ALU result for write back
                    end

                endcase 
            
            end
            
            6'b001000: begin //addi           
            ob_mctlb_extop = 1 ; //sign extension
            ob_mctlb_jump = 0; //no jump
            ob_mctlb_regdst = 2'b01; //rt
            ob_mctlb_src = 1; //imm value
            ob_mctlb_op = 3'b000; //add
            ob_mctlb_use_mult = 0; //transfer data to ALU
            ob_mctlb_beq = 0; //no brach
            ob_mctlb_mem_wr = 0; // disable memory write
            ob_mctlb_mem_rd = 0; // disable memory read
            ob_mctlb_mem2reg = 0; // select ALU result for write back
            ob_mctlb_reg_wr = 1; //Enable write reg file 
            ob_cu_hilo = 0; // low 
            ob_cu_multWr = 0; // ALU result for write back
            end
            
            6'b001100: begin //andi          
            ob_mctlb_extop = 0 ; //zero extension
            ob_mctlb_jump = 0; //no jump
            ob_mctlb_regdst = 2'b01; //rt
            ob_mctlb_src = 1; //imm value
            ob_mctlb_op = 3'b011; //and
            ob_mctlb_use_mult = 0; //transfer data to ALU
            ob_mctlb_beq = 0; //no brach
            ob_mctlb_mem_wr = 0; // disable memory write
            ob_mctlb_mem_rd = 0; // disable memory read
            ob_mctlb_mem2reg = 0; // select ALU result for write back
            ob_mctlb_reg_wr = 1; //Enable write reg file 
            ob_cu_multWr = 0; // ALU result for write back
            end
            
            6'b001010: begin //slti            
            ob_mctlb_extop = 1 ; //sign extension
            ob_mctlb_jump = 0; //no jump
            ob_mctlb_regdst = 2'b01; //rt
            ob_mctlb_src = 1; //imm value
            ob_mctlb_op = 3'b101; //set if less than
            ob_mctlb_use_mult = 0; //transfer data to ALU
            ob_mctlb_beq = 0; //no brach
            ob_mctlb_mem_wr = 0; // disable memory write
            ob_mctlb_mem_rd = 0; // disable memory read
            ob_mctlb_mem2reg = 0; // select ALU result for write back
            ob_mctlb_reg_wr = 1; //Enable write reg file 
            ob_cu_multWr = 0; // ALU result for write back
            end
            
            6'b001101: begin //ori       
            ob_mctlb_extop = 0 ; //zero extension
            ob_mctlb_jump = 0; //no jump
            ob_mctlb_regdst = 2'b01; //rt
            ob_mctlb_src = 1; //imm value
            ob_mctlb_op = 3'b010; //or
            ob_mctlb_use_mult = 0; //transfer data to ALU
            ob_mctlb_beq = 0; //no brach
            ob_mctlb_mem_wr = 0; // disable memory write
            ob_mctlb_mem_rd = 0; // disable memory read
            ob_mctlb_mem2reg = 0; // select ALU result for write back
            ob_mctlb_reg_wr = 1; //Enable write reg file 
            ob_cu_multWr = 0; // ALU result for write back
            end
            
            6'b100011: begin //lw       
            ob_mctlb_extop = 1 ; //sign extension
            ob_mctlb_jump = 0; //no jump
            ob_mctlb_regdst = 2'b01; //rt
            ob_mctlb_src = 1; //imm value
            ob_mctlb_op = 3'b000; //add
            ob_mctlb_use_mult = 0; //transfer data to ALU
            ob_mctlb_beq = 0; //no brach
            ob_mctlb_mem_wr = 0; // disable memory write
            ob_mctlb_mem_rd = 1; // Enable memory read
            ob_mctlb_mem2reg = 1; // select memory data for write back
            ob_mctlb_reg_wr = 1; //Enable write reg file 
            ob_cu_multWr = 0; // ALU result for write back
            end
            
            6'b101011: begin //sw       
            ob_mctlb_extop = 1 ; //sign extension
            ob_mctlb_jump = 0; //no jump
            ob_mctlb_src = 1; //imm value
            ob_mctlb_op = 3'b000; //add
            ob_mctlb_use_mult = 0; //transfer data to ALU
            ob_mctlb_beq = 0; //no brach
            ob_mctlb_mem_wr = 1; // Enable memory write
            ob_mctlb_mem_rd = 0; // disable memory read
            ob_mctlb_reg_wr = 0; //disable write reg file 
            ob_cu_multWr = 0; // ALU result for write back
            end
            
            6'b100000: begin //lb
            ob_mctlb_mem_mode = 0;       
            ob_mctlb_extop = 1 ; //sign extension
            ob_mctlb_jump = 0; //no jump
            ob_mctlb_regdst = 2'b01; //rt
            ob_mctlb_src = 1; //imm value
            ob_mctlb_op = 3'b000; //add
            ob_mctlb_use_mult = 0; //transfer data to ALU
            ob_mctlb_beq = 0; //no brach
            ob_mctlb_mem_wr = 0; // disable memory write
            ob_mctlb_mem_rd = 1; // Enable memory read
            ob_mctlb_mem2reg = 1; // select memory data for write back
            ob_mctlb_reg_wr = 1; //Enable write reg file 
            ob_cu_multWr = 0; // ALU result for write back
            end
            
            6'b101000: begin //sb
            ob_mctlb_mem_mode = 0;       
            ob_mctlb_extop = 1 ; //sign extension
            ob_mctlb_jump = 0; //no jump
            ob_mctlb_src = 1; //imm value
            ob_mctlb_op = 3'b000; //add
            ob_mctlb_use_mult = 0; //transfer data to ALU
            ob_mctlb_beq = 0; //brach
            ob_mctlb_mem_wr = 1; // Enable memory write
            ob_mctlb_mem_rd = 0; // disable memory read
            ob_mctlb_reg_wr = 0; //disable write reg file 
            ob_cu_multWr = 0; // ALU result for write back
            end
            
            6'b000100: begin //beq           
            ob_mctlb_extop = 1 ; //sign extension
            ob_mctlb_jump = 0; //no jump
            ob_mctlb_src = 0; //imm value
            ob_mctlb_op = 3'b001; //sub
            ob_mctlb_use_mult = 0; //transfer data to ALU
            ob_mctlb_beq = 1; //brach
            ob_mctlb_mem_wr = 0; // disable memory write
            ob_mctlb_mem_rd = 0; // disable memory read
            ob_mctlb_reg_wr = 0; //disable write reg file 
            ob_cu_multWr = 0; // ALU result for write back
            end
            
            6'b000101: begin //bne          
            ob_mctlb_extop = 1 ; //sign extension
            ob_mctlb_jump = 0; //no jump
            ob_mctlb_src = 0; //imm value
            ob_mctlb_op = 3'b001; //sub
            ob_mctlb_use_mult = 0; //transfer data to ALU
            ob_mctlb_beq = 0; // brach
            ob_mctlb_bne = 1; // brach nto equal
            ob_mctlb_mem_wr = 0; // disable memory write
            ob_mctlb_mem_rd = 0; // disable memory read
            ob_mctlb_reg_wr = 0; //disable write reg file 
            ob_cu_multWr = 0; // ALU result for write back
            end
            
            6'b000010: begin //j           
            ob_mctlb_jump = 1; //jump
            ob_mctlb_use_mult = 0; //transfer data to ALU
            ob_mctlb_beq = 0; //no brach
            ob_mctlb_mem_wr = 0; // disable memory write
            ob_mctlb_mem_rd = 0; // disable memory read
            ob_mctlb_mem2reg = 0; // select ALU result for write back
            ob_mctlb_reg_wr = 0; //disable write reg file 
            ob_cu_multWr = 0; // ALU result for write 
            end
            
            6'b000011: begin //jal           
            ob_mctlb_extop = 0 ; //zero extension
            ob_mctlb_jump = 0; //jump
            ob_mctlb_is_jal = 1; //jump and link
            ob_mctlb_regdst = 2'b00; //ra
            ob_mctlb_use_mult = 0; //transfer data to ALU
            ob_mctlb_beq = 0; //no brach
            ob_mctlb_mem_wr = 0; // disable memory write
            ob_mctlb_mem_rd = 0; // disable memory read
            ob_mctlb_mem2reg = 0; // select ALU result for write back
            ob_mctlb_reg_wr = 1; //Enable write reg file 
            ob_cu_multWr = 0; // ALU result for write back
            end

            6'b001111: begin // lui
            ob_mctlb_extop = 0;       // don't care (not used)
            ob_mctlb_jump = 0;        // no jump
            ob_mctlb_regdst = 2'b01;      // rt 
            ob_mctlb_src = 1;         // use immediate value
            ob_mctlb_op = 3'b110;     // new ALU opcode for LUI
            ob_mctlb_use_mult = 0;    // use ALU, not multiplier
            ob_mctlb_beq = 0;         // no branch
            ob_mctlb_mem_wr = 0;      // no memory write
            ob_mctlb_mem_rd = 0;      // no memory read
            ob_mctlb_mem2reg = 0;     // use ALU result, not memory
            ob_mctlb_reg_wr = 1;      // enable register write
            ob_cu_hilo = 0;           // not using HI/LO
            ob_cu_multWr = 0;         // not multiplier result
    end
            
            default:begin
            //NOP
            end
         
       endcase 
    end
endmodule


