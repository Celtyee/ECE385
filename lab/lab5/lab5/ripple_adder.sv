module ripple_adder
(
    input   logic[7:0]     A,
    input   logic[7:0]     B,
	 input	logic		 		sub,
    output  logic[8:0]     Sum
    //output  logic           CO
);

    /* TODO
     *
     * Insert code here to implement a ripple adder.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */
	logic C0, C1, C2, C3, C4;
	logic[8:0] B1;
	logic[8:0] A1;
	assign B1 = B^{8{sub}};
	assign A1 = {A[7],A};
	//assign B1[8] = ;
	
	three_bit_ra FRA0(.x(A1[2:0]),   .y(B1[2:0]),   .cin(sub),  .s(Sum[2:0]),   .cout(C0));
	three_bit_ra FRA1(.x(A1[5:3]),   .y(B1[5:3]),   .cin(C0), .s(Sum[5:3]),   .cout(C1));
	three_bit_ra FRA2(.x(A1[8:6]),   .y({B1[7],B1[7:6]}),   .cin(C1), .s(Sum[8:6]),   .cout(C2));
	//four_bit_ra FRA3(.x(A[15:12]), .y(B[15:12]), .cin(C2), .s(Sum[15:12]), .cout(CO));
   //full_adder fa0(.x(A[6]), .y(B1[6]), .cin(C1), .s(Sum[6]), .cout(C2));
	//full_adder fa1(.x(A[7]), .y(B1[7]), .cin(C2),  .s(Sum[7]), .cout(C3));
	//full_adder fa2(.x(A[7]), .y(B1[7]), .cin(C3),  .s(Sum[8]), .cout(C4));  
endmodule


module three_bit_ra
(
	input logic[2:0] x,
	input logic[2:0] y,
	input logic cin,
	output logic [2:0] s,
	output logic cout
);
	logic c0, c1;
	full_adder fa0(.x(x[0]), .y(y[0]), .cin(cin), .s(s[0]), .cout(c0));
	full_adder fa1(.x(x[1]), .y(y[1]), .cin(c0),  .s(s[1]), .cout(c1));
	full_adder fa2(.x(x[2]), .y(y[2]), .cin(c1),  .s(s[2]), .cout(cout));
	//full_adder fa3(.x(x[3]), .y(y[3]), .cin(c2),  .s(s[3]), .cout(cout));
		

endmodule


module full_adder
(
	input x,
	input y,
	input cin,
	output logic s,
	output logic cout
);
	assign s = x^y^cin;
	assign cout = (x&y) | (y&cin) | (cin&x);

endmodule
