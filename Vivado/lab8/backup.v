`define sil     32'd50000000
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


module backup(
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
    // Player Control
    // [in]  reset, clock, _play, _slow, _music, and _mode
    // [out] beat number
    player_control #(.LEN(512)) playerCtrl_00 ( 
        .clk(clkDiv22),
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
module player_control (
	input clk,
	input reset, 
	input _play,
	input _mute,
	input _slow, 
	input _mode,
	input _music,
	output reg [11:0] ibeat,
	output wire en
	);
	parameter LEN = 4095;
    reg [11:0] next_ibeat_d;
	reg slow;
	reg origin, switch;
	always @(posedge clk) begin
		if(_music)begin
			if(_music == origin)begin
				switch <= 0;
				origin <= _music;
			end else begin
				switch <= 1;
				origin <= _music;
			end
		end else begin
			if(_music == origin)begin
				switch <= 0;
				origin <= _music;
			end else begin
				switch <= 1;
				origin <= _music;
			end
		end
	end
/*demostrate*/
    always @* begin
        next_ibeat_d = (_mode == 1 && (ibeat + 1 < LEN)) ? (ibeat + 1) : 0;
    end
/**/
	always @(posedge clk or posedge reset) begin
		if (reset) begin
			ibeat <= 0;
		end else begin
			ibeat <= ibeat;
			if (_mode == 1) begin
				if(switch == 0) begin
					if(_play == 1'b1) begin
						if(_slow == 1'b1) begin
							if(slow)begin
								ibeat <= next_ibeat_d;
								slow <= ~slow;
							end else begin
								ibeat <= ibeat;
								slow <= ~slow;
							end 
						end else begin
							ibeat <= next_ibeat_d;
						end
					end
				end else ibeat <= 0;
			end
		end
	end
	assign en = (_mode == 1 && (_play == 1'b0)) || (_mode == 0 ) ? 0 : 1;

endmodule

module music_example (
	input [11:0] ibeatNum,
	input en,
	output reg [31:0] toneL,
    output reg [31:0] toneR
    );

    always @* begin
        if(en == 1) begin
            case(ibeatNum)
                // --- Song 1 ---
                // --- Measure 1 ---
                12'd0: toneR = `hg;      12'd1: toneR = `hg; // HG (half-beat)
                12'd2: toneR = `hg;      12'd3: toneR = `hg;
                12'd4: toneR = `hg;      12'd5: toneR = `hg;
                12'd6: toneR = `hg;      12'd7: toneR = `hg;
                12'd8: toneR = `he;      12'd9: toneR = `he; // HE (half-beat)
                12'd10: toneR = `he;     12'd11: toneR = `he;
                12'd12: toneR = `he;     12'd13: toneR = `he;
                12'd14: toneR = `he;     12'd15: toneR = `sil; // (Short break for repetitive notes: high E)

                12'd16: toneR = `he;     12'd17: toneR = `he; // HE (one-beat)
                12'd18: toneR = `he;     12'd19: toneR = `he;
                12'd20: toneR = `he;     12'd21: toneR = `he;
                12'd22: toneR = `he;     12'd23: toneR = `he;
                12'd24: toneR = `he;     12'd25: toneR = `he;
                12'd26: toneR = `he;     12'd27: toneR = `he;
                12'd28: toneR = `he;     12'd29: toneR = `he;
                12'd30: toneR = `he;     12'd31: toneR = `he;

                12'd32: toneR = `hf;     12'd33: toneR = `hf; // HF (half-beat)
                12'd34: toneR = `hf;     12'd35: toneR = `hf;
                12'd36: toneR = `hf;     12'd37: toneR = `hf;
                12'd38: toneR = `hf;     12'd39: toneR = `hf;
                12'd40: toneR = `hd;     12'd41: toneR = `hd; // HD (half-beat)
                12'd42: toneR = `hd;     12'd43: toneR = `hd;
                12'd44: toneR = `hd;     12'd45: toneR = `hd;
                12'd46: toneR = `hd;     12'd47: toneR = `sil; // (Short break for repetitive notes: high D)

                12'd48: toneR = `hd;     12'd49: toneR = `hd; // HD (one-beat)
                12'd50: toneR = `hd;     12'd51: toneR = `hd;
                12'd52: toneR = `hd;     12'd53: toneR = `hd;
                12'd54: toneR = `hd;     12'd55: toneR = `hd;
                12'd56: toneR = `hd;     12'd57: toneR = `hd;
                12'd58: toneR = `hd;     12'd59: toneR = `hd;
                12'd60: toneR = `hd;     12'd61: toneR = `hd;
                12'd62: toneR = `hd;     12'd63: toneR = `hd;

                // --- Measure 2 ---
                12'd64: toneR = `hc;     12'd65: toneR = `hc; // HC (half-beat)
                12'd66: toneR = `hc;     12'd67: toneR = `hc;
                12'd68: toneR = `hc;     12'd69: toneR = `hc;
                12'd70: toneR = `hc;     12'd71: toneR = `hc;
                12'd72: toneR = `hd;     12'd73: toneR = `hd; // HD (half-beat)
                12'd74: toneR = `hd;     12'd75: toneR = `hd;
                12'd76: toneR = `hd;     12'd77: toneR = `hd;
                12'd78: toneR = `hd;     12'd79: toneR = `hd;

                12'd80: toneR = `he;     12'd81: toneR = `he; // HE (half-beat)
                12'd82: toneR = `he;     12'd83: toneR = `he;
                12'd84: toneR = `he;     12'd85: toneR = `he;
                12'd86: toneR = `he;     12'd87: toneR = `he;
                12'd88: toneR = `hf;     12'd89: toneR = `hf; // HF (half-beat)
                12'd90: toneR = `hf;     12'd91: toneR = `hf;
                12'd92: toneR = `hf;     12'd93: toneR = `hf;
                12'd94: toneR = `hf;     12'd95: toneR = `hf;

                12'd96: toneR = `hg;     12'd97: toneR = `hg; // HG (half-beat)
                12'd98: toneR = `hg;     12'd99: toneR = `hg;
                12'd100: toneR = `hg;    12'd101: toneR = `hg;
                12'd102: toneR = `hg;    12'd103: toneR = `sil; // (Short break for repetitive notes: high D)
                12'd104: toneR = `hg;    12'd105: toneR = `hg; // HG (half-beat)
                12'd106: toneR = `hg;    12'd107: toneR = `hg;
                12'd108: toneR = `hg;    12'd109: toneR = `hg;
                12'd110: toneR = `hg;    12'd111: toneR = `sil; // (Short break for repetitive notes: high D)

                12'd112: toneR = `hg;    12'd113: toneR = `hg; // HG (one-beat)
                12'd114: toneR = `hg;    12'd115: toneR = `hg;
                12'd116: toneR = `hg;    12'd117: toneR = `hg;
                12'd118: toneR = `hg;    12'd119: toneR = `hg;
                12'd120: toneR = `hg;    12'd121: toneR = `hg;
                12'd122: toneR = `hg;    12'd123: toneR = `hg;
                12'd124: toneR = `hg;    12'd125: toneR = `hg;
                12'd126: toneR = `hg;    12'd127: toneR = `sil;
                
                // --- Measure 3 ---
                12'd128: toneR = `hg;     12'd129: toneR = `hg;
                12'd130: toneR = `hg;     12'd131: toneR = `hg;
                12'd132: toneR = `hg;     12'd133: toneR = `hg;
                12'd134: toneR = `hg;     12'd135: toneR = `hg;

                12'd136: toneR = `he;     12'd137: toneR = `he;
                12'd138: toneR = `he;     12'd139: toneR = `he;
                12'd140: toneR = `he;     12'd141: toneR = `he;
                12'd142: toneR = `he;     12'd143: toneR = `sil;

                12'd144: toneR = `he;     12'd145: toneR = `he;
                12'd146: toneR = `he;     12'd147: toneR = `he;
                12'd148: toneR = `he;     12'd149: toneR = `he;
                12'd150: toneR = `he;     12'd151: toneR = `he;
                12'd152: toneR = `he;     12'd153: toneR = `he;
                12'd154: toneR = `he;     12'd155: toneR = `he;
                12'd156: toneR = `he;     12'd157: toneR = `he;
                12'd158: toneR = `he;     12'd159: toneR = `he;

                12'd160: toneR = `hf;     12'd161: toneR = `hf;
                12'd162: toneR = `hf;     12'd163: toneR = `hf;
                12'd164: toneR = `hf;     12'd165: toneR = `hf;
                12'd166: toneR = `hf;     12'd167: toneR = `hf;

                12'd168: toneR = `hd;     12'd169: toneR = `hd;
                12'd170: toneR = `hd;     12'd171: toneR = `hd;
                12'd172: toneR = `hd;     12'd173: toneR = `hd;
                12'd174: toneR = `hd;     12'd175: toneR = `sil;

                12'd176: toneR = `hd;     12'd177: toneR = `hd;
                12'd178: toneR = `hd;     12'd179: toneR = `hd;
                12'd180: toneR = `hd;     12'd181: toneR = `hd;
                12'd182: toneR = `hd;     12'd183: toneR = `hd;
                12'd184: toneR = `hd;     12'd185: toneR = `hd;
                12'd186: toneR = `hd;     12'd187: toneR = `hd;
                12'd188: toneR = `hd;     12'd189: toneR = `hd;
                12'd190: toneR = `hd;     12'd191: toneR = `hd;
                // --- Measure 4 ---
                12'd192: toneR = `hc;     12'd193: toneR = `hc;
                12'd194: toneR = `hc;     12'd195: toneR = `hc;
                12'd196: toneR = `hc;     12'd197: toneR = `hc;
                12'd198: toneR = `hc;     12'd199: toneR = `hc;

                12'd200: toneR = `he;     12'd201: toneR = `he;
                12'd202: toneR = `he;     12'd203: toneR = `he;
                12'd204: toneR = `he;     12'd205: toneR = `he;
                12'd206: toneR = `he;     12'd207: toneR = `he;

                12'd208: toneR = `hg;     12'd209: toneR = `hg;
                12'd210: toneR = `hg;     12'd211: toneR = `hg;
                12'd212: toneR = `hg;     12'd213: toneR = `hg;
                12'd214: toneR = `hg;     12'd215: toneR = `sil;

                12'd216: toneR = `hg;     12'd217: toneR = `hg;
                12'd218: toneR = `hg;     12'd219: toneR = `hg;
                12'd220: toneR = `hg;     12'd221: toneR = `hg;
                12'd222: toneR = `hg;     12'd223: toneR = `hg;

                12'd224: toneR = `he;     12'd225: toneR = `he;
                12'd226: toneR = `he;     12'd227: toneR = `he;
                12'd228: toneR = `he;     12'd229: toneR = `he;
                12'd230: toneR = `he;     12'd231: toneR = `sil;

                12'd232: toneR = `he;     12'd233: toneR = `he;
                12'd234: toneR = `he;     12'd235: toneR = `he;
                12'd236: toneR = `he;     12'd237: toneR = `he;
                12'd238: toneR = `he;     12'd239: toneR = `sil;

                12'd240: toneR = `he;     12'd241: toneR = `he;
                12'd242: toneR = `he;     12'd243: toneR = `he;
                12'd244: toneR = `he;     12'd245: toneR = `he;
                12'd246: toneR = `he;     12'd247: toneR = `he;
                12'd248: toneR = `he;     12'd249: toneR = `he;
                12'd250: toneR = `he;     12'd251: toneR = `he;
                12'd252: toneR = `he;     12'd253: toneR = `he;
                12'd254: toneR = `he;     12'd255: toneR = `he;
                // --- Measure 5 ---
                12'd256: toneR = `hd;     12'd257: toneR = `hd;
                12'd258: toneR = `hd;     12'd259: toneR = `hd;
                12'd260: toneR = `hd;     12'd261: toneR = `hd;
                12'd262: toneR = `hd;     12'd263: toneR = `sil;

                12'd264: toneR = `hd;     12'd265: toneR = `hd;
                12'd266: toneR = `hd;     12'd267: toneR = `hd;
                12'd268: toneR = `hd;     12'd269: toneR = `hd;
                12'd270: toneR = `hd;     12'd271: toneR = `sil;

                12'd272: toneR = `hd;     12'd273: toneR = `hd;
                12'd274: toneR = `hd;     12'd275: toneR = `hd;
                12'd276: toneR = `hd;     12'd277: toneR = `hd;
                12'd278: toneR = `hd;     12'd279: toneR = `sil;

                12'd280: toneR = `hd;     12'd281: toneR = `hd;
                12'd282: toneR = `hd;     12'd283: toneR = `hd;
                12'd284: toneR = `hd;     12'd285: toneR = `hd;
                12'd286: toneR = `hd;     12'd287: toneR = `sil;

                12'd288: toneR = `hd;     12'd289: toneR = `hd;
                12'd290: toneR = `hd;     12'd291: toneR = `hd;
                12'd292: toneR = `hd;     12'd293: toneR = `hd;
                12'd294: toneR = `hd;     12'd295: toneR = `hd;

                12'd296: toneR = `he;     12'd297: toneR = `he;
                12'd298: toneR = `he;     12'd299: toneR = `he;
                12'd300: toneR = `he;     12'd301: toneR = `he;
                12'd302: toneR = `he;     12'd303: toneR = `he;

                12'd304: toneR = `hf;     12'd305: toneR = `hf;
                12'd306: toneR = `hf;     12'd307: toneR = `hf;
                12'd308: toneR = `hf;     12'd309: toneR = `hf;
                12'd310: toneR = `hf;     12'd311: toneR = `hf;
                12'd312: toneR = `hf;     12'd313: toneR = `hf;
                12'd314: toneR = `hf;     12'd315: toneR = `hf;
                12'd316: toneR = `hf;     12'd317: toneR = `hf;
                12'd318: toneR = `hf;     12'd319: toneR = `hf;
                // --- Measure 6 ---
                12'd320: toneR = `he;     12'd321: toneR = `he;
                12'd322: toneR = `he;     12'd323: toneR = `he;
                12'd324: toneR = `he;     12'd325: toneR = `he;
                12'd326: toneR = `he;     12'd327: toneR = `sil;

                12'd328: toneR = `he;     12'd329: toneR = `he;
                12'd330: toneR = `he;     12'd331: toneR = `he;
                12'd332: toneR = `he;     12'd333: toneR = `he;
                12'd334: toneR = `he;     12'd335: toneR = `sil;

                12'd336: toneR = `he;     12'd337: toneR = `he;
                12'd338: toneR = `he;     12'd339: toneR = `he;
                12'd340: toneR = `he;     12'd341: toneR = `he;
                12'd342: toneR = `he;     12'd343: toneR = `sil;

                12'd344: toneR = `he;     12'd345: toneR = `he;
                12'd346: toneR = `he;     12'd347: toneR = `he;
                12'd348: toneR = `he;     12'd349: toneR = `he;
                12'd350: toneR = `he;     12'd351: toneR = `sil;

                12'd352: toneR = `he;     12'd353: toneR = `he;
                12'd354: toneR = `he;     12'd355: toneR = `he;
                12'd356: toneR = `he;     12'd357: toneR = `he;
                12'd358: toneR = `he;     12'd359: toneR = `he;

                12'd360: toneR = `hf;     12'd361: toneR = `hf;
                12'd362: toneR = `hf;     12'd363: toneR = `hf;
                12'd364: toneR = `hf;     12'd365: toneR = `hf;
                12'd366: toneR = `hf;     12'd367: toneR = `hf;

                12'd368: toneR = `hg;     12'd369: toneR = `hg;
                12'd370: toneR = `hg;     12'd371: toneR = `hg;
                12'd372: toneR = `hg;     12'd373: toneR = `hg;
                12'd374: toneR = `hg;     12'd375: toneR = `hg;
                12'd376: toneR = `hg;     12'd377: toneR = `hg;
                12'd378: toneR = `hg;     12'd379: toneR = `hg;
                12'd380: toneR = `hg;     12'd381: toneR = `hg;
                12'd382: toneR = `hg;     12'd383: toneR = `sil;
                // --- Measure 7 ---
                12'd384: toneR = `hg;     12'd385: toneR = `hg;
                12'd386: toneR = `hg;     12'd387: toneR = `hg;
                12'd388: toneR = `hg;     12'd389: toneR = `hg;
                12'd390: toneR = `hg;     12'd391: toneR = `hg;

                12'd392: toneR = `he;     12'd393: toneR = `he;
                12'd394: toneR = `he;     12'd395: toneR = `he;
                12'd396: toneR = `he;     12'd397: toneR = `he;
                12'd398: toneR = `he;     12'd399: toneR = `sil;

                12'd400: toneR = `he;     12'd401: toneR = `he;
                12'd402: toneR = `he;     12'd403: toneR = `he;
                12'd404: toneR = `he;     12'd405: toneR = `he;
                12'd406: toneR = `he;     12'd407: toneR = `he;
                12'd408: toneR = `he;     12'd409: toneR = `he;
                12'd410: toneR = `he;     12'd411: toneR = `he;
                12'd412: toneR = `he;     12'd413: toneR = `he;
                12'd414: toneR = `he;     12'd415: toneR = `he;

                12'd416: toneR = `hf;     12'd417: toneR = `hf;
                12'd418: toneR = `hf;     12'd419: toneR = `hf;
                12'd420: toneR = `hf;     12'd421: toneR = `hf;
                12'd422: toneR = `hf;     12'd423: toneR = `hf;

                12'd424: toneR = `hd;     12'd425: toneR = `hd;
                12'd426: toneR = `hd;     12'd427: toneR = `hd;
                12'd428: toneR = `hd;     12'd429: toneR = `hd;
                12'd430: toneR = `hd;     12'd431: toneR = `sil;

                12'd432: toneR = `hd;     12'd433: toneR = `hd;
                12'd434: toneR = `hd;     12'd435: toneR = `hd;
                12'd436: toneR = `hd;     12'd437: toneR = `hd;
                12'd438: toneR = `hd;     12'd439: toneR = `hd;
                12'd440: toneR = `hd;     12'd441: toneR = `hd;
                12'd442: toneR = `hd;     12'd443: toneR = `hd;
                12'd444: toneR = `hd;     12'd445: toneR = `hd;
                12'd446: toneR = `hd;     12'd447: toneR = `hd;
                // --- Measure 8 ---
                12'd448: toneR = `hc;     12'd449: toneR = `hc;
                12'd450: toneR = `hc;     12'd451: toneR = `hc;
                12'd452: toneR = `hc;     12'd453: toneR = `hc;
                12'd454: toneR = `hc;     12'd455: toneR = `sil;

                12'd456: toneR = `hc;     12'd457: toneR = `hc;
                12'd458: toneR = `hc;     12'd459: toneR = `hc;
                12'd460: toneR = `hc;     12'd461: toneR = `hc;
                12'd462: toneR = `hc;     12'd463: toneR = `hc;

                12'd464: toneR = `hg;     12'd465: toneR = `hg;
                12'd466: toneR = `hg;     12'd467: toneR = `hg;
                12'd468: toneR = `hg;     12'd469: toneR = `hg;
                12'd470: toneR = `hg;     12'd471: toneR = `sil;

                12'd472: toneR = `hg;     12'd473: toneR = `hg;
                12'd474: toneR = `hg;     12'd475: toneR = `hg;
                12'd476: toneR = `hg;     12'd477: toneR = `hg;
                12'd478: toneR = `hg;     12'd479: toneR = `hg;

                12'd480: toneR = `hc;     12'd481: toneR = `hc;
                12'd482: toneR = `hc;     12'd483: toneR = `hc;
                12'd484: toneR = `hc;     12'd485: toneR = `hc;
                12'd486: toneR = `hc;     12'd487: toneR = `hc;
                12'd488: toneR = `hc;     12'd489: toneR = `hc;
                12'd490: toneR = `hc;     12'd491: toneR = `hc;
                12'd492: toneR = `hc;     12'd493: toneR = `hc;
                12'd494: toneR = `hc;     12'd495: toneR = `hc;
                12'd496: toneR = `hc;     12'd497: toneR = `hc;
                12'd498: toneR = `hc;     12'd499: toneR = `hc;
                12'd500: toneR = `hc;     12'd501: toneR = `hc;
                12'd502: toneR = `hc;     12'd503: toneR = `hc;
                12'd504: toneR = `hc;     12'd505: toneR = `hc;
                12'd506: toneR = `hc;     12'd507: toneR = `hc;
                12'd508: toneR = `hc;     12'd509: toneR = `hc;
                12'd510: toneR = `hc;     12'd511: toneR = `hc;
                default: toneR = `sil;
            endcase
        end else begin
            toneR = `sil;
        end
    end

    always @(*) begin
        if(en == 1)begin
            case(ibeatNum)
                // --- Measure 1 ---
                12'd0: toneL = `hc;  	12'd1: toneL = `hc; // HC (two-beat)
                12'd2: toneL = `hc;  	12'd3: toneL = `hc;
                12'd4: toneL = `hc;	    12'd5: toneL = `hc;
                12'd6: toneL = `hc;  	12'd7: toneL = `hc;
                12'd8: toneL = `hc;	    12'd9: toneL = `hc;
                12'd10: toneL = `hc;	12'd11: toneL = `hc;
                12'd12: toneL = `hc;	12'd13: toneL = `hc;
                12'd14: toneL = `hc;	12'd15: toneL = `hc;

                12'd16: toneL = `hc;	12'd17: toneL = `hc;
                12'd18: toneL = `hc;	12'd19: toneL = `hc;
                12'd20: toneL = `hc;	12'd21: toneL = `hc;
                12'd22: toneL = `hc;	12'd23: toneL = `hc;
                12'd24: toneL = `hc;	12'd25: toneL = `hc;
                12'd26: toneL = `hc;	12'd27: toneL = `hc;
                12'd28: toneL = `hc;	12'd29: toneL = `hc;
                12'd30: toneL = `hc;	12'd31: toneL = `hc;

                12'd32: toneL = `g;	    12'd33: toneL = `g; // G (one-beat)
                12'd34: toneL = `g;	    12'd35: toneL = `g;
                12'd36: toneL = `g;	    12'd37: toneL = `g;
                12'd38: toneL = `g;	    12'd39: toneL = `g;
                12'd40: toneL = `g;	    12'd41: toneL = `g;
                12'd42: toneL = `g;	    12'd43: toneL = `g;
                12'd44: toneL = `g;	    12'd45: toneL = `g;
                12'd46: toneL = `g;	    12'd47: toneL = `g;

                12'd48: toneL = `b;	    12'd49: toneL = `b; // B (one-beat)
                12'd50: toneL = `b;	    12'd51: toneL = `b;
                12'd52: toneL = `b;	    12'd53: toneL = `b;
                12'd54: toneL = `b;	    12'd55: toneL = `b;
                12'd56: toneL = `b;	    12'd57: toneL = `b;
                12'd58: toneL = `b;	    12'd59: toneL = `b;
                12'd60: toneL = `b;	    12'd61: toneL = `b;
                12'd62: toneL = `b;	    12'd63: toneL = `b;
                // --- Measure 2 ---
                12'd64: toneL = `hc;	12'd65: toneL = `hc; // HC (two-beat)
                12'd66: toneL = `hc;    12'd67: toneL = `hc;
                12'd68: toneL = `hc;	12'd69: toneL = `hc;
                12'd70: toneL = `hc;	12'd71: toneL = `hc;
                12'd72: toneL = `hc;	12'd73: toneL = `hc;
                12'd74: toneL = `hc;	12'd75: toneL = `hc;
                12'd76: toneL = `hc;	12'd77: toneL = `hc;
                12'd78: toneL = `hc;	12'd79: toneL = `hc;

                12'd80: toneL = `hc;	12'd81: toneL = `hc;
                12'd82: toneL = `hc;    12'd83: toneL = `hc;
                12'd84: toneL = `hc;    12'd85: toneL = `hc;
                12'd86: toneL = `hc;    12'd87: toneL = `hc;
                12'd88: toneL = `hc;    12'd89: toneL = `hc;
                12'd90: toneL = `hc;    12'd91: toneL = `hc;
                12'd92: toneL = `hc;    12'd93: toneL = `hc;
                12'd94: toneL = `hc;    12'd95: toneL = `hc;

                12'd96: toneL = `g;	    12'd97: toneL = `g; // G (one-beat)
                12'd98: toneL = `g; 	12'd99: toneL = `g;
                12'd100: toneL = `g;	12'd101: toneL = `g;
                12'd102: toneL = `g;	12'd103: toneL = `g;
                12'd104: toneL = `g;	12'd105: toneL = `g;
                12'd106: toneL = `g;	12'd107: toneL = `g;
                12'd108: toneL = `g;	12'd109: toneL = `g;
                12'd110: toneL = `g;	12'd111: toneL = `g;

                12'd112: toneL = `b;	12'd113: toneL = `b; // B (one-beat)
                12'd114: toneL = `b;	12'd115: toneL = `b;
                12'd116: toneL = `b;	12'd117: toneL = `b;
                12'd118: toneL = `b;	12'd119: toneL = `b;
                12'd120: toneL = `b;	12'd121: toneL = `b;
                12'd122: toneL = `b;	12'd123: toneL = `b;
                12'd124: toneL = `b;	12'd125: toneL = `b;
                12'd126: toneL = `b;	12'd127: toneL = `b;
                // --- Measure 3 ---
                12'd128: toneL = `c;     12'd129: toneL = `c;
                12'd130: toneL = `c;     12'd131: toneL = `c;
                12'd132: toneL = `c;     12'd133: toneL = `c;
                12'd134: toneL = `c;     12'd135: toneL = `c;
                12'd136: toneL = `c;     12'd137: toneL = `c;
                12'd138: toneL = `c;     12'd139: toneL = `c;
                12'd140: toneL = `c;     12'd141: toneL = `c;
                12'd142: toneL = `c;     12'd143: toneL = `c;
                12'd144: toneL = `c;     12'd145: toneL = `c;
                12'd146: toneL = `c;     12'd147: toneL = `c;
                12'd148: toneL = `c;     12'd149: toneL = `c;
                12'd150: toneL = `c;     12'd151: toneL = `c;
                12'd152: toneL = `c;     12'd153: toneL = `c;
                12'd154: toneL = `c;     12'd155: toneL = `c;
                12'd156: toneL = `c;     12'd157: toneL = `c;
                12'd158: toneL = `c;     12'd159: toneL = `c;

                12'd160: toneL = `g;     12'd161: toneL = `g;
                12'd162: toneL = `g;     12'd163: toneL = `g;
                12'd164: toneL = `g;     12'd165: toneL = `g;
                12'd166: toneL = `g;     12'd167: toneL = `g;
                12'd168: toneL = `g;     12'd169: toneL = `g;
                12'd170: toneL = `g;     12'd171: toneL = `g;
                12'd172: toneL = `g;     12'd173: toneL = `g;
                12'd174: toneL = `g;     12'd175: toneL = `g;

                12'd176: toneL = `b;     12'd177: toneL = `b;
                12'd178: toneL = `b;     12'd179: toneL = `b;
                12'd180: toneL = `b;     12'd181: toneL = `b;
                12'd182: toneL = `b;     12'd183: toneL = `b;
                12'd184: toneL = `b;     12'd185: toneL = `b;
                12'd186: toneL = `b;     12'd187: toneL = `b;
                12'd188: toneL = `b;     12'd189: toneL = `b;
                12'd190: toneL = `b;     12'd191: toneL = `b;
                // --- Measure 4 ---
                12'd192: toneL = `hc;     12'd193: toneL = `hc;
                12'd194: toneL = `hc;     12'd195: toneL = `hc;
                12'd196: toneL = `hc;     12'd197: toneL = `hc;
                12'd198: toneL = `hc;     12'd199: toneL = `hc;
                12'd200: toneL = `hc;     12'd201: toneL = `hc;
                12'd202: toneL = `hc;     12'd203: toneL = `hc;
                12'd204: toneL = `hc;     12'd205: toneL = `hc;
                12'd206: toneL = `hc;     12'd207: toneL = `hc;

                12'd208: toneL = `g;     12'd209: toneL = `g;
                12'd210: toneL = `g;     12'd211: toneL = `g;
                12'd212: toneL = `g;     12'd213: toneL = `g;
                12'd214: toneL = `g;     12'd215: toneL = `g;
                12'd216: toneL = `g;     12'd217: toneL = `g;
                12'd218: toneL = `g;     12'd219: toneL = `g;
                12'd220: toneL = `g;     12'd221: toneL = `g;
                12'd222: toneL = `g;     12'd223: toneL = `g;

                12'd224: toneL = `e;     12'd225: toneL = `e;
                12'd226: toneL = `e;     12'd227: toneL = `e;
                12'd228: toneL = `e;     12'd229: toneL = `e;
                12'd230: toneL = `e;     12'd231: toneL = `e;
                12'd232: toneL = `e;     12'd233: toneL = `e;
                12'd234: toneL = `e;     12'd235: toneL = `e;
                12'd236: toneL = `e;     12'd237: toneL = `e;
                12'd238: toneL = `e;     12'd239: toneL = `e;

                12'd240: toneL = `c;     12'd241: toneL = `c;
                12'd242: toneL = `c;     12'd243: toneL = `c;
                12'd244: toneL = `c;     12'd245: toneL = `c;
                12'd246: toneL = `c;     12'd247: toneL = `c;
                12'd248: toneL = `c;     12'd249: toneL = `c;
                12'd250: toneL = `c;     12'd251: toneL = `c;
                12'd252: toneL = `c;     12'd253: toneL = `c;
                12'd254: toneL = `c;     12'd255: toneL = `c;
                // --- Measure 5 ---
                12'd256: toneL = `g;     12'd257: toneL = `g;
                12'd258: toneL = `g;     12'd259: toneL = `g;
                12'd260: toneL = `g;     12'd261: toneL = `g;
                12'd262: toneL = `g;     12'd263: toneL = `g;
                12'd264: toneL = `g;     12'd265: toneL = `g;
                12'd266: toneL = `g;     12'd267: toneL = `g;
                12'd268: toneL = `g;     12'd269: toneL = `g;
                12'd270: toneL = `g;     12'd271: toneL = `g;
                12'd272: toneL = `g;     12'd273: toneL = `g;
                12'd274: toneL = `g;     12'd275: toneL = `g;
                12'd276: toneL = `g;     12'd277: toneL = `g;
                12'd278: toneL = `g;     12'd279: toneL = `g;
                12'd280: toneL = `g;     12'd281: toneL = `g;
                12'd282: toneL = `g;     12'd283: toneL = `g;
                12'd284: toneL = `g;     12'd285: toneL = `g;
                12'd286: toneL = `g;     12'd287: toneL = `g;

                12'd288: toneL = `f;     12'd289: toneL = `f;
                12'd290: toneL = `f;     12'd291: toneL = `f;
                12'd292: toneL = `f;     12'd293: toneL = `f;
                12'd294: toneL = `f;     12'd295: toneL = `f;
                12'd296: toneL = `f;     12'd297: toneL = `f;
                12'd298: toneL = `f;     12'd299: toneL = `f;
                12'd300: toneL = `f;     12'd301: toneL = `f;
                12'd302: toneL = `f;     12'd303: toneL = `f;

                12'd304: toneL = `d;     12'd305: toneL = `d;
                12'd306: toneL = `d;     12'd307: toneL = `d;
                12'd308: toneL = `d;     12'd309: toneL = `d;
                12'd310: toneL = `d;     12'd311: toneL = `d;
                12'd312: toneL = `d;     12'd313: toneL = `d;
                12'd314: toneL = `d;     12'd315: toneL = `d;
                12'd316: toneL = `d;     12'd317: toneL = `d;
                12'd318: toneL = `d;     12'd319: toneL = `d;
                // --- Measure 6 ---
                12'd320: toneL = `e;     12'd321: toneL = `e;
                12'd322: toneL = `e;     12'd323: toneL = `e;
                12'd324: toneL = `e;     12'd325: toneL = `e;
                12'd326: toneL = `e;     12'd327: toneL = `e;
                12'd328: toneL = `e;     12'd329: toneL = `e;
                12'd330: toneL = `e;     12'd331: toneL = `e;
                12'd332: toneL = `e;     12'd333: toneL = `e;
                12'd334: toneL = `e;     12'd335: toneL = `e;
                12'd336: toneL = `e;     12'd337: toneL = `e;
                12'd338: toneL = `e;     12'd339: toneL = `e;
                12'd340: toneL = `e;     12'd341: toneL = `e;
                12'd342: toneL = `e;     12'd343: toneL = `e;
                12'd344: toneL = `e;     12'd345: toneL = `e;
                12'd346: toneL = `e;     12'd347: toneL = `e;
                12'd348: toneL = `e;     12'd349: toneL = `e;
                12'd350: toneL = `e;     12'd351: toneL = `e;

                12'd352: toneL = `g;     12'd353: toneL = `g;
                12'd354: toneL = `g;     12'd355: toneL = `g;
                12'd356: toneL = `g;     12'd357: toneL = `g;
                12'd358: toneL = `g;     12'd359: toneL = `g;
                12'd360: toneL = `g;     12'd361: toneL = `g;
                12'd362: toneL = `g;     12'd363: toneL = `g;
                12'd364: toneL = `g;     12'd365: toneL = `g;
                12'd366: toneL = `g;     12'd367: toneL = `g;

                12'd368: toneL = `b;     12'd369: toneL = `b;
                12'd370: toneL = `b;     12'd371: toneL = `b;
                12'd372: toneL = `b;     12'd373: toneL = `b;
                12'd374: toneL = `b;     12'd375: toneL = `b;
                12'd376: toneL = `b;     12'd377: toneL = `b;
                12'd378: toneL = `b;     12'd379: toneL = `b;
                12'd380: toneL = `b;     12'd381: toneL = `b;
                12'd382: toneL = `b;     12'd383: toneL = `b;
                // --- Measure 7 ---
                12'd384: toneL = `hc;     12'd385: toneL = `hc;
                12'd386: toneL = `hc;     12'd387: toneL = `hc;
                12'd388: toneL = `hc;     12'd389: toneL = `hc;
                12'd390: toneL = `hc;     12'd391: toneL = `hc;
                12'd392: toneL = `hc;     12'd393: toneL = `hc;
                12'd394: toneL = `hc;     12'd395: toneL = `hc;
                12'd396: toneL = `hc;     12'd397: toneL = `hc;
                12'd398: toneL = `hc;     12'd399: toneL = `hc;
                12'd400: toneL = `hc;     12'd401: toneL = `hc;
                12'd402: toneL = `hc;     12'd403: toneL = `hc;
                12'd404: toneL = `hc;     12'd405: toneL = `hc;
                12'd406: toneL = `hc;     12'd407: toneL = `hc;
                12'd408: toneL = `hc;     12'd409: toneL = `hc;
                12'd410: toneL = `hc;     12'd411: toneL = `hc;
                12'd412: toneL = `hc;     12'd413: toneL = `hc;
                12'd414: toneL = `hc;     12'd415: toneL = `hc;

                12'd416: toneL = `g;     12'd417: toneL = `g;
                12'd418: toneL = `g;     12'd419: toneL = `g;
                12'd420: toneL = `g;     12'd421: toneL = `g;
                12'd422: toneL = `g;     12'd423: toneL = `g;
                12'd424: toneL = `g;     12'd425: toneL = `g;
                12'd426: toneL = `g;     12'd427: toneL = `g;
                12'd428: toneL = `g;     12'd429: toneL = `g;
                12'd430: toneL = `g;     12'd431: toneL = `g;

                12'd432: toneL = `b;     12'd433: toneL = `b;
                12'd434: toneL = `b;     12'd435: toneL = `b;
                12'd436: toneL = `b;     12'd437: toneL = `b;
                12'd438: toneL = `b;     12'd439: toneL = `b;
                12'd440: toneL = `b;     12'd441: toneL = `b;
                12'd442: toneL = `b;     12'd443: toneL = `b;
                12'd444: toneL = `b;     12'd445: toneL = `b;
                12'd446: toneL = `b;     12'd447: toneL = `b;
                // --- Measure 8 ---
                12'd448: toneL = `hc;     12'd449: toneL = `hc;
                12'd450: toneL = `hc;     12'd451: toneL = `hc;
                12'd452: toneL = `hc;     12'd453: toneL = `hc;
                12'd454: toneL = `hc;     12'd455: toneL = `hc;
                12'd456: toneL = `hc;     12'd457: toneL = `hc;
                12'd458: toneL = `hc;     12'd459: toneL = `hc;
                12'd460: toneL = `hc;     12'd461: toneL = `hc;
                12'd462: toneL = `hc;     12'd463: toneL = `hc;

                12'd464: toneL = `g;     12'd465: toneL = `g;
                12'd466: toneL = `g;     12'd467: toneL = `g;
                12'd468: toneL = `g;     12'd469: toneL = `g;
                12'd470: toneL = `g;     12'd471: toneL = `g;
                12'd472: toneL = `g;     12'd473: toneL = `g;
                12'd474: toneL = `g;     12'd475: toneL = `g;
                12'd476: toneL = `g;     12'd477: toneL = `g;
                12'd478: toneL = `g;     12'd479: toneL = `g;

                12'd480: toneL = `c;     12'd481: toneL = `c;
                12'd482: toneL = `c;     12'd483: toneL = `c;
                12'd484: toneL = `c;     12'd485: toneL = `c;
                12'd486: toneL = `c;     12'd487: toneL = `c;
                12'd488: toneL = `c;     12'd489: toneL = `c;
                12'd490: toneL = `c;     12'd491: toneL = `c;
                12'd492: toneL = `c;     12'd493: toneL = `c;
                12'd494: toneL = `c;     12'd495: toneL = `c;
                12'd496: toneL = `c;     12'd497: toneL = `c;
                12'd498: toneL = `c;     12'd499: toneL = `c;
                12'd500: toneL = `c;     12'd501: toneL = `c;
                12'd502: toneL = `c;     12'd503: toneL = `c;
                12'd504: toneL = `c;     12'd505: toneL = `c;
                12'd506: toneL = `c;     12'd507: toneL = `c;
                12'd508: toneL = `c;     12'd509: toneL = `c;
                12'd510: toneL = `c;     12'd511: toneL = `c;
            endcase
        end
        else begin
            toneL = `sil;
        end
    end
