module pla_ptp_top
(
    input                 I_clk_312m                   , 
    input                 I_rst                        ,  
//ǰ��
//    input       [47:0]    I_tx_pla_dmac                ,
//    input       [47:0]    I_tx_pla_smac                ,
    input       [31:0]    I_tx_xgmii_data              ,       
    input       [3:0 ]    I_tx_xgmii_txc               ,       
    input       [1:0]     I_tx_xgmii_err               ,

    output      [31:0]    O_xgmii_tx_data              ,
    output      [3:0 ]    O_xgmii_tx_txc               ,
    output      [1:0]     O_xgmii_tx_err               ,

    output      [31:0]    O_xgmii_tx_ptp_data          ,
    output      [3:0 ]    O_xgmii_tx_ptp_txc           ,
    output                O_xgmii_tx_ptp_err           ,
    ///////////��ά�ɲⲿ�ֽӿ�//////////////////////
    input       [1:0]     I_pla_tc_bypass              ,                                            //ǰ������bypass
    input                 I_rd_cnt_clr                 ,    
    
    output      [31:0]    O_pkt_cnt_slice_in           ,
    output      [31:0]    O_ptp_cnt_in                 ,
    output      [31:0]    O_vlan_ptp_cnt_in            ,
    output      [31:0]    O_ptp_no_vlan_cnt_out        ,
    output      [31:0]    O_ptp_vlan_cnt_out           ,
    output      [31:0]    O_slice_cnt_out              ,
    output      [31:0]    O_packet_cnt_out             ,
    ///////////��ά�ɲⲿ�ֽӿ�end//////////////////////
//����
    input       [31:0]    I_rx_xgmii_data              ,   
    input       [3:0 ]    I_rx_xgmii_txc               ,   
    input                 I_rx_xgmii_err               ,   
    
    output      [31:0]    O_xgmii_rx_data              ,
    output      [3:0 ]    O_xgmii_rx_txc               ,
    output                O_xgmii_rx_err               ,

    input       [1:0]     I_subport_num                ,
    input       [47:0]    I_pla_slice_da0              ,
    input       [47:0]    I_pla_slice_da1              ,
    input       [47:0]    I_pla_slice_da2              ,
    input       [47:0]    I_pla_slice_sa00             ,
    input       [47:0]    I_pla_slice_sa01             ,
    input       [47:0]    I_pla_slice_sa02             ,
    input       [47:0]    I_pla_slice_sa03             ,
    input       [47:0]    I_pla_slice_sa04             ,
    input       [47:0]    I_pla_slice_sa05             ,
    input       [47:0]    I_pla_slice_sa06             ,
    input       [47:0]    I_pla_slice_sa07             ,
    input       [47:0]    I_pla_slice_sa10             ,
    input       [47:0]    I_pla_slice_sa11             ,
    input       [47:0]    I_pla_slice_sa12             ,
    input       [47:0]    I_pla_slice_sa13             ,
    input       [47:0]    I_pla_slice_sa14             ,
    input       [47:0]    I_pla_slice_sa15             ,
    input       [47:0]    I_pla_slice_sa16             ,
    input       [47:0]    I_pla_slice_sa17             ,
    input       [47:0]    I_pla_slice_sa20             ,
    input       [47:0]    I_pla_slice_sa21             ,
    input       [47:0]    I_pla_slice_sa22             ,
    input       [47:0]    I_pla_slice_sa23             ,
    input       [47:0]    I_pla_slice_sa24             ,
    input       [47:0]    I_pla_slice_sa25             ,
    input       [47:0]    I_pla_slice_sa26             ,
    input       [47:0]    I_pla_slice_sa27             ,
    
    input       [3:0]     I_clear_en                   ,
    input       [7:0]     I_clear_subport0_en          ,
    input       [7:0]     I_clear_subport1_en          ,
    input       [7:0]     I_clear_subport2_en          ,
    
    output      [6:0]     O_fifo_usedw                 ,
    output      [15:0]    O_1588_packet_in_num         ,         
    output      [15:0]    O_1588_packet_out_num        ,     
    output      [15:0]    O_all_packet_in_num          ,     
    output      [15:0]    O_all_packet_out_num         ,     
    output      [15:0]    O_pla_slice_sa00_cnt         ,     
    output      [15:0]    O_pla_slice_sa01_cnt         ,     
    output      [15:0]    O_pla_slice_sa02_cnt         ,     
    output      [15:0]    O_pla_slice_sa03_cnt         ,     
    output      [15:0]    O_pla_slice_sa04_cnt         ,     
    output      [15:0]    O_pla_slice_sa05_cnt         ,     
    output      [15:0]    O_pla_slice_sa06_cnt         ,     
    output      [15:0]    O_pla_slice_sa07_cnt         ,     
    output      [15:0]    O_pla_slice_sa10_cnt         ,     
    output      [15:0]    O_pla_slice_sa11_cnt         ,     
    output      [15:0]    O_pla_slice_sa12_cnt         ,     
    output      [15:0]    O_pla_slice_sa13_cnt         ,     
    output      [15:0]    O_pla_slice_sa14_cnt         ,     
    output      [15:0]    O_pla_slice_sa15_cnt         ,     
    output      [15:0]    O_pla_slice_sa16_cnt         ,     
    output      [15:0]    O_pla_slice_sa17_cnt         ,     
    output      [15:0]    O_pla_slice_sa20_cnt         ,     
    output      [15:0]    O_pla_slice_sa21_cnt         ,     
    output      [15:0]    O_pla_slice_sa22_cnt         ,         
    output      [15:0]    O_pla_slice_sa23_cnt         ,            
    output      [15:0]    O_pla_slice_sa24_cnt         ,            
    output      [15:0]    O_pla_slice_sa25_cnt         ,            
    output      [15:0]    O_pla_slice_sa26_cnt         ,            
    output      [15:0]    O_pla_slice_sa27_cnt         ,            
    output      [31:0]    O_state                                  
);
        
