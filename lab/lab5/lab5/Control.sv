module control(
		input logic run,
		input logic clearA_loadB,
		input logic clk,
		input logic reset,
		input M,			
		output logic clr_ld,
		output logic shift,
		output logic add,
		output logic sub);
		
		
		//base on what we learn in lab4 there we choose moore mechine
		enum logic [4:1'b0] {Reset,halt,excute,
						Add1,Shift1,
						Add2,Shift2,
						Add3,Shift3,
						Add4,Shift4,
						Add5,Shift5,
						Add6,Shift6,
						Add7,Shift7,
						Add8,Shift8} curr,next;
						
		always_ff @ (posedge clk or posedge reset)
		begin
				if(reset)
						curr <= Reset;
				else
						curr <= next;
		end
		
		always_comb
		begin
			next = curr;
			unique case (curr)
				Reset:		if(run)
								next = excute;
				excute:		next = Add1;
				Add1: 	    next = Shift1;
				Shift1: 	next = Add2;
				Add2:	    next = Shift2;
				Shift2:		next = Add3;
				Add3: 	    next = Shift3;
				Shift3:		next = Add4;
				Add4: 	    next = Shift4;
				Shift4:		next = Add5;
				Add5: 	    next = Shift5;
				Shift5: 	next = Add6;
				Add6: 	    next = Shift6;
				Shift6:		next = Add7;
				Add7:	    next = Shift7;
				Shift7:	    next = Add8;
				Add8:	    next = Shift8;
				Shift8:		next = halt;
				halt:		if(~run)
								next = Reset;
			endcase
		end
		
		always_comb
		begin
			case(curr)
				excute:
					begin
						clr_ld = 1'b1;
						shift = 1'b0;
						add = 1'b0;
						sub = 1'b0;
					end
				
				Reset:
					begin
						clr_ld=clearA_loadB;
						shift = 1'b0;
						add = 1'b0;
						sub = 1'b0;
					end
            halt:
					begin
						clr_ld=1'b0;
						shift =1'b0;
						add = 1'b0;
						sub = 1'b0;
					end


				Add1, Add2, Add3, Add4, Add5,
				Add6, Add7:
					begin
						clr_ld = 1'b0;
						shift = 1'b0;
						if(M)
							begin
								add = 1'b1;
								sub = 1'b0;
							end
						else
							begin
								add = 1'b0;
								sub = 1'b0;
							end
					end
				Add8:
					begin
						clr_ld = 1'b0;
						shift = 1'b0;
						if(M)
							begin
								add = 1'b0;
								sub = 1'b1;
							end
						else
							begin
								add = 1'b0;
								sub = 1'b0;
							end
					end
				Shift1, Shift2, Shift3, Shift4, Shift5,
				Shift6, Shift7, Shift8:
					begin
						clr_ld = 1'b0;
						shift = 1'b1;
						add = 1'b0;
						sub = 1'b0;
					end
			endcase
		end

endmodule 		