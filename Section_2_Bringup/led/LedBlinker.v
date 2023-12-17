module LedBlinker #(parameter PERIOD=1)(
    input wire clk,
    input wire reset,
    output reg led
);

generate
    if (PERIOD < 0) initial $fatal(1,"invalid period %d", PERIOD);
endgenerate

integer cnt = 0;

initial begin
    led = 0;
    cnt = 0;
end

always @(posedge clk) begin
    if (reset) begin
        led <= 0;
        cnt <= 0;
    end else if (cnt == PERIOD) begin
        led <= ~led;
        cnt <= 0;
    end else cnt <= cnt + 1;
end

endmodule