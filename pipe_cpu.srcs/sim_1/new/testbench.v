`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/20 23:34:13
// Design Name: 
// Module Name: testbench
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module testbench(

    );
    
    reg clk;
    reg rst;
    initial begin
        clk = 0;
        rst = 0;
        #20
        rst = 1;
        
    end
    
    always #10 clk=~clk;
    
    pipe_cpu cpu(
        .clk   (clk),
        .rst   (rst)
    );
endmodule

    
