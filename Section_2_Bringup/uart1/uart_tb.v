// iverilog -o uart_tb.vvp uart.v uart_tb.v
// vvp uart_tb.vvp 


module uart_tx_tb();

    /* instantiate the uart */
    reg[7:0] data_in  = 0;
    reg      clk      = 0;
    reg      write_en = 0;
    wire     rdy;
    wire     tx;
    uart_tx u (
        .data(data_in),
        .clk(clk),
        .write_en(write_en),
        .rdy(rdy),
        .tx(tx)
    );

    /* test vars */
    integer i = 0;
    reg[7:0] data = 8'b01010101;

    /* start the clock */
    initial forever #1 clk = ~clk;

    initial begin
        if (!tx)
            $fatal(1, "tx should be idling");
        if (!rdy)
            $fatal(1, "tx should be ready");

        /* lets begin transmission */
        data_in = data;
        write_en = 1;
    
        /* go to start state */
        #4
        if (rdy)
            $fatal(1, "tx should not be ready");
        if (tx)
            $fatal(1, "should be reading the start bit");
        
        /* transmit all the bits and test */
        for (i = 0; i<8; i++) begin
            #2
            if (tx != data[i])
                $fatal(1, "incorrect bit %d", i);
        end

        /* disable transmission */
        write_en = 0;

        /* check the stop bit */
        #2
        if (!tx)
            $fatal(1, "stop bit should be high");

        /* shouldnt be ready yet */
        if (rdy)
            $fatal(1, "shouldnt be ready yet");

        /* back to idle */
        #2
        if (!rdy)
            $fatal(1, "should be ready");

        /* test idle */
        for (i = 0; i<20; i++)
            #1 if (!tx) $fatal(1, "improper idle");
    
    end

endmodule


module uart_tb();

    /* define the clock */
    reg  clk;

    /* declare uart1 */
    reg[7:0]  din1 = 0;
    wire[7:0] dout1;
    reg       wr_en1 = 0;
    reg       rd_en1 = 0;
    reg       rx1  = 0;
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
    reg       rx2 = 0;
    wire      rd_rdy2;
    wire      wr_rdy2;
    wire      tx2;
    uart u2 (
        .din(din2),
        .clk(clk),
        .wr_en(wr_en1),
        .rd_en(rd_en1),
        .rx(rx2),
        .tx(tx2),
        .rd_rdy(rd_rdy1),
        .wr_rdy(wr_rdy1),
        .dout(dout1)
    );

    /* start the clock */
    initial forever #1 clk = ~clk;

    initial begin
        rx1 <= tx2;
        rx2 <= tx1;

        if (!tx1)
            $fatal(1, "u1 should be idling");
        if (!tx2)
            $fatal(1, "u2 should be idling");
        #2

        /* lets write some data and see what happens */
        // $fatal(1, "u2 is not reading %d", dout2);
        din1 = 125;
        din2 = 47;
        wr_en1 = 1;
        wr_en2 = 1;
        rd_en2 = 1;
        rd_en1 = 1;
        #35
        // $fatal(1, "u2 is not reading %d", dout2);
        // if (dout1 != 46 || 1)
        //     $fatal(1, "u1 is not reading %d", dout2);

        

        $finish(1);
    end;

endmodule