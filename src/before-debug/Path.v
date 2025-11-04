module Path(
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
    input shift_en_sub,
    input load_sub_reg,
    input load_PI_sub,
    input en_cnt_sub,
    output [15:0] partialO,
    output done,
    output ready,
    output co_sub
);
    wire [7:0] mux_out, xor_out, A, W, sub;
    wire [2:0] wire_shift_count, shift_count_dp, sub_cnt;
    wire co_sub; 

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
    
    

    ShiftRegister #(
        .WIDTH(8)
    ) shift_reg_sub (
        .clk(clk),
        .rst(rst),
        .shift_en(shift_en_sub),
        .ser_in(1'b0),
        .load(load_sub_reg),
        .PI(8'b1),
        .data_out(sub)
    );

    assign xor_out = sub ^ A;

    Counter #(
        .WIDTH(3) 
    ) counter_P1_inst (
        .clk(clk),
        .rst(rst),
        .load(load_PI_sub),
        .en(en_cnt_sub),
        .PI(4'b1000 - shift_count_dp), // possibly bug
        .count(sub_cnt)
    );

    assign wire_co_sub = &sub_cnt; 

    Register #(
        .WIDTH(1)
    ) reg_co_sub_inst (
        .clk(clk),
        .rst(rst), // possibly bug
        .load(wire_co_sub),
        .PI(wire_co_sub),
        .register(co_sub)
    );
endmodule