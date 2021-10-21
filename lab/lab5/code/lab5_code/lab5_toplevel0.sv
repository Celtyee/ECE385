module lab5_toplevel
(
    input logic [7:0] S,
    input logic Clk, Reset, Run, ClearA_LoadB,
    output logic [6:0]AhexU, AhexL, BhexU, BhexL,
    output logic [7:0]Aval, Bval,
    output logic X,M,clr_ld,compute_sig,shift_sig,
    output logic [8:0]adder_re
);
    logic Clr_ld, shift_reg, Add_op, Sub_op,M_signal;
    logic compute;
    logic [8:0] adder_result;
    logic [7:0] SR_A,SR_B;
    assign compute = Add_op|Sub_op;
    assign Aval = SR_A;
    assign Bval = SR_B;
	assign M = M_signal;
    assign adder_re = adder_result;
    assign clr_ld = Clr_ld;
    assign compute_sig = compute;
    assign shift_sig = shift_reg;
    controller CONTROL(.Clk(Clk),.Reset(Reset),.ClearA_LoadB(ClearA_LoadB),.Run(Run),.M(M_signal),
                        .Clr_Ld(Clr_ld),.Shift(shift_reg),.Add(Add_op),.Sub(Sub_op));


    sixteen_RS sixteen_bit_SR(.Clk(Clk),.Reset(Reset),.Shift_En(shift_reg),.Load_B(Clr_ld),.Compute(compute),
                            .S(S),
                            .CA_result(adder_result),
                            .M(M_signal),
                            .X_sig(X),
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
								
endmodule
