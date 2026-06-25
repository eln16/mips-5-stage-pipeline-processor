
module regb(
    //input ports
    input logic         ib_regb_clk_n, //System clock
    input logic         ib_regb_rst,
    
    //write port
    input logic         ib_regb_reg_wr,
    input logic [4:0]   ib_regb_wr_addr,
    input logic [31:0]  ib_regb_wr_data,
    
    //read port
    input logic [4:0]   ib_regb_rd_addr1,
    input logic [4:0]   ib_regb_rd_addr2,
    output logic [31:0]  ob_regb_rd_data1,
    output logic [31:0]  ob_regb_rd_data2
    );
 
//internal signals
logic [31:0] registers [1:31];

// Initialize the pointer in regfile when power on
initial begin
    registers[29] = 32'h7FFF_FFFC; // $sp
    registers[30] = 32'h7FFF_FFFC; // $fp
    registers[28] = 32'h1000_8000; // $gp
    
    // Initialize others to 0
    for (int i = 1; i < 32; i++) begin
        if (i != 28 && i != 29 && i != 30) begin
            registers[i] = 32'h0000_0000;
        end
    end
end

//Write operation (synchronous on rising edge of clock)
always_ff @(negedge ib_regb_clk_n, posedge ib_regb_rst) begin
    if (ib_regb_rst) begin
        for (int i = 1; i < 32; i++) begin

            if ( i == 28) begin // $gp
                registers[i] <= 32'h10008000;
            end
            else if ( i == 29) begin // $sp
                registers[i] <= 32'h7FFFFFFC;
            end
            else if ( i == 30) begin // $fp
                registers[i] <= 32'h7FFFFFFC;
            end
            else begin
                registers[i] <= 32'h00000000;
            end

        end        
    end
    
    else if (ib_regb_reg_wr && ib_regb_wr_addr != 5'd0) begin

        registers[ib_regb_wr_addr] <= ib_regb_wr_data;
        
    end 
end

//asynchronous read
always_comb begin 
    //if reading register 0 ($zero), always output 0
    ob_regb_rd_data1 = (ib_regb_rd_addr1 == 5'd0) ? 32'h00000000 : registers[ib_regb_rd_addr1];
    ob_regb_rd_data2 = (ib_regb_rd_addr2 == 5'd0) ? 32'h00000000 : registers[ib_regb_rd_addr2];
end
endmodule
