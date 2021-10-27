module datapath (
    input logic         Clk,
                        Reset_ah,
    // LD register signals
    input logic         LD_MAR,
                        LD_MDR,
                        LD_IR,
                        LD_BEN,
                        LD_CC,
                        LD_REG,
                        LD_PC,
                        LD_LED, // for PAUSE instruction
    // Tristate gate signals             
    input logic         GatePC,
                        GateMDR,
                        GateALU,
                        GateMARMUX,
    // MUX signals                 
    input logic [1:0]   PCMUX,
    input logic         DRMUX,
                        SR1MUX,
                        SR2MUX,
                        ADDR1MUX,
    input logic [1:0]   ADDR2MUX,
                        ALUK,
    // Memory signals
    input logic         MIO_EN,
    input logic [15:0]  Data_to_CPU,
    output logic [15:0] Data_from_CPU,
    output logic [15:0] MAR,

    // Instruction register
    output logic [15:0] IR
    
);    

    logic [15:0] GatePC_result, GateMARMUX_result, GateALU_result, GateMDR_result, pc_add_1_result;
    logic [15:0] dataBus_output;

    MAR_Unit MAR_reg(
        .Clk, .Reset(Reset_ah), 
        .LD_MAR, 
        .ADDR_In(dataBus_output), .ADDR_Out(MAR)
    );

    MDR_Unit MDR_reg(
        .Clk, .Reset(Reset_ah), 
        .LD_MDR, .MIO_EN, 
        .Data_to_CPU, .Data_from_Bus(dataBus_output), .Data_from_CPU(GateMDR_result)
    );
    
    PCU PC(
        .Clk, .Reset_ah, 
        .adder_output(),
        .pc_add_1(pc_add_1_result),
        .dataBus_input(dataBus_output),
        .PCMUX,
        .LD_PC,
        .PC_result(GatePC_result),
        .pc_add_1_result(pc_add_1_result)
    );
    
    IR  IR_reg(
        .Clk, .Reset_ah, .LD_IR,
        .dataBus_output(dataBus_output),
        .IR
    );

    // dataBus instance
    Data_BUS Data_Bus0(
        .Clk,
        .GatePC_sig(GatePC),
        .GateMDR_sig(GateMDR),
        .GateALU_sig(GateALU),
        .GateMARMUX_sig(GateMARMUX),
        // inputs to gates
        .GatePC(GatePC_result),
        .GateMARMUX(GateMARMUX_result),
        .GateMDR(GateMDR_result),
        .GateALU(GateALU_result),
        .dataBus_output(dataBus_output)
    );
    
endmodule


module Data_BUS (
    input logic Clk,
                GatePC_sig,
                GateMDR_sig,
                GateALU_sig,
                GateMARMUX_sig,
    input logic[15:0] GateMARMUX, GatePC, GateMDR, GateALU,
    
    output logic[15:0] dataBus_output
);
    logic[3:0] selector_sig;
	 assign selector_sig = {GatePC_sig, GateMDR_sig, GateALU_sig,GateMARMUX_sig};

    always_comb begin : dataBus_out
        unique case(selector_sig)
            4'b0001: dataBus_output = GateMARMUX;
            4'b0010: dataBus_output = GateALU;
            4'b0100: dataBus_output = GateMDR;
            4'b1000: dataBus_output = GatePC;
            default: dataBus_output = 16'h0000;
        endcase
    end

endmodule