//------------------------------------------------------------------------------
// Company:          UIUC ECE Dept.
// Engineer:         Stephen Kempf
//
// Create Date:    17:44:03 10/08/06
// Design Name:    ECE 385 Lab 6 Given Code - Incomplete ISDU
// Module Name:    ISDU - Behavioral
//
// Comments:
//    Revised 03-22-2007
//    Spring 2007 Distribution
//    Revised 07-26-2013
//    Spring 2015 Distribution
//    Revised 02-13-2017
//    Spring 2017 Distribution
//------------------------------------------------------------------------------
`include "SLC3_2.sv"
import SLC3_2::*;

module ISDU (   input logic         Clk, 
									Reset,
									Run,
									Continue,
									
				input logic[3:0]    Opcode, 
				input logic         IR_5,
				input logic         IR_11,
				input logic         BEN,
				  
				output logic        LD_MAR,
									LD_MDR,
									LD_IR,
									LD_BEN,
									LD_CC,
									LD_REG,
									LD_PC,
									LD_LED, // for PAUSE instruction
									
				output logic        GatePC,
									GateMDR,
									GateALU,
									GateMARMUX,
									
				output logic [1:0]  PCMUX,
				output logic        DRMUX,
									SR1MUX,
									SR2MUX,
									ADDR1MUX,
				output logic [1:0]  ADDR2MUX,
									ALUK,
				  
				output logic        Mem_CE,
									Mem_UB,
									Mem_LB,
									Mem_OE,
									Mem_WE
				);

	enum logic [4:0] {  Halted, 
						PauseIR1, 
						PauseIR2, 
						S_18, 
						S_33_1, 
						S_33_2, 
						S_35, 
						S_32, 
						// BR
						S_00,
						S_22,
						// ADD
						S_01,
						S_05,
						// NOT
						S_09,
						// LDR
						S_06,
						S_25_1,
						S_25_2,
						S_27,
						// STR
						S_07,
						S_23,
						S_16_1,
						S_16_2,
						// JMP
						S_12,
						// JSR
						S_04,
						S_21
						}   State, Next_state;   // Internal state logic

	always_ff @ (posedge Clk)
	begin
		if (Reset) 
			State <= Halted;
		else 
			State <= Next_state;
	end
   
	always_comb
	begin 
		// Default next state is staying at current state
		Next_state = State;
		
		// Default controls signal values
		LD_MAR = 1'b0;
		LD_MDR = 1'b0;
		LD_IR = 1'b0;
		LD_BEN = 1'b0;
		LD_CC = 1'b0;
		LD_REG = 1'b0;
		LD_PC = 1'b0;
		LD_LED = 1'b0;
		 
		GatePC = 1'b0;
		GateMDR = 1'b0;
		GateALU = 1'b0;
		GateMARMUX = 1'b0;
		 
		ALUK = 2'b00;
		 
		PCMUX = 2'b00;
		DRMUX = 1'b0;
		SR1MUX = 1'b0;
		SR2MUX = 1'b0;
		ADDR1MUX = 1'b0;
		ADDR2MUX = 2'b00;
		 
		Mem_OE = 1'b1;
		Mem_WE = 1'b1;
	
		// Assign next state
		unique case (State)
			Halted : 
				if (Run) 
					Next_state = S_18;                      
			S_18 : 
				Next_state = S_33_1;
			// Any states involving SRAM require more than one clock cycles.
			// The exact number will be discussed in lecture.
			S_33_1 : 
				Next_state = S_33_2;
			S_33_2 : 
				Next_state = S_35;
			S_35 : 
				Next_state = S_32;
			// PauseIR1 and PauseIR2 are only for Week 1 such that TAs can see 
			// the values in IR.
			// PauseIR1 : 
			// 	if (~Continue) 
			// 		Next_state = PauseIR1;
			// 	else 
			// 		Next_state = PauseIR2;
			// PauseIR2 : 
			// 	if (Continue) 
			// 		Next_state = PauseIR2;
			// 	else 
			// 		Next_state = S_18;
			S_32 : 
				unique case (Opcode)
					op_ADD : 
						Next_state = S_01;
					op_AND : 
						Next_state = S_05;
					op_NOT :
						Next_state = S_09;
					op_BR  :
						Next_state = S_00;
					op_JMP :
						Next_state = S_12;
					op_JSR :
						Next_state = S_04;
					op_LDR :
						Next_state = S_06;
					op_STR :
						Next_state = S_07;
					op_PSE :
						Next_state = PauseIR1;
					default :  
						Next_state = S_18;
				endcase
			// ADD
			S_01 : 
				Next_state = S_18;
			// AND
			S_05 :
				Next_state = S_18;
			// NOT
			S_09 :
				Next_state = S_18;

			// LDR
			S_06:
				Next_state = S_25_1;
			S_25_1:
				Next_state = S_25_2;
			S_25_2:
				Next_state = S_27;
			S_27:
				Next_state = S_18;

			// STR
			S_07:
				Next_state = S_23;
			S_23:
				Next_state = S_16_1;
			S_16_1:
				Next_state = S_16_2;
			S_16_2:
				Next_state = S_18;

			// JSR
			S_04:
				Next_state = S_21;
			S_21:
				Next_state = S_18;

			// JMP
			S_12:
				Next_state = S_18;
			
			// BR
			S_00:
				unique case (BEN)
					1'b0: Next_state = S_18;
					1'b1: Next_state = S_22; 
				endcase
			S_22:
				Next_state = S_18;	
			
			// PSE
			PauseIR1 : 
				if (~Continue) 
					Next_state = PauseIR1;
				else 
					Next_state = PauseIR2;
			PauseIR2 : 
				if (Continue) 
					Next_state = PauseIR2;
				else 
					Next_state = S_18;
			default : ;
		endcase
		
		// Assign control signals based on current state
		unique case (State)
			Halted: ;
			S_18 : 
				begin 
					GatePC = 1'b1;
					LD_MAR = 1'b1;
					PCMUX = 2'b00;
					LD_PC = 1'b1;
				end
			S_33_1 : 
				Mem_OE = 1'b0;
			S_33_2 : 
				begin 
					Mem_OE = 1'b0;
					LD_MDR = 1'b1;
				end
			S_35 : 
				begin 
					GateMDR = 1'b1;
					LD_IR = 1'b1;
				end
			S_32 : 
				LD_BEN = 1'b1;

			// ADD
			S_01 : 
				begin 
					LD_REG = 1'b1;
					SR1MUX = 1'b0; // choose IR[8:6]
					SR2MUX = IR_5; // choose SR2 (0) or imm5 (1)
					ALUK = 2'b00; // 00 is ADD
					GateALU = 1'b1;
					DRMUX = 1'b0; // choose IR[11:9]
					LD_CC = 1'b1; // set CC
				end

			// AND
			S_05 :
				begin 
					LD_REG = 1'b1;
					SR1MUX = 1'b0; // choose IR[8:6]
					SR2MUX = IR_5;
					ALUK = 2'b01; // 01 is AND
					GateALU = 1'b1;
					DRMUX = 1'b0; // choose IR[11:9]
					LD_CC= 1'b1; // set CC
				end

			// NOT
			S_09:
				begin
					LD_REG = 1'b1;
					SR1MUX = 1'b0; // choose IR[8:6]
					ALUK = 2'b10; // 10 is NOT
					GateALU = 1'b1;
					DRMUX = 1'b0; // choose IR[11:9]
					LD_CC = 1'b1; // set CC
				end

			// LDR
			S_06:
				begin
					ADDR2MUX = 2'b01;
					ADDR1MUX = 1'b1;
					SR1MUX = 1'b0;
					GateMARMUX = 1'b1;
					LD_MAR = 1'b1;
				end
			S_25_1:
				Mem_OE = 1'b0;
			S_25_2:
				begin
					Mem_OE = 1'b0;
					LD_MDR = 1'b1;
				end
			S_27:
				begin
					GateMDR = 1'b1;
					LD_REG = 1'b1;
					DRMUX = 1'b0; // IR[11:9]
					LD_CC = 1'b1; // SetCC
				end
			
			// STR
			S_07:
				begin
					LD_MAR = 1'b1;
					GateMARMUX = 1'b1;
					SR1MUX = 1'b0; // choose IR[8:6]
					ADDR1MUX = 1'b1; // choose SR1_OUT
					ADDR2MUX = 2'b01; // choose [5:0]SEXT
				end
			S_23:
				begin
					LD_MDR = 1'b1;
					ALUK = 2'b11; // 11 is PASSA
					SR1MUX = 1'b1; // choose IR[11:9]
					GateALU = 1'b1;
				end
			S_16_1:
				Mem_WE = 1'b0;
			S_16_2:
				Mem_WE = 1'b0;
			
			// BR
			S_00: 
					;
			S_22:
				begin
					LD_PC = 1'b1;
					ADDR2MUX = 2'b10; // choose [8:0]SEXT
					ADDR1MUX = 1'b0; // choose output from PC
					PCMUX = 2'b01; // choose output from adder
				end

			// JMP
			S_12:
				begin
					LD_PC = 1'b1;
					SR1MUX = 1'b0; // choose IR[8:6]
					ALUK = 2'b11; // 11 is PASSA
					GateALU = 1'b1;
					PCMUX = 2'b10; // choose value from BUS
				end

			// JSR
			S_04:
				begin
					LD_REG = 1'b1;
					GatePC = 1'b1;
					DRMUX = 1'b1; // select R7
				end
			S_21:
				begin
					LD_PC = 1'b1;
					PCMUX = 2'b1; // choose value from BUS
					case (IR_11)
						0: 
							begin
								SR1MUX = 1'b0; // choose IR[8:6]
								ALUK = 2'b11; // 11 is PASSA
								GateALU = 1'b1;
							end
						1: 
							begin
								ADDR1MUX = 1'b0; // choose output from PC
								ADDR2MUX = 2'b11; // select SEXT[IR[10:0]]
								GateMARMUX = 1'b1;
							end
						default: ;
					endcase
				end

			// PSE
			PauseIR1: ;
			PauseIR2: ;
			default : ;
		endcase
	end 

	 // These should always be active
	assign Mem_CE = 1'b0;
	assign Mem_UB = 1'b0;
	assign Mem_LB = 1'b0;
	
endmodule
