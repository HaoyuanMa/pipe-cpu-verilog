`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/11 12:10:21
// Design Name: 
// Module Name: one_cycle_cpu
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


module pipe_cpu(
    input       clk,
    input       rst
);

wire        c_is_br;
wire        c_is_lw_id_ex;
wire        c_is_lw_ex_id;
wire        pc_temp;
wire [ 1:0] c_alu_src;
wire        reg_we;
wire        c_reg_we_id_ex;
wire        c_reg_we_ex_me;
wire        c_reg_we_me_wb;
wire        c_mem_we_id_ex;
wire        c_mem_we_ex_me;
wire        c_reg_data_id_ex;
wire        c_reg_data_ex_me;
wire        c_reg_data_me_wb;
wire        c_reg_addr_id_ex;
wire        c_reg_addr_ex_me;
wire        c_reg_addr_me_wb;
wire [31:0] mem_data;
wire [31:0] target;
wire [13:0] ca;
wire [ 4:0] reg_addr_ex_b;
wire [31:0] reg_data_ex_b;
wire [ 4:0] reg_addr_me_b;
wire [31:0] reg_data_me_b;
wire [ 4:0] reg_addr_wb_b;
wire [31:0] reg_data_wb_b;
wire [31:0] inst_if_id;
wire [31:0] inst_id_ex;
wire [31:0] inst_ex_me;
wire [31:0] inst_me_wb;
wire [31:0] rs_value;
wire [31:0] rt_value_id_ex;
wire [31:0] rt_value_ex_me;
wire [31:0] alu_result_ex_me;
wire [31:0] alu_result_me_wb;
wire [31:0] reg_waddr;
wire [31:0] reg_wdata;
wire [31:0] nextpc;


reg  [31:0] pc;
reg         reset;
always @(posedge clk) reset <= ~rst;

assign nextpc = target; 

always @(posedge clk) begin
    if (reset)  begin
         pc <= 32'hbfc00000;
    end
    else       pc <= nextpc;
end

ifs _ifs(
    .clk        (clk),
    .rst        (rst),
    .c_is_br    (c_is_br),
    .c_is_lw    (c_is_lw_id_ex),
    .pc         (pc),
    .final_inst (inst_if_id)
);

ids _ids(
    .clk        (clk),
    .rst        (rst),
    .c_is_lw_in (c_is_lw_ex_id),
    .inst_in    (inst_if_id),
    .reg_we     (reg_we),
    .reg_we_ex  (c_reg_we_ex_me),
    .reg_we_me  (c_reg_we_me_wb),
    .reg_waddr  (reg_waddr),
    .reg_wdata  (reg_wdata),
    .reg_addr_ex_b (reg_addr_ex_b),
    .reg_data_ex_b (reg_data_ex_b),
    .reg_addr_me_b (reg_addr_me_b),
    .reg_data_me_b (reg_data_me_b),
    .reg_addr_wb_b (reg_addr_wb_b),
    .reg_data_wb_b (reg_data_wb_b),
    .mem_data_b (mem_data),
    .pc         (pc),
    .c_is_br    (c_is_br),
    .c_is_lw_out (c_is_lw_id_ex),
    .c_alu_src  (c_alu_src),
    .c_mem_we   (c_mem_we_id_ex),
    .c_reg_data (c_reg_data_id_ex),
    .c_reg_addr (c_reg_addr_id_ex),
    .c_reg_we   (c_reg_we_id_ex),
    .ca         (ca),
    .inst_out   (inst_id_ex),         
    .rs_value   (rs_value),
    .rt_value   (rt_value_id_ex),
    .target     (target)
);

exs _exs(
    .clk            (clk),
    .rst            (rst),   
    .c_is_lw_in     (c_is_lw_id_ex),
    .c_alu_src_in   (c_alu_src),
    .c_mem_we_in    (c_mem_we_id_ex),
    .c_reg_data_in  (c_reg_data_id_ex),
    .c_reg_addr_in  (c_reg_addr_id_ex),
    .c_reg_we_in    (c_reg_we_id_ex),
    .ca_in          (ca),
    .rs_value_in    (rs_value),
    .rt_value_in    (rt_value_id_ex),
    .inst_in        (inst_id_ex),
    .c_is_lw_out    (c_is_lw_ex_id),
    .c_mem_we_out   (c_mem_we_ex_me),
    .c_reg_we_out   (c_reg_we_ex_me),
    .c_reg_data_out (c_reg_data_ex_me),
    .c_reg_addr_out (c_reg_addr_ex_me),
    .inst_out       (inst_ex_me),
    .rt_value_out   (rt_value_ex_me),
    .alu_result     (alu_result_ex_me),
    .reg_addr_ex_b  (reg_addr_ex_b),
    .reg_data_ex_b  (reg_data_ex_b)
    );

mes _mes(
    .clk            (clk),
    .rst            (rst),
    .c_mem_we_in    (c_mem_we_ex_me),
    .c_reg_data_in  (c_reg_data_ex_me),
    .c_reg_addr_in  (c_reg_addr_ex_me),
    .c_reg_we_in    (c_reg_we_ex_me),
    .alu_result_in  (alu_result_ex_me),
    .rt_value_in    (rt_value_ex_me),
    .inst_in        (inst_ex_me),
    .c_reg_we_out   (c_reg_we_me_wb),
    .c_reg_data_out (c_reg_data_me_wb),
    .c_reg_addr_out (c_reg_addr_me_wb),
    .alu_result_out (alu_result_me_wb),
    .inst_out       (inst_me_wb),
    .mem_data       (mem_data),
    .reg_addr_me_b  (reg_addr_me_b),
    .reg_data_me_b  (reg_data_me_b)
    );

wbs _wbs(
    .clk           (clk),
    .rst           (rst),
    .c_reg_we_in   (c_reg_we_me_wb),
    .c_reg_data_in (c_reg_data_me_wb),
    .c_reg_addr_in (c_reg_addr_me_wb),
    .alu_result_in (alu_result_me_wb),
    .mem_rdata     (mem_data),
    .inst_in       (inst_me_wb),
    .reg_we        (reg_we),
    .reg_waddr     (reg_waddr),
    .reg_wdata     (reg_wdata),
    .reg_addr_wb_b  (reg_addr_wb_b),
    .reg_data_wb_b  (reg_data_wb_b)
    );    

endmodule

