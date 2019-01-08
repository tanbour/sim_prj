`timescale 1ns/100ps
`define Xilinx_K7
module blk_com_fifo_1024x36(
input          I_fifo_clk   ,
input          I_fifo_rst   ,
input   [35:0] I_fifo_din   ,
input          I_fifo_wr    ,
input          I_fifo_rd    ,
output         O_fifo_empty ,
output         O_fifo_full  ,
output  [35:0] O_fifo_dout  ,
output  [10:0] O_fifo_usedw
);

wire  [9:0]    S_fifo_usedw;

`ifdef Xilinx_K7
blk_com_fifo_1024x36_k7 U_blk_com_fifo_1024x36_k7(
.clk           (I_fifo_clk    ),
.srst          (I_fifo_rst    ),
.din           (I_fifo_din    ),
.wr_en         (I_fifo_wr     ),
.rd_en         (I_fifo_rd     ),
.dout          (O_fifo_dout   ),
.full          (O_fifo_full   ),
.empty         (O_fifo_empty  ),
.data_count    (S_fifo_usedw  )
);

assign O_fifo_usedw = {O_fifo_full,S_fifo_usedw};
`endif

endmodule