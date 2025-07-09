module register_file(clk, rst, WE3, WD3, A1, A2, A3, RD1, RD2);
    input clk, rst, WE3;
    input [4:0] A1, A2, A3;
    input [31:0] WD3;
    output [31:0] RD1, RD2;

    reg [31:0] register [31:0];

    always @(posedge clk) begin
        if(WE3 & (A3 != 5'h00))
            register[A3] <= WD3;

        register[0] <= 32'b0; 
    end

    assign RD1 = (rst == 1'b0) ? 32'd0: register[A1];
    assign RD2 = (rst == 1'b0) ? 32'd0: register[A2];
    
endmodule