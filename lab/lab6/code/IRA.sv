module IRA #(w=16)(
    input logic Clk, Reset_ah, LD_IR,ADDR1MUX,
    input logic [w-1:0] PC, SR1_out, datapath_input,
    input logic [1:0] ADDR2MUX, 
    output logic [w-1:0] GateMARMUX,
    output logic [w-1:0] IR,
    output logic [w-1:0] SEXT_IR
);
    logic [w-1:0] IR_unit, ADDR2_result, ADDR1_result;
    assign IR = IR_unit;
    always_ff @( posedge Clk ) begin
        if(Reset_ah)
            IR_unit <= 16'b0000;
            GateMARMUX <= 16'b0000;
        if(LD_IR)
            IR_unit <= datapath_input;
    end
    


endmodule