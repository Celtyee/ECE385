module lab5_toplevel
(
    input logic [7:0] S,
    input logic Clk, Reset, Run, ClearA_LoadB,
    output logic [6:0]AhexU, AhexL, BhexU, BhexL,
    output logic [7:0]Aval, Bval,
    output logic X
);
    logic Clr_ld, shift_reg, Add_op, Sub_op,M_signal;
    logic compute;
    logic [8:0] adder_result;
    logic [7:0] SR_A;
    assign compute = Add_op|Sub_op;
    assign Aval = SR_A;

    controller CONTROL(.Clk(Clk),.Reset(Reset),.ClearA_LoadB(ClearA_LoadB),.Run(Run),.M(M_signal),
                        .Clr_Ld(Clr_ld),.Shift(shift_reg),.Add(Add_op),.Sub(Sub_op));


    sixteen_RS sixteen_bit_SR(.Clk(Clk),.Reset(Reset),.Shift_En(shift_reg),.Load_B(Clr_ld),.Compute(compute),
                            .S(S),
                            .CA_result(adder_result),
                            .M(M_signal),
                            .X_sig(X),
									 .A(SR_A),
                            .B(Bval));
    
    CLA_S nine_bit_Adder(.A(SR_A),.B(S),
                        .fn(Sub_op),
                        .S(adder_result));

    HexDriver HexAL
    (
        .In0(Aval[3:0]),   // This connects the 4 least significant bits of 
                        // register A to the input of a hex driver named Ahex0_inst
        .Out0(AhexL)
    );
    HexDriver HexBL
    (
        .In0(Bval[3:0]),   // This connects the 4 least significant bits of 
                        // register A to the input of a hex driver named Ahex0_inst
        .Out0(BhexL)
    );

    HexDriver HexAU
    (
        .In0(Aval[7:4]),   // This connects the 4 least significant bits of 
                        // register A to the input of a hex driver named Ahex0_inst
        .Out0(AhexU)
    );

    HexDriver HexBU
    (
        .In0(Bval[7:4]),   // This connects the 4 least significant bits of 
                        // register A to the input of a hex driver named Ahex0_inst
        .Out0(BhexU)
    );
    
    
endmodule