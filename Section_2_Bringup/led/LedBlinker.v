module LedBlinker #(
    parameter DEFAULT_PERIOD = 1,
    parameter MIN_PERIOD = 1,
    parameter MAX_PERIOD = 1000
)(
    input       clk,
    input       reset,
    input[31:0] period,
    output reg  led
);
    /* verify parameters */
    initial begin
        if (MIN_PERIOD <= 0)
            $fatal(1, "Mininum period must be greater than 0");
        if (MAX_PERIOD > (2**31 - 1))
            $fatal(1, "Maximum period must fit in integer");
        if (MAX_PERIOD < MIN_PERIOD)
            $fatal(1, "Maximum period must be greater than mininum period");
        if (DEFAULT_PERIOD > MAX_PERIOD || DEFAULT_PERIOD < MIN_PERIOD)
            $fatal(1, "Default period must be within max and min period");
    end

    /* define internal registers */
    integer period_reg;
    integer cnt;

    /* initialize registers */
    initial begin
        led = 0;
        cnt = 0;
        period_reg = (period == 0) ? DEFAULT_PERIOD : period;
    end

    /* main toggle logic */
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            led <= 0;
            cnt <= 0;

            if ((period > MAX_PERIOD || period < MIN_PERIOD) && period != 0)
                $fatal(1, "period must be within max and min");

            period_reg = (period == 0) ? DEFAULT_PERIOD : period;
        end else if (cnt >= period_reg-1) begin
            led <= ~led;
            cnt <= 0;
        end else
            cnt++;
    end

endmodule