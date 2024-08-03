`include "uart.v"

module uart_tb();

    /* define the clock */
    reg  clk = 0;

    /* test vars */
    reg[7:0] data;
    integer i;

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
    assign rx1 = tx2;
    assign rx2 = tx1;

    /* start the clock */
    initial forever #1 clk = ~clk;

initial begin

    /* transmit some data */

    din1 = 8'b11101000;
    wr_en1 = 1;
    rd_en2 = 1;
    while (rd_rdy2 == 0)
        #2;
    if (dout2 != din1)
        $fatal(1, "failed - %b - %b", dout2, din1);

    /* transmit and receive */
    din1 = 8'b11001010;
    din2 = 8'b01001011;
    wr_en1 = 1;
    wr_en2 = 1;
    rd_en1 = 1;
    rd_en2 = 1;
    // TODO - this syntax works uut.a = 0;
    // TODO - some work needed with the control signals
    while (rd_rdy1 == 0 || rd_rdy2 == 0) begin
        #2;
        if (rd_rdy1 == 1) begin
            wr_en2 = 0;
        end;
        if (rd_rdy2 == 1) begin
            wr_en1 = 0;
        end;
    end
    if (dout2 != din1)
        $fatal(1, "failed(1) - %b - %b", dout2, din1);
    if (dout1 != din2)
        $fatal(1, "failed(2) - %b - %b", dout1, din2);
    $finish(0);
end;

endmodule