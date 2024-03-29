module lab5_toplevel
(
    input logic [7:0] S,
    input logic Clk, Reset, Run, ClearA_LoadB,
    output logic [6:0]AhexU, AhexL, BhexU, BhexL,
    output logic [7:0]Aval, Bval,
    output logic X,
    output logic [8:0] adder_re
);
    logic Reset_SH, Run_SH, ClearA_LoadB_SH, Clear_XA;
    logic Clr_ld, shift_reg, Add_op, Sub_op,M_signal, shift_IN;
    logic compute;
    logic [8:0] adder_result;
    logic [7:0] SR_A,SR_B;
    assign compute = Add_op|Sub_op;
    assign Aval = SR_A;
    assign Bval = SR_B;
    assign adder_re = adder_result;
    assign X = shift_IN;
    flip_reg X_reg(.Clk(Clk),.Load(compute),.Reset(Clear_XA),.D(adder_result[8]),
                    .Q(shift_IN));
						  
						  
    controller CONTROL(.Clk(Clk),.Reset(Reset_SH),.ClearA_LoadB(ClearA_LoadB_SH),.Run(Run_SH),.M(M_signal),
                        .Clr_Ld(Clr_ld),.Shift(shift_reg),.Add(Add_op),.Sub(Sub_op),.Clear_XA(Clear_XA));


    sixteen_RS sixteen_bit_SR(.Clk(Clk),.Reset(Reset_SH),.Shift_En(shift_reg),.Load_B(Clr_ld),.Compute(compute),
									 .Clear_XA(Clear_XA),.Shift_IN(shift_IN),
                            .S(S),
                            .CA_result(adder_result[7:0]),
                            .M(M_signal),
									 .A(SR_A),
                            .B(SR_B));
    
    CLA_S nine_bit_Adder(.A(SR_A),.B(S),
                    .fn(Sub_op),
                    .S(adder_result));

    HexDriver        HexAL (
                    .In0(SR_A[3:0]),
                    .Out0(AhexL) );
    HexDriver        HexBL (
                    .In0(SR_B[3:0]),
                    .Out0(BhexL) );
                            
    //When you extend to 8-bits, you will need more HEX drivers to view upper nibble of registers, for now set to 0
    HexDriver        HexAU (
                    .In0(SR_A[7:4]),
                    .Out0(AhexU) );	
    HexDriver        HexBU (
                    .In0(SR_B[7:4]),
                    .Out0(BhexU) );
    //Input synchronizers required for asynchronous inputs (in this case, from the switches)
    //These are array module instantiations
    //Note: S stands for SYNCHRONIZED, H stands for active HIGH
    //Note: We can invert the levels inside the port assignments
    sync button_sync[2:0] (Clk, {~Reset, ~Run, ~ClearA_LoadB}, {Reset_SH, Run_SH, ClearA_LoadB_SH});
                            
endmodule
