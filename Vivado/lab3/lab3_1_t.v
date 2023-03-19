`timescale 1ns/100ps

module lab3_1_t;
    reg clk, rst, en, speed;
    wire [15:0] led;

    lab3_1 test(
        .clk(clk),
        .rst(rst),
        .en(en),
        .speed(speed),
        .led(led)
        );
    always #5 clk = ~clk;
    initial begin
        clk = 0; en = 0; speed = 0; rst = 0;
        #5 rst = 1;
        #5 rst = 0;
        #5 en = 1;
        #100000 $finish;
    end
endmodule