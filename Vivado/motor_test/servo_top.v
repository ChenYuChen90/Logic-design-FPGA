`timescale 10 ns / 100 ps

module servo_top (
    input clk,
    input [5:0] SW,
    output [5:0] LED,
    output JA
    );

    assign LED = SW;

    servo servo_main(.clk(clk),.pos(SW), .control(JA));

endmodule
