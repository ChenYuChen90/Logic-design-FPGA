`timescale 1ns/100ps

module lab1_2 (a, b, aluctr, d);
    input [3:0] a;
    input [1:0] b;
    input [1:0] aluctr;
    output reg [3:0] d;
    wire [3:0] shi;

    lab1_1 shifter(.a(a), .b(b), .dir(aluctr[0]), .d(shi));
    
    always @(*) begin
        if(aluctr == 2'b00) begin
            d = shi;
        end else if (aluctr == 2'b01) begin
            d = shi;
        end else if (aluctr == 2'b10) begin
            d = a + b;
        end else begin
            d = a - b;
        end
    end
endmodule