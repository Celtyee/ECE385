module IR (
    input logic Clk, Reset_ah, LD_IR,
    input logic[15:0] Data_from_dataBus,
    output logic[15:0] IR
);
    always_ff @( posedge Clk ) begin
        if(Reset_ah)
            IR <= 16'b0000;
        if(LD_IR)
            IR <= Data_from_dataBus;
    end
endmodule


module IRA (
    input logic ADDR1MUX, Clk, Reset_ah,
    input logic [15:0] IR, 
                       Data_from_SR1, Data_from_PC,
    input logic [1:0] ADDR2MUX,

    output logic [15:0] Data_to_GateMARMUX, Data_to_PC 
    
);
    logic [15:0] adder_result, adder_left, adder_right;
    logic [15:0] SEXT_IR10, SEXT_IR8, SEXT_IR5;

    SEXTU#(.INPUT_WIDTH(6)) SEXTU0(.input_IR(IR[5:0]),.SEXT_IR(SEXT_IR5));
    SEXTU#(.INPUT_WIDTH(9)) SEXTU1(.input_IR(IR[8:0]),.SEXT_IR(SEXT_IR8));
    SEXTU#(.INPUT_WIDTH(11)) SEXTU2(.input_IR(IR[11:0]),.SEXT_IR(SEXT_IR10));

    always_ff @( posedge Clk) begin 
        if(Reset_ah)
            Data_to_GateMARMUX <= 16'b0000;
            Data_to_PC <= 16'b0000;
    end

    always_comb begin
        case(ADDR2MUX)
            2'b00: adder_left = 16'b0000;
            2'b01: adder_left = SEXT_IR5;
            2'b10: adder_left = SEXT_IR8;
            2'b11: adder_left = SEXT_IR10;
        endcase
        
        case (ADDR1MUX) 
            1'b0: adder_right = Data_from_PC;
            1'b1: adder_right = Data_from_SR1;
        endcase
    end

endmodule



module SEXTU #(parameter w = 16, parameter INPUT_WIDTH = 16) (
    input logic [INPUT_WIDTH -1:0] input_IR,
    output logic [w-1:0] SEXT_IR
);
    assign SEXT_IR = {{(w-INPUT_WIDTH){input_IR[INPUT_WIDTH -1]}},input_IR};
endmodule