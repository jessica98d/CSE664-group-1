// tb_cpu.v
`timescale 1ns/1ps

module tb_cpu;
    reg         clk;
    reg         reset;
    wire [7:0]  pc;
    wire [7:0]  acc;
    wire        halted;
    wire [7:0]  instr;

    // Clock: 10 ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // toggle every 5 ns
    end

    // Reset pulse
    initial begin
        reset = 1;
        #20;
        reset = 0;
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
        $monitor("time=%0t ns  PC=%0d  instr=%02h  ACC=%02h  halted=%b",
                  $time,       pc,      instr,      acc,      halted);
    end

    // Stop simulation when HALT or timeout
    initial begin
        // safety timeout
        #5000;
        $display("Timeout reached, stopping simulation.");
        $stop;
    end

endmodule
