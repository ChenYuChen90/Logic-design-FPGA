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

module lab3_1(
    input clk,
    input rst,
    input en,
    input speed,
    output reg [15:0] led
    );
    wire clk_24, clk_27;
    clock_divider #(25) c_25 (
        .clk(clk),
        .clk_div(clk_24)
    );
    clock_divider #(28) c_27 (
        .clk(clk),
        .clk_div(clk_27)
    );
    reg [15:0] clk_next_24, clk_next_27;
    always @(posedge rst or posedge clk) begin
        if(rst == 1) begin
            led <= 16'b1111111111111111;
        end else begin
            if (en == 1) begin
                if (speed == 1) begin
                    led <= clk_next_27;
                end else begin
                    led <= clk_next_24;
                end
            end else begin
                led <= led;
            end
        end
    end

    always @(*) begin
        if(clk_24 == 1) clk_next_24 = 16'b1111111111111111;
        else clk_next_24 = 16'b0000000000000000;
    end
    always @(*) begin
        if(clk_27 == 1) clk_next_27 = 16'b1111111111111111;
        else clk_next_27 = 16'b0000000000000000;
    end
endmodule
