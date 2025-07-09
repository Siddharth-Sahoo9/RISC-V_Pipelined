module memory_cycle(clk, rst, RegWriteM, MemWriteM, ResultSrcM, PCPlus4M, WriteDataM, ALUResultM, RD_M, RegWriteW, ResultSrcW, RD_W, PCPlus4W, ReadDataW, ALUResultW);

    //declaration of I/Os
    input clk, rst, RegWriteM, MemWriteM, ResultSrcM; 
    input [31:0] PCPlus4M, WriteDataM, ALUResultM;
    input [4:0] RD_M;

    output RegWriteW, ResultSrcW; 
    output [4:0] RD_W; 
    output [31:0] PCPlus4W, ReadDataW, ALUResultW;

    //declaration of interim wires
    wire [31:0] ReadDataM;

    //declaration of interim registers
    reg RegWriteM_r, ResultSrcM_r;
    reg [4:0] RD_M_r;
    reg [31:0] PCPlus4M_r, ReadDataM_r, ALUResultM_r;

    //instantiation of modules
    data_memory dmem (
                    .clk(clk),
                    .rst(rst),
                    .WE(MemWriteM),
                    .WD(WriteDataM), 
                    .A(ALUResultM), 
                    .RD(ReadDataM)
                    );

    //memory stage register logic
    always @(posedge clk or negedge rst) begin
        if(rst == 1'b0) begin
            RegWriteM_r <= 1'b0; 
            ResultSrcM_r <= 1'b0;
            RD_M_r <= 5'h00;
            PCPlus4M_r <= 32'b0;
            ReadDataM_r <= 32'b0; 
            ALUResultM_r <= 32'b0;
        end
        else begin
            RegWriteM_r <= RegWriteM; 
            ResultSrcM_r <= ResultSrcM;
            RD_M_r <= RD_M;
            PCPlus4M_r <= PCPlus4M;
            ReadDataM_r <= ReadDataM; 
            ALUResultM_r <= ALUResultM;
        end
    end

    //assigning the outputs we get
    assign RegWriteW = RegWriteM_r; 
    assign ResultSrcW = ResultSrcM_r;
    assign RD_W = RD_M_r;
    assign PCPlus4W = PCPlus4M_r;
    assign ReadDataW = ReadDataM_r; 
    assign ALUResultW = ALUResultM_r;

endmodule