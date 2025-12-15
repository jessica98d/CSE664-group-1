// instr_mem.v
module instr_mem (
    input  wire [7:0] addr,
    output reg  [7:0] data
);
    always @(*) begin
        case (addr)
	    // Program 1
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

	    // Delay between programs
	    8'd60: data = 8'h00; // NOP
	    8'd61: data = 8'h00; // NOP
	    8'd62: data = 8'h00; // NOP
	    8'd63: data = 8'h00; // NOP
	    8'd64: data = 8'h00; // NOP
	    8'd65: data = 8'h00; // NOP

	    // Program 2
 	    // =====================================================
            // Standalone GCD Program
            // Computes GCD(48, 36) = 12 -> stores in r3
            // Uses r4 (swap temp), r0 (loop target)
            // =====================================================

            // Load a = 48 into r1 (48 = 3 << 4)
            8'd66:  data = 8'hD3; // lia 3
            8'd67:  data = 8'hB0; // shl
            8'd68:  data = 8'hB0; // shl
            8'd69:  data = 8'hB0; // shl
            8'd70:  data = 8'hB0; // shl -> acc = 48
            8'd71:  data = 8'h51; // lar r1

            // Load b = 36 into r2 (36 = 9 << 2)
            8'd72:  data = 8'hD9; // lia 9
            8'd73:  data = 8'hB0; // shl
            8'd74:  data = 8'hB0; // shl -> acc = 36
            8'd75:  data = 8'h52; // lar r2

            // Load loop address (addr 96) into r0
            8'd76: data = 8'hDB; // lia 11
	    8'd77: data = 8'hB0; // shl 22
	    8'd78: data = 8'hB0; // shl 44
	    8'd79: data = 8'hB0; // shl 88
            8'd80: data = 8'h50; // lar r0
            8'd81: data = 8'hD8; // lia 8
	    8'd82: data = 8'h10; // add 96
            8'd83: data = 8'h50; // lar r0

            8'd84: data = 8'hDF; // lia 15
	    8'd85: data = 8'h10; // add loop + 15
            8'd86: data = 8'h5F; // lar r15
            8'd87: data = 8'hD2; // lia 2
	    8'd88: data = 8'h1F; // add r15 + 2
            8'd89: data = 8'h5F; // lar r15

	    8'd90: data = 8'hD9; // lia 9
	    8'd91: data = 8'h10; // add loop + 9
            8'd92: data = 8'h5E; // lar r14

            8'd93: data = 8'hD2; // lia 2
	    8'd94: data = 8'h10; // add loop + 2
            8'd95: data = 8'h5D; // lar r13

            // Loop start (addr 96)
            8'd96: data = 8'h42; // lra r2 -> acc = b
            8'd97: data = 8'h6F; // jzrp 15 to done (in r15)

            // Repeated subtraction: a -= b while a >= b
            8'd98: data = 8'h41; // lra r1 -> acc = a
            8'd99: data = 8'h22; // sub r2
            8'd100: data = 8'h8E; // jnrp 14 -> if borrow (a < b), skip store and go to swap
	    8'd101: data = 8'h00; // NOP bubble
            8'd102: data = 8'h51; // lar r1 -> a = a - b
	    8'd103: data = 8'hD0; // lia 0
            8'd104: data = 8'h6D; // jzrp 13; jump back to addr 98 (continue subtraction)

            // Swap a and b (now a is remainder, b is previous a)
            8'd105: data = 8'h41; // lra r1
            8'd106: data = 8'h54; // lar r4 -> temp = a
            8'd107: data = 8'h42; // lra r2
            8'd108: data = 8'h51; // lar r1 -> a = b
            8'd109: data = 8'h44; // lra r4
            8'd110: data = 8'h52; // lar r2 -> b = temp

            // Unconditional jump back to loop
            8'd111: data = 8'hD0; // lia 0
            8'd112: data = 8'h60; // jzrp r0; jump to addr in r0

            // Done – GCD is now in r1
            8'd113: data = 8'h41; // lra r1
            8'd114: data = 8'h53; // lar r3 -> store result in r3

	    // Delay between programs
	    8'd115: data = 8'h00; // NOP
	    8'd116: data = 8'h00; // NOP
	    8'd117: data = 8'h00; // NOP
	    8'd118: data = 8'h00; // NOP
	    8'd119: data = 8'h00; // NOP
	    8'd120: data = 8'h00; // NOP

	    // Program 3
	    8'd121: data = 8'b01000001;  // lra r1  -> ACC = R1
	    8'd122: data = 8'b00010010;  // add r2  -> ACC = ACC + R2
	    8'd123: data = 8'b01010011;  // lar r3  -> R3 = ACC

	    // Delay between programs
	    8'd124: data = 8'h00; // NOP
	    8'd125: data = 8'h00; // NOP
	    8'd126: data = 8'h00; // NOP
	    8'd127: data = 8'h00; // NOP
	    8'd128: data = 8'h00; // NOP
	    8'd129: data = 8'h00; // NOP

	    // Program 4
      	    8'd130: data  = 8'hD5;   // LOAD IMM 5  -> ACC = 5
            8'd131: data  = 8'h51;   // STORE ACC -> R1
            8'd132: data  = 8'hD9;   // LOAD IMM 9  -> ACC = 9
            8'd133: data  = 8'h52;   // STORE ACC -> R2
            8'd134: data  = 8'hD4;   // LOAD IMM 4  -> ACC = 4
            8'd135: data  = 8'h53;   // STORE ACC -> R3
            8'd136: data  = 8'hD7;   // LOAD IMM 7  -> ACC = 7
            8'd137: data  = 8'h54;   // STORE ACC -> R4

            8'd138: data  = 8'h41;   // LOAD R1 -> ACC
            8'd139: data  = 8'h12;   // ADD R2
            8'd140: data = 8'h13;   // ADD R3
            8'd141: data = 8'h14;   // ADD R4

            8'd142: data = 8'h50;   // STORE ACC -> R0 (result)

	    8'd143: data = 8'hFF; // HALT
            default: data = 8'h00; // NOP
        endcase
    end
endmodule
