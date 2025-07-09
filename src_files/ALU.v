module ALU(A,B,Result,ALUControl,Overflow,Carry,Zero,Negative); // flags also implemented
    input [31:0] A,B;
    input [2:0] ALUControl;
    output reg [31:0] Result;
    output reg Carry, Overflow, Zero, Negative;

    reg [31:0] Sum;
    reg Cout;

    always @(*) begin
        Carry = 0;
        Cout = 0;
        Overflow = 0;
        Result = 32'b0;

        case(ALUControl)
            3'b000: begin //add
                {Cout, Sum} = A + B;
                Result = Sum;
                Carry = Cout;
                Overflow = (A[31] == B[31]) && (Result[31] != A[31]);
            end

            3'b001: begin //sub
                {Cout, Sum} = A + ((~B)+1);
                Result = Sum;
                Carry = Cout; // for sub: cout indicates no borrow
                Overflow = (A[31] != B[31]) && (Result[31] != A[31]);
            end

            3'b010: Result = A & B; // And
            3'b011: Result = A | B; // or

            3'b101: begin //slt (signed)
                Result = ($signed(A) < $signed(B)) ? 32'b1 : 32'b0;
            end

            default: Result = 32'b0;
        endcase

        Zero = (Result == 32'b0);
        Negative = Result[31];
    end
endmodule