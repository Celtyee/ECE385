module carry_lookahead_adder
(
	 input logic cin,
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Sum,
    output  logic           CO
);

    /* TODO
     *
     * Insert code here to implement a CLA adder.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */
	  logic [3:0] PG;
	  logic [3:0] GG;
	  logic [3:0] C;
	  four_bit_CLA CLA4_0(.A(A[3:0]),.B(B[3:0]),.cin(cin),.PG(PG[0]),.GG(GG[0]),.sum(Sum[3:0]));
	  four_bit_CLA CLA4_1(.A(A[7:4]),.B(B[7:4]),.cin(C[1]),.PG(PG[1]),.GG(GG[1]),.sum(Sum[7:4]));
	  four_bit_CLA CLA4_2(.A(A[11:8]),.B(B[11:8]),.cin(C[2]),.PG(PG[2]),.GG(GG[2]),.sum(Sum[11:8]));
	  four_bit_CLA CLA4_3(.A(A[15:12]),.B(B[15:12]),.cin(C[3]),.PG(PG[3]),.GG(GG[3]),.sum(Sum[15:12]));
	  
	  sixteen_bit_CLA_CLU CLU16(.PG(PG),.cin(0),.GG(GG),.C(C),.cout(CO));

	  
endmodule


module sixteen_bit_CLA_CLU(
	input [3:0] PG,
	input [3:0] GG,
	input cin,
	output logic [3:0] C,
	output logic PG_f,
	output logic GG_f,
	output logic cout
	);
	
	assign C[0] = cin;
	assign C[1] = (C[0]&PG[0]) | GG[0];
	assign C[2] = (C[0]&PG[0]&PG[1]) | (GG[0]&PG[1]) | GG[1];
	assign C[3] = (C[0]&PG[0]&PG[1]&PG[2]) | (GG[0]&PG[1]&PG[2]) | (GG[1]&PG[2]) | GG[2];
	
	
	assign cout = GG[3] | (GG[2] & PG[3]) | GG[1]&PG[2]&PG[3] | GG[0]&PG[1]&PG[2]&PG[3] | (C[0]&PG[0]&PG[1]&PG[2]&PG[3]);
	assign PG_f = PG[0]&PG[1]&PG[2]&PG[3];
	assign GG_f = GG[3] | GG[2]&PG[3] | GG[1]&PG[3]&PG[2] | GG[0]&PG[3]&PG[2]&PG[1];
	
	
endmodule



module four_bit_CLA(
	input [3:0] A,
	input [3:0] B,
	input cin,
	output logic [3:0] sum,
	output logic PG,
	output logic GG,
	output logic cout
	);
	
	logic [3:0] P;
	logic [3:0] G;
	logic [3:0] C;
	
	
	full_adder_for_CLA fa0(.x(A[0]),.y(B[0]),.cin(cin),.p(P[0]),.g(G[0]),.s(sum[0]));
	full_adder_for_CLA fa1(.x(A[1]),.y(B[1]),.cin(C[1]),.p(P[1]),.g(G[1]),.s(sum[1]));
	full_adder_for_CLA fa2(.x(A[2]),.y(B[2]),.cin(C[2]),.p(P[2]),.g(G[2]),.s(sum[2]));
	full_adder_for_CLA fa3(.x(A[3]),.y(B[3]),.cin(C[3]),.p(P[3]),.g(G[3]),.s(sum[3]));
	
	full_bit_CLA_CLU clu(.P(P),.G(G),.cin(cin),.C(C),.PG(PG),.GG(GG),.cout(cout));

	
	
endmodule

module full_bit_CLA_CLU(
	input [3:0] P,
	input [3:0] G,
	input cin,
	output logic [3:0] C,
	output logic PG,
	output logic GG,
	output logic cout
	);
	
	assign C[0] = cin;
	assign C[1] = (C[0]&P[0]) | G[0];
	assign C[2] = (C[0]&P[0]&P[1]) | (G[0]&P[1]) | G[1];
	assign C[3] = (C[0]&P[0]&P[1]&P[2]) | (G[0]&P[1]&P[2]) | (G[1]&P[2] | G[2]);
	
	assign cout = G[3] | (G[2]&P[3]) | (G[1]&P[2]&P[3]) | (G[0]&P[1]&P[2]&P[3]) | (C[0]&P[0]&P[1]&P[2]&P[3]);
	assign PG = P[0]&P[1]&P[2]&P[3];
	assign GG = G[3] | (G[2]&P[3]) | (G[1]&P[3]&P[2]) | (G[0]&P[3]&P[2]&P[1]);
	
endmodule

module full_adder_for_CLA(
	input x,
	input y,
	input cin,
	output logic p,
	output logic g,
	output logic s
	);
	
	assign s = x^y^cin;
	assign g = x&y;
	assign p = x^y;

endmodule