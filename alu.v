// alu.v
module alu (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire [2:0] alu_ctrl,   // 000:add, 001:sub, 010:nor, 011:shl, 100:shr
    output reg  [7:0] y
);
    always @(*) begin
        case (alu_ctrl)
            3'b000: y = a + b;          // ADD
            3'b001: y = a - b;          // SUB
            3'b010: y = ~(a | b);       // NOR
            3'b011: y = a << 1;         // SHL (use A only)
            3'b100: y = a >> 1;         // SHR (use A only)
            default: y = a;             // Default: pass through A
        endcase
    end
endmodule
