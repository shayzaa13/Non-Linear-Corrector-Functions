`timescale 1ns / 1ps

module shiftreg#( parameter M_WIDTH=3,
                  parameter INPUT_WIDTH=10)
       (
                input clk,
                input rst,
                input [INPUT_WIDTH-1:0] in,
                input [M_WIDTH-1:0] count,
                input start_shift,
                output reg done_shift,
                output [M_WIDTH-1:0] random_out,
                output done_upcount);

    reg [M_WIDTH-1:0] lfsr_int;
    reg [M_WIDTH-1:0] counter; 
    reg start_upcount;
    reg [M_WIDTH-1:0] lfsr_out;
    
    upcounter uc( .clk(clk), 
                  .rst(rst), 
                  .in(in), 
                  .start(start_upcount), 
                  .lfsr_out(lfsr_out), 
                  .random_out(random_out), 
                  .done (done_upcount)
                ); 

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            done_shift <= 0;
            lfsr_int <= 1;
            counter <= 0;
            lfsr_out <= 0;
            start_upcount<=0;
        end 
        
        else begin
            if (start_shift && !done_shift) begin // start shifting
                if (counter < count+1) begin 
                    lfsr_int <= {lfsr_int[1], lfsr_int[2] ^ lfsr_int[0], lfsr_int[2]};
                    counter <= counter + 1;
                    
                    if(counter==count) begin
                        lfsr_out=lfsr_int;
                        $display("lfsr output for count %0d = %b", count, lfsr_out);
                    end
                end 
                
                else begin
                    done_shift = 1;
                    start_upcount = 1;
                end
            end 
            else if (done_shift & done_upcount) begin
                start_upcount <= 0;
                done_shift <= 0;
                lfsr_int <= 1;
                counter <= 0;
            end
        end
    end

endmodule





