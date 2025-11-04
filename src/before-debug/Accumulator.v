module Accumulator #(
    parameter WIDTH = 16
)(
    input clk,
    input rst,
    input en_acc,
    input [WIDTH-1:0] data1,
    input [WIDTH-1:0] data2,
    output reg [WIDTH-1:0] register
);
    always @(posedge clk or posedge rst) begin
        if (rst)
            register <= {WIDTH{1'b0}};
        else if (en_acc)
            register <= (register + data1 + data2);
    end
    
endmodule