tx_pla_ptp_top U_tx_pla_ptp_top
(
  .I_clk_312m                   (I_clk_312m               ),
  .I_rst                        (I_rst                    ),
  .I_xgmii_data                 (I_tx_xgmii_data          ),
  .I_xgmii_txc                  (I_tx_xgmii_txc           ),
  .I_xgmii_err                  (I_tx_xgmii_err           ),
//  .I_pla_dmac                   (I_tx_pla_dmac            ),
//  .I_pla_smac                   (I_tx_pla_smac            ),  
  
  .I_pla_tc_bypass              (I_pla_tc_bypass[0]       ),
  .I_rd_cnt_clr                 (I_rd_cnt_clr             ),
  
  .O_pkt_cnt_slice_in           (O_pkt_cnt_slice_in       ),
  .O_ptp_cnt_in                 (O_ptp_cnt_in             ),
  .O_vlan_ptp_cnt_in            (O_vlan_ptp_cnt_in        ),
  .O_ptp_no_vlan_cnt_out        (O_ptp_no_vlan_cnt_out    ),
  .O_ptp_vlan_cnt_out           (O_ptp_vlan_cnt_out       ),
  .O_slice_cnt_out              (O_slice_cnt_out          ),
  .O_packet_cnt_out             (O_packet_cnt_out         ),
                                                          
  .O_xgmii_data                 (O_xgmii_tx_data          ),
  .O_xgmii_txc                  (O_xgmii_tx_txc           ),
  .O_xgmii_err                  (O_xgmii_tx_err           ),
                                                          
  .O_xgmii_ptp_data             (O_xgmii_tx_ptp_data      ),
  .O_xgmii_ptp_txc              (O_xgmii_tx_ptp_txc       ),
  .O_xgmii_ptp_err              (O_xgmii_tx_ptp_err       ) 
);   

