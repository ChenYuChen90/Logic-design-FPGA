`timescale 1ns/100ps

module lab2_1 (
    input clk,
    input rst,
    output reg [5:0] out,
    output reg [5:0] cnt
    );

    parameter sequence_a = 1'b0, sequence_b = 1'b1;
    reg [1:0] state, next_state;
    reg [5:0] out_next;
    wire [5:0] cnt_next;
    assign cnt_next = (cnt == 6'b111111) ? 0 : cnt + 1'b1;

    always @(posedge clk or posedge rst) begin
        cnt <= 0;
        if(rst)begin
            state <= sequence_a;
            cnt <= 1;
            out <= 0;
        end else begin
            state <= next_state;
            cnt <= cnt_next;
            out <= out_next;
        end
    end

    always @(*) begin
        case (state)
            sequence_a:
                if(out == 63)begin
                    next_state = sequence_b;
                    out_next = 62;
                end else begin
                    next_state = sequence_a;
                    out_next = (out <= cnt) ? out + cnt : out - cnt;
                end
            sequence_b:
                if(out == 0)begin
                    next_state = sequence_a;
                    out_next = 1;
                    cnt = 1;
                end else begin
                    next_state = sequence_b;
                    out_next = out - 2 ** (cnt - 58);
                end
        endcase
    end
endmodule