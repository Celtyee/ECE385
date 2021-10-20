module controller(
    input  logic Clk, Reset, ClearA_LoadB, Run, M,
    output logic Clr_Ld, Shift, Add, Sub
);

    enum logic [1:0] {Start, Ld, Sft, Fin} state, next_state;
    enum logic [2:0] {S0, S1, S2, S3, S4, S5, S6, S7} count, next_count;

	// Update state
    always_ff @ (posedge Clk) begin
        if (Reset) begin
            state <= Start;
            count <= S0;
        end
        else begin
            state <= next_state;
            count <= next_count;
        end
    end

    always_comb begin
        next_state = state;
        next_count = count;
        unique case (state)
            Start: 
                if (Run) next_state = Ld;
            Ld:
                next_state = Sft;
            Sft: 
            begin
                if (count == S7) next_state = Fin;
                else next_state = Ld;
                unique case (count)
                    S0: next_count = S1;
                    S1: next_count = S2;
                    S2: next_count = S3;
                    S3: next_count = S4;
                    S4: next_count = S5;
                    S5: next_count = S6;
                    S6: next_count = S7;
                    S7: next_count = S0;
                    default:;
                endcase
            end
            Fin:
                if (~Run) next_state = Start;
            default:
                ;
        endcase

        // output
        case (state)
            Start: begin
                Clr_Ld = ClearA_LoadB;
                Shift = 0;
                Add = 0;
                Sub = 0;
                if (Run) Clr_Ld = 1;
            end
            Ld: begin
                Clr_Ld = 0;
                Shift = 0;
                Add = 0;
                Sub = 0;
                if (count == S7) Sub = M;
                else Add = M;
            end
            Sft: begin
                Clr_Ld = 0;
                Shift = 1;
                Add = 0;
                Sub = 0;
            end
            default: begin
                Clr_Ld = 0;
                Shift = 0;
                Add = 0;
                Sub = 0;
            end
        endcase
    end
endmodule
