module data_memory(clk, rst, WE, WD, A, RD);
    input clk;
    input rst; 
    input WE;
    input [31:0] A; 
    input [31:0] WD;
    output [31:0] RD;

    reg [31:0] mem [1023:0];

    always @(posedge clk) begin
        if(WE)
            mem[A[31:2]] <= WD;
    end

    assign RD = (~rst) ? 32'd0:mem[A[31:2]];

    initial begin
        mem[0] = 32'b0;
        //mem[40] = 32'h00000002;
    end
endmodule