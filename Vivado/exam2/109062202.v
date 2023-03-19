// 109062202 陳禹辰

// e.g. 109012345 ???p??
// Add your ID and name to FIRST line of file, or you will get 5 points penalty


module exam2(
    input wire clk, // 100Mhz clock
    input wire rst,
    input wire en,
    input wire up,       // for remedy
    input wire down,   //for remedy
    inout wire PS2_DATA,
    inout wire PS2_CLK,
    output wire [3:0] DIGIT,
    output wire [6:0] DISPLAY,
    output reg [15:0] led  // You can modify "wire" of output ports to "reg" if needed
    );
    
    parameter [8:0] KEY_CODES [0:1] = {
    	9'b0_0110_1001, // right_1 => 69
    	9'b0_0111_0010 // right_2 => 72
    };
    //add your design here
    
    // for state
    reg [2:0] state, state_next;
    parameter IDLE = 2'b00, NORMAL = 2'b01, CHANGE = 2'b10;
    
    // for clock
    wire clk_21, clk_25, clk_27, clk_16;
    reg clk_FSM;
    clock_divider #(16) clk16( .clk(clk), .clk_div(clk_16));
    clock_divider #(21) clk21( .clk(clk), .clk_div(clk_21));
    clock_divider #(25) clk25( .clk(clk), .clk_div(clk_25));
    clock_divider #(27) clk27( .clk(clk), .clk_div(clk_27));
    reg [2:0] clk_mode;
    parameter C21 = 2'b00, C25 = 2'b01, C27 = 2'b10;

    // for button
    wire de_en, one_en;
    debounce deen(.pb_debounced(de_en), .pb(en), .clk(clk_16));
    onepulse oneen(.pb_debounced(de_en), .clk(clk_16), .pb_1pulse(one_en));

    // for led
    reg [15:0] next_led;

    // for BCD
    reg [3:0] BCD1, BCD2, BCD3, BCD4;
    reg [3:0] next_BCD1, next_BCD2, next_BCD3, next_BCD4;
    reg [15:0] BCD_nums, next_BCD_nums;
    SevenSegment seven(.display(DISPLAY), .digit(DIGIT), .nums(BCD_nums), .rst(rst), .clk(clk));

    // for keyboard
    wire [511:0] KEY_DOWN;
    wire [8:0] LAST_CHANGE;
    wire been_valid;
    KeyboardDecoder key( .key_down(KEY_DOWN), .last_change(LAST_CHANGE), .key_valid(been_valid), .PS2_DATA(PS2_DATA), .PS2_CLK(PS2_CLK), .rst(rst), .clk(clk));
/*---------------------------------------------------------------------------------*/
// for state change
    always @(posedge clk_16 or posedge rst) begin
        if (rst) begin
            state <= IDLE; 
        end else begin
            state <= state_next;
        end
    end

    always @(*) begin
        case(state)
            IDLE: begin
                if (one_en) begin
                    state_next = NORMAL;
                end else begin
                    state_next = IDLE;
                end
            end 
            NORMAL: begin
                if (one_en) begin
                    state_next = CHANGE;
                end else begin
                    state_next = NORMAL;
                end
            end
            CHANGE: begin
                if (one_en) begin
                    state_next = IDLE;
                end else begin
                    state_next = CHANGE;
                end
            end
        endcase
    end
/*---------------------------------------------------------------------------------*/
// for led in diff state
    always @(posedge clk_16 or posedge rst) begin
        if(rst) begin
            led <= 16'b1111_0000_0000_0000;
        end else begin
            led <= next_led;
        end
    end

    always @(*) begin
        case(state)
            IDLE:begin
                next_led = 16'b1111_0000_0000_0000;
            end
            NORMAL:begin
                next_led = 16'b0000_1111_0000_0000;
            end
            CHANGE:begin
                next_led = 16'b0000_0000_1111_0000;
            end
        endcase
    end