endmodule

module music_example1 (
	input [11:0] ibeatNum,
	input en,
	output reg [31:0] toneL,
    output reg [31:0] toneR
    );

    always @* begin
        if(en == 1) begin
            case(ibeatNum)
                // --- Song 1 ---
                // --- Measure 1 ---
                12'd0: toneR = `he;     12'd1: toneR = `he;
                12'd2: toneR = `he;     12'd3: toneR = `he;
                12'd4: toneR = `he;     12'd5: toneR = `he;
                12'd6: toneR = `he;     12'd7: toneR = `sil;

                12'd8: toneR = `he;     12'd9: toneR = `he;
                12'd10: toneR = `he;     12'd11: toneR = `he;
                12'd12: toneR = `he;     12'd13: toneR = `he;
                12'd14: toneR = `he;     12'd15: toneR = `sil;

                12'd16: toneR = `he;     12'd17: toneR = `he;
                12'd18: toneR = `he;     12'd19: toneR = `he;
                12'd20: toneR = `he;     12'd21: toneR = `he;
                12'd22: toneR = `he;     12'd23: toneR = `he;
                12'd24: toneR = `he;     12'd25: toneR = `he;
                12'd26: toneR = `he;     12'd27: toneR = `he;
                12'd28: toneR = `he;     12'd29: toneR = `he;
                12'd30: toneR = `he;     12'd31: toneR = `sil;

                12'd32: toneR = `he;     12'd33: toneR = `he;
                12'd34: toneR = `he;     12'd35: toneR = `he;
                12'd36: toneR = `he;     12'd37: toneR = `he;
                12'd38: toneR = `he;     12'd39: toneR = `sil;

                12'd40: toneR = `he;     12'd41: toneR = `he;
                12'd42: toneR = `he;     12'd43: toneR = `he;
                12'd44: toneR = `he;     12'd45: toneR = `he;
                12'd46: toneR = `he;     12'd47: toneR = `sil;

                12'd48: toneR = `he;     12'd49: toneR = `he;
                12'd50: toneR = `he;     12'd51: toneR = `he;
                12'd52: toneR = `he;     12'd53: toneR = `he;
                12'd54: toneR = `he;     12'd55: toneR = `he;
                12'd56: toneR = `he;     12'd57: toneR = `he;
                12'd58: toneR = `he;     12'd59: toneR = `he;
                12'd60: toneR = `he;     12'd61: toneR = `he;
                12'd62: toneR = `he;     12'd63: toneR = `sil;
                // --- Measure 2 ---
                12'd64: toneR = `he;     12'd65: toneR = `he;
                12'd66: toneR = `he;     12'd67: toneR = `he;
                12'd68: toneR = `he;     12'd69: toneR = `he;
                12'd70: toneR = `he;     12'd71: toneR = `he;

                12'd72: toneR = `hg;     12'd73: toneR = `hg;
                12'd74: toneR = `hg;     12'd75: toneR = `hg;
                12'd76: toneR = `hg;     12'd77: toneR = `hg;
                12'd78: toneR = `hg;     12'd79: toneR = `hg;

                12'd80: toneR = `hc;     12'd81: toneR = `hc;
                12'd82: toneR = `hc;     12'd83: toneR = `hc;
                12'd84: toneR = `hc;     12'd85: toneR = `hc;
                12'd86: toneR = `hc;     12'd87: toneR = `hc;

                12'd88: toneR = `hd;     12'd89: toneR = `hd;
                12'd90: toneR = `hd;     12'd91: toneR = `hd;
                12'd92: toneR = `hd;     12'd93: toneR = `hd;
                12'd94: toneR = `hd;     12'd95: toneR = `hd;

                12'd96: toneR = `he;     12'd97: toneR = `he;
                12'd98: toneR = `he;     12'd99: toneR = `he;
                12'd100: toneR = `he;     12'd101: toneR = `he;
                12'd102: toneR = `he;     12'd103: toneR = `he;
                12'd104: toneR = `he;     12'd105: toneR = `he;
                12'd106: toneR = `he;     12'd107: toneR = `he;
                12'd108: toneR = `he;     12'd109: toneR = `he;
                12'd110: toneR = `he;     12'd111: toneR = `he;
                12'd112: toneR = `he;     12'd113: toneR = `he;
                12'd114: toneR = `he;     12'd115: toneR = `he;
                12'd116: toneR = `he;     12'd117: toneR = `he;
                12'd118: toneR = `he;     12'd119: toneR = `he;
                12'd120: toneR = `he;     12'd121: toneR = `he;
                12'd122: toneR = `he;     12'd123: toneR = `he;
                12'd124: toneR = `he;     12'd125: toneR = `he;
                12'd126: toneR = `he;     12'd127: toneR = `he;
                // --- Measure 3 ---
                12'd128: toneR = `hf;     12'd129: toneR = `hf;
                12'd130: toneR = `hf;     12'd131: toneR = `hf;
                12'd132: toneR = `hf;     12'd133: toneR = `hf;
                12'd134: toneR = `hf;     12'd135: toneR = `sil;

                12'd136: toneR = `hf;     12'd137: toneR = `hf;
                12'd138: toneR = `hf;     12'd139: toneR = `hf;
                12'd140: toneR = `hf;     12'd141: toneR = `hf;
                12'd142: toneR = `hf;     12'd143: toneR = `sil;

                12'd144: toneR = `hf;     12'd145: toneR = `hf;
                12'd146: toneR = `hf;     12'd147: toneR = `hf;
                12'd148: toneR = `hf;     12'd149: toneR = `hf;
                12'd150: toneR = `hf;     12'd151: toneR = `hf;
                12'd152: toneR = `hf;     12'd153: toneR = `hf;
                12'd154: toneR = `hf;     12'd155: toneR = `sil;

                12'd156: toneR = `hf;     12'd157: toneR = `hf;
                12'd158: toneR = `hf;     12'd159: toneR = `sil;

                12'd160: toneR = `hf;     12'd161: toneR = `hf;
                12'd162: toneR = `hf;     12'd163: toneR = `hf;
                12'd164: toneR = `hf;     12'd165: toneR = `hf;
                12'd166: toneR = `hf;     12'd167: toneR = `hf;

                12'd168: toneR = `he;     12'd169: toneR = `he;
                12'd170: toneR = `he;     12'd171: toneR = `he;
                12'd172: toneR = `he;     12'd173: toneR = `he;
                12'd174: toneR = `he;     12'd175: toneR = `sil;

                12'd176: toneR = `he;     12'd177: toneR = `he;
                12'd178: toneR = `he;     12'd179: toneR = `he;
                12'd180: toneR = `he;     12'd181: toneR = `he;
                12'd182: toneR = `he;     12'd183: toneR = `he;
                12'd184: toneR = `he;     12'd185: toneR = `he;
                12'd186: toneR = `he;     12'd187: toneR = `sil;

                12'd188: toneR = `he;     12'd189: toneR = `he;
                12'd190: toneR = `he;     12'd191: toneR = `sil;
                // --- Measure 4 ---
                12'd192: toneR = `he;     12'd193: toneR = `he;
                12'd194: toneR = `he;     12'd195: toneR = `he;
                12'd196: toneR = `he;     12'd197: toneR = `he;
                12'd198: toneR = `he;     12'd199: toneR = `he;

                12'd200: toneR = `hd;     12'd201: toneR = `hd;
                12'd202: toneR = `hd;     12'd203: toneR = `hd;
                12'd204: toneR = `hd;     12'd205: toneR = `hd;
                12'd206: toneR = `hd;     12'd207: toneR = `sil;

                12'd208: toneR = `hd;     12'd209: toneR = `hd;
                12'd210: toneR = `hd;     12'd211: toneR = `hd;
                12'd212: toneR = `hd;     12'd213: toneR = `hd;
                12'd214: toneR = `hd;     12'd215: toneR = `hd;

                12'd216: toneR = `he;     12'd217: toneR = `he;
                12'd218: toneR = `he;     12'd219: toneR = `he;
                12'd220: toneR = `he;     12'd221: toneR = `he;
                12'd222: toneR = `he;     12'd223: toneR = `he;

                12'd224: toneR = `hd;     12'd225: toneR = `hd;
                12'd226: toneR = `hd;     12'd227: toneR = `hd;
                12'd228: toneR = `hd;     12'd229: toneR = `hd;
                12'd230: toneR = `hd;     12'd231: toneR = `hd;
                12'd232: toneR = `hd;     12'd233: toneR = `hd;
                12'd234: toneR = `hd;     12'd235: toneR = `hd;
                12'd236: toneR = `hd;     12'd237: toneR = `hd;
                12'd238: toneR = `hd;     12'd239: toneR = `hd;

                12'd240: toneR = `hg;     12'd241: toneR = `hg;
                12'd242: toneR = `hg;     12'd243: toneR = `hg;
                12'd244: toneR = `hg;     12'd245: toneR = `hg;
                12'd246: toneR = `hg;     12'd247: toneR = `hg;
                12'd248: toneR = `hg;     12'd249: toneR = `hg;
                12'd250: toneR = `hg;     12'd251: toneR = `hg;
                12'd252: toneR = `hg;     12'd253: toneR = `hg;
                12'd254: toneR = `hg;     12'd255: toneR = `hg;
                // --- Measure 5 ---
                12'd256: toneR = `he;     12'd257: toneR = `he;
                12'd258: toneR = `he;     12'd259: toneR = `he;
                12'd260: toneR = `he;     12'd261: toneR = `he;
                12'd262: toneR = `he;     12'd263: toneR = `sil;

                12'd264: toneR = `he;     12'd265: toneR = `he;
                12'd266: toneR = `he;     12'd267: toneR = `he;
                12'd268: toneR = `he;     12'd269: toneR = `he;
                12'd270: toneR = `he;     12'd271: toneR = `sil;

                12'd272: toneR = `he;     12'd273: toneR = `he;
                12'd274: toneR = `he;     12'd275: toneR = `he;
                12'd276: toneR = `he;     12'd277: toneR = `he;
                12'd278: toneR = `he;     12'd279: toneR = `he;
                12'd280: toneR = `he;     12'd281: toneR = `he;
                12'd282: toneR = `he;     12'd283: toneR = `he;
                12'd284: toneR = `he;     12'd285: toneR = `he;
                12'd286: toneR = `he;     12'd287: toneR = `sil;

                12'd288: toneR = `he;     12'd289: toneR = `he;
                12'd290: toneR = `he;     12'd291: toneR = `he;
                12'd292: toneR = `he;     12'd293: toneR = `he;
                12'd294: toneR = `he;     12'd295: toneR = `sil;

                12'd296: toneR = `he;     12'd297: toneR = `he;
                12'd298: toneR = `he;     12'd299: toneR = `he;
                12'd300: toneR = `he;     12'd301: toneR = `he;
                12'd302: toneR = `he;     12'd303: toneR = `sil;

                12'd304: toneR = `he;     12'd305: toneR = `he;
                12'd306: toneR = `he;     12'd307: toneR = `he;
                12'd308: toneR = `he;     12'd309: toneR = `he;
                12'd310: toneR = `he;     12'd311: toneR = `he;
                12'd312: toneR = `he;     12'd313: toneR = `he;
                12'd314: toneR = `he;     12'd315: toneR = `he;
                12'd316: toneR = `he;     12'd317: toneR = `he;
                12'd318: toneR = `he;     12'd319: toneR = `sil;
                // --- Measure 6 ---
                12'd320: toneR = `he;     12'd321: toneR = `he;
                12'd322: toneR = `he;     12'd323: toneR = `he;
                12'd324: toneR = `he;     12'd325: toneR = `he;
                12'd326: toneR = `he;     12'd327: toneR = `he;

                12'd328: toneR = `hg;     12'd329: toneR = `hg;
                12'd330: toneR = `hg;     12'd331: toneR = `hg;
                12'd332: toneR = `hg;     12'd333: toneR = `hg;
                12'd334: toneR = `hg;     12'd335: toneR = `hg;

                12'd336: toneR = `hc;     12'd337: toneR = `hc;
                12'd338: toneR = `hc;     12'd339: toneR = `hc;
                12'd340: toneR = `hc;     12'd341: toneR = `hc;
                12'd342: toneR = `hc;     12'd343: toneR = `hc;

                12'd344: toneR = `hd;     12'd345: toneR = `hd;
                12'd346: toneR = `hd;     12'd347: toneR = `hd;
                12'd348: toneR = `hd;     12'd349: toneR = `hd;
                12'd350: toneR = `hd;     12'd351: toneR = `hd;

                12'd352: toneR = `he;     12'd353: toneR = `he;
                12'd354: toneR = `he;     12'd355: toneR = `he;
                12'd356: toneR = `he;     12'd357: toneR = `he;
                12'd358: toneR = `he;     12'd359: toneR = `he;
                12'd360: toneR = `he;     12'd361: toneR = `he;
                12'd362: toneR = `he;     12'd363: toneR = `he;
                12'd364: toneR = `he;     12'd365: toneR = `he;
                12'd366: toneR = `he;     12'd367: toneR = `he;
                12'd368: toneR = `he;     12'd369: toneR = `he;
                12'd370: toneR = `he;     12'd371: toneR = `he;
                12'd372: toneR = `he;     12'd373: toneR = `he;
                12'd374: toneR = `he;     12'd375: toneR = `he;
                12'd376: toneR = `he;     12'd377: toneR = `he;
                12'd378: toneR = `he;     12'd379: toneR = `he;
                12'd380: toneR = `he;     12'd381: toneR = `he;
                12'd382: toneR = `he;     12'd383: toneR = `he;
                // --- Measure 7 ---
                12'd384: toneR = `hf;     12'd385: toneR = `hf;
                12'd386: toneR = `hf;     12'd387: toneR = `hf;
                12'd388: toneR = `hf;     12'd389: toneR = `hf;
                12'd390: toneR = `hf;     12'd391: toneR = `sil;

                12'd392: toneR = `hf;     12'd393: toneR = `hf;
                12'd394: toneR = `hf;     12'd395: toneR = `hf;
                12'd396: toneR = `hf;     12'd397: toneR = `hf;
                12'd398: toneR = `hf;     12'd399: toneR = `sil;

                12'd400: toneR = `hf;     12'd401: toneR = `hf;
                12'd402: toneR = `hf;     12'd403: toneR = `hf;
                12'd404: toneR = `hf;     12'd405: toneR = `hf;
                12'd406: toneR = `hf;     12'd407: toneR = `hf;
                12'd408: toneR = `hf;     12'd409: toneR = `hf;
                12'd410: toneR = `hf;     12'd411: toneR = `sil;

                12'd412: toneR = `hf;     12'd413: toneR = `hf;
                12'd414: toneR = `hf;     12'd415: toneR = `sil;

                12'd416: toneR = `hf;     12'd417: toneR = `hf;
                12'd418: toneR = `hf;     12'd419: toneR = `hf;
                12'd420: toneR = `hf;     12'd421: toneR = `hf;
                12'd422: toneR = `hf;     12'd423: toneR = `hf;         

                12'd424: toneR = `he;     12'd425: toneR = `he;
                12'd426: toneR = `he;     12'd427: toneR = `he;
                12'd428: toneR = `he;     12'd429: toneR = `he;
                12'd430: toneR = `he;     12'd431: toneR = `sil;

                12'd432: toneR = `he;     12'd433: toneR = `he;
                12'd434: toneR = `he;     12'd435: toneR = `he;
                12'd436: toneR = `he;     12'd437: toneR = `he;
                12'd438: toneR = `he;     12'd439: toneR = `he;
                12'd440: toneR = `he;     12'd441: toneR = `he;
                12'd442: toneR = `he;     12'd443: toneR = `sil;

                12'd444: toneR = `he;     12'd445: toneR = `he;
                12'd446: toneR = `he;     12'd447: toneR = `he;
                // --- Measure 8 ---
                12'd448: toneR = `hg;     12'd449: toneR = `hg;
                12'd450: toneR = `hg;     12'd451: toneR = `hg;
                12'd452: toneR = `hg;     12'd453: toneR = `hg;
                12'd454: toneR = `hg;     12'd455: toneR = `sil;

                12'd456: toneR = `hg;     12'd457: toneR = `hg;
                12'd458: toneR = `hg;     12'd459: toneR = `hg;
                12'd460: toneR = `hg;     12'd461: toneR = `hg;
                12'd462: toneR = `hg;     12'd463: toneR = `hg;

                12'd464: toneR = `hf;     12'd465: toneR = `hf;
                12'd466: toneR = `hf;     12'd467: toneR = `hf;
                12'd468: toneR = `hf;     12'd469: toneR = `hf;
                12'd470: toneR = `hf;     12'd471: toneR = `hf;

                12'd472: toneR = `hd;     12'd473: toneR = `hd;
                12'd474: toneR = `hd;     12'd475: toneR = `hd;
                12'd476: toneR = `hd;     12'd477: toneR = `hd;
                12'd478: toneR = `hd;     12'd479: toneR = `hd;

                12'd480: toneR = `hc;     12'd481: toneR = `hc;
                12'd482: toneR = `hc;     12'd483: toneR = `hc;
                12'd484: toneR = `hc;     12'd485: toneR = `hc;
                12'd486: toneR = `hc;     12'd487: toneR = `hc;
                12'd488: toneR = `hc;     12'd489: toneR = `hc;
                12'd490: toneR = `hc;     12'd491: toneR = `hc;
                12'd492: toneR = `hc;     12'd493: toneR = `hc;
                12'd494: toneR = `hc;     12'd495: toneR = `hc;
                12'd496: toneR = `hc;     12'd497: toneR = `hc;
                12'd498: toneR = `hc;     12'd499: toneR = `hc;
                12'd500: toneR = `hc;     12'd501: toneR = `hc;
                12'd502: toneR = `hc;     12'd503: toneR = `hc;
                12'd504: toneR = `hc;     12'd505: toneR = `hc;
                12'd506: toneR = `hc;     12'd507: toneR = `hc;
                12'd508: toneR = `hc;     12'd509: toneR = `hc;
                12'd510: toneR = `hc;     12'd511: toneR = `hc;
                default: toneR = `sil;
            endcase
        end else begin
            toneR = `sil;
        end
    end

    always @(*) begin
        if(en == 1)begin
            case(ibeatNum)
                // --- Song 1 ---
                // --- Measure 1 ---
                12'd0: toneL = `hc;     12'd1: toneL = `hc;
                12'd2: toneL = `hc;     12'd3: toneL = `hc;
                12'd4: toneL = `hc;     12'd5: toneL = `hc;
                12'd6: toneL = `hc;     12'd7: toneL = `hc;
                12'd8: toneL = `hc;     12'd9: toneL = `hc;
                12'd10: toneL = `hc;     12'd11: toneL = `hc;
                12'd12: toneL = `hc;     12'd13: toneL = `hc;
                12'd14: toneL = `hc;     12'd15: toneL = `hc;

                12'd16: toneL = `g;     12'd17: toneL = `g;
                12'd18: toneL = `g;     12'd19: toneL = `g;
                12'd20: toneL = `g;     12'd21: toneL = `g;
                12'd22: toneL = `g;     12'd23: toneL = `g;
                12'd24: toneL = `g;     12'd25: toneL = `g;
                12'd26: toneL = `g;     12'd27: toneL = `g;
                12'd28: toneL = `g;     12'd29: toneL = `g;
                12'd30: toneL = `g;     12'd31: toneL = `g;

                12'd32: toneL = `hc;     12'd33: toneL = `hc;
                12'd34: toneL = `hc;     12'd35: toneL = `hc;
                12'd36: toneL = `hc;     12'd37: toneL = `hc;
                12'd38: toneL = `hc;     12'd39: toneL = `hc;
                12'd40: toneL = `hc;     12'd41: toneL = `hc;
                12'd42: toneL = `hc;     12'd43: toneL = `hc;
                12'd44: toneL = `hc;     12'd45: toneL = `hc;
                12'd46: toneL = `hc;     12'd47: toneL = `hc;

                12'd48: toneL = `g;     12'd49: toneL = `g;
                12'd50: toneL = `g;     12'd51: toneL = `g;
                12'd52: toneL = `g;     12'd53: toneL = `g;
                12'd54: toneL = `g;     12'd55: toneL = `g;
                12'd56: toneL = `g;     12'd57: toneL = `g;
                12'd58: toneL = `g;     12'd59: toneL = `g;
                12'd60: toneL = `g;     12'd61: toneL = `g;
                12'd62: toneL = `g;     12'd63: toneL = `g;
                // --- Measure 2 ---
                12'd64: toneL = `hc;     12'd65: toneL = `hc;
                12'd66: toneL = `hc;     12'd67: toneL = `hc;
                12'd68: toneL = `hc;     12'd69: toneL = `hc;
                12'd70: toneL = `hc;     12'd71: toneL = `hc;
                12'd72: toneL = `hc;     12'd73: toneL = `hc;
                12'd74: toneL = `hc;     12'd75: toneL = `hc;
                12'd76: toneL = `hc;     12'd77: toneL = `hc;
                12'd78: toneL = `hc;     12'd79: toneL = `hc;

                12'd80: toneL = `g;     12'd81: toneL = `g;
                12'd82: toneL = `g;     12'd83: toneL = `g;
                12'd84: toneL = `g;     12'd85: toneL = `g;
                12'd86: toneL = `g;     12'd87: toneL = `g;
                12'd88: toneL = `g;     12'd89: toneL = `g;
                12'd90: toneL = `g;     12'd91: toneL = `g;
                12'd92: toneL = `g;     12'd93: toneL = `g;
                12'd94: toneL = `g;     12'd95: toneL = `g;

                12'd96: toneL = `hc;     12'd97: toneL = `hc;
                12'd98: toneL = `hc;     12'd99: toneL = `hc;
                12'd100: toneL = `hc;     12'd101: toneL = `hc;
                12'd102: toneL = `hc;     12'd103: toneL = `hc;

                12'd104: toneL = `g;     12'd105: toneL = `g;
                12'd106: toneL = `g;     12'd107: toneL = `g;
                12'd108: toneL = `g;     12'd109: toneL = `g;
                12'd110: toneL = `g;     12'd111: toneL = `g;

                12'd112: toneL = `a;     12'd113: toneL = `a;
                12'd114: toneL = `a;     12'd115: toneL = `a;
                12'd116: toneL = `a;     12'd117: toneL = `a;
                12'd118: toneL = `a;     12'd119: toneL = `a;

                12'd120: toneL = `b;     12'd121: toneL = `b;
                12'd122: toneL = `b;     12'd123: toneL = `b;
                12'd124: toneL = `b;     12'd125: toneL = `b;
                12'd126: toneL = `b;     12'd127: toneL = `b;
                // --- Measure 3 ---
                12'd128: toneL = `hd;     12'd129: toneL = `hd;
                12'd130: toneL = `hd;     12'd131: toneL = `hd;
                12'd132: toneL = `hd;     12'd133: toneL = `hd;
                12'd134: toneL = `hd;     12'd135: toneL = `hd;
                12'd136: toneL = `hd;     12'd137: toneL = `hd;
                12'd138: toneL = `hd;     12'd139: toneL = `hd;
                12'd140: toneL = `hd;     12'd141: toneL = `hd;
                12'd142: toneL = `hd;     12'd143: toneL = `hd;

                12'd144: toneL = `f;     12'd145: toneL = `f;
                12'd146: toneL = `f;     12'd147: toneL = `f;
                12'd148: toneL = `f;     12'd149: toneL = `f;
                12'd150: toneL = `f;     12'd151: toneL = `f;
                12'd152: toneL = `f;     12'd153: toneL = `f;
                12'd154: toneL = `f;     12'd155: toneL = `f;
                12'd156: toneL = `f;     12'd157: toneL = `f;
                12'd158: toneL = `f;     12'd159: toneL = `f;

                12'd160: toneL = `hc;     12'd161: toneL = `hc;
                12'd162: toneL = `hc;     12'd163: toneL = `hc;
                12'd164: toneL = `hc;     12'd165: toneL = `hc;
                12'd166: toneL = `hc;     12'd167: toneL = `hc;
                12'd168: toneL = `hc;     12'd169: toneL = `hc;
                12'd170: toneL = `hc;     12'd171: toneL = `hc;
                12'd172: toneL = `hc;     12'd173: toneL = `hc;
                12'd174: toneL = `hc;     12'd175: toneL = `hc;

                12'd176: toneL = `e;     12'd177: toneL = `e;
                12'd178: toneL = `e;     12'd179: toneL = `e;
                12'd180: toneL = `e;     12'd181: toneL = `e;
                12'd182: toneL = `e;     12'd183: toneL = `e;
                12'd184: toneL = `e;     12'd185: toneL = `e;
                12'd186: toneL = `e;     12'd187: toneL = `e;
                12'd188: toneL = `e;     12'd189: toneL = `e;
                12'd190: toneL = `e;     12'd191: toneL = `e;
                // --- Measure 4 ---
                12'd192: toneL = `g;     12'd193: toneL = `g;
                12'd194: toneL = `g;     12'd195: toneL = `g;
                12'd196: toneL = `g;     12'd197: toneL = `g;
                12'd198: toneL = `g;     12'd199: toneL = `g;
                12'd200: toneL = `g;     12'd201: toneL = `g;
                12'd202: toneL = `g;     12'd203: toneL = `g;
                12'd204: toneL = `g;     12'd205: toneL = `g;
                12'd206: toneL = `g;     12'd207: toneL = `g;

                12'd208: toneL = `f;     12'd209: toneL = `f;
                12'd210: toneL = `f;     12'd211: toneL = `f;
                12'd212: toneL = `f;     12'd213: toneL = `f;
                12'd214: toneL = `f;     12'd215: toneL = `f;
                12'd216: toneL = `f;     12'd217: toneL = `f;
                12'd218: toneL = `f;     12'd219: toneL = `f;
                12'd220: toneL = `f;     12'd221: toneL = `f;
                12'd222: toneL = `f;     12'd223: toneL = `f;

                12'd224: toneL = `d;     12'd225: toneL = `d;
                12'd226: toneL = `d;     12'd227: toneL = `d;
                12'd228: toneL = `d;     12'd229: toneL = `d;
                12'd230: toneL = `d;     12'd231: toneL = `d;
                12'd232: toneL = `d;     12'd233: toneL = `d;
                12'd234: toneL = `d;     12'd235: toneL = `d;
                12'd236: toneL = `d;     12'd237: toneL = `d;
                12'd238: toneL = `d;     12'd239: toneL = `d;

                12'd240: toneL = `b;     12'd241: toneL = `b;
                12'd242: toneL = `b;     12'd243: toneL = `b;
                12'd244: toneL = `b;     12'd245: toneL = `b;
                12'd246: toneL = `b;     12'd247: toneL = `b;
                12'd248: toneL = `b;     12'd249: toneL = `b;
                12'd250: toneL = `b;     12'd251: toneL = `b;
                12'd252: toneL = `b;     12'd253: toneL = `b;
                12'd254: toneL = `b;     12'd255: toneL = `b;
                // --- Measure 5 ---
                12'd256: toneL = `hc;     12'd257: toneL = `hc;
                12'd258: toneL = `hc;     12'd259: toneL = `hc;
                12'd260: toneL = `hc;     12'd261: toneL = `hc;
                12'd262: toneL = `hc;     12'd263: toneL = `hc;
                12'd264: toneL = `hc;     12'd265: toneL = `hc;
                12'd266: toneL = `hc;     12'd267: toneL = `hc;
                12'd268: toneL = `hc;     12'd269: toneL = `hc;
                12'd270: toneL = `hc;     12'd271: toneL = `hc;

                12'd272: toneL = `g;     12'd273: toneL = `g;
                12'd274: toneL = `g;     12'd275: toneL = `g;
                12'd276: toneL = `g;     12'd277: toneL = `g;
                12'd278: toneL = `g;     12'd279: toneL = `g;
                12'd280: toneL = `g;     12'd281: toneL = `g;
                12'd282: toneL = `g;     12'd283: toneL = `g;
                12'd284: toneL = `g;     12'd285: toneL = `g;
                12'd286: toneL = `g;     12'd287: toneL = `g;

                12'd288: toneL = `hc;     12'd289: toneL = `hc;
                12'd290: toneL = `hc;     12'd291: toneL = `hc;
                12'd292: toneL = `hc;     12'd293: toneL = `hc;
                12'd294: toneL = `hc;     12'd295: toneL = `hc;
                12'd296: toneL = `hc;     12'd297: toneL = `hc;
                12'd298: toneL = `hc;     12'd299: toneL = `hc;
                12'd300: toneL = `hc;     12'd301: toneL = `hc;
                12'd302: toneL = `hc;     12'd303: toneL = `hc;

                12'd304: toneL = `g;     12'd305: toneL = `g;
                12'd306: toneL = `g;     12'd307: toneL = `g;
                12'd308: toneL = `g;     12'd309: toneL = `g;
                12'd310: toneL = `g;     12'd311: toneL = `g;
                12'd312: toneL = `g;     12'd313: toneL = `g;
                12'd314: toneL = `g;     12'd315: toneL = `g;
                12'd316: toneL = `g;     12'd317: toneL = `g;
                12'd318: toneL = `g;     12'd319: toneL = `g;
                // --- Measure 6 ---
                12'd320: toneL = `hc;     12'd321: toneL = `hc;
                12'd322: toneL = `hc;     12'd323: toneL = `hc;
                12'd324: toneL = `hc;     12'd325: toneL = `hc;
                12'd326: toneL = `hc;     12'd327: toneL = `hc;
                12'd328: toneL = `hc;     12'd329: toneL = `hc;
                12'd330: toneL = `hc;     12'd331: toneL = `hc;
                12'd332: toneL = `hc;     12'd333: toneL = `hc;
                12'd334: toneL = `hc;     12'd335: toneL = `hc;

                12'd336: toneL = `g;     12'd337: toneL = `g;
                12'd338: toneL = `g;     12'd339: toneL = `g;
                12'd340: toneL = `g;     12'd341: toneL = `g;
                12'd342: toneL = `g;     12'd343: toneL = `g;
                12'd344: toneL = `g;     12'd345: toneL = `g;
                12'd346: toneL = `g;     12'd347: toneL = `g;
                12'd348: toneL = `g;     12'd349: toneL = `g;
                12'd350: toneL = `g;     12'd351: toneL = `g;

                12'd352: toneL = `hc;     12'd353: toneL = `hc;
                12'd354: toneL = `hc;     12'd355: toneL = `hc;
                12'd356: toneL = `hc;     12'd357: toneL = `hc;
                12'd358: toneL = `hc;     12'd359: toneL = `hc;

                12'd360: toneL = `g;     12'd361: toneL = `g;
                12'd362: toneL = `g;     12'd363: toneL = `g;
                12'd364: toneL = `g;     12'd365: toneL = `g;
                12'd366: toneL = `g;     12'd367: toneL = `g;

                12'd368: toneL = `a;     12'd369: toneL = `a;
                12'd370: toneL = `a;     12'd371: toneL = `a;
                12'd372: toneL = `a;     12'd373: toneL = `a;
                12'd374: toneL = `a;     12'd375: toneL = `a;

                12'd376: toneL = `b;     12'd377: toneL = `b;
                12'd378: toneL = `b;     12'd379: toneL = `b;
                12'd380: toneL = `b;     12'd381: toneL = `b;
                12'd382: toneL = `b;     12'd383: toneL = `b;
                // --- Measure 7 ---
                12'd384: toneL = `hd;     12'd385: toneL = `hd;
                12'd386: toneL = `hd;     12'd387: toneL = `hd;
                12'd388: toneL = `hd;     12'd389: toneL = `hd;
                12'd390: toneL = `hd;     12'd391: toneL = `hd;
                12'd392: toneL = `hd;     12'd393: toneL = `hd;
                12'd394: toneL = `hd;     12'd395: toneL = `hd;
                12'd396: toneL = `hd;     12'd397: toneL = `hd;
                12'd398: toneL = `hd;     12'd399: toneL = `hd;

                12'd400: toneL = `f;     12'd401: toneL = `f;
                12'd402: toneL = `f;     12'd403: toneL = `f;
                12'd404: toneL = `f;     12'd405: toneL = `f;
                12'd406: toneL = `f;     12'd407: toneL = `f;
                12'd408: toneL = `f;     12'd409: toneL = `f;
                12'd410: toneL = `f;     12'd411: toneL = `f;
                12'd412: toneL = `f;     12'd413: toneL = `f;
                12'd414: toneL = `f;     12'd415: toneL = `f;

                12'd416: toneL = `hc;     12'd417: toneL = `hc;
                12'd418: toneL = `hc;     12'd419: toneL = `hc;
                12'd420: toneL = `hc;     12'd421: toneL = `hc;
                12'd422: toneL = `hc;     12'd423: toneL = `hc;
                12'd424: toneL = `hc;     12'd425: toneL = `hc;
                12'd426: toneL = `hc;     12'd427: toneL = `hc;
                12'd428: toneL = `hc;     12'd429: toneL = `hc;
                12'd430: toneL = `hc;     12'd431: toneL = `hc;

                12'd432: toneL = `e;     12'd433: toneL = `e;
                12'd434: toneL = `e;     12'd435: toneL = `e;
                12'd436: toneL = `e;     12'd437: toneL = `e;
                12'd438: toneL = `e;     12'd439: toneL = `e;
                12'd440: toneL = `e;     12'd441: toneL = `e;
                12'd442: toneL = `e;     12'd443: toneL = `e;
                12'd444: toneL = `e;     12'd445: toneL = `e;
                12'd446: toneL = `e;     12'd447: toneL = `e;
                // --- Measure 8 ---
                12'd448: toneL = `hc;     12'd449: toneL = `hc;
                12'd450: toneL = `hc;     12'd451: toneL = `hc;
                12'd452: toneL = `hc;     12'd453: toneL = `hc;
                12'd454: toneL = `hc;     12'd455: toneL = `hc;
                12'd456: toneL = `hc;     12'd457: toneL = `hc;
                12'd458: toneL = `hc;     12'd459: toneL = `hc;
                12'd460: toneL = `hc;     12'd461: toneL = `hc;
                12'd462: toneL = `hc;     12'd463: toneL = `hc;

                12'd464: toneL = `g;     12'd465: toneL = `g;
                12'd466: toneL = `g;     12'd467: toneL = `g;
                12'd468: toneL = `g;     12'd469: toneL = `g;
                12'd470: toneL = `g;     12'd471: toneL = `g;
                12'd472: toneL = `g;     12'd473: toneL = `g;
                12'd474: toneL = `g;     12'd475: toneL = `g;
                12'd476: toneL = `g;     12'd477: toneL = `g;
                12'd478: toneL = `g;     12'd479: toneL = `g;

                12'd480: toneL = `c;     12'd481: toneL = `c;
                12'd482: toneL = `c;     12'd483: toneL = `c;
                12'd484: toneL = `c;     12'd485: toneL = `c;
                12'd486: toneL = `c;     12'd487: toneL = `c;
                12'd488: toneL = `c;     12'd489: toneL = `c;
                12'd490: toneL = `c;     12'd491: toneL = `c;
                12'd492: toneL = `c;     12'd493: toneL = `c;
                12'd494: toneL = `c;     12'd495: toneL = `c;

                12'd496: toneL = `sil;     12'd497: toneL = `sil;
                12'd498: toneL = `sil;     12'd499: toneL = `sil;
                12'd500: toneL = `sil;     12'd501: toneL = `sil;
                12'd502: toneL = `sil;     12'd503: toneL = `sil;
                12'd504: toneL = `sil;     12'd505: toneL = `sil;
                12'd506: toneL = `sil;     12'd507: toneL = `sil;
                12'd508: toneL = `sil;     12'd509: toneL = `sil;
                12'd510: toneL = `sil;     12'd511: toneL = `sil;
            endcase
        end
        else begin
            toneL = `sil;
        end
    end
endmodule

module note_gen(
    clk, // clock from crystal
    rst, // active high reset
    volume, 
    note_div_left, // div for note generation
    note_div_right,
    audio_left,
    audio_right
    );

    // I/O declaration
    input clk; // clock from crystal
    input rst; // active low reset
    input [3:0] volume;
    input [21:0] note_div_left, note_div_right; // div for note generation
    output reg [15:0] audio_left, audio_right;

    // Declare internal signals
    reg [21:0] clk_cnt_next, clk_cnt;
    reg [21:0] clk_cnt_next_2, clk_cnt_2;
    reg b_clk, b_clk_next;
    reg c_clk, c_clk_next;

    // Note frequency generation
    // clk_cnt, clk_cnt_2, b_clk, c_clk
    always @(posedge clk or posedge rst)
        if (rst == 1'b1)
            begin
                clk_cnt <= 22'd0;
                clk_cnt_2 <= 22'd0;
                b_clk <= 1'b0;
                c_clk <= 1'b0;
            end
        else
            begin
                clk_cnt <= clk_cnt_next;
                clk_cnt_2 <= clk_cnt_next_2;
                b_clk <= b_clk_next;
                c_clk <= c_clk_next;
            end
    
    // clk_cnt_next, b_clk_next
    always @*
        if (clk_cnt == note_div_left)
            begin
                clk_cnt_next = 22'd0;
                b_clk_next = ~b_clk;
            end
        else
            begin
                clk_cnt_next = clk_cnt + 1'b1;
                b_clk_next = b_clk;
            end

    // clk_cnt_next_2, c_clk_next
    always @*
        if (clk_cnt_2 == note_div_right)
            begin
                clk_cnt_next_2 = 22'd0;
                c_clk_next = ~c_clk;
            end
        else
            begin
                clk_cnt_next_2 = clk_cnt_2 + 1'b1;
                c_clk_next = c_clk;
            end

    // Assign the amplitude of the note
    // Volume is controlled here
    
    always @(*) begin
        if(note_div_left == 22'd1) audio_left = 16'h0000;
        else begin
            case(volume)
                4'd1: audio_left = (b_clk == 1'b0) ? 16'h0E00 : 16'h0200;
                4'd2: audio_left = (b_clk == 1'b0) ? 16'h1C00 : 16'h0400;
                4'd3: audio_left = (b_clk == 1'b0) ? 16'h3800 : 16'h0800;
                4'd4: audio_left = (b_clk == 1'b0) ? 16'h7000 : 16'h1000;
                4'd5: audio_left = (b_clk == 1'b0) ? 16'hE000 : 16'h2000;
            endcase
        end
    end
    always @(*) begin
        if(note_div_right == 22'd1) audio_right = 16'h0000;
        else begin
            case(volume)
                4'd1: audio_right = (c_clk == 1'b0) ? 16'h0E00 : 16'h0200;
                4'd2: audio_right = (c_clk == 1'b0) ? 16'h1C00 : 16'h0400;
                4'd3: audio_right = (c_clk == 1'b0) ? 16'h3800 : 16'h0800;
                4'd4: audio_right = (c_clk == 1'b0) ? 16'h7000 : 16'h1000;
                4'd5: audio_right = (c_clk == 1'b0) ? 16'hE000 : 16'h2000;
            endcase
        end
    end
    
    //assign audio_left = (note_div_left == 22'd1) ? 16'h0000 : (b_clk == 1'b0) ? 16'hE000 : 16'h2000;
    //assign audio_right = (note_div_right == 22'd1) ? 16'h0000 : (c_clk == 1'b0) ? 16'hE000 : 16'h2000;
endmodule