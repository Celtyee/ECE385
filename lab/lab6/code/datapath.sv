module datapath (
    input logic         Clk,
                        Reset_ah,

    input logic         LD_MAR,
                        LD_MDR,
                        LD_IR,
                        LD_BEN,
                        LD_CC,
                        LD_REG,
                        LD_PC,
                        LD_LED, // for PAUSE instruction
                        
    input logic         GatePC,
                        GateMDR,
                        GateALU,
                        GateMARMUX,
                        
    input logic [1:0]   PCMUX,

    input logic         DRMUX,
                        SR1MUX,
                        SR2MUX,
                        ADDR1MUX,

    input logic         MIO_EN,

    input logic [1:0]   ADDR2MUX,
                        ALUK,

    input logic [2:0]   IR_11_9_in,

    input logic [15:0]  Data_to_CPU,
    output logic [15:0] Data_from_CPU,
    output logic [15:0] MAR,
    output logic [15:0] IR
    
);    

    logic [15:0] GatePC_result, GateMARMUX_result, GateALU_result, GateMDR_result,pc_add_1_result;
    logic [15:0] datapath_output;

    MAR_Unit MAR0(.Clk, .Reset(Reset_ah), .LD_MAR, .ADDR_In(), .ADDR_Out(MAR));
    MDR_Unit MDR0(.Clk, .Reset(Reset_ah), .LD_MDR, .MIO_EN, .Data_to_CPU, .Data_from_Bus(), .Data_from_CPU);
    PCU PCU0(.Clk, .Reset_ah, .PC(GatePC_result),.pc_add_1_result(pc_add_1_result),.pc_add_1(pc_add_1_result),.PCMUX,.LD_PC);
    
    IRA IRA0(.Clk, .Reset_ah, .LD_IR, .ADDR1MUX,
            .ADDR2MUX,.PC(GatePC_result),.datapath_input(datapath_output),
            .IR);

    Data_BUS DB0(.GatePC_sig(GatePC),.GateMDR_sig(GateMDR),.GateALU_sig(GateALU),.GateMARMUX_sig(GateMARMUX),.Clk,
                .GatePC(GatePC_result),
                .dataBus_output(datapath_output));
    
endmodule


module Data_BUS (
    input logic GatePC_sig,
                GateMDR_sig,
                GateALU_sig,
                GateMARMUX_sig,
                Clk,
    input logic[15:0] GateMARMUX, GatePC, GateMDR, GateALU,
    
    output logic[15:0] dataBus_output
);
    logic selector_sig  = {GatePC_sig, GateMDR_sig, GateALU_sig,GateMARMUX_sig};
    
    always_comb begin : dataBus_out
        unique case(selector_sig)
            4'b0001: dataBus_output = GateMARMUX;
            4'b0010: dataBus_output = GateALU;
            4'b0100: dataBus_output = GateMDR;
            4'b1000: dataBus_output = GatePC;
            default: dataBus_output = 16'b0000000000000000;
        endcase
    end

endmodule