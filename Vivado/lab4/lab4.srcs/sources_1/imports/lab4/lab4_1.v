module clk_times #(parameter max = 1000000000) (
    input clk,
    output clk_second
    );
    reg [26:0] cnt;
    reg clock = 0;

    always @(posedge clk) begin
        if (cnt == max / 2 - 1) begin
           cnt <= 0;
           clock <= ~clock; 
        end else begin
            cnt <= cnt + 1;
        end
    end

    assign clk_second = clock;
endmodule

module lab4_1(
    input clk,
    input rst,
    input en,
    input dir,
    input speed_up,
    input speed_down,
    output reg [3:0] DIGIT,
    output reg [6:0] DISPLAY,
    output reg max,
    output reg min
    );

    wire clk_16, clk_26, clk_27, clk_28;
    // for light
    reg [3:0] value, BCD0, BCD1, BCD2, BCD3;
    reg [3:0] next_BCD0, next_BCD1, next_BCD2, next_BCD3;
    // for button
    wire de_rst, de_en, de_dir, de_speedup, de_speeddown;
    wire pulse_rst, pulse_en, pulse_speedup, pulse_speeddown;
    // for state and count
    reg state, next_state;
    reg [1:0] speed_state, next_speed;
    parameter pause = 1'b0, count = 1'b1;
    parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10;

    debounce debounce_rst( .pb(rst), .clk(clk), .pb_debounced(de_rst));
    debounce debounce_en( .pb(en), .clk(clk), .pb_debounced(de_en));
    debounce debounce_dir( .pb(dir), .clk(clk), .pb_debounced(de_dir));
    debounce debounce_speedup( .pb(speed_up), .clk(clk), .pb_debounced(de_speedup));
    debounce debounce_speeddown( .pb(speed_down), .clk(clk), .pb_debounced(de_speeddown));

    onepulse onpulse_rst( .pb_debounced(de_rst), .clk(clk), .pb_1pulse(pulse_rst));
    onepulse onpulse_en( .pb_debounced(de_en), .clk(clk), .pb_1pulse(pulse_en));
    onepulse onpulse_speedup( .pb_debounced(de_speedup), .clk(clk), .pb_1pulse(pulse_speedup));
    onepulse onpulse_speeddown( .pb_debounced(de_speeddown), .clk(clk), .pb_1pulse(pulse_speeddown));

    clock_diveder #(16) clk_div16 (        // Light refersh
        .clk(clk),
        .clk_div(clk_16)
    );
    clk_times #(50000000) clk_div26 (        // speed = 0
        .clk(clk),
        .clk_second(clk_26)
    );
    clk_times #(100000000) clk_div27 (        // speed = 1
        .clk(clk),
        .clk_second(clk_27)
    );
    clk_times #(200000000) clk_div28 (        // speed = 2
        .clk(clk),
        .clk_second(clk_28)
    );
    always @(posedge clk_16) begin         // Light control
        case (DIGIT)
            4'b1110: begin
                value <= BCD1;
                DIGIT <= 4'b1101;
            end
            4'b1101: begin
                value <= BCD2;
                DIGIT <= 4'b1011;
            end
            4'b1011: begin
                value <= BCD3;
                DIGIT <= 4'b0111;
            end
            4'b0111: begin
                value <= BCD0;
                DIGIT <= 4'b1110;
            end
            default: begin
                value <= BCD0;
                DIGIT <= 4'b1110;
            end
        endcase
    end
    always @(*) begin                      // Light control
        case (value)
            4'd0 : DISPLAY = 7'b100_0000;
            4'd1 : DISPLAY = 7'b111_1001;
            4'd2 : DISPLAY = 7'b010_0100;
            4'd3 : DISPLAY = 7'b011_0000;
            4'd4 : DISPLAY = 7'b001_1001;
            4'd5 : DISPLAY = 7'b001_0010;
            4'd6 : DISPLAY = 7'b000_0010;
            4'd7 : DISPLAY = 7'b111_1000;
            4'd8 : DISPLAY = 7'b000_0000;
            4'd9 : DISPLAY = 7'b001_0000;
            4'd10: DISPLAY = 7'b101_1100;   //up arrow
            4'd11: DISPLAY = 7'b110_0011;   //down arrow
        endcase
    end
    //for counter
    always @(posedge clk_26 or posedge pulse_rst) begin
        if (pulse_rst == 1) begin
            BCD0 <= 4'd0;
            BCD1 <= 4'd0;
        end else begin
            case (speed_state)
                S0 : begin
                    if(clk_28 == 1 && clk_27 == 1) begin
                        BCD0 <= next_BCD0;
                        BCD1 <= next_BCD1;
                    end else begin
                        BCD0 <= BCD0;
                        BCD1 <= BCD1;
                    end
                end
                S1 : begin
                    if(clk_27 == 1) begin
                        BCD0 <= next_BCD0;
                        BCD1 <= next_BCD1;
                    end else begin
                        BCD0 <= BCD0;
                        BCD1 <= BCD1;
                    end
                end
                S2 : begin
                    if(clk_26 == 1) begin
                        BCD0 <= next_BCD0;
                        BCD1 <= next_BCD1;
                    end else begin
                        BCD0 <= BCD0;
                        BCD1 <= BCD1;
                    end
                end
            endcase
        end
    end
    //for state display (count up or down)
    always @(posedge clk or posedge pulse_rst) begin
        if (pulse_rst == 1) begin
            BCD2 <= 4'd10;
            BCD3 <= 4'd0;
            state <= pause;
            speed_state <= S0;
            max <= 0;
            min <= 0;
        end else begin
            BCD2 <= next_BCD2;
            BCD3 <= next_BCD3;
            state <= next_state;
            speed_state <= next_speed;
            if(BCD0 == 4'd9 && BCD1 == 4'd9) max = 1;
            else max = 0;
            if(BCD0 == 4'd0 && BCD1 == 4'd0) min = 1;
            else min = 0;
        end
    end

    // for state (need : next_state, next_BCD2) (start or pause)
    always @(*) begin
        if (pulse_en == 1) begin
            if (state == pause) next_state = count;
            else next_state = pause;
        end else begin
            next_state = state;
        end
    end
    always @(*) begin
        if (de_dir == 1 & state != pause) begin
            next_BCD2 = 4'd11;
        end else if (de_dir == 0 & state != pause) begin
            next_BCD2 = 4'd10;
        end
    end
    //for counter (need : next_BCD0, next_BCD1)
    always @(*) begin
        if(state == pause)begin
            next_BCD0 = BCD0;
            next_BCD1 = BCD1;
        end else begin 
            if(BCD2 == 4'd10) begin
                if(BCD0 == 4'd9)begin
                    if(BCD1 == 4'd9)begin
                        next_BCD0 = BCD0;
                        next_BCD1 = BCD1;
                    end else begin
                        next_BCD0 = 4'd0;
                        next_BCD1 = BCD1 + 4'd1;
                    end
                end else begin
                    next_BCD0 = BCD0 + 4'd1;
                    next_BCD1 = BCD1;
                end
            end else if(BCD2 == 4'd11) begin
                if(BCD0 == 4'd0)begin
                    if(BCD1 == 4'd0)begin
                        next_BCD0 = BCD0;
                        next_BCD1 = BCD1;
                    end else begin
                        next_BCD0 = 4'd9;
                        next_BCD1 = BCD1 - 4'd1;
                    end
                end else begin
                    next_BCD0 = BCD0 - 4'd1;
                    next_BCD1 = BCD1;
                end
            end
        end
    end

    //for speed_state change (need : next_speed, next_BCD3)
    always @(*) begin
        case (speed_state)
            S0 : begin
                if(pulse_speedup) begin
                    next_speed = S1;
                    next_BCD3 = 4'd1;
                end else begin
                    next_speed = S0;
                    next_BCD3 = 4'd0;
                end
            end
            S1 : begin
                if (pulse_speedup == 1 && pulse_speeddown == 0) begin
                    next_speed = S2;
                    next_BCD3 = 4'd2;
                end else if(pulse_speeddown == 1 && pulse_speedup == 0) begin
                    next_speed = S0;
                    next_BCD3 = 4'd0;
                end else begin
                    next_speed = S1;
                    next_BCD3 = 4'd1;
                end
            end
            S2 : begin
                if(pulse_speeddown == 1) begin
                    next_speed = S1;
                    next_BCD3 = 4'd1;
                end else begin
                    next_speed = S2;
                    next_BCD3 = 4'd2;
                end
            end
        endcase
    end
endmodule
