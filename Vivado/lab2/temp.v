`timescale 1ns/100ps

module lab2_2(
    input clk,
    input rst,
    input carA,
    input carB,
    output reg [2:0] lightA,
    output reg [2:0] lightB
    );

    reg [1:0] state, next_state;
    parameter s0 = 2'b00;       // a:green   b:red
    parameter s1 = 2'b01;       // a:yellow  b:red
    parameter s2 = 2'b10;       // a:red     b:green
    parameter s3 = 2'b11;       // a:red     b:yellow
    parameter green = 3'b001, yellow = 3'b010, red = 3'b100;
    reg [5:0] cycle;
    always @(posedge clk) begin
        case(state)
            s0:begin
                if({carA,carB} == 2'b00 || {carA,carB} == 2'b10 || {carA,carB} == 2'b11) begin
                    lightA = green;
                    lightB = red;
                    next_state = s0;
                end else if({carA, carB} == 2'b01) begin // need consider cycle time
                    if(cycle >= 1) begin
                        lightA = yellow;
                        lightB = red;
                        next_state = s1;
                    end else begin
                        lightA = green;
                        lightB = red;
                        next_state = s0;
                    end
                end
            end
            s1:begin
                lightA = red;
                lightB = green;
                next_state = s2;
                cycle = 0;
            end
            s2:begin
                if({carA,carB} == 2'b00 || {carA,carB} == 2'b01 || {carA,carB} == 2'b11) begin
                    lightA = red;
                    lightB = green;
                    next_state = s2;
                end else if (({carA, carB} == 2'b10) && (cycle > 2)) begin // need consider cycle time
                    lightA = red;
                    lightB = yellow;
                    next_state = s3;
                end else begin
                    lightA = red;
                    lightB = green;
                    next_state = s2;
                end
            end
            s3:begin
                lightA = green;
                lightB = red;
                next_state = s0;
                cycle = 0;
            end
        endcase
    end

    always @(posedge clk or posedge rst) begin
        if(rst)begin
            state <= s0;
            cycle <= 0;
        end else begin
            state <= next_state;
            cycle <= cycle + 1;
        end
    end
endmodule