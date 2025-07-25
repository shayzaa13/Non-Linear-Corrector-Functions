`timescale 1ns / 1ps
module top #(
    parameter INPUT_WIDTH = 10,       // Width of 'in' input
    parameter M_WIDTH = 3)            // Width of 'm', 'y' and final output
         
    (   input clk,
        input rst,
        input start,
        input [INPUT_WIDTH-1:0] in, // input bitstream
        output [M_WIDTH-1:0] random_out //output random bitstrean
    );

    reg [M_WIDTH-1:0] y;
    reg [INPUT_WIDTH-M_WIDTH-1:0] x;
    reg [M_WIDTH-1:0] r; //mod value of y
    reg [M_WIDTH-1:0] r_temp;
    integer i;
      
    downcounter #( .M_WIDTH(M_WIDTH),
                   .INPUT_WIDTH(INPUT_WIDTH)
                 )
                   dc (.clk(clk), 
                       .rst(rst), 
                       .in(in), 
                       .r(r), 
                       .start_count(start), 
                       .random_out(random_out)
                   );
    
    always @(*) begin
        r_temp = 0;
        y = in[INPUT_WIDTH-1:INPUT_WIDTH-M_WIDTH];
        x = in[INPUT_WIDTH-M_WIDTH-1:0];
        
        //calculation of r=[y]
        for (i = 0; i < M_WIDTH; i = i + 1) begin
            r_temp = r_temp + (y[M_WIDTH - 1 - i] << i);
        end
        r = r_temp;
    end
endmodule
