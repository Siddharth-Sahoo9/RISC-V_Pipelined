module hazard_unit(rst, RegWriteM, RegWriteW, RD_M, RD_W, RS1_E, RS2_E, ForwardAE, ForwardBE);
    
    //declaration of I/Os
    input rst;
    input RegWriteM, RegWriteW;
    input [4:0] RD_M, RD_W, RS1_E, RS2_E;
    output reg [1:0] ForwardAE, ForwardBE;

    //the following thing can also be implemented using simple assign statements, it will be much shorter in that case (using ternary operators).
    always @(*) begin
        if(~rst) begin
            ForwardAE = 2'b00;
            ForwardBE = 2'b00;
        end
        else begin
            //default
            ForwardAE = 2'b00;
            ForwardBE = 2'b00;

            //EX Hazard
            if((RegWriteM == 1'b1) & (RD_M != 5'h00)) begin
                if(RD_M == RS1_E)
                    ForwardAE = 2'b10;
                if(RD_M == RS2_E)
                    ForwardBE = 2'b10;
            end

            //MEM Hazard
            if((RegWriteW == 1'b1) & (RD_W != 5'h00)) begin
                if((RD_W == RS1_E) & (ForwardAE == 2'b00)) //ensures that latest data is being used. EX > MEM
                    ForwardAE = 2'b01;
                if((RD_W == RS2_E) & (ForwardBE == 2'b00)) //ensures that latest data is being used. EX > MEM
                    ForwardBE = 2'b01;
            end
        end
    end

endmodule