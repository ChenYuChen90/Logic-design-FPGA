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

module clock_diveder #(parameter n = 25) (
    input clk,
    output clk_div
    );
    reg [n-1:0] num = 0;
    wire [n-1:0] next_num;

    always @(posedge clk) begin
        num = next_num;
    end

    assign next_num = num + 1;
    assign clk_div = num[n-1];

endmodule

module lab5 (
    input clk,
    input rst,
    input BTNL,
    input BTNR,
    input BTNU,
    input BTND,
    input BTNC,
    output reg [15:0] LED,
    output reg [3:0] DIGIT,
    output reg [6:0] DISPLAY
    );

    // FSM light control
    wire clk_machine, clk_05hz, clk_led, clk_BCD, clk_state, clk_tool;
    // for light
    reg [3:0] value, BCD0, BCD1, BCD2, BCD3;
    reg [3:0] next_BCD0, next_BCD1, next_BCD2, next_BCD3;
    // for led
    reg [15:0] next_LED;
    // for button
    wire de_BTNU, de_BTND, de_BTNL, de_BTNC, de_BTNR;
    wire pulse_rst, pulse_BTNU, pulse_BTND, pulse_BTNL, pulse_BTNC, pulse_BTNR;
    // for machine state
    reg [2:0] machine_state, next_machine;
    parameter RST = 3'b110, IDLE = 3'b000, TYPE = 3'b001, AMOUNT = 3'b010, PAYMENT = 3'b011, RELEASE = 3'b100, CHANGE = 3'b101;
    // for tool
    reg [5:0] price, next_price, money, next_money;
    reg [3:0] mem3, next_mem3, mem0, next_mem0;
    reg [2:0] cycle, next_cycle;
    reg [4:0] little, next_little;
    reg signed [6:0] change, next_change;
    reg [1:0] type, next_type;

    debounce debounce_BTNU( .pb(BTNU), .clk(clk_machine), .pb_debounced(de_BTNU));
    debounce debounce_BTND( .pb(BTND), .clk(clk_machine), .pb_debounced(de_BTND));
    debounce debounce_BTNL( .pb(BTNL), .clk(clk_machine), .pb_debounced(de_BTNL));
    debounce debounce_BTNC( .pb(BTNC), .clk(clk_machine), .pb_debounced(de_BTNC));
    debounce debounce_BTNR( .pb(BTNR), .clk(clk_machine), .pb_debounced(de_BTNR));

    onepulse onepulse_BTNU( .pb_debounced(de_BTNU), .clk(clk_machine), .pb_1pulse(pulse_BTNU));
    onepulse onepulse_BTND( .pb_debounced(de_BTND), .clk(clk_machine), .pb_1pulse(pulse_BTND));
    onepulse onepulse_BTNL( .pb_debounced(de_BTNL), .clk(clk_machine), .pb_1pulse(pulse_BTNL));
    onepulse onepulse_BTNC( .pb_debounced(de_BTNC), .clk(clk_machine), .pb_1pulse(pulse_BTNC));
    onepulse onepulse_BTNR( .pb_debounced(de_BTNR), .clk(clk_machine), .pb_1pulse(pulse_BTNR));

    clock_diveder #(16) clk_divmac( .clk(clk), .clk_div(clk_machine));
    clk_times #(100000000) clk_05( .clk(clk), .clk_second(clk_05hz));          // 0.5hz clk = 2s 一秒亮一秒暗

    always @(posedge clk_machine) begin         // Light control
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
            4'd10: DISPLAY = 7'b011_1111;   // setting -
            4'd11: DISPLAY = 7'b100_0110;   // C
            4'd12: DISPLAY = 7'b001_0010;   // S
            4'd13: DISPLAY = 7'b000_1000;   // A
            4'd14: DISPLAY = 7'b111_1111;   // black
        endcase
    end

    // machine state refersh    (need machine_state)
    always @(posedge clk_state or posedge rst) begin
        if (rst) begin
            machine_state <= RST;
        end else begin
            machine_state <= next_machine;
        end
    end
    assign clk_state = (machine_state == RELEASE) ? clk_05hz : clk_machine;
    // machine state change     (need next_machine)
    always @(*) begin
        case (machine_state)
            RST:begin
                if(rst == 0)begin
                    next_machine = IDLE;
                end else begin
                    next_machine = RST;
                end
            end
            IDLE:begin
                if(pulse_BTNL || pulse_BTNC || pulse_BTNR)begin
                    next_machine = TYPE;
                end else begin
                    next_machine = IDLE;
                end
            end
            TYPE:begin
                if(pulse_BTNU)begin
                    next_machine = AMOUNT;
                end else if(pulse_BTND)begin
                    next_machine = IDLE;
                end else begin
                    next_machine = TYPE;
                end
            end
            AMOUNT:begin
                if(pulse_BTNU)begin
                    next_machine = PAYMENT;
                end else if(pulse_BTND)begin
                    next_machine = IDLE;
                end else begin
                    next_machine = AMOUNT;
                end
            end
            PAYMENT:begin
                if(money >= price) begin
                    next_machine = RELEASE;
                end else if(pulse_BTND == 1) begin
                    next_machine = CHANGE;
                end else begin
                    next_machine = PAYMENT;
                end
            end
            RELEASE:begin
                if(cycle >= 3'd5) begin
                    next_machine = CHANGE;
                end else begin
                    next_machine = RELEASE;
                end
            end
            CHANGE:begin
                if (BCD0 + BCD1 == 0) begin
                    next_machine = IDLE;
                end else begin
                    next_machine = CHANGE;
                end
            end
        endcase
    end

    // BCD refersh      (need BCD0 - 3)
    always @(posedge clk_BCD or posedge rst) begin
        if (rst) begin          // 全暗
            BCD0 <= 4'd14;
            BCD1 <= 4'd14;
            BCD2 <= 4'd14;
            BCD3 <= 4'd14;
        end else begin
            BCD0 <= next_BCD0;
            BCD1 <= next_BCD1;
            BCD2 <= next_BCD2;
            BCD3 <= next_BCD3;
        end
    end
    assign clk_BCD = (machine_state == IDLE || machine_state == CHANGE || machine_state == RELEASE) ? clk_05hz : clk_machine;

    // BCD change in diff state     (need next_BCD0 - 3)
    always @(*) begin
        case (machine_state)
            RST:begin
                next_BCD0 = 4'd14;
                next_BCD1 = 4'd14;
                next_BCD2 = 4'd14;
                next_BCD3 = 4'd14;
            end
            IDLE:begin
                if (pulse_BTNL == 1) begin
                    next_BCD0 = 4'd5;       //5
                    next_BCD1 = 4'd0;       //0
                    next_BCD2 = 4'd14;      //black
                    next_BCD3 = 4'd11;      //c
                end else if (pulse_BTNC == 1) begin
                    next_BCD0 = 4'd0;       //0
                    next_BCD1 = 4'd1;       //1
                    next_BCD2 = 4'd14;      //black
                    next_BCD3 = 4'd12;      //S
                end else if (pulse_BTNR == 1) begin
                    next_BCD0 = 4'd5;       //5
                    next_BCD1 = 4'd1;       //1
                    next_BCD2 = 4'd14;      //black
                    next_BCD3 = 4'd13;      //A
                end else begin
                    if(BCD0 == 4'd10) begin
                        next_BCD0 = 4'd14;
                        next_BCD1 = 4'd14;
                        next_BCD2 = 4'd14;
                        next_BCD3 = 4'd14;
                    end else begin
                        next_BCD0 = 4'd10;
                        next_BCD1 = 4'd10;
                        next_BCD2 = 4'd10;
                        next_BCD3 = 4'd10;
                    end
                end
            end
            TYPE:begin
                if (pulse_BTNL == 1) begin
                    next_BCD0 = 4'd5;       //5
                    next_BCD1 = 4'd0;       //0
                    next_BCD2 = 4'd14;      //black
                    next_BCD3 = 4'd11;      //c
                end else if (pulse_BTNC == 1) begin
                    next_BCD0 = 4'd0;       //0
                    next_BCD1 = 4'd1;       //1
                    next_BCD2 = 4'd14;      //black
                    next_BCD3 = 4'd12;      //S
                end else if (pulse_BTNR == 1) begin
                    next_BCD0 = 4'd5;       //5
                    next_BCD1 = 4'd1;       //1
                    next_BCD2 = 4'd14;      //black
                    next_BCD3 = 4'd13;      //A
                end else if (pulse_BTNU == 1) begin
                    next_BCD0 = 4'd1;
                    next_BCD1 = 4'd14;
                    next_BCD2 = 4'd14;
                    next_BCD3 = BCD3;
                end else if (pulse_BTND) begin
                    next_BCD0 = 4'd14;
                    next_BCD1 = 4'd14;
                    next_BCD2 = 4'd14;
                    next_BCD3 = 4'd14;
                end else begin
                    if(type == 2'b01) begin
                        next_BCD0 = 4'd5;       //5
                        next_BCD1 = 4'd0;       //0
                        next_BCD2 = 4'd14;      //black
                        next_BCD3 = 4'd11;      //c
                    end else if (type == 2'b10) begin
                        next_BCD0 = 4'd0;       //0
                        next_BCD1 = 4'd1;       //1
                        next_BCD2 = 4'd14;      //black
                        next_BCD3 = 4'd12;      //S
                    end else if (type == 2'b11) begin
                        next_BCD0 = 4'd5;       //5
                        next_BCD1 = 4'd1;       //1
                        next_BCD2 = 4'd14;      //black
                        next_BCD3 = 4'd13;      //A
                    end else begin
                        next_BCD0 = BCD0;
                        next_BCD1 = BCD1;
                        next_BCD2 = BCD2;
                        next_BCD3 = BCD3;
                    end
                end
            end
            AMOUNT:begin
                if (pulse_BTNU == 1) begin
                    next_BCD0 = price % 4'd10;
                    next_BCD1 = price / 4'd10;
                    next_BCD2 = 4'd0;
                    next_BCD3 = 4'd0;
                end else if (pulse_BTND) begin
                    next_BCD0 = 4'd14;
                    next_BCD1 = 4'd14;
                    next_BCD2 = 4'd14;
                    next_BCD3 = 4'd14;
                end else begin
                    next_BCD1 = BCD1;
                    next_BCD2 = BCD2;
                    next_BCD3 = BCD3;
                    if (pulse_BTNR && BCD0 < 4'd3) begin
                        next_BCD0 = BCD0 + 4'd1;
                    end else if (pulse_BTNL && BCD0 > 4'd1) begin
                        next_BCD0 = BCD0 - 4'd1;
                    end else begin
                        next_BCD0 = BCD0;
                    end
                end
            end
            PAYMENT:begin
                if (money >= price) begin
                    next_BCD0 = mem0;
                    next_BCD1 = 4'd14;
                    next_BCD2 = 4'd14;
                    next_BCD3 = mem3;
                end else begin
                    next_BCD0 = BCD0;
                    next_BCD1 = BCD1;
                    if (pulse_BTNL == 1) begin
                        if (BCD2 == 4'd9) begin
                            next_BCD2 = 4'd0;
                            next_BCD3 = BCD3 + 4'd1;
                        end else begin
                            next_BCD2 = BCD2 + 4'd1;
                            next_BCD3 = BCD3;
                        end
                    end else if (pulse_BTNC == 1) begin
                        if (BCD2 >= 4'd5) begin
                            next_BCD2 = BCD2 - 4'd5;
                            next_BCD3 = BCD3 + 4'd1;
                        end else begin
                            next_BCD2 = BCD2 + 4'd5;
                            next_BCD3 = BCD3;
                        end
                    end else if (pulse_BTNR == 1) begin
                        next_BCD2 = BCD2;
                        next_BCD3 = BCD3 + 4'd1;
                    end else begin
                        next_BCD2 = BCD2;
                        next_BCD3 = BCD3;
                    end
                end
            end
            RELEASE:begin
                next_BCD0 = BCD0;
                next_BCD1 = BCD1;
                next_BCD2 = BCD2;
                next_BCD3 = BCD3;
            end
            CHANGE:begin
                next_BCD2 = 4'd14;
                next_BCD3 = 4'd14;
                if (little > 0)begin
                    if(BCD1 * 6'd10 + BCD0 >= 6'd5)begin
                        if(BCD0 >= 4'd5)begin
                            next_BCD0 = BCD0 - 4'd5;
                            next_BCD1 = BCD1;
                        end else begin
                            next_BCD0 = BCD0 + 4'd5;
                            next_BCD1 = BCD1 - 4'd1;
                        end
                    end else begin
                        next_BCD0 = BCD0 - 4'd1;
                        next_BCD1 = BCD1;
                    end
                end else begin
                    if(money >= price) begin
                        next_BCD0 = (money - price) % 4'd10;
                        next_BCD1 = (money - price) / 4'd10;
                    end else begin
                        next_BCD0 = money % 4'd10;
                        next_BCD1 = money / 4'd10;
                    end
                end
            end
        endcase
    end

    //
    always @(posedge clk_machine or posedge rst) begin
        if(rst)begin
            type <= 2'b0;
        end else begin
            type <= next_type;
        end
    end

    always @(*) begin
        if (machine_state == IDLE) begin
            if(pulse_BTNL) next_type = 2'b01;
            else if (pulse_BTNC) next_type = 2'b10;
            else if (pulse_BTNR) next_type = 2'b11;
            else next_type = 2'b00;
        end else begin
            next_type = 2'b0;
        end
    end

    // tool refresh (need price, money, mem3, mem0, cycle)
    always @(posedge clk_tool or posedge rst) begin
        if(rst)begin
            price <= 0;
            money <= 0;
            mem3 <= 0;
            mem0 <= 0;
            cycle <= 0;
            little <= 0;
        end else begin
            price <= next_price;
            money <= next_money;
            mem3 <= next_mem3;
            mem0 <= next_mem0;
            cycle <= next_cycle;
            little <= next_little;
        end
    end
    assign clk_tool = (machine_state == CHANGE || machine_state == RELEASE) ? clk_05hz : clk_machine;

    // price evaluate only change in AMOUNT state       (need next_price)
    always @(*) begin
        if(machine_state == AMOUNT) begin
            if(BCD3 == 4'd13) next_price = 4'd15 * BCD0;       // A 15
            else if (BCD3 == 4'd12) next_price = 4'd10 * BCD0; // S 10
            else if (BCD3 == 4'd11) next_price = 4'd5 * BCD0;  // C 05
            else next_price = price;
        end else if(machine_state == IDLE) begin
            next_price = 0;
        end else begin
            next_price = price; 
        end
    end
    
    // money evaluate only change in PAYMENT state      (need next_money)
    always @(*) begin
        if(machine_state == PAYMENT) begin
            next_money = BCD3 * 4'd10 + BCD2;
        end else if (machine_state == IDLE) begin
            next_money = 0;
        end else begin
            next_money = money;
        end
    end

    // for record mem3 only change in TYPE state        (need next_mem3) (mem3 : C,S,A)
    always @(*) begin
        if(machine_state == TYPE) begin
            next_mem3 = BCD3;
        end else if(machine_state == IDLE) begin
            next_mem3 = 4'd0;
        end else begin
            next_mem3 = mem3;
        end
    end

    // for record mem0 only change in AMOUNT state      (need next_mem0) (mem0 : 1,2,3)
    always @(*) begin
        if(machine_state == AMOUNT) begin
            next_mem0 = BCD0;
        end else if(machine_state == IDLE) begin
            next_mem0 = 4'd0;
        end else begin
            next_mem0 = mem0;
        end
    end

    // for evaluate cycle in RELEASE state only change in this state (need next_cycle)
    always @(*) begin
        if(machine_state == RELEASE) begin
            next_cycle = cycle + 1;
        end else if (machine_state == IDLE) begin
            next_cycle = 1;
        end else begin
            next_cycle = cycle;
        end
    end

    // for evaluate cycle in CHANGE state only change in this state (need next_little)
    always @(*) begin
        if(machine_state == CHANGE) begin
            next_little = little + 1;
        end else if (machine_state == IDLE) begin
            next_little = 0;
        end else begin
            next_little = little;
        end
    end

    // LED refersh
    always @(posedge clk_led or posedge rst) begin
        if(rst)begin
            LED <= 16'b0000_0000_0000_0000;
        end else begin
            LED <= next_LED;
        end
    end
    assign clk_led = (machine_state == IDLE || machine_state == RELEASE || machine_state == CHANGE) ? clk_05hz : clk_machine;
    // LED change     (need next_LED)
    always @(*) begin
        case (machine_state)
            RST:begin
                next_LED = 16'b0000_0000_0000_0000;
            end
            IDLE:begin
                next_LED = ~LED;
            end
            TYPE:begin
                next_LED = 16'b0000_0000_0000_0000;
            end
            AMOUNT:begin
                next_LED = 16'b0000_0000_0000_0000;
            end
            PAYMENT:begin
                next_LED = 16'b0000_0000_0000_0000;
            end
            RELEASE:begin
                next_LED = ~LED;
            end
            CHANGE:begin
                next_LED = 16'b0000_0000_0000_0000;
            end
        endcase
    end
endmodule