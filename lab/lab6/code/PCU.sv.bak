module PCU #(w = 16) (
    input logic Clk, Reset_ah,
    input logic [w-1:0] adder_output,
                        pc_add_1,
                        dataBus_output,
    input logic [1:0] PCMUX,
    input logic LD_PC,

    output logic [w-1:0] PC,
    output logic [w-1:0] pc_add_1_result
);
    logic [15:0]PC_REG;  

    assign pc_add_1_result = PC + 1;
    always_ff @( posedge Clk ) begin : PC_register
        if(Reset_ah)
            PC <= 16'b 0000000000000000;
        if(LD_PC)
            PC <= PC_REG;
    end

    always_comb begin : PC_MUX
        unique case (PCMUX)
            2'b00: PC_REG = pc_add_1;
            2'b01: PC_REG = adder_output;
            2'b10: PC_REG = dataBus_output;
        endcase
    end
    
endmodule

