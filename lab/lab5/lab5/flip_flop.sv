// Design
// D flip-flop
//however, regx should be control by clrA
//copyright : https://www.edaplayground.com/s/example/8
module D_filp_flop(Clk, Reset,load,
  in, out);
  input logic Clk;
  input logic Reset;
  input logic load;
  input logic in;
  output logic out;

  always @(posedge Clk or posedge Reset)
  begin
    if (Reset) begin
      // Asynchronous reset when reset goes high
      out <= 1'b0;
    end 
	 else if(load)
	 begin
      // Assign D to Q on positive clock edge
      out <= in;
    end
	 else
	 begin
      // Assign D to Q on positive clock edge
      out <= out;
    end
  end

endmodule 