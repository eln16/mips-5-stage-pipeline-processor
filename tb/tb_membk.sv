//##################################################################################################
/*
Project / Module    : tb_membk
File name           : tb_membk.sv
Version             : 1-0
Date created        : 1 SEPTEMBER 2025
Author              : Elveis Ng Kai Wei
Code type           : Behavioural (System Verilog)
Description         : Testbench for Memory Bank (membk) a module that represent a memory that allow 
                      word and byte addressable 
*/
//##################################################################################################
// Parameters
`define HALF_CLK 5

module tb_membk ();

    // Memory Bank Input Signals
    logic               tb_ib_membk_clk;
    logic               tb_ib_membk_rst;
    logic               tb_ib_membk_mem_rd;
    logic               tb_ib_membk_mem_wr;
    logic               tb_ib_membk_mode;
    logic [31:0]        tb_ib_membk_addr;
    logic [31:0]        tb_ib_membk_wr_data;
    
    // Memory Bank Output Signal
    wire [31:0]         tb_ob_membk_rd_data;
    
    membk
    #(
        .MEM_DEPTH(2048)
    )
    dut_membk
    (
        .ib_membk_clk(tb_ib_membk_clk),
        .ib_membk_rst(tb_ib_membk_rst),
        .ib_membk_mem_rd(tb_ib_membk_mem_rd),
        .ib_membk_mem_wr(tb_ib_membk_mem_wr),
        .ib_membk_mode(tb_ib_membk_mode),
        .ib_membk_addr(tb_ib_membk_addr),
        .ib_membk_wr_data(tb_ib_membk_wr_data),
        .ob_membk_rd_data(tb_ob_membk_rd_data)
    );
    
    //----------------------------------------------------------
    //   Clock Wave Generator
    // ---------------------------------------------------------
    
    initial begin
    
        tb_ib_membk_clk = 1'b0;
        forever #(`HALF_CLK) tb_ib_membk_clk = ~tb_ib_membk_clk;
    
    end
    
    initial begin
    
    //----------------------------------------------------------
    //   Signal Initialization
    // ---------------------------------------------------------
    
    tb_ib_membk_rst = 1'b0;
    tb_ib_membk_mem_rd = 1'b0;
    tb_ib_membk_mem_wr = 1'b0;
    tb_ib_membk_mode = 1'b0;
    tb_ib_membk_addr = 32'h0000_0000;
    tb_ib_membk_wr_data = 32'h0000_0000;
    repeat(1) @(negedge tb_ib_membk_clk);
    
    //----------------------------------------------------------
    //   Test Case 1: System Reset
    // ---------------------------------------------------------
    
    tb_ib_membk_rst = 1'b1;
    repeat(1) @(negedge tb_ib_membk_clk);
    tb_ib_membk_rst = 1'b0;
    repeat(1) @(negedge tb_ib_membk_clk);
    
    //----------------------------------------------------------
    //   Test Case 2: Word Write
    // ---------------------------------------------------------
    
    tb_ib_membk_mode = 1'b1;
    tb_ib_membk_addr = 32'h0000_0004;
    tb_ib_membk_wr_data = 32'hDEAD_BEEF;
    tb_ib_membk_mem_rd = 1'b0;
    tb_ib_membk_mem_wr = 1'b1;
    repeat(1) @(negedge tb_ib_membk_clk);
    
    
    //----------------------------------------------------------
    //   Test Case 3: Word Read
    // ---------------------------------------------------------
    
    tb_ib_membk_mode = 1'b1;
    tb_ib_membk_addr = 32'h0000_0004;
    tb_ib_membk_wr_data = 32'h0000_0000;
    tb_ib_membk_mem_rd = 1'b1;
    tb_ib_membk_mem_wr = 1'b0;
    repeat(1) @(negedge tb_ib_membk_clk);
    tb_ib_membk_mem_rd = 1'b0;
    
    //----------------------------------------------------------
    //   Test Case 4: Byte Write
    // ---------------------------------------------------------
    
    
    tb_ib_membk_mode = 1'b0;
    tb_ib_membk_addr = 32'h0000_0011;
    tb_ib_membk_wr_data = 32'h0000_00AA;
    tb_ib_membk_mem_rd = 1'b0;
    tb_ib_membk_mem_wr = 1'b1;
    repeat(1) @(negedge tb_ib_membk_clk);
    
    //----------------------------------------------------------
    //   Test Case 5: Byte Read
    // ---------------------------------------------------------
    
    
    tb_ib_membk_mode = 1'b0;
    tb_ib_membk_addr = 32'h0000_0011;
    tb_ib_membk_wr_data = 32'h0000_0000;
    tb_ib_membk_mem_rd = 1'b1;
    tb_ib_membk_mem_wr = 1'b0;
    repeat(1) @(negedge tb_ib_membk_clk);
    tb_ib_membk_mem_rd = 1'b0;
    
    //----------------------------------------------------------
    //   End Simulation
    // ---------------------------------------------------------
    
    repeat(2) @(negedge tb_ib_membk_clk);
    $finish;
    end

endmodule