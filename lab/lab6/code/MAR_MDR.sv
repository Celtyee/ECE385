module MAR_Unit(
    input logic Clk,
    input logic Reset, LD_MAR,
    input logic [15:0] ADDR_In,
    output logic [15:0] ADDR_Out
);
    logic [15:0] Val;
    always_ff @( Clk ) begin
        if (Reset) Val <= 16'h0000;
        else if (LD_MAR) Val <= ADDR_In;
        else Val <= Val;
    end

    assign ADDR_Out = Val;
endmodule

module MDR_Unit(
    input logic Clk,
    input logic Reset, LD_MDR, MIO_EN,
    input logic [15:0] Data_to_CPU, Data_from_Bus,
    output logic [15:0] Data_from_CPU
);
    logic [15:0] Val;
    always_ff @( Clk ) begin
        if (Reset) Val <= 16'h0000;
        else if (LD_MDR) 
            case (MIO_EN)
                0: Val <= Data_to_CPU;
                1: Val <= Data_from_Bus;
                default: ;
            endcase
        else Val <= Val;
    end

    assign Data_from_CPU = Val;
endmodule