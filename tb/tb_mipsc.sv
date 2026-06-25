//##################################################################################################
/*
Project / Module    : tb_mipsc
File name           : tb_mipsc.sv
Version             : 1-0
Date created        : 1 SEPTEMBER 2025
Author              : Elveis Ng Kai Wei
Code type           : Behavioural (System Verilog)
Description         : Testbench for MIPS Pipelined Processor Chip Level (mipsc), this module use to
                      implement the Central Processing Unit (cpu) and Memory Unit (memu). 
*/
//##################################################################################################

// Parameters
`define HALF_CLK 5

module tb_mipsc ();

    // MIPS Chip Input Signals
    logic       tb_ic_mipsc_clk;
    logic       tb_ic_mipsc_rst;

    mipsc
    dut_mipsc
    (
        .ic_mipsc_clk(tb_ic_mipsc_clk),
        .ic_mipsc_rst(tb_ic_mipsc_rst)
    );

    //----------------------------------------------------------
    //   Clock Wave Generator
    // ---------------------------------------------------------
    
    initial begin
    
        tb_ic_mipsc_clk = 1'b0;
        forever #(`HALF_CLK) tb_ic_mipsc_clk = ~tb_ic_mipsc_clk;
    
    end
    
    initial begin
    
    //----------------------------------------------------------
    //   Signal Initialization
    // ---------------------------------------------------------
    
    tb_ic_mipsc_rst = 1'b0;
    
    //----------------------------------------------------------
    //   System Reset
    // ---------------------------------------------------------
    
    
    tb_ic_mipsc_rst = 1'b1;
    #(`HALF_CLK * 2);
    tb_ic_mipsc_rst = 1'b0;
    #(`HALF_CLK);
   
    //----------------------------------------------------------
    //   End Simulation
    // ---------------------------------------------------------
    
    repeat(400) @(posedge tb_ic_mipsc_clk);
    $finish;
    end

endmodule