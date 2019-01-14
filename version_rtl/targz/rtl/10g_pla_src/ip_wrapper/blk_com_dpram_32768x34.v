`timescale 1ns/100ps
///`include "macro.v"

module blk_com_dpram_32768x34(
input           clka ,
input           ena  ,
input  [0 : 0]  wea  ,
input  [14 : 0] addra,
input  [33 : 0] dina ,
input           clkb ,
input           rstb ,
input           enb  ,
input  [14 : 0] addrb,

output [33 : 0] doutb
);

wire [33 : 0] S_doutb;

///`ifdef Xilinx_K7    ////blk_dpram_32768x34_k7_funcsim
blk_com_dpram_32768x34_k7 U0_blk_com_dpram_32768x34_k7(
.clka    (clka   ),
.ena     (ena    ),
.wea     (wea    ),
.addra   (addra  ),
.dina    (dina   ),
.clkb    (clkb   ),
.enb     (enb    ),
.rstb    (rstb   ),
.addrb   (addrb  ),
.doutb   (doutb  )
);
///`endif
///`ifdef Xilinx_S6
///dpram_32768x34_xilinx U0_xgmii_delay_dpram(
///.clka    (clka   ),
///.ena     (ena    ),
///.wea     (wea    ),
///.addra   (addra  ),
///.dina    (dina   ),
///.enb     (enb    ),
///.clkb    (clkb   ),
///.rstb    (rstb   ),
///.addrb   (addrb  ),
///.doutb   (doutb  )
///);


///`endif



endmodule