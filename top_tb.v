`timescale 1ns / 1ps

module top_tb;
reg clk, rst;
reg [9:0] in;
reg start;
wire [2:0] out;
wire done;

top uut(clk, rst, start, in, out);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    rst = 1;
    start= 1;
    in = 10'b1011100010; // Example input
    #20;
    rst = 0;
    #500; // Run for a while
    $finish;
end

endmodule

