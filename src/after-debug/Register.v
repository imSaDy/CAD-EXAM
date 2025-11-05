module Register #(
    parameter WIDTH = 3
)(
    input clk,
    input rst,
    input load,
    input [WIDTH-1:0] PI,
    output reg [WIDTH-1:0] register
);
    always @(posedge clk or posedge rst) begin
        if (rst)
            register <= {WIDTH{1'b0}};
        else if (load)
            register <= PI;
    end
    
endmodule