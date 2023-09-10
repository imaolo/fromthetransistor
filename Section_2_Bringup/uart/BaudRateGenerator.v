module BaudRateGenerator#(parameter BR=0, parameter CLKF=0)(
    input clk,
    input reset,
    output wire bclk
);

generate
    if (BR == 0 || CLKF == 0) initial $fatal(1, "baud rate nor clock frequency can be 0");
    if (CLKF < BR*2) initial $fatal(1, "clock frequency must be atleast double the baud rate");
    if (CLKF%(BR*2) != 0) initial $fatal(1, "The clock divisor must a whole number");
endgenerate

localparam CLK_DIV = CLKF / (BR*2);
reg [$clog2(CLK_DIV)-1:0] counter = 0;
reg int_bclk;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 0;
        int_bclk <= 0;
    end else if (counter == CLK_DIV-1) begin
        counter <= 0;
        int_bclk <= ~int_bclk;
    end else counter <= counter + 1;
    if (counter >= CLK_DIV) $fatal(1, "counter overflow!");
end

assign bclk = int_bclk;

endmodule