`timescale 1ns/100ps
//`include "macro.v"
module fifo_128_36(
input         aclr   ,
input         clock  ,
input [35:0]  data   ,
input         rdreq  ,
input         wrreq  ,
output[35:0]  q      ,
output[6:0]   usedw
);

//`ifdef Xilinx_k7
blk_fifo_128_36_k7 U0_blk_fifo_128_36_k7(
  .clk        (clock),      
  .srst       (aclr ),     
  .din        (data ),      
  .wr_en      (wrreq),    
  .rd_en      (rdreq),    
  .dout       (q    ),     
  .full       (     ),     
  .empty      (     ),    
  .data_count (usedw)
);
//`endif

endmodule