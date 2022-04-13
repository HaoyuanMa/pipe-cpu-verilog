`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/12 11:24:49
// Design Name: 
// Module Name: inst_ram
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


module inst_ram(
    input         clk,
    input         rst,
    input  [31:0] addr,
    output [31:0] data
    );
    
    reg [7:0] mem[255:0];
    
    initial begin
    $readmemb("C:/Users/MaHaoyuan/Desktop/cpu/testmc.txt",mem);
    end
    
    wire [7:0] baddr = addr[7:0];
    assign data = {mem[baddr],mem[baddr+1],mem[baddr+2],mem[baddr+3]};    
    
endmodule
