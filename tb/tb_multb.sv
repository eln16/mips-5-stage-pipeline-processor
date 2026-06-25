//##################################################################################################
/*
Project / Module    : tb_multb
File name           : tb_mutlb.sv
Version             : 1-0
Date created        : 1 SEPTEMBER 2025
Author              : Wong Carman
Code type           : Behavioural (System Verilog)
Description         : Testbench for Multiplier Block (membk) a module that computing the Multiply 
                      Arithmetic Result by checking the multiplier bit to add to product regitser
                      and then shift the product register repeat for all 32 bit
*/
//##################################################################################################

// Parameters
`define HALF_CLK 5

module tb_multb ();

    // Multiplier Input Signals
    logic               tb_ib_multb_clk;
    logic               tb_ib_multb_rst;    
    logic [31:0]        tb_ib_multb_mulcn;
    logic [31:0]        tb_ib_multb_mulpl;
    
    // Multiplier Output Signals
    wire                tb_ob_multb_valid;
    wire                tb_ob_multb_busy;
    wire [63:0]         tb_ob_multb_out;
    
    multb
    dut_multb
    (
        .ib_multb_clk(tb_ib_multb_clk),
        .ib_multb_rst(tb_ib_multb_rst),
        .ib_multb_mulcn(tb_ib_multb_mulcn),
        .ib_multb_mulpl(tb_ib_multb_mulpl),
        .ob_multb_valid(tb_ob_multb_valid),
        .ob_multb_busy(tb_ob_multb_busy),
        .ob_multb_out(tb_ob_multb_out)
    );
    
    //----------------------------------------------------------
    //   Clock Wave Generator
    // ---------------------------------------------------------
    
    initial begin
    
        tb_ib_multb_clk = 1'b0;
        forever #(`HALF_CLK) tb_ib_multb_clk = ~tb_ib_multb_clk;
    
    end
    
    initial begin
    
    //----------------------------------------------------------
    //   Signal Initialization
    // ---------------------------------------------------------
    
    tb_ib_multb_rst = 1'b0;
    tb_ib_multb_mulcn = 32'h0000_0000;
    tb_ib_multb_mulpl = 32'h0000_0000;
    repeat(1) @(posedge tb_ib_multb_clk);
    
    //----------------------------------------------------------
    //   Test Case 1: System Reset
    // ---------------------------------------------------------
    
    tb_ib_multb_rst = 1'b1;
    repeat(1) @(posedge tb_ib_multb_clk);
    
    tb_ib_multb_rst = 1'b0;
    repeat(1) @(posedge tb_ib_multb_clk);
    
    //----------------------------------------------------------
    //   Test Case 2: Multiplier Input Test
    // ---------------------------------------------------------
    
    tb_ib_multb_mulcn = 32'h0000_0004;
    tb_ib_multb_mulpl = 32'h0000_0003;
    repeat(34) @(posedge tb_ib_multb_clk);
    
    tb_ib_multb_mulcn = 32'h0000_0000;
    tb_ib_multb_mulpl = 32'h0000_0000;
    repeat(1) @(posedge tb_ib_multb_clk);
    
    //----------------------------------------------------------
    //   Test Case 3: Check for Overflow Handling
    // ---------------------------------------------------------
    
    tb_ib_multb_mulcn = 32'hFFFF_FFFF;
    tb_ib_multb_mulpl = 32'hFFFF_FFFF;
    repeat(34) @(posedge tb_ib_multb_clk);
    
    tb_ib_multb_mulcn = 32'h0000_0000;
    tb_ib_multb_mulpl = 32'h0000_0000;
    repeat(1) @(posedge tb_ib_multb_clk);
    
    //----------------------------------------------------------
    //   Test Case 4: Check for Zero Multiplication
    // ---------------------------------------------------------
    
    tb_ib_multb_mulcn = 32'h0000_0005;
    tb_ib_multb_mulpl = 32'h0000_0000;
    repeat(34) @(posedge tb_ib_multb_clk);
    
    tb_ib_multb_mulcn = 32'h0000_0000;
    tb_ib_multb_mulpl = 32'h0000_0000;
    repeat(1) @(posedge tb_ib_multb_clk);
    
    //----------------------------------------------------------
    //   Test Case 5: COMPUTE State Handling
    // ---------------------------------------------------------
    
    tb_ib_multb_mulcn = 32'h0000_0003;
    tb_ib_multb_mulpl = 32'h0000_0002;
    repeat(17) @(posedge tb_ib_multb_clk);
    
    tb_ib_multb_mulcn = 32'h0000_0005;
    tb_ib_multb_mulpl = 32'h0000_0005;
    repeat(17) @(posedge tb_ib_multb_clk);
    
    tb_ib_multb_mulcn = 32'h0000_0000;
    tb_ib_multb_mulpl = 32'h0000_0000;
    repeat(1) @(posedge tb_ib_multb_clk);
    
    //----------------------------------------------------------
    //   End Simulation
    // ---------------------------------------------------------
    
    repeat(2) @(posedge tb_ib_multb_clk);
    $finish;
    end

endmodule