module clock_divider(clk1, clk, clk22);
    input clk;
    output clk1;
    output clk22;
    reg [21:0] num;
    wire [21:0] next_num;

    always @(posedge clk) begin
    num <= next_num;
    end

    assign next_num = num + 1'b1;
    assign clk1 = num[1];
    assign clk22 = num[21];
endmodule

module lab7_2 (
    input clk,
    input rst,
    input hold,
    inout PS2_CLK,
    inout PS2_DATA,
    output reg [3:0] vgaRed,
    output reg [3:0] vgaGreen,
    output reg [3:0] vgaBlue,
    output hsync,
    output vsync,
    output pass  
    );
    
    // for display
    wire [11:0] data;
    wire clk_25Hz, clk_22;
    wire [16:0] pixel_addr;
    wire [11:0] pixel;
    wire valid;
    wire [9:0] h_cnt;   //640
    wire [9:0] v_cnt;   //480

    always @(*) begin
        if (valid) begin
            {vgaRed, vgaGreen, vgaBlue} = pixel;
        end else begin
            {vgaRed, vgaGreen, vgaBlue} = 12'h0;
        end
    end

    clock_divider clk_div( .clk(clk), .clk1(clk_25Hz), .clk22(clk_22));

    mem_addr_gen mem_addr_gen_inst(
        .clk(clk),
        .rst(rst),
        .hold(hold),
        .PS2_CLK(PS2_CLK),
        .PS2_DATA(PS2_DATA),
        .h_cnt(h_cnt),
        .v_cnt(v_cnt),
        .pixel_addr(pixel_addr),
        .pass(pass)
    );

    blk_mem_gen_0 blk_mem_gen_0_inst(
      .clka(clk_25Hz),
      .wea(0),
      .addra(pixel_addr),
      .dina(data[11:0]),
      .douta(pixel)
    ); 

    vga_controller   vga_inst(
      .pclk(clk_25Hz),
      .reset(rst),
      .hsync(hsync),
      .vsync(vsync),
      .valid(valid),
      .h_cnt(h_cnt),
      .v_cnt(v_cnt)
    );

endmodule

