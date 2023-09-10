// iverilog -o LedBlinkerTB.vvp LedBlinker.v LedBlinkerTB.v
// vvp LedBlinkerTB.vvp 

`timescale 1ns/1ns

module LedBlinkerTB;

// timescale dependent
parameter CLOCK_FREQ     = 100;
parameter DURATION       = 64e9; // must be atleast a second (HZ is /s and floats dont exist here)
parameter NUM_BLINKS     = 100;

reg reset, clk = 0;
wire led;
integer num_blinks = 0, prev_led = 0;
LedBlinker #(.PERIOD((DURATION/1e9)*(CLOCK_FREQ/(NUM_BLINKS*2+1)))) u0 (
    .clk(clk),
    .reset(reset),
    .led(led));

always begin
    #(1e9/(CLOCK_FREQ*2)) clk = ~clk;
    if (prev_led != led) begin
        prev_led = led;
        if (led == 1) num_blinks++;
    end;
end

initial begin
    reset = 1;
    #10 reset = 0;
    #DURATION if (num_blinks !== NUM_BLINKS) $fatal(1,"FAILED");
    $display("PASSED"); $finish;
end

endmodule