//copy from lab4 the top entr for muiltiplier


//Always use input/output logic types when possible, prevents issues with tools that have strict type enforcement

module lab5_toplevel (input logic   Clk,     // Internal
                                Reset,   // Push button 0
                                //LoadA,   // Push button 1
                                ClearA_LoadB,   // clear
                                Run, // Push button 3
                  input  logic [7:0]  S,     // input data
                  //input  logic [2:0]  F,       // Function select
                  //input  logic [1:0]  R,       // Routing select
                  //output logic [3:0]  LED,     // DEBUG
                  output logic [7:0]  Aval,    // DEBUG
                                Bval,    // DEBUG
                  output logic [6:0]  AhexL,
                                AhexU,
                                BhexL,
                                BhexU,
						output logic  X);				// x is thr

	 //local logic variables go here
	 logic Reset_SH, RUN_SH, ClearA_loadB_SH;
	 
	 logic [7:0] A,B;
	 logic [8:0] sum;
	 logic sub,bIN,shift,clear_load,add;
	 //We can use the "assign" statement to do simple combinational logic
	 assign Aval = A;
	 assign Bval = B;
	 
	 
	 
	 //Instantiation of modules here
	 reg_8    registerA (
                        .Clk(Clk),
                        .Reset(clear_load | Reset_SH),// clear and load here
                        .Shift_In(X),
								.Load(add | sub),
								.Shift_En(shift),
								.D(sum[7:0]),
								.Shift_Out(bIN),
								.Data_Out(A));
	 
     reg_8    registerB (
                        .Clk(Clk),
                        .Reset(Reset_SH),
                        .Shift_In(bIN),
								.Load(ClearA_loadB_SH),
								.Shift_En(shift),
								.D(S),
								.Shift_Out(),
								.Data_Out(B));
								
    ripple_adder 	nine_bits_adder (
								//.F(F_S),
                        .A(A),
                        .B(S),
                        .sub(sub),
                        .Sum(sum));
															
	//flip-flop to store x

	 D_filp_flop	registerX(
								.Clk(Clk),
                        .Reset(clear_load | Reset_SH),// clear and load here
								.load(add | sub),
								.in(sum[8]),
								.out(X));
	//the most important part is the state mechine
	
	 control          control_unit (
                        .clk(Clk),
                        .reset(Reset_SH),
                        .clearA_loadB(ClearA_loadB_SH),
								.run(RUN_SH),
                        .shift(shift),
                        .add(add),
                        .sub(sub),
								.clr_ld(clear_load),
                        .M(B[0]) );
	 
	 
	 
	 HexDriver        HexAL (
                        .In0(A[3:0]),
                        .Out0(AhexL) );
	 HexDriver        HexBL (
                        .In0(B[3:0]),
                        .Out0(BhexL) );
								
	 //When you extend to 8-bits, you will need more HEX drivers to view upper nibble of registers, for now set to 0
	 HexDriver        HexAU (
                        .In0(A[7:4]),
                        .Out0(AhexU) );	
	 HexDriver        HexBU (
                       .In0(B[7:4]),
                        .Out0(BhexU) );
								
	  //Input synchronizers required for asynchronous inputs (in this case, from the switches)
	  //These are array module instantiations
	  //Note: S stands for SYNCHRONIZED, H stands for active HIGH
	  //Note: We can invert the levels inside the port assignments
	  sync button_sync[2:0] (Clk, {~Reset,~ClearA_LoadB,~Run}, {Reset_SH, ClearA_loadB_SH , RUN_SH});
	  //sync Din_sync[7:0] (Clk, Din, Din_S);
	  //sync F_sync[2:0] (Clk, F, F_S);
	  //sync R_sync[1:0] (Clk, R, R_S);
	  
endmodule
