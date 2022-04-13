`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/18 22:15:19
// Design Name: 
// Module Name: ifs
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

module ifs(
    input         clk,
    input         rst,
    input         c_is_br,
    input         c_is_lw,
    input  [31:0] pc,
    output [31:0] final_inst
    );

    wire [31:0] inst;
    
    reg is_start;
    
    always @(posedge clk) begin
        if (!rst)  begin
            is_start <= 1'b1;
        end
        else
            is_start <= 1'b0;  
        end
    
    inst_ram _inst_ram(
    .clk    (clk ), //I
    .rst    (rst ), //I
    .addr   (pc  ), //I
    .data   (inst)  //O
    );

    assign final_inst = is_start ? 32'b1 : c_is_br | c_is_lw ? 32'b0 : inst;
   
endmodule
