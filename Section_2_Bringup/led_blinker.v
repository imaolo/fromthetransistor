module led_blinker #(parameter period=1) (input clk, output reg led);

    reg [24:0] counter = 0;

    initial led = 0;
    always @(posedge clk) begin
        if (counter == period) begin
            led <= ~led;
            counter <= 0;
        end
        else begin
            counter <= counter + 1'b1;
        end
    end

endmodule