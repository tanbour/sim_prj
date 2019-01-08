module xgmii_crc_compare_h16bit
(
 input            I_global_rst    	    ,  
 input            I_312m_clk	          ,
 input  [31:0]    I_xgmii_data          ,   
 input  [3:0]     I_xgmii_txc           ,
 input            I_ptp_flag            ,
 output           O_crc_err             ,
 output           O_crc_ok              ,
 output           O_crc_compare_signal  ,
 output [31:0]    O_crc_out                  
        
);

wire [31:0]    S_crc_data_out ; 
crc32_top   u1_crc32_top
(
    .I_rst    	           (   I_global_rst      ),  ///复位信号，高有效                  
    .I_sys_clk	           (   I_312m_clk        ),  ///系统时钟                         
    .I_crc_data	           (   I_xgmii_data      ),  ///Gmii数据              
    .I_xgmii_ctl	         (   I_xgmii_txc       ),  ///EGMII数据奇偶标识  
    .O_crc_out             (   S_crc_data_out    )   ///  
); 

xgmii_crc_compare_16 xgmii_no_comp_crc_compare_16
(
    .I_rst    	           (   I_global_rst          ),  ///复位信号，高有效                  
    .I_312m_clk	           (   I_312m_clk            ),  ///系统时钟 
    .I_xgmii_txc           (   I_xgmii_txc           ),
    .I_xgmii_data          (   I_xgmii_data          ),
    .I_crc_data_out        (   S_crc_data_out        ),
    .I_ptp_flag            (   I_ptp_flag            ),
    .O_crc_compare_signal  (   O_crc_compare_signal  ),
    .O_crc_wrong           (   O_crc_err             ),   ///
    .O_crc_ok              (   O_crc_ok              ),
    .O_crc_out             (   O_crc_out             )               
);


endmodule