module mem_addr_gen (
    input clk,
    input rst,
    input hold,
    inout PS2_CLK,
    inout PS2_DATA,
    input [9:0] h_cnt,
    input [9:0] v_cnt,
    output reg [16:0] pixel_addr,
    output pass
    );
    wire de_hold;
    Debounce debouced_hold( .pb_debounced(de_hold), .pb(hold), .clk(clk));
    
    reg [7:0] position;

    // for keyboard
    wire shift_down;
    wire [511:0] key_down;
	wire [8:0] last_change;
	wire been_ready;
    reg [3:0] key_num;

    parameter [8:0] LEFT_SHIFT_CODES = 9'b0_0001_0010;
	parameter [8:0] RIGHT_SHIFT_CODES = 9'b0_0101_1001;
    parameter [8:0] KEY_CODES [0:11] = {
        9'b0_0100_0100, // O
        9'b0_0100_1101, // p
        9'b0_0101_0100, // [
        9'b0_0101_1011, // ]
        9'b0_0100_0010, // k
        9'b0_0100_1011, // l
        9'b0_0100_1100, // ;
        9'b0_0101_0010, // '
        9'b0_0011_1010, // m
        9'b0_0100_0001, // ,
        9'b0_0100_1001, // .
        9'b0_0100_1010  // /
    };
    assign shift_down = (key_down[LEFT_SHIFT_CODES] == 1'b1 || key_down[RIGHT_SHIFT_CODES] == 1'b1) ? 1'b1 : 1'b0;
    KeyboardDecoder key_de (
		.key_down(key_down),
		.last_change(last_change),
		.key_valid(been_ready),
		.PS2_DATA(PS2_DATA),
		.PS2_CLK(PS2_CLK),
		.rst(rst),
		.clk(clk)
	);
    
    reg [4:0] rotate_times_1;
    reg [4:0] rotate_times_2;
    reg [4:0] rotate_times_3;
    reg [4:0] rotate_times_4;
    reg [4:0] rotate_times_5;
    reg [4:0] rotate_times_6;
    reg [4:0] rotate_times_7;
    reg [4:0] rotate_times_8;
    reg [4:0] rotate_times_9;
    reg [4:0] rotate_times_10;
    reg [4:0] rotate_times_11;
    reg [4:0] rotate_times_12;
    reg [4:0] rotate_times;

    wire [4:0] ph, pv;
    assign ph = h_cnt / 160;
    assign pv = v_cnt / 160;
    wire [16:0] dir0, dir1, dir2, dir3;
    parameter [3:0] Area [0:11] = {
        4'b0000,
        4'b0001,
        4'b0010,
        4'b0011,
        4'b0100,
        4'b0101,
        4'b0111,
        4'b1000,
        4'b1001,
        4'b1010,
        4'b1011,
        4'b1100
    };
    reg [3:0] area;
    always @(posedge clk or posedge rst) begin
        if (rst) begin              // initial
            rotate_times_1 <= 5'd1;
            rotate_times_2 <= 5'd2;
            rotate_times_3 <= 5'd3;
            rotate_times_4 <= 5'd2;
            rotate_times_5 <= 5'd2;
            rotate_times_6 <= 5'd3;
            rotate_times_7 <= 5'd1;
            rotate_times_8 <= 5'd1;
            rotate_times_9 <= 5'd1;
            rotate_times_10 <= 5'd3;
            rotate_times_11 <= 5'd2;
            rotate_times_12 <= 5'd3; 
        end else begin
            rotate_times_1 <= rotate_times_1;
            rotate_times_2 <= rotate_times_2;
            rotate_times_3 <= rotate_times_3;
            rotate_times_4 <= rotate_times_4;
            rotate_times_5 <= rotate_times_5;
            rotate_times_6 <= rotate_times_6;
            rotate_times_7 <= rotate_times_7;
            rotate_times_8 <= rotate_times_8;
            rotate_times_9 <= rotate_times_9;
            rotate_times_10 <= rotate_times_10;
            rotate_times_11 <= rotate_times_11;
            rotate_times_12 <= rotate_times_12;
            if (!pass && !de_hold) begin
                if (been_ready && key_down[last_change] == 1'b1) begin
                    case (last_change)
                        KEY_CODES[00] :begin
                            if (shift_down) begin
                                if (rotate_times_1 == 0) begin
                                    rotate_times_1 <= 3;
                                end else begin
                                    rotate_times_1 <= rotate_times_1 - 1;
                                end
                            end else begin
                                if (rotate_times_1 == 3) begin
                                    rotate_times_1 <= 0;
                                end else begin
                                    rotate_times_1 <= rotate_times_1 + 1;
                                end
                            end
                        end
                        KEY_CODES[01] :begin
                            if (shift_down) begin
                                if (rotate_times_2 == 0) begin
                                    rotate_times_2 <= 3;
                                end else begin
                                    rotate_times_2 <= rotate_times_2 - 1;
                                end
                            end else begin
                                if (rotate_times_2 == 3) begin
                                    rotate_times_2 <= 0;
                                end else begin
                                    rotate_times_2 <= rotate_times_2 + 1;
                                end
                            end
                        end
                        KEY_CODES[02] :begin
                            if (shift_down) begin
                                if (rotate_times_3 == 0) begin
                                    rotate_times_3 <= 3;
                                end else begin
                                    rotate_times_3 <= rotate_times_3 - 1;
                                end
                            end else begin
                                if (rotate_times_3 == 3) begin
                                    rotate_times_3 <= 0;
                                end else begin
                                    rotate_times_3 <= rotate_times_3 + 1;
                                end
                            end
                        end
                        KEY_CODES[03] :begin
                            if (shift_down) begin
                                if (rotate_times_4 == 0) begin
                                    rotate_times_4 <= 3;
                                end else begin
                                    rotate_times_4 <= rotate_times_4 - 1;
                                end
                            end else begin
                                if (rotate_times_4 == 3) begin
                                    rotate_times_4 <= 0;
                                end else begin
                                    rotate_times_4 <= rotate_times_4 + 1;
                                end
                            end
                        end
                        KEY_CODES[04] :begin
                            if (shift_down) begin
                                if (rotate_times_5 == 0) begin
                                    rotate_times_5 <= 3;
                                end else begin
                                    rotate_times_5 <= rotate_times_5 - 1;
                                end
                            end else begin
                                if (rotate_times_5 == 3) begin
                                    rotate_times_5 <= 0;
                                end else begin
                                    rotate_times_5 <= rotate_times_5 + 1;
                                end
                            end
                        end
                        KEY_CODES[05] :begin
                            if (shift_down) begin
                                if (rotate_times_6 == 0) begin
                                    rotate_times_6 <= 3;
                                end else begin
                                    rotate_times_6 <= rotate_times_6 - 1;
                                end
                            end else begin
                                if (rotate_times_6 == 3) begin
                                    rotate_times_6 <= 0;
                                end else begin
                                    rotate_times_6 <= rotate_times_6 + 1;
                                end
                            end
                        end
                        KEY_CODES[06] :begin
                            if (shift_down) begin
                                if (rotate_times_7 == 0) begin
                                    rotate_times_7 <= 3;
                                end else begin
                                    rotate_times_7 <= rotate_times_7 - 1;
                                end
                            end else begin
                                if (rotate_times_7 == 3) begin
                                    rotate_times_7 <= 0;
                                end else begin
                                    rotate_times_7 <= rotate_times_7 + 1;
                                end
                            end
                        end
                        KEY_CODES[07] :begin
                            if (shift_down) begin
                                if (rotate_times_8 == 0) begin
                                    rotate_times_8 <= 3;
                                end else begin
                                    rotate_times_8 <= rotate_times_8 - 1;
                                end
                            end else begin
                                if (rotate_times_8 == 3) begin
                                    rotate_times_8 <= 0;
                                end else begin
                                    rotate_times_8 <= rotate_times_8 + 1;
                                end
                            end
                        end
                        KEY_CODES[08] :begin
                            if (shift_down) begin
                                if (rotate_times_9 == 0) begin
                                    rotate_times_9 <= 3;
                                end else begin
                                    rotate_times_9 <= rotate_times_9 - 1;
                                end
                            end else begin
                                if (rotate_times_9 == 3) begin
                                    rotate_times_9 <= 0;
                                end else begin
                                    rotate_times_9 <= rotate_times_9 + 1;
                                end
                            end
                        end
                        KEY_CODES[09] :begin
                            if (shift_down) begin
                                if (rotate_times_10 == 0) begin
                                    rotate_times_10 <= 3;
                                end else begin
                                    rotate_times_10 <= rotate_times_10 - 1;
                                end
                            end else begin
                                if (rotate_times_10 == 3) begin
                                    rotate_times_10 <= 0;
                                end else begin
                                    rotate_times_10 <= rotate_times_10 + 1;
                                end
                            end
                        end
                        KEY_CODES[10] :begin
                            if (shift_down) begin
                                if (rotate_times_11 == 0) begin
                                    rotate_times_11 <= 3;
                                end else begin
                                    rotate_times_11 <= rotate_times_11 - 1;
                                end
                            end else begin
                                if (rotate_times_11 == 3) begin
                                    rotate_times_11 <= 0;
                                end else begin
                                    rotate_times_11 <= rotate_times_11 + 1;
                                end
                            end
                        end
                        KEY_CODES[11] :begin
                            if (shift_down) begin
                                if (rotate_times_12 == 0) begin
                                    rotate_times_12 <= 3;
                                end else begin
                                    rotate_times_12 <= rotate_times_12 - 1;
                                end
                            end else begin
                                if (rotate_times_12 == 3) begin
                                    rotate_times_12 <= 0;
                                end else begin
                                    rotate_times_12 <= rotate_times_12 + 1;
                                end
                            end
                        end                
                    endcase
                end
            end    
        end
    end

    always @(*) begin
        if (ph == 0 && pv == 0) begin
            area = Area[0];
        end else if (ph == 1 && pv == 0) begin
            area = Area[1];
        end else if (ph == 2 && pv == 0) begin
            area = Area[2];
        end else if (ph == 3 && pv == 0) begin
            area = Area[3];
        end else if (ph == 0 && pv == 1) begin
            area = Area[4];
        end else if (ph == 1 && pv == 1) begin
            area = Area[5];
        end else if (ph == 2 && pv == 1) begin
            area = Area[6];
        end else if (ph == 3 && pv == 1) begin
            area = Area[7];
        end else if (ph == 0 && pv == 2) begin
            area = Area[8];
        end else if (ph == 1 && pv == 2) begin
            area = Area[9];
        end else if (ph == 2 && pv == 2) begin
            area = Area[10];
        end else if (ph == 3 && pv == 2) begin
            area = Area[11];
        end
    end

    always @(*) begin
        case(area)
            Area[0]:begin
                if (de_hold) rotate_times = 0;
                else rotate_times = rotate_times_1;
            end 
            Area[1]: begin
                if (de_hold) rotate_times = 0;
                else rotate_times = rotate_times_2;
            end 
            Area[2]: begin
                if (de_hold) rotate_times = 0;
                else rotate_times = rotate_times_3;
            end 
            Area[3]: begin
                if (de_hold) rotate_times = 0;
                else rotate_times = rotate_times_4;
            end 
            Area[4]:begin
                if (de_hold) rotate_times = 0;
                else rotate_times = rotate_times_5;
            end 
            Area[5]:begin
                if (de_hold) rotate_times = 0;
                else rotate_times = rotate_times_6;
            end 
            Area[6]:begin
                if (de_hold) rotate_times = 0;
                else rotate_times = rotate_times_7;
            end 
            Area[7]:begin
                if (de_hold) rotate_times = 0;
                else rotate_times = rotate_times_8;
            end 
            Area[8]:begin
                if (de_hold) rotate_times = 0;
                else rotate_times = rotate_times_9;
            end 
            Area[9]:begin
                if (de_hold) rotate_times = 0;
                else rotate_times = rotate_times_10;
            end 
            Area[10]:begin
                if (de_hold) rotate_times = 0;
                else rotate_times = rotate_times_11;
            end 
            Area[11]:begin
                if (de_hold) rotate_times = 0;
                else rotate_times = rotate_times_12;
            end 
        endcase
    end

    always @(*) begin
        case(rotate_times)
            0: pixel_addr = ((h_cnt>>1)+320*(v_cnt>>1))% 76800;
            1: pixel_addr = (((v_cnt - 160 * pv) + 160 * ph) >> 1 ) + 320 * ((159 - (h_cnt - 160 * ph) + 160 * pv) >>1 );
            2: pixel_addr = ((159 - (h_cnt - 160 * ph) + 160 * ph) >> 1 ) + 320 * ((159 - (v_cnt - 160 * pv) + 160 * pv) >> 1);
            3: pixel_addr = ((159 - (v_cnt - 160 * pv) + 160 * ph) >> 1 ) + 320 * (((h_cnt - 160 * ph) + 160 * pv) >> 1 );
        endcase
    end

    assign pass = (rotate_times_1 == 0 && rotate_times_2 == 0 && rotate_times_3 == 0 
                && rotate_times_4 == 0 && rotate_times_5 == 0 && rotate_times_6 == 0 
                && rotate_times_7 == 0 && rotate_times_8 == 0 && rotate_times_9 == 0 
                && rotate_times_10 == 0 && rotate_times_11 == 0 && rotate_times_12 == 0 ) ? 1'b1 : 1'b0;
endmodule