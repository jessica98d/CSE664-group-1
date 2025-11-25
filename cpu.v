// cpu.v
module cpu (
    input  wire       clk,
    input  wire       reset,
    input  wire [7:0] instr,     // instruction from program memory
    output reg  [7:0] pc,        // program counter (address to instruction memory)
    output reg  [7:0] acc,       // accumulator
    output reg        halted     // high when HALT executed
);
    // Instruction register
    reg [7:0] ir;

    // Decode fields
    wire [3:0] opcode  = ir[7:4];
    wire [3:0] operand = ir[3:0];

    // Register file wires
    wire [7:0] reg_data_out;
    reg        reg_we;
    reg  [3:0] reg_addr_w;
    reg  [7:0] reg_data_in;

    // ALU wires
    reg  [2:0] alu_ctrl;
    wire [7:0] alu_out;

    // Next-state signals
    reg [7:0] next_pc;
    reg [7:0] next_acc;
    reg       next_halted;

    // Instantiate register file (16x8)
    regfile rf (
        .clk      (clk),
        .we       (reg_we & ~halted), // no writes when halted
        .addr_r   (operand),
        .addr_w   (reg_addr_w),
        .data_in  (reg_data_in),
        .data_out (reg_data_out)
    );

    // Instantiate ALU
    alu alu0 (
        .a        (acc),
        .b        (reg_data_out),
        .alu_ctrl (alu_ctrl),
        .y        (alu_out)
    );

    // Combinational control / next-state logic
    always @(*) begin
        // Default values
        next_pc      = pc + 8'd1;
        next_acc     = acc;
        next_halted  = halted;

        reg_we       = 1'b0;
        reg_addr_w   = operand;
        reg_data_in  = acc;

        alu_ctrl     = 3'b000;   // default is Add

        case (opcode)
            4'b0000: begin
                // NOP
            end

            4'b0001: begin
                // Add acc and operand
                alu_ctrl = 3'b000;
                next_acc = alu_out;
            end

            4'b0010: begin
                // Sub acc and operand
                alu_ctrl = 3'b001;
                next_acc = alu_out;
            end

            4'b0011: begin
                // NOR acc and operand
                alu_ctrl = 3'b010;
                next_acc = alu_out;
            end

            4'b0100: begin
                // Load Reg->ACC
                next_acc = reg_data_out;
            end

            4'b0101: begin
                // Load ACC->Reg 
                reg_we     = 1'b1;
                reg_data_in = acc;
            end

            4'b0110: begin 
                // Jump if 0 Reg->PC 
                if (acc == 8'b0) begin
                    next_pc = reg_data_out;
                end
            end

            4'b0111: begin
                // Jump if 0 IMM->PC 
                if (acc == 8'b0) begin
                    next_pc = {4'b0000, operand};
                end
            end

            4'b1000: begin
                // Jump if carry Reg->PC
                if (acc[7] == 1'b1) begin
                    next_pc = reg_data_out;
                end
            end

            4'b1010: begin
                // Jump if carry IMM->PC 
                if (acc[7] == 1'b1) begin
                    next_pc = {4'b0000, operand};
                end
            end

            4'b1011: begin
                // Shift left
                alu_ctrl = 3'b011;
                next_acc = alu_out;
            end

            4'b1100: begin
                // Shift right
                alu_ctrl = 3'b100;
                next_acc = alu_out;
            end

            4'b1101: begin
                // Load IMM->ACC
                next_acc = {4'b0000, operand};
            end

            4'b1111: begin
                // HALT
                next_pc     = pc;   // hold PC
                next_halted = 1'b1;
            end

            default: begin
                // Unused opcodes (1110 and 1001) handled with NOP
            end
        endcase
    end

    // Sequential state updates
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc      <= 8'b0;
            acc     <= 8'b0;
            ir      <= 8'b0;
            halted  <= 1'b0;
        end else if (!halted) begin
            // Latch instruction (instruction register)
            ir      <= instr;
            // State updates
            pc      <= next_pc;
            acc     <= next_acc;
            halted  <= next_halted;
        end
    end

endmodule
