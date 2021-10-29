module Data_BUS (
    input logic Clk,
                GatePC_sig,
                GateMDR_sig,
                GateALU_sig,
                GateMARMUX_sig,
    input logic[15:0] GateMARMUX, GatePC, GateMDR, GateALU,
    
    output logic[15:0] Data_to_dataBus
);
    logic[3:0] selector_sig;
    assign selector_sig = {GatePC_sig, GateMDR_sig, GateALU_sig,GateMARMUX_sig};

    always_comb begin : dataBus_out
        unique case(selector_sig)
            4'b0001: Data_to_dataBus = GateMARMUX;
            4'b0010: Data_to_dataBus = GateALU;
            4'b0100: Data_to_dataBus = GateMDR;
            4'b1000: Data_to_dataBus = GatePC;
            default: Data_to_dataBus = 16'h0000;
        endcase
    end

endmodule