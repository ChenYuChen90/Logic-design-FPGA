`define c2      32'd131     // C2
`define hc2     32'd138     // #C2
`define d2      32'd147     // D2
`define hd2     32'd155     // #D2
`define e2      32'd165     // E2
`define f2      32'd174     // F2
`define hf2     32'd185     // #F2
`define g2      32'd196     // G2
`define hg2     32'd207     // #G2
`define a2      32'd220     // A2
`define ha2     32'd233     // #A2
`define b2      32'd247     // B2

`define c3       32'd262     // C3
`define hc3     32'd277     // #C3
`define d3       32'd294     // D3
`define hd3     32'd311     // #D3
`define e3       32'd330     // E3
`define f3       32'd349     // F3
`define hf3     32'd369     // #F3
`define g3       32'd392     // G3
`define hg3     32'd415     // #G3
`define a3      32'd440     // A3
`define ha3     32'd466     // #A3
`define b3       32'd494     // B3

`define c4      32'd524     // C4
`define hc4     32'd554     // #C4
`define d4      32'd588     // D4
`define hd4     32'd622     // #D4
`define e4      32'd660     // E4
`define f4      32'd698     // F4
`define hf4     32'd739     // #F4
`define g4      32'd784     // G4
`define hg4     32'd830     // #G4
`define a4      32'd880     // A4
`define ha4     32'd932     // #A4
`define b4      32'd988     // B4

