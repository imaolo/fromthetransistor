`timescale 1ns/1ns

module UART(
    input clk, reset, tx_data, tx_start, rx_enable, rx,
    output tx, tx_done, rx_ready
);

reg r = 0;
wire w;

assign w = r;

endmodule


// module example(output wire out1, input clk, input in1);
//     reg r1;
//     always @(posedge clk) begin
//         r1 = in1;
//     end
//     assign out1 = r1;
// endmodule

// module example(output wire out1, input clk, input in1);
//     always @(posedge clk) begin
//         out1 <= in1;
//     end
// endmodule