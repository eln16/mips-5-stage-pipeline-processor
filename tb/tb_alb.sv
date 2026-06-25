module tb_alb;
    // Inputs
    logic         ib_alub_rst;
    logic [31:0]  ib_alub_op_a;
    logic [31:0]  ib_alub_op_b;
    logic [31:0]  ib_alub_shamt;
    logic [3:0]   ib_alub_ctr;

    // Outputs
    logic [31:0]  ob_alub_out;
    logic         ob_alub_zero;

    // Instantiate the ALU block
    alb uut (
        .ib_alub_rst(ib_alub_rst),
        .ib_alub_op_a(ib_alub_op_a),
        .ib_alub_op_b(ib_alub_op_b),
        .ib_alub_shamt(ib_alub_shamt),
        .ib_alub_ctr(ib_alub_ctr),
        .ob_alub_out(ob_alub_out),
        .ob_alub_zero(ob_alub_zero)
    );

    // Stimulus
    initial begin
        // ---------- Test 1: System Reset ----------    
        ib_alub_rst    = 0;
        ib_alub_op_a   = 32'h00000001;
        ib_alub_op_b   = 32'h00000002;
        ib_alub_shamt  = 32'd0;
        ib_alub_ctr    = 4'b0110;  //ADD
        #10;
        
        ib_alub_rst = 1;
        #10;
        // Deassert reset
        ib_alub_rst = 0;
        #10;

        // ---------- Test 2: AND Operation ----------
        ib_alub_op_a = 32'hFFFF0000;
        ib_alub_op_b = 32'h12345678;
        ib_alub_ctr  = 4'b0000; // AND
        #10;

        // ---------- Test 3: OR Operation ----------
        ib_alub_op_a = 32'h0000FFFF;
        ib_alub_op_b = 32'h12345679;
        ib_alub_ctr  = 4'b0001; // OR
        #10;

        // ---------- Test 4: XOR Operation ----------
        ib_alub_op_a = 32'hF0F0F0F0;
        ib_alub_op_b = 32'h0F0F0F0F;
        ib_alub_ctr  = 4'b0010; // XOR
        #10;

        // ---------- Test 5: NOR Operation ----------
        ib_alub_op_a = 32'hFFFFFFFF;
        ib_alub_op_b = 32'h00000000;
        ib_alub_ctr  = 4'b0011; // NOR
        #10;

        // ---------- Test 6: Shift Left Logical (SLL) ----------
        ib_alub_op_a  = 32'h00000001;
        ib_alub_shamt = 32'd5;
        ib_alub_ctr   = 4'b0100; // SLL
        #10;

        // ---------- Test 7: Shift Right Logical (SRL) ----------
        ib_alub_op_a  = 32'h80000000;
        ib_alub_shamt = 32'd1;
        ib_alub_ctr   = 4'b0101; // SRL
        #10;

        // ---------- Test 8: ADD Operation ----------
        ib_alub_op_a = 32'h00000001;
        ib_alub_op_b = 32'hFFFFFFFF;
        ib_alub_ctr  = 4'b0110; // ADD
        #10;

        // ---------- Test 9: SUB Operation ----------
        ib_alub_op_a = 32'h00000002;
        ib_alub_op_b = 32'h00000001;
        ib_alub_ctr  = 4'b1110; // SUB
        #10;

        // ---------- Test 10: Set-on-less-than (Signed) ----------
        ib_alub_op_a = 32'hFFFFFFFF; // -1
        ib_alub_op_b = 32'h00000001;
        ib_alub_ctr  = 4'b1111; // SLT
        #10;

        // ---------- Test 11: Zero Detection (Add 0 + 0) ----------
        ib_alub_op_a = 32'h00000000;
        ib_alub_op_b = 32'h00000000;
        ib_alub_ctr  = 4'b0110; // ADD
        #10;

        // ---------- Test 12: Invalid Control Code ----------
        ib_alub_op_a = 32'h00000000;
        ib_alub_op_b = 32'h00000000;
        ib_alub_ctr  = 4'b1001; // Invalid
        #10;

        // End simulation
        $finish;
    end

endmodule
