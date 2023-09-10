module BaudRateGenerator#(parameter BR=0, parameter CLKF=0)(
    input clk,
    input reset,
    output reg bclk
);

generate
    if (BR == 0 || CLKF == 0) initial $fatal(1, "baud rate nor clock frequency can be 0");
    if (CLKF < BR*2) initial $fatal(1, "clock frequency must be atleast double the baud rate");
    if (CLKF%(BR*2) != 0) initial $fatal(1, "The clock divisor must a whole number");
endgenerate

localparam CLK_DIV = CLKF / (BR*2);
integer counter = 0;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 0;
        bclk <= 0;
    end else if (counter == CLK_DIV-1) begin
        counter <= 0;
        bclk <= ~bclk;
    end else counter <= counter + 1;
end

endmodule