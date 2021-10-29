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
    output logic [15:0] MDR_Out
);
    logic [15:0] MUX_Out, MDR_Val;

    always_ff @(posedge Clk ) begin
        if (Reset) MDR_Val <= 16'h0000;
        else if (LD_MDR) 
            case (MIO_EN)
                1: MDR_Val <= Data_to_CPU;
                0: MDR_Val <= Data_from_Bus;
                default: ;
            endcase
    end

    assign MDR_Out = MDR_Val;
endmodule