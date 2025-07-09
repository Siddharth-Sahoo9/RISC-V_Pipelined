//all the modular units included here in the top file instead of individual inclusion.
`include "Fetch_Cycle.v"
`include "Decode_Cycle.v"
`include "Execute_Cycle.v"
`include "Memory_Cycle.v"
`include "Writeback_Cycle.v"
`include "Hazard_Unit.v"

`include "PC.v"
`include "PC_Adder.v"
`include "mux.v"
`include "Instruction_Memory.v"
`include "Control_Unit_Top.v"
`include "Register_File.v"
`include "Sign_Extend.v"
`include "ALU.v"
`include "Data_Memory.v"

module pipeline_top(clk, rst);
    
    //declaration of I/Os
    input clk, rst;

    //declaration of interim wires
    wire PCSrcE, RegWriteW, RegWriteE, ALUSrcE, MemWriteE, ResultSrcE, BranchE, RegWriteM, MemWriteM, ResultSrcM, ResultSrcW;
    wire [2:0] ALUControlE;
    wire [4:0] RD_E, RD_M, RDW;
    wire [31:0] PCTargetE, InstrD, PCD, PCPlus4D, ResultW, RD1_E, RD2_E, Imm_Ext_E, PCE, PCPlus4E, PCPlus4M, WriteDataM, ALUResultM;
    wire [31:0] PCPlus4W, ALUResultW, ReadDataW;
    wire [4:0] RS1_E, RS2_E;
    wire [1:0] ForwardAE, ForwardBE;

    //instantiation of modules.
    //fetch stage
    fetch_cycle Fetch (
                        .clk(clk), 
                        .rst(rst), 
                        .PCSrcE(PCSrcE), 
                        .PCTargetE(PCTargetE), 
                        .InstrD(InstrD), 
                        .PCD(PCD), 
                        .PCPlus4D(PCPlus4D)
                        );

    //decode stage
    decode_cycle Decode (
                        .clk(clk), 
                        .rst(rst), 
                        .InstrD(InstrD), 
                        .PCD(PCD), 
                        .PCPlus4D(PCPlus4D), 
                        .RegWriteW(RegWriteW), 
                        .RDW(RDW), 
                        .ResultW(ResultW), 
                        .RegWriteE(RegWriteE), 
                        .ALUSrcE(ALUSrcE), 
                        .MemWriteE(MemWriteE), 
                        .ResultSrcE(ResultSrcE), 
                        .BranchE(BranchE), 
                        .ALUControlE(ALUControlE), 
                        .RD1_E(RD1_E), 
                        .RD2_E(RD2_E), 
                        .Imm_Ext_E(Imm_Ext_E), 
                        .RD_E(RD_E), 
                        .PCE(PCE), 
                        .PCPlus4E(PCPlus4E), 
                        .RS1_E(RS1_E), 
                        .RS2_E(RS2_E)
                        );

    //execute stage
    execute_cycle Execute (
                            .clk(clk), 
                            .rst(rst), 
                            .RegWriteE(RegWriteE), 
                            .ALUSrcE(ALUSrcE), 
                            .MemWriteE(MemWriteE), 
                            .ResultSrcE(ResultSrcE), 
                            .BranchE(BranchE), 
                            .ALUControlE(ALUControlE), 
                            .RD1_E(RD1_E), 
                            .RD2_E(RD2_E), 
                            .Imm_Ext_E(Imm_Ext_E), 
                            .RD_E(RD_E), 
                            .PCE(PCE), 
                            .PCPlus4E(PCPlus4E), 
                            .PCSrcE(PCSrcE), 
                            .PCTargetE(PCTargetE), 
                            .RegWriteM(RegWriteM), 
                            .MemWriteM(MemWriteM), 
                            .ResultSrcM(ResultSrcM), 
                            .RD_M(RD_M), 
                            .PCPlus4M(PCPlus4M), 
                            .WriteDataM(WriteDataM), 
                            .ALUResultM(ALUResultM),
                            .ResultW(ResultW),
                            .ForwardA_E(ForwardAE),
                            .ForwardB_E(ForwardBE)
                            );

    //memory stage
    memory_cycle Memory (
                        .clk(clk), 
                        .rst(rst), 
                        .RegWriteM(RegWriteM), 
                        .MemWriteM(MemWriteM), 
                        .ResultSrcM(ResultSrcM), 
                        .PCPlus4M(PCPlus4M), 
                        .WriteDataM(WriteDataM), 
                        .ALUResultM(ALUResultM), 
                        .RD_M(RD_M), 
                        .RegWriteW(RegWriteW), 
                        .ResultSrcW(ResultSrcW), 
                        .RD_W(RDW), 
                        .PCPlus4W(PCPlus4W), 
                        .ReadDataW(ReadDataW), 
                        .ALUResultW(ALUResultW)
                        );

    //writeback stage
    writeback_cycle WriteBack (
                                .clk(clk), 
                                .rst(rst), 
                                .ResultSrcW(ResultSrcW), 
                                .ReadDataW(ReadDataW), 
                                .ALUResultW(ALUResultW), 
                                .PCPlus4W(PCPlus4W), 
                                .ResultW(ResultW)
                            );

    //hazard unit
    hazard_unit forwarding_block (
                                    .rst(rst), 
                                    .RegWriteM(RegWriteM), 
                                    .RegWriteW(RegWriteW), 
                                    .RD_M(RD_M), 
                                    .RD_W(RDW), 
                                    .RS1_E(RS1_E), 
                                    .RS2_E(RS2_E), 
                                    .ForwardAE(ForwardAE), 
                                    .ForwardBE(ForwardBE)
                                );
endmodule