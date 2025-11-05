`timescale 1ns/1ns
module tb_Top();

    reg clk;
    reg rst;
    reg start;
    reg [7:0] A_init1;
    reg [7:0] W_init1;
    reg [7:0] A_init2;
    reg [7:0] W_init2;

    wire [15:0] final_result;
    wire final_done;

    initial clk = 0;
    always #5 clk = ~clk; 

    Top dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .A_init1(A_init1),
        .W_init1(W_init1),
        .A_init2(A_init2),
        .W_init2(W_init2),
        .final_result(final_result),
        .final_done(final_done)
    );

    initial begin

        A_init1 = 8'h00; W_init1 = 8'h00;
        A_init2 = 8'h00; W_init2 = 8'h00;
        rst = 1; start = 1'b0;

        #10 rst = 0;

        #10 start = 1'b1;  // max value of 16 bit = 65535
            A_init1 = 8'b11000001;
            W_init1 = 8'b00111110;
            A_init2 = 8'b11111111;
            W_init2 = 8'b01101110;

        #10 start = 1'b0;

        #3000;
        // rst = 1; 
        // #10 rst = 0;
        #10 start = 1'b1;  // max value of 16 bit = 65535
            A_init1 = 8'b11111111;
            W_init1 = 8'b11111111;
            A_init2 = 8'b11111111;
            W_init2 = 8'b00000000;

        #10 start = 1'b0;

        #3000;
        $stop;
    end
endmodule

