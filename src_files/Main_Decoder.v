// basically a control path.
module main_decoder(opcode, RegWrite, MemWrite, Branch, ALUSrc, ResultSrc, ALUOp, ImmSrc);
    input [6:0] opcode;
    output reg RegWrite, MemWrite, Branch, ALUSrc, ResultSrc;
    output reg [1:0] ALUOp, ImmSrc;

    always @(*) begin
        //default values
        RegWrite = 0;
        MemWrite = 0;
        Branch = 0;
        ALUSrc = 0;
        ResultSrc = 0;
        ALUOp = 2'b0;
        ImmSrc = 2'b0;

        case(opcode)
            7'b0110011: begin // R-type (add, sub, and, or)
                RegWrite = 1;
                ALUSrc = 0;
                ResultSrc = 0; // alu-result
                ALUOp = 2'b10;
                ImmSrc = 2'b00;
            end

            7'b0010011: begin // I-type (addi)
                RegWrite = 1;
                ALUSrc = 1;
                ResultSrc = 0;
                ALUOp = 2'b10;
                ImmSrc = 2'b00; // I-type
            end

            7'b0000011: begin // load (lw)
                RegWrite = 1;
                ALUSrc = 1;
                ResultSrc = 1;
                ALUOp = 2'b00;
                ImmSrc = 2'b00;
            end

            7'b0100011: begin // store (sw)
                RegWrite = 0;
                MemWrite = 1;
                ALUSrc = 1;
                ALUOp = 2'b00;
                ImmSrc = 2'b01; // s-type
            end

            7'b1100011: begin // branch (beq)
                RegWrite = 0;
                Branch = 1;
                ALUSrc = 0;
                ALUOp = 2'b01;
                ImmSrc = 2'b10; // b-type
            end

            default: begin
                // we can add more instructions here later.
            end
        endcase
    end
endmodule