// iverilog -o LedBlinker_TB.vvp LedBlinker.v LedBlinkerTB.v
// vvp LedBlinker_TB.vvp 

`timescale 1ns/1ns

module LedBlinkerTB;

parameter TEST_LEN = 10000;
parameter PERIOD = 100;
parameter EXPECTED_TOGGLES = TEST_LEN/20/PERIOD;

reg reset = 0;
reg clk = 0;
integer num_toggles = 0;
wire led;

LedBlinker #(.PERIOD(PERIOD)) u0 (
    .clk(clk),
    .reset(reset),
    .led(led));

always #10 clk = ~clk;
always @(led) num_toggles++;

initial begin
    #TEST_LEN; if (num_toggles != EXPECTED_TOGGLES) $fatal(1,"FAILED num : %d, exp : %d ", num_toggles, EXPECTED_TOGGLES);
    $display("PASSED");
    $finish;
end

endmodule