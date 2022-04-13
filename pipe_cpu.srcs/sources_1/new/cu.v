`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/12 01:16:18
// Design Name: 
// Module Name: cu
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


module cu(
    input  [ 5:0] op,
    input  [ 5:0] func,
    input  [31:0] src1,
    input  [31:0] src2,
    output [13:0] ca,
    output [ 4:0] cb,
    output        c_is_br,
    output        c_is_lw,
    output [ 1:0] c_alu_src,
    output        c_mem_we,
    output        c_reg_data,
    output        c_reg_addr,
    output        c_reg_we
    ); 
    
wire [63:0] op_d;
wire [63:0] func_d;

wire        src_is_eq;
wire        rs_is_ne;

wire        inst_and;
wire        inst_or;
wire        inst_xor;
wire        inst_nor;
wire        inst_add;
wire        inst_addu;
wire        inst_sub;
wire        inst_subu;
wire        inst_mul;
wire        inst_addiu;
wire        inst_addi;
wire        inst_lui;
wire        inst_slt;
wire        inst_sltu;
wire        inst_slti;
wire        inst_sltiu;
wire        inst_sll;
wire        inst_srl;
wire        inst_sra;
wire        inst_srav;
wire        inst_srlv;
wire        inst_sllv;
wire        inst_lw;
wire        inst_sw;
wire        inst_movn;
wire        inst_movz;
wire        inst_j;
wire        inst_beq;
wire        inst_jr;
wire        inst_bne;
wire        inst_bltz;

    
decoder_6_64 u_dec0(.in(op  ), .out(op_d  ));
decoder_6_64 u_dec1(.in(func), .out(func_d));
    
assign inst_addiu  = op_d[6'h09];
assign inst_addi   = op_d[6'h08];
assign inst_add    = op_d[6'h00] & func_d[6'h20];
assign inst_addu   = op_d[6'h00] & func_d[6'h21]; 
assign inst_subu   = op_d[6'h00] & func_d[6'h23];
assign inst_sub    = op_d[6'h00] & func_d[6'h22];
assign inst_slt    = op_d[6'h00] & func_d[6'h2a];
assign inst_sltu   = op_d[6'h00] & func_d[6'h2b];
assign inst_slti   = op_d[6'h0a];
assign inst_sltiu  = op_d[6'h0b];
assign inst_mul    = op_d[6'h1c] & func_d[6'h02];
assign inst_and    = op_d[6'h00] & func_d[6'h24];
assign inst_or     = op_d[6'h00] & func_d[6'h25];
assign inst_xor    = op_d[6'h00] & func_d[6'h26];
assign inst_nor    = op_d[6'h00] & func_d[6'h27];
assign inst_sll    = op_d[6'h00] & func_d[6'h00];
assign inst_srl    = op_d[6'h00] & func_d[6'h02];
assign inst_sra    = op_d[6'h00] & func_d[6'h03];
assign inst_srav   = op_d[6'h00] & func_d[6'h07];
assign inst_srlv   = op_d[6'h00] & func_d[6'h06];
assign inst_sllv   = op_d[6'h00] & func_d[6'h04]; 
assign inst_movn   = op_d[6'h00] & func_d[6'h0b];
assign inst_movz   = op_d[6'h00] & func_d[6'h0a];
assign inst_lw     = op_d[6'h23];
assign inst_sw     = op_d[6'h2b];
assign inst_lui    = op_d[6'h0f];
assign inst_beq    = op_d[6'h04];
assign inst_j      = op_d[6'h02];
assign inst_bne    = op_d[6'h05];
assign inst_jr     = op_d[6'h00] & func_d[6'h08];
assign inst_bltz   = op_d[6'h01];
assign src_is_eq   = (src1 === src2);
assign rs_is_ne    =  src1[31];
    
assign ca[ 0] = inst_addi | inst_add | inst_addiu | inst_addu | inst_lw | inst_sw;
assign ca[ 1] = inst_srlv | inst_srl;
assign ca[ 2] = inst_lui; 
assign ca[ 3] = inst_sub | inst_subu;
assign ca[ 4] = inst_slt | inst_slti;
assign ca[ 5] = inst_sltu | inst_sltiu;
assign ca[ 6] = inst_mul;
assign ca[ 7] = inst_and;
assign ca[ 8] = inst_nor;
assign ca[ 9] = inst_or;
assign ca[10] = inst_xor;
assign ca[11] = inst_sll | inst_sllv;
assign ca[12] = inst_sra | inst_srav;
assign ca[13] = inst_movn | inst_movz; 

assign cb[0]      = inst_beq;
assign cb[1]      = inst_j;
assign cb[2]      = inst_bne;
assign cb[3]      = inst_bltz;
assign cb[4]      = inst_jr;
assign c_is_br    = inst_j | inst_jr | (inst_beq & src_is_eq) | (inst_bne & ~src_is_eq) | (inst_bltz & rs_is_ne);
assign c_is_lw    = inst_lw;
assign c_alu_src  = {(inst_and | inst_xor | inst_or | inst_nor | inst_add | inst_addu | inst_sub | inst_subu | inst_sll |
                      inst_sllv | inst_srl | inst_srlv | inst_sra | inst_srav | inst_slt | inst_sltu | inst_mul),
                    ~(inst_sll | inst_srl | inst_sra )};
assign c_mem_we   = inst_sw;
assign c_reg_data = inst_lw;
assign c_reg_addr = inst_addi | inst_addiu | inst_lw | inst_lui | inst_slti | inst_sltiu;
assign c_reg_we   = inst_add | inst_addi | inst_addiu | inst_addu | inst_sub | inst_subu | inst_slt | inst_sltu | 
                    inst_slti | inst_sltiu | inst_mul | inst_and | inst_or | inst_xor | inst_nor | inst_sll | 
                    inst_sllv | inst_srl | inst_srlv | inst_sra | inst_srav | inst_lui | inst_lw | (inst_movn & src2 != 32'b0) | (inst_movz & src2=== 32'b0);  

endmodule
