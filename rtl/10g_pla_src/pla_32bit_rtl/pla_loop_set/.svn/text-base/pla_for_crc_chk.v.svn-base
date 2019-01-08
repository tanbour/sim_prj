module pla_for_crc_chk
(
 input                I_pla_rst       ,  
 input                I_pla_312m5_clk	    ,
 input  [31:0]        I_xgmii_data    ,   
 input  [3:0]         I_xgmii_txc     ,
 input                I_cnt_clear     ,
 output               O_crc_err_reg   ,
 output reg [15:0]    O_crc_err_cnt   ,      
 output reg [15:0]    O_crc_ok_cnt               
);

wire [31:0]    S_crc_data_out ; 
reg  [7:0]     S_f8_cnt       ;


crc32_top   u1_crc32_top
(
    .I_rst    	           (   I_pla_rst      ),  ///复位信号，高有效                  
    .I_sys_clk	           (   I_pla_312m5_clk   ),  ///系统时钟                         
    .I_crc_data	           (   I_xgmii_data      ),  ///Gmii数据              
    .I_xgmii_ctl	         (   I_xgmii_txc       ),  ///EGMII数据奇偶标识  
    .O_crc_out             (   S_crc_data_out    )   ///  
); 

xgmii_crc_compare xgmii_no_comp_crc_compare
(
    .I_rst    	           (   I_pla_rst          ),  ///复位信号，高有效                  
    .I_312m_clk	           (   I_pla_312m5_clk       ),  ///系统时钟 
    .I_xgmii_txc           (   I_xgmii_txc           ),
    .I_xgmii_data          (   I_xgmii_data          ),
    .I_group_cnt           (   5'd0                  ),                
    .I_crc_data_out        (   S_crc_data_out        ),
    .O_crc_compare_signal  (                         ),
    .O_crc_wrong           (   O_crc_err_reg         ),   ///
    .O_crc_ok              (   S_crc_ok              )               
);



always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
    begin
        O_crc_err_cnt[7:0] <= 8'd0;
    end    
    else if(I_cnt_clear)
    begin
        O_crc_err_cnt[7:0] <= 8'h0 ;
    end
    else if(O_crc_err_reg)
    begin
        O_crc_err_cnt[7:0] <= O_crc_err_cnt[7:0] + 8'd1 ;
    end
end



always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
    begin
        O_crc_ok_cnt <= 16'd0;
    end 
    else if(I_cnt_clear)
    begin
        O_crc_ok_cnt <= 16'h0 ;
    end
    else if(S_crc_ok)
    begin
        O_crc_ok_cnt <= O_crc_ok_cnt + 16'b1 ;
    end
end




always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
    begin
        S_f8_cnt <= 8'd0;   
    end
    else if (I_xgmii_txc !=4'hf && I_xgmii_txc != 4'h0)
    begin
        S_f8_cnt <= S_f8_cnt + 8'd1;   
    end
    else if (I_xgmii_txc ==4'hf || I_xgmii_txc == 4'h0)
    begin
        S_f8_cnt <= 8'd0;  
    end
end    


always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
    begin
        O_crc_err_cnt[15:8] <= 16'd0;   
    end
    else if(I_cnt_clear)
    begin
        O_crc_err_cnt[15:8] <= 16'h0 ;
    end    
    else if (S_f8_cnt == 8'd2)
    begin
        O_crc_err_cnt[15:8] <= O_crc_err_cnt[15:8] + 16'd1;   
    end
end    


endmodule
