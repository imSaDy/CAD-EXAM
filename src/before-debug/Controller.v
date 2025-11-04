module Controller(
    input clk,
    input rst,
    input start,
    
    input done,
    input Ready1,
    input Ready2,
    input co_sub1,
    input co_sub2,
    input co_lod,

    output reg selA1,
    output reg loadA1,
    output reg loadW1,
    output reg load_regA1, 
    output reg shift_en_LOD1,
    output reg cnt_en_LOD1,
    output reg loadShiftCountDP1,
    output reg load_mult1, 
    output reg rst_ready1,
    output reg en_num_shift1,
    output reg mult_shift_en1,
    output reg shift_en_sub1,
    output reg load_sub_reg1,
    output reg load_PI_sub1,
    output reg en_cnt_sub1,
    output reg load_num_shift1,

    output reg selA2,
    output reg loadA2,
    output reg loadW2,
    output reg load_regA2, 
    output reg shift_en_LOD2,
    output reg cnt_en_LOD2,
    output reg loadShiftCountDP2,
    output reg load_mult2, 
    output reg rst_ready2,
    output reg en_num_shift2,
    output reg mult_shift_en2,
    output reg shift_en_sub2,
    output reg load_sub_reg2,
    output reg load_PI_sub2,
    output reg en_cnt_sub2,
    output reg load_num_shift2,

    output reg rst_acc,
    output reg sel_P,
    
    output reg final_done
);

    reg [2:0] ps, ns;
    parameter [2:0] IDLE = 3'b000,
                    LOAD_A_W = 3'b001,
                    LOAD_LOD = 3'b010,
                    CALCULATE_LOD = 3'b011,
                    CALCULATE_MULT = 3'b100,
                    SUB_A = 3'b101,
                    LOAD_A = 3'b110,
                    DONE = 3'b111;

    always @(posedge clk, posedge rst) begin
        if (rst == 1'b1)
            ps <= IDLE;
        else 
            ps <= ns; 
    end

    always @(*) begin
        ns = IDLE;
        case (ps) 
            IDLE: ns = (start ? LOAD_A_W : IDLE);
            LOAD_A_W: ns = LOAD_LOD;
            LOAD_LOD: ns = CALCULATE_LOT;
            CALCULATE_LOD: ns = (co_lod ? CALCULATE_MULT : CALCULATE_LOD);
            CALCULATE_MULT: ns = ((ready1 && ready2) ? SUB_A : CALCULATE_MULT);
            SUB_A: ns = ((co_sub1 && co_sub2) ? LOAD_A : SUB_A);
            LOAD_A: ns = ((co_sub1 && co_sub2) ? LOAD_LOD : DONE); // possibly bug and added done
            DONE: ns = IDLE; 
            default: ns = IDLE;
        endcase
    end

    always @(*) begin
        {selA1, loadA1, loadW1, load_regA1, shift_en_LOD1, cnt_en_LOD1, loadShiftCountDP1, load_mult1, rst_ready1, en_num_shift1, mult_shift_en1, shift_en_sub1, load_sub_reg1, load_PI_sub1, en_cnt_sub1, 
         selA2, loadA2, loadW2, load_regA2, shift_en_LOD2, cnt_en_LOD2, loadShiftCountDP2, load_mult2, rst_ready2, en_num_shift2, mult_shift_en2, shift_en_sub2, load_sub_reg2, load_PI_sub2, en_cnt_sub2, 
         rst_acc, sel_P, final_done} = 33'b0;
         
        case (ps)
            IDLE: begin    
            end
            LOAD_A_W: begin 
                loadA1 = 1'b1;
                loadW1 = 1'b1;
                loadA2 = 1'b1;
                loadW2 = 1'b1;
            end
            LOAD_LOD: begin
                load_regA1 = 1'b1; 
                load_regA2 = 1'b1;
            end
            CALCULATE_LOD: begin
                cnt_en_LOD1 = 1'b1;
                cnt_en_LOD2 = 1'b1;
                shift_en_LOD1 = 1'b1;
                shift_en_LOD2 = 1'b1;
                load_mult1 = 1'b1;
                load_mult2 = 1'b1;
                load_num_shift1 = 1'b1;
                load_num_shift2 = 1'b1;
            end
            CALCULATE_MULT: begin
                mult_shift_en1 = 1'b1;
                mult_shift_en2 = 1'b1;
                en_num_shift1 = 1'b1;
                en_num_shift2 = 1'b1;
                load_PI_sub1 = 1'b1;
                load_PI_sub2 = 1'b1; 
            end
            SUB_A: begin
                en_cnt_sub1 = 1'b1;
                en_cnt_sub2 = 1'b1;
            end
            LOAD_A: begin
                loadA1 = 1'b1;
                loadA2 = 1'b1;
                selA1 = 1'b1;
                selA2 = 1'b1;
            end 
            DONE: begin
                done = 1'b1;
            end
        endcase
    end

endmodule

