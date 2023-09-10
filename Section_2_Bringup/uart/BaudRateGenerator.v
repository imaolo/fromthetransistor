module BaudRateGenerator#(parameter BR=0, parameter CLKF=0)(
    input clk,
    input reset,
    output wire bclk
);

// parameter asserts and clock divisor calculation
generate
    if (BR == 0) initial $fatal(1, "baud rate cannot be 0");
    if (CLKF == 0) initial $fatal(1, "clock frequency cannot be 0");

    /* I would really love these to be scoped to the generate block. I don't
     * want them leaking into sythesizable code. They only exist as intermediaries
     * in the CLK_DIV computation and validation. If someone knows how to achieve this,
     * please tell me.
    */
    localparam real _br = BR;
    localparam real _clkf = CLKF;
    localparam real _clk_div = clkf/(br*2);

    initial if (_clk_div != $floor(_clk_div)) $fatal(1, "clock divisor must be whole number");
    initial if (_clk_div == 0) $fatal(1, "clock divisor must be >0");
    
    localparam CLK_DIV = _clk_div;
endgenerate

reg [$clog2(CLK_DIV)-1:0] counter = 0;
reg int_bclk = 0;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 0;
        int_bclk <= 0;
    end else begin
        if (counter >= CLK_DIV) $fatal(1, "counter overflow!");
        else if (counter == CLK_DIV-1) begin
            counter <= 0;
            int_bclk <= ~int_bclk;
        end else counter <= counter + 1;
    end
end

assign bclk = int_bclk;

endmodule