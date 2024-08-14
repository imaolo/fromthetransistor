// iverilog -o BaudRateGenerator_TB.vvp BaudRateGenerator.v BaudRateGenerator_TB.v
// vvp BaudRateGenerator_TB.vvp 

`timescale 1ns/1ns

module BaudRateGeneratorTB;

// timescale dependent
parameter BAUD_RATE      = 10;
parameter CLOCK_FREQ0    = BAUD_RATE*2*3;
parameter CLOCK_FREQ1    = BAUD_RATE*2*44;
parameter DURATION       = 1e9; // must be atleast a second

reg reset, clk0 = 0, clk1 = 0;
wire clk, bclk0, bclk1;

BaudRateGenerator#(.BR(BAUD_RATE), .CLKF(CLOCK_FREQ0)) u0 (
    .clk(clk0),
    .reset(reset),
    .bclk(bclk0));
BaudRateGenerator#(.BR(BAUD_RATE), .CLKF(CLOCK_FREQ1)) u1 (
    .clk(clk1),
    .reset(reset),
    .bclk(bclk1));

assign clk = (CLOCK_FREQ0 > CLOCK_FREQ1) ? clk1 : clk0;

always #(1e9/(CLOCK_FREQ0*2)) clk0 = ~clk0;
always #(1e9/(CLOCK_FREQ1*2)) clk1 = ~clk1;
always@(posedge clk) if (bclk0 != bclk1) $fatal(1,"FAILED - baud clocks not synced");

initial begin
    reset = 1; #10 reset = 0;
    #DURATION $display("PASSED");  $finish;
end

endmodule