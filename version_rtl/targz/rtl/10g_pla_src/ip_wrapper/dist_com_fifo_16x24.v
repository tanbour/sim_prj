`timescale 1ns/100ps
//`include "macro.v"

module dist_com_fifo_16x24(
input           clk  ,
input           rst  ,
input [23 : 0]  din  ,
input           wr_en,
input           rd_en,
output [23 : 0] dout ,
output          full ,
output          empty,
output [3 : 0]  data_count
);

wire [23 : 0] S_dout       ;
wire          S_full       ;
wire          S_empty      ;
wire [3 : 0]  S_data_count ;

//`ifdef Xilinx_K7      ////dist_fifo_16x24_k7_funcsim
dist_com_fifo_16x24_k7 U0_dist_com_fifo_16x24_k7(
  .clk        (clk      ),      
  .srst       (rst      ),     
  .din        (din      ),      
  .wr_en      (wr_en    ),    
  .rd_en      (rd_en    ),    
  .dout       (dout     ),     
  .full       (full     ),     
  .empty      (empty    ),    
  .data_count (data_count)
);
//`endif



endmodule