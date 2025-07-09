module writeback_cycle(clk, rst, ResultSrcW, ReadDataW, ALUResultW, PCPlus4W, ResultW);

    //declaration of I/Os
    input clk, rst, ResultSrcW;
    input [31:0] ReadDataW, ALUResultW, PCPlus4W;
    output [31:0] ResultW;

    //instantiation of the module
    mux result_mux (
                    .a(ALUResultW),
                    .b(ReadDataW),
                    .s(ResultSrcW),
                    .c(ResultW)
                    );
endmodule