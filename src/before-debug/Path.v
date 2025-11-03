module Path1(
    input clk,
    input rst,
    input selA,
    input loadA,
    input loadW,
    input [7:0] A_init,
    input [7:0] W_init,
    input load_regA, 
    input shift_en_LOD,
    input cnt_en_LOD,
    input loadShiftCountDP,
    input load_mult, 
    input rst_ready,
    input en_num_shift,
    
    output [15:0] partialO,
    output done,
    output ready
);
    wire [7:0] mux_out, xor_out, A, W;
    wire [2:0] wire_shift_count, shift_count_dp;

    Mux2 #(
        .WIDTH(8),
    ) mux (
        .in0(A_init),
        .in1(xor_out),
        .sel(selA),
        .out(mux_out)
    )

    Register #(
        .WIDTH(8)
    ) regA (
        .clk(clk),
        .rst(rst),
        .load(loadA),
        .PI(mux_out),
        .register(A)
    );

    Register #(
        .WIDTH(8)
    ) regW (
        .clk(clk),
        .rst(rst),
        .load(loadW),
        .PI(W_init),
        .register(W)
    );

    LOD lod (
        .clk(clk),
        .rst(rst),
        .load_regA(load_regA),
        .A(A),
        .shift_en(shift_en_LOD),
        .cnt_en(cnt_en_LOD),
        .shift_count(wire_shift_count),
        .co_LOD(co_LOD),
        .done(done)
    );

    Register #(
        .WIDTH(8)
    ) registerShiftCount (
        .clk(clk),
        .rst(rst),
        .load(loadShiftCountDP),
        .PI(wire_shift_count),
        .register(shift_count_dp)
    );

    MultO multo (
        .clk(clk),
        .rst(rst),
        .load_mult(load_mult),
        .W(W),
        .ready(ready),
        .shift_count(shift_count_dp), // possibly bug
        .mult_shift_en(mult_shift_en),
        .en_num_shift(en_num_shift),
        .rst_ready(rst_ready),
        .final_partial(partialO),
    );
    
    // need to continue

    ShiftRegister #(
        .WIDTH(WIDTH_SUB)
    ) shift_reg_sub_inst (
        .clk(clk),
        .rst(rst),
        .shift_en(shift_en_sub),
        .ser_in(1'b0),
        .load(load_sub_reg),
        .PI(sub_in),
        .data_out(wire_sub)
    );

    Counter #(
        .WIDTH(WIDTH_C)
    ) counter_P1_inst (
        .clk(clk),
        .rst(rst),
        .load(load_P1),
        .en(en_P1),
        .PI(PI_P1),
        .count(wire_count_P1)
    );

    Register #(
        .WIDTH(WIDTH_C)
    ) reg_co_sub_inst (
        .clk(clk),
        .rst(rst),
        .load(ld_co_sub),
        .PI(wire_count_P1),
        .register(wire_co_sub)
    );
endmodule