// instr_mem.v
module instr_mem (
    input  wire [7:0] addr,
    output reg  [7:0] data
);
    always @(*) begin
        case (addr)
	        // init data
            8'd0: data = 8'hD4; // load first element to ACC 
            8'd1: data = 8'h50; // r0 stores max first element to start
            8'd2: data = 8'h51; // r1 stores min first element to start

	        // instruction addresses for branching
	        8'd3: data = 8'hD5;		// 5
	        8'd4: data = 8'h59; 	// r9 = 5
	        8'd5: data = 8'hD7;		// 7
	        8'd6: data = 8'h5A;		// r10 = 7
	        8'd7: data = 8'hDE;		// 14
	        8'd8: data = 8'h5B;		// r11 = 14
	
	        8'd9: data = 8'hDF;		// 15
	        8'd10: data = 8'h1B; 	// 15 + 14 <= 29
	        8'd11: data = 8'h53; 	// r3 <= 29 

	        8'd12: data = 8'h19;  	// 29 + 5 <= 34  
	        8'd13: data = 8'h54; 	// r4 <= 34

	        8'd14: data = 8'h1A; 	// 34 + 7 <= 41
	        8'd15: data = 8'h55;	// r5 <= 41

	        8'd16: data = 8'h19; 	// 41 + 5 <= 46
	        8'd17: data = 8'h56; 	// r6 <= 46

	        8'd18: data = 8'h1A; 	// 46 + 7 <= 53
	        8'd19: data = 8'h57; 	// r7 <= 53

	        8'd20: data = 8'h19; 	// 53 + 5 <= 58
	        8'd21: data = 8'h58; 	// r8 <= 58

	        // second element
            8'd22: data = 8'hD3; // load element into ACC
            8'd23: data = 8'h52; // load element into r2

            8'd24: data = 8'h41; // load min in ACC
            8'd25: data = 8'h22; // sub current element
            8'd26: data = 8'h83; // if min - r2 < 0 => min < r2 skip min update
            8'd27: data = 8'h42; // load the new min into ACC
            8'd28: data = 8'h51; // update min

            8'd29: data = 8'h42; // load current element in ACC may already be done
            8'd30: data = 8'h20; // sub max
            8'd31: data = 8'h84; // if r2 - max < 0 => r2 < max skip max update
            8'd32: data = 8'h42; // load the new max into ACC
            8'd33: data = 8'h50; // update max

	        // third element
            8'd34: data = 8'hDF; // load element into ACC
            8'd35: data = 8'h52; // load element into r2

            8'd36: data = 8'h41; // load min in ACC
            8'd37: data = 8'h22; // sub current element
            8'd38: data = 8'h85; // if min - r2 < 0 => min < r2 skip min update
            8'd39: data = 8'h42; // load the new min into ACC
            8'd40: data = 8'h51; // update min

            8'd41: data = 8'h42; // load current element in ACC may already be done
            8'd42: data = 8'h20; // sub max
            8'd43: data = 8'h86; // if r2 - max < 0 => r2 < max skip max update
            8'd44: data = 8'h42; // load the new max into ACC
            8'd45: data = 8'h50; // update max

	        // fourth element
            8'd46: data = 8'hDC; // load element into ACC
            8'd47: data = 8'h52; // load element into r2

            8'd48: data = 8'h41; // load min in ACC
            8'd49: data = 8'h22; // sub current element
            8'd50: data = 8'h87; // if min - r2 < 0 => min < r2 skip min update
            8'd51: data = 8'h42; // load the new min into ACC
            8'd52: data = 8'h51; // update min

            8'd53: data = 8'h42; // load current element in ACC may already be done
            8'd54: data = 8'h20; // sub max
            8'd55: data = 8'h88; // if r2 - max < 0 => r2 < max skip max update
            8'd56: data = 8'h42; // load the new max into ACC
            8'd57: data = 8'h50; // update max

            8'd58: data = 8'h40; // See max
	        8'd59: data = 8'h41; // See min
	        8'd60: data = 8'hFF; // HALT
            default: data = 8'h00; // NOP
        endcase
    end
endmodule
