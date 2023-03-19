`timescale 10 ns / 100 ps

module servo (
    input clk,  //base on 100MHZ clock
    input [5:0] pos, //left(10), right(01), neutral(00,11)
    output control
    );
    /* SG90 9g micro servo, Tower Pro (sg90servo.pdf)
     1.5 ms pulse for middle, 2 ms for right, 1 ms for left duty cycle
    ----
    |   |------------------------|
    <---------------------------->
             20ms (50HZ)
    */
    
    localparam MS_20 = 24'd2000000; //20ms from 100MHZ clock
    
    localparam ALLRIGHT = 24'd240000; // 2ms all the way right
    localparam MIDDLE = 24'd140000; // 1.5 ms  middle
    localparam ALLLEFT = 24'd40000; //1 ms all the way left

    localparam target1 = 24'd200000;
    localparam target2 = 24'd160000;
    localparam target3 = 24'd120000;
    localparam target4 = 24'd80000;

    reg [23:0] count;
    reg pulse;

    initial count = 0; //for simulation

    assign control = pulse; //output

    always@(posedge clk) 
            count <= (count == MS_20) ? 0 : count + 1'b1; /* 20 ms period */

    always@(*) 	
        case(pos)
            6'b000_001: pulse = (count <= ALLRIGHT); //right all the way
            6'b000_010: pulse = (count <= target1);
            6'b000_100: pulse = (count <= target2);
            6'b001_000: pulse = (count <= target3);
            6'b010_000: pulse = (count <= target4);
            6'b100_000: pulse = (count <= ALLLEFT); //left all the way
            default: pulse = (count <= MIDDLE);  //center 
        endcase

endmodule
