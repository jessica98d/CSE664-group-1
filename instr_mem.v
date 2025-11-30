// instr_mem.v
module instr_mem (
    input  wire [7:0] addr,
    output reg  [7:0] data
);
    always @(*) begin
        case (addr)
            8'd0: data = 8'hD7; // Load IMM(7)->ACC(0) 
            8'd1: data = 8'h51; // Load ACC(7)->Reg(R1(0)) 
            8'd2: data = 8'hD9; // Load IMM(9)->ACC(7) 
            8'd3: data = 8'h11; // Add ACC(9) + Reg(R1(7)); ACC = 16 at end
            8'd4: data = 8'h00; // NOP
            8'd5: data = 8'hF0; // HALT
            default: data = 8'h00; // NOP
        endcase
    end
endmodule
