// iverilog -o LedBlinker_tb.vvp LedBlinker.v LedBlinker_tb.v
// vvp LedBlinker_tb.vvp 

module LEDBlinker_tb();
    /* Test parameters */
    parameter TEST_CYCLES = 500;
    parameter MIN_PERIOD = 1;
    parameter MAX_PERIOD = 141;

    /* test vars */
    integer num_toggles = 0;
    integer expected_toggles = 0;
    integer i;

    /* instantiate the blinker */
    reg     reset = 0;
    reg     clk = 0;
    integer period;
    wire    led;
    LedBlinker u0 (
        .clk(clk),
        .reset(reset),
        .period(period),
        .led(led)
    );

    /* start the clock */
    initial forever #1 clk = ~clk;

    /* track how many times the led changes */
    always @(led) if (!reset) num_toggles++;

    initial begin
        for (i = MIN_PERIOD; i <= MAX_PERIOD; i++) begin
            /* configure blinker */
            period = i;
            reset = 1;

            /* reset test counter */
            num_toggles = 0;

            /* The led should change after every period (/period) rising edges (/2) */
            expected_toggles = TEST_CYCLES/period/2;

            /* let the led blink */
            #2 reset = 0;
            #(TEST_CYCLES)

            /* verify the number of blinks */
            if (num_toggles != expected_toggles)
                $fatal(1,"FAILED num : %d, exp : %d", num_toggles, expected_toggles);
        end
        $finish;
    end

endmodule;