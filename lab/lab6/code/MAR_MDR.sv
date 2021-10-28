module MAR_Unit(
    input logic Clk,
    input logic Reset, LD_MAR,
    input logic [15:0] ADDR_In,
    output logic [15:0] ADDR_Out
);
    logic [15:0] MAR_Val;
    always_ff @(posedge Clk ) begin
        if (Reset) MAR_Val <= 16'h0000;
        else if (LD_MAR) MAR_Val <= ADDR_In;
        else MAR_Val <= MAR_Val;
    end

    assign ADDR_Out = MAR_Val;
endmodule

module MDR_Unit(
    input logic Clk,
    input logic Reset, LD_MDR, MIO_EN,
    input logic [15:0] Data_to_CPU, Data_from_Bus,
    output logic [15:0] Data_from_CPU
);
    logic [15:0] MUX_Out, MDR_Val;
    always_ff @(posedge Clk ) begin
        if (Reset) MDR_Val <= 16'h0000;
        else if (LD_MDR) MDR_Val <= MUX_Out;
        else MDR_Val <= MDR_Val;
    end

    always_comb begin
        case (MIO_EN)
            1: MUX_Out = Data_to_CPU;
            0: MUX_Out = Data_from_Bus;
            default: ;
        endcase
    end

    assign Data_from_CPU = MDR_Val;
endmodule