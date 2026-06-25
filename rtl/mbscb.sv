//##################################################################################################
/*
Project / Module    : mbscb
File name           : mbscb.sv
Version             : 1-0
Date created        : 1 SEPTEMBER 2025
Author              : Elveis Ng Kai Wei
Code type           : Behavioural (System Verilog)
Description         : a module used to dectect when there is branch equal taken or multiplier 
                      working then stall the pipeline register.
*/
//##################################################################################################

module mbscb
(
    input           ib_mbscb_rst,
	input 			ib_mbscb_beq, 
	input 			ib_mbscb_busy,
	output logic 	ob_mbscb_nop
);

	always_comb begin
		
		if (ib_mbscb_rst) begin
		  
		    ob_mbscb_nop = 1'b0;
		end
		else begin
            if ( ib_mbscb_busy) begin
                
                ob_mbscb_nop = 1'b1;
            end
            else begin
                ob_mbscb_nop = 1'b0;
            end
		end
	end

endmodule