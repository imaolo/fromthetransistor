module BaudRateGenerator#(parameter BR=0, parameter CLKR=0)(
    input clk,
    input reset,
    output wire baud_clock
);

generate
    if (BR == 0 || CLKR == 0) begin
        initial $fatal("BaudRateGenerator must be instantiated with non-zero baud and clock rate parameters.");
    end
endgenerate

parameter BAUD_DIV = CLKR / BR;

reg [31:0] counter = 0;
reg baud_toggle = 0;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 0;
        baud_toggle <= 0;
    end else if (counter == BAUD_DIV - 1) begin
        counter <= 0;
        baud_toggle <= ~baud_toggle;
    end else begin
        counter <= counter + 1;
    end
end

assign baud_clock = baud_toggle;

endmodule