module LedBlinker #(parameter PERIOD=1)(
    input clk,
    input reset,
    output reg led
);

generate
    if (PERIOD == 0) initial $fatal(1,"zero period");
endgenerate

reg [63:0] counter = 0;

always @(posedge clk or reset) begin
    if (reset) begin
        led <= 0;
        counter = 0;
    end else if (counter == PERIOD) begin
        led <= ~led;
        counter <= 0;
    end else counter <= counter + 1;
end

endmodule