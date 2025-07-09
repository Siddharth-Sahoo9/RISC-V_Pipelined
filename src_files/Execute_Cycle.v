module execute_cycle(clk, rst, RegWriteE, ALUSrcE, MemWriteE, ResultSrcE, BranchE, ALUControlE, RD1_E, RD2_E, Imm_Ext_E, RD_E, PCE, PCPlus4E, PCSrcE, PCTargetE, RegWriteM, MemWriteM, ResultSrcM, RD_M, PCPlus4M, WriteDataM, ALUResultM, ResultW, ForwardA_E, ForwardB_E);
    //declaring I/Os
    input clk, rst, RegWriteE, ALUSrcE, MemWriteE, ResultSrcE, BranchE;
    input [2:0] ALUControlE;
    input [31:0] RD1_E, RD2_E, Imm_Ext_E;
    input [4:0] RD_E;
    input [31:0] PCE, PCPlus4E;
    input [31:0] ResultW;
    input [1:0] ForwardA_E, ForwardB_E;

    output PCSrcE, RegWriteM, MemWriteM, ResultSrcM; 
    output [31:0] PCPlus4M, WriteDataM, ALUResultM;
    output [31:0] PCTargetE;
    output [4:0] RD_M;

    //declaration of interim wires.
    wire [31:0] Src_A, Src_B, Src_B_interim;
    wire [31:0] ResultE;
    wire ZeroE;

    //declaration of registers.
    reg RegWriteE_r, MemWriteE_r, ResultSrcE_r;
    reg [4:0] RD_E_r;
    reg [31:0] PCPlus4E_r, RD2_E_r, ResultE_r;

    //instantiation of the modules.
    //3by1 mux for source A
    mux_3_by_1 srcA_mux (
                        .a(RD1_E),
                        .b(ResultW),
                        .c(ALUResultM),
                        .s(ForwardA_E),
                        .d(Src_A)
                        );

    //3by1 mux for source B
    mux_3_by_1 srcB_mux (
                        .a(RD2_E),
                        .b(ResultW),
                        .c(ALUResultM),
                        .s(ForwardB_E),
                        .d(Src_B_interim)
                        );

    //ALU src mux
    mux alu_src_mux (
                    .a(Src_B_interim),
                    .b(Imm_Ext_E),
                    .s(ALUSrcE),
                    .c(Src_B)
                    );

    //ALU unit
    ALU alu (
            .A(Src_A),
            .B(Src_B),
            .Result(ResultE),
            .ALUControl(ALUControlE),
            .Overflow(),
            .Carry(),
            .Zero(ZeroE),
            .Negative()
            );

    //Adder
    PC_Adder branch_adder (
                        .a(PCE),
                        .b(Imm_Ext_E),
                        .c(PCTargetE)
                        );

    //designing the register logic here we get
    always @(posedge clk or negedge rst) begin
        if(rst == 1'b0) begin
            RegWriteE_r <= 1'b0; 
            MemWriteE_r <= 1'b0;
            ResultSrcE_r <= 1'b0;
            RD_E_r <= 5'h00;
            PCPlus4E_r <= 32'b0;
            RD2_E_r <= 32'b0;
            ResultE_r <= 32'b0;
        end
        else begin
            RegWriteE_r <= RegWriteE; 
            MemWriteE_r <= MemWriteE;
            ResultSrcE_r <= ResultSrcE;
            RD_E_r <= RD_E;
            PCPlus4E_r <= PCPlus4E;
            RD2_E_r <= Src_B_interim;
            ResultE_r <= ResultE;
        end
    end

    //output assignments
    assign PCSrcE = (ZeroE & BranchE);
    assign RegWriteM = RegWriteE_r; 
    assign MemWriteM = MemWriteE_r;
    assign ResultSrcM = ResultSrcE_r;
    assign RD_M = RD_E_r;
    assign PCPlus4M = PCPlus4E_r;
    assign WriteDataM = RD2_E_r;
    assign ALUResultM = ResultE_r;
endmodule