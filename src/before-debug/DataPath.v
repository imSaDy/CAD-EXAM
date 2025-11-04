module DataPath(
    input clk,
    input rst,

    input selA1,
    input loadA1,
    input loadW1,
    input [7:0] A_init1,
    input [7:0] W_init1,
    input load_regA1, 
    input shift_en_LOD1,
    input cnt_en_LOD1,
    input loadShiftCountDP1,
    input load_mult1, 
    input rst_ready1,
    input en_num_shift1,
    input shift_en_sub1,
    input load_sub_reg1,
    input load_PI_sub1,
    input en_cnt_sub1,
    input load_num_shift1,

    input selA2,
    input loadA2,
    input loadW2,
    input [7:0] A_init2,
    input [7:0] W_init2,
    input load_regA2, 
    input shift_en_LOD2,
    input cnt_en_LOD2,
    input loadShiftCountDP2,
    input load_mult2, 
    input rst_ready2,
    input en_num_shift2,
    input shift_en_sub2,
    input load_sub_reg2,
    input load_PI_sub2,
    input en_cnt_sub2,
    input load_num_shift2,

    input rst_acc,
    input sel_P,

    output [15:0] final_result,
    output done,
    output Ready1,
    output Ready2,
    output co_sub1,
    output co_sub2
);

    wire [15:0] Partial1;
    wire [15:0] Partial2;
    wire done1;
    wire done2;
    
    wire en_acc;
    wire [15:0] mux_out;

    Path path1 (
        .clk(clk),
        .rst(rst),
        .selA(selA1),
        .loadA(loadA1),
        .loadW(loadW1),
        .A_init(A_init1),
        .W_init(W_init1),
        .load_regA(load_regA1), 
        .shift_en_LOD(shift_en_LOD1),
        .cnt_en_LOD(cnt_en_LOD1),
        .loadShiftCountDP(loadShiftCountDP1),
        .load_mult(load_mult1), 
        .rst_ready(rst_ready1),
        .en_num_shift(en_num_shift1),
        .shift_en_sub(shift_en_sub1),
        .load_sub_reg(load_sub_reg1),
        .load_PI_sub(load_PI_sub1),
        .en_cnt_sub(en_cnt_sub1),
        .load_num_shift(load_num_shift1),
        
        .partialO(Partial1),
        .done(done1),
        .ready(Ready1),
        .co_sub(co_sub1)
    );

    Path path2 (
        .clk(clk),
        .rst(rst),
        .selA(selA2),
        .loadA(loadA2),
        .loadW(loadW2),
        .A_init(A_init2),
        .W_init(W_init2),
        .load_regA(load_regA2), 
        .shift_en_LOD(shift_en_LOD2),
        .cnt_en_LOD(cnt_en_LOD2),
        .loadShiftCountDP(loadShiftCountDP2),
        .load_mult(load_mult2), 
        .rst_ready(rst_ready2),
        .en_num_shift(en_num_shift2),
        .shift_en_sub(shift_en_sub2),
        .load_sub_reg(load_sub_reg2),
        .load_PI_sub(load_PI_sub2),
        .en_cnt_sub(en_cnt_sub2),
        .load_num_shift(load_num_shift2),
        
        .partialO(Partial2),
        .done(done2),
        .ready(Ready2),
        .co_sub(co_sub2)
    );

    assign en_acc = Ready1 & Ready2;
    assign done = done1 | done2;

    Accumulator #(
        .WIDTH(WIDTH_P)
    ) accumulator (
        .clk(clk),
        .rst(rst), // possibly bug
        .en_acc(en_acc),
        .data1(Partial1),
        .data2(Partial2),
        .register(final_result)
    );

endmodule