/*---------------------------------------------------------------------------------*/
// for BCD in diff state
    // for BCD_nums
    always @(posedge clk_16 or posedge rst) begin
        if(rst) begin
            BCD_nums <= 16'b0000_0000_0000_0000;
        end else begin
            BCD_nums <= next_BCD_nums;
        end
    end

    always @(*) begin
        case(state)
            IDLE:begin
                next_BCD_nums = 16'b0000_0000_0000_0000;
            end
            NORMAL:begin
                next_BCD_nums = {BCD4, BCD3, BCD2, BCD1};
            end
            CHANGE:begin
                next_BCD_nums = {BCD4, BCD3, BCD2, BCD1};
            end
        endcase
    end

    // for clk chenge (clk_FSM)
    always @(posedge clk or posedge rst) begin
        if(rst)begin
            clk_FSM <= clk_25;
        end else begin
            case(clk_mode)
                C21:begin
                    clk_FSM <= clk_21;
                end
                C25:begin
                    clk_FSM <= clk_25;
                end
                C27:begin
                    clk_FSM <= clk_27;
                end
            endcase
        end  
    end
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            clk_mode <= C25;
        end else begin
            clk_mode <= clk_mode;
            if (state == NORMAL) begin
                if(been_valid && KEY_DOWN[LAST_CHANGE] == 1'b1) begin
                    if(LAST_CHANGE == KEY_CODES[0]) begin
                        clk_mode <= C21;
                    end else if (LAST_CHANGE == KEY_CODES[1]) begin
                        clk_mode <= C27;
                    end
                end
                if(en) begin
                    clk_mode <= C25;
                end
            end else if (state == CHANGE) begin
                if(been_valid && KEY_DOWN[LAST_CHANGE] == 1'b1) begin
                    if(LAST_CHANGE == KEY_CODES[0]) begin
                        clk_mode <= C21;
                    end else if (LAST_CHANGE == KEY_CODES[1]) begin
                        clk_mode <= C27;
                    end
                end
                if(en) begin
                    clk_mode <= C25;
                end
            end
        end
    end

    always @(posedge clk_FSM or posedge rst) begin
        if(rst)begin
            BCD1 <= 4'b0000;
            BCD2 <= 4'b0000;
            BCD3 <= 4'b0000;
            BCD4 <= 4'b0000;
        end else begin
            if (state == IDLE) begin
                BCD1 <= 4'b0000;
                BCD2 <= 4'b0000;
                BCD3 <= 4'b0000;
                BCD4 <= 4'b0000;
            end else if(state == NORMAL) begin
                if(en) begin
                    BCD1 <= 4'b0000;
                    BCD2 <= 4'b0000;
                    BCD3 <= 4'b0000;
                    BCD4 <= 4'b0000;
                end else begin
                    BCD1 <= next_BCD1;
                    BCD2 <= next_BCD2;
                    BCD3 <= next_BCD3;
                    BCD4 <= next_BCD4;
                end
            end else if(state == CHANGE) begin
                if(en) begin
                    BCD1 <= 4'b0000;
                    BCD2 <= 4'b0000;
                    BCD3 <= 4'b0000;
                    BCD4 <= 4'b0000;
                end else begin
                    BCD1 <= next_BCD1;
                    BCD2 <= next_BCD2;
                    BCD3 <= next_BCD3;
                    BCD4 <= next_BCD4;
                end
            end
        end
    end
    always @(*) begin
        if(state == IDLE) begin
            next_BCD1 = 4'd0;
            next_BCD2 = 4'd0;
            next_BCD3 = 4'd0;
            next_BCD4 = 4'd0;
        end else if(state == NORMAL) begin
            if(en) begin
                next_BCD1 = 4'd0;
                next_BCD2 = 4'd0;
                next_BCD3 = 4'd0;
                next_BCD4 = 4'd0;
            end else begin
                if(BCD4 < 4'd1) begin
                    if(BCD3 < 4'd6) begin
                        if(BCD2 < 4'd9)begin
                            if(BCD1 < 4'd9) begin
                                next_BCD1 = BCD1 + 4'd1;
                                next_BCD2 = BCD2;
                                next_BCD3 = BCD3;
                                next_BCD4 = BCD4;
                            end else begin
                                next_BCD1 = 4'd0;
                                next_BCD2 = BCD2 + 4'd1;
                                next_BCD3 = BCD3;
                                next_BCD4 = BCD4;
                            end
                        end else begin
                            next_BCD1 = 4'd0;
                            next_BCD2 = 4'd0;
                            next_BCD3 = BCD3 + 4'd1;
                            next_BCD4 = BCD4;
                        end
                    end else begin
                        next_BCD1 = 4'd0;
                        next_BCD2 = 4'd0;
                        next_BCD3 = 4'd0;
                        next_BCD4 = 4'd1;
                    end
                end else begin
                    next_BCD1 = 4'd0;
                    next_BCD2 = 4'd0;
                    next_BCD3 = 4'd0;
                    next_BCD4 = 4'd1;
                end
            end
        end else begin
            if(en) begin
                next_BCD1 = 4'd0;
                next_BCD2 = 4'd0;
                next_BCD3 = 4'd0;
                next_BCD4 = 4'd0;
            end else begin
                if(BCD4 < 4'd1) begin
                    if(BCD3 < 4'd6) begin
                        if(BCD2 < 4'd9)begin
                            if(BCD1 < 4'd9) begin
                                next_BCD1 = BCD1 + 4'd1;
                                next_BCD2 = BCD2;
                                next_BCD3 = BCD3;
                                next_BCD4 = BCD4;
                            end else begin
                                next_BCD1 = 4'd0;
                                next_BCD2 = BCD2 + 4'd1;
                                next_BCD3 = BCD3;
                                next_BCD4 = BCD4;
                            end
                        end else begin
                            next_BCD1 = 4'd0;
                            next_BCD2 = 4'd0;
                            next_BCD3 = BCD3 + 4'd1;
                            next_BCD4 = BCD4;
                        end
                    end else begin
                        next_BCD1 = 4'd0;
                        next_BCD2 = 4'd0;
                        next_BCD3 = 4'd0;
                        next_BCD4 = 4'd1;
                    end
                end else begin
                    next_BCD1 = 4'd0;
                    next_BCD2 = 4'd0;
                    next_BCD3 = 4'd0;
                    next_BCD4 = 4'd1;
                end
            end
        end
    end
endmodule

// You can modify below modules I/O or content if needed.
// Also you can add any module you need.
// Make sure you include all modules you used in this file.



module SevenSegment(
	output reg [6:0] display,
	output reg [3:0] digit, 
	input wire [15:0] nums, // four 4-bits BCD number
	input wire rst,
	input wire clk  // Input 100Mhz clock
    );
    
    reg [15:0] clk_divider;
    reg [3:0] display_num;
    
    always @ (posedge clk, posedge rst) begin
    	if (rst) begin
    		clk_divider <= 15'b0;
    	end else begin
    		clk_divider <= clk_divider + 15'b1;
    	end
    end
    
    always @ (posedge clk_divider[15], posedge rst) begin
    	if (rst) begin
    		display_num <= 4'b0000;
    		digit <= 4'b1111;
    	end else begin
    		case (digit)
    			4'b1110 : begin
    					display_num <= nums[7:4];
    					digit <= 4'b1101;
    				end
    			4'b1101 : begin
						display_num <= nums[11:8];
						digit <= 4'b1011;
					end
    			4'b1011 : begin
						display_num <= nums[15:12];
						digit <= 4'b0111;
					end
    			4'b0111 : begin
						display_num <= nums[3:0];
						digit <= 4'b1110;
					end
    			default : begin
						display_num <= nums[3:0];
						digit <= 4'b1110;
					end				
    		endcase
    	end
    end
    
    always @ (*) begin
    	case (display_num)
    		0 : display = 7'b1000000;	//0000
			1 : display = 7'b1111001;   //0001                                                
			2 : display = 7'b0100100;   //0010                                                
			3 : display = 7'b0110000;   //0011                                             
			4 : display = 7'b0011001;   //0100                                               
			5 : display = 7'b0010010;   //0101                                               
			6 : display = 7'b0000010;   //0110
			7 : display = 7'b1111000;   //0111
			8 : display = 7'b0000000;   //1000
			9 : display = 7'b0010000;	//1001
			default : display = 7'b1111111;
    	endcase
    end
    
endmodule

module onepulse(pb_debounced, clk, pb_1pulse);	
	input pb_debounced;	
	input clk;	
	output pb_1pulse;	

	reg pb_1pulse;	
	reg pb_debounced_delay;	

	always@(posedge clk) begin
		pb_1pulse <= pb_debounced & (! pb_debounced_delay);
		pb_debounced_delay <= pb_debounced;
	end	
endmodule

module clock_divider(clk, clk_div);   
    parameter n = 26;     
    input clk;   
    output clk_div;   
    
    reg [n-1:0] num;
    wire [n-1:0] next_num;
    
    always@(posedge clk)begin
    	num <= next_num;
    end
    
    assign next_num = num +1;
    assign clk_div = num[n-1];
    
endmodule

module debounce (pb_debounced, pb, clk); 
	output pb_debounced;
	input pb;
	input clk; 
	reg [3:0] DFF;
	always @(posedge clk) begin 
		DFF[3:1] <= DFF[2:0]; 
		DFF[0] <= pb; 
	end
	assign pb_debounced = ((DFF == 4'b1111) ? 1'b1 : 1'b0);

endmodule

module KeyboardDecoder(
	output reg [511:0] key_down,
	output wire [8:0] last_change,
	output reg key_valid,
	inout wire PS2_DATA,
	inout wire PS2_CLK,
	input wire rst,
	input wire clk
    );
    
    parameter [1:0] INIT			= 2'b00;
    parameter [1:0] WAIT_FOR_SIGNAL = 2'b01;
    parameter [1:0] GET_SIGNAL_DOWN = 2'b10;
    parameter [1:0] WAIT_RELEASE    = 2'b11;
    
	parameter [7:0] IS_INIT			= 8'hAA;
    parameter [7:0] IS_EXTEND		= 8'hE0;
    parameter [7:0] IS_BREAK		= 8'hF0;
    
    reg [9:0] key;		// key = {been_extend, been_break, key_in}
    reg [1:0] state;
    reg been_ready, been_extend, been_break;
    
    wire [7:0] key_in;
    wire is_extend;
    wire is_break;
    wire valid;
    wire err;
    
    wire [511:0] key_decode = 1 << last_change;
    assign last_change = {key[9], key[7:0]};
    
    KeyboardCtrl_0 inst (
		.key_in(key_in),
		.is_extend(is_extend),
		.is_break(is_break),
		.valid(valid),
		.err(err),
		.PS2_DATA(PS2_DATA),
		.PS2_CLK(PS2_CLK),
		.rst(rst),
		.clk(clk)
	);
	
	
    onepulse op(.clk(clk), .pb_debounced(been_ready), .pb_1pulse(pulse_been_ready));
    
    always @ (posedge clk, posedge rst) begin
    	if (rst) begin
    		state <= INIT;
    		been_ready  <= 1'b0;
    		been_extend <= 1'b0;
    		been_break  <= 1'b0;
    		key <= 10'b0_0_0000_0000;
    	end else begin
    		state <= state;
			been_ready  <= been_ready;
			been_extend <= (is_extend) ? 1'b1 : been_extend;
			been_break  <= (is_break ) ? 1'b1 : been_break;
			key <= key;
    		case (state)
    			INIT : begin
    					if (key_in == IS_INIT) begin
    						state <= WAIT_FOR_SIGNAL;
    						been_ready  <= 1'b0;
							been_extend <= 1'b0;
							been_break  <= 1'b0;
							key <= 10'b0_0_0000_0000;
    					end else begin
    						state <= INIT;
    					end
    				end
    			WAIT_FOR_SIGNAL : begin
    					if (valid == 0) begin
    						state <= WAIT_FOR_SIGNAL;
    						been_ready <= 1'b0;
    					end else begin
    						state <= GET_SIGNAL_DOWN;
    					end
    				end
    			GET_SIGNAL_DOWN : begin
						state <= WAIT_RELEASE;
						key <= {been_extend, been_break, key_in};
						been_ready  <= 1'b1;
    				end
    			WAIT_RELEASE : begin
    					if (valid == 1) begin
    						state <= WAIT_RELEASE;
    					end else begin
    						state <= WAIT_FOR_SIGNAL;
    						been_extend <= 1'b0;
    						been_break  <= 1'b0;
    					end
    				end
    			default : begin
    					state <= INIT;
						been_ready  <= 1'b0;
						been_extend <= 1'b0;
						been_break  <= 1'b0;
						key <= 10'b0_0_0000_0000;
    				end
    		endcase
    	end
    end
    
    always @ (posedge clk, posedge rst) begin
    	if (rst) begin
    		key_valid <= 1'b0;
    		key_down <= 511'b0;
    	end else if (key_decode[last_change] && pulse_been_ready) begin
    		key_valid <= 1'b1;
    		if (key[8] == 0) begin
    			key_down <= key_down | key_decode;
    		end else begin
    			key_down <= key_down & (~key_decode);
    		end
    	end else begin
    		key_valid <= 1'b0;
			key_down <= key_down;
    	end
    end

endmodule
