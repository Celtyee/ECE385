module carry_select_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Sum,
    output  logic           CO
);

    /* TODO
     *
     * Insert code here to implement a carry select.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */
	  logic CO0,CO1,CO2,CO3;
	  
	  CSA4 CSA4_0(.A(A[3:0]),.B(B[3:0]),.Sum(Sum[3:0]),.cin(0),.cout(CO0));
	  CSA4 CSA4_1(.A(A[7:4]),.B(B[7:4]),.Sum(Sum[7:4]),.cin(CO0),.cout(CO1));
	  CSA4 CSA4_2(.A(A[11:8]),.B(B[11:8]),.Sum(Sum[11:8]),.cin(CO1),.cout(CO2));
	  CSA4 CSA4_3(.A(A[15:12]),.B(B[15:12]),.Sum(Sum[15:12]),.cin(CO2),.cout(CO3));
	  
	  assign CO = CO3;
     
endmodule

module CSA4(
	input [3:0] A,B,
	input cin,
	output logic [3:0]Sum,
	output logic cout
	);
	
	logic C0,C1;
	logic [3:0] S0,S1;
	logic CO0,CO1;
	assign C0 = 0;
	assign C1 = 1;
	
	ripple_adder4 CRA0(.c_in(C0),.A(A),.B(B),.S(S0),.c_out(CO0));
	ripple_adder4 CRA1(.c_in(C1),.A(A),.B(B),.S(S1),.c_out(CO1));
	
	always_comb
		begin
			unique case(cin)
				0:cout = CO0;
				1:cout = CO1;
			endcase
		end
		
	always_comb
		begin
			unique case(cin)
				0:Sum = S0;
				1:Sum = S1;
			endcase
		end
		

endmodule


module ripple_adder4 (
	input [3:0] A, B, 
	input c_in,
	output [3:0] S,
	output c_out
	);
	logic c1, c2, c3;

	FA FA0(.x(A[0]), .y(B[0]), .z(c_in), .s(S[0]), .c(c1));
	FA FA1(.x(A[1]), .y(B[1]), .z(c1), .s(S[1]), .c(c2));
	FA FA2(.x(A[2]), .y(B[2]), .z(c2), .s(S[2]), .c(c3));
	FA FA3(.x(A[3]), .y(B[3]), .z(c3), .s(S[3]), .c(c_out));

endmodule

module FA (
	input x, y, z,
	output s, c 
	);
	assign s = x^y^z;
	assign c = (x&y)|(y&z)|(x&z);
	
endmodule

