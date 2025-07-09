`include "Fetch_Cycle.v"
`timescale 1ns/1ns

module tb();

    //declaring the I/Os
    reg clk = 0, rst, PCSrcE;
    reg [31:0] PCTargetE;
    wire [31:0] InstrD, PCD, PCPlus4D;
    
    //declaring the design under test
    fetch_cycle dut (.clk(clk), 
                    .rst(rst), 
                    .PCSrcE(PCSrcE), 
                    .PCTargetE(PCTargetE), 
                    .InstrD(InstrD), 
                    .PCD(PCD), 
                    .PCPlus4D(PCPlus4D));
    
    //generation of clock
    always begin
        clk = ~clk;
        #50;
    end

    //providing the stimulus
    initial begin
        rst <= 1'b0;
        #200;
        rst <= 1'b1;
        PCSrcE <= 1'b0;
        PCTargetE <= 32'h00000000;
        #500;
        $finish;
    end

    //generation of vcd file
    initial begin
        $dumpfile("dumpf.vcd");
        $dumpvars(0, tb);
    end
endmodule