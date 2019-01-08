module crc_no_comp_compare
(
 input            I_global_rst    	    ,  
 input            I_312m_clk	          ,
 input  [31:0]    I_xgmii_data          ,   
 input  [3:0]     I_xgmii_txc           ,
 output           O_crc_err             ,
 output           O_crc_ok              ,
 output           O_crc_compare_signal                    
        
);

wire [31:0]    S_crc_data_out ; 
crc32_top   u1_crc32_top
(
    .I_rst    	           (   I_global_rst      ),  ///��λ�źţ�����Ч                  
    .I_sys_clk	           (   I_312m_clk        ),  ///ϵͳʱ��                         
    .I_crc_data	           (   I_xgmii_data      ),  ///Gmii����              
    .I_xgmii_ctl	         (   I_xgmii_txc       ),  ///EGMII������ż��ʶ  
    .O_crc_out             (   S_crc_data_out    )   ///  
); 

xgmii_crc_compare xgmii_no_comp_crc_compare
(
    .I_rst    	           (   I_global_rst          ),  ///��λ�źţ�����Ч                  
    .I_312m_clk	           (   I_312m_clk            ),  ///ϵͳʱ�� 
    .I_xgmii_txc           (   I_xgmii_txc           ),
    .I_xgmii_data          (   I_xgmii_data          ),
    .I_group_cnt           (   I_group_cnt           ),                
    .I_crc_data_out        (   S_crc_data_out        ),
    .O_crc_compare_signal  (   O_crc_compare_signal  ),
    .O_crc_wrong           (   O_crc_err             ),   ///
    .O_crc_ok              (   O_crc_ok              )               
);


endmodule