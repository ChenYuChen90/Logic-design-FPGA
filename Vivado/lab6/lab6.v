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

module lab06 (
    input wire clk,
    input wire rst,
    inout wire PS2_CLK,
    inout wire PS2_DATA,
    output reg [3:0] DIGIT,
    output reg [6:0] DISPLAY,
    output reg [15:0] LED
    );
    
    // for clk
    wire clk_machine, clk_light, clk_bus, clk_FSM, clk_people, clk_on;
    // for led     [15:14] for B1 pepple, [12:11] for B2 people, [10:9] for bus people, [6:0] for bus pos
    reg [1:0] B1_led, B2_led, Bus_led;
    reg [6:0] Pos_led;
    reg [15:0] LED_next;
    // for 7-segement
    reg [3:0] value;

    // for tool
    reg [1:0] B1_people, B2_people, Bus_people;                 // 記 B1, B2, Bus的人數
    reg [1:0] B1_people_next, B2_people_next, Bus_people_next;
    reg Bus_dir, Bus_dir_next;                                  // 記 Bus 現在的方向 (0 向上 1 向下)
    reg [7:0] revenue, revenue_next;                            // 記 收入為多少 (max = 90)
    reg [5:0] gas_unit, gas_unit_next;                          // 記 gas 為多少 (max = 20)

    reg [2:0] Bus_pos, Bus_pos_next;                            // 記 Bus 的位置 ([6][5][4][3][2][1][0])
    parameter B1 = 3'b000;
    parameter LD1 = 3'b001;
    parameter LD2 = 3'b010;
    parameter G2 = 3'b011;
    parameter LD4 = 3'b100;
    parameter LD5 = 3'b101;
    parameter B2 = 3'b110;

    reg [3:0] Bus_state, Bus_state_next;                        // 記 Bus state
    parameter DRIVE = 4'b0000;
    parameter ARRIVE_B = 4'b0001;
    parameter FUELCOMP_B = 4'b0010;
    parameter GET_OFF = 4'b0011;
    parameter WAITING = 4'b0100;
    parameter GET_ON = 4'b0101;
    parameter REFUELING_B = 4'b0110;
    parameter ARRIVE_G = 4'b0111;
    parameter FUELCOMP_G = 4'b1000;
    parameter REFUELING_G = 4'b1001;
    parameter PAY = 4'b1010;
    parameter STEP = 4'b1011;

    // for keyboard
    wire [511:0] key_down;
	wire [8:0] last_change;
    reg [3:0] key_num;
	wire been_ready;
    
    parameter [8:0] KEY_CODES1 = 9'b0_0110_1001; //right_1 =>69
    parameter [8:0] KEY_CODES2 = 9'b0_0111_0010; //right_2 =>72

    clock_diveder #(10) clk_light_control( .clk(clk), .clk_div(clk_light));
    clock_diveder #(16) clk_butt( .clk(clk), .clk_div(clk_button));
    clock_diveder #(26) clk_mach( .clk(clk), .clk_div(clk_machine));

    KeyboardDecoder key_de (
		.key_down(key_down),			//哪個按鍵被按下去了
		.last_change(last_change),		//前一個處理的按鍵
		.key_valid(been_ready),			//能不能接受新的訊號
		.PS2_DATA(PS2_DATA),
		.PS2_CLK(PS2_CLK),
		.rst(rst),
		.clk(clk)
	);
