`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/18 22:39:39
// Design Name: 
// Module Name: ids
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


module ids(
    input         clk,
    input         rst,
    input         c_is_lw_in,
    input  [31:0] inst_in,
    input         reg_we,
    input         reg_we_ex,
    input         reg_we_me,
    input  [ 4:0] reg_waddr,
    input  [31:0] reg_wdata,
    input  [31:0] pc,
    input  [ 4:0] reg_addr_ex_b,
    input  [31:0] reg_data_ex_b,
    input  [ 4:0] reg_addr_me_b,
    input  [31:0] reg_data_me_b,
    input  [ 4:0] reg_addr_wb_b,
    input  [31:0] reg_data_wb_b,
    input  [31:0] mem_data_b,  
    output        c_is_br,
    output        c_is_lw_out,
    output [ 1:0] c_alu_src,
    output        c_mem_we,
    output        c_reg_data,
    output        c_reg_addr,
    output        c_reg_we,
    output [13:0] ca,
    output [31:0] inst_out,         
    output [31:0] rs_value,
    output [31:0] rt_value,
    output [31:0] target
    );
    
    reg [31:0] inst;
    reg        c_is_lw;
    
    wire        c_is_lw_t;
    wire [ 5:0] op;
    wire [ 5:0] func;
    wire [ 4:0] rs;
    wire [ 4:0] rt;
    wire [ 4:0] cb;
    wire [25:0] index;
    wire [31:0] rt_value_t;
    wire [31:0] rs_value_t;
    
    
    always @(posedge clk or negedge rst) begin
    if (!rst) begin
        inst <= 32'b1;
        c_is_lw <= 1'b0;
        end 
    else begin
        inst <= inst_in;
        c_is_lw <= c_is_lw_in;
        end
    end
    
    assign op    = inst[31:26];
    assign rs    = inst[25:21];
    assign rt    = inst[20:16];
    assign func  = inst[ 5: 0];
    assign index = inst[25: 0];
    
   
    
    regfile _regfile(
    .clk    (clk        ),
    .raddr1 (rs         ),
    .rdata1 (rs_value_t ),
    .raddr2 (rt         ),
    .rdata2 (rt_value_t ),
    .we     (reg_we     ),
    .waddr  (reg_waddr  ),
    .wdata  (reg_wdata  )
    );
    
    bru _bru(
    .rs_value (rs_value ),
    .op       (cb       ),
    .c_is_lw  (c_is_lw_t),
    .index    (index    ),
    .pc       (pc       ),
    .target   (target   )
    );
    
    
    cu _cu(
    .op         (op         ), 
    .func       (func       ),
    .src1       (rs_value   ),
    .src2       (rt_value   ),
    .ca         (ca         ),
    .cb         (cb         ),
    .c_is_br    (c_is_br    ),
    .c_is_lw    (c_is_lw_t  ),
    .c_alu_src  (c_alu_src  ),
    .c_mem_we   (c_mem_we   ),
    .c_reg_data (c_reg_data ),
    .c_reg_addr (c_reg_addr ),
    .c_reg_we   (c_reg_we   )
    );
    
   
    assign c_is_lw_out = c_is_lw_t; 
    assign inst_out    = inst;
    assign rs_value    = (rs === reg_addr_ex_b & reg_we_ex) ? reg_data_ex_b : 
                         (rs === reg_addr_me_b & reg_we_me) ? reg_data_me_b : 
                         (rs === reg_addr_wb_b & reg_we) ? reg_data_wb_b : rs_value_t;
    assign rt_value    = c_is_lw ? mem_data_b : (rt === reg_addr_ex_b & reg_we_ex) ? reg_data_ex_b : 
                         (rt === reg_addr_me_b & reg_we_me) ? reg_data_me_b : 
                         (rt === reg_addr_wb_b & reg_we) ? reg_data_wb_b : rt_value_t; 

endmodule
