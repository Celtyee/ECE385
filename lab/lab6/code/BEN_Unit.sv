module BEN_Unit (
    input logic Clk, Reset,
    input logic LD_BEN, LD_CC,
    input logic [2:0] IR_11_9,
    input logic [15:0] Data_from_Bus,
    output logic BEN_Out
);
    logic BEN_Val, BEN_Logic_Out;
    logic [2:0] NZP_Val, NZP_Logic_Out;

    always_ff @(posedge Clk ) begin
        // NZP_Reg
        if (Reset) 
            NZP_Val <= 3'b000;
        else if (LD_CC)
            NZP_Val <= NZP_Logic_Out;
        // BEN_Reg
        if (Reset) 
            BEN_Val <= 1'b0;
        else if (LD_BEN)
            BEN_Val <= BEN_Logic_Out;
    end

    always_comb begin
        // NZP_Logic
        if (Data_from_Bus[15] == 1'b1)
            NZP_Logic_Out = 3'b100; // N
        else if (Data_from_Bus == 16'h0000)
            NZP_Logic_Out = 3'b010; // Z
        else 
            NZP_Logic_Out = 3'b001; // P
        // BEN_Logic
        BEN_Logic_Out = IR_11_9[2]&NZP_Val[2] | IR_11_9[1]&NZP_Val[1] | IR_11_9[0]&NZP_Val[0];
        // Output
        BEN_Out = BEN_Val;
    end
endmodule