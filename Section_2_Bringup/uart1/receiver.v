module receiver(
    input           x,    /* serial in */
    input           clk,  /* clk signal */
    input           en,   /* enabled read */
    output reg      rdy,  /* ready for read */  
    output reg[7:0] data  /* data out */
);

    /* states */
    parameter s_IDLE  = 1'b0;
    parameter s_READ  = 1'b1;

    /* initialize output signals */
    initial begin
        rdy = 0;
        data = 8'b0;
    end

    /* internal registers*/
    reg     state      = s_IDLE;
    integer read_count = 0;

    /* state machine */
    always @(posedge clk) begin
        if (!en)
            state <= s_IDLE;
        else begin
            case (state)
                s_IDLE: begin
                    rdy <= 0;
                    if (!x) begin
                        state <= s_READ;
                    end
                end
                s_READ: begin
                    if (read_count < 8) begin
                        data <= {x, data[7:1]};
                        read_count++;
                    end
                    if (read_count >= 8) begin
                        state <= s_IDLE;
                        rdy <= 1;
                        read_count = 0;
                    end
                end
            endcase
        end
    end

endmodule