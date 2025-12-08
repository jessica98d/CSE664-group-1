`timescale 1ns/1ps

// ---------------------------
// Instruction Memory (ROM)
// ---------------------------
module instr_mem (
    input  wire [7:0] addr,   // PC from CPU
    output reg  [7:0] data    // instruction to CPU
);
    reg [7:0] rom [0:255];
    integer i;

    initial begin
        // Default all instructions to NOP (0000_0000)
        for (i = 0; i < 256; i = i + 1) begin
            rom[i] = 8'h00;   // NOP
        end

        // ----------
        // Program: Sum of 4 "array" elements in R1–R4
        //
        // ISA recap:
        //  opcode (upper 4 bits):
        //    0000 : NOP
        //    0001 : ADD  ACC + Reg[operand]
        //    0010 : SUB  ACC - Reg[operand]
        //    0011 : NOR  ACC, Reg[operand]
        //    0100 : LOAD Reg[operand] -> ACC
        //    0101 : STORE ACC -> Reg[operand]
        //    0110 : JZ  Reg->PC if ACC == 0
        //    0111 : JZ  IMM->PC if ACC == 0
        //    1000 : JC  Reg->PC if ACC[7] == 1
        //    1010 : JC  IMM->PC if ACC[7] == 1
        //    1011 : SHL ACC
        //    1100 : SHR ACC
        //    1101 : LOAD IMM (low nibble) -> ACC
        //    1111 : HALT
        //
        // Program layout:
        //  Addr  Instr   Meaning
        //  ----  -----   -----------------------------------------
        //   0    D5      LOAD IMM 5  -> ACC = 5
        //   1    51      STORE ACC -> R1     (R1 = 5)
        //   2    D9      LOAD IMM 9  -> ACC = 9
        //   3    52      STORE ACC -> R2     (R2 = 9)
        //   4    D4      LOAD IMM 4  -> ACC = 4
        //   5    53      STORE ACC -> R3     (R3 = 4)
        //   6    D7      LOAD IMM 7  -> ACC = 7
        //   7    54      STORE ACC -> R4     (R4 = 7)
        //
        //   8    41      LOAD R1 -> ACC      (ACC = R1 = 5)
        //   9    12      ADD  R2             (ACC = 5 + 9  = 14)
        //  10    13      ADD  R3             (ACC = 14 + 4 = 18)
        //  11    14      ADD  R4             (ACC = 18 + 7 = 25 = 0x19)
        //
        //  12    50      STORE ACC -> R0     (R0 = 25)
        //  13    F0      HALT
        // ----------

        rom[8'd0]  = 8'hD5;   // LOAD IMM 5  -> ACC = 5
        rom[8'd1]  = 8'h51;   // STORE ACC -> R1
        rom[8'd2]  = 8'hD9;   // LOAD IMM 9  -> ACC = 9
        rom[8'd3]  = 8'h52;   // STORE ACC -> R2
        rom[8'd4]  = 8'hD4;   // LOAD IMM 4  -> ACC = 4
        rom[8'd5]  = 8'h53;   // STORE ACC -> R3
        rom[8'd6]  = 8'hD7;   // LOAD IMM 7  -> ACC = 7
        rom[8'd7]  = 8'h54;   // STORE ACC -> R4

        rom[8'd8]  = 8'h41;   // LOAD R1 -> ACC
        rom[8'd9]  = 8'h12;   // ADD R2
        rom[8'd10] = 8'h13;   // ADD R3
        rom[8'd11] = 8'h14;   // ADD R4

        rom[8'd12] = 8'h50;   // STORE ACC -> R0 (result)
        rom[8'd13] = 8'hF0;   // HALT
    end

    always @(*) begin
        data = rom[addr];
    end
endmodule

// ---------------------------
// CPU Testbench
// ---------------------------
module tb_cpu;
    reg         clk;
    reg         reset;
    wire [7:0]  pc;
    wire [7:0]  acc;
    wire        halted;
    wire [7:0]  instr;

    // Clock: 10 ns period
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;  // toggle every 5 ns
    end

    // Reset pulse
    initial begin
        reset = 1'b1;
        #20;
        reset = 1'b0;
    end

    // Instantiate instruction memory and CPU
    instr_mem imem (
        .addr (pc),
        .data (instr)
    );

    cpu uut (
        .clk    (clk),
        .reset  (reset),
        .instr  (instr),
        .pc     (pc),
        .acc    (acc),
        .halted (halted)
    );

    // Monitor for console output
    initial begin
        $display("time   ns | PC  instr  ACC  halted");
        $display("----------------------------------");
        $monitor("%8t | %02h   %02h    %02h    %b",
                 $time, pc, instr, acc, halted);
    end

    // Stop simulation on HALT or timeout
    initial begin
        @(negedge reset);  // wait until reset deasserted

        fork
            begin : wait_for_halt
                @(posedge halted);
                #20;  // small delay so state settles
                $display("HALT at time %t, PC=%0h, ACC=%0h (should be 0x19 = 25)",
                         $time, pc, acc);
                $stop;
            end

            begin : timeout
                #1000;
                $display("Timeout reached, stopping simulation.");
                $stop;
            end
        join_any

        disable wait_for_halt;
        disable timeout;
    end

endmodule
