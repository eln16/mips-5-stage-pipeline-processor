module multb (
    input                    ib_multb_clk,
    input                    ib_multb_rst,     // Active-high reset
    input   [31:0]           ib_multb_mulcn,   // multiplicand
    input   [31:0]           ib_multb_mulpl,   // multiplier
    output  logic            ob_multb_valid,   // result ready
    output  logic            ob_multb_busy,    // high while computing
    output  logic [63:0]     ob_multb_out      // 64-bit product
);

    // FSM States
    typedef enum logic [1:0] { 
        IDLE = 2'b00, 
        COMPUTE = 2'b01, 
        DONE = 2'b10,
        XXX = 'x 
    } state_t;
    
    // State Register
    state_t      state_reg, state_next;
    
    // Multiplier Internal Register
    logic [63:0] multiplicand_reg,multiplicand_next;// change
    logic [31:0] multiplier_reg, multiplier_next;
    logic [63:0] product_reg, product_next;
    logic [5:0]  count_reg, count_next;

    // Register Present State
    always_ff @(posedge ib_multb_clk, posedge ib_multb_rst) begin
    
        if (ib_multb_rst) begin
            
            state_reg <= IDLE;
                        
        end
        else begin
        
            state_reg <= state_next;
        
        end
    end
    
    // Combinational Nest State
    always_comb begin
    
        // Multiplier Default Value 
        state_next        = state_reg;
        multiplicand_next = multiplicand_reg;
        multiplier_next   = multiplier_reg;
        product_next      = product_reg;
        count_next        = count_reg;

       
    
        case (state_reg)
        
            IDLE: begin
                
                if ( (ib_multb_mulcn != 1'b0) || (ib_multb_mulpl != 1'b0)) begin
                
                    state_next = COMPUTE;
                    
                    multiplicand_next = ib_multb_mulcn;
                    multiplier_next = ib_multb_mulpl;
                    product_next = 64'h0000_0000_0000_0000;
                    count_next = 6'b00_0000;
                end
                else begin
                
                    state_next = IDLE;
                    
                    multiplicand_next = multiplicand_reg;
                    multiplier_next = multiplier_reg;
                    product_next = product_reg;
                    count_next = count_reg;
                end
                  
            end
            
            COMPUTE: begin
            
                if (count_reg == 6'd32) begin
                
                    state_next = DONE;
                    
                end
                else begin
                
                    state_next = COMPUTE;
                    
                end
                
                if (multiplier_reg[0]) begin
                    
                    product_next = product_reg + multiplicand_reg;//change
                    
                end

                multiplicand_next = multiplicand_reg << 1;
                multiplier_next = multiplier_reg >> 1;
                count_next = count_reg + 6'b00_0001;

            end
            
            DONE: begin
                
                state_next = IDLE;

            end
            
        endcase
    end
    
    // Registered Output
    always_ff @(posedge ib_multb_clk, posedge ib_multb_rst) begin

         
    
        if (ib_multb_rst) begin
        
            multiplicand_reg <= 32'h0000_0000;
            multiplier_reg   <= 32'h0000_0000;
            product_reg      <= 64'h0000_0000_0000_0000;
            count_reg         <= 6'b00_000;
            ob_multb_busy    <= 1'b0;
            ob_multb_valid   <= 1'b0;
            
        end 
        else begin
        
            multiplicand_reg <= multiplicand_next;
            multiplier_reg <= multiplier_next;
            product_reg <= product_next;
            count_reg <= count_next;

            // Registered outputs follow the state
            case (state_next)
            
                IDLE: begin
                
                    ob_multb_busy  <= 1'b0;
                    ob_multb_valid <= 1'b0;
                    ob_multb_out   <= 32'h0000_0000;
                    
                end
                
                COMPUTE: begin
                
                    ob_multb_busy  <= 1'b1;
                    ob_multb_valid <= 1'b0;
                    ob_multb_out   <= 32'h0000_0000;
                    
                end
                
                DONE: begin
                
                    ob_multb_busy  <= 1'b0;
                    ob_multb_valid <= 1'b1;
                    ob_multb_out   <= product_next;
                    
                end
                
            endcase
        end
    
    end

endmodule




