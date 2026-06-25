//////////////////////////////////////////////////////////////////////////////////

/* 
Project / Module    : membk.sv
File name           : membk.sv 
Version             : 1.0
Date created        : 09 September 2025
Author              : Elveis Ng Kai Wei
Code type           : RTL Level (System Verilog) 
Description         : This module handles data memory access for load and store 
                      operations. It supports both byte-addressable and word-addressable 
                      modes, controlled by a mode select signal. The block takes in a 
                      memory address, data to write, and control signals to determine 
                      whether to perform a read or write. Data read from memory is registered 
                      and provided as output. The module is synchronized by a system clock 
                      and uses an asynchronous reset.

*/

//////////////////////////////////////////////////////////////////////////////////


module membk
#(
    parameter   MEM_DEPTH = "",  // Memory depth in words
    parameter   MEM_FILE = ""       // Memory initialization file
)
(
    input               ib_membk_clk,
    input               ib_membk_rst,
    input               ib_membk_mem_rd,    // Read enable
    input               ib_membk_mem_wr,    // Write enable
    input               ib_membk_mode,      // 1 = word mode, 0 = byte mode
    input [31:0]        ib_membk_addr,      // Memory address
    input [31:0]        ib_membk_wr_data,   // Write Data
    output logic [31:0] ob_membk_rd_data    // Read Data
);

    // Little Endian Memory Banks
    // MEM_DEPTH = words size
    // Each Bank stores MEM_DEPTH bytes
    // Total Memory size = MEM_DEPTH * 4 banks
    logic [7:0] bank0 [0:MEM_DEPTH-1];
    logic [7:0] bank1 [0:MEM_DEPTH-1];
    logic [7:0] bank2 [0:MEM_DEPTH-1];
    logic [7:0] bank3 [0:MEM_DEPTH-1];
    

    // Instruction Memory File Initialization 
    logic [31:0] temp_mem [0:MEM_DEPTH-1];

    // Word Index Address Calculation
    logic [$clog2(MEM_DEPTH)-1:0] word_addr;
    logic [1:0] bank_sel;

    assign word_addr = ib_membk_addr[31:2];
    assign bank_sel = ib_membk_addr[1:0];
    
    // Write Logic
    always_ff @(posedge ib_membk_clk) begin

        if (ib_membk_rst) begin
    
            for (int i = 0; i < MEM_DEPTH; i++) begin
                bank0[i] = '0;
                bank1[i] = '0;
                bank2[i] = '0;
                bank3[i] = '0;
                temp_mem[i] = '0;
            end
                
            if (MEM_FILE != "") begin
                $readmemh(MEM_FILE, temp_mem);
                for (int i = 0; i < MEM_DEPTH; i++) begin
                    bank0[i] = temp_mem[i][7:0];
                    bank1[i] = temp_mem[i][15:8];
                    bank2[i] = temp_mem[i][23:16];
                    bank3[i] = temp_mem[i][31:24];
                end
            end
        end
        
        else if (ib_membk_mem_wr) begin
            // Write Word (sw)
            if (ib_membk_mode) begin
    
                bank0[word_addr] <= ib_membk_wr_data[7:0];
                bank1[word_addr] <= ib_membk_wr_data[15:8];
                bank2[word_addr] <= ib_membk_wr_data[23:16];
                bank3[word_addr] <= ib_membk_wr_data[31:24];
    
            end
            // Write Byte (sb)
            else begin
    
                case (bank_sel)
                    2'b00: bank0[word_addr] <= ib_membk_wr_data[7:0];
                    2'b01: bank1[word_addr] <= ib_membk_wr_data[7:0];
                    2'b10: bank2[word_addr] <= ib_membk_wr_data[7:0];
                    2'b11: bank3[word_addr] <= ib_membk_wr_data[7:0];
                endcase
    
            end
        end
    end

    // Read Logic
    always_comb begin

        if (ib_membk_rst) begin

            ob_membk_rd_data = '0;

        end
        
        else if (ib_membk_mem_rd) begin
            // Read Word (lw)
            if (ib_membk_mode) begin
    
                ob_membk_rd_data = {bank3[word_addr], bank2[word_addr], bank1[word_addr], bank0[word_addr]};
    
            end
            // Read Byte (lb)
            else begin
                
                // Load 8 bits data with zero extend
                case (bank_sel)
                    2'b00: ob_membk_rd_data = {24'h00_0000, bank0[word_addr]};
                    2'b01: ob_membk_rd_data = {24'h00_0000, bank1[word_addr]};
                    2'b10: ob_membk_rd_data = {24'h00_0000, bank2[word_addr]};
                    2'b11: ob_membk_rd_data = {24'h00_0000, bank3[word_addr]};
                endcase
    
            end
        end
        else begin
        
            ob_membk_rd_data = '0;
            
        end
    end

endmodule