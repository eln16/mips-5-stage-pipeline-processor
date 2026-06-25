//##################################################################################################
/*
Project / Module    : mipsc
File name           : mipsc.sv
Version             : 1-0
Date created        : 1 SEPTEMBER 2025
Author              : Elveis Ng Kai Wei
Code type           : Behavioural (System Verilog)
Description         : MIPS Pipeline Processor Chip Interface (mipsc) a module use to
                      implement the Central Processing Unit (cpu) and Memory Unit (memu). 
*/
//##################################################################################################


module mipsc
(
    input       ic_mipsc_clk,
    input       ic_mipsc_rst
);

    // Signals Declaration
    logic           mem_rd;
    logic           mem_wr;
    logic           mem_mode;
    logic [31:0]    mem_addr;
    logic [31:0]    wr_data;
    logic [31:0]    rd_addr;
    logic [31:0]    dat_rd_data;
    logic [31:0]    inst_rd_data;

    // ------------------------------------------
    //          Central Processing Unit
    // ------------------------------------------
    cpu
    cp
    (
        .iu_cpu_clk(ic_mipsc_clk),
        .iu_cpu_rst(ic_mipsc_rst),
        .iu_cpu_dat_rd_data(dat_rd_data),
        .iu_cpu_inst_rd_data(inst_rd_data),
        .ou_cpu_mem_mode(mem_mode),
        .ou_cpu_mem_rd(mem_rd),
        .ou_cpu_mem_wr(mem_wr),
        .ou_cpu_addr(mem_addr),
        .ou_cpu_wr_data(wr_data),
        .ou_cpu_inst_rd_addr(rd_addr)
    );

    // ------------------------------------------
    //          Memory Unit
    // ------------------------------------------
    memu
    mem
    (
        .iu_memu_clk(ic_mipsc_clk),
        .iu_memu_rst(ic_mipsc_rst),
        .iu_memu_mem_rd(mem_rd),
        .iu_memu_mem_wr(mem_wr),
        .iu_memu_mode(mem_mode),
        .iu_memu_addr(mem_addr),
        .iu_memu_wr_data(wr_data),
        .iu_memu_rd_addr(rd_addr),
        .ou_memu_dat_rd_data(dat_rd_data),
        .ou_memu_inst_rd_data(inst_rd_data)
    );



endmodule