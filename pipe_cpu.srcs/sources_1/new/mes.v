`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/20 16:58:19
// Design Name: 
// Module Name: mes
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


module mes(
    input         clk,
    input         rst,
    input         c_mem_we_in,
    input         c_reg_data_in,
    input         c_reg_addr_in,
    input         c_reg_we_in,
    input  [31:0] alu_result_in,
    input  [31:0] rt_value_in,
    input  [31:0] inst_in,
    output        c_reg_we_out,
    output        c_reg_data_out,
    output        c_reg_addr_out,
    output [31:0] alu_result_out,
    output [31:0] inst_out,
    output [31:0] mem_data,
    output [ 4:0] reg_addr_me_b,
    output [31:0] reg_data_me_b
    );
    
    reg        c_is_lw;
    reg        c_mem_we;
    reg        c_reg_we;
    reg        c_reg_data;
    reg        c_reg_addr;
    reg [31:0] inst;
    reg [31:0] rt_value;
    reg [31:0] alu_result;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            inst <= 32'b0;
            alu_result <= 32'b0;
            rt_value <= 32'b0;
        end
        else begin
            c_mem_we   <= c_mem_we_in;
            c_reg_we   <= c_reg_we_in;
            c_reg_data <= c_reg_data_in;
            c_reg_addr <= c_reg_addr_in;
            inst       <= inst_in;
            alu_result <= alu_result_in;
            rt_value   <= rt_value_in;
        end
    end

    data_ram _data_ram(
    .clk   (clk       ),
    .rst   (rst       ),
    .wen   (c_mem_we ),
    .addr  (alu_result),
    .wdata (rt_value  ),
    .rdata (mem_data )
    );

    assign alu_result_out = alu_result;
    assign inst_out       = inst;
    assign c_reg_we_out   = c_reg_we;
    assign c_reg_data_out = c_reg_data;
    assign c_reg_addr_out = c_reg_addr;
    assign reg_addr_me_b  = c_reg_addr ? inst[20:16] : inst[15:11];
    assign reg_data_me_b  = alu_result;


endmodule
