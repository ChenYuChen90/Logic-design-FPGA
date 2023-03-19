`define silence   32'd50000000
`define oc      32'd131     // C2
`define hc2     32'd138     // #C2
`define od      32'd147     // D2
`define hd2     32'd155     // #D2
`define oe      32'd165     // E2
`define of      32'd174     // F2
`define hf2     32'd185     // #F2
`define og      32'd196     // G2
`define hg2     32'd207     // #G2
`define oa      32'd220     // A2
`define ha2     32'd233     // #A2
`define ob      32'd247     // B2

`define c       32'd262     // C3
`define hc3     32'd277     // #C3
`define d       32'd294     // D3
`define hd3     32'd311     // #D3
`define e       32'd330     // E3
`define f       32'd349     // F3
`define hf3     32'd369     // #F3
`define g       32'd392     // G3
`define hg3     32'd415     // #G3
`define a       32'd440     // A3
`define ha3     32'd466     // #A3
`define b       32'd494     // B3

`define hc      32'd524     // C4
`define hc4     32'd554     // #C4
`define hd      32'd588     // D4
`define hd4     32'd622     // #D4
`define he      32'd660     // E4
`define hf      32'd698     // F4
`define hf4     32'd739     // #F4
`define hg      32'd784     // G4
`define hg4     32'd830     // #G4
`define ha      32'd880     // A4
`define ha4     32'd932     // #A4
`define hb      32'd988     // B4


module lab8(
    clk,        // clock from crystal
    rst,        // BTNC: active high reset
    _play,      // SW0: Play/Pause
    _mute,      // SW1: Mute
    _slow,      // SW2: Slow
    _music,     // SW3: Music
    _mode,      // SW15: Mode
    _volUP,     // BTNU: Vol up
    _volDOWN,   // BTND: Vol down
    _higherOCT, // BTNR: Oct higher
    _lowerOCT,  // BTNL: Oct lower
    PS2_DATA,   // Keyboard I/O
    PS2_CLK,    // Keyboard I/O
    _led,       // LED: [15:13] octave & [4:0] volume
    audio_mclk, // master clock
    audio_lrck, // left-right clock
    audio_sck,  // serial clock
    audio_sdin, // serial audio data input
    DISPLAY,    // 7-seg
    DIGIT       // 7-seg
    );

    // I/O declaration
    input clk; 
    input rst; 
    input _play, _mute, _slow, _music, _mode; 
    input _volUP, _volDOWN, _higherOCT, _lowerOCT; 
    inout PS2_DATA; 
	inout PS2_CLK; 
    output reg [15:0] _led; 
    output audio_mclk; 
    output audio_lrck; 
    output audio_sck; 
    output audio_sdin; 
    output [6:0] DISPLAY; 
    output [3:0] DIGIT; 

/*volume octave control*/
    
    // clk
    wire clk_16;
    clock_divider #(16) c16(.clk(clk), .clk_div(clk_16));
    // button
    wire de_volup, de_voldown, de_hioct, de_lowoct;
    wire one_volup, one_voldown, one_hioct, one_lowoct;
    debounce devu(de_volup, _volUP, clk_16);
    debounce dedo(de_voldown, _volDOWN, clk_16);
    debounce deho(de_hioct, _higherOCT, clk_16);
    debounce delo(de_lowoct, _lowerOCT, clk_16);
    onepulse onevu(de_volup, clk_16, one_volup);
    onepulse onedo(de_voldown, clk_16, one_voldown);
    onepulse oneho(de_hioct, clk_16, one_hioct);
    onepulse onelo(de_lowoct, clk_16, one_lowoct);
    reg [3:0] volume, octave;
    always @(posedge clk_16 or posedge rst) begin
        if(rst)begin
            volume <= 4'd3;
        end else begin
            volume <= volume;
            if(one_volup) begin
                if(volume < 4'd5) volume <= volume + 4'd1;
            end else if (one_voldown) begin
                if(volume > 4'd1) volume <= volume - 4'd1;
            end
        end
    end
    always @(*) begin
        case(volume)
            4'd1: _led[4:0] = 5'b00001;
            4'd2: _led[4:0] = 5'b00011;
            4'd3: _led[4:0] = 5'b00111;
            4'd4: _led[4:0] = 5'b01111;
            4'd5: _led[4:0] = 5'b11111;
        endcase
    end
    always @(posedge clk_16 or posedge rst) begin
        if(rst) begin
            octave <= 4'd2;
        end else begin
            octave <= octave;
            if(one_hioct) begin
                if(octave < 4'd3) octave <= octave + 4'd1;
            end else if (one_lowoct) begin
                if(octave > 4'd1) octave <= octave - 4'd1;
            end
        end
    end
    always @(*) begin
        case(octave)
            4'd1: _led[15:13] = 3'b100;
            4'd2: _led[15:13] = 3'b010;
            4'd3: _led[15:13] = 3'b001;
        endcase
    end
    
/*variable*/
    // Internal Signal
    wire [15:0] audio_in_left, audio_in_right;
    wire en;
    wire [11:0] ibeatNum;               // Beat counter
    wire [31:0] freqL, freqR;           // Raw frequency, produced by music module
    wire [31:0] freqL0, freqR0, freqL1, freqR1;
    reg [31:0] k_freqL, k_freqR;
    wire [31:0] r_freqL, r_freqR;
    wire [31:0] new_freqL, new_freqR;
    wire [21:0] freq_outL, freq_outR;    // Processed frequency, adapted to the clock rate of Basys3

    // clkDiv22
    wire clkDiv22;
    clock_divider #(.n(22)) clock_22(.clk(clk), .clk_div(clkDiv22));    // for keyboard and audio
/*7-segment*/
    reg [3:0] note_1, note_2;
    // note_1
    always @(*) begin
        case(r_freqR)
            32'd131: note_1 = 4'd0; //oc
            32'd138: note_1 = 4'd0; //#oc2
            32'd147: note_1 = 4'd1; //od
            32'd155: note_1 = 4'd1; //#od2
            32'd165: note_1 = 4'd2; //oe
            32'd174: note_1 = 4'd3; //of
            32'd185: note_1 = 4'd3; //#of2
            32'd196: note_1 = 4'd4; //og
            32'd207: note_1 = 4'd4; //#og2
            32'd220: note_1 = 4'd5; //oa
            32'd233: note_1 = 4'd5; //#oa2
            32'd247: note_1 = 4'd6; //ob
            32'd262: note_1 = 4'd0; //c
            32'd277: note_1 = 4'd0; //#c3
            32'd294: note_1 = 4'd1; //d
            32'd311: note_1 = 4'd1; //#d3
            32'd330: note_1 = 4'd2; //e
            32'd349: note_1 = 4'd3; //f
            32'd369: note_1 = 4'd3; //#f3
            32'd392: note_1 = 4'd4; //g
            32'd415: note_1 = 4'd4; //#g3
            32'd440: note_1 = 4'd5; //a
            32'd466: note_1 = 4'd5; //#a3
            32'd494: note_1 = 4'd6; //b
            32'd524: note_1 = 4'd0; //hc
            32'd554: note_1 = 4'd0; //#hc4
            32'd588: note_1 = 4'd1; //hd
            32'd622: note_1 = 4'd1; //#hd4
            32'd660: note_1 = 4'd2; //he
            32'd698: note_1 = 4'd3; //hf
            32'd739: note_1 = 4'd3; //#hf4
            32'd784: note_1 = 4'd4; //hg
            32'd830: note_1 = 4'd4; //#hg4
            32'd880: note_1 = 4'd5; //ha
            32'd932: note_1 = 4'd5; //#ha4
            32'd988: note_1 = 4'd6; //hb
            32'd50000000: note_1 = 4'd7;
            default : note_1 = 4'd7; //
        endcase
    end
    // note_2
    always @(*) begin
        case(r_freqR)
            32'd138: note_2 = 4'd8; //#oc2
            32'd155: note_2 = 4'd8; //#od2
            32'd185: note_2 = 4'd8; //#of2
            32'd207: note_2 = 4'd8; //#og2
            32'd233: note_2 = 4'd8; //#oa2
            32'd277: note_2 = 4'd8; //#c3
            32'd311: note_2 = 4'd8; //#d3
            32'd369: note_2 = 4'd8; //#f3
            32'd415: note_2 = 4'd8; //#g3
            32'd466: note_2 = 4'd8; //#a3
            32'd554: note_2 = 4'd8; //#hc4
            32'd622: note_2 = 4'd8; //#hd4
            32'd739: note_2 = 4'd8; //#hf4
            32'd830: note_2 = 4'd8; //#hg4
            32'd932: note_2 = 4'd8; //#ha4
            32'd50000000: note_2 = 4'd7;
            default : note_2 = 4'd7; //
        endcase
    end
    seven_segment_display sev(clk, note_1, note_2, 4'd7, 4'd7, DIGIT, DISPLAY);
/*module*/
    wire clk_music;
    clock_counter(clk, clk_music);
    // Player Control
    // [in]  reset, clock, _play, _slow, _music, and _mode
    // [out] beat number
    player_control #(.LEN(1023)) playerCtrl_00 ( 
        .clk(clk_music),
        .reset(rst),
        ._play(_play),
        ._mute(_mute),
        ._slow(_slow), 
        ._mode(_mode),
        ._music(_music),
        .ibeat(ibeatNum),
        .en(en)
    );
    // Music module
    // [in]  beat number and en
    // [out] left & right raw frequency
    music_example music_00 (
        .ibeatNum(ibeatNum),
        .en(en),
        .toneL(freqL0),
        .toneR(freqR0)
    );
    music_example1 music_01 (
        .ibeatNum(ibeatNum),
        .en(en),
        .toneL(freqL1),
        .toneR(freqR1)
    );
    // Note generation
    // [in]  processed frequency
    // [out] audio wave signal (using square wave here)
    note_gen noteGen_00(
        .clk(clk), 
        .rst(rst), 
        .volume(volume),
        .note_div_left(freq_outL), 
        .note_div_right(freq_outR), 
        .audio_left(audio_in_left),     // left sound audio
        .audio_right(audio_in_right)    // right sound audio
    );

    // Speaker controller
    speaker_control sc(
        .clk(clk), 
        .rst(rst), 
        .audio_in_left(audio_in_left),      // left channel audio data input
        .audio_in_right(audio_in_right),    // right channel audio data input
        .audio_mclk(audio_mclk),            // master clock
        .audio_lrck(audio_lrck),            // left-right clock
        .audio_sck(audio_sck),              // serial clock
        .audio_sdin(audio_sdin)             // serial audio data input
    );
/*keyboard*/
    wire [511:0] key_down;
	wire [8:0] last_change;
	wire been_ready;
	parameter [8:0] KEY_CODES [0:11] = {
        9'b0_0001_1100,	//A
		9'b0_0001_1101,	//W
		9'b0_0001_1011,	//S
		9'b0_0010_0100,	//E
		9'b0_0010_0011,	//D
		9'b0_0010_1011,	//F
		9'b0_0010_1100,	//T
		9'b0_0011_0100,	//G
		9'b0_0011_0101,	//Y
		9'b0_0011_0011,	//H
		9'b0_0011_1100,	//U
		9'b0_0011_1011	//J
    };
	KeyboardDecoder key(.rst(reset),.clk(clk),
						.PS2_DATA(PS2_DATA),
						.PS2_CLK(PS2_CLK),
						.key_down(key_down),
						.last_change(last_change),
						.key_valid(been_ready));
    always @(posedge clk or posedge rst) begin
        if(rst)begin
            k_freqL <= 32'd50000000;
        end else begin
            k_freqL <= 32'd50000000;
            if(key_down[last_change]) begin
                case(last_change)
                    KEY_CODES[0]: k_freqL <= 32'd262;
                    KEY_CODES[1]: k_freqL <= 32'd277;
                    KEY_CODES[2]: k_freqL <= 32'd294;
                    KEY_CODES[3]: k_freqL <= 32'd311;
                    KEY_CODES[4]: k_freqL <= 32'd330;
                    KEY_CODES[5]: k_freqL <= 32'd349;
                    KEY_CODES[6]: k_freqL <= 32'd369;
                    KEY_CODES[7]: k_freqL <= 32'd392;
                    KEY_CODES[8]: k_freqL <= 32'd415;
                    KEY_CODES[9]: k_freqL <= 32'd440;
                    KEY_CODES[10]: k_freqL <= 32'd466;
                    KEY_CODES[11]: k_freqL <= 32'd494;
                    default : k_freqL <= 32'd50000000;
                endcase
            end
        end
    end
    always @(posedge clk or posedge rst) begin
        if(rst)begin
            k_freqR <= 32'd50000000;
        end else begin
            k_freqR <= 32'd50000000;
            if(key_down[last_change]) begin
                case(last_change)
                    KEY_CODES[0]: k_freqR <= 32'd262;
                    KEY_CODES[1]: k_freqR <= 32'd277;
                    KEY_CODES[2]: k_freqR <= 32'd294;
                    KEY_CODES[3]: k_freqR <= 32'd311;
                    KEY_CODES[4]: k_freqR <= 32'd330;
                    KEY_CODES[5]: k_freqR <= 32'd349;
                    KEY_CODES[6]: k_freqR <= 32'd369;
                    KEY_CODES[7]: k_freqR <= 32'd392;
                    KEY_CODES[8]: k_freqR <= 32'd415;
                    KEY_CODES[9]: k_freqR <= 32'd440;
                    KEY_CODES[10]: k_freqR <= 32'd466;
                    KEY_CODES[11]: k_freqR <= 32'd494;
                    default : k_freqR <= 32'd50000000;
                endcase
            end
        end
    end
/*frequency*/
    // freq_outL, freq_outR
    assign freqL = (_music == 1) ? freqL1 : freqL0;
    assign freqR = (_music == 1) ? freqR1 : freqR0;

    assign r_freqL = (_mode == 1) ? freqL : k_freqL;
    assign r_freqR = (_mode == 1) ? freqR : k_freqR;

    assign new_freqL = (_mute == 1) ? 32'd50000000 : (octave == 2) ? r_freqL : (octave == 3) ? (r_freqL*2) : (r_freqL/2);
    assign new_freqR = (_mute == 1) ? 32'd50000000 : (octave == 2) ? r_freqR : (octave == 3) ? (r_freqR*2) : (r_freqR/2);
    // Note gen makes no sound, if freq_out = 50000000 / `silence = 1
    assign freq_outL = 50000000 / new_freqL;
    assign freq_outR = 50000000 / new_freqR;
