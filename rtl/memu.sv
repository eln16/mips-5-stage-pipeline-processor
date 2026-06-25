//////////////////////////////////////////////////////////////////////////////////

/* 
Project / Module    : memu.sv
File name           : memu.sv 
Version             : 1.0
Date created        : 09 September 2025
Author              : Elveis Ng Kai Wei
Code type           : RTL Level (System Verilog) 
Description         : This block interfaces with instruction and data memory. 
                      It supports both load/store operations and instruction fetching. 
                      The module uses control signals to select between byte- or 
                      word-addressable memory, and to enable read or write actions. 
                      Address and data inputs determine where and what to read or write. 
                      Outputs provide the read data from memory for use by the processor
                      pipeline.
*/

//////////////////////////////////////////////////////////////////////////////////


module memu
(
    input               iu_memu_clk,
    input               iu_memu_rst,
    input               iu_memu_mem_rd,
    input               iu_memu_mem_wr,
    input               iu_memu_mode,
    input [31:0]        iu_memu_addr,
    input [31:0]        iu_memu_wr_data,
    input [31:0]        iu_memu_rd_addr,
    output logic [31:0] ou_memu_dat_rd_data,
    output logic [31:0] ou_memu_inst_rd_data
);
    
    logic [3:0]     seg_dmem_addr;
    logic [3:0]     seg_imem_addr;
    logic [31:0]    imem_addr;
    logic [31:0]    dmem_addr;
    logic           imem_rd;
    logic           dmem_rd;
    
    //                  Virtual(v) to Physical(p) memory mapping
    //               {16'h0000, v[31], v[28], v[22], v[15], v[11:0]}
    // -----------------------------------------------------------------------------------
    // Segment (byte size):     [   physical memory  ] -> [       virtual memory         ]
    // -----------------------------------------------------------------------------------
    // Kernel        (4KB):     [16'h8000 to 16'h8FFF] -> [32'h8000_0000 to 32'h8000_0FFF]
    // Stack         (4KB):     [16'h7000 to 16'h7FFF] -> [32'h7FFF_F000 to 32'h7FFF_FFFC]
    // Static        (4KB):     [16'h4000 to 16'h4FFF] -> [32'h1000_0000 to 32'h1000_0FFF]
    // Text          (4KB):     [16'h2000 to 16'h2FFF] -> [32'h0040_0000 to 32'h0040_0FFF]

    always_comb begin
        
        seg_dmem_addr = {iu_memu_addr[31], iu_memu_addr[28], iu_memu_addr[22], iu_memu_addr[15]};
        seg_imem_addr = {iu_memu_rd_addr[31], iu_memu_rd_addr[28], iu_memu_rd_addr[22], iu_memu_rd_addr[15]};
        
        // Instruciton Memory Mapping to physical memory
        imem_addr = 16'h0000;
        case (seg_imem_addr)

            4'h2:       imem_addr = {16'h0000, 4'h2, iu_memu_rd_addr[11:0]}; // Text Segment
            default:    imem_addr = '0;

        endcase
        
        imem_rd = ((seg_imem_addr == 4'h2)
                  ? iu_memu_mem_rd : 1'b0);

        // Data Memory Mapping to physical memory
        dmem_addr = 16'h0000;
        case (seg_dmem_addr)

            4'h4:       dmem_addr = {16'h0000, 4'h4, iu_memu_addr[11:0]}; // Static Data Segment
            4'h7:       dmem_addr = {16'h0000, 4'h7, iu_memu_addr[11:0]}; // Stack Top
            4'h8:       dmem_addr = {16'h0000, 4'h8, iu_memu_addr[11:0]}; // Kernel Segment
            default:    dmem_addr = '0;

        endcase
        
        
        dmem_rd = (((seg_dmem_addr == 4'h4) ||
                    (seg_dmem_addr == 4'h7) ||
                    (seg_dmem_addr == 4'h8))
                    ? iu_memu_mem_rd : 1'b0);

    end

    // ------------------------------------------------------------
    //                  Instruction Memory (imem)
    // ------------------------------------------------------------
    membk
    #(
        .MEM_DEPTH(1024), // (4KB / 4 = 1K words)
        .MEM_FILE("C:/Users/Elveis/Desktop/COA/COA.sourcecode/Instruction Memory Data/indv_inst.hex")
    )
    imem
    (
        .ib_membk_clk(iu_memu_clk),
        .ib_membk_rst(iu_memu_rst),
        .ib_membk_mem_rd(1'b1),
        .ib_membk_mem_wr(1'b0),
        .ib_membk_mode(1'b1),
        .ib_membk_addr(imem_addr),
        .ib_membk_wr_data(32'h0000_0000),
        .ob_membk_rd_data(ou_memu_inst_rd_data)
    );

    // ----------------------------------------------------------
    //                    Data Memory (dmem)
    // ----------------------------------------------------------
    membk
    #(
        .MEM_DEPTH(4096)  // Stack(12KB) + Static Data(4KB) = 16KB
    )                     // (16KB / 4 = 4K words)
    dmem
    (
        .ib_membk_clk(iu_memu_clk),
        .ib_membk_rst(iu_memu_rst),
        .ib_membk_mem_rd(dmem_rd),
        .ib_membk_mem_wr(iu_memu_mem_wr),
        .ib_membk_mode(iu_memu_mode),
        .ib_membk_addr(dmem_addr),
        .ib_membk_wr_data(iu_memu_wr_data),
        .ob_membk_rd_data(ou_memu_dat_rd_data)
    );

endmodule