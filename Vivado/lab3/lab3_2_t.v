`timescale 1ns/100ps

module lab3_2_t;
    reg clk, rst, en, dir;
    wire [15:0] led;

    lab3_2 test(
        .clk(clk),
        .rst(rst),
        .en(en),
        .dir(dir),
        .led(led)
        );
    always #5 clk = ~clk;
    initial begin
        clk = 0; en = 0; dir = 0; rst = 0;
        #5 rst = 1;
        #5 rst = 0;
        #100 en = 1;
        #10000 $finish;
    end
endmodule