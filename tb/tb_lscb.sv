//##################################################################################################
/*
Project / Module    : tb_lscb
File name           : tb_lscb.sv
Version             : 1-0
Date created        : 1 SEPTEMBER 2025
Author              : Elveis Ng Kai Wei
Code type           : Behavioural (System Verilog)
Description         : Testbench for Load-Use Stall Control Block (lscb) a module used to handles the 
                      stalling of control signal from main control and the pipeline register.
*/
//##################################################################################################
// Parameters
`define HALF_CLK 5

module tb_lscb ();
    
    // Load-Use Stall Input Signals
    logic			tb_ib_lscb_rst;
	logic			tb_ib_lscb_id_memwr;
	logic			tb_ib_lscb_ex_memRead;
	logic [4:0]		tb_ib_lscb_id_rs5;
	logic [4:0]		tb_ib_lscb_id_rt5;
	logic [4:0]		tb_ib_lscb_ex_rt5;
	
	// Load-Use Stall Output Signals
	wire	        tb_ob_lscb_nopEX;
	
	lscb
	dut_lscb
	(
	   .ib_lscb_rst(tb_ib_lscb_rst),
	   .ib_lscb_id_memwr(tb_ib_lscb_id_memwr),
	   .ib_lscb_ex_memRead(tb_ib_lscb_ex_memRead),
	   .ib_lscb_id_rs5(tb_ib_lscb_id_rs5),
	   .ib_lscb_id_rt5(tb_ib_lscb_id_rt5),
	   .ib_lscb_ex_rt5(tb_ib_lscb_ex_rt5),
	   .ob_lscb_nopEX(tb_ob_lscb_nopEX)
	);
	
	
	initial begin
	
	//----------------------------------------------------------
    //   Signal Initialization
    // ---------------------------------------------------------
	tb_ib_lscb_rst = 1'b0;
	tb_ib_lscb_id_memwr = 1'b0;
	tb_ib_lscb_ex_memRead = 1'b0;
	tb_ib_lscb_id_rs5 = 5'h00;
	tb_ib_lscb_id_rt5 = 5'h00;
	tb_ib_lscb_ex_rt5 = 5'h00;
	#(`HALF_CLK * 2);
	
	
	//----------------------------------------------------------
    //   Test Case 1: Load-use hazard on $rs
    // ---------------------------------------------------------
    
	tb_ib_lscb_rst = 1'b1;
	#(`HALF_CLK * 2);
	tb_ib_lscb_rst = 0;
	#(`HALF_CLK * 2);
	
	tb_ib_lscb_id_memwr = 1'b0;
	tb_ib_lscb_ex_memRead = 1'b1;
	tb_ib_lscb_id_rs5 = 5'h05;
	tb_ib_lscb_id_rt5 = 5'h06;
	tb_ib_lscb_ex_rt5 = 5'h05;
	#(`HALF_CLK * 2);
	tb_ib_lscb_rst = 1'b0;
	tb_ib_lscb_id_memwr = 1'b0;
	tb_ib_lscb_ex_memRead = 1'b0;
	tb_ib_lscb_id_rs5 = 5'h00;
	tb_ib_lscb_id_rt5 = 5'h00;
	tb_ib_lscb_ex_rt5 = 5'h00;
	#(`HALF_CLK * 2);
	
	//----------------------------------------------------------
    //   Test Case 2: Load-use hazard on $rt
    // ---------------------------------------------------------
    
    tb_ib_lscb_rst = 1'b1;
	#(`HALF_CLK * 2);
	tb_ib_lscb_rst = 0;
	#(`HALF_CLK * 2);
	
	tb_ib_lscb_id_memwr = 1'b0;
	tb_ib_lscb_ex_memRead = 1'b1;
	tb_ib_lscb_id_rs5 = 5'h06;
	tb_ib_lscb_id_rt5 = 5'h05;
	tb_ib_lscb_ex_rt5 = 5'h05;
	#(`HALF_CLK * 2);
	tb_ib_lscb_rst = 1'b0;
	tb_ib_lscb_id_memwr = 1'b0;
	tb_ib_lscb_ex_memRead = 1'b0;
	tb_ib_lscb_id_rs5 = 5'h00;
	tb_ib_lscb_id_rt5 = 5'h00;
	tb_ib_lscb_ex_rt5 = 5'h00;
	#(`HALF_CLK * 2);
	
	//----------------------------------------------------------
    //   Test Case 3: Store (So no need stall)
    // ---------------------------------------------------------
    
    tb_ib_lscb_rst = 1'b1;
	#(`HALF_CLK * 2);
	tb_ib_lscb_rst = 0;
	#(`HALF_CLK * 2);
	
	tb_ib_lscb_id_memwr = 1'b1;
	tb_ib_lscb_ex_memRead = 1'b1;
	tb_ib_lscb_id_rs5 = 5'h06;
	tb_ib_lscb_id_rt5 = 5'h05;
	tb_ib_lscb_ex_rt5 = 5'h05;
	#(`HALF_CLK * 2);
	tb_ib_lscb_rst = 1'b0;
	tb_ib_lscb_id_memwr = 1'b0;
	tb_ib_lscb_ex_memRead = 1'b0;
	tb_ib_lscb_id_rs5 = 5'h00;
	tb_ib_lscb_id_rt5 = 5'h00;
	tb_ib_lscb_ex_rt5 = 5'h00;
	#(`HALF_CLK * 2);
	
	//----------------------------------------------------------
    //   Test Case 4: No hazard
    // ---------------------------------------------------------
    
    tb_ib_lscb_rst = 1'b1;
	#(`HALF_CLK * 2);
	tb_ib_lscb_rst = 0;
	#(`HALF_CLK * 2);
	
	tb_ib_lscb_id_memwr = 1'b1;
	tb_ib_lscb_ex_memRead = 1'b0;
	tb_ib_lscb_id_rs5 = 5'h06;
	tb_ib_lscb_id_rt5 = 5'h05;
	tb_ib_lscb_ex_rt5 = 5'h05;
	#(`HALF_CLK * 2);
	tb_ib_lscb_rst = 1'b0;
	tb_ib_lscb_id_memwr = 1'b0;
	tb_ib_lscb_ex_memRead = 1'b0;
	tb_ib_lscb_id_rs5 = 5'h00;
	tb_ib_lscb_id_rt5 = 5'h00;
	tb_ib_lscb_ex_rt5 = 5'h00;
	#(`HALF_CLK * 2);
	
	//----------------------------------------------------------
    //   End Simulation
    // ---------------------------------------------------------
    
    #(`HALF_CLK * 20);
    $finish;
	
	end


endmodule