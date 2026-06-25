module cu
(
    input               iu_cu_clk,
    input               iu_cu_rst,
    input [2:0]         iu_cu_alu_op,
    input [5:0]         iu_cu_alu_funct,
    input [5:0]         iu_cu_main_op,
    input [5:0]         iu_cu_main_funct,
    output logic        ou_cu_mem2reg,
    output logic        ou_cu_multWr,
    output logic        ou_cu_hilo,
    output logic        ou_cu_reg_wr,
    output logic        ou_cu_mem_rd,
    output logic        ou_cu_mem_wr,
    output logic        ou_cu_beq,
    output logic        ou_cu_bne,
    output logic        ou_cu_mem_mode,
    output logic        ou_cu_use_mult,
    output logic        ou_cu_src,
    output logic [1:0]  ou_cu_regdst,
    output logic        ou_cu_is_jal,
    output logic        ou_cu_is_jalr,
    output logic        ou_cu_is_jr,
    output logic        ou_cu_jump,
    output logic        ou_cu_extop,
    output logic [2:0]  ou_cu_op,
    output logic [3:0]  ou_cu_ctr
);
    // ------------------------------------------
    //          Main Control Block
    // ------------------------------------------
    mctlb
    mctl
    (
        .ib_mctlb_op(iu_cu_main_op),
        .ib_mctlb_funct(iu_cu_main_funct),
        .ob_mctlb_mem2reg(ou_cu_mem2reg),
        .ob_cu_multWr(ou_cu_multWr),
        .ob_cu_hilo(ou_cu_hilo),
        .ob_mctlb_reg_wr(ou_cu_reg_wr),
        .ob_mctlb_mem_rd(ou_cu_mem_rd),
        .ob_mctlb_mem_wr(ou_cu_mem_wr),
        .ob_mctlb_beq(ou_cu_beq),
        .ob_mctlb_bne(ou_cu_bne),
        .ob_mctlb_use_mult(ou_cu_use_mult),
        .ob_mctlb_op(ou_cu_op),
        .ob_mctlb_src(ou_cu_src),
        .ob_mctlb_regdst(ou_cu_regdst),
        .ob_mctlb_is_jal(ou_cu_is_jal),
        .ob_mctlb_is_jalr(ou_cu_is_jalr),
        .ob_mctlb_is_jr(ou_cu_is_jr),
        .ob_mctlb_jump(ou_cu_jump),
        .ob_mctlb_extop(ou_cu_extop),
        .ob_mctlb_mem_mode(ou_cu_mem_mode)
    );

    // ------------------------------------------
    //          ALU Control Block
    // ------------------------------------------
    actlb
    actl
    (
        .ib_actlb_op(iu_cu_alu_op),
        .ib_actlb_funct(iu_cu_alu_funct),
        .ob_actlb_ctr(ou_cu_ctr)
    );


endmodule