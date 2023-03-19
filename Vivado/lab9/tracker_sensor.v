module tracker_sensor(clk, reset, left_track, right_track, mid_track, state);
    input clk;
    input reset;
    input left_track, right_track, mid_track;
    output reg [1:0] state;
    
    // TODO: Receive three tracks and make your own policy.
    // Hint: You can use output state to change your action.
    parameter stop = 2'b00, go = 2'b01, right = 2'b10, left = 2'b11;
    always @(*) begin
        if(left_track == 1) state = left;
        else if (right_track == 1) state = right;
        else state = go;
    end
endmodule
