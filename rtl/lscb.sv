//##################################################################################################
/*
Project / Module    : lscb
File name           : lscb.sv
Version             : 1-0
Date created        : 1 SEPTEMBER 2025
Author              : Elveis Ng Kai Wei
Code type           : RTL Level (System Verilog)
Description         : This block detects load-store hazards by comparing register addresses across 
                      pipeline stages. It outputs a stall signal to prevent data hazards during 
                      memory write operations.

*/
//##################################################################################################


module lscb
(
	input			ib_lscb_rst,
	input			ib_lscb_id_memwr,
	input			ib_lscb_ex_memRead, 
	input [4:0]		ib_lscb_id_rs5, 
	input [4:0]		ib_lscb_id_rt5,
	input [4:0]		ib_lscb_ex_rt5,
	output logic	ob_lscb_nopEX
);

	always_comb begin

		if (ib_lscb_rst) begin

		end
		else begin

			if (ib_lscb_ex_memRead 
			&& ((ib_lscb_id_rs5 == ib_lscb_ex_rt5) 
			|| ((ib_lscb_id_rt5 == ib_lscb_ex_rt5) 
			&& ~ib_lscb_id_memwr)) 
			&& (ib_lscb_ex_rt5 != 0)) begin

				ob_lscb_nopEX = 1'b1;

			end
			else begin
			
			     ob_lscb_nopEX = 1'b0;
			     
			end
		end
	end

endmodule