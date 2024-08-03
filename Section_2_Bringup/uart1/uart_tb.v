// iverilog -o uart_tb.vvp uart.v uart_tb.v
// vvp uart_tb.vvp 

module uart_rx_tb();

    /* instantiate the uart */
    reg rx = 1;
    reg clk = 0;
    wire rdy;
    wire[7:0] out_data;
    uart_rx u (
        .rx(rx),
        .clk(clk),
        .rdy(rdy),
        .data(out_data)
    );

    /* start the clock */
    initial forever #1 clk = ~clk;

    initial begin
        if (out_data != 0)
            $fatal(1, "1. failed - %d", out_data);

        /* put the reciever in read mode */
        rx = 0;
        #2

        /* write a bit */
        rx = 1;
        #2
        if (out_data != 1)
            $fatal(1, "2. failed - %d", out_data);

        /* write the same bit some more */
        #4
        if (out_data != 7)
            $fatal(1, "3. failed - %d", out_data);

        /* we should not be ready to read yet */
        if (rdy)
            $fatal(1, "4. failed");

        /* lets write some zeros */
        rx = 0;
        #4
        if (out_data != 8'b00011100)
            $fatal(1, "5. failed - %d", out_data);

        /* finish it off */
        #6
        if (!rdy)
            $fatal(1, "6. should be ready");
        if (out_data != 8'b11100000)
            $fatal(1, "7. failed - %d", out_data);

        /* should stay ready until we start reading again */
        rx = 1; // idle
        #10
        if (!rdy)
            $fatal(1, "8. should be ready");

        /* should not be ready once we exit the idle state */
        rx = 0;
        #2
        rx = 1; // write a bit
        #2
        if (rdy)
            $fatal(1, "9. should not be ready");

        /* even though we are not ready, we dont clear the buffer */
        if (out_data != 8'b11000001)
            $fatal(1, "10. failed - %d", out_data);

        $finish(0);
    end


endmodule

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