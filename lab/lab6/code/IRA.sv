module IR (
    input logic Clk, Reset_ah, LD_IR,
    input logic[15:0] dataBus_output,
    output logic[15:0] IR
);
    always_ff @( posedge Clk ) begin
        if(Reset_ah)
            IR <= 16'b0000;
        if(LD_IR)
            IR <= dataBus_output;
    end
endmodule