module ALU (
    input logic Clk, Reset_ah,
    input logic [15:0] SR1_out, SR2_out, SEXT_result,
    input logic [1:0] ALUK, 
    input logic SR2MUX,

    output logic [15:0] GateALU
);
    logic [15:0] SR2MUX_result, ALU_result;
    sub_ALU ALU_unit(.Clk(Clk), .Reset_ah(Reset_ah),
                    .ALUK(ALUK),
                    .SR2MUX_result(SR2MUX_result), .SR1_out(SR1_out),
                    .ALU_result(ALU_result));
    
    assign GateALU = ALU_result;
    always_comb begin
        unique case (SR2MUX)
            1'b0 :  SR2MUX_result = SR2_out;
            1'b1 :  SR2MUX_result = SEXT_result; 
        endcase
    end
    always_ff @( posedge Clk ) begin
        if(Reset_ah)
            ALU_result <= 16'b0000;
    end
endmodule

module sub_ALU (
    input logic[1:0] ALUK,
    input logic [15:0] SR2MUX_result, SR1_out,
    output logic [15:0] ALU_result
);
    always_comb begin
        unique case (ALUK)
            2'b 00: ALU_result = SR2MUX_result + SR1_out;
            2'b 01: ALU_result = SR2MUX_result & SR1_out;
            2'b 10: ALU_result = ~SR1_out;
            2'b 11: ALU_result = SR1_out;
        endcase
    end
endmodule
