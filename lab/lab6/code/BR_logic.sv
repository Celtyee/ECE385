module BR_logic (
    input logic Clk, Reset_ah,
    input logic[2:0] IR_11_9, LD_BEN, LD_CC,
    output logic BEN
);
  always_ff @( posedge Clk ) begin
      if (Reset_ah)
        BEN <= 1'b0;
  end  
endmodule