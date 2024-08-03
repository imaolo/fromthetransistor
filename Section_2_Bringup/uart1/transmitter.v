module reciever(
    input           rx,     /* serial in */
    input           clk,    /* clk signal */
    output reg      rdy,   /* ready for read */  
    output reg[7:0] data   /* data out */
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
    reg      state    = s_IDLE;
    integer  read_cnt = 0;

    /* state machine */
    always @(posedge clk) begin
        case (state)
            s_IDLE: begin
                if (rx == 0) begin
                    state <= s_READ;
                    read_cnt <= 0;
                end
            end
            s_READ: begin
                if (read_cnt < 8) begin
                    rdy <= 0;
                    data <= {data[6:0], rx};
                    read_cnt++;
                end
                if (read_cnt >= 8) begin 
                    rdy <= 1;
                    state <= s_IDLE;
                end;
            end
        endcase
    end

endmodule