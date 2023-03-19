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
