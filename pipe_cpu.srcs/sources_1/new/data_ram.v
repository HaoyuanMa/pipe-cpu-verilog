`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/11 14:08:11
// Design Name: 
// Module Name: data_ram
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


module data_ram(
    input  wire       clk,
    input  wire       rst,
    input  wire       wen,
    input  wire[31:0] addr,
    input  wire[31:0] wdata,
    output wire[31:0] rdata
    );
    
   reg[7:0] mem[255:0];
    
    
    initial begin
    $readmemb("C:/Users/MaHaoyuan/Desktop/cpu/testdata.txt",mem);
    end
    
    wire [7:0] baddr = addr[7:0];
    assign rdata = {mem[baddr+3],mem[baddr+2],mem[baddr+1],mem[baddr]}; 
    always @(posedge clk) begin
	    if(wen) begin
	        mem[baddr  ] <= wdata[ 7: 0];
	        mem[baddr+1] <= wdata[15: 8];
	        mem[baddr+2] <= wdata[23:16];
	        mem[baddr+3] <= wdata[31:24];
	    end
	end
	
endmodule
