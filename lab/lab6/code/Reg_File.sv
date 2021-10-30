module REG_FILE (
    input logic Clk, Reset, 
    input logic DRMUX, SR1MUX, LD_REG,
    input logic [2:0] SR2,
    input logic [15:0] Data_from_Bus,
    input logic [2:0] IR_11_9, IR_8_6,
    output logic [15:0] SR1_Out, SR2_Out
);
    logic [15:0] R0, R1, R2, R3, R4, R5, R6, R7;
    logic [2:0] DR, SR1;

    always_ff @(posedge Clk ) begin // Load register 
        if (Reset) begin
            R0 <= 16'h0000;
            R1 <= 16'h0000;
            R2 <= 16'h0000;
            R3 <= 16'h0000;
            R4 <= 16'h0000;
            R5 <= 16'h0000;
            R6 <= 16'h0000;
            R7 <= 16'h0000;
        end else if (LD_REG)
            unique case (DR)
                3'b000:    R0 <= Data_from_Bus;
                3'b001:    R1 <= Data_from_Bus;
                3'b010:    R2 <= Data_from_Bus;
                3'b011:    R3 <= Data_from_Bus;
                3'b100:    R4 <= Data_from_Bus;
                3'b101:    R5 <= Data_from_Bus;
                3'b110:    R6 <= Data_from_Bus;
                3'b111:    R7 <= Data_from_Bus;
                default: ;
            endcase
    end

    always_comb begin
        // DRMUX
        unique case (DRMUX)
            0:  DR = IR_11_9;
            1:  DR = 3'b111;
            default: ;
        endcase

        unique case (SR1MUX)
            0: SR1 = IR_8_6;
            1: SR1 = IR_11_9;
            default: ;
        endcase

        // SR_OUT
        unique case (SR1)
            3'b000:    SR1_Out = R0;
            3'b001:    SR1_Out = R1;
            3'b010:    SR1_Out = R2;
            3'b011:    SR1_Out = R3;
            3'b100:    SR1_Out = R4;
            3'b101:    SR1_Out = R5;
            3'b110:    SR1_Out = R6;
            3'b111:    SR1_Out = R7;
            default: ;
        endcase
        unique case (SR2)
            3'b000:    SR2_Out = R0;
            3'b001:    SR2_Out = R1;
            3'b010:    SR2_Out = R2;
            3'b011:    SR2_Out = R3;
            3'b100:    SR2_Out = R4;
            3'b101:    SR2_Out = R5;
            3'b110:    SR2_Out = R6;
            3'b111:    SR2_Out = R7;
            default: ;
        endcase
    end
endmodule
