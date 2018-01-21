`timescale 1ns / 1ps

`define ADDR_OEN    5'b00000
`define ADDR_SET    5'b00100
`define ADDR_RESET  5'b01000
`define ADDR_READ   5'b10000

module wb_gpio (
  input clk_sys_i,
  input rst_n_i,
  
  input  [7:0] gpio_in_i,
  output [7:0] gpio_oen_o,
  output [7:0] gpio_out_o,
  
  output reg [31:0] wb_dat_o,
  input [4:0] wb_adr_i,
  input [31:0] wb_dat_i,
  //input wb_sel_i,
  input wb_stb_i,
  input wb_cyc_i,
  input wb_we_i,
  output reg wb_ack_o
);
  reg [7:0] oen;
  reg [7:0] out;

  wire wb_transaction = wb_cyc_i && wb_stb_i;
  wire wb_write = wb_we_i && wb_transaction;
  wire wb_read = !wb_we_i && wb_transaction;
  
  assign gpio_oen_o = oen;
  assign gpio_out_o = out;
  
  always @(posedge clk_sys_i or negedge rst_n_i)
    if(!rst_n_i)
      wb_ack_o <= 0;
    else if(wb_transaction)
      wb_ack_o <= 1;
    else
      wb_ack_o <= 0;
  
  always @(posedge clk_sys_i or negedge rst_n_i)
    if(!rst_n_i)
      wb_dat_o <= 0;
    else if(wb_read)
      case (wb_adr_i) 
        `ADDR_OEN  : wb_dat_o <= oen;
        `ADDR_READ : wb_dat_o <= gpio_in_i;
        `ADDR_SET  : wb_dat_o <= out;
        default    : wb_dat_o <= 0;
      endcase
  
  always @(posedge clk_sys_i or negedge rst_n_i)
    if(!rst_n_i)
      oen <= 8'h00;
    else if(wb_adr_i == `ADDR_OEN && wb_write)
      oen <= wb_dat_i[7:0];

  always @(posedge clk_sys_i or negedge rst_n_i)
    if(!rst_n_i)
      out <= 8'h00;
    else if(wb_adr_i == `ADDR_RESET && wb_write)
      out <= wb_dat_i[7:0];
    else if(wb_adr_i == `ADDR_SET && wb_write)
      out <= out | wb_dat_i[7:0];
endmodule