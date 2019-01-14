`timescale 1ns/100ps
///`include "macro.v"

module blk_com_dpram_2560x38(
input           clka  ,
input           ena   ,
input  [0 : 0]  wea   ,
input  [11 : 0] addra ,
input  [37 : 0] dina  ,
input           clkb  ,
input           rstb  ,
input  [11 : 0] addrb ,
output [37 : 0] doutb
);

wire [37 : 0] S_doutb;


//`ifdef Xilinx_K7  ///blk_dpram_2560x38_k7_funcsim
blk_com_dpram_2560x38_k7 U0_blk_dpram_2560x38_k7(
.clka    (clka   ),
.ena     (ena    ),
.wea     (wea    ),
.addra   (addra  ),
.dina    (dina   ),
.rstb    (rstb   ),
.clkb    (clkb   ),
.addrb   (addrb  ),
.doutb   (doutb  )
);
/// `endif
/// `ifdef Xilinx_S6
/// dpram_2560x38_xilinx U0_xgmii_delay_dpram(
/// .clka    (clka   ),
/// .ena     (ena    ),
/// .wea     (wea    ),
/// .addra   (addra  ),
/// .dina    (dina   ),
/// .clkb    (clkb   ),
/// .rstb    (rstb   ),
/// .addrb   (addrb  ),
/// .doutb   (doutb  )
///);
///`endif



endmodule