//##################################################################################################
/*
Project / Module    : tb_fcb
File name           : tb_fcb.sv
Version             : 1-0
Date created        : 1 SEPTEMBER 2025
Author              : Elveis Ng Kai Wei
Code type           : Behavioural (System Verilog)
Description         : Testbench for Forward Control Block (fcb) a module used to handles the 
                      branch forwarding, data forwarding, and load-store forwarding for MIPS 
                      pipelined processor.
*/
//##################################################################################################

// Parameters
`define HALF_CLK 5

module tb_fcb ();

    // Clock and Reset
    logic               tb_ib_fcb_rst;

    // Branch Forward Control Input Signals
    logic			    tb_ib_fcb_b_id_beq;
	logic			    tb_ib_fcb_b_mem_reg_wr;
	logic [4:0]		    tb_ib_fcb_b_mem_rd;
	logic [4:0]		    tb_ib_fcb_b_id_rs;
	logic [4:0]		    tb_ib_fcb_b_id_rt;
    
    // Data Forward Control Input Signals
    logic			    tb_ib_fcb_d_wb_regwr;
	logic				tb_ib_fcb_d_mem_regwr;
	logic [4:0]			tb_ib_fcb_d_mem_rd_rt;
	logic [4:0]			tb_ib_fcb_d_wb_rd_rt;
	logic [4:0]			tb_ib_fcb_d_ex_rt5;
	logic [4:0]			tb_ib_fcb_d_ex_rs5;
    
    // Load-Store Forward Control Input Signals
    logic 			    tb_ib_fcb_l_wb_regwr;
	logic 			    tb_ib_fcb_l_wb_mem2reg;
	logic 			    tb_ib_fcb_l_mem_memwr; 
	logic [4:0] 	    tb_ib_fcb_l_mem_rt5;
	logic [4:0] 	    tb_ib_fcb_l_wb_rt5;
    
    // Branch Forward Control Output Signals
    wire        	    tb_ob_fcb_b_fw_rt;
    wire           	    tb_ob_fcb_b_fw_rs;
    
    // Data Forward Control Output Signals
    wire [1:0]	        tb_ob_fcb_d_fw_rt;
	wire [1:0]          tb_ob_fcb_d_fw_rs;
    
    // Load-Store Forward Control Output Signals
    wire 	            tb_ob_fcb_l_fw_mem;
    
    fcb
    dut_fcb
    (   
        .ib_fcb_rst(tb_ib_fcb_rst),
        .ib_fcb_b_id_beq(tb_ib_fcb_b_id_beq),
        .ib_fcb_b_mem_reg_wr(tb_ib_fcb_b_mem_reg_wr),
        .ib_fcb_b_mem_rd(tb_ib_fcb_b_mem_rd),
	    .ib_fcb_b_id_rs(tb_ib_fcb_b_id_rs),
        .ib_fcb_b_id_rt(tb_ib_fcb_b_id_rt),
        .ib_fcb_d_wb_regwr(tb_ib_fcb_d_wb_regwr),
        .ib_fcb_d_mem_regwr(tb_ib_fcb_d_mem_regwr),
        .ib_fcb_d_mem_rd_rt(tb_ib_fcb_d_mem_rd_rt),
        .ib_fcb_d_wb_rd_rt(tb_ib_fcb_d_wb_rd_rt),
        .ib_fcb_d_ex_rt5(tb_ib_fcb_d_ex_rt5),
        .ib_fcb_d_ex_rs5(tb_ib_fcb_d_ex_rs5),
        .ib_fcb_l_wb_regwr(tb_ib_fcb_l_wb_regwr),
        .ib_fcb_l_wb_mem2reg(tb_ib_fcb_l_wb_mem2reg),
        .ib_fcb_l_mem_memwr(tb_ib_fcb_l_mem_memwr), 
        .ib_fcb_l_mem_rt5(tb_ib_fcb_l_mem_rt5),
        .ib_fcb_l_wb_rt5(tb_ib_fcb_l_wb_rt5),
        .ob_fcb_b_fw_rt(tb_ob_fcb_b_fw_rt),
        .ob_fcb_b_fw_rs(tb_ob_fcb_b_fw_rs),
        .ob_fcb_d_fw_rt(tb_ob_fcb_d_fw_rt),
        .ob_fcb_d_fw_rs(tb_ob_fcb_d_fw_rs),
        .ob_fcb_l_fw_mem(tb_ob_fcb_l_fw_mem)
    );
    
    
    initial begin
    
    //----------------------------------------------------------
    //   Signal Initialization
    // ---------------------------------------------------------
    
    tb_ib_fcb_rst = 1'b0;
    
    tb_ib_fcb_b_id_beq = 1'b0;
	tb_ib_fcb_b_mem_reg_wr = 1'b0;
	tb_ib_fcb_b_mem_rd = 5'h00;
	tb_ib_fcb_b_id_rs = 5'h00;
	tb_ib_fcb_b_id_rt = 5'h00;
    
    tb_ib_fcb_d_wb_regwr = 1'b0;
	tb_ib_fcb_d_mem_regwr = 1'b0;
	tb_ib_fcb_d_mem_rd_rt = 5'h00;
	tb_ib_fcb_d_wb_rd_rt = 5'h00;
	tb_ib_fcb_d_ex_rt5 = 5'h00;
	tb_ib_fcb_d_ex_rs5 = 5'h00;
    
    tb_ib_fcb_l_wb_regwr = 1'b0;
	tb_ib_fcb_l_wb_mem2reg = 1'b0;
	tb_ib_fcb_l_mem_memwr = 1'b0; 
	tb_ib_fcb_l_mem_rt5 = 5'h00;
	tb_ib_fcb_l_wb_rt5 = 5'h00;
	#(`HALF_CLK * 2);
	
	//----------------------------------------------------------
    //   Test Case 1: No Store in MEM Stage
    // ---------------------------------------------------------
    
    tb_ib_fcb_rst = 1'b1;
    #(`HALF_CLK * 2);
    tb_ib_fcb_rst = 1'b0;
    #(`HALF_CLK * 2);
    
    tb_ib_fcb_l_mem_memwr = 1'b0;
	tb_ib_fcb_l_wb_mem2reg = 1'b1;
	tb_ib_fcb_l_wb_regwr = 1'b1;
	tb_ib_fcb_l_mem_rt5 = 5'h05;
	tb_ib_fcb_l_wb_rt5 = 5'h05;
	#(`HALF_CLK * 2);
    tb_ib_fcb_l_mem_memwr = 1'b0;
	tb_ib_fcb_l_wb_mem2reg = 1'b0;
	tb_ib_fcb_l_wb_regwr = 1'b0;
	tb_ib_fcb_l_mem_rt5 = 5'h00;
	tb_ib_fcb_l_wb_rt5 = 5'h00;
	#(`HALF_CLK * 2);
    
    //----------------------------------------------------------
    //   Test Case 2: Store and WB load, but register different
    // ---------------------------------------------------------
    
    tb_ib_fcb_rst = 1'b1;
    #(`HALF_CLK * 2);
    tb_ib_fcb_rst = 1'b0;
    #(`HALF_CLK * 2);
    
    tb_ib_fcb_l_mem_memwr = 1'b1;
	tb_ib_fcb_l_wb_mem2reg = 1'b1;
	tb_ib_fcb_l_wb_regwr = 1'b1;
	tb_ib_fcb_l_mem_rt5 = 5'h03;
	tb_ib_fcb_l_wb_rt5 = 5'h07;
	#(`HALF_CLK * 2);
    tb_ib_fcb_l_mem_memwr = 1'b0;
	tb_ib_fcb_l_wb_mem2reg = 1'b0;
	tb_ib_fcb_l_wb_regwr = 1'b0;
	tb_ib_fcb_l_mem_rt5 = 5'h00;
	tb_ib_fcb_l_wb_rt5 = 5'h00;
	#(`HALF_CLK * 2);
    
    //----------------------------------------------------------
    //   Test Case 3: Store and WB load, same register but is $zero
    // ---------------------------------------------------------
    
    tb_ib_fcb_rst = 1'b1;
    #(`HALF_CLK * 2);
    tb_ib_fcb_rst = 1'b0;
    #(`HALF_CLK * 2);
    
    tb_ib_fcb_l_mem_memwr = 1'b1;
	tb_ib_fcb_l_wb_mem2reg = 1'b1;
	tb_ib_fcb_l_wb_regwr = 1'b1;
	tb_ib_fcb_l_mem_rt5 = 5'h00;
	tb_ib_fcb_l_wb_rt5 = 5'h00;
	#(`HALF_CLK * 2);
    tb_ib_fcb_l_mem_memwr = 1'b0;
	tb_ib_fcb_l_wb_mem2reg = 1'b0;
	tb_ib_fcb_l_wb_regwr = 1'b0;
	tb_ib_fcb_l_mem_rt5 = 5'h00;
	tb_ib_fcb_l_wb_rt5 = 5'h00;
	#(`HALF_CLK * 2);
	
	//----------------------------------------------------------
    //   Test Case 4: Load-Store Forwarding Required
    // ---------------------------------------------------------
    
    tb_ib_fcb_rst = 1'b1;
    #(`HALF_CLK * 2);
    tb_ib_fcb_rst = 1'b0;
    #(`HALF_CLK * 2);
    
    tb_ib_fcb_l_mem_memwr = 1'b1;
	tb_ib_fcb_l_wb_mem2reg = 1'b1;
	tb_ib_fcb_l_wb_regwr = 1'b1;
	tb_ib_fcb_l_mem_rt5 = 5'h08;
	tb_ib_fcb_l_wb_rt5 = 5'h08;
	#(`HALF_CLK * 2);
    tb_ib_fcb_l_mem_memwr = 1'b0;
	tb_ib_fcb_l_wb_mem2reg = 1'b0;
	tb_ib_fcb_l_wb_regwr = 1'b0;
	tb_ib_fcb_l_mem_rt5 = 5'h00;
	tb_ib_fcb_l_wb_rt5 = 5'h00;
	#(`HALF_CLK * 2);
	
	//----------------------------------------------------------
    //   Test Case 5: MEM Data Hazard on $rs
    // ---------------------------------------------------------
    
    tb_ib_fcb_rst = 1'b1;
    #(`HALF_CLK * 2);
    tb_ib_fcb_rst = 1'b0;
    #(`HALF_CLK * 2);
    
	tb_ib_fcb_d_mem_regwr = 1'b1;
	tb_ib_fcb_d_wb_regwr = 1'b0;
	tb_ib_fcb_d_ex_rs5 = 5'h05;
	tb_ib_fcb_d_ex_rt5 = 5'h02;
	tb_ib_fcb_d_mem_rd_rt = 5'h05;
	tb_ib_fcb_d_wb_rd_rt = 5'h00;
	#(`HALF_CLK * 2);
	tb_ib_fcb_d_mem_regwr = 1'b0;
	tb_ib_fcb_d_wb_regwr = 1'b0;
	tb_ib_fcb_d_ex_rs5 = 5'h00;
	tb_ib_fcb_d_ex_rt5 = 5'h00;
	tb_ib_fcb_d_mem_rd_rt = 5'h00;
	tb_ib_fcb_d_wb_rd_rt = 5'h00;
	#(`HALF_CLK * 2);
	
	//----------------------------------------------------------
    //   Test Case 6: MEM Data Hazard on $rt
    // ---------------------------------------------------------
    
    tb_ib_fcb_rst = 1'b1;
    #(`HALF_CLK * 2);
    tb_ib_fcb_rst = 1'b0;
    #(`HALF_CLK * 2);
    
	tb_ib_fcb_d_mem_regwr = 1'b1;
	tb_ib_fcb_d_wb_regwr = 1'b0;
	tb_ib_fcb_d_ex_rs5 = 5'h02;
	tb_ib_fcb_d_ex_rt5 = 5'h06;
	tb_ib_fcb_d_mem_rd_rt = 5'h06;
	tb_ib_fcb_d_wb_rd_rt = 5'h00;
	#(`HALF_CLK * 2);
	tb_ib_fcb_d_mem_regwr = 1'b0;
	tb_ib_fcb_d_wb_regwr = 1'b0;
	tb_ib_fcb_d_ex_rs5 = 5'h00;
	tb_ib_fcb_d_ex_rt5 = 5'h00;
	tb_ib_fcb_d_mem_rd_rt = 5'h00;
	tb_ib_fcb_d_wb_rd_rt = 5'h00;
	#(`HALF_CLK * 2);
	
	//----------------------------------------------------------
    //   Test Case 7: WB Data Hazard on $rs
    // ---------------------------------------------------------
    
    tb_ib_fcb_rst = 1'b1;
    #(`HALF_CLK * 2);
    tb_ib_fcb_rst = 1'b0;
    #(`HALF_CLK * 2);
    
	tb_ib_fcb_d_mem_regwr = 1'b0;
	tb_ib_fcb_d_wb_regwr = 1'b1;
	tb_ib_fcb_d_ex_rs5 = 5'h07;
	tb_ib_fcb_d_ex_rt5 = 5'h03;
	tb_ib_fcb_d_mem_rd_rt = 5'h00;
	tb_ib_fcb_d_wb_rd_rt = 5'h07;
	#(`HALF_CLK * 2);
	tb_ib_fcb_d_mem_regwr = 1'b0;
	tb_ib_fcb_d_wb_regwr = 1'b0;
	tb_ib_fcb_d_ex_rs5 = 5'h00;
	tb_ib_fcb_d_ex_rt5 = 5'h00;
	tb_ib_fcb_d_mem_rd_rt = 5'h00;
	tb_ib_fcb_d_wb_rd_rt = 5'h00;
	#(`HALF_CLK * 2);
	
	//----------------------------------------------------------
    //   Test Case 8: WB Data Hazard on $rt
    // ---------------------------------------------------------
    
    tb_ib_fcb_rst = 1'b1;
    #(`HALF_CLK * 2);
    tb_ib_fcb_rst = 1'b0;
    #(`HALF_CLK * 2);
    
	tb_ib_fcb_d_mem_regwr = 1'b0;
	tb_ib_fcb_d_wb_regwr = 1'b1;
	tb_ib_fcb_d_ex_rs5 = 5'h03;
	tb_ib_fcb_d_ex_rt5 = 5'h07;
	tb_ib_fcb_d_mem_rd_rt = 5'h00;
	tb_ib_fcb_d_wb_rd_rt = 5'h07;
	#(`HALF_CLK * 2);
	tb_ib_fcb_d_mem_regwr = 1'b0;
	tb_ib_fcb_d_wb_regwr = 1'b0;
	tb_ib_fcb_d_ex_rs5 = 5'h00;
	tb_ib_fcb_d_ex_rt5 = 5'h00;
	tb_ib_fcb_d_mem_rd_rt = 5'h00;
	tb_ib_fcb_d_wb_rd_rt = 5'h00;
	#(`HALF_CLK * 2);
	
	//----------------------------------------------------------
    //   Test Case 9: No Data Hazard
    // ---------------------------------------------------------
    
    tb_ib_fcb_rst = 1'b1;
    #(`HALF_CLK * 2);
    tb_ib_fcb_rst = 1'b0;
    #(`HALF_CLK * 2);
    
	tb_ib_fcb_d_mem_regwr = 1'b0;
	tb_ib_fcb_d_wb_regwr = 1'b0;
	tb_ib_fcb_d_ex_rs5 = 5'h03;
	tb_ib_fcb_d_ex_rt5 = 5'h04;
	tb_ib_fcb_d_mem_rd_rt = 5'h00;
	tb_ib_fcb_d_wb_rd_rt = 5'h00;
	#(`HALF_CLK * 2);
	tb_ib_fcb_d_mem_regwr = 1'b0;
	tb_ib_fcb_d_wb_regwr = 1'b0;
	tb_ib_fcb_d_ex_rs5 = 5'h00;
	tb_ib_fcb_d_ex_rt5 = 5'h00;
	tb_ib_fcb_d_mem_rd_rt = 5'h00;
	tb_ib_fcb_d_wb_rd_rt = 5'h00;
	#(`HALF_CLK * 2);
	
	//----------------------------------------------------------
    //   Test Case 10: BEQ, but MEM.RegWrite is 0
    // ---------------------------------------------------------
    
    tb_ib_fcb_rst = 1'b1;
    #(`HALF_CLK * 2);
    tb_ib_fcb_rst = 1'b0;
    #(`HALF_CLK * 2);
    
    tb_ib_fcb_b_id_beq = 1'b1;
	tb_ib_fcb_b_mem_reg_wr = 1'b0;
	tb_ib_fcb_b_mem_rd = 5'h06;
	tb_ib_fcb_b_id_rs = 5'h06;
	tb_ib_fcb_b_id_rt = 5'h06;
    #(`HALF_CLK * 2);
    tb_ib_fcb_b_id_beq = 1'b0;
	tb_ib_fcb_b_mem_reg_wr = 1'b0;
	tb_ib_fcb_b_mem_rd = 5'h00;
	tb_ib_fcb_b_id_rs = 5'h00;
	tb_ib_fcb_b_id_rt = 5'h00;
	#(`HALF_CLK * 2);
	
	//------------------------------------------------------------------
    //   Test Case 11: BEQ, MEM.RegWrite is 1, ID.rs matches MEM.rd
    // -----------------------------------------------------------------
    
    tb_ib_fcb_rst = 1'b1;
    #(`HALF_CLK * 2);
    tb_ib_fcb_rst = 1'b0;
    #(`HALF_CLK * 2);
    
    tb_ib_fcb_b_id_beq = 1'b1;
	tb_ib_fcb_b_mem_reg_wr = 1'b1;
	tb_ib_fcb_b_mem_rd = 5'h07;
	tb_ib_fcb_b_id_rs = 5'h07;
	tb_ib_fcb_b_id_rt = 5'h03;
    #(`HALF_CLK * 2);
    tb_ib_fcb_b_id_beq = 1'b0;
	tb_ib_fcb_b_mem_reg_wr = 1'b0;
	tb_ib_fcb_b_mem_rd = 5'h00;
	tb_ib_fcb_b_id_rs = 5'h00;
	tb_ib_fcb_b_id_rt = 5'h00;
	#(`HALF_CLK * 2);
	
	//------------------------------------------------------------------
    //   Test Case 12: BEQ, MEM.RegWrite is 1, ID.rt matches MEM.rd
    // -----------------------------------------------------------------
    
    tb_ib_fcb_rst = 1'b1;
    #(`HALF_CLK * 2);
    tb_ib_fcb_rst = 1'b0;
    #(`HALF_CLK * 2);
    
    tb_ib_fcb_b_id_beq = 1'b1;
	tb_ib_fcb_b_mem_reg_wr = 1'b1;
	tb_ib_fcb_b_mem_rd = 5'h04;
	tb_ib_fcb_b_id_rs = 5'h02;
	tb_ib_fcb_b_id_rt = 5'h04;
    #(`HALF_CLK * 2);
    tb_ib_fcb_b_id_beq = 1'b0;
	tb_ib_fcb_b_mem_reg_wr = 1'b0;
	tb_ib_fcb_b_mem_rd = 5'h00;
	tb_ib_fcb_b_id_rs = 5'h00;
	tb_ib_fcb_b_id_rt = 5'h00;
	#(`HALF_CLK * 2);
	
	//------------------------------------------------------------------
    //   Test Case 13: BEQ, MEM.RegWrite is 1, ID.rt and ID.rs matches MEM.rd
    // -----------------------------------------------------------------
    
    tb_ib_fcb_rst = 1'b1;
    #(`HALF_CLK * 2);
    tb_ib_fcb_rst = 1'b0;
    #(`HALF_CLK * 2);
    
    tb_ib_fcb_b_id_beq = 1'b1;
	tb_ib_fcb_b_mem_reg_wr = 1'b1;
	tb_ib_fcb_b_mem_rd = 5'h04;
	tb_ib_fcb_b_id_rs = 5'h04;
	tb_ib_fcb_b_id_rt = 5'h04;
    #(`HALF_CLK * 2);
    tb_ib_fcb_b_id_beq = 1'b0;
	tb_ib_fcb_b_mem_reg_wr = 1'b0;
	tb_ib_fcb_b_mem_rd = 5'h00;
	tb_ib_fcb_b_id_rs = 5'h00;
	tb_ib_fcb_b_id_rt = 5'h00;
	#(`HALF_CLK * 2);
	
    //----------------------------------------------------------
    //   End Simulation
    // ---------------------------------------------------------
    
    #(`HALF_CLK * 20);
    $finish;
    
    end

endmodule