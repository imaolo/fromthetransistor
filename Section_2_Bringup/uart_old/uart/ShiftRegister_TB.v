// iverilog -o ShiftRegister_TB.vvp ShiftRegister.v ShiftRegister_TB.v
// vvp ShiftRegister_TB.vvp 

`timescale 1ns/1ns

module ShiftRegister_TB;

parameter N = 8;

reg [N-1:0]in, load = 0, reset = 0, enable = 0, clk = 0;
wire out;

ShiftRegister#(N) uut (
    .in(in), .enable(enable), .load(load),
    .clk(clk), .reset(reset), .out(out)
);

always #5 clk = ~clk;

integer i = 0;
initial begin
    reset = 1;
    #10 reset = 0;

    in = 8'b11110001;
    load = 1;
    #10 load = 0;
    enable = 1;
    repeat(N) begin
        if (out != in[i]) $display("FAILED");
        #10 i++;
    end
    $finish;
end

endmodule