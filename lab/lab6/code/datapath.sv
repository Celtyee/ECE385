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

    // Outputs to controller
    output logic [15:0] IR,
    output logic BEN,
    // For demonstration
    output logic [15:0] PC
    
);    

    logic [15:0] GatePC_result, GateMARMUX_result, GateALU_result, GateMDR_result, pc_add_1_result;
    logic [15:0] Data_from_IR_reg, SR1_out, SR2_out, Data_to_PC;
    logic [15:0] dataBus_output;
    logic [15:0] SEXT_IR4;

    assign PC = GatePC_result;
    assign IR = Data_from_IR_reg;
    SEXTU #(.INPUT_WIDTH(5)) SEXTU3(.input_IR(Data_from_IR_reg[4:0]),.SEXT_IR(SEXT_IR4));

    // IR adder unit
    IRA IRA0(
        // .Clk,.Reset_ah,
        .ADDR1MUX,
        .IR(Data_from_IR_reg),
        .Data_from_SR1(SR1_out),.Data_from_PC(GatePC_result),
        .ADDR2MUX,
        .Data_to_GateMARMUX(GateMARMUX_result),.Data_to_PC
    );


    // BEN_unit
    BEN_Unit BENU0(
        .Clk, .Reset(Reset_ah),
        .LD_BEN, .LD_CC,
        .IR_11_9(Data_from_IR_reg[11:9]),
        .Data_from_Bus(dataBus_output),
        .BEN_Out(BEN)
    );

    // ALU
    ALU ALU0(
        // .Clk, .Reset_ah,
        .SR1_out,.SR2_out,.SEXT_result(SEXT_IR4),
        .ALUK,
        .SR2MUX,
        .GateALU(GateALU_result)
    );


    REG_FILE RF0(
        .Clk, .Reset(Reset_ah),
        .DRMUX(DRMUX), .SR1MUX(SR1MUX), .LD_REG, .SR2(IR[2:0]),
        .Data_from_Bus(dataBus_output),
        .IR_11_9(IR[11:9]), .IR_8_6(IR[8:6]),
        .SR1_Out(SR1_out), .SR2_Out(SR2_out)
    );


    // ======================================== finish for week 1 ========================================
    MAR_Unit MAR_reg(
        .Clk, .Reset(Reset_ah), 
        .LD_MAR, 
        .ADDR_In(dataBus_output), .ADDR_Out(MAR)
    );

    MDR_Unit MDR_reg(
        .Clk, .Reset(Reset_ah), 
        .LD_MDR, .MIO_EN, 
        .Data_to_CPU, .Data_from_Bus(dataBus_output), .MDR_Out(GateMDR_result)
    );
    
    assign Data_from_CPU = GateMDR_result; // Feed MDR output to MEM2IO
    
    PCU PC_reg(
        .Clk, .Reset_ah, 
        .adder_output(Data_to_PC),
        .pc_add_1(pc_add_1_result),
        .Data_from_dataBus(dataBus_output),
        .PCMUX,
        .LD_PC,
        .Current_PC_value(GatePC_result),
        .pc_add_1_result(pc_add_1_result)
    );
    
    IR  IR_reg(
        .Clk, .Reset_ah, .LD_IR,
        .Data_from_dataBus(dataBus_output),
        .IR(Data_from_IR_reg)
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
        .Data_to_dataBus(dataBus_output)
    );
    
endmodule

