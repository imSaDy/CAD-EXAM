module MultShiftRegister #(
    parameter WIDTH = 8
)(
    input clk,
    input rst,
    input shift_en,
    input ser_in,
    input load,
    input [WIDTH-1:0] PI,
    output [WIDTH-1:0] data_out
);
    reg [WIDTH-1:0] register;

    always @(posedge clk or posedge rst) begin
        if (rst) 
            register <= {WIDTH{1'b0}};
        else if (load)
            register <= PI; 
        else if (shift_en) 
            register <= {register[WIDTH-2:0], ser_in};
    end

    assign data_out = register;
endmodule
