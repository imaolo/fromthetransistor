// iverilog -o led_blinker_tb.vvp led_blinker.v led_blinker_tb.v
// vvp led_blinker_tb.vvp 
module led_tb;

    parameter TEST_DURATION = 80000;

    reg clk;
    wire led;

    led_blinker #(.period(2000)) u0 (.clk(clk), .led(led));

    always begin #1 clk = ~clk; end

    initial begin
        clk = 0;
        $monitor("%dns: LED = %b", $time, led);
        #TEST_DURATION $finish;
    end

endmodule