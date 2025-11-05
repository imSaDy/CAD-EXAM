module Controller(
    input clk,
    input rst,
    input start,
    
    input done,
    input ready1,
    input ready2,
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
    output reg rst_co_sub1,

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
    output reg rst_co_sub2,

    output reg rst_acc,
    output reg sel_P,
    
    output reg update_acc,
    
    output reg final_done,
    output reg rst_controller
);

    reg [3:0] ps, ns;
    parameter [3:0] IDLE = 4'b0000,
                    LOAD_A_W = 4'b0001,
                    LOAD_LOD = 4'b0010,
                    CALCULATE_LOD = 4'b0011,
                    CALCULATE_MULT = 4'b0100,
                    SUB_A = 4'b0101,
                    LOAD_A = 4'b0110,
                    DONE = 4'b0111,
                    WAIT1 = 4'b1000,
                    WAIT2 = 4'b1001;

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
            LOAD_LOD: ns = (~done ? CALCULATE_LOD : DONE);
            CALCULATE_LOD: ns = (co_lod ? WAIT1 : CALCULATE_LOD);
            WAIT1: ns = WAIT2;
            WAIT2: ns = CALCULATE_MULT;
            CALCULATE_MULT: ns = ((ready1 && ready2) ? SUB_A : CALCULATE_MULT);
            SUB_A: ns = ((co_sub1 && co_sub2) ? LOAD_A : SUB_A);
            LOAD_A: ns = LOAD_LOD;
            DONE: ns = IDLE; 
            default: ns = IDLE;
        endcase
    end

    always @(*) begin
        {selA1, loadA1, loadW1, load_regA1, shift_en_LOD1, cnt_en_LOD1, loadShiftCountDP1, load_mult1, rst_ready1, en_num_shift1, mult_shift_en1, shift_en_sub1, load_sub_reg1, load_PI_sub1, en_cnt_sub1, load_num_shift1, rst_co_sub1,
         selA2, loadA2, loadW2, load_regA2, shift_en_LOD2, cnt_en_LOD2, loadShiftCountDP2, load_mult2, rst_ready2, en_num_shift2, mult_shift_en2, shift_en_sub2, load_sub_reg2, load_PI_sub2, en_cnt_sub2, load_num_shift2, rst_co_sub2,
         rst_acc, sel_P, final_done, update_acc, rst_controller} = 39'b0;
         
        case (ps)
            IDLE: begin    
                rst_controller = 1'b1; 
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
                loadShiftCountDP1 = 1'b1;
                loadShiftCountDP2 = 1'b1;
                load_mult1 = 1'b1;
                load_mult2 = 1'b1;
                load_num_shift1 = 1'b1;
                load_num_shift2 = 1'b1;
                rst_ready1 = 1'b1;
                rst_ready2 = 1'b1;
            end
            WAIT1: begin
                loadShiftCountDP1 = 1'b1;
                loadShiftCountDP2 = 1'b1;
                load_mult1 = 1'b1;
                load_mult2 = 1'b1;
                load_num_shift1 = 1'b1;
                load_num_shift2 = 1'b1;
                rst_ready1 = 1'b1;
                rst_ready2 = 1'b1;
            end
            WAIT2: begin
                loadShiftCountDP1 = 1'b1;
                loadShiftCountDP2 = 1'b1;
                load_mult1 = 1'b1;
                load_mult2 = 1'b1;
                load_num_shift1 = 1'b1;
                load_num_shift2 = 1'b1;
                rst_ready1 = 1'b1;
                rst_ready2 = 1'b1;
            end
            CALCULATE_MULT: begin
                mult_shift_en1 = 1'b1;
                mult_shift_en2 = 1'b1;
                en_num_shift1 = 1'b1;
                en_num_shift2 = 1'b1;
                load_PI_sub1 = 1'b1;
                load_PI_sub2 = 1'b1; 
                load_sub_reg1 = 1'b1;
                load_sub_reg2 = 1'b1;
                update_acc = 1'b1;
                rst_co_sub1 = 1'b1; 
                rst_co_sub2 = 1'b1; 
            end
            SUB_A: begin
                en_cnt_sub1 = 1'b1;
                en_cnt_sub2 = 1'b1;
                shift_en_sub1 = 1'b1; 
                shift_en_sub2 = 1'b1;
            end
            LOAD_A: begin
                loadA1 = 1'b1;
                loadA2 = 1'b1;
                selA1 = 1'b1;
                selA2 = 1'b1;
            end 
            DONE: begin
                final_done = 1'b1;
            end
        endcase
    end

endmodule

