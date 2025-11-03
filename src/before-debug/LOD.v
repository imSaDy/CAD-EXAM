module LOD(
    input clk,
    input rst,
    input load_regA,
    input [7:0] A,
    input shift_en,
    input cnt_en,
    input [2:0] outputPI,
    output [2:0] shift_count,
    output co_LOD,
    output done
);
    wire [2:0] index;
    wire [7:0] regA;

    Counter #(
        .WIDTH(3)
    ) counter (
        .clk(clk),
        .rst(rst),
        .load(1'b0),
        .en(cnt_en),
        .PI(3'b0),
        .count(index)
    );
    
    
    ShiftRegister #(
        .WIDTH(8)
    ) shift_regsiter (
        .clk(clk),
        .rst(rst),
        .shift_en(shift_en),
        .ser_in(1'b0),
        .load(load_regA),
        .PI(A),
        .data_out(regA)
    );
    
    Register #(
        .WIDTH(3)
    ) output_register (
        .clk(clk),
        .rst(rst),
        .load(regA[0]),
        .PI(index),
        .register(shift_count)
    );
    
    assign done = ~|A;
    assign co_LOD = &index; 
endmodule
