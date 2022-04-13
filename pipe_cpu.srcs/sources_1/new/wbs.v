`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/20 17:13:22
// Design Name: 
// Module Name: wbs
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

module wbs(
    input         clk,
    input         rst,
    input         c_reg_we_in,
    input         c_reg_data_in,
    input         c_reg_addr_in,
    input  [31:0] alu_result_in,
    input  [31:0] mem_rdata,
    input  [31:0] inst_in,
    output        reg_we,
    output [ 4:0] reg_waddr,
    output [31:0] reg_wdata,
    output [ 4:0] reg_addr_wb_b,
    output [31:0] reg_data_wb_b 
    );
    
    reg        c_reg_we;
    reg        c_reg_data;
    reg        c_reg_addr;
    reg [31:0] inst;
    reg [31:0] rt_value;
    reg [31:0] alu_result;
    reg [31:0] mem_data;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            c_reg_we   <= 1'b0;
            c_reg_data <= 1'b0;
            c_reg_addr <= 1'b0;
            inst       <= 32'b0;
            alu_result <= 32'b0;
        end
        else begin
            c_reg_we   <= c_reg_we_in;
            c_reg_data <= c_reg_data_in;
            c_reg_addr <= c_reg_addr_in;
            inst       <= inst_in;
            alu_result <= alu_result_in;
            mem_data   <= mem_rdata;
        end
    end
    
    assign reg_we    = c_reg_we;
    assign reg_waddr = c_reg_addr ? inst[20:16] : inst[15:11];
    assign reg_wdata = c_reg_data ? mem_data : alu_result;
    assign reg_addr_wb_b  = c_reg_addr ? inst[20:16] : inst[15:11];
    assign reg_data_wb_b  = reg_wdata;

endmodule
