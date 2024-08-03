`include "receiver.v"

module receiver_tb();

    /* test vars */
    integer  i;
    reg[7:0] data = 0;

    /* instantiate the transmitter */
    reg  rx      = 1;
    reg  clk     = 0;
    reg  read_en = 0;
    wire rdy;
    wire[7:0] data_out;
    receiver r (
        .x(rx),
        .clk(clk),
        .en(read_en),
        .rdy(rdy),
        .data(data_out)
    );

    /* start the clock */
    initial forever #1 clk = ~clk;

    /* start test */
    initial begin

        /* initialization tests */

        if (data_out != 0 || data_out === 8'bz)
            $fatal(1, "data init failed - %d", data_out);

        if (rdy == 1 || rdy === 1'bz)
            $fatal(1, "ready init failed - %d", data_out);

        /* we can transmit all we want but we need to enable reading */
        read_en = 0;
        for (i = 0; i<40; i++) begin
            #2 rx = i % 2;
            if (data_out != 0 || data_out === 8'bz)
                $fatal(1, "read disabled failed - %d", data_out);
        end

        /* enable reading but stay in idle mode */
        read_en = 1;
        rx = 1;
        #10
        if (data_out != 0 || data_out === 8'bz)
            $fatal(1, "data idle failed - %d", data_out);
        if (rdy == 1 || rdy === 1'bz)
            $fatal(1, "ready idle failed - %d", rdy);

        /* send the start bit */
        rx = 0;
        #2
        if (rdy == 1 || rdy === 1'bz)
            $fatal(1, "ready start failed - %d", rdy);

        data = 8'b00011100;
        /* start writing */
        for (i = 0; i<8; i++) begin
            rx = data[i];

            /* check ready bit */
            if (rdy == 1 || rdy === 1'bz)
                $fatal(1, "ready start failed(2) - %d", rdy);
            #2;
        end

        /* read data */
        if (data != data_out)
            $fatal(1, "write data failed(5) - %b - %b", data_out, data);

        /* final data_out check */
        if (rdy == 0 || rdy === 1'bz)
            $fatal(1, "ready finish failed(2) - %d", rdy);
        if (data != data_out)
            $fatal(1, "write data failed(2) - %b - %b", data_out, data);

        /* send the start bit again */
        rx = 0;
        #2
        if (rdy == 1 || rdy === 1'bz)
            $fatal(1, "ready start failed(4) - %d", data_out);

        $finish;
    end

endmodule