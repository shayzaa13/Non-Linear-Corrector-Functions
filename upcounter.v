`timescale 1ns / 1ps

module upcounter#( parameter M_WIDTH=3,
                  parameter INPUT_WIDTH=10)
       (
                    input clk,
                    input rst,
                    input [INPUT_WIDTH-1:0] in,
                    input start,
                    input [M_WIDTH-1:0] lfsr_out,
                    output reg [M_WIDTH-1:0] random_out,
                    output reg done);

    reg [M_WIDTH-1:0] counter;
    reg [M_WIDTH-1:0] counts [0:INPUT_WIDTH-M_WIDTH-1];
    integer i;
    reg filling_done;
    reg [INPUT_WIDTH-M_WIDTH-1:0] temp_array;
    reg [M_WIDTH-1:0] y; 
    reg [INPUT_WIDTH-M_WIDTH-1:0] x;
    reg [M_WIDTH-1:0] temp_count=0;
    reg [M_WIDTH-1:0] temp_out;

    // Sequential block: fill the array
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            counter <= 1;
            filling_done <= 0;
            done<=0;
            temp_out<=0;   
        end 
        
        else if (start && !filling_done) begin
            if(counter < (1<<M_WIDTH)) begin
                counts[counter-1] <= counter;
                counter <= counter + 1;
                if(counter == (1<<M_WIDTH)-1) begin            
                    filling_done <= 1;
                end
            end
        end
    end

    // Combinational block: process after array is filled
    always @(*) begin
        done=0;
        y = in[INPUT_WIDTH-1:INPUT_WIDTH-M_WIDTH];
        x = in[INPUT_WIDTH-M_WIDTH-1:0];
        
        if (filling_done && (temp_count<M_WIDTH)) begin
        
            for(i=0; i<(1<<M_WIDTH)-1; i=i+1) begin
                temp_array[i] = ^(counts[i] & lfsr_out);
                
                if(i==(1<<M_WIDTH)-2) begin
                    temp_out [temp_count] = ^(temp_array & x);
                    $display("temp_out[%0d]= %b, temp_array = %b, x= %b", temp_count, temp_out[temp_count], temp_array, x);                   
                    temp_count=temp_count+1;
                    
                    if(temp_count==M_WIDTH-1) 
                        random_out=temp_out; 
                    done=1;                                     
                end
            end
        end       
        else begin
            temp_array = 0;
        end
    end
endmodule

