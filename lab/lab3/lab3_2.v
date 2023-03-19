module clock_divider #(parameter n = 25) (
    input clk,
    output clk_div
);
    reg[n-1:0] num = 0;
    wire [n-1:0] next_num;

    always @(posedge clk) begin
        num = next_num;
    end

    assign next_num = num + 1;
    assign clk_div = num[n-1];

endmodule

module lab3_2(
    input clk,
    input rst,
    input en,
    input dir,
    output reg [15:0] led
    );
    wire clk_25, clk_26;
    clock_divider #(25) c_25 (
        .clk(clk),
        .clk_div(clk_25)
    );
    clock_divider #(26) c_26 (
        .clk(clk),
        .clk_div(clk_26)
    );
    parameter [1:0] 
    all_on = 2'b00,
    flashing = 2'b01,
    shifting = 2'b10,
    expanding = 2'b11;
    reg [1:0] state, next_state;
    reg [47:0] led_next, led_state;
    integer cycle = 0, cycle_next;
    always @(posedge clk_25 or posedge rst) begin
        if (rst) begin
            state <= all_on;
            led <= 16'b1111111111111111;
            cycle <= cycle_next;
            led_state <= led_next;
        end else begin
            if (en == 1) begin
                state <= next_state;
                led <= led_state[31:16];
                cycle <= cycle_next;
                led_state <= led_next;
            end else begin
                state <= state;
                led <= led;
                cycle <= cycle;
                led_state <= led_state;
            end
        end       
    end

    always @(*) begin
        cycle_next = 0;
        case (state)
            all_on:begin
                led_next = {16'b0000000000000000, 16'b1111111111111111, 16'b0000000000000000};
                next_state = flashing;
            end
            flashing:begin
                if (cycle == 6) begin
                    next_state = shifting;
                    led_next[31:16] = 16'b1010101010101010;
                    cycle_next = 0;
                end else begin
                    if(clk_26 == 1) begin
                        cycle_next = cycle + 1;
                        next_state = flashing;
                        led_next[31:16] = 16'b1111111111111111;
                    end else begin
                        cycle_next = cycle;
                        next_state = flashing;
                        led_next[31:16] = 16'b0000000000000000;
                    end
                end
            end
            shifting:begin
                if (led_state[31:16] != 16'b0000000000000000) begin
                    if(dir == 0) begin 
                        led_next = led_state >> 1;
                        next_state = shifting;
                    end else begin
                        led_next = led_state << 1;
                        next_state = shifting;
                    end
                end else begin
                    led_next = {16'b0000000000000000, 16'b0000000110000000, 16'b0000000000000000};
                    next_state = expanding;
                end
            end
            expanding:begin
                if (led_state[31:16] != 16'b1111111111111111) begin
                    if (dir == 0) begin
                        led_next[31:16] = {led_state[30:24], 2'b11, led_state[23:17]};
                        next_state = expanding;
                    end else begin
                        led_next[31:16] = {1'b0, led_state[31:25], led_state[22:16], 1'b0};
                        next_state = expanding;
                    end
                end else begin
                    led_next[31:16] = 16'b0000000000000000;
                    next_state = flashing;
                end
            end
        endcase
    end
endmodule
