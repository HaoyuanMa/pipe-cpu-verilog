`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/12 01:24:38
// Design Name: 
// Module Name: bru
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


module bru(
    input         c_is_lw,       
    input  [ 4:0] op,
    input  [31:0] rs_value,
    input  [25:0] index,
    input  [31:0] pc,
    output [31:0] target
    );
    
    wire        is_j;
    wire        is_jr;
    wire        is_beq;
    wire        is_bne;
    wire        is_bltz;
    wire        src_is_eq;
    wire [31:0] offset;
    wire [31:0] bds;
    
    assign bds        = pc + 3'h4;
    assign offset     = {{14{index[15]}}, index[15:0], 2'b0};  
    assign is_beq     = op[0];
    assign is_j       = op[1];
    assign is_bne     = op[2];
    assign is_bltz    = op[3];
    assign is_jr      = op[4];
    assign target     = c_is_lw ? pc : is_j ? {bds[31:28],index,2'b00} : is_jr ? rs_value : 
                        ((is_beq) | (is_bne) | (is_bltz)) ? (offset + bds) : (bds);
endmodule
