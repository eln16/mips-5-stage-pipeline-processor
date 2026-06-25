//##################################################################################################
/*
Project / Module    : tb_memu
File name           : tb_memu.sv
Version             : 1-0
Date created        : 1 SEPTEMBER 2025
Author              : Elveis Ng Kai Wei
Code type           : Behavioural (System Verilog)
Description         : Testbench for Memory Unit (memu) a module that represent a memory that allow 
                      word and byte addressable. It instantiate Data Memory and Instruction Memory.
*/
//##################################################################################################

// Parameters
`define HALF_CLK 5

module tb_memu ();
    
    // Memory Unit Input Signals
    logic               tb_iu_memu_clk;
    logic               tb_iu_memu_rst;
    logic               tb_iu_memu_mem_rd;
    logic               tb_iu_memu_mem_wr;
    logic               tb_iu_memu_mode;
    logic [31:0]        tb_iu_memu_addr;
    logic [31:0]        tb_iu_memu_wr_data;
    logic [31:0]        tb_iu_memu_rd_addr;
    
    
    // Memory Unit Output Signals
    wire [31:0]         tb_ou_memu_dat_rd_data;
    wire [31:0]         tb_ou_memu_inst_rd_data;
    
    memu
    dut_memu
    (
        .iu_memu_clk(tb_iu_memu_clk),
        .iu_memu_rst(tb_iu_memu_rst),
        .iu_memu_mem_rd(tb_iu_memu_mem_rd),
        .iu_memu_mem_wr(tb_iu_memu_mem_wr),
        .iu_memu_mode(tb_iu_memu_mode),
        .iu_memu_addr(tb_iu_memu_addr),
        .iu_memu_wr_data(tb_iu_memu_wr_data),
        .iu_memu_rd_addr(tb_iu_memu_rd_addr),
        .ou_memu_dat_rd_data(tb_ou_memu_dat_rd_data),
        .ou_memu_inst_rd_data(tb_ou_memu_inst_rd_data)
    );
    
    //----------------------------------------------------------
    //   Clock Wave Generator
    // ---------------------------------------------------------
    
    initial begin
    
        tb_iu_memu_clk = 1'b0;
        forever #(`HALF_CLK) tb_iu_memu_clk = ~tb_iu_memu_clk;
    
    end
    
    initial begin
    
    //----------------------------------------------------------
    //   Signal Initialization
    // ---------------------------------------------------------
    
    tb_iu_memu_rst = 1'b0;
    tb_iu_memu_mem_rd = 1'b0;
    tb_iu_memu_mem_wr = 1'b0;
    tb_iu_memu_mode = 1'b0;
    tb_iu_memu_addr = 32'h0000_0000;
    tb_iu_memu_wr_data = 32'h0000_0000;
    tb_iu_memu_rd_addr = 32'h0000_0000;
    repeat(1) @(negedge tb_iu_memu_clk);
    
    //----------------------------------------------------------
    //   Test Case 1: Instruction Fetch at address = 32'h0040_0004
    // ---------------------------------------------------------
    
    tb_iu_memu_mem_rd = 1'b1;
    tb_iu_memu_mem_wr = 1'b0;
    tb_iu_memu_mode = 1'b1;
    tb_iu_memu_addr = 32'h0000_0000;
    tb_iu_memu_wr_data = 32'h0000_0000;
    tb_iu_memu_rd_addr = 32'h0040_0000;
    repeat(1) @(negedge tb_iu_memu_clk);
    
    //----------------------------------------------------------
    //   Test Case 2: Word Write
    // ---------------------------------------------------------
    
    tb_iu_memu_mem_rd = 1'b0;
    tb_iu_memu_mem_wr = 1'b1;
    tb_iu_memu_mode = 1'b1;
    tb_iu_memu_addr = 32'h1000_0004;
    tb_iu_memu_wr_data = 32'hDEAD_BEEF;
    tb_iu_memu_rd_addr = 32'h0000_0000;
    repeat(1) @(negedge tb_iu_memu_clk);
    
    //----------------------------------------------------------
    //   Test Case 3: Word Read
    // ---------------------------------------------------------
    
    tb_iu_memu_mem_rd = 1'b1;
    tb_iu_memu_mem_wr = 1'b0;
    tb_iu_memu_mode = 1'b1;
    tb_iu_memu_addr = 32'h1000_0004;
    tb_iu_memu_wr_data = 32'h0000_0000;
    tb_iu_memu_rd_addr = 32'h0000_0000;
    repeat(1) @(negedge tb_iu_memu_clk);
    
    //----------------------------------------------------------
    //   Test Case 4: Byte Write
    // ---------------------------------------------------------
    
    tb_iu_memu_mem_rd = 1'b0;
    tb_iu_memu_mem_wr = 1'b1;
    tb_iu_memu_mode = 1'b0;
    tb_iu_memu_addr = 32'h1000_0011;
    tb_iu_memu_wr_data = 32'h0000_00AA;
    tb_iu_memu_rd_addr = 32'h0000_0000;
    repeat(1) @(negedge tb_iu_memu_clk);
    
    //----------------------------------------------------------
    //   Test Case 5: Byte Read
    // ---------------------------------------------------------
    
    tb_iu_memu_mem_rd = 1'b1;
    tb_iu_memu_mem_wr = 1'b0;
    tb_iu_memu_mode = 1'b0;
    tb_iu_memu_addr = 32'h1000_0011;
    tb_iu_memu_wr_data = 32'h0000_0000;
    tb_iu_memu_rd_addr = 32'h0000_0000;
    repeat(1) @(negedge tb_iu_memu_clk);

    //----------------------------------------------------------
    //   End Simulation
    // ---------------------------------------------------------
    
    repeat(1) @(negedge tb_iu_memu_clk);
    $finish;
    
    end
    
endmodule