module sixteen_RS
(
    input logic Clk, Reset, Shift_En,Load_B, Compute,
    input logic [7:0] S,
    input logic [8:0] CA_result,
    output logic M,
    output logic X_sig,
    output logic [7:0] A,
    output logic [7:0] B
);
    logic [16:0] XAB;
    logic X;
    assign A = XAB[15:8];
    assign B = XAB[7:0];
    assign M = XAB[0];
    assign X_sig = X;
    flip_reg X_reg(.Clk(Clk), .Load(Compute),.Q(X),.D(CA_result[8]),.Reset(Reset));
    always_ff @( posedge Clk ) begin : shift_logic
        if(Reset)
            XAB <= 17'b0;
        else if(Load_B)
            XAB[7:0] <= S[7:0];
        else if(Compute)
            XAB[15:8] <= CA_result[7:0];
        else if(Shift_En)
            XAB <= {X, XAB[16:1]};
    end
endmodule

module flip_reg
(
    input Clk, Load, Reset, D,
    output logic Q
);
always_ff @( posedge Clk ) begin : common_reg
    if(Reset)
     Q <= 1'b0;
    else
        if(Load)
            Q <= D;
        else
            Q <= Q;
end
endmodule

module CLA_S
(
    input [7:0] A,B,
    input fn,
    output [8:0] S
);
    logic [8:0] ex_A,ex_B;
    logic [7:0] complement_element;
    logic [7:0] BB;
    logic [15:0] Sum;
    assign BB = (B^{4{fn}});
    assign ex_A = {A[7],A};
    assign ex_B = {BB[7],BB};
    carry_lookahead_adder adder(.A({complement_element,ex_A}),.B({complement_element,ex_B}),.Sum(Sum));
    assign S = Sum[8:0];
    
endmodule
