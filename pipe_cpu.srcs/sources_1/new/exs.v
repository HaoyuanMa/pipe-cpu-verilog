`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/20 16:35:42
// Design Name: 
// Module Name: exs
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


module exs(
    input         clk,
    input         rst, 
    input         c_is_lw_in,
    input         c_mem_we_in,
    input         c_reg_data_in,
    input         c_reg_addr_in,
    input         c_reg_we_in,
    input  [13:0] ca_in,
    input  [ 1:0] c_alu_src_in,
    input  [31:0] rs_value_in,
    input  [31:0] rt_value_in,
    input  [31:0] inst_in,
    output        c_is_lw_out,
    output        c_mem_we_out,
    output        c_reg_we_out,
    output        c_reg_data_out,
    output        c_reg_addr_out,
    output [31:0] inst_out,
    output [31:0] rt_value_out,
    output [31:0] alu_result,
    output [31:0] reg_addr_ex_b,
    output [31:0] reg_data_ex_b
    );
    
    reg        c_is_lw;
    reg [ 1:0] c_alu_src;
    reg        c_mem_we;
    reg        c_reg_we;
    reg        c_reg_data;
    reg        c_reg_addr;
    reg [13:0] ca;
    reg [31:0] inst;
    reg [31:0] rs_value;
    reg [31:0] rt_value;
   
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            inst <= 32'b0;
            rs_value <= 32'b0;
            rt_value <= 32'b0;
            c_is_lw  <= 1'b0;
        end
        else begin
            c_is_lw    <= c_is_lw_in;
            c_mem_we   <= c_mem_we_in;
            c_reg_we   <= c_reg_we_in;
            ca         <= ca_in;
            c_alu_src  <= c_alu_src_in;
            c_reg_data <= c_reg_data_in;
            c_reg_addr <= c_reg_addr_in;
            inst       <= inst_in;
            rs_value   <= rs_value_in;
            rt_value   <= rt_value_in;
        end
    end

    wire [31:0] mux_alu1;
    wire [31:0] mux_alu2;
    
    assign mux_alu1 = c_alu_src[0] ? rs_value :  {27'b0,inst[10:6]};
    assign mux_alu2 = c_alu_src[1] ? rt_value : {{16{inst[15]}},inst[15:0]};

    alu _alu(
    .alu_op     (ca        ),
    .alu_src1   (mux_alu1  ),
    .alu_src2   (mux_alu2  ),
    .alu_result (alu_result)
    );

    assign c_is_lw_out    = c_is_lw;
    assign inst_out       = inst;
    assign rt_value_out   = rt_value;
    assign c_mem_we_out   = c_mem_we;
    assign c_reg_we_out   = c_reg_we;
    assign c_reg_data_out = c_reg_data;
    assign c_reg_addr_out = c_reg_addr;
    assign reg_addr_ex_b  = c_reg_addr ? inst[20:16] : inst[15:11];
    assign reg_data_ex_b  = alu_result;

endmodule
