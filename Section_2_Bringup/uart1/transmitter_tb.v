`include "transmitter.v"

module transmitter_tb();

    /* instantiate the transmitter */
    reg[7:0] data_in  = 0;
    reg      clk      = 0;
    reg      write_en = 0;
    wire     rdy;
    wire     tx;
    transmitter t (
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

    /* start test */
    initial begin
        if (!tx || tx === 1'bz)
            $fatal(1, "tx should be idling");
        if (!rdy || rdy === 1'bz)
            $fatal(1, "tx should be ready");

        /* lets begin transmission */
        data_in = data;
        write_en = 1;
    
        /* go to start state */
        #4
        if (rdy || rdy === 1'bz)
            $fatal(1, "tx should not be ready");
        if (tx || tx === 1'bz)
            $fatal(1, "should be reading the start bit");
        
        /* transmit all the bits and test */
        for (i = 0; i<8; i++) begin
            #2
            if (tx != data[i] || tx === 1'bz)
                $fatal(1, "incorrect bit %d", i);
        end

        /* disable transmission */
        write_en = 0;

        /* check the stop bit */
        #2
        if (!tx || tx === 1'bz)
            $fatal(1, "stop bit should be high");

        /* shouldnt be ready yet */
        if (rdy || rdy === 1'bz)
            $fatal(1, "shouldnt be ready yet");

        /* back to idle */
        #2
        if (!rdy || rdy === 1'bz)
            $fatal(1, "should be ready");

        /* test idle */
        for (i = 0; i<20; i++)
            #1 if (!tx || tx === 1'bz) $fatal(1, "improper idle");

        $finish;
    
    end

endmodule
