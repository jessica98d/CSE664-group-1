// instr_mem.v
module instr_mem (
    input  wire [7:0] addr,
    output reg  [7:0] data
);
    always @(*) begin
        case (addr)
            8'd0: data = 8'hA3; // MOV ACC, #3
            8'd1: data = 8'h91; // MOV R1, ACC
            8'd2: data = 8'hA5; // MOV ACC, #5
            8'd3: data = 8'h11; // ADD ACC, R1 -> ACC = 8
            8'd4: data = 8'h00; // NOP
            8'd5: data = 8'hF0; // HALT
            default: data = 8'h00; // NOP
        endcase
    end
endmodule