/*-------------------------------LED------------------------------------*/

    // LED refresh  (need LED)
    always @(posedge clk_bus or posedge rst) begin
        if (rst) begin
            LED[10:0] <= 11'b000_0000_0000;
        end else begin
                    // [8:7]   [6:0]
            LED[10:0] <= {Bus_led, 2'b0, Pos_led};
        end
    end
    assign clk_bus = (Bus_state == GET_ON) ? clk : clk_machine;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            LED[15:11] <= 7'b000_0000;
        end else begin
                        //[15:14] [13]  [12:11]
            LED[15:11] <= {B1_led, 1'b0, B2_led};
        end
    end

    // B1_led
    always @(*) begin
        if (B1_people == 2'b01) begin
            B1_led = 2'b10;
        end else if (B1_people == 2'b10) begin
            B1_led = 2'b11;
        end else begin
            B1_led = 2'b00;
        end
    end
    
    // B2_led
    always @(*) begin
        if (B2_people == 2'b01) begin
            B2_led = 2'b10;
        end else if (B2_people == 2'b10) begin
            B2_led = 2'b11;
        end else begin
            B2_led = 2'b00;
        end
    end
    // Bus_led
    always @(*) begin
        if (Bus_people == 2'b01) begin
            Bus_led = 2'b10;
        end else if (Bus_people == 2'b10) begin
            Bus_led = 2'b11;
        end else begin
            Bus_led = 2'b00;
        end
    end
    // Pos_led
    always @(*) begin
        case (Bus_pos)
            3'd0: Pos_led = 7'b000_0001;
            3'd1: Pos_led = 7'b000_0010;
            3'd2: Pos_led = 7'b000_0100;
            3'd3: Pos_led = 7'b000_1000;
            3'd4: Pos_led = 7'b001_0000;
            3'd5: Pos_led = 7'b010_0000;
            3'd6: Pos_led = 7'b100_0000;
            default: Pos_led = 7'b000_0000;
        endcase
    end
    
/*-----------------------------KEYBOARD---------------------------------*/   
    always @ (*) begin
		case (last_change)
			KEY_CODES1 : key_num = 4'b0001; // right 1
			KEY_CODES2 : key_num = 4'b0010; // right 2
            default	   : key_num = 4'b1111;
		endcase
	end
/*-------------------------------BUS------------------------------------*/
    //(B1_people, B2_people), Bus_people, Bus_pos, Bus_state, Bus_dir, revenue, gas_unit
    always @(posedge clk_FSM or posedge rst) begin
        if (rst) begin
            Bus_pos <= 0;
            Bus_state <= WAITING;
            Bus_dir <= 0;
            revenue <= 0;
            gas_unit <= 0;
        end else begin
            Bus_pos <= Bus_pos_next;
            Bus_state <= Bus_state_next;
            Bus_dir <= Bus_dir_next;
            revenue <= revenue_next;
            gas_unit <= gas_unit_next;
        end    
    end
    assign clk_FSM = (Bus_state == GET_ON) ? clk : clk_machine;

    always @(posedge clk_people or posedge rst) begin
        if (rst) begin
            Bus_people <= 0;
        end else begin
            Bus_people <= Bus_people_next;
        end   
    end
    assign clk_people = (Bus_state == GET_ON) ? clk : clk_machine;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            B1_people <= 0;
            B2_people <= 0;
        end else begin
            B1_people <= B1_people_next;
            B2_people <= B2_people_next;
        end 
    end
    // Bus state (Bus_state_next)
    always @(*) begin
        case (Bus_state)
            DRIVE : begin
                if (Bus_pos_next == B1 || Bus_pos_next == B2) begin
                    Bus_state_next = ARRIVE_B;
                end else if (Bus_pos_next == G2) begin
                    Bus_state_next = ARRIVE_G;
                end else begin
                    Bus_state_next = DRIVE;
                end
            end
            ARRIVE_B : begin
                if (Bus_people_next != 0) begin
                    Bus_state_next = FUELCOMP_B;
                end else begin
                    Bus_state_next = WAITING;
                end
            end
            FUELCOMP_B : begin
                Bus_state_next = GET_OFF;
            end
            GET_OFF : begin
                if (Bus_people == 0) begin
                    Bus_state_next = WAITING;
                end else begin
                    Bus_state_next = GET_OFF;
                end
            end
            WAITING : begin
                if (B1_people_next == 0 && B2_people_next == 0) begin         // 兩邊沒人
                    Bus_state_next = WAITING;
                end else begin
                    if (Bus_pos_next == B1) begin                        // 車在B1
                        if (B2_people_next != 0 && B1_people_next == 0) begin // 對面有人這邊沒人
                            Bus_state_next = DRIVE;
                        end else begin                              // 對面沒人這邊有人 or 對面有人這邊有人
                            Bus_state_next = GET_ON;
                        end
                    end else begin                                  // 車在B2
                        if (B1_people_next != 0 && B2_people_next == 0) begin // 對面有人這邊沒人
                            Bus_state_next = DRIVE;
                        end else begin                              // 對面沒人這邊有人 or 對面有人這邊有人
                            Bus_state_next = GET_ON;
                        end
                    end
                end
            end
            GET_ON : begin
                Bus_state_next = STEP;
            end
            STEP : begin
                Bus_state_next = PAY;
            end
            PAY : begin
                Bus_state_next = REFUELING_B;
            end
            REFUELING_B : begin
                if (gas_unit_next == 5'd20 || revenue_next < 4'd10) begin        // 補油捕到油滿了 或 錢不夠再付一次油錢了
                    Bus_state_next = DRIVE;
                end else begin
                    Bus_state_next = REFUELING_B;
                end
            end
            ARRIVE_G : begin
                if (Bus_people_next != 0) begin
                    Bus_state_next = FUELCOMP_G;
                end else begin
                    Bus_state_next = DRIVE;
                end
            end
            FUELCOMP_G : begin
                if(revenue_next >= 4'd10) begin
                    Bus_state_next = REFUELING_G;
                end else begin
                    Bus_state_next = DRIVE;
                end
            end
            REFUELING_G : begin
                if (gas_unit_next == 5'd20 || revenue_next < 4'd10) begin        // 補油捕到油滿了 或 沒錢了
                    Bus_state_next = DRIVE;
                end else begin
                    Bus_state_next = REFUELING_G;
                end
            end
        endcase
    end
    
    // 輸入做判斷   (上車時會一次減少 鍵盤按時會一個一個增加)
    // B1 people
    always @(*) begin
        B1_people_next = B1_people;
        if(been_ready && key_down[last_change] == 1'b1)begin
            if (key_num == 4'b0001) begin
                if(B1_people < 2'd2) begin
                    B1_people_next = B1_people + 1;
                end else begin
                    B1_people_next = B1_people;
                end
            end
        end else begin
            if(Bus_state == GET_ON && Bus_pos == B1) begin
                B1_people_next = 0;
            end else begin
                B1_people_next = B1_people;
            end
        end
    end
    // B2 people
    always @(*) begin
        B2_people_next = B2_people;
        if(been_ready && key_down[last_change] == 1'b1)begin
            if (key_num == 4'b0010) begin
                if(B2_people < 2'd2) begin
                    B2_people_next = B2_people + 1;
                end else begin
                    B2_people_next = B2_people;
                end
            end
        end else begin
            if(Bus_state == GET_ON && Bus_pos == B2) begin
                B2_people_next = 0;
            end else begin
                B2_people_next = B2_people;
            end
        end
    end
    // Bus people    (Bus_people_next)   (要考慮上下車)      (上車時會一次加 下車時會一個一個下)
    always @(*) begin
        if (Bus_state == GET_ON) begin                      // 上車一次上 所以直接 assign
            if (Bus_pos == B1) begin
                Bus_people_next = B1_people;
            end else if (Bus_pos == B2) begin
                Bus_people_next = B2_people;
            end else begin
                Bus_people_next = Bus_people;
            end
        end else if (Bus_state == GET_OFF) begin            // 下車一個一個下 所以一次減少一個
            if (Bus_people > 0) begin
                Bus_people_next = Bus_people - 1'b1;
            end else begin
                Bus_people_next = Bus_people;
            end
        end else begin
            Bus_people_next = Bus_people;
        end
    end

    // Bus pos      (Bus_pos_next)
    always @(*) begin
        if (Bus_state == DRIVE) begin
            if (Bus_dir == 0) begin                     // 方向朝上
                if(Bus_pos < 3'd6)begin
                    Bus_pos_next = Bus_pos + 1'b1;
                end else begin
                    Bus_pos_next = Bus_pos;
                end
            end else begin                              // 方向朝下
                if (Bus_pos > 3'd0) begin
                    Bus_pos_next = Bus_pos - 1'b1;
                end else begin
                    Bus_pos_next = Bus_pos;
                end
            end
        end else begin
            Bus_pos_next = Bus_pos;
        end
    end

    // Bus dir      (Bus_dir_next)
    always @(*) begin
        if (Bus_pos == 3'd0) begin
            Bus_dir_next = 1'b0; 
        end else if (Bus_pos == 3'd6) begin
            Bus_dir_next = 1'b1;
        end else begin
            Bus_dir_next = Bus_dir;
        end
    end
    
    // revenue          (補油時會扣錢 or 人上車會加錢)
    always @(*) begin
        if (Bus_state == PAY) begin                                  // 人上車付錢
            if (Bus_pos == B1) begin                                    // 在B1
                if (revenue + Bus_people * 6'd30 > 7'd90) begin          // 不讓收入超過90 (上山付30)
                    revenue_next = 7'd90;
                end else begin
                    revenue_next = revenue + Bus_people * 6'd30;         
                end
            end else if (Bus_pos == B2) begin                           // 在B2 (下山付20)
                if (revenue + Bus_people * 6'd20 > 7'd90) begin
                    revenue_next = 7'd90;
                end else begin
                    revenue_next = revenue + Bus_people * 6'd20;
                end
            end else begin
                revenue_next = revenue;
            end
        end else if (Bus_state == REFUELING_B) begin
            if (revenue >= 4'd10 && gas_unit != 5'd20) begin
                revenue_next = revenue - 4'd10;
            end else begin
                revenue_next = revenue;
            end
        end else if (Bus_state == REFUELING_G) begin
            if (revenue >= 4'd10 && gas_unit != 5'd20) begin
                revenue_next = revenue - 4'd10;
            end else begin
                revenue_next = revenue;
            end
        end else begin
            revenue_next = revenue;
        end
    end

    // gas unit         (扣油時會減少 補油時會增加)
    always @(*) begin
        if (Bus_state == REFUELING_G || Bus_state == REFUELING_B) begin
            if (gas_unit + 5'd10 > 5'd20) begin
                gas_unit_next = 5'd20;
            end else begin
                gas_unit_next = gas_unit + 5'd10;
            end
        end else if (Bus_state == FUELCOMP_B) begin             // 扣油
            if (gas_unit - Bus_people * 5'd5 >= 0) begin        // 最多扣到沒油 (?)
                gas_unit_next = gas_unit - Bus_people * 5'd5;
            end else begin
                gas_unit_next = gas_unit;
            end
        end else if (Bus_state == FUELCOMP_G) begin
            if (gas_unit - Bus_people * 5'd5 >= 0) begin
                gas_unit_next = gas_unit - Bus_people * 5'd5;
            end else begin
                gas_unit_next = gas_unit;
            end
        end else begin
            gas_unit_next = gas_unit;
        end
    end

/*-------------------------------BCD------------------------------------*/
    always @(posedge clk_light) begin
        case (DIGIT)
            4'b1110: begin
                value <= revenue / 7'd10;
                DIGIT <= 4'b1101;
            end
            4'b1101: begin
                value <= gas_unit % 5'd10;
                DIGIT <= 4'b1011;
            end
            4'b1011: begin
                value <= gas_unit / 5'd10;
                DIGIT <= 4'b0111;
            end
            4'b0111: begin
                value <= revenue % 7'd10;
                DIGIT <= 4'b1110;
            end
            default: begin
                value <= revenue % 7'd10;
                DIGIT <= 4'b1110;
            end
        endcase
    end
    always @(*) begin
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
        endcase
    end
    
endmodule