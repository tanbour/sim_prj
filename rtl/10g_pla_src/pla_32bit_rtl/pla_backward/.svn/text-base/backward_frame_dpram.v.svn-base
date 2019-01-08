`timescale 1ns/100ps
module backward_frame_dpram
(
input          I_porta_clk  ,
input  [11:0]  I_porta_addr ,
input  [31:0]  I_porta_din  ,
input          I_porta_wr   ,
input          I_portb_clk  ,
input  [11:0]  I_portb_addr ,
output [31:0]  O_portb_dout
);


sdpram_4096x32_xilinx U_sdpram_4096x32_xilinx(
.clka    (I_porta_clk    ),
.wea     (I_porta_wr     ),
.addra   (I_porta_addr   ),
.dina    (I_porta_din    ),
.clkb    (I_portb_clk    ),
.addrb   (I_portb_addr   ),
.doutb   (O_portb_dout   )
);

endmodule