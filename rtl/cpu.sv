//##################################################################################################
/*
Project / Module    : cpu
File name           : cpu.sv
Version             : 1-0
Date created        : 1 SEPTEMBER 2025
Author              : Elveis Ng Kai Wei
Code type           : Behavioural (System Verilog)
Description         : a module used to synthesis the whole processor data path, it including 5 stage 
                      pipeline whihc are IF ID EX MEM WB
*/
//##################################################################################################


`define WORD_NB 32
`define REG_ADDR_NB 5
`define SHAMT_NB 5
`define OPCODE_NB 6
`define FUNCT_NB 6
`define IMM_NB 16
`define JADDR_OFF_NB 26

module cpu
(
    input                       iu_cpu_clk,
    input                       iu_cpu_rst,
    input [`WORD_NB-1:0]        iu_cpu_dat_rd_data, // Data word read from data memory
    input [`WORD_NB-1:0]        iu_cpu_inst_rd_data, // Insturction word read from instruction memory
    output logic                ou_cpu_mem_mode, // To select the write or read to or from data memory (0 = word / 1 = byte)
    output logic                ou_cpu_mem_rd, // Data memory read enable signal
    output logic                ou_cpu_mem_wr, // Data memory write enable signal
    output logic [`WORD_NB-1:0] ou_cpu_addr, // Data memory input address can be read addr or write addr
    output logic [`WORD_NB-1:0] ou_cpu_wr_data, // Data need write into data memory
    output logic [`WORD_NB-1:0] ou_cpu_inst_rd_addr // Instruction address need to access the instruciton memory
);
    // =====================================================================
    //     Intruction format
    // =====================================================================
    typedef union packed{

        logic [`WORD_NB-1:0] all_bits;

        // R-type format
        struct packed{
            logic [`OPCODE_NB-1:0]      opcode;
            logic [`REG_ADDR_NB-1:0]    rs;
            logic [`REG_ADDR_NB-1:0]    rt;
            logic [`REG_ADDR_NB-1:0]    rd;
            logic [`SHAMT_NB-1:0]       shamt;
            logic [`FUNCT_NB-1:0]       funct; 
        } r_type;

        // I-type format
        struct packed{
            logic [`OPCODE_NB-1:0]      opcode;
            logic [`REG_ADDR_NB-1:0]    rs;
            logic [`REG_ADDR_NB-1:0]    rt;
            logic [`IMM_NB-1:0]         imm;
        } i_type;

        // J-type format
        struct packed{
            logic [`OPCODE_NB-1:0]      opcode;
            logic [`JADDR_OFF_NB-1:0]   jaddr_off;
        } j_type;

    }instr32_t;


    // =====================================================================
    //     Pipeline Registers
    // =====================================================================

    // IF_ID pipe
    typedef struct packed {

        // Data Signal
        logic [`WORD_NB-1:0] pc;
        logic [`WORD_NB-1:0] instr;

    } if_id_t;

    // ID_EX pipe
    typedef struct packed {

        // Data Signal
        logic [`REG_ADDR_NB-1:0]    rs;
        logic [`REG_ADDR_NB-1:0]    rt;
        logic [`REG_ADDR_NB-1:0]    rd;
        logic [`FUNCT_NB-1:0]       funct;
        logic [`WORD_NB-1:0]        rs_data;
        logic [`WORD_NB-1:0]        rt_data;
        logic [`WORD_NB-1:0]        ext_imm;
        logic [`WORD_NB-1:0]        pc;

        // Control Signal for EX Stage
        logic [1:0] reg_dst;
        logic       alb_src;
        logic       use_mult;
        logic [2:0] op;

        // Control Signal for MEM Stage
        logic       mem_rd;
        logic       mem_wr;
        logic       mem_mode;

        // Control Signal for WB Stage
        logic       is_jal;
        logic       is_jalr;
        logic       is_jr;
        logic       reg_wr;
        logic       hilo;
        logic       multWr;
        logic       mem2reg;

    } id_ex_t;

    // EX_MEM pipe
    typedef struct packed {
        
        // Data Signal
        logic [`WORD_NB-1:0]        alu_out;
        logic [`WORD_NB-1:0]        rt_data;
        logic [`WORD_NB-1:0]        pc;
        logic [`REG_ADDR_NB-1:0]    rt_rd; 

        // Control Signal for MEM Stage
        logic       mem_rd;
        logic       mem_wr;
        logic       mem_mode;

        // Control Signal for WB Stage
        logic       is_jal;
        logic       is_jalr;
        logic       is_jr;
        logic       reg_wr;
        logic       hilo;
        logic       multWr;
        logic       mem2reg;

    } ex_mem_t;

    typedef struct packed {
        
        // Data Signal
        logic [`WORD_NB-1:0]        mem_read_data;
        logic [`WORD_NB-1:0]        mem_data_rt_rd;
        logic [`WORD_NB-1:0]        pc;
        logic [`REG_ADDR_NB-1:0]    rt_rd;

        // Control Signal for WB Stage
        logic       is_jal;
        logic       is_jalr;
        logic       is_jr;
        logic       reg_wr;
        logic       hilo;
        logic       multWr;
        logic       mem2reg;

    } mem_wb_t;

    // =====================================================================
    //          HiLo Registers
    // =====================================================================

    typedef struct packed {

        // Hi and Lo regitser separately 32 bits
        logic [`WORD_NB-1:0]    hi;
        logic [`WORD_NB-1:0]    lo;

    } hi_lo_t;

    // =====================================================================
    //     Pipe and Instruction Type Required Wire 
    // =====================================================================

    // -------------------------Pipe Declaration----------------------------
    if_id_t IF_ID;
    id_ex_t ID_EX;
    ex_mem_t EX_MEM;
    mem_wb_t MEM_WB;

    // -------------------------Pipe Enable Signal--------------------------
    logic pc_wr_en;
    logic if_id_en;
    logic id_ex_en;
    logic ex_mem_en;
    logic mem_wb_en;

    // ------------------------Insturction Register-------------------------
    instr32_t IR;

    // ----------------------------Hi_LO Register---------------------------
    hi_lo_t HI_LO;

    // =====================================================================
    //     Internal Stage's Instantiation Wire
    // =====================================================================
    
    // ---------------------------IF Stage----------------------------------
    
    // Program Counter wire
    logic [`WORD_NB-1:0] pc_reg;
    logic [`WORD_NB-1:0] pc_next;
    logic [`WORD_NB-1:0] if_pc4;

    // Multiplier and Branch Stall Control Block wire
    logic   mbscb_nop;

    // Jump Address wire
    logic                if_jr_stall;
    logic [`WORD_NB-1:0] if_jr_addr;
    logic [`WORD_NB-1:0] if_j_addr;

    // Flush Logic wire
    logic   if_flush_ifid;

    // ---------------------------ID Stage----------------------------------
    
    // Control Unit wire
    logic       cu_extop;
    logic       cu_jump;
    logic [1:0] cu_reg_dst;
    logic       cu_src;
    logic [2:0] cu_op;
    logic       cu_use_mult;
    logic       cu_beq;
    logic       cu_bne;
    logic       cu_mem_mode;
    logic       cu_mem_rd;
    logic       cu_mem_wr;
    logic       cu_reg_wr;
    logic       cu_hilo;
    logic       cu_multWr;
    logic       cu_mem2reg;
    logic       cu_is_jal;
    logic       cu_is_jalr;
    logic       cu_is_jr;
    logic [3:0] cu_ctr;

    // Register File Block wire
    logic [`WORD_NB-1:0] regb_rd_data1;
    logic [`WORD_NB-1:0] regb_rd_data2;

    // Zero/Sign Extend wire
    logic [`WORD_NB-1:0] extb_imm;

    // Branch Forward Control Block wire
    logic   bfcb_fw_rs;
    logic   bfcb_fw_rt;

    // Load-Use Stall Control Block wire
    logic   lscb_nopEX;

    // Branch Target Address Logic wire
    logic                id_br_cond_beq;
    logic                id_br_cond_bne;
    logic                id_pc_src;
    logic [`WORD_NB-1:0] id_br_taddr;
    logic [`WORD_NB-1:0] id_br_imm_extend;
    logic [`WORD_NB-1:0] id_br_rs_data;
    logic [`WORD_NB-1:0] id_br_rt_data;

    // ---------------------------EX Stage----------------------------------

    // Data Forward Control Block wire
    logic [1:0] dfcb_fw_rt;
    logic [1:0] dfcb_fw_rs;

    // Arithmetic Logic Block wire
    logic [`WORD_NB-1:0] alb_out;

    // Multiplier Block wire
    logic                multb_valid;
    logic                multb_busy;
    logic [(`WORD_NB * 2)-1:0] multb_out;

    // Data Forward datapath wire
    logic [`WORD_NB-1:0] ex_fw_rs;
    logic [`WORD_NB-1:0] ex_fw_rt;

    // ALB or Multiplier selector wire
    logic [`WORD_NB-1:0] ex_alb_a_in;
    logic [`WORD_NB-1:0] ex_alb_b_in;
    logic [`WORD_NB-1:0] ex_multb_mulcn_in;
    logic [`WORD_NB-1:0] ex_multb_mulpl_in;

    // rt or rd register selected wire
    logic [`REG_ADDR_NB-1:0] ex_dest_rt_rd_ra;

    // ---------------------------MEM Stage----------------------------------

    // Load-Store Forward Control Block wire
    logic                lfcb_fw_mem;

    // Data Memory Write Data selected wire
    logic [`WORD_NB-1:0] mem_wr_data;

    // ---------------------------WB Stage---------------------------------- 

    // Data Memory to Register File selected wire
    logic [`WORD_NB-1:0] wb_mem2reg_data;

    
    logic [31:0] predicted_ra;
    logic        predicted_ra_valid;


    // =====================================================================
    //     IF Stage
    // =====================================================================

    // Sequential Next instruction Logic
    // cu_jump choose next instruction address; 1 is Jump Target Address, 0 is (PC+4 / Branch Target Address)
    // id_pc_src choose next instruction address; 1 is Branch Target Address, 0 is PC+4

    // Calculate PC + 4
    assign if_pc4 = pc_reg + 4;

    // jr stall detection
    assign if_jr_stall = (cu_is_jr || cu_is_jalr) &&
                        (dfcb_fw_rs == 2'b00) &&
                        (IR.r_type.rs != 0);

    // JR/JALR address calculation with RA special-case
    always_comb begin
        if_jr_addr = 32'h0;

        if (IR.r_type.rs == 5'd31) begin
            // If rs = $ra, check if last instr was jal/jalr
            casez ({(ID_EX.is_jal || ID_EX.is_jalr), (EX_MEM.is_jal || EX_MEM.is_jalr)})
                2'b?1: if_jr_addr = ID_EX.pc + 8;   // jal in ID stage
                2'b1?: if_jr_addr = EX_MEM.pc + 8;  // jal in EX stage
                default: if_jr_addr = regb_rd_data1; // otherwise use regfile
            endcase
        end
        else begin
            // Normal forwarding mux for non-$ra sources
            case (dfcb_fw_rs)
                2'b00: if_jr_addr = regb_rd_data1;
                2'b01: if_jr_addr = wb_mem2reg_data;
                2'b10: if_jr_addr = EX_MEM.alu_out;
                default: if_jr_addr = 32'h0;
            endcase
        end
    end    

    // Jump Address Calculation
    always_comb begin

        if_j_addr = 32'h0000_0000;

        // J-tyte jump (j, jal)
        if (cu_jump || cu_is_jal) begin

            if_j_addr = {if_pc4[31:20], IR.j_type.jaddr_off[17:0], 2'b00};

        end
        // R-type jump (jr, jalr)
        else if (cu_is_jr || cu_is_jalr) begin

            if_j_addr = if_jr_addr;

            // $ra register forwording
            if (IR.r_type.rs == 5'b11111) begin

                casez ({(ID_EX.is_jal || ID_EX.is_jalr), (EX_MEM.is_jal || EX_MEM.is_jalr)})
                    2'b?1:    if_j_addr = ID_EX.pc + 8;
                    2'b1?:    if_j_addr = EX_MEM.pc + 8;
                endcase

            end
        end

    end

    // Next pC Calculation
    assign pc_next = (cu_is_jr || cu_is_jalr) ? if_jr_addr : 
                     ((cu_jump || cu_is_jal) ? if_j_addr : 
                     (id_pc_src ? (id_br_taddr) : if_pc4));

    // Program Counter write enable control: 
    // If flush occurs then force enable
    // Otherwise allow PC update only when (mbscb_nop == 0) and (lscb_nopEX == 0)
    assign pc_wr_en = if_flush_ifid ? 1'b1 :  (~mbscb_nop & ( ~lscb_nopEX | ~if_jr_stall)); 


    // PC Register next clock cycle update logic
    always_ff @(posedge iu_cpu_clk) begin

        // Reset Clear the PC register
        if (iu_cpu_rst) begin
            pc_reg <= 32'h0040_0000;
        end
        // Stall the PC register
        else if(!pc_wr_en) begin
            pc_reg <= pc_reg;
        end
        // No Reset Update the PC register
        else begin
            pc_reg <= pc_next;
        end

    end

    // Load PC into Instruction Memory to read instruction (CPU -> MEMU)
    assign ou_cpu_inst_rd_addr = pc_reg;

    // Multiplier and Branch Stall Control Block
    mbscb mbsc
    (
        .ib_mbscb_beq(cu_beq),
        .ib_mbscb_busy(multb_busy), //from Multiplier
        .ob_mbscb_nop(mbscb_nop)
    );

    // ========================== IF_ID pipeline ===========================

    // IF_ID pipe enable
    // Disabled when there is a stall due to hazards or multiplier working
    assign if_id_en =  (~mbscb_nop & ( ~lscb_nopEX | ~if_jr_stall));

    // Flush when the Branch or Jump are taken 
    assign if_flush_ifid = cu_jump | id_pc_src | cu_is_jr | cu_is_jalr | cu_is_jal;

    // IF_ID pipe next clock cycle update logic
    always_ff @(posedge iu_cpu_clk) begin

        // Reset Clear the IF_ID pipe
        if (iu_cpu_rst) begin
            IF_ID <= '0;
        end
        // Flush the IF_ID pipe
        else if (if_flush_ifid) begin
            IF_ID <= '0;
        end
        // Stall the IF_ID pipe
        else if (!if_id_en) begin
            IF_ID <= IF_ID;
        end
        // No Reset Update the IF_ID pipe
        else begin            
            IF_ID.pc <= pc_next;
            IF_ID.instr <= iu_cpu_inst_rd_data; // (MEMU -> CPU)
        end

    end

    // =====================================================================
    //     ID Stage
    // =====================================================================

    // Load Instruction into IR and assign IR Data Type 
    assign IR = IF_ID.instr;

    // Control Unit Instantiation
    cu c
    (
        .iu_cu_clk(iu_cpu_clk),
        .iu_cu_rst(iu_cpu_rst),
        .iu_cu_main_op(IR.i_type.opcode),
        .iu_cu_main_funct(IR.r_type.funct),
        .iu_cu_alu_op(ID_EX.op), // from EX
        .iu_cu_alu_funct(ID_EX.funct), // from EX

        // Main Control Block
        // ID stage control signals
        .ou_cu_extop(cu_extop),
        .ou_cu_jump(cu_jump), 

        // EX stage contorl signals
        .ou_cu_regdst(cu_reg_dst),
        .ou_cu_src(cu_src), 
        .ou_cu_op(cu_op),
        .ou_cu_use_mult(cu_use_mult),

        // Branch contorl signals
        .ou_cu_beq(cu_beq),
        .ou_cu_bne(cu_bne),

        // MEM control signals
        .ou_cu_mem_mode(cu_mem_mode), 

        // WB control signals
        .ou_cu_mem_rd(cu_mem_rd),
        .ou_cu_mem_wr(cu_mem_wr),
        .ou_cu_reg_wr(cu_reg_wr),
        .ou_cu_hilo(cu_hilo),
        .ou_cu_multWr(cu_multWr),
        .ou_cu_mem2reg(cu_mem2reg),
        .ou_cu_is_jalr(cu_is_jalr),
        .ou_cu_is_jal(cu_is_jal),
        .ou_cu_is_jr(cu_is_jr),

        // ALU Control Block
        .ou_cu_ctr(cu_ctr)
    );

    // Register File Block Instantiation
    regb regf
    (
        .ib_regb_clk_n(iu_cpu_clk),
        .ib_regb_rst(iu_cpu_rst),
        .ib_regb_reg_wr(MEM_WB.reg_wr), // from WB
        .ib_regb_wr_data(wb_mem2reg_data), // from WB
        .ib_regb_wr_addr(MEM_WB.rt_rd), // from WB
        .ib_regb_rd_addr1(IR.r_type.rs),
        .ib_regb_rd_addr2(IR.r_type.rt),
        .ob_regb_rd_data1(regb_rd_data1),
        .ob_regb_rd_data2(regb_rd_data2)
    );

    // Forward Control Block Instantiation
    fcb fc
    (
        // Branch Forward Control Inputs
        .ib_fcb_b_id_beq(cu_beq), // from ID
        .ib_fcb_b_mem_reg_wr(EX_MEM.reg_wr), // from MEM
        .ib_fcb_b_mem_rd(EX_MEM.rt_rd), // from MEM
        .ib_fcb_b_id_rs(IR.r_type.rs), // from ID
        .ib_fcb_b_id_rt(IR.r_type.rt), // from ID

        // Data Forward Control Inputs
        .ib_fcb_d_wb_regwr(MEM_WB.reg_wr), // from WB
        .ib_fcb_d_mem_regwr(EX_MEM.reg_wr), // from MEM
        .ib_fcb_d_mem_rd_rt(EX_MEM.rt_rd), // from MEM
        .ib_fcb_d_wb_rd_rt(MEM_WB.rt_rd), // from WB
        .ib_fcb_d_ex_rt5(ID_EX.rt), // from EX
        .ib_fcb_d_ex_rs5(ID_EX.rs), // from EX

        // Load-Store Forward Control Inputs
        .ib_fcb_l_wb_regwr(MEM_WB.reg_wr), // from WB
        .ib_fcb_l_wb_mem2reg(MEM_WB.mem2reg), // from WB
        .ib_fcb_l_mem_memwr(EX_MEM.mem_wr), // from MEM
        .ib_fcb_l_mem_rt5(EX_MEM.rt_rd), // from MEM
        .ib_fcb_l_wb_rt5(MEM_WB.rt_rd), // from WB

        // Branch Forward Control Outputs
        .ob_fcb_b_fw_rt(bfcb_fw_rt),
        .ob_fcb_b_fw_rs(bfcb_fw_rs),

        // Data Forward Control Outputs
        .ob_fcb_d_fw_rt(dfcb_fw_rt),
        .ob_fcb_d_fw_rs(dfcb_fw_rs),

        // Load-Store Forward Control Outputs
        .ob_fcb_l_fw_mem(lfcb_fw_mem)
    );

    // Zero / Sign Extend the 16 bits to 32 bits
    always_comb begin
        case(cu_extop)

            // Zero-extnd: fill upper 16 bits with zero
            0:  extb_imm = {16'h0000, IR.i_type.imm};

            // Sign-extend: replicate the MSB of ib_extb_imm to the upper 16 bits
            1:  extb_imm = {{16{IR.i_type.imm[15]}}, IR.i_type.imm};

            default:    extb_imm = 'x;

        endcase
    end

    // Branch Target Address Logic 
    assign id_br_imm_extend = {extb_imm[29:0], 2'b00}; // Shift left 2 bits
    
    assign id_br_taddr = IF_ID.pc + id_br_imm_extend;

    assign id_br_cond_beq = ((bfcb_fw_rs ? (EX_MEM.alu_out) : ID_EX.rs_data) 
                            == (bfcb_fw_rt ? (EX_MEM.alu_out) : ID_EX.rt_data));

    assign id_br_cond_bne = ((bfcb_fw_rs ? (EX_MEM.alu_out) : ID_EX.rs_data) 
                            != (bfcb_fw_rt ? (EX_MEM.alu_out) : ID_EX.rt_data));

    assign id_pc_src = (cu_beq && id_br_cond_beq) 
                        || (cu_bne && id_br_cond_bne);

    // Load-Use Stall Control Block
    lscb lsc
    (
        .ib_lscb_id_memwr(cu_mem_wr), // from ID
        .ib_lscb_ex_memRead(ID_EX.mem2reg), // from EX
        .ib_lscb_id_rs5(IR.r_type.rs), // from ID
        .ib_lscb_id_rt5(IR.r_type.rt), // from ID
        .ib_lscb_ex_rt5(ID_EX.rt), // from EX
        .ob_lscb_nopEX(lscb_nopEX)
    );

    // ========================== ID_EX pipeline ===========================

    // ID_EX pipe enable
    // Disabled during load-use hazards stalls or multiplier working
    assign id_ex_en = ~mbscb_nop;

    // ID_EX pipe next clock cycle update logic
    always_ff @(posedge iu_cpu_clk) begin

        // Reset Clear the ID_EX pipe
        if (iu_cpu_rst) begin
            ID_EX <= '0;
        end
        // Stall the ID_EX pipe
        else if (!id_ex_en) begin
            ID_EX <= ID_EX;
        end
        // No Reset Update the ID_EX pipe
        else begin

            // Data Signal store to ID_EX pipe
            ID_EX.rs_data <= regb_rd_data1;
            ID_EX.rt_data <= regb_rd_data2;
            ID_EX.ext_imm <= extb_imm;
            ID_EX.funct <= IR.r_type.funct;
            ID_EX.rs <= IR.r_type.rs;
            ID_EX.rt <= IR.r_type.rt;
            ID_EX.rd <= IR.r_type.rd;
            ID_EX.pc <= IF_ID.pc;

            // Stall all the control signals form Main Control Block
            if (lscb_nopEX) begin

                ID_EX.reg_dst <= 2'b01;
                ID_EX.alb_src <= 1'b0;
                ID_EX.use_mult <= 1'b0;
                ID_EX.op <= 1'b0;
                ID_EX.mem_wr <= 1'b0;
                ID_EX.mem_rd <= 1'b0;
                ID_EX.mem_mode <= 1'b0;
                ID_EX.reg_wr <= 1'b0;
                ID_EX.hilo <= 1'b0;
                ID_EX.multWr <= 1'b0;
                ID_EX.mem2reg <= 1'b0;
                ID_EX.is_jal <= 1'b0;
                ID_EX.is_jalr <= 1'b0;
                ID_EX.is_jr <= 1'b0;

            end
            
            // Update the control signals from Main Control Block to ID_EX pipe
            else begin

                ID_EX.reg_dst <= cu_reg_dst;
                ID_EX.alb_src <= cu_src;
                ID_EX.use_mult <= cu_use_mult;
                ID_EX.op <= cu_op;
                ID_EX.mem_rd <= cu_mem_rd;
                ID_EX.mem_wr <= cu_mem_wr;
                ID_EX.mem_mode <= cu_mem_mode;
                ID_EX.reg_wr <= cu_reg_wr;
                ID_EX.hilo <= cu_hilo;
                ID_EX.multWr <= cu_multWr;
                ID_EX.mem2reg <= cu_mem2reg;
                ID_EX.is_jal <= cu_is_jal;
                ID_EX.is_jalr <= cu_is_jalr;
                ID_EX.is_jr <= cu_is_jr;

            end

        end 
    end

    // =====================================================================
    //     EX Stage
    // =====================================================================

    // EX stage's rs and rt select and transfer logic
    always_comb begin
        
        // Data Forwording Muxes
        // rs forward mux
        case (dfcb_fw_rs)
            2'b00:  ex_fw_rs = ID_EX.rs_data;
            2'b01:  ex_fw_rs = wb_mem2reg_data; // from WB
            2'b10:  ex_fw_rs = EX_MEM.alu_out; // from MEM
            default: ex_fw_rs = ID_EX.rs_data;
        endcase
        
        // rt forward mux
        case (dfcb_fw_rt)
            2'b00:  ex_fw_rt = ID_EX.rt_data;
            2'b01:  ex_fw_rt = wb_mem2reg_data; // from WB
            2'b10:  ex_fw_rt = EX_MEM.alu_out; // from MEM
            default: ex_fw_rt = ID_EX.rt_data;
        endcase

        // Multiplier or ALB Demux Logic
        // It control the rs and rt value will give to alu or multiplier
        ex_alb_a_in = '0;
        ex_alb_b_in = '0;
        ex_multb_mulcn_in = '0;
        ex_multb_mulpl_in = '0;

        if (ID_EX.use_mult) begin
            ex_multb_mulcn_in = ex_fw_rs;
            ex_multb_mulpl_in = ex_fw_rt;
        end
        else begin
            ex_alb_a_in = ex_fw_rs;
            // Choose ALB operand b is immediate value or rt value
            ex_alb_b_in = ID_EX.alb_src ? ID_EX.ext_imm : ex_fw_rt; 
        end

    end

    // Arithmetic Logic Block Instantiation
    alb al
    (
        .ib_alb_rst(iu_cpu_rst),
        .ib_alb_op_a(ex_alb_a_in),
        .ib_alb_op_b(ex_alb_b_in),
        .ib_alb_shamt(ID_EX.ext_imm[10:6]),
        .ib_alb_ctr(cu_ctr),
        .ob_alb_out(alb_out)
    );

    // Multiplier Block Instantiation
    multb mult 
    (
        .ib_multb_clk(iu_cpu_clk),
        .ib_multb_rst(iu_cpu_rst),
        .ib_multb_mulpl(ex_multb_mulpl_in),
        .ib_multb_mulcn(ex_multb_mulcn_in),
        .ob_multb_out(multb_out),
        .ob_multb_valid(multb_valid),
        .ob_multb_busy(multb_busy)
    );

    // Write the Multiplier Result to Hi_Lo Register
    always_ff @(posedge iu_cpu_clk) begin

        if (iu_cpu_rst) begin

            HI_LO <= '0;

        end
        // The Multiplier result will update only when the multb_valid asserted high
        else if (multb_valid) begin

            HI_LO.hi <= multb_out[63:32];
            HI_LO.lo <= multb_out[31:0];

        end
    end

    // Select the Destination Register File Address is rt or rd or ra
    always_comb begin

        case (ID_EX.reg_dst)
            2'b01: ex_dest_rt_rd_ra = ID_EX.rt;
            2'b10: ex_dest_rt_rd_ra = ID_EX.rd;
            default: ex_dest_rt_rd_ra = 6'd31; // ra is the dest reg
        endcase

    end



    // ========================== EX_MEM pipeline ===========================

    // EX_MEM pipe enable
    // Disabled during multiplier working
    assign ex_mem_en = ~mbscb_nop;

    // EX_MEM pipe next clock cycle update logic
    always_ff @(posedge iu_cpu_clk) begin

        // Reset Clear the EX_MEM pipe
        if (iu_cpu_rst) begin
            EX_MEM <= '0;
        end
        // Stall the EX_MEM pipe
        else if (!ex_mem_en) begin
            EX_MEM <= EX_MEM;
        end
        // No Reset Update the EX_MEM pipe
        else begin

            // Data Signal store to EX_MEM pipe
            EX_MEM.alu_out <= alb_out;
            EX_MEM.rt_data <= ex_fw_rt;
            EX_MEM.rt_rd <= ex_dest_rt_rd_ra;
            EX_MEM.pc <= ID_EX.pc;

            // Control Signal store to EX_MEM pipe
            EX_MEM.mem_rd <= ID_EX.mem_rd;
            EX_MEM.mem_wr <= ID_EX.mem_wr;
            EX_MEM.mem_mode <= ID_EX.mem_mode;
            EX_MEM.reg_wr <= ID_EX.reg_wr;
            EX_MEM.hilo <= ID_EX.hilo;
            EX_MEM.multWr <= ID_EX.multWr;
            EX_MEM.mem2reg <= ID_EX.mem2reg;
            EX_MEM.is_jal <= ID_EX.is_jal;
            EX_MEM.is_jalr <= ID_EX.is_jalr;
            EX_MEM.is_jr <= ID_EX.is_jr;

        end
    
    end

    // =====================================================================
    //    MEM Stage
    // =====================================================================

    // Data Memory data forwarding from WB to MEM write data when the lfcb-fw_mem is 1'b1
    assign mem_wr_data = lfcb_fw_mem ? MEM_WB.mem_read_data : EX_MEM.rt_data;

    // Data Memory input wire (CPU -> MEMU)
    always_comb begin

        ou_cpu_mem_mode = EX_MEM.mem_mode;
        ou_cpu_mem_rd = EX_MEM.mem_rd;
        ou_cpu_mem_wr = EX_MEM.mem_wr;
        ou_cpu_addr = EX_MEM.alu_out;
        ou_cpu_wr_data = mem_wr_data;

    end

    


    // ========================== MEM_WB pipeline ===========================

    // MEM_WB pipe enable
    // Disabled during multiplier working
    assign mem_wb_en = ~mbscb_nop;

    // MEM_WB pipe next clock cycle update logic
    always_ff @(posedge iu_cpu_clk) begin

        // Reset Clear the MEM_WB pipe
        if (iu_cpu_rst) begin
            MEM_WB <= '0;
        end
        // Stall the MEM_WB pipe
        else if (!mem_wb_en) begin
            MEM_WB <= MEM_WB;
        end
        // No Reset Update the MEM_WB pipe
        else begin

            // Data Signal store to MEM_WB pipe
            MEM_WB.mem_read_data <= iu_cpu_dat_rd_data; // (MEMU -> CPU)
            MEM_WB.mem_data_rt_rd <= EX_MEM.alu_out;
            MEM_WB.rt_rd <= EX_MEM.rt_rd;
            MEM_WB.pc <= EX_MEM.pc;

            // Control Signal store to MEM_WB pipe
            MEM_WB.reg_wr <= EX_MEM.reg_wr;
            MEM_WB.hilo <= EX_MEM.hilo;
            MEM_WB.multWr <= EX_MEM.multWr;
            MEM_WB.mem2reg <= EX_MEM.mem2reg;
            MEM_WB.is_jal <= EX_MEM.is_jal;
            MEM_WB.is_jalr <= EX_MEM.is_jalr;
            MEM_WB.is_jr <= EX_MEM.is_jr;

        end
    
    end

    // =====================================================================
    //    WB Stage
    // =====================================================================

    // Write Memory data back to Register selection
    // MEM_WB.is_jal choose write the pc+4 into $ra
    // MEM_WB.hilo choose data write to register; 1 is from hilo register, 0 is from (data memory / alu_result)
    // MEM_WB.multWr choose data write to register; 1 is from High 32 bits data, 0 is from Low 32 bits data 
    // MEM_WB.mem2reg choose data write to regiteer; 1 is from data memory, 0 is from alu_result

    assign wb_mem2reg_data = MEM_WB.is_jal ? MEM_WB.pc : 
                            (MEM_WB.multWr ? (MEM_WB.hilo ? HI_LO.hi : HI_LO.lo) : 
                            (MEM_WB.mem2reg ? MEM_WB.mem_read_data : MEM_WB.mem_data_rt_rd));



endmodule