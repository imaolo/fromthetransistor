module transmitter(
    input[7:0]  data,      /* read buffer */
    input       clk,       /* clk signal */
    input       write_en,  /* start buffer transmission */
    output reg  rdy,       /* ready for write */
    output reg  tx         /* transmit wire */
);
    /* states */
    parameter s_IDLE  = 2'b00;
    parameter s_START = 2'b01;
    parameter s_WRITE = 2'b10;
    parameter s_STOP  = 2'b11;

    /* initialize output signals */
    initial begin
        rdy = 1;
        tx = 1;
    end

    /* internal registers */
    reg[2:0]  write_idx = 0;
    reg[1:0]  state     = s_IDLE;

    always @(posedge clk) begin
        case (state)
            s_IDLE: begin
                tx <= 1;
                rdy <= 1;
                if (write_en)
                    state <= s_START;
            end
            s_START: begin
                rdy <= 0;
                tx <= 0;
                write_idx <= 0;
                state <= s_WRITE;
            end
            s_WRITE: begin
                tx <= data[write_idx];
                if (write_idx == 7)
                    state <= s_STOP;
                else
                    write_idx <= write_idx + 1;
            end
            s_STOP: begin
                tx <= 1;
                write_idx <= 0;
                state <= s_IDLE;
            end    
        endcase
    end

endmodule
