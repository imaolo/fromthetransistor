module uart_rx(
    input       rx,     /* serial in */
    input       clk,    /* clk signal */
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

module uart_tx(
    input[7:0]  data,  /* read buffer */
    input       clk,   /* clk signal */
    input       write_en, /* start buffer transmission */
    output reg  rdy,   /* ready for write */
    output reg  tx     /* transmit wire */
);
    /* states */
    parameter s_IDLE  = 2'b00;
    parameter s_START = 2'b01;
    parameter s_WRITE = 2'b10;
    parameter s_STOP  = 2'b11;

    /* initialize output signals */
    initial begin
        rdy = 1;
        tx <= 1;
    end

    /* internal registers */
    reg[7:0]  write_cnt = 0;
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
                write_cnt <= 0;
                state <= s_WRITE;
            end
            s_WRITE: begin
                if (write_cnt < 8) begin
                    tx <= data[write_cnt];
                    write_cnt++;
                end
                if (write_cnt >=8)
                    state <= s_STOP;
            end
            s_STOP: begin
                tx <= 1;
                write_cnt <= 0;
                state <= s_IDLE;
            end    
        endcase
    end

endmodule