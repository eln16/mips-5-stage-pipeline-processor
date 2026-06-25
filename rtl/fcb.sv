//##################################################################################################
/*
Project / Module    : fscb
File name           : fcb.sv
Version             : 1-0
Date created        : 1 SEPTEMBER 2025
Author              : Elveis Ng Kai Wei
Code type           : Behavioural (System Verilog)
Description         : a module used to detect Data, Branch, Loasd-Store Frowarding
*/
//##################################################################################################

module fcb
(
	// Reset Signal
	input				ib_fcb_rst,

    // Branch Forward Control Inputs
    input			    ib_fcb_b_id_beq,
	input			    ib_fcb_b_mem_reg_wr,
	input [4:0]		    ib_fcb_b_mem_rd,
	input [4:0]		    ib_fcb_b_id_rs,
	input [4:0]		    ib_fcb_b_id_rt,

    // Data Forward Control Inputs
    input			    ib_fcb_d_wb_regwr,
	input				ib_fcb_d_mem_regwr,
	input [4:0]			ib_fcb_d_mem_rd_rt,
	input [4:0]			ib_fcb_d_wb_rd_rt,
	input [4:0]			ib_fcb_d_ex_rt5,
	input [4:0]			ib_fcb_d_ex_rs5,

    // Load-Store Forward Control Inputs
    input 			    ib_fcb_l_wb_regwr,
	input 			    ib_fcb_l_wb_mem2reg,
	input 			    ib_fcb_l_mem_memwr, 
	input [4:0] 	    ib_fcb_l_mem_rt5,
	input [4:0] 	    ib_fcb_l_wb_rt5,

    // Branch Forward Control Outputs
	output logic	    ob_fcb_b_fw_rt,
	output logic	    ob_fcb_b_fw_rs,

    // Data Forward Control Outputs
    output logic [1:0]	ob_fcb_d_fw_rt,
	output logic [1:0]	ob_fcb_d_fw_rs,

    // Load-Store Forward Control Outputs
    output logic 	    ob_fcb_l_fw_mem
);


    // Branch Forward Control Logic
    always_comb begin

		if (ib_fcb_rst) begin

			ob_fcb_b_fw_rs = 0;
			ob_fcb_b_fw_rt = 0;

		end
		else begin
			if (ib_fcb_b_id_beq
			&& (ib_fcb_b_id_rs == ib_fcb_b_mem_rd)
			&& ib_fcb_b_mem_reg_wr
			&& (ib_fcb_b_mem_rd != 0)) begin

				ob_fcb_b_fw_rs = 1;

			end
			else begin

				ob_fcb_b_fw_rs = 0;
			
			end

			if (ib_fcb_b_id_beq
			&& (ib_fcb_b_id_rt == ib_fcb_b_mem_rd)
			&& ib_fcb_b_mem_reg_wr
			&& (ib_fcb_b_mem_rd != 0)) begin

				ob_fcb_b_fw_rt = 1;

			end
			else begin

				ob_fcb_b_fw_rt = 0;
			
			end
		end
	end

    // Data Forward Control Logic
    always_comb begin

		if (ib_fcb_rst) begin

			ob_fcb_d_fw_rs = 2'b00;
			ob_fcb_d_fw_rt = 2'b00;
		
		end
		else begin

			// $rs MEM Hazard
			if ((ib_fcb_d_ex_rs5 == ib_fcb_d_mem_rd_rt)
			&& ib_fcb_d_mem_regwr
			&& (ib_fcb_d_mem_rd_rt != 0)) begin

				ob_fcb_d_fw_rs = 2'b10;
			
			end
			// $rs WB Hazard
			else if ((ib_fcb_d_ex_rs5 == ib_fcb_d_wb_rd_rt)
			&& ib_fcb_d_wb_regwr
			&& (ib_fcb_d_wb_rd_rt != 0)
			&& ((ib_fcb_d_mem_rd_rt != ib_fcb_d_ex_rs5) || (ib_fcb_d_mem_regwr == 0))) begin

				ob_fcb_d_fw_rs = 2'b01;
			
			end

			else
				ob_fcb_d_fw_rs = 2'b00;


			// $rt MEM Hazard
			if ((ib_fcb_d_ex_rt5 == ib_fcb_d_mem_rd_rt)
			&& ib_fcb_d_mem_regwr
			&& (ib_fcb_d_mem_rd_rt != 0)) begin

				ob_fcb_d_fw_rt = 2'b10;
			
			end

			// $rt WB Hazard
			else if ((ib_fcb_d_ex_rt5 == ib_fcb_d_wb_rd_rt)
			&& ib_fcb_d_wb_regwr
			&& (ib_fcb_d_wb_rd_rt != 0)
			&& ((ib_fcb_d_mem_rd_rt != ib_fcb_d_ex_rs5) || (ib_fcb_d_mem_regwr == 0))) begin

				ob_fcb_d_fw_rt = 2'b01;
			
			end

			else 
				ob_fcb_d_fw_rt = 2'b00;

		end
	end

    // Load-Use Forward Control Logic
    always_comb begin

		if (ib_fcb_rst) begin

			ob_fcb_l_fw_mem = 1'b0;
			
		end
		else begin

			if (ib_fcb_l_mem_memwr 
			&& (ib_fcb_l_wb_mem2reg && ib_fcb_l_wb_regwr) 
			&& (ib_fcb_l_mem_rt5 == ib_fcb_l_wb_rt5) 
			&& (ib_fcb_l_wb_rt5 != 0)) begin

				ob_fcb_l_fw_mem = 1'b1;

			end
			else begin

				ob_fcb_l_fw_mem = 1'b0;

			end

		end
	end

endmodule