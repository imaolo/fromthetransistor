`include "transmitter.v"

module reciever_tb();

    /* instantiate the transmitter */
    reg rx = 1;
    reg clk = 0;
    wire rdy;
    wire[7:0] out_data;
    reciever t (
        .rx(rx),
        .clk(clk),
        .rdy(rdy),
        .data(out_data)
    );

    /* start the clock */
    initial forever #1 clk = ~clk;

    /* start test */
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