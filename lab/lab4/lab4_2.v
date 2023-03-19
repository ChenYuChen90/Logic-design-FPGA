module clk_times #(parameter max = 100000000) (
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

module lab4_2(
    input clk,
    input rst,
    input en,
    input input_number,
    input enter,
    input count_down,
    output reg [3:0] DIGIT,
    output reg [6:0] DISPLAY,
    output reg led0
    );

    wire clk_16, clk_01, clk_change;
    // for light
    reg [3:0] value, BCD0, BCD1, BCD2, BCD3;
    reg [3:0] next_BCD0, next_BCD1, next_BCD2, next_BCD3;
    reg [3:0] mem0, mem1, mem2, mem3;
    reg [3:0] next_mem0, next_mem1, next_mem2, next_mem3;
    // for button
    wire de_rst, de_enter, de_dir, de_inputnum;
    wire pulse_rst, pulse_enter, pulse_dir, pulse_inputnum;
    // for state
    reg state, next_state;              // start or pause
    parameter pause = 1'b0, count = 1'b1;
    reg [1:0] machine_state, next_machine;         // dir_setting, num_setting, counting
    parameter dir_setting = 2'b00, num_setting = 2'b01, counting = 2'b10, clear = 2'b11;
    reg counting_state, next_counting;              // counting dir state
    parameter counting_up = 1'b0, counting_dowm = 1'b1;
    reg [2:0] entertimes, next_entertimes;

    debounce debounce_rst( .pb(rst), .clk(clk), .pb_debounced(de_rst));
    debounce debounce_enter( .pb(enter), .clk(clk), .pb_debounced(de_enter));
    debounce debounce_dir( .pb(count_down), .clk(clk), .pb_debounced(de_dir));
    debounce debounce_inputnum( .pb(input_number), .clk(clk), .pb_debounced(de_inputnum));

    onepulse onpulse_rst( .pb_debounced(de_rst), .clk(clk), .pb_1pulse(pulse_rst));
    onepulse onpulse_enter( .pb_debounced(de_enter), .clk(clk), .pb_1pulse(pulse_enter));
    onepulse onpulse_dir( .pb_debounced(de_dir), .clk(clk), .pb_1pulse(pulse_dir));
    onepulse onpulse_inputnum( .pb_debounced(de_inputnum), .clk(clk), .pb_1pulse(pulse_inputnum));

    clock_diveder #(16) clk_div16 (        // Light refersh
        .clk(clk),
        .clk_div(clk_16)
    );
    clk_times #(10000000) clk_01second (        // counting
        .clk(clk),
        .clk_second(clk_01)
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
            4'd10: DISPLAY = 7'b011_1111;   // setting
        endcase
    end

    // state change (dir setting, num setting, count) (start pause) (counting up, down)
    always @(posedge clk or posedge pulse_rst) begin
        if (pulse_rst == 1) begin
            state <= pause;
            machine_state <= dir_setting;
            counting_state <= counting_up;
            entertimes <= 3'b000;
            led0 <= 0;
            mem0 <= 4'd0;
            mem1 <= 4'd0;
            mem2 <= 4'd0;
            mem3 <= 4'd0;
        end else begin
            state <= next_state;
            machine_state <= next_machine;
            counting_state <= next_counting;
            entertimes <= next_entertimes;
            if (counting_state == counting_dowm) led0 = 1; 
            else led0 = 0;
            mem0 <= next_mem0;
            mem1 <= next_mem1;
            mem2 <= next_mem2;
            mem3 <= next_mem3;
        end
    end
    // light 
    always @(posedge clk_change or posedge pulse_rst) begin
        if (pulse_rst == 1) begin
            BCD0 <= 4'd10;
            BCD1 <= 4'd10;
            BCD2 <= 4'd10;
            BCD3 <= 4'd10;
        end else begin
            BCD0 <= next_BCD0;
            BCD1 <= next_BCD1;
            BCD2 <= next_BCD2;
            BCD3 <= next_BCD3;
        end
    end
    assign clk_change = (machine_state == counting) ? clk_01 : clk;
    // start pause change
    always @(*) begin
        if(en == 1)begin
            next_state = count;
        end else begin
            next_state = pause;
        end
    end

    // for counting dir setting (counting_state, next_counting)
    always @(*) begin
        if(machine_state == dir_setting)begin
            if(pulse_dir == 1)begin
                if(counting_state == counting_up) next_counting = counting_dowm;
                else next_counting = counting_up;
            end else begin
                next_counting = counting_state;
            end
        end
    end

    // for num memery
    always @(*) begin
        if(machine_state == num_setting)begin
            next_mem0 = BCD0;
            next_mem1 = BCD1;
            next_mem2 = BCD2;
            next_mem3 = BCD3;
        end else begin
            next_mem0 = mem0;
            next_mem1 = mem1;
            next_mem2 = mem2;
            next_mem3 = mem3;
        end
    end


    // for machine state (need next_machine, next_BCD0,1,2,3, entertimes)
    always @(*) begin
        next_entertimes = entertimes;
        case (machine_state)
            dir_setting : begin                
                next_BCD0 = 4'd10;
                next_BCD1 = 4'd10;
                next_BCD2 = 4'd10;
                next_BCD3 = 4'd10;
                if (pulse_enter == 1) begin
                    next_BCD0 = 4'd0;
                    next_BCD1 = 4'd0;
                    next_BCD2 = 4'd0;
                    next_BCD3 = 4'd0;
                    next_machine = num_setting;
                    next_entertimes = 3'b000;
                end else begin
                    next_machine = dir_setting;
                end
            end
            num_setting : begin
                next_BCD0 = BCD0;
                next_BCD1 = BCD1;
                next_BCD2 = BCD2;
                next_BCD3 = BCD3;
                next_machine = num_setting;
                if (entertimes == 3'b000) begin              // for BCD3
                    if (pulse_enter == 1) begin
                        next_entertimes = entertimes + 1'b1;
                    end else begin
                        next_entertimes = entertimes;
                    end
                    if (pulse_inputnum == 1) begin
                        if(BCD3 == 4'd1) next_BCD3 = 4'd0;
                        else next_BCD3 = BCD3 + 4'd1;
                    end else begin
                        next_BCD3 = BCD3;
                    end
                end else if (entertimes == 3'b001)begin      // for BCD2
                    if (pulse_enter == 1) begin
                        next_entertimes = entertimes + 1'b1;
                    end else begin
                        if (pulse_inputnum == 1) begin
                            if(BCD2 == 4'd5) next_BCD2 = 4'd0;
                            else next_BCD2 = BCD2 + 4'd1;
                        end else begin
                            next_BCD2 = BCD2;
                        end
                    end
                end else if (entertimes == 3'b010) begin     // for BCD1
                    if (pulse_enter == 1) begin
                        next_entertimes = entertimes + 1'b1;
                    end else begin
                        if (pulse_inputnum == 1) begin
                            if(BCD1 == 4'd9) next_BCD1 = 4'd0;
                            else next_BCD1 = BCD1 + 4'd1;
                        end else begin
                            next_BCD1 = BCD1;
                        end
                    end
                end else if (entertimes == 3'b011) begin     // for BCD0
                    if (pulse_enter == 1) begin
                        if (counting_state == counting_up) begin
                            next_BCD0 = 4'd0;
                            next_BCD1 = 4'd0;
                            next_BCD2 = 4'd0;
                            next_BCD3 = 4'd0;
                        end else begin
                            next_BCD0 = mem0;
                            next_BCD1 = mem1;
                            next_BCD2 = mem2;
                            next_BCD3 = mem3;
                        end
                        next_machine = counting;
                    end else begin
                        if (pulse_inputnum == 1) begin
                            if(BCD0 == 4'd9) next_BCD0 = 4'd0;
                            else next_BCD0 = BCD0 + 4'd1;
                        end else begin
                            next_BCD0 = BCD0;
                        end
                        next_machine = num_setting;
                    end
                end
            end
            counting : begin
                next_BCD0 = BCD0;
                next_BCD1 = BCD1;
                next_BCD2 = BCD2;
                next_BCD3 = BCD3;
                if (state == count) begin
                    if (counting_state == counting_up) begin
                        if(BCD0 == mem0 && BCD1 == mem1 && BCD2 == mem2 && BCD3 == mem3) begin
                            next_BCD0 = BCD0;
                            next_BCD1 = BCD1;
                            next_BCD2 = BCD2;
                            next_BCD3 = BCD3;
                        end else begin
                            if (BCD0 == 4'd9) begin
                                if (BCD1 == 4'd9) begin
                                    if (BCD2 == 4'd5) begin
                                        if (BCD3 == 4'd1) begin
                                            next_BCD0 = 4'd0;
                                            next_BCD1 = 4'd0;
                                            next_BCD2 = 4'd0;
                                            next_BCD3 = 4'd2;
                                        end else begin
                                            next_BCD0 = 4'd0;
                                            next_BCD1 = 4'd0;
                                            next_BCD2 = 4'd0;
                                            next_BCD3 = 4'd1;
                                        end
                                    end else begin  //BCD2 != 5
                                        next_BCD0 = 4'd0;
                                        next_BCD1 = 4'd0;
                                        next_BCD2 = BCD2 + 4'd1;
                                        next_BCD3 = BCD3;
                                    end
                                end else begin  //BCD1 != 9
                                    next_BCD0 = 4'd0;
                                    next_BCD1 = BCD1 + 4'd1;
                                    next_BCD2 = BCD2;
                                    next_BCD3 = BCD3;
                                end
                            end else begin  //BCD0 != 9
                                next_BCD0 = BCD0 + 4'd1;
                                next_BCD1 = BCD1;
                                next_BCD2 = BCD2;
                                next_BCD3 = BCD3;
                            end
                        end
                    end else begin
                        if(BCD0 == 4'd0 && BCD1 == 4'd0 && BCD2 == 4'd0 && BCD3 == 4'd0) begin
                            next_BCD0 = BCD0;
                            next_BCD1 = BCD1;
                            next_BCD2 = BCD2;
                            next_BCD3 = BCD3;
                        end else begin
                            if (BCD0 == 4'd0) begin
                                if (BCD1 == 4'd0) begin
                                    if (BCD2 == 4'd0) begin
                                        if (BCD3 == 4'd0) begin
                                            next_BCD0 = BCD0;
                                            next_BCD1 = BCD1;
                                            next_BCD2 = BCD2;
                                            next_BCD3 = BCD3;
                                        end else begin  //BCD3 != 0
                                            next_BCD0 = BCD0;
                                            next_BCD1 = BCD1;
                                            next_BCD2 = 4'd6;
                                            next_BCD3 = BCD3 - 4'd1;
                                        end
                                    end else begin  //BCD2 != 0
                                        next_BCD0 = 4'd9;
                                        next_BCD1 = 4'd9;
                                        next_BCD2 = BCD2 - 4'd1;
                                        next_BCD3 = BCD3;
                                    end
                                end else begin  //BCD1 != 0
                                    next_BCD0 = 4'd9;
                                    next_BCD1 = BCD1 - 4'd1;
                                    next_BCD2 = BCD2;
                                    next_BCD3 = BCD3;
                                end
                            end else begin  //BCD0 != 0
                                next_BCD0 = BCD0 - 4'd1;
                                next_BCD1 = BCD1;
                                next_BCD2 = BCD2;
                                next_BCD3 = BCD3;
                            end
                        end
                    end
                end else begin
                    next_BCD0 = BCD0;
                    next_BCD1 = BCD1;
                    next_BCD2 = BCD2;
                    next_BCD3 = BCD3;
                end
                next_machine = counting;
            end
        endcase
    end
endmodule