endmodule

module seven_segment_display (
    input clk,
    input [3:0] number_0,
    input [3:0] number_1,
    input [3:0] number_2,
    input [3:0] number_3,
    output reg [3:0] digit,
    output reg [6:0] display
    );
    wire clk_seg;
    wire [3:0] next_digit;
    reg [3:0] display_number;

    clock_divider #(16) C16(.clk(clk), .clk_div(clk_seg));

    assign next_digit = digit ? {digit[2:0], digit[3]} : 4'b1110;

    always @(posedge clk_seg) begin
        digit <= next_digit;
    end

    always @* begin
        case (digit)
            4'b1110: display_number = number_0;
            4'b1101: display_number = number_1;
            4'b1011: display_number = number_2;
            4'b0111: display_number = number_3;
            default: display_number = 4'd15;
        endcase
    end

    always @* begin
        case (display_number)  // cdefgab
            4'd0: display    = 7'b0100_111;     //c
            4'd1: display    = 7'b0100_001;     //d
            4'd2: display    = 7'b0000_110;     //E
            4'd3: display    = 7'b0001_110;     //F
            4'd4: display    = 7'b1000_010;     //G
            4'd5: display    = 7'b0100_000;     //a
            4'd6: display    = 7'b0000_011;     //b
            4'd7: display    = 7'b0111_111;     //-
            4'd8: display    = 7'b0011_100;     //# (shap notation)
            4'd9: display    = 7'b0000_011;     //b (flat notation)
            default: display = 7'b0111_111; // ERROR
        endcase
    end
endmodule

module clock_counter(clk, clk_div);  
    parameter n = 26;     
    input clk;   
    output clk_div;   
    
    reg [22:0] num;
    wire [22:0] next_num;
    
    always@(posedge clk)begin
    	num<=next_num;
    end
    
    assign next_num = (num == 3000000)? 0 : num +1;
    assign clk_div = (num == 3000000) ? 1 : 0;
    
endmodule
