module MultO (
    input clk,
    input rst,
    input load_mult,
    input [7:0] W,
    input done,
    input [2:0] shift_count,
    input mult_shift_en,
    input en_num_shift,
    input rst_ready,
    input load_num_shift,
    
    output [15:0] final_partial,
    output ready
);
    wire reg_ready;
    wire [15:0] partial;
    wire [2:0] cnt;
    wire co_mult;

    MultShiftRegister #(
        .WIDTH(16)
    ) mult_shift_register (
        .clk(clk),
        .rst(rst),
        .shift_en(mult_shift_en & (~ready)),
        .ser_in(1'b0),
        .load(load_mult),
        .PI({8'b0, W}),
        .data_out(partial)
    );

    Counter #(
        .WIDTH(3)
    ) count_shifter (
        .clk(clk),
        .rst(rst),
        .load(load_num_shift),
        .en(en_num_shift),
        .PI(3'd8 - shift_count),
        .count(cnt)
    );
    
    Mux2 #(
        .WIDTH(16)
    ) mux (
        .in0(partial),
        .in1(16'b0),
        .sel(done),
        .out(final_partial)
    );

    Register #(
        .WIDTH(1)
    ) reg_ready_register (
        .clk(clk),
        .rst(rst | rst_ready),
        .load(co_mult),
        .PI(co_mult),
        .register(reg_ready)
    );

    assign ready = (reg_ready | (shift_count == 0));
    assign co_mult = &cnt;
endmodule