`timescale 1ns / 1ps

module downcounter #( parameter M_WIDTH=3,
                      parameter INPUT_WIDTH=10)
    (
        input clk,
        input rst,
        input [INPUT_WIDTH-1:0] in,
        input [M_WIDTH-1:0] r,
        input start_count,
        output [M_WIDTH-1:0] random_out
    );
    reg [M_WIDTH-1:0] current_count;
    reg [M_WIDTH-1:0] count;
    reg busy;
    reg start_shift;
    wire done_upcount;
    wire done_shift;

    shiftreg #( .M_WIDTH(M_WIDTH),
                .INPUT_WIDTH(INPUT_WIDTH))
       sr(
            .clk(clk),
            .rst(rst),
            .in(in),
            .count(count),
            .start_shift(start_shift),
            .done_shift(done_shift),
            .random_out(random_out),
            .done_upcount(done_upcount)
        );

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= r;
            current_count <= r;
            start_shift <= 0;
            busy <= 0;
        end 
        
        else if (start_count) begin
            if (!busy && count > r-M_WIDTH+1) begin
                start_shift <= 1; // Start shift for current count
                busy <= 1;
            end 
          
            else if (busy) begin
                if (done_shift & done_upcount) begin
                    $display("shift done for count %0d", count);
                    // Shift operation done for current count
                    current_count <= count - 1;
                    count <= count - 1;
                    busy <= 0;
                end
            end
        end
    end

endmodule
