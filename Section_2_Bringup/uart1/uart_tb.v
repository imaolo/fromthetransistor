`include "uart.v"

module uart_tb();

    /* define the clock */
    reg  clk = 0;

    /* some test vars */
    reg[7:0] data;
    integer i;

    /* declare uart1 */
    reg[7:0]  din1 = 0;
    wire[7:0] dout1;
    reg       wr_en1 = 0;
    reg       rd_en1 = 0;
    wire      rx1;
    wire      rd_rdy1;
    wire      wr_rdy1;
    wire      tx1;
    uart u1 (
        .din(din1),
        .clk(clk),
        .wr_en(wr_en1),
        .rd_en(rd_en1),
        .rx(rx1),
        .tx(tx1),
        .rd_rdy(rd_rdy1),
        .wr_rdy(wr_rdy1),
        .dout(dout1)
    );

    /* declare uart2 */
    reg[7:0]  din2 = 0;
    wire[7:0] dout2;
    reg       wr_en2 = 0;
    reg       rd_en2 = 0;
    wire      rx2;
    wire      rd_rdy2;
    wire      wr_rdy2;
    wire      tx2;
    uart u2 (
        .din(din2),
        .clk(clk),
        .wr_en(wr_en2),
        .rd_en(rd_en2),
        .rx(rx2),
        .tx(tx2),
        .rd_rdy(rd_rdy2),
        .wr_rdy(wr_rdy2),
        .dout(dout2)
    );

    assign rx1 = tx2;
    assign rx2 = tx1;

    /* start the clock */
    initial forever #1 clk = ~clk;

initial begin

    /* both data outs should be low */
    if (dout1 != 8'b0)
        $fatal(1, "1. dout1 should be low - %b", dout1);
    if (dout1 === 8'bz)
        $fatal(1, "2. dout1 should be low - %b", dout1);
    if (dout2 != 8'b0)
        $fatal(1, "1. dout2 should be low - %b", dout2);
    if (dout2 === 8'bz)
        $fatal(1, "2. dout2 should be low - %b", dout2);


    /* lets transmit some data */

    din1 = 8'b11101000;
    wr_en1 = 1;
    rd_en2 = 1;
    while (rd_rdy2 == 0)
        #2;
    if (dout2 != din1)
        $fatal(1, "failed - %b - %b", dout2, din1);
    $finish(0);
end;

endmodule