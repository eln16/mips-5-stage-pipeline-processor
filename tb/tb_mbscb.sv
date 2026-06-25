//##################################################################################################
/*
Project / Module    : tb_mbscb
File name           : tb_mbscb.sv
Version             : 1-0
Date created        : 1 SEPTEMBER 2025
Author              : Elveis Ng Kai Wei
Code type           : Behavioural (System Verilog)
Description         : Testbench for Multiplier and Branch Stall Control Block (mbscb) a module used 
                      to dectect when there is branch equal taken or multiplier working then stall
                      the pipeline regitser.
*/
//##################################################################################################

// Parameters
`define HALF_CLK 5

module tb_mbscb ();
    
    // Multiplier and Branch Stall Input Signals
    logic           tb_ib_mbscb_rst;
    logic           tb_ib_mbscb_beq;
    logic           tb_ib_mbscb_busy;
    
    // Multiplier and Branch Stall Input Signals
    wire            tb_ob_mbscb_nop;


    mbscb
    dut_mbscb
    (
        .ib_mbscb_rst(tb_ib_mbscb_rst),
        .ib_mbscb_beq(tb_ib_mbscb_beq),
        .ib_mbscb_busy(tb_ib_mbscb_busy),
        .ob_mbscb_nop(tb_ob_mbscb_nop)
    );
    
    initial begin
	
	//----------------------------------------------------------
    //   Signal Initialization
    // ---------------------------------------------------------
    
    tb_ib_mbscb_rst = 1'b0;
    tb_ib_mbscb_beq = 1'b0;
    tb_ib_mbscb_busy = 1'b0;
    #(`HALF_CLK * 2);
    
    //----------------------------------------------------------
    //   Test Case 1: BEQ and Multiplier are not working
    // ---------------------------------------------------------
    
    tb_ib_mbscb_rst = 1'b1;
    #(`HALF_CLK * 2)
    tb_ib_mbscb_rst = 1'b0;
    #(`HALF_CLK * 2)
    
    tb_ib_mbscb_beq = 1'b0;
    tb_ib_mbscb_busy = 1'b0;
    #(`HALF_CLK * 2)
    tb_ib_mbscb_beq = 1'b0;
    tb_ib_mbscb_busy = 1'b0;
    #(`HALF_CLK * 2)
    
    //----------------------------------------------------------
    //   Test Case 2: Multiplier working but beq not working
    // ---------------------------------------------------------
    
    tb_ib_mbscb_rst = 1'b1;
    #(`HALF_CLK * 2)
    tb_ib_mbscb_rst = 1'b0;
    #(`HALF_CLK * 2)
    
    tb_ib_mbscb_beq = 1'b0;
    tb_ib_mbscb_busy = 1'b1;
    #(`HALF_CLK * 2)
    tb_ib_mbscb_beq = 1'b0;
    tb_ib_mbscb_busy = 1'b0;
    #(`HALF_CLK * 2)
    
    //----------------------------------------------------------
    //   Test Case 3: Beq working but multiplier not working
    // ---------------------------------------------------------
    
    tb_ib_mbscb_rst = 1'b1;
    #(`HALF_CLK * 2)
    tb_ib_mbscb_rst = 1'b0;
    #(`HALF_CLK * 2)
    
    tb_ib_mbscb_beq = 1'b1;
    tb_ib_mbscb_busy = 1'b0;
    #(`HALF_CLK * 2)
    tb_ib_mbscb_beq = 1'b0;
    tb_ib_mbscb_busy = 1'b0;
    #(`HALF_CLK * 2)
    
    //----------------------------------------------------------
    //   Test Case 4: Both beq and multiplier are working
    // ---------------------------------------------------------
    
    tb_ib_mbscb_rst = 1'b1;
    #(`HALF_CLK * 2)
    tb_ib_mbscb_rst = 1'b0;
    #(`HALF_CLK * 2)
    
    tb_ib_mbscb_beq = 1'b1;
    tb_ib_mbscb_busy = 1'b1;
    #(`HALF_CLK * 2)
    tb_ib_mbscb_beq = 1'b0;
    tb_ib_mbscb_busy = 1'b0;
    #(`HALF_CLK * 2)
    
    
    //----------------------------------------------------------
    //   End Simulation
    // ---------------------------------------------------------
    
    #(`HALF_CLK * 2);
    $finish;
    end
endmodule 