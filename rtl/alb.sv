module alb(
    // Input ports
    input  logic        ib_alb_rst,   //Asynchronous reset
    input  logic [3:0]  ib_alb_ctr,   //ALU control signal
    input  logic [31:0] ib_alb_op_a,  //Operand A
    input  logic [31:0] ib_alb_op_b,  //Operand B
    input  logic [4:0] ib_alb_shamt, //Shift amount
    
    
    
    // Output ports
    output logic [31:0] ob_alb_out
    );
    
// Internal signals
logic [31:0] alu_result;
logic [31:0] operand_a, operand_b;
logic [4:0]  shift_amount;

integer i;

// Main ALU operation logic
always_comb begin
    operand_a = ib_alb_op_a;
    operand_b = ib_alb_op_b;
    shift_amount = ib_alb_shamt;
    
    case (ib_alb_ctr)
        4'b0000: alu_result = operand_a & operand_b;     // AND

        4'b0001: alu_result = operand_a | operand_b;     // OR

        4'b0010: alu_result = operand_a ^ operand_b;     // XOR

        4'b0011: alu_result = ~(operand_a | operand_b);  // NOR
        
        4'b0100: begin // SLL
            alu_result = 32'd0;
            for (i = 0; i < 32; i = i + 1) begin
                if (i < (32 - shift_amount)) begin
                    alu_result[i + shift_amount] = operand_b[i];
                end
            end
        end
        
        4'b0101: begin // SRL
            alu_result = 32'd0;
            for (i = 0; i < 32; i = i + 1) begin
                if (i >= shift_amount) begin
                    alu_result[i - shift_amount] = operand_b[i];
                end
            end
        end

        
        4'b0110: alu_result = operand_a + operand_b;      // ADD

        4'b1110: alu_result = operand_a - operand_b;   // SUB

        4'b1000: begin // LUI
            // shift immediate value left by 16 bits
            alu_result = {operand_b[15:0], 16'h0000};
        end

        4'b1111: alu_result = ($signed(operand_a) < $signed(operand_b)) ? 32'h1 : 32'h0; // SLT
        default: alu_result = 32'h0;  
    endcase
end

always_comb begin
        if (ib_alb_rst) begin
            ob_alb_out  = 32'd0;
        end 
        else begin
            ob_alb_out  = alu_result;
        end
end 

endmodule