pla_1588_packing_top U0_pla_1588_packing_top(
.I_sys_312m_clk                 (I_clk_312m             ),    // 
.I_fpga_reset                   (I_rst                  ),    //
.I_bypass_en                    (I_pla_tc_bypass[1]     ),    //

.I_subport_num                  (I_subport_num          ),    //
.I_pla_slice_da0                (I_pla_slice_da0        ),    //
.I_pla_slice_da1                (I_pla_slice_da1        ),    //
.I_pla_slice_da2                (I_pla_slice_da2        ),    //
.I_pla_slice_sa00               (I_pla_slice_sa00       ),    //
.I_pla_slice_sa01               (I_pla_slice_sa01       ),    //
.I_pla_slice_sa02               (I_pla_slice_sa02       ),    //
.I_pla_slice_sa03               (I_pla_slice_sa03       ),    //
.I_pla_slice_sa04               (I_pla_slice_sa04       ),    //
.I_pla_slice_sa05               (I_pla_slice_sa05       ),    //
.I_pla_slice_sa06               (I_pla_slice_sa06       ),    //
.I_pla_slice_sa07               (I_pla_slice_sa07       ),    //
.I_pla_slice_sa10               (I_pla_slice_sa10       ),    //
.I_pla_slice_sa11               (I_pla_slice_sa11       ),    //
.I_pla_slice_sa12               (I_pla_slice_sa12       ),    //
.I_pla_slice_sa13               (I_pla_slice_sa13       ),    //
.I_pla_slice_sa14               (I_pla_slice_sa14       ),    //
.I_pla_slice_sa15               (I_pla_slice_sa15       ),    //
.I_pla_slice_sa16               (I_pla_slice_sa16       ),    //
.I_pla_slice_sa17               (I_pla_slice_sa17       ),    //
.I_pla_slice_sa20               (I_pla_slice_sa20       ),    //
.I_pla_slice_sa21               (I_pla_slice_sa21       ),    //
.I_pla_slice_sa22               (I_pla_slice_sa22       ),    //
.I_pla_slice_sa23               (I_pla_slice_sa23       ),    //
.I_pla_slice_sa24               (I_pla_slice_sa24       ),    //
.I_pla_slice_sa25               (I_pla_slice_sa25       ),    //
.I_pla_slice_sa26               (I_pla_slice_sa26       ),    //
.I_pla_slice_sa27               (I_pla_slice_sa27       ),    //
    
.I_clear_en                     (I_clear_en             ),    //
.I_clear_subport0_en            (I_clear_subport0_en    ),    //
.I_clear_subport1_en            (I_clear_subport1_en    ),    //
.I_clear_subport2_en            (I_clear_subport2_en    ),    //

.I_gmii_txc                     (I_rx_xgmii_txc         ),    //
.I_gmii_data                    (I_rx_xgmii_data        ),    //
        
.O_gmii_txc                     (O_xgmii_rx_txc         ),    //
.O_gmii_data                    (O_xgmii_rx_data        ),    //

.O_fifo_usedw                   (O_fifo_usedw           ),    //
.O_1588_packet_in_num           (O_1588_packet_in_num   ),    //
.O_1588_packet_out_num          (O_1588_packet_out_num  ),    //
.O_all_packet_in_num            (O_all_packet_in_num    ),    //
.O_all_packet_out_num           (O_all_packet_out_num   ),    //
.O_pla_slice_sa00_cnt           (O_pla_slice_sa00_cnt   ),    //
.O_pla_slice_sa01_cnt           (O_pla_slice_sa01_cnt   ),    //
.O_pla_slice_sa02_cnt           (O_pla_slice_sa02_cnt   ),    //
.O_pla_slice_sa03_cnt           (O_pla_slice_sa03_cnt   ),    //
.O_pla_slice_sa04_cnt           (O_pla_slice_sa04_cnt   ),    //
.O_pla_slice_sa05_cnt           (O_pla_slice_sa05_cnt   ),    //
.O_pla_slice_sa06_cnt           (O_pla_slice_sa06_cnt   ),    //
.O_pla_slice_sa07_cnt           (O_pla_slice_sa07_cnt   ),    //
.O_pla_slice_sa10_cnt           (O_pla_slice_sa10_cnt   ),    //
.O_pla_slice_sa11_cnt           (O_pla_slice_sa11_cnt   ),    //
.O_pla_slice_sa12_cnt           (O_pla_slice_sa12_cnt   ),    //
.O_pla_slice_sa13_cnt           (O_pla_slice_sa13_cnt   ),    //
.O_pla_slice_sa14_cnt           (O_pla_slice_sa14_cnt   ),    //
.O_pla_slice_sa15_cnt           (O_pla_slice_sa15_cnt   ),    //
.O_pla_slice_sa16_cnt           (O_pla_slice_sa16_cnt   ),    //
.O_pla_slice_sa17_cnt           (O_pla_slice_sa17_cnt   ),    //
.O_pla_slice_sa20_cnt           (O_pla_slice_sa20_cnt   ),    //
.O_pla_slice_sa21_cnt           (O_pla_slice_sa21_cnt   ),    //
.O_pla_slice_sa22_cnt           (O_pla_slice_sa22_cnt   ),    //
.O_pla_slice_sa23_cnt           (O_pla_slice_sa23_cnt   ),    //
.O_pla_slice_sa24_cnt           (O_pla_slice_sa24_cnt   ),    //
.O_pla_slice_sa25_cnt           (O_pla_slice_sa25_cnt   ),    //
.O_pla_slice_sa26_cnt           (O_pla_slice_sa26_cnt   ),    //
.O_pla_slice_sa27_cnt           (O_pla_slice_sa27_cnt   ),    //
.O_state                        (O_state                )
);
endmodule  