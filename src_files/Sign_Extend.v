module sign_extend(In, ImmSrc, Imm_Ext);
    input [31:0] In;
    input [1:0] ImmSrc;
    output reg [31:0] Imm_Ext;

    always @(*) begin
        case(ImmSrc)
            2'b00: Imm_Ext = {{20{In[31]}}, In[31:20]}; // i-type
            2'b01: Imm_Ext = {{20{In[31]}}, In[31:25], In[11:7]}; // s-type
            2'b10: Imm_Ext = {{20{In[31]}}, In[7], In[30:25], In[11:8], 1'b0}; // b-type

            default: Imm_Ext = 32'h0;
        endcase
    end
endmodule