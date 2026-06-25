module tb_regb;
    //input ports
    logic         ib_regb_clk; //System clock
    logic         ib_regb_rst;
    
    //write port
    logic         ib_regb_reg_wr;
    logic [4:0]   ib_regb_wr_addr;
    logic [31:0]  ib_regb_wr_data;
    
    //read port
    logic [4:0]   ib_regb_rd_addr1;
    logic [4:0]   ib_regb_rd_addr2;
    
    //output ports
    logic [31:0]  ob_regb_rd_data1;
    logic [31:0]  ob_regb_rd_data2;
    
    // Instantiate the DUT
    regb uut (
        .ib_regb_clk(ib_regb_clk),
        .ib_regb_rst(ib_regb_rst),
        .ib_regb_reg_wr(ib_regb_reg_wr),
        .ib_regb_wr_addr(ib_regb_wr_addr),
        .ib_regb_wr_data(ib_regb_wr_data),
        .ib_regb_rd_addr1(ib_regb_rd_addr1),
        .ib_regb_rd_addr2(ib_regb_rd_addr2),
        .ob_regb_rd_data1(ob_regb_rd_data1),
        .ob_regb_rd_data2(ob_regb_rd_data2)
    );

    
    //Clock generation
    initial begin
        ib_regb_clk = 0;
        forever #5 ib_regb_clk = ~ib_regb_clk;
    end
    
    initial begin
        //Initialize signals
        ib_regb_clk = 0;
        ib_regb_rst = 0;
        ib_regb_reg_wr = 0;
        ib_regb_wr_addr = 0;
        ib_regb_wr_data = 0;
        ib_regb_rd_addr1 = 0;
        ib_regb_rd_addr2 = 0;
        
        // ---------- Test 1: System Reset ----------
        ib_regb_rst = 1;
        ib_regb_rst = 0; //de-assert
        #1;
        
        // ---------- Test 2: Read behaviour (asynchronous) ----------
        ib_regb_wr_addr = 5'd4;  // $a0
        ib_regb_wr_data = 32'h12345678;
        ib_regb_reg_wr = 1;
        #10;

        ib_regb_wr_addr = 5'd5;  // $a1
        ib_regb_wr_data = 32'h0000CAFE;
        #10;
        ib_regb_reg_wr = 0;

        ib_regb_rd_addr1 = 5'd4; // $a0
        #1;
        ib_regb_rd_addr2 = 5'd5; // $a1
        #1;
        
        // ---------- Test 3: Write operation ----------
        ib_regb_wr_addr = 5'd9;        // $t1
        ib_regb_wr_data = 32'hCAFEBEEF;
        ib_regb_reg_wr = 1;
        #10;
        ib_regb_reg_wr = 0;

        ib_regb_rd_addr1 = 5'd9; // $t1
        #1;
        
        // ---------- Test 4: Write to zero ----------
        ib_regb_wr_addr = 5'd0; // $zero
        ib_regb_wr_data = 32'hFFFFFFFF;
        ib_regb_reg_wr = 1;
        #10;
        ib_regb_reg_wr = 0;

        ib_regb_rd_addr1 = 5'd0; // $zero 
        #1;
        
        // ---------- Test 5: Multiple writes + read ----------
        ib_regb_wr_addr = 5'd4;  // $a0
        ib_regb_wr_data = 32'hAAAA0001;
        ib_regb_reg_wr = 1;
        #10;

        ib_regb_wr_addr = 5'd5;  // $a1
        ib_regb_wr_data = 32'hBBBB0002;
        #10;
        ib_regb_reg_wr = 0;

        ib_regb_rd_addr1 = 5'd4;
        ib_regb_rd_addr2 = 5'd5;
        #1;
        
        // ---------- Test 6: write enable = 0 ----------
        ib_regb_wr_addr = 5'd9;        // $t1
        ib_regb_wr_data = 32'hCAFEFFFF;
        ib_regb_reg_wr = 0;            // Disabled write
        #10;

        ib_regb_rd_addr1 = 5'd9;
        #1;
        
        //end of simulation
         $finish;
    end
    

endmodule

