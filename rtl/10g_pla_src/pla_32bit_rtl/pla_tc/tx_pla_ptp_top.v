module tx_pla_ptp_top
    (
    input                 I_clk_312m                   ,
    input                 I_rst                        ,
    input       [31:0]    I_xgmii_data                 ,
    input       [3:0]     I_xgmii_txc                  ,
    input       [1:0]     I_xgmii_err                  ,
//    input       [47:0]    I_ptp_dmac                   ,
//    input       [47:0]    I_pla_smac                   ,  
                                                       
    ///////////可维可测部分接口//////////////////////
    input                 I_pla_tc_bypass              ,
    input                 I_rd_cnt_clr                 ,
    
    output      [31:0]    O_pkt_cnt_slice_in           ,
    output      [31:0]    O_ptp_cnt_in                 ,
    output      [31:0]    O_vlan_ptp_cnt_in            ,
    output      [31:0]    O_ptp_no_vlan_cnt_out        ,
    output      [31:0]    O_ptp_vlan_cnt_out           ,
    output      [31:0]    O_slice_cnt_out              ,
    output      [31:0]    O_packet_cnt_out             ,
    ///////////可维可测部分接口end//////////////////////
        
    output reg  [31:0]    O_xgmii_data = 32'h 07070707 ,
    output reg  [3:0 ]    O_xgmii_txc = 4'b1111        ,
    output reg  [1:0]     O_xgmii_err = 2'b0           ,
    
    output      [31:0]   O_xgmii_ptp_data              ,
    output      [3:0 ]   O_xgmii_ptp_txc               ,
    output      [1:0]    O_xgmii_ptp_err               
  
    );
   
    wire                 S_ptp_vlan_flag               ;
    wire        [31:0]   S_xgmii_data                  ;
    wire        [3:0]    S_xgmii_txc                   ;
    wire        [1:0]    S_xgmii_err                   ;
    wire        [15:0]   S_ptp_length                  ;
    wire                 S_ptp_pac_flag                ;
    wire        [15:0]   S_ptp_slice_id                ;
    wire        [31:0]   S_vlan_type                   ;
    wire        [3:0 ]   S_state_current               ;
    wire        [31:0]   S_xgmii_data_out              ;
    wire        [3:0 ]   S_xgmii_txc_out               ;
    wire        [1:0]    S_xgmii_err_out               ;
    
tx_pla_ptp_check tx_tx_pla_ptp_check
    (
    .I_clk_312m             (I_clk_312m                 ),      
    .I_rst                  (I_rst                      ),
    .I_xgmii_data           (I_xgmii_data               ),
    .I_xgmii_txc            (I_xgmii_txc                ),
    .I_xgmii_err            (I_xgmii_err                ),
    .I_ptp_dmac             (48'h011b19000000           ),
//    .I_pla_smac             (I_pla_smac                 ),
    .I_rd_cnt_clr           (I_rd_cnt_clr               ),
    .O_pkt_cnt_slice_in     (O_pkt_cnt_slice_in         ),
    .O_ptp_pack_flag        (S_ptp_pac_flag             ),
    .O_xgmii_data           (S_xgmii_data               ),
    .O_xgmii_txc            (S_xgmii_txc                ),
    .O_xgmii_err            (S_xgmii_err                ),
    .O_ptp_length           (S_ptp_length               ),
    .O_ptp_vlan_flag        (S_ptp_vlan_flag            ), 
    .O_slice_id             (S_ptp_slice_id             ),
    .O_vlan_type            (S_vlan_type                ),
    .O_state_current        (S_state_current            )
    );    

tx_pla_ptp_pack tx_tx_pla_ptp_pack
(

    .I_rst                     (I_rst                    ),
    .I_clk_312m                (I_clk_312m               ),
    .I_xgmii_data              (S_xgmii_data             ),    
    .I_xgmii_txc               (S_xgmii_txc              ),    
    .I_xgmii_err               (S_xgmii_err              ),    
    .I_state_current           (S_state_current          ),    
    .I_slice_id                (S_ptp_slice_id           ),
    .I_vlan_type               (S_vlan_type              ),
    .I_ptp_length              (S_ptp_length             ),
    .I_ptp_pack_flag           (S_ptp_pac_flag           ),
    .I_ptp_vlan_flag           (S_ptp_vlan_flag          ),
    .I_rd_cnt_clr              (I_rd_cnt_clr             ),
    .O_ptp_cnt_in              (O_ptp_cnt_in             ),
    .O_vlan_ptp_cnt_in         (O_vlan_ptp_cnt_in        ),
    .O_ptp_no_vlan_cnt_out     (O_ptp_no_vlan_cnt_out    ),
    .O_ptp_vlan_cnt_out        (O_ptp_vlan_cnt_out       ),
    .O_slice_cnt_out           (O_slice_cnt_out          ),
    .O_packet_cnt_out          (O_packet_cnt_out         ),
                      
    .O_xgmii_data              (S_xgmii_data_out         ),      
    .O_xgmii_txc               (S_xgmii_txc_out          ),
    .O_xgmii_err               (S_xgmii_err_out          ), 
                               
    .O_xgmii_ptp_data          (O_xgmii_ptp_data         ),
    .O_xgmii_ptp_txc           (O_xgmii_ptp_txc          ),
    .O_xgmii_ptp_err           (O_xgmii_ptp_err          )
   
);    
    
always @ (posedge I_clk_312m)
begin
	if(I_pla_tc_bypass)
		begin
      O_xgmii_data <= I_xgmii_data ;
      O_xgmii_txc  <= I_xgmii_txc  ;    
      O_xgmii_err  <= I_xgmii_err  ;
		end
	else
		begin
      O_xgmii_data <= S_xgmii_data_out ;
      O_xgmii_txc  <= S_xgmii_txc_out  ;   
      O_xgmii_err  <= S_xgmii_err_out  ;
		end
end
    
endmodule