`define sil   32'd50000000 // slience

module music_example (
	input [11:0] ibeatNum,
	input en,
	output reg [31:0] toneL,
    output reg [31:0] toneR
    );

    always @* begin
        if(en == 1) begin
            case(ibeatNum)
                12'd0: toneL = `b3;    12'd1: toneL = `b3;
                12'd2: toneL = `b3;    12'd3: toneL = `b3;
                12'd4: toneL = `b3;    12'd5: toneL = `b3;
                12'd6: toneL = `b3;    12'd7: toneL = `b3;

                12'd8: toneL = `a3;    12'd9: toneL = `a3;
                12'd10: toneL = `a3;    12'd11: toneL = `a3;
                12'd12: toneL = `a3;    12'd13: toneL = `a3;
                12'd14: toneL = `a3;    12'd15: toneL = `a3;

                12'd16: toneL = `hg3;    12'd17: toneL = `hg3;
                12'd18: toneL = `hg3;    12'd19: toneL = `hg3;
                12'd20: toneL = `hg3;    12'd21: toneL = `hg3;
                12'd22: toneL = `hg3;    12'd23: toneL = `hg3;

                12'd24: toneL = `e3;    12'd25: toneL = `e3;
                12'd26: toneL = `e3;    12'd27: toneL = `e3;
                12'd28: toneL = `e3;    12'd29: toneL = `e3;
                12'd30: toneL = `e3;    12'd31: toneL = `e3;

                12'd32: toneL = `hf3;    12'd33: toneL = `hf3;
                12'd34: toneL = `hf3;    12'd35: toneL = `hf3;
                12'd36: toneL = `hf3;    12'd37: toneL = `hf3;
                12'd38: toneL = `hf3;    12'd39: toneL = `hf3;
                12'd40: toneL = `hf3;    12'd41: toneL = `hf3;
                12'd42: toneL = `hf3;    12'd43: toneL = `hf3;
                12'd44: toneL = `hf3;    12'd45: toneL = `hf3;
                12'd46: toneL = `hf3;    12'd47: toneL = `sil;

                12'd48: toneL = `hf3;    12'd49: toneL = `hf3;
                12'd50: toneL = `hf3;    12'd51: toneL = `hf3;
                12'd52: toneL = `hf3;    12'd53: toneL = `hf3;
                12'd54: toneL = `hf3;    12'd55: toneL = `hf3;

                12'd56: toneL = `hc4;    12'd57: toneL = `hc4;
                12'd58: toneL = `hc4;    12'd59: toneL = `hc4;
                12'd60: toneL = `hc4;    12'd61: toneL = `hc4;
                12'd62: toneL = `hc4;    12'd63: toneL = `hc4;

                12'd64: toneL = `b3;    12'd65: toneL = `b3;
                12'd66: toneL = `b3;    12'd67: toneL = `b3;
                12'd68: toneL = `b3;    12'd69: toneL = `b3;
                12'd70: toneL = `b3;    12'd71: toneL = `b3;
                12'd72: toneL = `b3;    12'd73: toneL = `b3;
                12'd74: toneL = `b3;    12'd75: toneL = `b3;
                12'd76: toneL = `b3;    12'd77: toneL = `b3;
                12'd78: toneL = `b3;    12'd79: toneL = `b3;

                12'd80: toneL = `a3;    12'd81: toneL = `a3;
                12'd82: toneL = `a3;    12'd83: toneL = `a3;
                12'd84: toneL = `a3;    12'd85: toneL = `a3;
                12'd86: toneL = `a3;    12'd87: toneL = `a3;
                12'd88: toneL = `a3;    12'd89: toneL = `a3;
                12'd90: toneL = `a3;    12'd91: toneL = `a3;
                12'd92: toneL = `a3;    12'd93: toneL = `a3;
                12'd94: toneL = `a3;    12'd95: toneL = `a3;

                12'd96: toneL = `hg3;    12'd97: toneL = `hg3;
                12'd98: toneL = `hg3;    12'd99: toneL = `hg3;
                12'd100: toneL = `hg3;    12'd101: toneL = `hg3;
                12'd102: toneL = `hg3;    12'd103: toneL = `hg3;
                12'd104: toneL = `hg3;    12'd105: toneL = `hg3;
                12'd106: toneL = `hg3;    12'd107: toneL = `hg3;
                12'd108: toneL = `hg3;    12'd109: toneL = `hg3;
                12'd110: toneL = `hg3;    12'd111: toneL = `sil;

                12'd112: toneL = `hg3;    12'd113: toneL = `hg3;
                12'd114: toneL = `hg3;    12'd115: toneL = `hg3;
                12'd116: toneL = `hg3;    12'd117: toneL = `hg3;
                12'd118: toneL = `hg3;    12'd119: toneL = `sil;

                12'd120: toneL = `hg3;    12'd121: toneL = `hg3;
                12'd122: toneL = `hg3;    12'd123: toneL = `hg3;
                12'd124: toneL = `hg3;    12'd125: toneL = `hg3;
                12'd126: toneL = `hg3;    12'd127: toneL = `hg3;

                12'd128: toneL = `b3;    12'd129: toneL = `b3;
                12'd130: toneL = `b3;    12'd131: toneL = `b3;
                12'd132: toneL = `b3;    12'd133: toneL = `b3;
                12'd134: toneL = `b3;    12'd135: toneL = `b3;
                12'd136: toneL = `b3;    12'd137: toneL = `b3;
                12'd138: toneL = `b3;    12'd139: toneL = `b3;
                12'd140: toneL = `b3;    12'd141: toneL = `b3;
                12'd142: toneL = `b3;    12'd143: toneL = `b3;

                12'd144: toneL = `a3;    12'd145: toneL = `a3;
                12'd146: toneL = `a3;    12'd147: toneL = `a3;
                12'd148: toneL = `a3;    12'd149: toneL = `a3;
                12'd150: toneL = `a3;    12'd151: toneL = `a3;

                12'd152: toneL = `hg3;    12'd153: toneL = `hg3;
                12'd154: toneL = `hg3;    12'd155: toneL = `hg3;
                12'd156: toneL = `hg3;    12'd157: toneL = `hg3;
                12'd158: toneL = `hg3;    12'd159: toneL = `hg3;

                12'd160: toneL = `hf3;    12'd161: toneL = `hf3;
                12'd162: toneL = `hf3;    12'd163: toneL = `hf3;
                12'd164: toneL = `hf3;    12'd165: toneL = `hf3;
                12'd166: toneL = `hf3;    12'd167: toneL = `hf3;
                12'd168: toneL = `hf3;    12'd169: toneL = `hf3;
                12'd170: toneL = `hf3;    12'd171: toneL = `hf3;
                12'd172: toneL = `hf3;    12'd173: toneL = `hf3;
                12'd174: toneL = `hf3;    12'd175: toneL = `sil;

                12'd176: toneL = `hf3;    12'd177: toneL = `hf3;
                12'd178: toneL = `hf3;    12'd179: toneL = `hf3;
                12'd180: toneL = `hf3;    12'd181: toneL = `hf3;
                12'd182: toneL = `hf3;    12'd183: toneL = `hf3;

                12'd184: toneL = `a4;    12'd185: toneL = `a4;
                12'd186: toneL = `a4;    12'd187: toneL = `a4;
                12'd188: toneL = `a4;    12'd189: toneL = `a4;
                12'd190: toneL = `a4;    12'd191: toneL = `a4;

                12'd192: toneL = `hg4;    12'd193: toneL = `hg4;
                12'd194: toneL = `hg4;    12'd195: toneL = `hg4;
                12'd196: toneL = `hg4;    12'd197: toneL = `hg4;
                12'd198: toneL = `hg4;    12'd199: toneL = `hg4;

                12'd200: toneL = `a4;    12'd201: toneL = `a4;
                12'd202: toneL = `a4;    12'd203: toneL = `a4;
                12'd204: toneL = `a4;    12'd205: toneL = `a4;
                12'd206: toneL = `a4;    12'd207: toneL = `a4;

                12'd208: toneL = `hg4;    12'd209: toneL = `hg4;
                12'd210: toneL = `hg4;    12'd211: toneL = `hg4;
                12'd212: toneL = `hg4;    12'd213: toneL = `hg4;
                12'd214: toneL = `hg4;    12'd215: toneL = `hg4;

                12'd216: toneL = `a4;    12'd217: toneL = `a4;
                12'd218: toneL = `a4;    12'd219: toneL = `a4;
                12'd220: toneL = `a4;    12'd221: toneL = `a4;
                12'd222: toneL = `a4;    12'd223: toneL = `a4;

                12'd224: toneL = `hf3;    12'd225: toneL = `hf3;
                12'd226: toneL = `hf3;    12'd227: toneL = `hf3;
                12'd228: toneL = `hf3;    12'd229: toneL = `hf3;
                12'd230: toneL = `hf3;    12'd231: toneL = `hf3;
                12'd232: toneL = `hf3;    12'd233: toneL = `hf3;
                12'd234: toneL = `hf3;    12'd235: toneL = `hf3;
                12'd236: toneL = `hf3;    12'd237: toneL = `hf3;
                12'd238: toneL = `hf3;    12'd239: toneL = `sil;

                12'd240: toneL = `hf3;    12'd241: toneL = `hf3;
                12'd242: toneL = `hf3;    12'd243: toneL = `hf3;
                12'd244: toneL = `hf3;    12'd245: toneL = `hf3;
                12'd246: toneL = `hf3;    12'd247: toneL = `hf3;

                12'd248: toneL = `a4;    12'd249: toneL = `a4;
                12'd250: toneL = `a4;    12'd251: toneL = `a4;
                12'd252: toneL = `a4;    12'd253: toneL = `a4;
                12'd254: toneL = `a4;    12'd255: toneL = `a4;

                12'd256: toneL = `hg4;    12'd257: toneL = `hg4;
                12'd258: toneL = `hg4;    12'd259: toneL = `hg4;
                12'd260: toneL = `hg4;    12'd261: toneL = `hg4;
                12'd262: toneL = `hg4;    12'd263: toneL = `hg4;

                12'd264: toneL = `a4;    12'd265: toneL = `a4;
                12'd266: toneL = `a4;    12'd267: toneL = `a4;
                12'd268: toneL = `a4;    12'd269: toneL = `a4;
                12'd270: toneL = `a4;    12'd271: toneL = `a4;

                12'd272: toneL = `hg4;    12'd273: toneL = `hg4;
                12'd274: toneL = `hg4;    12'd275: toneL = `hg4;
                12'd276: toneL = `hg4;    12'd277: toneL = `hg4;
                12'd278: toneL = `hg4;    12'd279: toneL = `hg4;

                12'd280: toneL = `a4;    12'd281: toneL = `a4;
                12'd282: toneL = `a4;    12'd283: toneL = `a4;
                12'd284: toneL = `a4;    12'd285: toneL = `a4;
                12'd286: toneL = `a4;    12'd287: toneL = `a4;

                12'd288: toneL = `hf3;    12'd289: toneL = `hf3;
                12'd290: toneL = `hf3;    12'd291: toneL = `hf3;
                12'd292: toneL = `hf3;    12'd293: toneL = `hf3;
                12'd294: toneL = `hf3;    12'd295: toneL = `hf3;
                12'd296: toneL = `hf3;    12'd297: toneL = `hf3;
                12'd298: toneL = `hf3;    12'd299: toneL = `hf3;
                12'd300: toneL = `hf3;    12'd301: toneL = `hf3;
                12'd302: toneL = `hf3;    12'd303: toneL = `sil;

                12'd304: toneL = `hf3;    12'd305: toneL = `hf3;
                12'd306: toneL = `hf3;    12'd307: toneL = `hf3;
                12'd308: toneL = `hf3;    12'd309: toneL = `hf3;
                12'd310: toneL = `hf3;    12'd311: toneL = `hf3;

                12'd312: toneL = `hc4;    12'd313: toneL = `hc4;
                12'd314: toneL = `hc4;    12'd315: toneL = `hc4;
                12'd316: toneL = `hc4;    12'd317: toneL = `hc4;
                12'd318: toneL = `hc4;    12'd319: toneL = `hc4;

                12'd320: toneL = `b3;    12'd321: toneL = `b3;
                12'd322: toneL = `b3;    12'd323: toneL = `b3;
                12'd324: toneL = `b3;    12'd325: toneL = `b3;
                12'd326: toneL = `b3;    12'd327: toneL = `b3;
                12'd328: toneL = `b3;    12'd329: toneL = `b3;
                12'd330: toneL = `b3;    12'd331: toneL = `b3;
                12'd332: toneL = `b3;    12'd333: toneL = `b3;
                12'd334: toneL = `b3;    12'd335: toneL = `b3;

                12'd336: toneL = `a3;    12'd337: toneL = `a3;
                12'd338: toneL = `a3;    12'd339: toneL = `a3;
                12'd340: toneL = `a3;    12'd341: toneL = `a3;
                12'd342: toneL = `a3;    12'd343: toneL = `a3;
                12'd344: toneL = `a3;    12'd345: toneL = `a3;
                12'd346: toneL = `a3;    12'd347: toneL = `a3;
                12'd348: toneL = `a3;    12'd349: toneL = `a3;
                12'd350: toneL = `a3;    12'd351: toneL = `a3;

                12'd352: toneL = `hg3;    12'd353: toneL = `hg3;
                12'd354: toneL = `hg3;    12'd355: toneL = `hg3;
                12'd356: toneL = `hg3;    12'd357: toneL = `hg3;
                12'd358: toneL = `hg3;    12'd359: toneL = `hg3;
                12'd360: toneL = `hg3;    12'd361: toneL = `hg3;
                12'd362: toneL = `hg3;    12'd363: toneL = `hg3;
                12'd364: toneL = `hg3;    12'd365: toneL = `hg3;
                12'd366: toneL = `hg3;    12'd367: toneL = `sil;

                12'd368: toneL = `hg3;    12'd369: toneL = `hg3;
                12'd370: toneL = `hg3;    12'd371: toneL = `hg3;
                12'd372: toneL = `hg3;    12'd373: toneL = `hg3;
                12'd374: toneL = `hg3;    12'd375: toneL = `sil;

                12'd376: toneL = `hg3;    12'd377: toneL = `hg3;
                12'd378: toneL = `hg3;    12'd379: toneL = `hg3;
                12'd380: toneL = `hg3;    12'd381: toneL = `hg3;
                12'd382: toneL = `hg3;    12'd383: toneL = `hg3;

                12'd384: toneL = `b3;    12'd385: toneL = `b3;
                12'd386: toneL = `b3;    12'd387: toneL = `b3;
                12'd388: toneL = `b3;    12'd389: toneL = `b3;
                12'd390: toneL = `b3;    12'd391: toneL = `b3;
                12'd392: toneL = `b3;    12'd393: toneL = `b3;
                12'd394: toneL = `b3;    12'd395: toneL = `b3;
                12'd396: toneL = `b3;    12'd397: toneL = `b3;
                12'd398: toneL = `b3;    12'd399: toneL = `b3;

                12'd400: toneL = `a3;    12'd401: toneL = `a3;
                12'd402: toneL = `a3;    12'd403: toneL = `a3;
                12'd404: toneL = `a3;    12'd405: toneL = `a3;
                12'd406: toneL = `a3;    12'd407: toneL = `a3;

                12'd408: toneL = `hg3;    12'd409: toneL = `hg3;
                12'd410: toneL = `hg3;    12'd411: toneL = `hg3;
                12'd412: toneL = `hg3;    12'd413: toneL = `hg3;
                12'd414: toneL = `hg3;    12'd415: toneL = `hg3;

                12'd416: toneL = `hf3;    12'd417: toneL = `hf3;
                12'd418: toneL = `hf3;    12'd419: toneL = `hf3;
                12'd420: toneL = `hf3;    12'd421: toneL = `hf3;
                12'd422: toneL = `hf3;    12'd423: toneL = `hf3;
                12'd424: toneL = `hf3;    12'd425: toneL = `hf3;
                12'd426: toneL = `hf3;    12'd427: toneL = `hf3;
                12'd428: toneL = `hf3;    12'd429: toneL = `hf3;
                12'd430: toneL = `hf3;    12'd431: toneL = `sil;

                12'd432: toneL = `hf3;    12'd433: toneL = `hf3;
                12'd434: toneL = `hf3;    12'd435: toneL = `hf3;
                12'd436: toneL = `hf3;    12'd437: toneL = `hf3;
                12'd438: toneL = `hf3;    12'd439: toneL = `hf3;

                12'd440: toneL = `a4;    12'd441: toneL = `a4;
                12'd442: toneL = `a4;    12'd443: toneL = `a4;
                12'd444: toneL = `a4;    12'd445: toneL = `a4;
                12'd446: toneL = `a4;    12'd447: toneL = `a4;

                12'd448: toneL = `hg4;    12'd449: toneL = `hg4;
                12'd450: toneL = `hg4;    12'd451: toneL = `hg4;
                12'd452: toneL = `hg4;    12'd453: toneL = `hg4;
                12'd454: toneL = `hg4;    12'd455: toneL = `hg4;

                12'd456: toneL = `a4;    12'd457: toneL = `a4;
                12'd458: toneL = `a4;    12'd459: toneL = `a4;
                12'd460: toneL = `a4;    12'd461: toneL = `a4;
                12'd462: toneL = `a4;    12'd463: toneL = `a4;

                12'd464: toneL = `hg4;    12'd465: toneL = `hg4;
                12'd466: toneL = `hg4;    12'd467: toneL = `hg4;
                12'd468: toneL = `hg4;    12'd469: toneL = `hg4;
                12'd470: toneL = `hg4;    12'd471: toneL = `hg4;

                12'd472: toneL = `a4;    12'd473: toneL = `a4;
                12'd474: toneL = `a4;    12'd475: toneL = `a4;
                12'd476: toneL = `a4;    12'd477: toneL = `a4;
                12'd478: toneL = `a4;    12'd479: toneL = `a4;

                12'd480: toneL = `hf3;    12'd481: toneL = `hf3;
                12'd482: toneL = `hf3;    12'd483: toneL = `hf3;
                12'd484: toneL = `hf3;    12'd485: toneL = `hf3;
                12'd486: toneL = `hf3;    12'd487: toneL = `hf3;
                12'd488: toneL = `hf3;    12'd489: toneL = `hf3;
                12'd490: toneL = `hf3;    12'd491: toneL = `hf3;
                12'd492: toneL = `hf3;    12'd493: toneL = `hf3;
                12'd494: toneL = `hf3;    12'd495: toneL = `sil;

                12'd496: toneL = `hf3;    12'd497: toneL = `hf3;
                12'd498: toneL = `hf3;    12'd499: toneL = `hf3;
                12'd500: toneL = `hf3;    12'd501: toneL = `hf3;
                12'd502: toneL = `hf3;    12'd503: toneL = `hf3;

                12'd504: toneL = `a4;    12'd505: toneL = `a4;
                12'd506: toneL = `a4;    12'd507: toneL = `a4;
                12'd508: toneL = `a4;    12'd509: toneL = `a4;
                12'd510: toneL = `a4;    12'd511: toneL = `a4;

                12'd512: toneL = `hg4;    12'd513: toneL = `hg4;
                12'd514: toneL = `hg4;    12'd515: toneL = `hg4;
                12'd516: toneL = `hg4;    12'd517: toneL = `hg4;
                12'd518: toneL = `hg4;    12'd519: toneL = `hg4;

                12'd520: toneL = `a4;    12'd521: toneL = `a4;
                12'd522: toneL = `a4;    12'd523: toneL = `a4;
                12'd524: toneL = `a4;    12'd525: toneL = `a4;
                12'd526: toneL = `a4;    12'd527: toneL = `a4;

                12'd528: toneL = `hg4;    12'd529: toneL = `hg4;
                12'd530: toneL = `hg4;    12'd531: toneL = `hg4;
                12'd532: toneL = `hg4;    12'd533: toneL = `hg4;
                12'd534: toneL = `hg4;    12'd535: toneL = `hg4;

                12'd536: toneL = `a4;    12'd537: toneL = `a4;
                12'd538: toneL = `a4;    12'd539: toneL = `a4;
                12'd540: toneL = `a4;    12'd541: toneL = `a4;
                12'd542: toneL = `a4;    12'd543: toneL = `a4;

                12'd544: toneL = `hf3;    12'd545: toneL = `hf3;
                12'd546: toneL = `hf3;    12'd547: toneL = `hf3;
                12'd548: toneL = `hf3;    12'd549: toneL = `hf3;
                12'd550: toneL = `hf3;    12'd551: toneL = `hf3;
                12'd552: toneL = `hf3;    12'd553: toneL = `hf3;
                12'd554: toneL = `hf3;    12'd555: toneL = `hf3;
                12'd556: toneL = `hf3;    12'd557: toneL = `hf3;
                12'd558: toneL = `hf3;    12'd559: toneL = `sil;

                12'd560: toneL = `hf3;    12'd561: toneL = `hf3;
                12'd562: toneL = `hf3;    12'd563: toneL = `hf3;
                12'd564: toneL = `hf3;    12'd565: toneL = `hf3;
                12'd566: toneL = `hf3;    12'd567: toneL = `hf3;

                12'd568: toneL = `hc4;    12'd569: toneL = `hc4;
                12'd570: toneL = `hc4;    12'd571: toneL = `hc4;
                12'd572: toneL = `hc4;    12'd573: toneL = `hc4;
                12'd574: toneL = `hc4;    12'd575: toneL = `hc4;

                12'd576: toneL = `b3;    12'd577: toneL = `b3;
                12'd578: toneL = `b3;    12'd579: toneL = `b3;
                12'd580: toneL = `b3;    12'd581: toneL = `b3;
                12'd582: toneL = `b3;    12'd583: toneL = `b3;
                12'd584: toneL = `b3;    12'd585: toneL = `b3;
                12'd586: toneL = `b3;    12'd587: toneL = `b3;
                12'd588: toneL = `b3;    12'd589: toneL = `b3;
                12'd590: toneL = `b3;    12'd591: toneL = `b3;

                12'd592: toneL = `a3;    12'd593: toneL = `a3;
                12'd594: toneL = `a3;    12'd595: toneL = `a3;
                12'd596: toneL = `a3;    12'd597: toneL = `a3;
                12'd598: toneL = `a3;    12'd599: toneL = `a3;
                12'd600: toneL = `a3;    12'd601: toneL = `a3;
                12'd602: toneL = `a3;    12'd603: toneL = `a3;
                12'd604: toneL = `a3;    12'd605: toneL = `a3;
                12'd606: toneL = `a3;    12'd607: toneL = `a3;

                12'd608: toneL = `hg3;    12'd609: toneL = `hg3;
                12'd610: toneL = `hg3;    12'd611: toneL = `hg3;
                12'd612: toneL = `hg3;    12'd613: toneL = `hg3;
                12'd614: toneL = `hg3;    12'd615: toneL = `hg3;
                12'd616: toneL = `hg3;    12'd617: toneL = `hg3;
                12'd618: toneL = `hg3;    12'd619: toneL = `hg3;
                12'd620: toneL = `hg3;    12'd621: toneL = `hg3;
                12'd622: toneL = `hg3;    12'd623: toneL = `sil;

                12'd624: toneL = `hg3;    12'd625: toneL = `hg3;
                12'd626: toneL = `hg3;    12'd627: toneL = `hg3;
                12'd628: toneL = `hg3;    12'd629: toneL = `hg3;
                12'd630: toneL = `hg3;    12'd631: toneL = `sil;

                12'd632: toneL = `hg3;    12'd633: toneL = `hg3;
                12'd634: toneL = `hg3;    12'd635: toneL = `hg3;
                12'd636: toneL = `hg3;    12'd637: toneL = `hg3;
                12'd638: toneL = `hg3;    12'd639: toneL = `hg3;

                12'd640: toneL = `b3;    12'd641: toneL = `b3;
                12'd642: toneL = `b3;    12'd643: toneL = `b3;
                12'd644: toneL = `b3;    12'd645: toneL = `b3;
                12'd646: toneL = `b3;    12'd647: toneL = `b3;
                12'd648: toneL = `b3;    12'd649: toneL = `b3;
                12'd650: toneL = `b3;    12'd651: toneL = `b3;
                12'd652: toneL = `b3;    12'd653: toneL = `b3;
                12'd654: toneL = `b3;    12'd655: toneL = `b3;

                12'd656: toneL = `a3;    12'd657: toneL = `a3;
                12'd658: toneL = `a3;    12'd659: toneL = `a3;
                12'd660: toneL = `a3;    12'd661: toneL = `a3;
                12'd662: toneL = `a3;    12'd663: toneL = `a3;

                12'd664: toneL = `hg3;    12'd665: toneL = `hg3;
                12'd666: toneL = `hg3;    12'd667: toneL = `hg3;
                12'd668: toneL = `hg3;    12'd669: toneL = `hg3;
                12'd670: toneL = `hg3;    12'd671: toneL = `hg3;

                12'd672: toneL = `hf3;    12'd673: toneL = `hf3;
                12'd674: toneL = `hf3;    12'd675: toneL = `hf3;
                12'd676: toneL = `hf3;    12'd677: toneL = `hf3;
                12'd678: toneL = `hf3;    12'd679: toneL = `hf3;
                12'd680: toneL = `hf3;    12'd681: toneL = `hf3;
                12'd682: toneL = `hf3;    12'd683: toneL = `hf3;
                12'd684: toneL = `hf3;    12'd685: toneL = `hf3;
                12'd686: toneL = `hf3;    12'd687: toneL = `sil;

                12'd688: toneL = `hf3;    12'd689: toneL = `hf3;
                12'd690: toneL = `hf3;    12'd691: toneL = `hf3;
                12'd692: toneL = `hf3;    12'd693: toneL = `hf3;
                12'd694: toneL = `hf3;    12'd695: toneL = `hf3;

                12'd696: toneL = `a4;    12'd697: toneL = `a4;
                12'd698: toneL = `a4;    12'd699: toneL = `a4;
                12'd700: toneL = `a4;    12'd701: toneL = `a4;
                12'd702: toneL = `a4;    12'd703: toneL = `a4;

                12'd704: toneL = `hg4;    12'd705: toneL = `hg4;
                12'd706: toneL = `hg4;    12'd707: toneL = `hg4;
                12'd708: toneL = `hg4;    12'd709: toneL = `hg4;
                12'd710: toneL = `hg4;    12'd711: toneL = `hg4;

                12'd712: toneL = `a4;    12'd713: toneL = `a4;
                12'd714: toneL = `a4;    12'd715: toneL = `a4;
                12'd716: toneL = `a4;    12'd717: toneL = `a4;
                12'd718: toneL = `a4;    12'd719: toneL = `a4;

                12'd720: toneL = `hg4;    12'd721: toneL = `hg4;
                12'd722: toneL = `hg4;    12'd723: toneL = `hg4;
                12'd724: toneL = `hg4;    12'd725: toneL = `hg4;
                12'd726: toneL = `hg4;    12'd727: toneL = `hg4;

                12'd728: toneL = `a4;    12'd729: toneL = `a4;
                12'd730: toneL = `a4;    12'd731: toneL = `a4;
                12'd732: toneL = `a4;    12'd733: toneL = `a4;
                12'd734: toneL = `a4;    12'd735: toneL = `a4;

                12'd736: toneL = `hf3;    12'd737: toneL = `hf3;
                12'd738: toneL = `hf3;    12'd739: toneL = `hf3;
                12'd740: toneL = `hf3;    12'd741: toneL = `hf3;
                12'd742: toneL = `hf3;    12'd743: toneL = `hf3;
                12'd744: toneL = `hf3;    12'd745: toneL = `hf3;
                12'd746: toneL = `hf3;    12'd747: toneL = `hf3;
                12'd748: toneL = `hf3;    12'd749: toneL = `hf3;
                12'd750: toneL = `hf3;    12'd751: toneL = `sil;

                12'd752: toneL = `hf3;    12'd753: toneL = `hf3;
                12'd754: toneL = `hf3;    12'd755: toneL = `hf3;
                12'd756: toneL = `hf3;    12'd757: toneL = `hf3;
                12'd758: toneL = `hf3;    12'd759: toneL = `hf3;

                12'd760: toneL = `a4;    12'd761: toneL = `a4;
                12'd762: toneL = `a4;    12'd763: toneL = `a4;
                12'd764: toneL = `a4;    12'd765: toneL = `a4;
                12'd766: toneL = `a4;    12'd767: toneL = `a4;

                12'd768: toneL = `hg4;    12'd769: toneL = `hg4;
                12'd770: toneL = `hg4;    12'd771: toneL = `hg4;
                12'd772: toneL = `hg4;    12'd773: toneL = `hg4;
                12'd774: toneL = `hg4;    12'd775: toneL = `hg4;

                12'd776: toneL = `a4;    12'd777: toneL = `a4;
                12'd778: toneL = `a4;    12'd779: toneL = `a4;
                12'd780: toneL = `a4;    12'd781: toneL = `a4;
                12'd782: toneL = `a4;    12'd783: toneL = `a4;

                12'd784: toneL = `hg4;    12'd785: toneL = `hg4;
                12'd786: toneL = `hg4;    12'd787: toneL = `hg4;
                12'd788: toneL = `hg4;    12'd789: toneL = `hg4;
                12'd790: toneL = `hg4;    12'd791: toneL = `hg4;

                12'd792: toneL = `a4;    12'd793: toneL = `a4;
                12'd794: toneL = `a4;    12'd795: toneL = `a4;
                12'd796: toneL = `a4;    12'd797: toneL = `a4;
                12'd798: toneL = `a4;    12'd799: toneL = `a4;

                12'd800: toneL = `a3;    12'd801: toneL = `a3;
                12'd802: toneL = `a3;    12'd803: toneL = `a3;
                12'd804: toneL = `a3;    12'd805: toneL = `a3;
                12'd806: toneL = `a3;    12'd807: toneL = `sil;

                12'd808: toneL = `a3;    12'd809: toneL = `a3;
                12'd810: toneL = `a3;    12'd811: toneL = `a3;
                12'd812: toneL = `a3;    12'd813: toneL = `a3;
                12'd814: toneL = `a3;    12'd815: toneL = `sil;

                12'd816: toneL = `a3;    12'd817: toneL = `a3;
                12'd818: toneL = `a3;    12'd819: toneL = `a3;
                12'd820: toneL = `a3;    12'd821: toneL = `a3;
                12'd822: toneL = `a3;    12'd823: toneL = `sil;

                12'd824: toneL = `a3;    12'd825: toneL = `a3;
                12'd826: toneL = `a3;    12'd827: toneL = `a3;
                12'd828: toneL = `a3;    12'd829: toneL = `a3;
                12'd830: toneL = `a3;    12'd831: toneL = `sil;

                12'd832: toneL = `hc4;    12'd833: toneL = `hc4;
                12'd834: toneL = `hc4;    12'd835: toneL = `hc4;
                12'd836: toneL = `hc4;    12'd837: toneL = `hc4;
                12'd838: toneL = `hc4;    12'd839: toneL = `sil;

                12'd840: toneL = `hc4;    12'd841: toneL = `hc4;
                12'd842: toneL = `hc4;    12'd843: toneL = `hc4;
                12'd844: toneL = `hc4;    12'd845: toneL = `hc4;
                12'd846: toneL = `hc4;    12'd847: toneL = `sil;

                12'd848: toneL = `hc4;    12'd849: toneL = `hc4;
                12'd850: toneL = `hc4;    12'd851: toneL = `hc4;
                12'd852: toneL = `hc4;    12'd853: toneL = `hc4;
                12'd854: toneL = `hc4;    12'd855: toneL = `sil;

                12'd856: toneL = `hc4;    12'd857: toneL = `hc4;
                12'd858: toneL = `hc4;    12'd859: toneL = `hc4;
                12'd860: toneL = `hc4;    12'd861: toneL = `hc4;
                12'd862: toneL = `hc4;    12'd863: toneL = `sil;

                12'd864: toneL = `b3;    12'd865: toneL = `b3;
                12'd866: toneL = `b3;    12'd867: toneL = `b3;
                12'd868: toneL = `b3;    12'd869: toneL = `b3;
                12'd870: toneL = `b3;    12'd871: toneL = `sil;

                12'd872: toneL = `b3;    12'd873: toneL = `b3;
                12'd874: toneL = `b3;    12'd875: toneL = `b3;
                12'd876: toneL = `b3;    12'd877: toneL = `b3;
                12'd878: toneL = `b3;    12'd879: toneL = `sil;

                12'd880: toneL = `b3;    12'd881: toneL = `b3;
                12'd882: toneL = `b3;    12'd883: toneL = `b3;
                12'd884: toneL = `b3;    12'd885: toneL = `b3;
                12'd886: toneL = `b3;    12'd887: toneL = `sil;

                12'd888: toneL = `b3;    12'd889: toneL = `b3;
                12'd890: toneL = `b3;    12'd891: toneL = `b3;
                12'd892: toneL = `b3;    12'd893: toneL = `b3;
                12'd894: toneL = `b3;    12'd895: toneL = `sil;

                12'd896: toneL = `e4;    12'd897: toneL = `e4;
                12'd898: toneL = `e4;    12'd899: toneL = `e4;
                12'd900: toneL = `e4;    12'd901: toneL = `e4;
                12'd902: toneL = `e4;    12'd903: toneL = `sil;

                12'd904: toneL = `e4;    12'd905: toneL = `e4;
                12'd906: toneL = `e4;    12'd907: toneL = `e4;
                12'd908: toneL = `e4;    12'd909: toneL = `e4;
                12'd910: toneL = `e4;    12'd911: toneL = `sil;

                12'd912: toneL = `e4;    12'd913: toneL = `e4;
                12'd914: toneL = `e4;    12'd915: toneL = `e4;
                12'd916: toneL = `e4;    12'd917: toneL = `e4;
                12'd918: toneL = `e4;    12'd919: toneL = `sil;

                12'd920: toneL = `e4;    12'd921: toneL = `e4;
                12'd922: toneL = `e4;    12'd923: toneL = `e4;
                12'd924: toneL = `e4;    12'd925: toneL = `e4;
                12'd926: toneL = `e4;    12'd927: toneL = `sil;

                12'd928: toneL = `hf4;    12'd929: toneL = `hf4;
                12'd930: toneL = `hf4;    12'd931: toneL = `hf4;
                12'd932: toneL = `hf4;    12'd933: toneL = `hf4;
                12'd934: toneL = `hf4;    12'd935: toneL = `sil;

                12'd936: toneL = `hf4;    12'd937: toneL = `hf4;
                12'd938: toneL = `hf4;    12'd939: toneL = `hf4;
                12'd940: toneL = `hf4;    12'd941: toneL = `hf4;
                12'd942: toneL = `hf4;    12'd943: toneL = `sil;

                12'd944: toneL = `hf4;    12'd945: toneL = `hf4;
                12'd946: toneL = `hf4;    12'd947: toneL = `hf4;
                12'd948: toneL = `hf4;    12'd949: toneL = `hf4;
                12'd950: toneL = `hf4;    12'd951: toneL = `sil;

                12'd952: toneL = `hf4;    12'd953: toneL = `hf4;
                12'd954: toneL = `hf4;    12'd955: toneL = `hf4;
                12'd956: toneL = `hf4;    12'd957: toneL = `hf4;
                12'd958: toneL = `hf4;    12'd959: toneL = `sil;

                12'd960: toneL = `hf4;    12'd961: toneL = `hf4;
                12'd962: toneL = `hf4;    12'd963: toneL = `hf4;
                12'd964: toneL = `hf4;    12'd965: toneL = `hf4;
                12'd966: toneL = `hf4;    12'd967: toneL = `sil;

                12'd968: toneL = `hf4;    12'd969: toneL = `hf4;
                12'd970: toneL = `hf4;    12'd971: toneL = `hf4;
                12'd972: toneL = `hf4;    12'd973: toneL = `hf4;
                12'd974: toneL = `hf4;    12'd975: toneL = `sil;

                12'd976: toneL = `hf4;    12'd977: toneL = `hf4;
                12'd978: toneL = `hf4;    12'd979: toneL = `hf4;
                12'd980: toneL = `hf4;    12'd981: toneL = `hf4;
                12'd982: toneL = `hf4;    12'd983: toneL = `sil;

                12'd984: toneL = `hf4;    12'd985: toneL = `hf4;
                12'd986: toneL = `hf4;    12'd987: toneL = `hf4;
                12'd988: toneL = `hf4;    12'd989: toneL = `hf4;
                12'd990: toneL = `hf4;    12'd991: toneL = `sil;

                12'd992: toneL = `hf4;    12'd993: toneL = `hf4;
                12'd994: toneL = `hf4;    12'd995: toneL = `hf4;
                12'd996: toneL = `hf4;    12'd997: toneL = `hf4;
                12'd998: toneL = `hf4;    12'd999: toneL = `sil;

                12'd1000: toneL = `hf4;    12'd1001: toneL = `hf4;
                12'd1002: toneL = `hf4;    12'd1003: toneL = `hf4;
                12'd1004: toneL = `hf4;    12'd1005: toneL = `hf4;
                12'd1006: toneL = `hf4;    12'd1007: toneL = `sil;

                12'd1008: toneL = `hf4;    12'd1009: toneL = `hf4;
                12'd1010: toneL = `hf4;    12'd1011: toneL = `hf4;
                12'd1012: toneL = `hf4;    12'd1013: toneL = `hf4;
                12'd1014: toneL = `hf4;    12'd1015: toneL = `sil;

                12'd1016: toneL = `hf4;    12'd1017: toneL = `hf4;
                12'd1018: toneL = `hf4;    12'd1019: toneL = `hf4;
                12'd1020: toneL = `hf4;    12'd1021: toneL = `hf4;
                12'd1022: toneL = `hf4;    12'd1023: toneL = `sil;
                default: toneL = `sil;
            endcase
        end else begin
            toneL = `sil;
        end
    end

    always @(*) begin
        if(en == 1)begin
            case(ibeatNum)
                12'd0: toneR = `sil;    12'd1: toneR = `sil;
                12'd2: toneR = `sil;    12'd3: toneR = `sil;
                12'd4: toneR = `sil;    12'd5: toneR = `sil;
                12'd6: toneR = `sil;    12'd7: toneR = `sil;
                12'd8: toneR = `sil;    12'd9: toneR = `sil;
                12'd10: toneR = `sil;    12'd11: toneR = `sil;
                12'd12: toneR = `sil;    12'd13: toneR = `sil;
                12'd14: toneR = `sil;    12'd15: toneR = `sil;
                12'd16: toneR = `sil;    12'd17: toneR = `sil;
                12'd18: toneR = `sil;    12'd19: toneR = `sil;
                12'd20: toneR = `sil;    12'd21: toneR = `sil;
                12'd22: toneR = `sil;    12'd23: toneR = `sil;
                12'd24: toneR = `sil;    12'd25: toneR = `sil;
                12'd26: toneR = `sil;    12'd27: toneR = `sil;
                12'd28: toneR = `sil;    12'd29: toneR = `sil;
                12'd30: toneR = `sil;    12'd31: toneR = `sil;

                12'd32: toneR = `d2;    12'd33: toneR = `d2;
                12'd34: toneR = `d2;    12'd35: toneR = `d2;
                12'd36: toneR = `d2;    12'd37: toneR = `d2;
                12'd38: toneR = `d2;    12'd39: toneR = `d2;
                12'd40: toneR = `d2;    12'd41: toneR = `d2;
                12'd42: toneR = `d2;    12'd43: toneR = `d2;
                12'd44: toneR = `d2;    12'd45: toneR = `d2;
                12'd46: toneR = `d2;    12'd47: toneR = `d2;
                12'd48: toneR = `d2;    12'd49: toneR = `d2;
                12'd50: toneR = `d2;    12'd51: toneR = `d2;
                12'd52: toneR = `d2;    12'd53: toneR = `d2;
                12'd54: toneR = `d2;    12'd55: toneR = `d2;
                12'd56: toneR = `d2;    12'd57: toneR = `d2;
                12'd58: toneR = `d2;    12'd59: toneR = `d2;
                12'd60: toneR = `d2;    12'd61: toneR = `d2;
                12'd62: toneR = `d2;    12'd63: toneR = `d2;
                12'd64: toneR = `d2;    12'd65: toneR = `d2;
                12'd66: toneR = `d2;    12'd67: toneR = `d2;
                12'd68: toneR = `d2;    12'd69: toneR = `d2;
                12'd70: toneR = `d2;    12'd71: toneR = `d2;
                12'd72: toneR = `d2;    12'd73: toneR = `d2;
                12'd74: toneR = `d2;    12'd75: toneR = `d2;
                12'd76: toneR = `d2;    12'd77: toneR = `d2;
                12'd78: toneR = `d2;    12'd79: toneR = `d2;
                12'd80: toneR = `d2;    12'd81: toneR = `d2;
                12'd82: toneR = `d2;    12'd83: toneR = `d2;
                12'd84: toneR = `d2;    12'd85: toneR = `d2;
                12'd86: toneR = `d2;    12'd87: toneR = `d2;
                12'd88: toneR = `d2;    12'd89: toneR = `d2;
                12'd90: toneR = `d2;    12'd91: toneR = `d2;
                12'd92: toneR = `d2;    12'd93: toneR = `d2;
                12'd94: toneR = `d2;    12'd95: toneR = `d2;

                12'd96: toneR = `e2;    12'd97: toneR = `e2;
                12'd98: toneR = `e2;    12'd99: toneR = `e2;
                12'd100: toneR = `e2;    12'd101: toneR = `e2;
                12'd102: toneR = `e2;    12'd103: toneR = `e2;
                12'd104: toneR = `e2;    12'd105: toneR = `e2;
                12'd106: toneR = `e2;    12'd107: toneR = `e2;
                12'd108: toneR = `e2;    12'd109: toneR = `e2;
                12'd110: toneR = `e2;    12'd111: toneR = `e2;
                12'd112: toneR = `e2;    12'd113: toneR = `e2;
                12'd114: toneR = `e2;    12'd115: toneR = `e2;
                12'd116: toneR = `e2;    12'd117: toneR = `e2;
                12'd118: toneR = `e2;    12'd119: toneR = `e2;
                12'd120: toneR = `e2;    12'd121: toneR = `e2;
                12'd122: toneR = `e2;    12'd123: toneR = `e2;
                12'd124: toneR = `e2;    12'd125: toneR = `e2;
                12'd126: toneR = `e2;    12'd127: toneR = `e2;
                12'd128: toneR = `e2;    12'd129: toneR = `e2;
                12'd130: toneR = `e2;    12'd131: toneR = `e2;
                12'd132: toneR = `e2;    12'd133: toneR = `e2;
                12'd134: toneR = `e2;    12'd135: toneR = `e2;
                12'd136: toneR = `e2;    12'd137: toneR = `e2;
                12'd138: toneR = `e2;    12'd139: toneR = `e2;
                12'd140: toneR = `e2;    12'd141: toneR = `e2;
                12'd142: toneR = `e2;    12'd143: toneR = `e2;
                12'd144: toneR = `e2;    12'd145: toneR = `e2;
                12'd146: toneR = `e2;    12'd147: toneR = `e2;
                12'd148: toneR = `e2;    12'd149: toneR = `e2;
                12'd150: toneR = `e2;    12'd151: toneR = `e2;
                12'd152: toneR = `e2;    12'd153: toneR = `e2;
                12'd154: toneR = `e2;    12'd155: toneR = `e2;
                12'd156: toneR = `e2;    12'd157: toneR = `e2;
                12'd158: toneR = `e2;    12'd159: toneR = `e2;

                12'd160: toneR = `hf2;    12'd161: toneR = `hf2;
                12'd162: toneR = `hf2;    12'd163: toneR = `hf2;
                12'd164: toneR = `hf2;    12'd165: toneR = `hf2;
                12'd166: toneR = `hf2;    12'd167: toneR = `hf2;
                12'd168: toneR = `hf2;    12'd169: toneR = `hf2;
                12'd170: toneR = `hf2;    12'd171: toneR = `hf2;
                12'd172: toneR = `hf2;    12'd173: toneR = `hf2;
                12'd174: toneR = `hf2;    12'd175: toneR = `hf2;
                12'd176: toneR = `hf2;    12'd177: toneR = `hf2;
                12'd178: toneR = `hf2;    12'd179: toneR = `hf2;
                12'd180: toneR = `hf2;    12'd181: toneR = `hf2;
                12'd182: toneR = `hf2;    12'd183: toneR = `hf2;
                12'd184: toneR = `hf2;    12'd185: toneR = `hf2;
                12'd186: toneR = `hf2;    12'd187: toneR = `hf2;
                12'd188: toneR = `hf2;    12'd189: toneR = `hf2;
                12'd190: toneR = `hf2;    12'd191: toneR = `hf2;
                12'd192: toneR = `hf2;    12'd193: toneR = `hf2;
                12'd194: toneR = `hf2;    12'd195: toneR = `hf2;
                12'd196: toneR = `hf2;    12'd197: toneR = `hf2;
                12'd198: toneR = `hf2;    12'd199: toneR = `hf2;
                12'd200: toneR = `hf2;    12'd201: toneR = `hf2;
                12'd202: toneR = `hf2;    12'd203: toneR = `hf2;
                12'd204: toneR = `hf2;    12'd205: toneR = `hf2;
                12'd206: toneR = `hf2;    12'd207: toneR = `hf2;
                12'd208: toneR = `hf2;    12'd209: toneR = `hf2;
                12'd210: toneR = `hf2;    12'd211: toneR = `hf2;
                12'd212: toneR = `hf2;    12'd213: toneR = `hf2;
                12'd214: toneR = `hf2;    12'd215: toneR = `hf2;
                12'd216: toneR = `hf2;    12'd217: toneR = `hf2;
                12'd218: toneR = `hf2;    12'd219: toneR = `hf2;
                12'd220: toneR = `hf2;    12'd221: toneR = `hf2;
                12'd222: toneR = `hf2;    12'd223: toneR = `sil;

                12'd224: toneR = `hf2;    12'd225: toneR = `hf2;
                12'd226: toneR = `hf2;    12'd227: toneR = `hf2;
                12'd228: toneR = `hf2;    12'd229: toneR = `hf2;
                12'd230: toneR = `hf2;    12'd231: toneR = `hf2;
                12'd232: toneR = `hf2;    12'd233: toneR = `hf2;
                12'd234: toneR = `hf2;    12'd235: toneR = `hf2;
                12'd236: toneR = `hf2;    12'd237: toneR = `hf2;
                12'd238: toneR = `hf2;    12'd239: toneR = `hf2;
                12'd240: toneR = `hf2;    12'd241: toneR = `hf2;
                12'd242: toneR = `hf2;    12'd243: toneR = `hf2;
                12'd244: toneR = `hf2;    12'd245: toneR = `hf2;
                12'd246: toneR = `hf2;    12'd247: toneR = `hf2;
                12'd248: toneR = `hf2;    12'd249: toneR = `hf2;
                12'd250: toneR = `hf2;    12'd251: toneR = `hf2;
                12'd252: toneR = `hf2;    12'd253: toneR = `hf2;
                12'd254: toneR = `hf2;    12'd255: toneR = `hf2;
                12'd256: toneR = `hf2;    12'd257: toneR = `hf2;
                12'd258: toneR = `hf2;    12'd259: toneR = `hf2;
                12'd260: toneR = `hf2;    12'd261: toneR = `hf2;
                12'd262: toneR = `hf2;    12'd263: toneR = `hf2;
                12'd264: toneR = `hf2;    12'd265: toneR = `hf2;
                12'd266: toneR = `hf2;    12'd267: toneR = `hf2;
                12'd268: toneR = `hf2;    12'd269: toneR = `hf2;
                12'd270: toneR = `hf2;    12'd271: toneR = `hf2;
                12'd272: toneR = `hf2;    12'd273: toneR = `hf2;
                12'd274: toneR = `hf2;    12'd275: toneR = `hf2;
                12'd276: toneR = `hf2;    12'd277: toneR = `hf2;
                12'd278: toneR = `hf2;    12'd279: toneR = `hf2;
                12'd280: toneR = `hf2;    12'd281: toneR = `hf2;
                12'd282: toneR = `hf2;    12'd283: toneR = `hf2;
                12'd284: toneR = `hf2;    12'd285: toneR = `hf2;
                12'd286: toneR = `hf2;    12'd287: toneR = `hf2;

                12'd288: toneR = `d2;    12'd289: toneR = `d2;
                12'd290: toneR = `d2;    12'd291: toneR = `d2;
                12'd292: toneR = `d2;    12'd293: toneR = `d2;
                12'd294: toneR = `d2;    12'd295: toneR = `d2;
                12'd296: toneR = `d2;    12'd297: toneR = `d2;
                12'd298: toneR = `d2;    12'd299: toneR = `d2;
                12'd300: toneR = `d2;    12'd301: toneR = `d2;
                12'd302: toneR = `d2;    12'd303: toneR = `d2;
                12'd304: toneR = `d2;    12'd305: toneR = `d2;
                12'd306: toneR = `d2;    12'd307: toneR = `d2;
                12'd308: toneR = `d2;    12'd309: toneR = `d2;
                12'd310: toneR = `d2;    12'd311: toneR = `d2;
                12'd312: toneR = `d2;    12'd313: toneR = `d2;
                12'd314: toneR = `d2;    12'd315: toneR = `d2;
                12'd316: toneR = `d2;    12'd317: toneR = `d2;
                12'd318: toneR = `d2;    12'd319: toneR = `d2;
                12'd320: toneR = `d2;    12'd321: toneR = `d2;
                12'd322: toneR = `d2;    12'd323: toneR = `d2;
                12'd324: toneR = `d2;    12'd325: toneR = `d2;
                12'd326: toneR = `d2;    12'd327: toneR = `d2;
                12'd328: toneR = `d2;    12'd329: toneR = `d2;
                12'd330: toneR = `d2;    12'd331: toneR = `d2;
                12'd332: toneR = `d2;    12'd333: toneR = `d2;
                12'd334: toneR = `d2;    12'd335: toneR = `d2;
                12'd336: toneR = `d2;    12'd337: toneR = `d2;
                12'd338: toneR = `d2;    12'd339: toneR = `d2;
                12'd340: toneR = `d2;    12'd341: toneR = `d2;
                12'd342: toneR = `d2;    12'd343: toneR = `d2;
                12'd344: toneR = `d2;    12'd345: toneR = `d2;
                12'd346: toneR = `d2;    12'd347: toneR = `d2;
                12'd348: toneR = `d2;    12'd349: toneR = `d2;
                12'd350: toneR = `d2;    12'd351: toneR = `d2;

                12'd352: toneR = `e2;    12'd353: toneR = `e2;
                12'd354: toneR = `e2;    12'd355: toneR = `e2;
                12'd356: toneR = `e2;    12'd357: toneR = `e2;
                12'd358: toneR = `e2;    12'd359: toneR = `e2;
                12'd360: toneR = `e2;    12'd361: toneR = `e2;
                12'd362: toneR = `e2;    12'd363: toneR = `e2;
                12'd364: toneR = `e2;    12'd365: toneR = `e2;
                12'd366: toneR = `e2;    12'd367: toneR = `e2;
                12'd368: toneR = `e2;    12'd369: toneR = `e2;
                12'd370: toneR = `e2;    12'd371: toneR = `e2;
                12'd372: toneR = `e2;    12'd373: toneR = `e2;
                12'd374: toneR = `e2;    12'd375: toneR = `e2;
                12'd376: toneR = `e2;    12'd377: toneR = `e2;
                12'd378: toneR = `e2;    12'd379: toneR = `e2;
                12'd380: toneR = `e2;    12'd381: toneR = `e2;
                12'd382: toneR = `e2;    12'd383: toneR = `e2;
                12'd384: toneR = `e2;    12'd385: toneR = `e2;
                12'd386: toneR = `e2;    12'd387: toneR = `e2;
                12'd388: toneR = `e2;    12'd389: toneR = `e2;
                12'd390: toneR = `e2;    12'd391: toneR = `e2;
                12'd392: toneR = `e2;    12'd393: toneR = `e2;
                12'd394: toneR = `e2;    12'd395: toneR = `e2;
                12'd396: toneR = `e2;    12'd397: toneR = `e2;
                12'd398: toneR = `e2;    12'd399: toneR = `e2;
                12'd400: toneR = `e2;    12'd401: toneR = `e2;
                12'd402: toneR = `e2;    12'd403: toneR = `e2;
                12'd404: toneR = `e2;    12'd405: toneR = `e2;
                12'd406: toneR = `e2;    12'd407: toneR = `e2;
                12'd408: toneR = `e2;    12'd409: toneR = `e2;
                12'd410: toneR = `e2;    12'd411: toneR = `e2;
                12'd412: toneR = `e2;    12'd413: toneR = `e2;
                12'd414: toneR = `e2;    12'd415: toneR = `e2;

                12'd416: toneR = `hf2;    12'd417: toneR = `hf2;
                12'd418: toneR = `hf2;    12'd419: toneR = `hf2;
                12'd420: toneR = `hf2;    12'd421: toneR = `hf2;
                12'd422: toneR = `hf2;    12'd423: toneR = `hf2;
                12'd424: toneR = `hf2;    12'd425: toneR = `hf2;
                12'd426: toneR = `hf2;    12'd427: toneR = `hf2;
                12'd428: toneR = `hf2;    12'd429: toneR = `hf2;
                12'd430: toneR = `hf2;    12'd431: toneR = `hf2;
                12'd432: toneR = `hf2;    12'd433: toneR = `hf2;
                12'd434: toneR = `hf2;    12'd435: toneR = `hf2;
                12'd436: toneR = `hf2;    12'd437: toneR = `hf2;
                12'd438: toneR = `hf2;    12'd439: toneR = `hf2;
                12'd440: toneR = `hf2;    12'd441: toneR = `hf2;
                12'd442: toneR = `hf2;    12'd443: toneR = `hf2;
                12'd444: toneR = `hf2;    12'd445: toneR = `hf2;
                12'd446: toneR = `hf2;    12'd447: toneR = `hf2;
                12'd448: toneR = `hf2;    12'd449: toneR = `hf2;
                12'd450: toneR = `hf2;    12'd451: toneR = `hf2;
                12'd452: toneR = `hf2;    12'd453: toneR = `hf2;
                12'd454: toneR = `hf2;    12'd455: toneR = `hf2;
                12'd456: toneR = `hf2;    12'd457: toneR = `hf2;
                12'd458: toneR = `hf2;    12'd459: toneR = `hf2;
                12'd460: toneR = `hf2;    12'd461: toneR = `hf2;
                12'd462: toneR = `hf2;    12'd463: toneR = `hf2;
                12'd464: toneR = `hf2;    12'd465: toneR = `hf2;
                12'd466: toneR = `hf2;    12'd467: toneR = `hf2;
                12'd468: toneR = `hf2;    12'd469: toneR = `hf2;
                12'd470: toneR = `hf2;    12'd471: toneR = `hf2;
                12'd472: toneR = `hf2;    12'd473: toneR = `hf2;
                12'd474: toneR = `hf2;    12'd475: toneR = `hf2;
                12'd476: toneR = `hf2;    12'd477: toneR = `hf2;
                12'd478: toneR = `hf2;    12'd479: toneR = `sil;

                12'd480: toneR = `hf2;    12'd481: toneR = `hf2;
                12'd482: toneR = `hf2;    12'd483: toneR = `hf2;
                12'd484: toneR = `hf2;    12'd485: toneR = `hf2;
                12'd486: toneR = `hf2;    12'd487: toneR = `hf2;
                12'd488: toneR = `hf2;    12'd489: toneR = `hf2;
                12'd490: toneR = `hf2;    12'd491: toneR = `hf2;
                12'd492: toneR = `hf2;    12'd493: toneR = `hf2;
                12'd494: toneR = `hf2;    12'd495: toneR = `hf2;
                12'd496: toneR = `hf2;    12'd497: toneR = `hf2;
                12'd498: toneR = `hf2;    12'd499: toneR = `hf2;
                12'd500: toneR = `hf2;    12'd501: toneR = `hf2;
                12'd502: toneR = `hf2;    12'd503: toneR = `hf2;
                12'd504: toneR = `hf2;    12'd505: toneR = `hf2;
                12'd506: toneR = `hf2;    12'd507: toneR = `hf2;
                12'd508: toneR = `hf2;    12'd509: toneR = `hf2;
                12'd510: toneR = `hf2;    12'd511: toneR = `hf2;
                12'd512: toneR = `hf2;    12'd513: toneR = `hf2;
                12'd514: toneR = `hf2;    12'd515: toneR = `hf2;
                12'd516: toneR = `hf2;    12'd517: toneR = `hf2;
                12'd518: toneR = `hf2;    12'd519: toneR = `hf2;
                12'd520: toneR = `hf2;    12'd521: toneR = `hf2;
                12'd522: toneR = `hf2;    12'd523: toneR = `hf2;
                12'd524: toneR = `hf2;    12'd525: toneR = `hf2;
                12'd526: toneR = `hf2;    12'd527: toneR = `hf2;
                12'd528: toneR = `hf2;    12'd529: toneR = `hf2;
                12'd530: toneR = `hf2;    12'd531: toneR = `hf2;
                12'd532: toneR = `hf2;    12'd533: toneR = `hf2;
                12'd534: toneR = `hf2;    12'd535: toneR = `hf2;
                12'd536: toneR = `hf2;    12'd537: toneR = `hf2;
                12'd538: toneR = `hf2;    12'd539: toneR = `hf2;
                12'd540: toneR = `hf2;    12'd541: toneR = `hf2;
                12'd542: toneR = `hf2;    12'd543: toneR = `hf2;

                12'd544: toneR = `d2;    12'd545: toneR = `d2;
                12'd546: toneR = `d2;    12'd547: toneR = `d2;
                12'd548: toneR = `d2;    12'd549: toneR = `d2;
                12'd550: toneR = `d2;    12'd551: toneR = `d2;
                12'd552: toneR = `d2;    12'd553: toneR = `d2;
                12'd554: toneR = `d2;    12'd555: toneR = `d2;
                12'd556: toneR = `d2;    12'd557: toneR = `d2;
                12'd558: toneR = `d2;    12'd559: toneR = `d2;
                12'd560: toneR = `d2;    12'd561: toneR = `d2;
                12'd562: toneR = `d2;    12'd563: toneR = `d2;
                12'd564: toneR = `d2;    12'd565: toneR = `d2;
                12'd566: toneR = `d2;    12'd567: toneR = `d2;
                12'd568: toneR = `d2;    12'd569: toneR = `d2;
                12'd570: toneR = `d2;    12'd571: toneR = `d2;
                12'd572: toneR = `d2;    12'd573: toneR = `d2;
                12'd574: toneR = `d2;    12'd575: toneR = `d2;
                12'd576: toneR = `d2;    12'd577: toneR = `d2;
                12'd578: toneR = `d2;    12'd579: toneR = `d2;
                12'd580: toneR = `d2;    12'd581: toneR = `d2;
                12'd582: toneR = `d2;    12'd583: toneR = `d2;
                12'd584: toneR = `d2;    12'd585: toneR = `d2;
                12'd586: toneR = `d2;    12'd587: toneR = `d2;
                12'd588: toneR = `d2;    12'd589: toneR = `d2;
                12'd590: toneR = `d2;    12'd591: toneR = `d2;
                12'd592: toneR = `d2;    12'd593: toneR = `d2;
                12'd594: toneR = `d2;    12'd595: toneR = `d2;
                12'd596: toneR = `d2;    12'd597: toneR = `d2;
                12'd598: toneR = `d2;    12'd599: toneR = `d2;
                12'd600: toneR = `d2;    12'd601: toneR = `d2;
                12'd602: toneR = `d2;    12'd603: toneR = `d2;
                12'd604: toneR = `d2;    12'd605: toneR = `d2;
                12'd606: toneR = `d2;    12'd607: toneR = `d2;

                12'd608: toneR = `e2;    12'd609: toneR = `e2;
                12'd610: toneR = `e2;    12'd611: toneR = `e2;
                12'd612: toneR = `e2;    12'd613: toneR = `e2;
                12'd614: toneR = `e2;    12'd615: toneR = `e2;
                12'd616: toneR = `e2;    12'd617: toneR = `e2;
                12'd618: toneR = `e2;    12'd619: toneR = `e2;
                12'd620: toneR = `e2;    12'd621: toneR = `e2;
                12'd622: toneR = `e2;    12'd623: toneR = `e2;
                12'd624: toneR = `e2;    12'd625: toneR = `e2;
                12'd626: toneR = `e2;    12'd627: toneR = `e2;
                12'd628: toneR = `e2;    12'd629: toneR = `e2;
                12'd630: toneR = `e2;    12'd631: toneR = `e2;
                12'd632: toneR = `e2;    12'd633: toneR = `e2;
                12'd634: toneR = `e2;    12'd635: toneR = `e2;
                12'd636: toneR = `e2;    12'd637: toneR = `e2;
                12'd638: toneR = `e2;    12'd639: toneR = `e2;
                12'd640: toneR = `e2;    12'd641: toneR = `e2;
                12'd642: toneR = `e2;    12'd643: toneR = `e2;
                12'd644: toneR = `e2;    12'd645: toneR = `e2;
                12'd646: toneR = `e2;    12'd647: toneR = `e2;
                12'd648: toneR = `e2;    12'd649: toneR = `e2;
                12'd650: toneR = `e2;    12'd651: toneR = `e2;
                12'd652: toneR = `e2;    12'd653: toneR = `e2;
                12'd654: toneR = `e2;    12'd655: toneR = `e2;
                12'd656: toneR = `e2;    12'd657: toneR = `e2;
                12'd658: toneR = `e2;    12'd659: toneR = `e2;
                12'd660: toneR = `e2;    12'd661: toneR = `e2;
                12'd662: toneR = `e2;    12'd663: toneR = `e2;
                12'd664: toneR = `e2;    12'd665: toneR = `e2;
                12'd666: toneR = `e2;    12'd667: toneR = `e2;
                12'd668: toneR = `e2;    12'd669: toneR = `e2;
                12'd670: toneR = `e2;    12'd671: toneR = `e2;

                12'd672: toneR = `hf2;    12'd673: toneR = `hf2;
                12'd674: toneR = `hf2;    12'd675: toneR = `hf2;
                12'd676: toneR = `hf2;    12'd677: toneR = `hf2;
                12'd678: toneR = `hf2;    12'd679: toneR = `hf2;
                12'd680: toneR = `hf2;    12'd681: toneR = `hf2;
                12'd682: toneR = `hf2;    12'd683: toneR = `hf2;
                12'd684: toneR = `hf2;    12'd685: toneR = `hf2;
                12'd686: toneR = `hf2;    12'd687: toneR = `hf2;
                12'd688: toneR = `hf2;    12'd689: toneR = `hf2;
                12'd690: toneR = `hf2;    12'd691: toneR = `hf2;
                12'd692: toneR = `hf2;    12'd693: toneR = `hf2;
                12'd694: toneR = `hf2;    12'd695: toneR = `hf2;
                12'd696: toneR = `hf2;    12'd697: toneR = `hf2;
                12'd698: toneR = `hf2;    12'd699: toneR = `hf2;
                12'd700: toneR = `hf2;    12'd701: toneR = `hf2;
                12'd702: toneR = `hf2;    12'd703: toneR = `hf2;
                12'd704: toneR = `hf2;    12'd705: toneR = `hf2;
                12'd706: toneR = `hf2;    12'd707: toneR = `hf2;
                12'd708: toneR = `hf2;    12'd709: toneR = `hf2;
                12'd710: toneR = `hf2;    12'd711: toneR = `hf2;
                12'd712: toneR = `hf2;    12'd713: toneR = `hf2;
                12'd714: toneR = `hf2;    12'd715: toneR = `hf2;
                12'd716: toneR = `hf2;    12'd717: toneR = `hf2;
                12'd718: toneR = `hf2;    12'd719: toneR = `hf2;
                12'd720: toneR = `hf2;    12'd721: toneR = `hf2;
                12'd722: toneR = `hf2;    12'd723: toneR = `hf2;
                12'd724: toneR = `hf2;    12'd725: toneR = `hf2;
                12'd726: toneR = `hf2;    12'd727: toneR = `hf2;
                12'd728: toneR = `hf2;    12'd729: toneR = `hf2;
                12'd730: toneR = `hf2;    12'd731: toneR = `hf2;
                12'd732: toneR = `hf2;    12'd733: toneR = `hf2;
                12'd734: toneR = `hf2;    12'd735: toneR = `sil;

                12'd736: toneR = `hf2;    12'd737: toneR = `hf2;
                12'd738: toneR = `hf2;    12'd739: toneR = `hf2;
                12'd740: toneR = `hf2;    12'd741: toneR = `hf2;
                12'd742: toneR = `hf2;    12'd743: toneR = `hf2;
                12'd744: toneR = `hf2;    12'd745: toneR = `hf2;
                12'd746: toneR = `hf2;    12'd747: toneR = `hf2;
                12'd748: toneR = `hf2;    12'd749: toneR = `hf2;
                12'd750: toneR = `hf2;    12'd751: toneR = `hf2;
                12'd752: toneR = `hf2;    12'd753: toneR = `hf2;
                12'd754: toneR = `hf2;    12'd755: toneR = `hf2;
                12'd756: toneR = `hf2;    12'd757: toneR = `hf2;
                12'd758: toneR = `hf2;    12'd759: toneR = `hf2;
                12'd760: toneR = `hf2;    12'd761: toneR = `hf2;
                12'd762: toneR = `hf2;    12'd763: toneR = `hf2;
                12'd764: toneR = `hf2;    12'd765: toneR = `hf2;
                12'd766: toneR = `hf2;    12'd767: toneR = `hf2;
                12'd768: toneR = `hf2;    12'd769: toneR = `hf2;
                12'd770: toneR = `hf2;    12'd771: toneR = `hf2;
                12'd772: toneR = `hf2;    12'd773: toneR = `hf2;
                12'd774: toneR = `hf2;    12'd775: toneR = `hf2;
                12'd776: toneR = `hf2;    12'd777: toneR = `hf2;
                12'd778: toneR = `hf2;    12'd779: toneR = `hf2;
                12'd780: toneR = `hf2;    12'd781: toneR = `hf2;
                12'd782: toneR = `hf2;    12'd783: toneR = `hf2;
                12'd784: toneR = `hf2;    12'd785: toneR = `hf2;
                12'd786: toneR = `hf2;    12'd787: toneR = `hf2;
                12'd788: toneR = `hf2;    12'd789: toneR = `hf2;
                12'd790: toneR = `hf2;    12'd791: toneR = `hf2;
                12'd792: toneR = `hf2;    12'd793: toneR = `hf2;
                12'd794: toneR = `hf2;    12'd795: toneR = `hf2;
                12'd796: toneR = `hf2;    12'd797: toneR = `hf2;
                12'd798: toneR = `hf2;    12'd799: toneR = `hf2;

                12'd800: toneR = `d2;    12'd801: toneR = `d2;
                12'd802: toneR = `d2;    12'd803: toneR = `d2;
                12'd804: toneR = `d2;    12'd805: toneR = `d2;
                12'd806: toneR = `d2;    12'd807: toneR = `d2;
                12'd808: toneR = `d2;    12'd809: toneR = `d2;
                12'd810: toneR = `d2;    12'd811: toneR = `d2;
                12'd812: toneR = `d2;    12'd813: toneR = `d2;
                12'd814: toneR = `d2;    12'd815: toneR = `d2;
                12'd816: toneR = `d2;    12'd817: toneR = `d2;
                12'd818: toneR = `d2;    12'd819: toneR = `d2;
                12'd820: toneR = `d2;    12'd821: toneR = `d2;
                12'd822: toneR = `d2;    12'd823: toneR = `d2;
                12'd824: toneR = `d2;    12'd825: toneR = `d2;
                12'd826: toneR = `d2;    12'd827: toneR = `d2;
                12'd828: toneR = `d2;    12'd829: toneR = `d2;
                12'd830: toneR = `d2;    12'd831: toneR = `d2;
                12'd832: toneR = `d2;    12'd833: toneR = `d2;
                12'd834: toneR = `d2;    12'd835: toneR = `d2;
                12'd836: toneR = `d2;    12'd837: toneR = `d2;
                12'd838: toneR = `d2;    12'd839: toneR = `d2;
                12'd840: toneR = `d2;    12'd841: toneR = `d2;
                12'd842: toneR = `d2;    12'd843: toneR = `d2;
                12'd844: toneR = `d2;    12'd845: toneR = `d2;
                12'd846: toneR = `d2;    12'd847: toneR = `d2;
                12'd848: toneR = `d2;    12'd849: toneR = `d2;
                12'd850: toneR = `d2;    12'd851: toneR = `d2;
                12'd852: toneR = `d2;    12'd853: toneR = `d2;
                12'd854: toneR = `d2;    12'd855: toneR = `d2;
                12'd856: toneR = `d2;    12'd857: toneR = `d2;
                12'd858: toneR = `d2;    12'd859: toneR = `d2;
                12'd860: toneR = `d2;    12'd861: toneR = `d2;
                12'd862: toneR = `d2;    12'd863: toneR = `d2;

                12'd864: toneR = `e2;    12'd865: toneR = `e2;
                12'd866: toneR = `e2;    12'd867: toneR = `e2;
                12'd868: toneR = `e2;    12'd869: toneR = `e2;
                12'd870: toneR = `e2;    12'd871: toneR = `e2;
                12'd872: toneR = `e2;    12'd873: toneR = `e2;
                12'd874: toneR = `e2;    12'd875: toneR = `e2;
                12'd876: toneR = `e2;    12'd877: toneR = `e2;
                12'd878: toneR = `e2;    12'd879: toneR = `e2;
                12'd880: toneR = `e2;    12'd881: toneR = `e2;
                12'd882: toneR = `e2;    12'd883: toneR = `e2;
                12'd884: toneR = `e2;    12'd885: toneR = `e2;
                12'd886: toneR = `e2;    12'd887: toneR = `e2;
                12'd888: toneR = `e2;    12'd889: toneR = `e2;
                12'd890: toneR = `e2;    12'd891: toneR = `e2;
                12'd892: toneR = `e2;    12'd893: toneR = `e2;
                12'd894: toneR = `e2;    12'd895: toneR = `e2;
                12'd896: toneR = `e2;    12'd897: toneR = `e2;
                12'd898: toneR = `e2;    12'd899: toneR = `e2;
                12'd900: toneR = `e2;    12'd901: toneR = `e2;
                12'd902: toneR = `e2;    12'd903: toneR = `e2;
                12'd904: toneR = `e2;    12'd905: toneR = `e2;
                12'd906: toneR = `e2;    12'd907: toneR = `e2;
                12'd908: toneR = `e2;    12'd909: toneR = `e2;
                12'd910: toneR = `e2;    12'd911: toneR = `e2;
                12'd912: toneR = `e2;    12'd913: toneR = `e2;
                12'd914: toneR = `e2;    12'd915: toneR = `e2;
                12'd916: toneR = `e2;    12'd917: toneR = `e2;
                12'd918: toneR = `e2;    12'd919: toneR = `e2;
                12'd920: toneR = `e2;    12'd921: toneR = `e2;
                12'd922: toneR = `e2;    12'd923: toneR = `e2;
                12'd924: toneR = `e2;    12'd925: toneR = `e2;
                12'd926: toneR = `e2;    12'd927: toneR = `e2;

                12'd928: toneR = `hf2;    12'd929: toneR = `hf2;
                12'd930: toneR = `hf2;    12'd931: toneR = `hf2;
                12'd932: toneR = `hf2;    12'd933: toneR = `hf2;
                12'd934: toneR = `hf2;    12'd935: toneR = `hf2;
                12'd936: toneR = `hf2;    12'd937: toneR = `hf2;
                12'd938: toneR = `hf2;    12'd939: toneR = `hf2;
                12'd940: toneR = `hf2;    12'd941: toneR = `hf2;
                12'd942: toneR = `hf2;    12'd943: toneR = `hf2;
                12'd944: toneR = `hf2;    12'd945: toneR = `hf2;
                12'd946: toneR = `hf2;    12'd947: toneR = `hf2;
                12'd948: toneR = `hf2;    12'd949: toneR = `hf2;
                12'd950: toneR = `hf2;    12'd951: toneR = `hf2;
                12'd952: toneR = `hf2;    12'd953: toneR = `hf2;
                12'd954: toneR = `hf2;    12'd955: toneR = `hf2;
                12'd956: toneR = `hf2;    12'd957: toneR = `hf2;
                12'd958: toneR = `hf2;    12'd959: toneR = `hf2;
                12'd960: toneR = `hf2;    12'd961: toneR = `hf2;
                12'd962: toneR = `hf2;    12'd963: toneR = `hf2;
                12'd964: toneR = `hf2;    12'd965: toneR = `hf2;
                12'd966: toneR = `hf2;    12'd967: toneR = `hf2;
                12'd968: toneR = `hf2;    12'd969: toneR = `hf2;
                12'd970: toneR = `hf2;    12'd971: toneR = `hf2;
                12'd972: toneR = `hf2;    12'd973: toneR = `hf2;
                12'd974: toneR = `hf2;    12'd975: toneR = `hf2;
                12'd976: toneR = `hf2;    12'd977: toneR = `hf2;
                12'd978: toneR = `hf2;    12'd979: toneR = `hf2;
                12'd980: toneR = `hf2;    12'd981: toneR = `hf2;
                12'd982: toneR = `hf2;    12'd983: toneR = `hf2;
                12'd984: toneR = `hf2;    12'd985: toneR = `hf2;
                12'd986: toneR = `hf2;    12'd987: toneR = `hf2;
                12'd988: toneR = `hf2;    12'd989: toneR = `hf2;
                12'd990: toneR = `hf2;    12'd991: toneR = `hf2;
                12'd992: toneR = `hf2;    12'd993: toneR = `hf2;
                12'd994: toneR = `hf2;    12'd995: toneR = `hf2;
                12'd996: toneR = `hf2;    12'd997: toneR = `hf2;
                12'd998: toneR = `hf2;    12'd999: toneR = `hf2;
                12'd1000: toneR = `hf2;    12'd1001: toneR = `hf2;
                12'd1002: toneR = `hf2;    12'd1003: toneR = `hf2;
                12'd1004: toneR = `hf2;    12'd1005: toneR = `hf2;
                12'd1006: toneR = `hf2;    12'd1007: toneR = `hf2;
                12'd1008: toneR = `hf2;    12'd1009: toneR = `hf2;
                12'd1010: toneR = `hf2;    12'd1011: toneR = `hf2;
                12'd1012: toneR = `hf2;    12'd1013: toneR = `hf2;
                12'd1014: toneR = `hf2;    12'd1015: toneR = `hf2;
                12'd1016: toneR = `hf2;    12'd1017: toneR = `hf2;
                12'd1018: toneR = `hf2;    12'd1019: toneR = `hf2;
                12'd1020: toneR = `hf2;    12'd1021: toneR = `hf2;
                12'd1022: toneR = `hf2;    12'd1023: toneR = `hf2;
                default: toneR = `sil;
            endcase
        end
        else begin
            toneR = `sil;
        end
    end
endmodule