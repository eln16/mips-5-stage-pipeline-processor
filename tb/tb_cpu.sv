module tb_cpu;

    // Clock and Reset
    logic iu_cpu_clk;
    logic iu_cpu_rst;

    // Inputs from memu to cpu
    logic [31:0] iu_cpu_inst_rd_data;
    logic [31:0] iu_cpu_dat_rd_data;

    // Outputs from cpu to memu
    logic [31:0] ou_cpu_inst_rd_addr;
    logic [31:0] ou_cpu_wr_data;
    logic [31:0] ou_cpu_addr;
    logic       ou_cpu_mem_wr;

    // Instantiate the DUT
    cpu uut (
        .iu_cpu_clk(iu_cpu_clk),
        .iu_cpu_rst(iu_cpu_rst),
        .iu_cpu_inst_rd_data(iu_cpu_inst_rd_data),
        .iu_cpu_dat_rd_data(iu_cpu_dat_rd_data),
        .ou_cpu_inst_rd_addr(ou_cpu_inst_rd_addr),
        .ou_cpu_wr_data(ou_cpu_wr_data),
        .ou_cpu_addr(ou_cpu_addr),
        .ou_cpu_mem_wr(ou_cpu_mem_wr)
    );

    // Clock generation
    initial begin
        iu_cpu_clk = 0;
        forever #5 iu_cpu_clk = ~iu_cpu_clk; // 10ns clock period
    end

    // Main test sequence
    initial begin
        // --- Initial state ---
        iu_cpu_rst = 0;
        iu_cpu_inst_rd_data = 32'b0;
        iu_cpu_dat_rd_data  = 32'b0;

        // --- Test 1: Register Adressing ---
        iu_cpu_inst_rd_data = 32'h20090032; 
        #5
        iu_cpu_inst_rd_data = 32'h20080032; 
        #5
        
        // --- Test 2: Register Adressing ---
        //Setup
        iu_cpu_inst_rd_data = 32'h01095020;
        #10
        

        
        // --- End of Test ---
        #50;
        $stop; // End simulation (manual check in waveform/memory window)
    end

endmodule