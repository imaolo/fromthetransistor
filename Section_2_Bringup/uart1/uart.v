`include "transmitter.v"
`include "receiver.v"

module uart(
    input[7:0]  din,
    input       clk,
    input       wr_en,
    input       rd_en,
    input       rx,
    output      tx,
    output      rd_rdy,
    output      wr_rdy,
    output[7:0] dout
);

receiver r(
    .rx(rx),
    .clk(clk),
    .rdy(rd_rdy),
    .data(dout)
);

transmitter t(
    .data(din),
    .clk(clk),
    .write_en(wr_en),
    .rdy(wr_rdy),
    .tx(tx)
);

endmodule