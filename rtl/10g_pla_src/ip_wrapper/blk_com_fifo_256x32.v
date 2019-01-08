`timescale 1ns/100ps
///`include "macro.v"

module blk_com_fifo_256x32(
input           clk    ,
input           rst    ,
input  [31 : 0] din    ,
input           wr_en  ,
input           rd_en  ,

output [31 : 0] dout   ,
output          full   ,
output          empty  ,
output [7 : 0]  data_count
);

wire [31 : 0] S_dout       ;
wire          S_full       ;
wire          S_empty      ;
wire [7 : 0]  S_data_count ;

///`ifdef Xilinx_K7  ///blk_fifo_256x32_k7_funcsim
blk_com_fifo_256x32_k7 U0_blk_com_fifo_256x32_k7(
  .clk        (clk      ),      
  .rst       (rst      ),     
  .din        (din      ),      
  .wr_en      (wr_en    ),    
  .rd_en      (rd_en    ),    
  .dout       (dout     ),     
  .full       (full     ),     
  .empty      (empty    ),    
  .data_count (data_count)
);
///`endif
///`ifdef Xilinx_S6
///fifo_256x32_xilinx U0_fifo_256x32_xilinx(
///  .clk        (clk      ),      
///  .rst        (rst      ),     
///  .din        (din      ),      
///  .wr_en      (wr_en    ),    
///  .rd_en      (rd_en    ),    
///  .dout       (dout      ),      ///(S_dout      ),  
///  .full       (full      ),      ///(S_full      ),  
///  .empty      (empty     ),      ///(S_empty     ),  
///  .data_count (data_count)       ///(S_data_count)   
///);
///`endif

endmodule