//FILE_HEADER-------------------------------------------------------
//ZTE Copyright(C)
// ZTE Company Confidential
//------------------------------------------------------------------
// Project Name : ZXLTE xxxx
// FILE NAME    : pla_1588_packing_top.v
// AUTHOR       : sun.lijun
// Department   : ZTE-BBU System Department
// Email        : sun.lijun9@zte.com.cn
//------------------------------------------------------------------
// Module Hiberarchy:
//x pla_1588_depacking----- 
//-----------------------------------------------------------------
// Release History:
//-----------------------------------------------------------------
// Version      Date      Author        Description
// 1.0        5-25-2015   sun.lijun   initial version
// 1.1        mm-dd-yyyy   Author       修改、增减的主要内容描述
//-----------------------------------------------------------------
//Main Function:
// a)calc cf, add Tin.
//-----------------------------------------------------------------
//REUSE ISSUES: xxxxxxxx          
//Reset Strategy: synchronous reset
//Clock Strategy: xxxxxxxx
//Critical Timing: xxxxxxxx
//Asynchronous Interface: xxxxxxxx
//END_HEADER--------------------------------------------------------
`timescale 1ns / 100ps
module pla_1588_packing_top(
input          I_sys_312m_clk                 ,    // 
input          I_fpga_reset                   ,    //
input          I_bypass_en                    ,    //

input [1:0]    I_subport_num                  ,    //
input [47:0]   I_pla_slice_da0                ,    //
input [47:0]   I_pla_slice_da1                ,    //
input [47:0]   I_pla_slice_da2                ,    //
input [47:0]   I_pla_slice_sa00               ,    //
input [47:0]   I_pla_slice_sa01               ,    //
input [47:0]   I_pla_slice_sa02               ,    //
input [47:0]   I_pla_slice_sa03               ,    //
input [47:0]   I_pla_slice_sa04               ,    //
input [47:0]   I_pla_slice_sa05               ,    //
input [47:0]   I_pla_slice_sa06               ,    //
input [47:0]   I_pla_slice_sa07               ,    //
input [47:0]   I_pla_slice_sa10               ,    //
input [47:0]   I_pla_slice_sa11               ,    //
input [47:0]   I_pla_slice_sa12               ,    //
input [47:0]   I_pla_slice_sa13               ,    //
input [47:0]   I_pla_slice_sa14               ,    //
input [47:0]   I_pla_slice_sa15               ,    //
input [47:0]   I_pla_slice_sa16               ,    //
input [47:0]   I_pla_slice_sa17               ,    //
input [47:0]   I_pla_slice_sa20               ,    //
input [47:0]   I_pla_slice_sa21               ,    //
input [47:0]   I_pla_slice_sa22               ,    //
input [47:0]   I_pla_slice_sa23               ,    //
input [47:0]   I_pla_slice_sa24               ,    //
input [47:0]   I_pla_slice_sa25               ,    //
input [47:0]   I_pla_slice_sa26               ,    //
input [47:0]   I_pla_slice_sa27               ,    //

input [3:0]    I_clear_en                     ,    //
input [7:0]    I_clear_subport0_en            ,    //
input [7:0]    I_clear_subport1_en            ,    //
input [7:0]    I_clear_subport2_en            ,    //

input [3:0]    I_gmii_txc                     ,    //
input [31:0]   I_gmii_data                    ,    //

output[3:0]    O_gmii_txc                     ,    //
output[31:0]   O_gmii_data                    ,    //

output[6:0]    O_fifo_usedw                   ,    //
output[15:0]   O_1588_packet_in_num           ,    //
output[15:0]   O_1588_packet_out_num          ,    //
output[15:0]   O_all_packet_in_num            ,    //
output[15:0]   O_all_packet_out_num           ,    //
output[15:0]   O_pla_slice_sa00_cnt           ,    //
output[15:0]   O_pla_slice_sa01_cnt           ,    //
output[15:0]   O_pla_slice_sa02_cnt           ,    //
output[15:0]   O_pla_slice_sa03_cnt           ,    //
output[15:0]   O_pla_slice_sa04_cnt           ,    //
output[15:0]   O_pla_slice_sa05_cnt           ,    //
output[15:0]   O_pla_slice_sa06_cnt           ,    //
output[15:0]   O_pla_slice_sa07_cnt           ,    //
output[15:0]   O_pla_slice_sa10_cnt           ,    //
output[15:0]   O_pla_slice_sa11_cnt           ,    //
output[15:0]   O_pla_slice_sa12_cnt           ,    //
output[15:0]   O_pla_slice_sa13_cnt           ,    //
output[15:0]   O_pla_slice_sa14_cnt           ,    //
output[15:0]   O_pla_slice_sa15_cnt           ,    //
output[15:0]   O_pla_slice_sa16_cnt           ,    //
output[15:0]   O_pla_slice_sa17_cnt           ,    //
output[15:0]   O_pla_slice_sa20_cnt           ,    //
output[15:0]   O_pla_slice_sa21_cnt           ,    //
output[15:0]   O_pla_slice_sa22_cnt           ,    //
output[15:0]   O_pla_slice_sa23_cnt           ,    //
output[15:0]   O_pla_slice_sa24_cnt           ,    //
output[15:0]   O_pla_slice_sa25_cnt           ,    //
output[15:0]   O_pla_slice_sa26_cnt           ,    //
output[15:0]   O_pla_slice_sa27_cnt           ,    //
output[31:0]   O_state                        
);

wire[15:0]     S_pla_vlan_id        ;
wire           S_pla_vlan_ind       ;
wire[47:0]     S_pla_slice_da       ;
wire[47:0]     S_pla_slice_sa       ;

wire[3:0]      S_pla_packing_txc    ;
wire[31:0]     S_pla_packing_data   ;

pla_1588_packing U0_pla_1588_packing(
.I_sys_312m_clk                 (I_sys_312m_clk           ),    // 
.I_fpga_reset                   (I_fpga_reset             ),    //
.I_gmii_txc                     (I_gmii_txc               ),    //
.I_gmii_data                    (I_gmii_data              ),    //
.I_pla_slice_da                 (S_pla_slice_da           ),    //
.I_pla_slice_sa                 (S_pla_slice_sa           ),    //

.I_1588_packet_in_num_clr       (I_clear_en[0]            ),    //
.I_1588_packet_out_num_clr      (I_clear_en[1]            ),    //
.I_all_packet_in_num_clr        (I_clear_en[2]            ),    //
.I_all_packet_out_num_clr       (I_clear_en[3]            ),    //

.O_gmii_txc                     (S_pla_packing_txc        ),    //
.O_gmii_data                    (S_pla_packing_data       ),    //
.O_pla_vlan_id                  (S_pla_vlan_id            ),    //
.O_pla_vlan_ind                 (S_pla_vlan_ind           ),    //
.O_fifo_usedw                   (O_fifo_usedw             ),    //
.O_1588_packet_in_num           (O_1588_packet_in_num     ),    //
.O_1588_packet_out_num          (O_1588_packet_out_num    ),    //
.O_all_packet_in_num            (O_all_packet_in_num      ),    //
.O_all_packet_out_num           (O_all_packet_out_num     ),    //
.O_state                        (O_state                  )
);

pla_1588_packing_mac_intp U0_pla_1588_packing_mac_intp(
.I_sys_312m_clk                 (I_sys_312m_clk           ),    // 
.I_fpga_reset                   (I_fpga_reset             ),    //
                                                          
.I_subport_num                  (I_subport_num            ),    //
.I_pla_vlan_id                  (S_pla_vlan_id            ),    //
.I_pla_vlan_ind                 (S_pla_vlan_ind           ),    //
.I_pla_slice_da0                (I_pla_slice_da0          ),    //
.I_pla_slice_da1                (I_pla_slice_da1          ),    //
.I_pla_slice_da2                (I_pla_slice_da2          ),    //
.I_pla_slice_sa00               (I_pla_slice_sa00         ),    //
.I_pla_slice_sa01               (I_pla_slice_sa01         ),    //
.I_pla_slice_sa02               (I_pla_slice_sa02         ),    //
.I_pla_slice_sa03               (I_pla_slice_sa03         ),    //
.I_pla_slice_sa04               (I_pla_slice_sa04         ),    //
.I_pla_slice_sa05               (I_pla_slice_sa05         ),    //
.I_pla_slice_sa06               (I_pla_slice_sa06         ),    //
.I_pla_slice_sa07               (I_pla_slice_sa07         ),    //
.I_pla_slice_sa10               (I_pla_slice_sa10         ),    //
.I_pla_slice_sa11               (I_pla_slice_sa11         ),    //
.I_pla_slice_sa12               (I_pla_slice_sa12         ),    //
.I_pla_slice_sa13               (I_pla_slice_sa13         ),    //
.I_pla_slice_sa14               (I_pla_slice_sa14         ),    //
.I_pla_slice_sa15               (I_pla_slice_sa15         ),    //
.I_pla_slice_sa16               (I_pla_slice_sa16         ),    //
.I_pla_slice_sa17               (I_pla_slice_sa17         ),    //
.I_pla_slice_sa20               (I_pla_slice_sa20         ),    //
.I_pla_slice_sa21               (I_pla_slice_sa21         ),    //
.I_pla_slice_sa22               (I_pla_slice_sa22         ),    //
.I_pla_slice_sa23               (I_pla_slice_sa23         ),    //
.I_pla_slice_sa24               (I_pla_slice_sa24         ),    //
.I_pla_slice_sa25               (I_pla_slice_sa25         ),    //
.I_pla_slice_sa26               (I_pla_slice_sa26         ),    //
.I_pla_slice_sa27               (I_pla_slice_sa27         ),    //

.I_pla_slice_sa00_cnt_clr       (I_clear_subport0_en[0]   ),    //
.I_pla_slice_sa01_cnt_clr       (I_clear_subport0_en[1]   ),    //
.I_pla_slice_sa02_cnt_clr       (I_clear_subport0_en[2]   ),    //
.I_pla_slice_sa03_cnt_clr       (I_clear_subport0_en[3]   ),    //
.I_pla_slice_sa04_cnt_clr       (I_clear_subport0_en[4]   ),    //
.I_pla_slice_sa05_cnt_clr       (I_clear_subport0_en[5]   ),    //
.I_pla_slice_sa06_cnt_clr       (I_clear_subport0_en[6]   ),    //
.I_pla_slice_sa07_cnt_clr       (I_clear_subport0_en[7]   ),    //
.I_pla_slice_sa10_cnt_clr       (I_clear_subport1_en[0]   ),    //
.I_pla_slice_sa11_cnt_clr       (I_clear_subport1_en[1]   ),    //
.I_pla_slice_sa12_cnt_clr       (I_clear_subport1_en[2]   ),    //
.I_pla_slice_sa13_cnt_clr       (I_clear_subport1_en[3]   ),    //
.I_pla_slice_sa14_cnt_clr       (I_clear_subport1_en[4]   ),    //
.I_pla_slice_sa15_cnt_clr       (I_clear_subport1_en[5]   ),    //
.I_pla_slice_sa16_cnt_clr       (I_clear_subport1_en[6]   ),    //
.I_pla_slice_sa17_cnt_clr       (I_clear_subport1_en[7]   ),    //
.I_pla_slice_sa20_cnt_clr       (I_clear_subport2_en[0]   ),    //
.I_pla_slice_sa21_cnt_clr       (I_clear_subport2_en[1]   ),    //
.I_pla_slice_sa22_cnt_clr       (I_clear_subport2_en[2]   ),    //
.I_pla_slice_sa23_cnt_clr       (I_clear_subport2_en[3]   ),    //
.I_pla_slice_sa24_cnt_clr       (I_clear_subport2_en[4]   ),    //
.I_pla_slice_sa25_cnt_clr       (I_clear_subport2_en[5]   ),    //
.I_pla_slice_sa26_cnt_clr       (I_clear_subport2_en[6]   ),    //
.I_pla_slice_sa27_cnt_clr       (I_clear_subport2_en[7]   ),    //

.O_pla_slice_da                 (S_pla_slice_da           ),    //
.O_pla_slice_sa                 (S_pla_slice_sa           ),    //

.O_pla_slice_sa00_cnt           (O_pla_slice_sa00_cnt     ),   //
.O_pla_slice_sa01_cnt           (O_pla_slice_sa01_cnt     ),   //
.O_pla_slice_sa02_cnt           (O_pla_slice_sa02_cnt     ),   //
.O_pla_slice_sa03_cnt           (O_pla_slice_sa03_cnt     ),   //
.O_pla_slice_sa04_cnt           (O_pla_slice_sa04_cnt     ),   //
.O_pla_slice_sa05_cnt           (O_pla_slice_sa05_cnt     ),   //
.O_pla_slice_sa06_cnt           (O_pla_slice_sa06_cnt     ),   //
.O_pla_slice_sa07_cnt           (O_pla_slice_sa07_cnt     ),   //
.O_pla_slice_sa10_cnt           (O_pla_slice_sa10_cnt     ),   //
.O_pla_slice_sa11_cnt           (O_pla_slice_sa11_cnt     ),   //
.O_pla_slice_sa12_cnt           (O_pla_slice_sa12_cnt     ),   //
.O_pla_slice_sa13_cnt           (O_pla_slice_sa13_cnt     ),   //
.O_pla_slice_sa14_cnt           (O_pla_slice_sa14_cnt     ),   //
.O_pla_slice_sa15_cnt           (O_pla_slice_sa15_cnt     ),   //
.O_pla_slice_sa16_cnt           (O_pla_slice_sa16_cnt     ),   //
.O_pla_slice_sa17_cnt           (O_pla_slice_sa17_cnt     ),   //
.O_pla_slice_sa20_cnt           (O_pla_slice_sa20_cnt     ),   //
.O_pla_slice_sa21_cnt           (O_pla_slice_sa21_cnt     ),   //
.O_pla_slice_sa22_cnt           (O_pla_slice_sa22_cnt     ),   //
.O_pla_slice_sa23_cnt           (O_pla_slice_sa23_cnt     ),   //
.O_pla_slice_sa24_cnt           (O_pla_slice_sa24_cnt     ),   //
.O_pla_slice_sa25_cnt           (O_pla_slice_sa25_cnt     ),   //
.O_pla_slice_sa26_cnt           (O_pla_slice_sa26_cnt     ),   //
.O_pla_slice_sa27_cnt           (O_pla_slice_sa27_cnt     )
);

pla_1588_packing_loop U0_pla_1588_packing_loop(
.I_sys_312m_clk                 (I_sys_312m_clk      ),    // 
.I_fpga_reset                   (I_fpga_reset        ),    //
.I_bypass_en                    (I_bypass_en         ),    //
.I_gmii_txc                     (I_gmii_txc          ),    //
.I_gmii_data                    (I_gmii_data         ),    //
.I_pla_packing_txc              (S_pla_packing_txc   ),    //
.I_pla_packing_data             (S_pla_packing_data  ),    //
.O_gmii_txc                     (O_gmii_txc          ),    //
.O_gmii_data                    (O_gmii_data         )     //
);
endmodule