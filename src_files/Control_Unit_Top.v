`include "ALU_Decoder.v"
`include "Main_Decoder.v"

module control_unit_top(opcode, funct3, funct7, RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, Branch, ALUControl);
    input [6:0] opcode;
    input [2:0] funct3;
    input [6:0] funct7;
    output RegWrite, ALUSrc, MemWrite, ResultSrc, Branch;
    output [1:0] ImmSrc;
    output [2:0] ALUControl;

    wire [1:0] ALUOp;

    //instantiating the modules
    main_decoder Main_Decoder (.opcode(opcode), 
                                .RegWrite(RegWrite), 
                                .MemWrite(MemWrite), 
                                .Branch(Branch), 
                                .ALUSrc(ALUSrc), 
                                .ResultSrc(ResultSrc), 
                                .ALUOp(ALUOp), 
                                .ImmSrc(ImmSrc));

    alu_decoder ALU_Decoder (
        .ALUOp(ALUOp), 
        .funct3(funct3), 
        .funct7(funct7), 
        .ALUControl(ALUControl)
    );

endmodule