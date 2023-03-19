`timescale 1ns/100ps

module lab2_1_t;
    reg clk, rst;
    wire [5:0] out;

    lab2_1 counter(
        .out(out),
        .clk(clk),
        .rst(rst),
        .cnt(cnt)
        );
    always #5 clk = ~clk;
    initial begin
        clk = 0;
        #5 rst = 1;
        #10 rst = 0;
        #30 rst = 1;
        #35 rst = 0;
        #1000 $finish;
    end
endmodule