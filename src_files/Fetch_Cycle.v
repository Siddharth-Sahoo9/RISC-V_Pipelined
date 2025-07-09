module fetch_cycle(clk, rst, PCSrcE, PCTargetE, InstrD, PCD, PCPlus4D);
    
    //input and outputs declaring
    input clk, rst;
    input PCSrcE;
    input [31:0] PCTargetE;
    output [31:0] InstrD;
    output [31:0] PCD, PCPlus4D;

    //declaring the interim wires
    wire [31:0] PC_F, PCF, PCPlus4F;
    wire [31:0] InstrF;

    //declaring the registers
    reg [31:0] InstrF_reg;
    reg [31:0] PCF_reg, PCPlus4F_reg;

    //instantiation of modules
    //PC MUX
    mux PC_MUX (.a(PCPlus4F),
                .b(PCTargetE),
                .s(PCSrcE),
                .c(PC_F));

    //PC Counter
    PC_module Program_Counter (.clk(clk), 
                                .rst(rst), 
                                .PC(PCF), 
                                .PC_Next(PC_F));

    //declare instruction memory
    Instruction_Memory IMEM (.rst(rst), 
                            .A(PCF), 
                            .RD(InstrF));

    //declaring PC Adder
    PC_Adder PC_adder (.a(PCF),
                        .b(32'h00000004),
                        .c(PCPlus4F));

    //fetch cycle register logic
    always @(posedge clk or negedge rst) begin
        if(rst == 1'b0) begin
            InstrF_reg <= 32'h00000000;
            PCF_reg <= 32'h00000000;
            PCPlus4F_reg <= 32'h00000000;
        end
        else begin
            InstrF_reg <= InstrF;
            PCF_reg <= PCF;
            PCPlus4F_reg <= PCPlus4F;
        end
    end

    //assigning register values to the output port
    assign InstrD = InstrF_reg;
    assign PCD = PCF_reg;
    assign PCPlus4D = PCPlus4F_reg;
endmodule