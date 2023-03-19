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

`define sil   32'd50000000 // slience

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