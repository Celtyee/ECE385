module lab5_toplevel
(
    input logic [7:0] S,
    input logic Clk, Reset, Run, ClearA_LoadB,
    output logic [6:0] AhexU, AhexL, BhexU, BhexL,
    output logic [7:0] Aval, Bval,
    output logic X
);
    logic Reset_SH, Run_SH, ClearA_LoadB_SH;
    logic Clr_Ld, shift_reg, Add_op, Sub_op,M_signal;
    logic compute;
    logic [8:0] adder_result;
    logic [7:0] SR_A;

    logic[6:0] AhexL_comb, AhexU_comb, BhexL_comb, BhexU_comb;

    assign compute = Add_op|Sub_op;
    assign Aval = SR_A;

    controller CONTROL(
        .Clk(Clk),
        .Reset(Reset_SH),
        .ClearA_LoadB(ClearA_LoadB_SH),
        .Run(Run_SH),
        .M(M_signal),
        .Clr_Ld(Clr_Ld),
        .Shift(shift_reg),
        .Add(Add_op),
        .Sub(Sub_op)
    );

    sixteen_RS sixteen_bit_SR(
        .Clk(Clk),
        .Reset(Reset_SH),
        .Shift_En(shift_reg),
        .Load_B(Clr_Ld),
        .Compute(compute),
        .S(S),
        .CA_result(adder_result),
        .M(M_signal),
        .X_sig(X),
        .A(SR_A),
        .B(Bval)
    );
    
    CLA_S nine_bit_Adder(
        .A(SR_A),
        .B(S),
        .fn(Sub_op),
        .S(adder_result)
    );

    always_ff @(posedge Clk) begin
        AhexL <= AhexL_comb;
        AhexU <= AhexU_comb;
        BhexL <= BhexL_comb;
        BhexU <= BhexU_comb;        
    end

    HexDriver HexAL
    (
        .In0(Aval[3:0]),
        .Out0(AhexL_comb)
    );
    HexDriver HexBL
    (
        .In0(Bval[3:0]),
        .Out0(BhexL_comb)
    );

    HexDriver HexAU
    (
        .In0(Aval[7:4]),
        .Out0(AhexU_comb)
    );

    HexDriver HexBU
    (
        .In0(Bval[7:4]),
        .Out0(BhexU_comb)
    );

    //Input synchronizers required for asynchronous inputs (in this case, from the switches)
    //These are array module instantiations
    //Note: S stands for SYNCHRONIZED, H stands for active HIGH
    //Note: We can invert the levels inside the port assignments
    sync button_sync[2:0] (Clk, {~Reset, ~Run, ~ClearA_LoadB}, {Reset_SH, Run_SH, ClearA_LoadB_SH});
    
endmodule
