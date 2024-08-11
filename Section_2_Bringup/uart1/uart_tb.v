`include "uart.v"

module uart_tb();

    /* define the clock */
    reg  clk = 0;

    /* test vars */
    reg[7:0] data;
    integer i;
    reg rdy1;
    reg rdy2;

    /* controls */
    reg wr_en1 = 0;
    reg wr_en2 = 0;
    reg rd_en1 = 0;
    reg rd_en2 = 0;

    /* statuses */
    wire rd_rdy1;
    wire rd_rdy2;
    wire wr_rdy1;
    wire wr_rdy2;

    /* serial signals */
    wire rx1;
    wire rx2;
    wire tx1;
    wire tx2;

    /* buffers */
    reg[7:0]  din1 = 0;
    reg[7:0]  din2 = 0;
    wire[7:0] dout1;
    wire[7:0] dout2;

    /* declare uarts */

    uart u1 (
        .clk(clk),

        /* controls */
        .wr_en(wr_en1),
        .rd_en(rd_en1),

        /* buffers */
        .din(din1),
        .dout(dout1),

        /* signals */
        .rd_rdy(rd_rdy1),
        .wr_rdy(wr_rdy1),

        /* serial signals */
        .rx(rx1),
        .tx(tx1)
    );

    uart u2 (
        .clk(clk),

        /* controls */
        .wr_en(wr_en2),
        .rd_en(rd_en2),

        /* buffers */
        .din(din2),
        .dout(dout2),

        /* signals */
        .rd_rdy(rd_rdy2),
        .wr_rdy(wr_rdy2),

        /* serial signals */
        .rx(rx2),
        .tx(tx2)
    );

    /* tie serial signals */
    assign rx1 = u2.tx;
    assign rx2 = u1.tx;

    /* start the clock */
    initial forever #1 clk = ~clk;

initial begin

    /* transmit some data */

    din1 = 8'b11101000;
    wr_en1 = 1;
    rd_en2 = 1;
    while (!u2.rd_rdy)
        #2;
    if (u2.dout != din1)
        $fatal(1, "failed - %b - %b", dout2, din1);

    /* transmit and receive */

    /* wait for write ready and read not ready*/
    while (!u1.wr_rdy || !u2.wr_rdy || u1.rd_rdy || u2.rd_rdy)
        #2;

    /* confiure controls */
    wr_en1 = 1;
    wr_en2 = 1;
    rd_en1 = 1;
    rd_en2 = 1;

    /* send data */
    din1 = 8'b11001010;
    din2 = 8'b01001011;

    /* wait for data to be received (ready signals go high for single cycle) */
    rdy1 = u1.rd_rdy;
    rdy2 = u2.rd_rdy;
    while (!rdy1 || !rdy2) begin
        #2
        if (u1.rd_rdy) begin
            rdy1 = 1;
            rd_en1 = 0;
        end;

        if (u2.rd_rdy) begin
            rdy2 = 1;
            rd_en2 = 0;
        end
    end

    /* verify data */
    if (u2.dout != din1)
        $fatal(1, "failed(1) - %b - %b", u2.dout, din1);
    if (u1.dout != din2)
        $fatal(1, "failed(2) - %b - %b", u1.dout, din2);
    $finish;
end;

endmodule