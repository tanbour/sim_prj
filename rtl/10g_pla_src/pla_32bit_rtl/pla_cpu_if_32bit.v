//FILE_HEADER-----------------------------------------------------------------
//ZTE  Copyright (C)
//ZTE Company Confidential
//----------------------------------------------------------------------------
//Project Name : RCUB PLA
//FILE NAME    : pla_cpu_if_32bit.v
//AUTHOR       : XXX XXXX
//Department   : ZTE-MW-TIANJIN-DESIGN-DEPARTMENT
//Email        : xxx.xxxx@zte.com.cn
//----------------------------------------------------------------------------
//Module Hiberarchy :
//x                        |--
//x pla_cpu_if_32bit     --|--
//----------------------------------------------------------------------------
//Relaese History :
//----------------------------------------------------------------------------
//Version         Date           Author        Description
// 1.0          Feb-2-2015       xxxxxxx       new pla
//----------------------------------------------------------------------------
//Main Function:
//a)pla_flow
//b)                                       C_VERSION_DATA
//----------------------------------------------------------------------------
//REUSE ISSUES: xxxxxxxx
//Reset Strategy: xxxxxxxx
//Clock Strategy: xxxxxxxx
//Critical Timing: xxxxxxxx
//Asynchronous Interface: xxxxxxxx
//END_HEADER------------------------------------------------------------------
`timescale 1ns/100ps

module pla_cpu_if_32bit

(
input                I_pla_312m5_clk            ,/// globle clk
input                I_pla_rst                  ,/// globle rst

input                I_lb_cs_n                  , /// localbus
input                I_lb_we_n                  , /// localbus
input                I_lb_rd_n                  , /// localbus
input       [10:0]   I_lb_addr                  , /// localbus
input       [15:0]   I_lb_wr_data               , /// localbus
output reg  [15:0]   O_lb_rd_data               , /// localbus

output reg  [2:0]    O_pla_tc_en                ,////CPU配置的定向发送使能   
output reg  [2:0]    O_pla_for_en               ,
output reg  [7:0]    O_pla0_tc_index            ,////PTP切片发送方向 0    
output reg  [7:0]    O_pla1_tc_index            ,////PTP切片发送方向 1     
output reg  [7:0]    O_pla2_tc_index            ,////PTP切片发送方向 2 
 
input       [7:0]    I_pla0_air_link            ,////空口link指示   
input       [7:0]    I_pla1_air_link            ,////空口link指示   
input       [7:0]    I_pla2_air_link            ,////空口link指示           
input       [7:0]    I_pla0_air_request         ,////反向解析的切片请求pulse   
input       [7:0]    I_pla1_air_request         ,////反向解析的切片请求pulse
input       [7:0]    I_pla2_air_request         ,////反向解析的切片请求pulse
input       [7:0]    I_pla0_air_pause           ,////空口pause指示   
input       [7:0]    I_pla1_air_pause           ,////空口pause指示   
input       [7:0]    I_pla2_air_pause           ,////空口pause指示   
output reg  [15:0]   O_flow_fifo_pause_set      ,////流FIFO Pause交换水位,上限           
output reg  [15:0]   O_flow_fifo_resume_set     ,////流FIFO解Pause交换水位,下限 
output reg  [15:0]   O_flow_fifo_overflow_set   ,////流FIFO解Pause交换水位,下限 


output reg  [14:0]   O_pla_slice_window         ,//// 
output reg  [15:0]   O_request_wait_time        ,///
output reg           O_request_wait_en          ,///
output reg  [2:0]    O_pla_mu_aou_sel           ,///
                                                
output reg  [23:0]   O_pla_air_link_change_mask ,
input       [23:0]   I_pla_air_link_change_flg  ,

output reg  [15:0]   O_pla_int_mask            ,  
output reg  [15:0]   O_pla_int_clr             ,  
input       [15:0]   I_pla_rmu_int             ,       
input       [15:0]   I_pla_int_event           ,
input       [19:0]   I_pla0_rmu_rate           ,
input       [19:0]   I_pla1_rmu_rate           ,
input       [19:0]   I_pla2_rmu_rate           ,
input       [15:0]   I_pla0_cu_rate_chg_cnt    ,
input       [15:0]   I_pla1_cu_rate_chg_cnt    ,
input       [15:0]   I_pla2_cu_rate_chg_cnt    ,
                                                
output reg  [2:0]    O_pla_loop_en              ,////LOOP选择   BIT0:rmuc外部10G SERDES环回 BIT1:rmuc内部10G环回 
output reg  [1:0]    O_pla_pass_en              ,
output reg  [23:0]   O_pla_loop_link            , 
output reg  [15:0]   O_loop_request_ifg         ,////反向数据带REQUEST报文间隔 16'h1400
output reg  [15:0]   O_cnt_clear                ,
output reg           O_num_test_en              ,

input       [1:0]    I_ddr_rdy                  ,
////CPU测试接口

input       [15:0]   I_for_framer_55D5_cnt      ,
input       [15:0]   I_for_framer_lose_cnt      ,
input                I_for_framer_lose_reg      ,
input       [15:0]   I_for_framer_err_cnt       ,
output reg  [1:0]    O_rcub_chk_sel             ,

input       [15:0]   I_for_egmii_crcerr_frame_cnt ,
input       [15:0]   I_for_egmii_output_frame_cnt ,
input       [15:0]   I_for_egmii_reframer_err_cnt ,


input       [47:0]   I_flow_ff_para_full_cnt    ,////FLOW fifo 帧统计       
input       [47:0]   I_pla_air_unlink_cnt       ,  
input       [15:0]   I_flow_ff0_level           ,////FLOW fifo 帧统计       
input       [15:0]   I_flow_ff1_level           ,////FLOW fifo 帧统计       
input       [15:0]   I_flow_ff2_level           ,////FLOW fifo 帧统计       
input       [47:0]   I_flow_ff0_frame_stat      ,////FLOW fifo 帧统计
input       [47:0]   I_flow_ff1_frame_stat      ,////FLOW fifo 帧统计
input       [47:0]   I_flow_ff2_frame_stat      ,////FLOW fifo 帧统计         
input       [47:0]   I_flow_ff0_err_stat        ,////fifo空的次数  
input       [47:0]   I_flow_ff1_err_stat        ,////fifo空的次数
input       [47:0]   I_flow_ff2_err_stat        ,////fifo空的次数 
input       [79:0]   I_slice_fifo0_len_err      ,////测试寄存器
input       [79:0]   I_slice_fifo1_len_err      ,////测试寄存器
input       [79:0]   I_slice_fifo2_len_err      ,////测试寄存器
input       [15:0]   I_for_frame_cnt            ,////测试寄存器
input       [2:0]    I_hc_for_en                ,
output reg  [15:0]   O_rate_limit_test          ,
input       [15:0]   I_for0_input_cnt           ,
input       [15:0]   I_for1_input_cnt           ,
input       [15:0]   I_for2_input_cnt           ,
input       [15:0]   I_for3_input_cnt           ,
input       [31:0]   I_pla0_para_err_stat      ,
input       [31:0]   I_pla1_para_err_stat      ,
input       [31:0]   I_pla2_para_err_stat      ,
                                                

input       [15:0]   I_pla0_forin_crcok_cnt      ,
input       [15:0]   I_pla0_forin_crcerr_cnt     ,
input       [15:0]   I_pla1_forin_crcok_cnt      ,
input       [15:0]   I_pla1_forin_crcerr_cnt     ,
input       [15:0]   I_pla2_forin_crcok_cnt      ,
input       [15:0]   I_pla2_forin_crcerr_cnt     ,

input       [15:0]  I_frame_dpram_usedw_back_pla0,
input       [15:0]  I_frame_dpram_usedw_back_pla1,
input       [15:0]  I_frame_dpram_usedw_back_pla2,

                                                  
output reg  [15:0]    O_module_rst               ,//// PLA0空口0 mac                                               
                                                
output reg  [47:0]   O_pla0_air_mac_0           ,//// PLA0空口0 mac       
output reg  [47:0]   O_pla0_air_mac_1           ,//// PLA0空口1 mac       
output reg  [47:0]   O_pla0_air_mac_2           ,//// PLA0空口2 mac       
output reg  [47:0]   O_pla0_air_mac_3           ,//// PLA0空口3 mac       
output reg  [47:0]   O_pla0_air_mac_4           ,//// PLA0空口4 mac       
output reg  [47:0]   O_pla0_air_mac_5           ,//// PLA0空口5 mac       
output reg  [47:0]   O_pla0_air_mac_6           ,//// PLA0空口6 mac       
output reg  [47:0]   O_pla0_air_mac_7           ,//// PLA0空口7 mac       
output reg  [47:0]   O_pla1_air_mac_0           ,//// PLA1空口0 mac       
output reg  [47:0]   O_pla1_air_mac_1           ,//// PLA1空口1 mac       
output reg  [47:0]   O_pla1_air_mac_2           ,//// PLA1空口2 mac       
output reg  [47:0]   O_pla1_air_mac_3           ,//// PLA1空口3 mac       
output reg  [47:0]   O_pla1_air_mac_4           ,//// PLA1空口4 mac       
output reg  [47:0]   O_pla1_air_mac_5           ,//// PLA1空口5 mac       
output reg  [47:0]   O_pla1_air_mac_6           ,//// PLA1空口6 mac       
output reg  [47:0]   O_pla1_air_mac_7           ,//// PLA1空口7 mac       
output reg  [47:0]   O_pla2_air_mac_0           ,//// PLA2空口0 mac       
output reg  [47:0]   O_pla2_air_mac_1           ,//// PLA2空口1 mac       
output reg  [47:0]   O_pla2_air_mac_2           ,//// PLA2空口2 mac       
output reg  [47:0]   O_pla2_air_mac_3           ,//// PLA2空口3 mac       
output reg  [47:0]   O_pla2_air_mac_4           ,//// PLA2空口4 mac       
output reg  [47:0]   O_pla2_air_mac_5           ,//// PLA2空口5 mac       
output reg  [47:0]   O_pla2_air_mac_6           ,//// PLA2空口6 mac       
output reg  [47:0]   O_pla2_air_mac_7           ,//// PLA2空口7 mac       
output reg  [47:0]   O_pla0_rcu_mac            , //// 切片发送源mac  
output reg  [47:0]   O_pla1_rcu_mac            , //// 切片发送源mac  
output reg  [47:0]   O_pla2_rcu_mac            , //// 切片发送源mac  
                                                
output reg [31:0]    O_pla0_test_freq_0      ,
output reg [31:0]    O_pla0_test_freq_1      ,
output reg [31:0]    O_pla0_test_freq_2      ,
output reg [31:0]    O_pla0_test_freq_3      ,
output reg [31:0]    O_pla0_test_freq_4      ,
output reg [31:0]    O_pla0_test_freq_5      ,
output reg [31:0]    O_pla0_test_freq_6      ,
output reg [31:0]    O_pla0_test_freq_7      ,
output reg [31:0]    O_pla1_test_freq_0      ,
output reg [31:0]    O_pla1_test_freq_1      ,
output reg [31:0]    O_pla1_test_freq_2      ,
output reg [31:0]    O_pla1_test_freq_3      ,
output reg [31:0]    O_pla1_test_freq_4      ,
output reg [31:0]    O_pla1_test_freq_5      ,
output reg [31:0]    O_pla1_test_freq_6      ,
output reg [31:0]    O_pla1_test_freq_7      ,
output reg [31:0]    O_pla2_test_freq_0      ,
output reg [31:0]    O_pla2_test_freq_1      ,
output reg [31:0]    O_pla2_test_freq_2      ,
output reg [31:0]    O_pla2_test_freq_3      ,
output reg [31:0]    O_pla2_test_freq_4      ,
output reg [31:0]    O_pla2_test_freq_5      ,
output reg [31:0]    O_pla2_test_freq_6      ,
output reg [31:0]    O_pla2_test_freq_7      ,


output reg [2:0]    O_pla_tc_protect_en         ,///tc保护使能    
output reg [15:0]   O_pla_tc_protect_cnt        ,///tc保护使能设置时间寄存器   
input      [15:0]   I_pla0_tc_protect_err_cnt   ,///测试寄存器
input      [15:0]   I_pla1_tc_protect_err_cnt   ,///测试寄存器
input      [15:0]   I_pla2_tc_protect_err_cnt   ,///测试寄存器
input      [2:0]    I_pla_tc_protect_out        ,///

///LOCAL BUS接口    
input      [3:0]    I_pla00_current_acm        ,
input      [3:0]    I_pla01_current_acm        ,
input      [3:0]    I_pla02_current_acm        ,
input      [3:0]    I_pla03_current_acm        ,
input      [3:0]    I_pla04_current_acm        ,
input      [3:0]    I_pla05_current_acm        ,
input      [3:0]    I_pla06_current_acm        ,
input      [3:0]    I_pla07_current_acm        ,
input      [3:0]    I_pla10_current_acm        ,
input      [3:0]    I_pla11_current_acm        ,
input      [3:0]    I_pla12_current_acm        ,
input      [3:0]    I_pla13_current_acm        ,
input      [3:0]    I_pla14_current_acm        ,
input      [3:0]    I_pla15_current_acm        ,
input      [3:0]    I_pla16_current_acm        ,
input      [3:0]    I_pla17_current_acm        ,
input      [3:0]    I_pla20_current_acm        ,
input      [3:0]    I_pla21_current_acm        ,
input      [3:0]    I_pla22_current_acm        ,
input      [3:0]    I_pla23_current_acm        ,
input      [3:0]    I_pla24_current_acm        ,
input      [3:0]    I_pla25_current_acm        ,
input      [3:0]    I_pla26_current_acm        ,
input      [3:0]    I_pla27_current_acm        ,

///LOCAL BUS接口    
input      [31:0]    I_pla00_current_freq       ,
input      [31:0]    I_pla01_current_freq       ,
input      [31:0]    I_pla02_current_freq       ,
input      [31:0]    I_pla03_current_freq       ,
input      [31:0]    I_pla04_current_freq       ,
input      [31:0]    I_pla05_current_freq       ,
input      [31:0]    I_pla06_current_freq       ,
input      [31:0]    I_pla07_current_freq       ,
input      [31:0]    I_pla10_current_freq       ,
input      [31:0]    I_pla11_current_freq       ,
input      [31:0]    I_pla12_current_freq       ,
input      [31:0]    I_pla13_current_freq       ,
input      [31:0]    I_pla14_current_freq       ,
input      [31:0]    I_pla15_current_freq       ,
input      [31:0]    I_pla16_current_freq       ,
input      [31:0]    I_pla17_current_freq       ,
input      [31:0]    I_pla20_current_freq       ,
input      [31:0]    I_pla21_current_freq       ,
input      [31:0]    I_pla22_current_freq       ,
input      [31:0]    I_pla23_current_freq       ,
input      [31:0]    I_pla24_current_freq       ,
input      [31:0]    I_pla25_current_freq       ,
input      [31:0]    I_pla26_current_freq       ,
input      [31:0]    I_pla27_current_freq       ,

input      [15:0]    I_pla00_rmu_rate    ,
input      [15:0]    I_pla01_rmu_rate    ,
input      [15:0]    I_pla02_rmu_rate    ,
input      [15:0]    I_pla03_rmu_rate    ,
input      [15:0]    I_pla04_rmu_rate    ,
input      [15:0]    I_pla05_rmu_rate    ,
input      [15:0]    I_pla06_rmu_rate    ,
input      [15:0]    I_pla07_rmu_rate    ,
input      [15:0]    I_pla10_rmu_rate    ,
input      [15:0]    I_pla11_rmu_rate    ,
input      [15:0]    I_pla12_rmu_rate    ,
input      [15:0]    I_pla13_rmu_rate    ,
input      [15:0]    I_pla14_rmu_rate    ,
input      [15:0]    I_pla15_rmu_rate    ,
input      [15:0]    I_pla16_rmu_rate    ,
input      [15:0]    I_pla17_rmu_rate    ,
input      [15:0]    I_pla20_rmu_rate    ,
input      [15:0]    I_pla21_rmu_rate    ,
input      [15:0]    I_pla22_rmu_rate    ,
input      [15:0]    I_pla23_rmu_rate    ,
input      [15:0]    I_pla24_rmu_rate    ,
input      [15:0]    I_pla25_rmu_rate    ,
input      [15:0]    I_pla26_rmu_rate    ,
input      [15:0]    I_pla27_rmu_rate    ,

input      [47:0]    I_pla00_req_change_cnt     ,
input      [47:0]    I_pla01_req_change_cnt     ,
input      [47:0]    I_pla02_req_change_cnt     ,
input      [47:0]    I_pla03_req_change_cnt     ,
input      [47:0]    I_pla04_req_change_cnt     ,
input      [47:0]    I_pla05_req_change_cnt     ,
input      [47:0]    I_pla06_req_change_cnt     ,
input      [47:0]    I_pla07_req_change_cnt     ,  
input      [47:0]    I_pla10_req_change_cnt     ,
input      [47:0]    I_pla11_req_change_cnt     ,
input      [47:0]    I_pla12_req_change_cnt     ,
input      [47:0]    I_pla13_req_change_cnt     ,
input      [47:0]    I_pla14_req_change_cnt     ,
input      [47:0]    I_pla15_req_change_cnt     ,
input      [47:0]    I_pla16_req_change_cnt     ,
input      [47:0]    I_pla17_req_change_cnt     ,
input      [47:0]    I_pla20_req_change_cnt     ,
input      [47:0]    I_pla21_req_change_cnt     ,
input      [47:0]    I_pla22_req_change_cnt     ,
input      [47:0]    I_pla23_req_change_cnt     ,
input      [47:0]    I_pla24_req_change_cnt     ,
input      [47:0]    I_pla25_req_change_cnt     ,
input      [47:0]    I_pla26_req_change_cnt     ,
input      [47:0]    I_pla27_req_change_cnt     ,


input      [15:0]    I_pla0_slice_ok_cnt        ,
input      [15:0]    I_pla0_slice_wr_cnt        ,
input      [15:0]    I_pla0_slice_rd_cnt        ,
input	   [15:0]    I_pla0_slice_crc_err_cnt	,
input      [15:0]    I_pla1_slice_ok_cnt        ,
input      [15:0]    I_pla1_slice_wr_cnt        ,
input      [15:0]    I_pla1_slice_rd_cnt        ,
input	   [15:0]    I_pla1_slice_crc_err_cnt	,
input      [15:0]    I_pla2_slice_ok_cnt        ,
input      [15:0]    I_pla2_slice_wr_cnt        ,
input      [15:0]    I_pla2_slice_rd_cnt        ,
input	   [15:0]    I_pla2_slice_crc_err_cnt	,
input	   [15:0]	 I_ddr3a_app_wdf_rdy_low_cnt_max,	
input	   [15:0]	 I_ddr3a_wr_app_rdy_low_cnt_max	,	
input	   [15:0]	 I_ddr3a_rd_app_rdy_low_cnt_max	,	
input	   [15:0]	 I_ddr3a_app_write_err_cnt		,	
input	   [15:0]	 I_ddr3a_buf_full_cnt			,	

input	   [15:0]	 I_ddr3b_app_wdf_rdy_low_cnt_max,	
input	   [15:0]	 I_ddr3b_wr_app_rdy_low_cnt_max	,	
input	   [15:0]	 I_ddr3b_rd_app_rdy_low_cnt_max	,	
input	   [15:0]	 I_ddr3b_app_write_err_cnt		,	
input	   [15:0]	 I_ddr3b_buf_full_cnt			,	




input      [47:0]    I_ddr0_reflow_55D5_cnt     ,
input      [47:0]    I_ddr0_reflow_lose_cnt     ,
input      [2:0]     I_ddr0_reflow_lose_reg     ,

input      [31:0]    I_pla0_reflow_rderr_cnt    ,
input      [31:0]    I_pla1_reflow_rderr_cnt    ,
input      [31:0]    I_pla2_reflow_rderr_cnt    ,
input      [47:0]    I_pla0_reflow_id_wl        ,   
input      [47:0]    I_pla1_reflow_id_wl        ,   
input      [47:0]    I_pla2_reflow_id_wl        ,   
input      [2:0]     I_pla_slice_id_depth_alful , 
input      [15:0]    I_input_crcok_cnt          ,
input      [15:0]    I_input_crcerr_cnt         ,
input      [15:0]    I_output_crcok_cnt         ,
input      [15:0]    I_output_crcerr_cnt        ,
////反向
input      [15:0]    I_pla_slice_crc_ok_cnt     ,
input      [15:0]    I_pla_slice_crc_err_cnt    ,
input      [15:0]    I_all_err_cnt              ,
input      [15:0]    I_fifo_full0_cnt           ,
input      [15:0]    I_ram_full0_cnt            ,
input      [15:0]    I_length_err0_cnt          ,

input		[15:0]	I_pla_slice_mac_err_cnt			, 
input		[15:0]	I_pla_slice_len_err_cnt			, 
input		[ 7:0]	I_pla0_slice_id_random_order	,
input		[ 7:0]	I_pla1_slice_id_random_order	,
input		[ 7:0]	I_pla2_slice_id_random_order	,
input		[15:0]	I_pla0_slice_id_bottom_err_cnt	,
input		[15:0]	I_pla1_slice_id_bottom_err_cnt	,
input		[15:0]	I_pla2_slice_id_bottom_err_cnt	,


output	reg[ 5:0]	O_slice_rd_en_valid_cnt_fix = 6'd40	,

input      [15:0]    I_back0_lose_num_cnt       ,
input      [15:0]    I_back1_lose_num_cnt       ,
input      [15:0]    I_back2_lose_num_cnt       ,
                       

input      [15:0]    I_feedback_cnt             ,
input      [15:0]    I_drop_flag_cnt            ,
input      [15:0]    I_reframe_state_change_cnt ,
input      [15:0]    I_slice_cnt                ,
input                I_pla_slice_fifo_empty_pla0,
input      [15:0]    I_pla0_reframe_fifo_wr_cnt ,
input      [15:0]    I_reframe_pla0_55d5_cnt    ,

// pla tc
output reg [1:0]     O_pla_tc_bypass           ,
output reg [6:0]     O_clear_forward_en        ,
output reg [3:0]     O_clear_en                ,
output reg [7:0]     O_clear_subport0_en       ,
output reg [7:0]     O_clear_subport1_en       ,
output reg [7:0]     O_clear_subport2_en       ,

input      [31:0]    I_pkt_cnt_slice_in        ,
input      [31:0]    I_ptp_cnt_in              ,
input      [31:0]    I_vlan_ptp_cnt_in         ,
input      [31:0]    I_ptp_no_vlan_cnt_out     ,
input      [31:0]    I_ptp_vlan_cnt_out        ,
input      [31:0]    I_slice_cnt_out           ,
input      [31:0]    I_packet_cnt_out          ,

input      [6:0]     I_fifo_usedw              ,
input      [15:0]    I_1588_packet_in_num      ,
input      [15:0]    I_1588_packet_out_num     ,
input      [15:0]    I_all_packet_in_num       ,
input      [15:0]    I_all_packet_out_num      ,
input      [15:0]    I_pla_slice_sa00_cnt      ,
input      [15:0]    I_pla_slice_sa01_cnt      ,
input      [15:0]    I_pla_slice_sa02_cnt      ,
input      [15:0]    I_pla_slice_sa03_cnt      ,
input      [15:0]    I_pla_slice_sa04_cnt      ,
input      [15:0]    I_pla_slice_sa05_cnt      ,
input      [15:0]    I_pla_slice_sa06_cnt      ,
input      [15:0]    I_pla_slice_sa07_cnt      ,
input      [15:0]    I_pla_slice_sa10_cnt      ,
input      [15:0]    I_pla_slice_sa11_cnt      ,
input      [15:0]    I_pla_slice_sa12_cnt      ,
input      [15:0]    I_pla_slice_sa13_cnt      ,
input      [15:0]    I_pla_slice_sa14_cnt      ,
input      [15:0]    I_pla_slice_sa15_cnt      ,
input      [15:0]    I_pla_slice_sa16_cnt      ,
input      [15:0]    I_pla_slice_sa17_cnt      ,
input      [15:0]    I_pla_slice_sa20_cnt      ,
input      [15:0]    I_pla_slice_sa21_cnt      ,
input      [15:0]    I_pla_slice_sa22_cnt      ,
input      [15:0]    I_pla_slice_sa23_cnt      ,
input      [15:0]    I_pla_slice_sa24_cnt      ,
input      [15:0]    I_pla_slice_sa25_cnt      ,
input      [15:0]    I_pla_slice_sa26_cnt      ,
input      [15:0]    I_pla_slice_sa27_cnt      ,
input      [31:0]    I_state                   ,
input      [15:0]    I_pla_rst_cnt             ,

input      [15:0]    I_err_tme_cnt             ,
input      [15:0]    I_small_inter_cnt         ,
output   reg         O_pause_en      
                     

);

parameter  C_VERSION_DATA            = 16'he900;///地址0x16860


//PLA0 11'h0XX  PLA1 11'h1XX ,PLA2 11'h2XX  共用:11'h3XX ,FPGA前向调试测试11'h4XX 
///反向 11'5XX
parameter  C_PLA0_AIR_MAC_0_P0       = 11'h000, ///PLA0空口0 MAC地址低16位
           C_PLA0_AIR_MAC_1_P0       = 11'h001, ///PLA0空口1 MAC地址低16位
           C_PLA0_AIR_MAC_2_P0       = 11'h002, ///PLA0空口2 MAC地址低16位
           C_PLA0_AIR_MAC_3_P0       = 11'h003, ///PLA0空口3 MAC地址低16位
           C_PLA0_AIR_MAC_4_P0       = 11'h004, ///PLA0空口4 MAC地址低16位
           C_PLA0_AIR_MAC_5_P0       = 11'h005, ///PLA0空口5 MAC地址低16位
           C_PLA0_AIR_MAC_6_P0       = 11'h006, ///PLA0空口6 MAC地址低16位          
           C_PLA0_AIR_MAC_7_P0       = 11'h007, ///PLA0空口7 MAC地址低16位
           C_PLA0_AIR_MAC_0_P1       = 11'h010, ///PLA0空口0 MAC地址中16位                              
           C_PLA0_AIR_MAC_1_P1       = 11'h011, ///PLA0空口1 MAC地址中16位    
           C_PLA0_AIR_MAC_2_P1       = 11'h012, ///PLA0空口2 MAC地址中16位    
           C_PLA0_AIR_MAC_3_P1       = 11'h013, ///PLA0空口3 MAC地址中16位    
           C_PLA0_AIR_MAC_4_P1       = 11'h014, ///PLA0空口4 MAC地址中16位    
           C_PLA0_AIR_MAC_5_P1       = 11'h015, ///PLA0空口5 MAC地址中16位    
           C_PLA0_AIR_MAC_6_P1       = 11'h016, ///PLA0空口6 MAC地址中16位    
           C_PLA0_AIR_MAC_7_P1       = 11'h017, ///PLA0空口7 MAC地址中16位    
           C_PLA0_AIR_MAC_0_P2       = 11'h020, ///PLA0空口0 MAC地址高16位           
           C_PLA0_AIR_MAC_1_P2       = 11'h021, ///PLA0空口1 MAC地址高16位           
           C_PLA0_AIR_MAC_2_P2       = 11'h022, ///PLA0空口2 MAC地址高16位           
           C_PLA0_AIR_MAC_3_P2       = 11'h023, ///PLA0空口3 MAC地址高16位           
           C_PLA0_AIR_MAC_4_P2       = 11'h024, ///PLA0空口4 MAC地址高16位           
           C_PLA0_AIR_MAC_5_P2       = 11'h025, ///PLA0空口5 MAC地址高16位           
           C_PLA0_AIR_MAC_6_P2       = 11'h026, ///PLA0空口6 MAC地址高16位           
           C_PLA0_AIR_MAC_7_P2       = 11'h027, ///PLA0空口7 MAC地址高16位           
                                    
           ///pla1                  
           C_PLA1_AIR_MAC_0_P0       = 11'h100, ///PLA1空口0 MAC地址低16位             
           C_PLA1_AIR_MAC_1_P0       = 11'h101, ///PLA1空口1 MAC地址低16位             
           C_PLA1_AIR_MAC_2_P0       = 11'h102, ///PLA1空口2 MAC地址低16位             
           C_PLA1_AIR_MAC_3_P0       = 11'h103, ///PLA1空口3 MAC地址低16位             
           C_PLA1_AIR_MAC_4_P0       = 11'h104, ///PLA1空口4 MAC地址低16位             
           C_PLA1_AIR_MAC_5_P0       = 11'h105, ///PLA1空口5 MAC地址低16位             
           C_PLA1_AIR_MAC_6_P0       = 11'h106, ///PLA1空口6 MAC地址低16位                 
           C_PLA1_AIR_MAC_7_P0       = 11'h107, ///PLA1空口7 MAC地址低16位            
           C_PLA1_AIR_MAC_0_P1       = 11'h110, ///PLA1空口0 MAC地址中16位             
           C_PLA1_AIR_MAC_1_P1       = 11'h111, ///PLA1空口1 MAC地址中16位             
           C_PLA1_AIR_MAC_2_P1       = 11'h112, ///PLA1空口2 MAC地址中16位             
           C_PLA1_AIR_MAC_3_P1       = 11'h113, ///PLA1空口3 MAC地址中16位             
           C_PLA1_AIR_MAC_4_P1       = 11'h114, ///PLA1空口4 MAC地址中16位             
           C_PLA1_AIR_MAC_5_P1       = 11'h115, ///PLA1空口5 MAC地址中16位             
           C_PLA1_AIR_MAC_6_P1       = 11'h116, ///PLA1空口6 MAC地址中16位             
           C_PLA1_AIR_MAC_7_P1       = 11'h117, ///PLA1空口7 MAC地址中16位        
           C_PLA1_AIR_MAC_0_P2       = 11'h120, ///PLA1空口0 MAC地址高16位             
           C_PLA1_AIR_MAC_1_P2       = 11'h121, ///PLA1空口1 MAC地址高16位             
           C_PLA1_AIR_MAC_2_P2       = 11'h122, ///PLA1空口2 MAC地址高16位             
           C_PLA1_AIR_MAC_3_P2       = 11'h123, ///PLA1空口3 MAC地址高16位             
           C_PLA1_AIR_MAC_4_P2       = 11'h124, ///PLA1空口4 MAC地址高16位             
           C_PLA1_AIR_MAC_5_P2       = 11'h125, ///PLA1空口5 MAC地址高16位             
           C_PLA1_AIR_MAC_6_P2       = 11'h126, ///PLA1空口6 MAC地址高16位             
           C_PLA1_AIR_MAC_7_P2       = 11'h127, ///PLA1空口7 MAC地址高16位             
                                    
           C_PLA2_AIR_MAC_0_P0       = 11'h200, ///PLA2空口0 MAC地址低16位            
           C_PLA2_AIR_MAC_1_P0       = 11'h201, ///PLA2空口1 MAC地址低16位            
           C_PLA2_AIR_MAC_2_P0       = 11'h202, ///PLA2空口2 MAC地址低16位            
           C_PLA2_AIR_MAC_3_P0       = 11'h203, ///PLA2空口3 MAC地址低16位            
           C_PLA2_AIR_MAC_4_P0       = 11'h204, ///PLA2空口4 MAC地址低16位            
           C_PLA2_AIR_MAC_5_P0       = 11'h205, ///PLA2空口5 MAC地址低16位            
           C_PLA2_AIR_MAC_6_P0       = 11'h206, ///PLA2空口6 MAC地址低16位            
           C_PLA2_AIR_MAC_7_P0       = 11'h207, ///PLA2空口7 MAC地址低16位            
           C_PLA2_AIR_MAC_0_P1       = 11'h210, ///PLA2空口0 MAC地址中16位            
           C_PLA2_AIR_MAC_1_P1       = 11'h211, ///PLA2空口1 MAC地址中16位            
           C_PLA2_AIR_MAC_2_P1       = 11'h212, ///PLA2空口2 MAC地址中16位            
           C_PLA2_AIR_MAC_3_P1       = 11'h213, ///PLA2空口3 MAC地址中16位            
           C_PLA2_AIR_MAC_4_P1       = 11'h214, ///PLA2空口4 MAC地址中16位            
           C_PLA2_AIR_MAC_5_P1       = 11'h215, ///PLA2空口5 MAC地址中16位            
           C_PLA2_AIR_MAC_6_P1       = 11'h216, ///PLA2空口6 MAC地址中16位            
           C_PLA2_AIR_MAC_7_P1       = 11'h217, ///PLA2空口7 MAC地址中16位            
           C_PLA2_AIR_MAC_0_P2       = 11'h220, ///PLA2空口0 MAC地址高16位            
           C_PLA2_AIR_MAC_1_P2       = 11'h221, ///PLA2空口1 MAC地址高16位            
           C_PLA2_AIR_MAC_2_P2       = 11'h222, ///PLA2空口2 MAC地址高16位            
           C_PLA2_AIR_MAC_3_P2       = 11'h223, ///PLA2空口3 MAC地址高16位            
           C_PLA2_AIR_MAC_4_P2       = 11'h224, ///PLA2空口4 MAC地址高16位            
           C_PLA2_AIR_MAC_5_P2       = 11'h225, ///PLA2空口5 MAC地址高16位            
           C_PLA2_AIR_MAC_6_P2       = 11'h226, ///PLA2空口6 MAC地址高16位            
           C_PLA2_AIR_MAC_7_P2       = 11'h227, ///PLA2空口7 MAC地址高16位            
                                    
           C_PLA0_TC_INDEX           = 11'h030, ///PLA0空口TC方向     
           C_PLA1_TC_INDEX           = 11'h130, ///PLA1空口TC方向   
           C_PLA2_TC_INDEX           = 11'h230, ///PLA2空口TC方向   
                                    
           C_PLA0_AIR_LINK           = 11'h031, ///PLA0空口LINK指示     
           C_PLA1_AIR_LINK           = 11'h131, ///PLA1空口LINK指示     
           C_PLA2_AIR_LINK           = 11'h231, ///PLA2空口LINK指示    
                                    
           C_PLA0_AIR_REQUEST        = 11'h032, ///PLA0空口REQUEST接收指示 
           C_PLA1_AIR_REQUEST        = 11'h132, ///PLA1空口REQUEST接收指示 
           C_PLA2_AIR_REQUEST        = 11'h232, ///PLA2空口REQUEST接收指示 
                                    
           C_PLA0_AIR_PAUSE          = 11'h033, ///PLA0空口PAUSE 
           C_PLA1_AIR_PAUSE          = 11'h133, ///PLA1空口PAUSE 
           C_PLA2_AIR_PAUSE          = 11'h233, ///PLA2空口PAUSE
                                    
           C_PLA00_CURRENT_ACM       = 11'h040,   
           C_PLA01_CURRENT_ACM       = 11'h041,   
           C_PLA02_CURRENT_ACM       = 11'h042,   
           C_PLA03_CURRENT_ACM       = 11'h043,   
           C_PLA04_CURRENT_ACM       = 11'h044,   
           C_PLA05_CURRENT_ACM       = 11'h045,   
           C_PLA06_CURRENT_ACM       = 11'h046,   
           C_PLA07_CURRENT_ACM       = 11'h047,   
           C_PLA10_CURRENT_ACM       = 11'h140,   
           C_PLA11_CURRENT_ACM       = 11'h141,   
           C_PLA12_CURRENT_ACM       = 11'h142,   
           C_PLA13_CURRENT_ACM       = 11'h143,   
           C_PLA14_CURRENT_ACM       = 11'h144,   
           C_PLA15_CURRENT_ACM       = 11'h145,   
           C_PLA16_CURRENT_ACM       = 11'h146,   
           C_PLA17_CURRENT_ACM       = 11'h147,   
           C_PLA20_CURRENT_ACM       = 11'h240,   
           C_PLA21_CURRENT_ACM       = 11'h241,   
           C_PLA22_CURRENT_ACM       = 11'h242,   
           C_PLA23_CURRENT_ACM       = 11'h243,   
           C_PLA24_CURRENT_ACM       = 11'h244,   
           C_PLA25_CURRENT_ACM       = 11'h245,   
           C_PLA26_CURRENT_ACM       = 11'h246,   
           C_PLA27_CURRENT_ACM       = 11'h247,  
                                    
           
           C_PLA00_CURRENT_FREQ_P0   = 11'h048,      
           C_PLA01_CURRENT_FREQ_P0   = 11'h049,      
           C_PLA02_CURRENT_FREQ_P0   = 11'h04A,      
           C_PLA03_CURRENT_FREQ_P0   = 11'h04B,      
           C_PLA04_CURRENT_FREQ_P0   = 11'h04C,      
           C_PLA05_CURRENT_FREQ_P0   = 11'h04D,      
           C_PLA06_CURRENT_FREQ_P0   = 11'h04E,      
           C_PLA07_CURRENT_FREQ_P0   = 11'h04F,      
           C_PLA10_CURRENT_FREQ_P0   = 11'h148,      
           C_PLA11_CURRENT_FREQ_P0   = 11'h149,      
           C_PLA12_CURRENT_FREQ_P0   = 11'h14A,      
           C_PLA13_CURRENT_FREQ_P0   = 11'h14B,      
           C_PLA14_CURRENT_FREQ_P0   = 11'h14C,      
           C_PLA15_CURRENT_FREQ_P0   = 11'h14D,      
           C_PLA16_CURRENT_FREQ_P0   = 11'h14E,      
           C_PLA17_CURRENT_FREQ_P0   = 11'h14F,      
           C_PLA20_CURRENT_FREQ_P0   = 11'h248,      
           C_PLA21_CURRENT_FREQ_P0   = 11'h249,      
           C_PLA22_CURRENT_FREQ_P0   = 11'h24A,      
           C_PLA23_CURRENT_FREQ_P0   = 11'h24B,      
           C_PLA24_CURRENT_FREQ_P0   = 11'h24C,      
           C_PLA25_CURRENT_FREQ_P0   = 11'h24D,      
           C_PLA26_CURRENT_FREQ_P0   = 11'h24E,      
           C_PLA27_CURRENT_FREQ_P0   = 11'h24F,    
                                                                          
           C_PLA00_CURRENT_FREQ_P1   = 11'h050,   
           C_PLA01_CURRENT_FREQ_P1   = 11'h051,   
           C_PLA02_CURRENT_FREQ_P1   = 11'h052,   
           C_PLA03_CURRENT_FREQ_P1   = 11'h053,   
           C_PLA04_CURRENT_FREQ_P1   = 11'h054,   
           C_PLA05_CURRENT_FREQ_P1   = 11'h055,   
           C_PLA06_CURRENT_FREQ_P1   = 11'h056,   
           C_PLA07_CURRENT_FREQ_P1   = 11'h057,   
           C_PLA10_CURRENT_FREQ_P1   = 11'h150,      
           C_PLA11_CURRENT_FREQ_P1   = 11'h151,      
           C_PLA12_CURRENT_FREQ_P1   = 11'h152,      
           C_PLA13_CURRENT_FREQ_P1   = 11'h153,      
           C_PLA14_CURRENT_FREQ_P1   = 11'h154,      
           C_PLA15_CURRENT_FREQ_P1   = 11'h155,      
           C_PLA16_CURRENT_FREQ_P1   = 11'h156,      
           C_PLA17_CURRENT_FREQ_P1   = 11'h157,      
           C_PLA20_CURRENT_FREQ_P1   = 11'h250,    
           C_PLA21_CURRENT_FREQ_P1   = 11'h251,    
           C_PLA22_CURRENT_FREQ_P1   = 11'h252,    
           C_PLA23_CURRENT_FREQ_P1   = 11'h253,    
           C_PLA24_CURRENT_FREQ_P1   = 11'h254,    
           C_PLA25_CURRENT_FREQ_P1   = 11'h255,    
           C_PLA26_CURRENT_FREQ_P1   = 11'h256,    
           C_PLA27_CURRENT_FREQ_P1   = 11'h257,   
                                    
           C_PLA0_TEST_FREQ_0_P0      = 11'h060,      
           C_PLA0_TEST_FREQ_0_P1      = 11'h061,      
           C_PLA0_TEST_FREQ_1_P0      = 11'h062,      
           C_PLA0_TEST_FREQ_1_P1      = 11'h063,      
           C_PLA0_TEST_FREQ_2_P0      = 11'h064,      
           C_PLA0_TEST_FREQ_2_P1      = 11'h065,      
           C_PLA0_TEST_FREQ_3_P0      = 11'h066,      
           C_PLA0_TEST_FREQ_3_P1      = 11'h067,      
           C_PLA0_TEST_FREQ_4_P0      = 11'h068,      
           C_PLA0_TEST_FREQ_4_P1      = 11'h069,      
           C_PLA0_TEST_FREQ_5_P0      = 11'h06a,      
           C_PLA0_TEST_FREQ_5_P1      = 11'h06b,      
           C_PLA0_TEST_FREQ_6_P0      = 11'h06c,      
           C_PLA0_TEST_FREQ_6_P1      = 11'h06d,      
           C_PLA0_TEST_FREQ_7_P0      = 11'h06e,      
           C_PLA0_TEST_FREQ_7_P1      = 11'h06f,      
                                
           C_PLA1_TEST_FREQ_0_P0      = 11'h160,      
           C_PLA1_TEST_FREQ_0_P1      = 11'h161,      
           C_PLA1_TEST_FREQ_1_P0      = 11'h162,      
           C_PLA1_TEST_FREQ_1_P1      = 11'h163,      
           C_PLA1_TEST_FREQ_2_P0      = 11'h164,      
           C_PLA1_TEST_FREQ_2_P1      = 11'h165,      
           C_PLA1_TEST_FREQ_3_P0      = 11'h166,      
           C_PLA1_TEST_FREQ_3_P1      = 11'h167,      
           C_PLA1_TEST_FREQ_4_P0      = 11'h168,      
           C_PLA1_TEST_FREQ_4_P1      = 11'h169,      
           C_PLA1_TEST_FREQ_5_P0      = 11'h16a,      
           C_PLA1_TEST_FREQ_5_P1      = 11'h16b,      
           C_PLA1_TEST_FREQ_6_P0      = 11'h16c,      
           C_PLA1_TEST_FREQ_6_P1      = 11'h16d,      
           C_PLA1_TEST_FREQ_7_P0      = 11'h16e,      
           C_PLA1_TEST_FREQ_7_P1      = 11'h16f,      
                                
           C_PLA2_TEST_FREQ_0_P0      = 11'h260,      
           C_PLA2_TEST_FREQ_0_P1      = 11'h261,      
           C_PLA2_TEST_FREQ_1_P0      = 11'h262,      
           C_PLA2_TEST_FREQ_1_P1      = 11'h263,      
           C_PLA2_TEST_FREQ_2_P0      = 11'h264,      
           C_PLA2_TEST_FREQ_2_P1      = 11'h265,      
           C_PLA2_TEST_FREQ_3_P0      = 11'h266,      
           C_PLA2_TEST_FREQ_3_P1      = 11'h267,      
           C_PLA2_TEST_FREQ_4_P0      = 11'h268,      
           C_PLA2_TEST_FREQ_4_P1      = 11'h269,      
           C_PLA2_TEST_FREQ_5_P0      = 11'h26a,      
           C_PLA2_TEST_FREQ_5_P1      = 11'h26b,      
           C_PLA2_TEST_FREQ_6_P0      = 11'h26c,      
           C_PLA2_TEST_FREQ_6_P1      = 11'h26d,      
           C_PLA2_TEST_FREQ_7_P0      = 11'h26e,      
           C_PLA2_TEST_FREQ_7_P1      = 11'h26f,      
                                
           C_PLA00_RMU_RATE           = 11'h070,   
           C_PLA01_RMU_RATE           = 11'h071,   
           C_PLA02_RMU_RATE           = 11'h072,   
           C_PLA03_RMU_RATE           = 11'h073,   
           C_PLA04_RMU_RATE           = 11'h074,   
           C_PLA05_RMU_RATE           = 11'h075,   
           C_PLA06_RMU_RATE           = 11'h076,   
           C_PLA07_RMU_RATE           = 11'h077,   
           C_PLA10_RMU_RATE           = 11'h170,     
           C_PLA11_RMU_RATE           = 11'h171,     
           C_PLA12_RMU_RATE           = 11'h172,     
           C_PLA13_RMU_RATE           = 11'h173,     
           C_PLA14_RMU_RATE           = 11'h174,     
           C_PLA15_RMU_RATE           = 11'h175,     
           C_PLA16_RMU_RATE           = 11'h176,     
           C_PLA17_RMU_RATE           = 11'h177,     
           C_PLA20_RMU_RATE           = 11'h270,     
           C_PLA21_RMU_RATE           = 11'h271,     
           C_PLA22_RMU_RATE           = 11'h272,     
           C_PLA23_RMU_RATE           = 11'h273,     
           C_PLA24_RMU_RATE           = 11'h274,     
           C_PLA25_RMU_RATE           = 11'h275,     
           C_PLA26_RMU_RATE           = 11'h276,     
           C_PLA27_RMU_RATE           = 11'h277,           
                                
           ///共用                  
           C_PLA0_RCU_MAC_P0         = 11'h300, ///RCU MAC地址低16位     
           C_PLA0_RCU_MAC_P1         = 11'h301, ///RCU MAC地址中16位     
           C_PLA0_RCU_MAC_P2         = 11'h302, ///RCU MAC地址高16位     
                                                                        
           C_PLA_TC_EN               = 11'h303, ///TC使能  1表示使能该空口的TC                 
           C_FLOW_FIFO_PAUSE_SET     = 11'h304, ///PLA前向FIFO PAUSE水位设置
           C_FLOW_FIFO_RESUME_SET    = 11'h305, ///PLA前向FIFO 解PAUSE水位设置
           C_FLOW_FIFO_OVERFLOW_SET  = 11'h306,           
                                    
                                    
           C_PLA_LOOP_EN             = 11'h310,  ///环回高有效  BIT0:rmuc外部10G SERDES环回 BIT1:rmuc内部10G环回 
           C_LOOP_REQUEST_IFG        = 11'h311,  ///反向数据带REQUEST报文间隔 16'h1400
           C_PLA_PASS_EN             = 11'h312, 
           C_PLA_LOOP_LINK_P0        = 11'h313, 
           C_PLA_LOOP_LINK_P1        = 11'h314, 
           
           C_PLA1_RCU_MAC_P0         = 11'h315, ///RCU MAC地址低16位     
           C_PLA1_RCU_MAC_P1         = 11'h316, ///RCU MAC地址中16位     
           C_PLA1_RCU_MAC_P2         = 11'h317, ///RCU MAC地址高16位     
                                                                         
           C_PLA2_RCU_MAC_P0         = 11'h318, ///RCU MAC地址低16位     
           C_PLA2_RCU_MAC_P1         = 11'h319, ///RCU MAC地址中16位     
           C_PLA2_RCU_MAC_P2         = 11'h31A, ///RCU MAC地址高16位     
           
           C_PLA_SLICE_WINDOW        = 11'h31B, // value 0xc00 for cub 
           C_PLA_CNT_CLEAR           = 11'h31C, 
            
           C_NUM_TEST_EN             = 11'h31D, 
           C_PLA_FOR_EN              = 11'h31E, 
           C_REQUEST_WAIT_TIME       = 11'h31F, 
           C_REQUEST_WAIT_EN         = 11'h320, 
           C_PLA_MU_AOU_SEL          = 11'h321, 
            
           C_PLA_INT_MASK            = 11'h322,
           C_PLA_INT_CLR             = 11'h323,
           C_PLA_RMU_INT             = 11'h324,  
           C_PLA_INT_EVENT           = 11'h325,
           C_PLA0_RMU_RATE_P0        = 11'h326,
           C_PLA0_RMU_RATE_P1        = 11'h327,
           C_PLA1_RMU_RATE_P0        = 11'h328,
           C_PLA1_RMU_RATE_P1        = 11'h329,
           C_PLA2_RMU_RATE_P0        = 11'h32A,
           C_PLA2_RMU_RATE_P1        = 11'h32B,
           C_PLA0_CU_RATE_CHG_CNT    = 11'h32C,
           C_PLA1_CU_RATE_CHG_CNT    = 11'h32D,
           C_PLA2_CU_RATE_CHG_CNT    = 11'h32E,
                                                
           C_PLA_AIR_LINK_CHANGE_MASK_P0 = 11'h32F,
           C_PLA_AIR_LINK_CHANGE_MASK_P1 = 11'h330,
           C_PLA_AIR_LINK_CHANGE_MASK_P2 = 11'h331,    
           
           C_PLA_AIR_LINK_CHANGE_FLG_P0  = 11'h332,    
           C_PLA_AIR_LINK_CHANGE_FLG_P1  = 11'h333,    
           C_PLA_AIR_LINK_CHANGE_FLG_P2  = 11'h334,    
                                                
           ///前向FPGA调试
           
           C_FLOW_FF0_FRAME_STAT_P0  = 11'h400,///only read
           C_FLOW_FF1_FRAME_STAT_P0  = 11'h401,
           C_FLOW_FF2_FRAME_STAT_P0  = 11'h402,
           C_FLOW_FF0_FRAME_STAT_P1  = 11'h403,
           C_FLOW_FF1_FRAME_STAT_P1  = 11'h404,  
           C_FLOW_FF2_FRAME_STAT_P1  = 11'h405,  
                                     
           C_FLOW_FF0_ERR_STAT_P0    = 11'h406,
           C_FLOW_FF1_ERR_STAT_P0    = 11'h407,
           C_FLOW_FF2_ERR_STAT_P0    = 11'h408,  
           C_FLOW_FF0_ERR_STAT_P1    = 11'h409,
           C_FLOW_FF1_ERR_STAT_P1    = 11'h40a,
           C_FLOW_FF2_ERR_STAT_P1    = 11'h40b,  
           C_FLOW_FF0_ERR_STAT_P2    = 11'h40c,
           C_FLOW_FF1_ERR_STAT_P2    = 11'h40d,
           C_FLOW_FF2_ERR_STAT_P2    = 11'h40e,             
                                                          
           C_PLA00_REQ_CHANGE_CNT    = 11'h412,   
           C_PLA01_REQ_CHANGE_CNT    = 11'h413,   
           C_PLA02_REQ_CHANGE_CNT    = 11'h414,   
           C_PLA03_REQ_CHANGE_CNT    = 11'h415,   
           C_PLA04_REQ_CHANGE_CNT    = 11'h416,   
           C_PLA05_REQ_CHANGE_CNT    = 11'h417,   
           C_PLA06_REQ_CHANGE_CNT    = 11'h418,   
           C_PLA07_REQ_CHANGE_CNT    = 11'h419,   
           C_PLA10_REQ_CHANGE_CNT    = 11'h41A,   
           C_PLA11_REQ_CHANGE_CNT    = 11'h41B,   
           C_PLA12_REQ_CHANGE_CNT    = 11'h41C,   
           C_PLA13_REQ_CHANGE_CNT    = 11'h41D,   
           C_PLA14_REQ_CHANGE_CNT    = 11'h41E,   
           C_PLA15_REQ_CHANGE_CNT    = 11'h41F,   
           C_PLA16_REQ_CHANGE_CNT    = 11'h420,   
           C_PLA17_REQ_CHANGE_CNT    = 11'h421,   
           C_PLA20_REQ_CHANGE_CNT    = 11'h422,   
           C_PLA21_REQ_CHANGE_CNT    = 11'h423,   
           C_PLA22_REQ_CHANGE_CNT    = 11'h424,   
           C_PLA23_REQ_CHANGE_CNT    = 11'h425,   
           C_PLA24_REQ_CHANGE_CNT    = 11'h426,   
           C_PLA25_REQ_CHANGE_CNT    = 11'h427,   
           C_PLA26_REQ_CHANGE_CNT    = 11'h428,   
           C_PLA27_REQ_CHANGE_CNT    = 11'h429, 
                                     
           C_PLA_TC_PROTECT_EN       = 11'h42A,  
           C_PLA_TC_PROTECT_CNT      = 11'h42B,  
           C_PLA0_TC_PROTECT_ERR_CNT = 11'h42C,  
           C_PLA1_TC_PROTECT_ERR_CNT = 11'h42D,  
           C_PLA2_TC_PROTECT_ERR_CNT = 11'h42E,  
           C_PLA_TC_PROTECT_OUT      = 11'h42F, 
             
           C_FOR_PLA_VERSION         = 11'h430, 
           
           C_FOR_FRAME_CNT           = 11'h431, 
           C_FOR_RST                 = 11'h432,
           C_FOR0_INPUT_CNT          = 11'h433,
           C_FOR1_INPUT_CNT          = 11'h434,
           C_FOR2_INPUT_CNT          = 11'h435,
           C_FOR3_INPUT_CNT          = 11'h436,
           
           C_PLA0_FORIN_CRCOK_CNT    = 11'h437,  ///PLA0前向CRC输入统计   B437 
           C_PLA0_FORIN_CRCERR_CNT   = 11'h438,  ///PLA1前向CRC输入统计   B438 
           C_PLA1_FORIN_CRCOK_CNT    = 11'h439,  ///PLA2前向CRC输入统计   B439 
           C_PLA1_FORIN_CRCERR_CNT   = 11'h43A,                                
           C_PLA2_FORIN_CRCOK_CNT    = 11'h43B,                                                              
           C_PLA2_FORIN_CRCERR_CNT   = 11'h43C,                                




           C_SLICE_FIFO0_LEN_ERR_P0  = 11'h440,
           C_SLICE_FIFO1_LEN_ERR_P0  = 11'h441,
           C_SLICE_FIFO2_LEN_ERR_P0  = 11'h442,
           C_SLICE_FIFO0_LEN_ERR_P1  = 11'h443,
           C_SLICE_FIFO1_LEN_ERR_P1  = 11'h444,
           C_SLICE_FIFO2_LEN_ERR_P1  = 11'h445,
           C_SLICE_FIFO0_LEN_ERR_P2  = 11'h446,
           C_SLICE_FIFO1_LEN_ERR_P2  = 11'h447,
           C_SLICE_FIFO2_LEN_ERR_P2  = 11'h448,
           
           C_FLOW_FF0_LEVEL          = 11'h449,
           C_FLOW_FF1_LEVEL          = 11'h44a,  
           C_FLOW_FF2_LEVEL          = 11'h44b,  

           C_FLOW0_FF_PARA_FULL_CNT  = 11'h44c,    /// PLA0 PARAMETER溢出统计    
           C_FLOW1_FF_PARA_FULL_CNT  = 11'h44d,    /// PLA1 PARAMETER溢出统计                          
           C_FLOW2_FF_PARA_FULL_CNT  = 11'h44e,    /// PLA2 PARAMETER溢出统计    
           
           C_FOR_FRAMER_55D5_CNT     = 11'h44f,        
           C_FOR_FRAMER_LOSE_CNT     = 11'h450,        
           C_FOR_FRAMER_LOSE_REG     = 11'h451,        
           
           C_PLA00_REQ_CNT           = 11'h452,  
           C_PLA01_REQ_CNT           = 11'h453,  
           C_PLA02_REQ_CNT           = 11'h454,  
           C_PLA03_REQ_CNT           = 11'h455,  
           C_PLA04_REQ_CNT           = 11'h456,  
           C_PLA05_REQ_CNT           = 11'h457,  
           C_PLA06_REQ_CNT           = 11'h458,  
           C_PLA07_REQ_CNT           = 11'h459,  
           C_PLA10_REQ_CNT           = 11'h45A,  
           C_PLA11_REQ_CNT           = 11'h45B,  
           C_PLA12_REQ_CNT           = 11'h45C,  
           C_PLA13_REQ_CNT           = 11'h45D,  
           C_PLA14_REQ_CNT           = 11'h45E,  
           C_PLA15_REQ_CNT           = 11'h45F,  
           C_PLA16_REQ_CNT           = 11'h460,  
           C_PLA17_REQ_CNT           = 11'h461,  
           C_PLA20_REQ_CNT           = 11'h462,  
           C_PLA21_REQ_CNT           = 11'h463,  
           C_PLA22_REQ_CNT           = 11'h464,  
           C_PLA23_REQ_CNT           = 11'h465,  
           C_PLA24_REQ_CNT           = 11'h466,  
           C_PLA25_REQ_CNT           = 11'h467,  
           C_PLA26_REQ_CNT           = 11'h468,  
           C_PLA27_REQ_CNT           = 11'h469, 
           
           C_FOR_EGMII_CRCERR_FRAME_CNT  = 11'h46a,  ////    
           C_FOR_EGMII_OUTPUT_FRAME_CNT  = 11'h46b,  ////    
           C_FOR_EGMII_REFRAMER_ERR_CNT  = 11'h46c,  ////    
           
           
           C_PLA00_REQ_RATE_CHG_CNT  = 11'h46d,  
           C_PLA01_REQ_RATE_CHG_CNT  = 11'h46e,  
           C_PLA02_REQ_RATE_CHG_CNT  = 11'h46f,  
           C_PLA03_REQ_RATE_CHG_CNT  = 11'h470,  
           C_PLA04_REQ_RATE_CHG_CNT  = 11'h471,  
           C_PLA05_REQ_RATE_CHG_CNT  = 11'h472,  
           C_PLA06_REQ_RATE_CHG_CNT  = 11'h473,  
           C_PLA07_REQ_RATE_CHG_CNT  = 11'h474,  
           C_PLA10_REQ_RATE_CHG_CNT  = 11'h475,  
           C_PLA11_REQ_RATE_CHG_CNT  = 11'h476,  
           C_PLA12_REQ_RATE_CHG_CNT  = 11'h477,  
           C_PLA13_REQ_RATE_CHG_CNT  = 11'h478,  
           C_PLA14_REQ_RATE_CHG_CNT  = 11'h479,  
           C_PLA15_REQ_RATE_CHG_CNT  = 11'h47a,  
           C_PLA16_REQ_RATE_CHG_CNT  = 11'h47b,  
           C_PLA17_REQ_RATE_CHG_CNT  = 11'h47c,  
           C_PLA20_REQ_RATE_CHG_CNT  = 11'h47d,  
           C_PLA21_REQ_RATE_CHG_CNT  = 11'h47e,  
           C_PLA22_REQ_RATE_CHG_CNT  = 11'h47f,  
           C_PLA23_REQ_RATE_CHG_CNT  = 11'h480,  
           C_PLA24_REQ_RATE_CHG_CNT  = 11'h481,  
           C_PLA25_REQ_RATE_CHG_CNT  = 11'h482,  
           C_PLA26_REQ_RATE_CHG_CNT  = 11'h483,  
           C_PLA27_REQ_RATE_CHG_CNT  = 11'h484,  
           
           C_RCUB_CHK_SEL            = 11'h485,  
           
           C_FLOW_FF0_FRAME_STAT_P2  = 11'h486,
           C_FLOW_FF1_FRAME_STAT_P2  = 11'h487,
           C_FLOW_FF2_FRAME_STAT_P2  = 11'h488,
           
           C_PLA0_AIR_UNLINK_CNT     = 11'h489,    /// PLA0 PARAMETER溢出统计    
           C_PLA1_AIR_UNLINK_CNT     = 11'h48a,    /// PLA1 PARAMETER溢出统计    
           C_PLA2_AIR_UNLINK_CNT     = 11'h48b,    /// PLA2 PARAMETER溢出统计    
           
           C_HC_FOR_EN               = 11'h48c,  
           
           C_SLICE_FIFO0_LEN_ERR_P3  = 11'h48d,
           C_SLICE_FIFO1_LEN_ERR_P3  = 11'h48e,
           C_SLICE_FIFO2_LEN_ERR_P3  = 11'h48f,
           C_FOR_FRAMER_ERR_CNT      = 11'h490,
           
           C_PLA0_PARA_ERR_STAT_P0   = 11'h491,  ///B491
           C_PLA1_PARA_ERR_STAT_P0   = 11'h492,  ///B492
           C_PLA2_PARA_ERR_STAT_P0   = 11'h493,  ///B493
           
           C_RATE_LIMIT_TEST         = 11'h494,
           
           C_SLICE_FIFO0_LEN_ERR_P4  = 11'h495,
           C_SLICE_FIFO1_LEN_ERR_P4  = 11'h496,
           C_SLICE_FIFO2_LEN_ERR_P4  = 11'h497,
           
           C_PLA0_PARA_ERR_STAT_P1   = 11'h498,  ///B498
           C_PLA1_PARA_ERR_STAT_P1   = 11'h499,  ///B499
           C_PLA2_PARA_ERR_STAT_P1   = 11'h49A,  ///B49A

			C_PLA_SLICE_MAC_ERR_CNT   = 11'h49b, 
			C_PLA_SLICE_LEN_ERR_CNT   = 11'h49c, 
           
           
          ///反向PLA调试 
           C_PLA_BACK_CRC_STAT        = 11'h500,
           C_PLA_BACK_STAT            = 11'h501,
           C_PLA0_BACK_SLICEOK_STAT   = 11'h502,
                                 
           C_PLA0_BACK_SLICEWR_CNT    = 11'h503,
           C_PLA0_BACK_SLICERD_CNT    = 11'h504, 
           C_PLA1_BACK_SLICEOK_STAT   = 11'h505,  
           C_PLA1_BACK_SLICEWR_CNT    = 11'h506,  
           C_PLA1_BACK_SLICERD_CNT    = 11'h507,  
           C_PLA2_BACK_SLICEOK_STAT   = 11'h508,  
           C_PLA2_BACK_SLICEWR_CNT    = 11'h509,  
           C_PLA2_BACK_SLICERD_CNT    = 11'h50a,  
           
           C_PLA0_REFLOW_RDERR_CNT_P0 = 11'h50b,
           C_PLA0_REFLOW_RDERR_CNT_P1 = 11'h50c,
           C_PLA1_REFLOW_RDERR_CNT_P0 = 11'h50d,  ///预留给1,2组
           C_PLA1_REFLOW_RDERR_CNT_P1 = 11'h50e,  ///
           C_PLA2_REFLOW_RDERR_CNT_P0 = 11'h50f,  ///
           C_PLA2_REFLOW_RDERR_CNT_P1 = 11'h510,  ///
           
           C_PLA0_REFLOW_ID_WL        = 11'h511,  ///预留给1,2组
           C_PLA1_REFLOW_ID_WL        = 11'h512,  ///           
           C_PLA2_REFLOW_ID_WL        = 11'h513,  ///           
           C_PLA_SLICE_ID_DEPTH_ALFUL = 11'h514,  ///
           
           C_PLA_REFRAMER_in_crcok_cnt    = 11'h515,  ///
           C_PLA_REFRAMER_in_crcerr_cnt   = 11'h516,  ///           
           C_PLA_REFRAMER_out_crcok_cnt   = 11'h517,  ///           
           C_PLA_REFRAMER_out_crcerr_cnt  = 11'h518,  ///
           
           C_BACPLA0_ALL_ERR_CNT          = 11'h519,
           C_BACPLA0_FIFOFULL_CNT         = 11'h51a,
           C_BAC_PLA0_RAM_FULL0_CNT       = 11'h51b,
           C_BACPLA0_LENGTH_ERR0_CNT      = 11'h51c,
           
           C_DDR_RDY                      = 11'h51d,
           
           
           C_DDR0_REFLOW_55D5_CNT_P0     = 11'h51e,  ///      
           C_DDR0_REFLOW_55D5_CNT_P1     = 11'h51f,  ///      
           C_DDR0_REFLOW_55D5_CNT_P2     = 11'h520,  ///      
           C_DDR0_REFLOW_LOSE_CNT_P0     = 11'h521, ///      
           C_DDR0_REFLOW_LOSE_CNT_P1     = 11'h522,  ///      
           C_DDR0_REFLOW_LOSE_CNT_P2     = 11'h523,  ///      
           C_DDR0_REFLOW_LOSE_REG        = 11'h524,  /// 
           
           C_PLA_BACK_FEEDBACK_CNT      =  11'h525,
           C_PLA_BACK_DROP_CNT          =  11'h526,
           C_PLA_STATE_CHANGE_CNT       =  11'h527,
           C_SLICE_CNT                  =  11'h528,
           C_SLICE_FIFO_EMPTY_PLA0      =  11'h529,
           
           C_PLA0_REFLOW_ID             = 11'h52A,  /// 
           C_PLA1_REFLOW_ID             = 11'h52B,  /// 
           C_PLA2_REFLOW_ID             = 11'h52C,  /// 
           
           C_PLA0_REFLOW_CURRENT_STATE  = 11'h52D,
           C_PLA1_REFLOW_CURRENT_STATE  = 11'h52E, 
           C_PLA2_REFLOW_CURRENT_STATE  = 11'h52F, 
           
           C_PLA0_BACK_REFAMEER_55D5_NUM= 11'h530,
           C_PLA0_BACK_REFAMEER_WR_FIFO_NUM=11'h531,
               
           C_BACK0_LOSE_NUM_CNT        = 11'h532,       ///B532   NUMBER测试PLA0组丢包统计  该寄存器需要环回使能,同时将
           C_BACK1_LOSE_NUM_CNT        = 11'h533,       ///B533   NUMBER测试PLA1组丢包统计
           C_BACK2_LOSE_NUM_CNT        = 11'h534,       ///B534   NUMBER测试PLA2组丢包统计
		   C_PLA0_SLICE_CRC_ERR_CNT	   = 11'h535,		///B535   (0x16a6a)DDR SLICE ERR 
		   C_PLA1_SLICE_CRC_ERR_CNT	   = 11'h536,		///B536   (0x16a6c)DDR SLICE ERR 
		   C_PLA2_SLICE_CRC_ERR_CNT	   = 11'h537,		///B537   (0x16a6e)DDR SLICE ERR 

		   C_DDR3A_APP_WDF_RDY_LOW_CNT_MAX = 11'h538,
		   C_DDR3A_WR_APP_RDY_LOW_CNT_MAX  = 11'h539,
		   C_DDR3A_RD_APP_RDY_LOW_CNT_MAX  = 11'h53a,
		   C_DDR3A_APP_WRITE_ERR_CNT	   = 11'h53b,
		   C_DDR3A_BUF_FULL_CNT			   = 11'h53c,
		   C_DDR3B_APP_WDF_RDY_LOW_CNT_MAX = 11'h53d,
		   C_DDR3B_WR_APP_RDY_LOW_CNT_MAX  = 11'h53e,
		   C_DDR3B_RD_APP_RDY_LOW_CNT_MAX  = 11'h53f,
		   C_DDR3B_APP_WRITE_ERR_CNT	   = 11'h540,
		   C_DDR3B_BUF_FULL_CNT			   = 11'h541,
		   C_PLA0_BACK_SDRM_USW_PAUSE      = 11'h542,
		   C_PLA1_BACK_SDRM_USW_PAUSE      = 11'h543,
		   C_PLA2_BACK_SDRM_USW_PAUSE      = 11'h544,
		   C_SLICE_RD_EN_VALID_CNT_FIX	   = 11'h545, 
		   C_PLA0_SLICE_ID_RANDOM_ORDER	   = 11'h546,	
		   C_PLA1_SLICE_ID_RANDOM_ORDER		= 11'h547,	
		   C_PLA2_SLICE_ID_RANDOM_ORDER		= 11'h548,	
		   C_PLA0_SLICE_ID_BOTTOM_ERR_CNT	= 11'h549,	
		   C_PLA1_SLICE_ID_BOTTOM_ERR_CNT	= 11'h54a,	
		   C_PLA2_SLICE_ID_BOTTOM_ERR_CNT	= 11'h54b,	
		   
		   		             
//pla_tc           
           C_PLA_TC_BYPASS             = 11'h600,
           C_CLEAR_FORWARD_EN          = 11'h601,
           C_CLEAR_EN                  = 11'h602,
           C_CLEAR_SUBPORT0_EN         = 11'h603,
           C_CLEAR_SUBPORT1_EN         = 11'h604,
           C_CLEAR_SUBPORT2_EN         = 11'h605,
           
           C_PKT_CNT_SLICE_IN_H        = 11'h606, 
           C_PKT_CNT_SLICE_IN_L        = 11'h607, 
           C_PTP_CNT_IN_H              = 11'h608, 
           C_PTP_CNT_IN_L              = 11'h609, 
           C_VLAN_PTP_CNT_IN_H         = 11'h610, 
           C_VLAN_PTP_CNT_IN_L         = 11'h611, 
           C_PTP_NO_VLAN_CNT_OUT_H     = 11'h612, 
           C_PTP_NO_VLAN_CNT_OUT_L     = 11'h613, 
           C_PTP_VLAN_CNT_OUT_H        = 11'h614, 
           C_PTP_VLAN_CNT_OUT_L        = 11'h615,
           C_SLICE_CNT_OUT_H           = 11'h616,
           C_SLICE_CNT_OUT_L           = 11'h617,
           C_PACKET_CNT_OUT_H          = 11'h618,
           C_PACKET_CNT_OUT_L          = 11'h619,
           
           C_1588_PACKET_IN_NUM        = 11'h620,
           C_1588_PACKET_OUT_NUM       = 11'h621,
           C_ALL_PACKET_IN_NUM         = 11'h622,
           C_ALL_PACKET_OUT_NUM        = 11'h623,
           C_PLA_SLICE_SA00_CNT        = 11'h624,
           C_PLA_SLICE_SA01_CNT        = 11'h625,
           C_PLA_SLICE_SA02_CNT        = 11'h626,
           C_PLA_SLICE_SA03_CNT        = 11'h627,
           C_PLA_SLICE_SA04_CNT        = 11'h628,
           C_PLA_SLICE_SA05_CNT        = 11'h629,
           C_PLA_SLICE_SA06_CNT        = 11'h630,
           C_PLA_SLICE_SA07_CNT        = 11'h631,
           C_PLA_SLICE_SA10_CNT        = 11'h632,
           C_PLA_SLICE_SA11_CNT        = 11'h633,
           C_PLA_SLICE_SA12_CNT        = 11'h634,
           C_PLA_SLICE_SA13_CNT        = 11'h635,
           C_PLA_SLICE_SA14_CNT        = 11'h636,
           C_PLA_SLICE_SA15_CNT        = 11'h637,
           C_PLA_SLICE_SA16_CNT        = 11'h638,
           C_PLA_SLICE_SA17_CNT        = 11'h639,
           C_PLA_SLICE_SA20_CNT        = 11'h640,
           C_PLA_SLICE_SA21_CNT        = 11'h641,
           C_PLA_SLICE_SA22_CNT        = 11'h642,
           C_PLA_SLICE_SA23_CNT        = 11'h643,
           C_PLA_SLICE_SA24_CNT        = 11'h644,
           C_PLA_SLICE_SA25_CNT        = 11'h645,
           C_PLA_SLICE_SA26_CNT        = 11'h646,
           C_PLA_SLICE_SA27_CNT        = 11'h647,
           C_STATE                     = 11'h648,
           C_FIFO_USEDW                = 11'h649,
           C_PLA_BACK_RST_CNT          = 11'h650,
           C_PLA_PAUSE_TIME_CNT        = 11'h651,
           C_PLA_BACK_PAUSE_EN         = 11'h652,
           C_PLA_OUT_INTER_SMALL_CNT   = 11'h653;

               
reg          S_lb_cs_n   ; /// localbus
reg          S_lb_we_n   ; /// localbus
reg          S_lb_rd_n   ; /// localbus
reg [10:0]   S_lb_addr   ; /// localbus    
reg [15:0]   S_lb_wr_data;    

always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
    begin
        S_lb_cs_n      <= 1'd1;
        S_lb_we_n      <= 1'd1;
        S_lb_rd_n      <= 1'd1;
        S_lb_addr      <= 11'd0;
        S_lb_wr_data   <= 16'd0;
    end
    else 
    begin
        S_lb_cs_n      <= I_lb_cs_n    ;
        S_lb_we_n      <= I_lb_we_n    ;
        S_lb_rd_n      <= I_lb_rd_n    ;
        S_lb_addr      <= I_lb_addr    ;
        S_lb_wr_data   <= I_lb_wr_data ;
    end
end
   
                                
always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
    begin
        O_module_rst           <= 16'b0 ; 
        O_rate_limit_test      <= 16'b0 ; 
        O_pla0_air_mac_0       <= 48'h01aabbccdd00 ;
        O_pla0_air_mac_1       <= 48'h02aabbccdd01 ;
        O_pla0_air_mac_2       <= 48'h04aabbccdd02 ;
        O_pla0_air_mac_3       <= 48'h08aabbccdd03 ;
        O_pla0_air_mac_4       <= 48'h10aabbccdd04 ;
        O_pla0_air_mac_5       <= 48'h20aabbccdd05 ;
        O_pla0_air_mac_6       <= 48'h40aabbccdd06 ;
        O_pla0_air_mac_7       <= 48'h80aabbccdd07 ;
        O_pla1_air_mac_0       <= 48'h01aabbccdd10 ;
        O_pla1_air_mac_1       <= 48'h02aabbccdd11 ;
        O_pla1_air_mac_2       <= 48'h04aabbccdd12 ;
        O_pla1_air_mac_3       <= 48'h08aabbccdd13 ;
        O_pla1_air_mac_4       <= 48'h10aabbccdd14 ;
        O_pla1_air_mac_5       <= 48'h20aabbccdd15 ;
        O_pla1_air_mac_6       <= 48'h40aabbccdd16 ;
        O_pla1_air_mac_7       <= 48'h80aabbccdd17 ;
        O_pla2_air_mac_0       <= 48'h01aabbccdd20 ;
        O_pla2_air_mac_1       <= 48'h02aabbccdd21 ;
        O_pla2_air_mac_2       <= 48'h04aabbccdd22 ;
        O_pla2_air_mac_3       <= 48'h08aabbccdd23 ;
        O_pla2_air_mac_4       <= 48'h10aabbccdd24 ;
        O_pla2_air_mac_5       <= 48'h20aabbccdd25 ;
        O_pla2_air_mac_6       <= 48'h40aabbccdd26 ;
        O_pla2_air_mac_7       <= 48'h80aabbccdd27 ;
        O_pla0_rcu_mac         <= 48'hffeeeeeeeef0 ;
        O_pla1_rcu_mac         <= 48'hffeeeeeeeef1 ;
        O_pla2_rcu_mac         <= 48'hffeeeeeeeef2 ;
        
        O_pla_tc_en            <= 3'd7       ;
        O_pla_for_en           <= 3'd0       ;
        O_pla0_tc_index        <= 8'd1       ;
        O_pla1_tc_index        <= 8'd1       ;
        O_pla2_tc_index        <= 8'd1       ;
        O_flow_fifo_pause_set  <= 16'h4da0;///16'h7d00 ;
        O_flow_fifo_resume_set <= 16'h2328;///16'h6d62 ;
        O_flow_fifo_overflow_set <= 16'h6D3f;

        O_pla_slice_window     <= 15'd1500   ;
        O_request_wait_time    <= 16'd2500   ;  ///10ms 4us单位
        O_request_wait_en      <= 1'd1         ;
        O_pla_mu_aou_sel       <= 1'd0       ;
        O_pla_air_link_change_mask <= 24'd0       ;
        
        O_pla_int_mask         <= 16'h0      ;
        O_pla_int_clr          <= 16'hffff   ;
        
        O_pla_loop_en          <= 3'd0     ;
        O_num_test_en          <= 1'b0       ;
        O_rcub_chk_sel         <= 2'd0       ;
       
        O_pla_pass_en          <= 2'd0     ; 
        O_loop_request_ifg     <= 16'h1400 ;
        O_pla_loop_link        <= 24'h0000ff ;
        O_cnt_clear            <= 16'h0     ;
        
        
        O_pla_tc_protect_en    <= 3'b111    ;
        O_pla_tc_protect_cnt   <= 16'hfff0    ;   ///10ms ///4us单位 发送间隔
                                        
        O_pla0_test_freq_0     <= {16'h0000,16'd1738};
        O_pla0_test_freq_1     <= {16'h0000,16'd1280};
        O_pla0_test_freq_2     <= {16'h0000,16'd1280};
        O_pla0_test_freq_3     <= {16'h0000,16'd1280};
        O_pla0_test_freq_4     <= {16'h0000,16'd1280};
        O_pla0_test_freq_5     <= {16'h0000,16'd1280};
        O_pla0_test_freq_6     <= {16'h0000,16'd1280};
        O_pla0_test_freq_7     <= {16'h0000,16'd1280};
        O_pla1_test_freq_0     <= {16'h0000,16'd1280};
        O_pla1_test_freq_1     <= {16'h0000,16'd1280};
        O_pla1_test_freq_2     <= {16'h0000,16'd1280};
        O_pla1_test_freq_3     <= {16'h0000,16'd1280};
        O_pla1_test_freq_4     <= {16'h0000,16'd1280};
        O_pla1_test_freq_5     <= {16'h0000,16'd1280};
        O_pla1_test_freq_6     <= {16'h0000,16'd1280};
        O_pla1_test_freq_7     <= {16'h0000,16'd1280};
        O_pla2_test_freq_0     <= {16'h0000,16'd1280};
        O_pla2_test_freq_1     <= {16'h0000,16'd1280};
        O_pla2_test_freq_2     <= {16'h0000,16'd1280};
        O_pla2_test_freq_3     <= {16'h0000,16'd1280};
        O_pla2_test_freq_4     <= {16'h0000,16'd1280};
        O_pla2_test_freq_5     <= {16'h0000,16'd1280};
        O_pla2_test_freq_6     <= {16'h0000,16'd1280};
        O_pla2_test_freq_7     <= {16'h0000,16'd1280};
        
        O_pla_tc_bypass        <= 2'h0;
        O_clear_forward_en     <= 7'h0;
        O_clear_en             <= 4'h0;
        O_clear_subport0_en    <= 8'h0;
        O_clear_subport1_en    <= 8'h0;
        O_clear_subport2_en    <= 8'h0;
        O_pause_en             <= 1'b0;
		O_slice_rd_en_valid_cnt_fix	<= 6'd40		;
    end
    else if(!S_lb_cs_n && !S_lb_we_n)
    begin
        case(S_lb_addr)            
            C_PLA0_AIR_MAC_0_P0        : O_pla0_air_mac_0[15:0]   <= S_lb_wr_data;
            C_PLA0_AIR_MAC_1_P0        : O_pla0_air_mac_1[15:0]   <= S_lb_wr_data;
            C_PLA0_AIR_MAC_2_P0        : O_pla0_air_mac_2[15:0]   <= S_lb_wr_data;
            C_PLA0_AIR_MAC_3_P0        : O_pla0_air_mac_3[15:0]   <= S_lb_wr_data;
            C_PLA0_AIR_MAC_4_P0        : O_pla0_air_mac_4[15:0]   <= S_lb_wr_data;
            C_PLA0_AIR_MAC_5_P0        : O_pla0_air_mac_5[15:0]   <= S_lb_wr_data;
            C_PLA0_AIR_MAC_6_P0        : O_pla0_air_mac_6[15:0]   <= S_lb_wr_data;
            C_PLA0_AIR_MAC_7_P0        : O_pla0_air_mac_7[15:0]   <= S_lb_wr_data;
            C_PLA0_AIR_MAC_0_P1        : O_pla0_air_mac_0[31:16]  <= S_lb_wr_data;
            C_PLA0_AIR_MAC_1_P1        : O_pla0_air_mac_1[31:16]  <= S_lb_wr_data;
            C_PLA0_AIR_MAC_2_P1        : O_pla0_air_mac_2[31:16]  <= S_lb_wr_data;
            C_PLA0_AIR_MAC_3_P1        : O_pla0_air_mac_3[31:16]  <= S_lb_wr_data;
            C_PLA0_AIR_MAC_4_P1        : O_pla0_air_mac_4[31:16]  <= S_lb_wr_data;
            C_PLA0_AIR_MAC_5_P1        : O_pla0_air_mac_5[31:16]  <= S_lb_wr_data;
            C_PLA0_AIR_MAC_6_P1        : O_pla0_air_mac_6[31:16]  <= S_lb_wr_data;
            C_PLA0_AIR_MAC_7_P1        : O_pla0_air_mac_7[31:16]  <= S_lb_wr_data;
            C_PLA0_AIR_MAC_0_P2        : O_pla0_air_mac_0[47:32]  <= S_lb_wr_data;
            C_PLA0_AIR_MAC_1_P2        : O_pla0_air_mac_1[47:32]  <= S_lb_wr_data;
            C_PLA0_AIR_MAC_2_P2        : O_pla0_air_mac_2[47:32]  <= S_lb_wr_data;
            C_PLA0_AIR_MAC_3_P2        : O_pla0_air_mac_3[47:32]  <= S_lb_wr_data;
            C_PLA0_AIR_MAC_4_P2        : O_pla0_air_mac_4[47:32]  <= S_lb_wr_data;
            C_PLA0_AIR_MAC_5_P2        : O_pla0_air_mac_5[47:32]  <= S_lb_wr_data;
            C_PLA0_AIR_MAC_6_P2        : O_pla0_air_mac_6[47:32]  <= S_lb_wr_data;
            C_PLA0_AIR_MAC_7_P2        : O_pla0_air_mac_7[47:32]  <= S_lb_wr_data;
                                       
            C_PLA1_AIR_MAC_0_P0        : O_pla1_air_mac_0[15:0]   <= S_lb_wr_data;
            C_PLA1_AIR_MAC_1_P0        : O_pla1_air_mac_1[15:0]   <= S_lb_wr_data;
            C_PLA1_AIR_MAC_2_P0        : O_pla1_air_mac_2[15:0]   <= S_lb_wr_data;
            C_PLA1_AIR_MAC_3_P0        : O_pla1_air_mac_3[15:0]   <= S_lb_wr_data;
            C_PLA1_AIR_MAC_4_P0        : O_pla1_air_mac_4[15:0]   <= S_lb_wr_data;
            C_PLA1_AIR_MAC_5_P0        : O_pla1_air_mac_5[15:0]   <= S_lb_wr_data;
            C_PLA1_AIR_MAC_6_P0        : O_pla1_air_mac_6[15:0]   <= S_lb_wr_data;
            C_PLA1_AIR_MAC_7_P0        : O_pla1_air_mac_7[15:0]   <= S_lb_wr_data;
            C_PLA1_AIR_MAC_0_P1        : O_pla1_air_mac_0[31:16]  <= S_lb_wr_data;
            C_PLA1_AIR_MAC_1_P1        : O_pla1_air_mac_1[31:16]  <= S_lb_wr_data;
            C_PLA1_AIR_MAC_2_P1        : O_pla1_air_mac_2[31:16]  <= S_lb_wr_data;
            C_PLA1_AIR_MAC_3_P1        : O_pla1_air_mac_3[31:16]  <= S_lb_wr_data;
            C_PLA1_AIR_MAC_4_P1        : O_pla1_air_mac_4[31:16]  <= S_lb_wr_data;
            C_PLA1_AIR_MAC_5_P1        : O_pla1_air_mac_5[31:16]  <= S_lb_wr_data;
            C_PLA1_AIR_MAC_6_P1        : O_pla1_air_mac_6[31:16]  <= S_lb_wr_data;
            C_PLA1_AIR_MAC_7_P1        : O_pla1_air_mac_7[31:16]  <= S_lb_wr_data;
            C_PLA1_AIR_MAC_0_P2        : O_pla1_air_mac_0[47:32]  <= S_lb_wr_data;
            C_PLA1_AIR_MAC_1_P2        : O_pla1_air_mac_1[47:32]  <= S_lb_wr_data;
            C_PLA1_AIR_MAC_2_P2        : O_pla1_air_mac_2[47:32]  <= S_lb_wr_data;
            C_PLA1_AIR_MAC_3_P2        : O_pla1_air_mac_3[47:32]  <= S_lb_wr_data;
            C_PLA1_AIR_MAC_4_P2        : O_pla1_air_mac_4[47:32]  <= S_lb_wr_data;
            C_PLA1_AIR_MAC_5_P2        : O_pla1_air_mac_5[47:32]  <= S_lb_wr_data;
            C_PLA1_AIR_MAC_6_P2        : O_pla1_air_mac_6[47:32]  <= S_lb_wr_data;
            C_PLA1_AIR_MAC_7_P2        : O_pla1_air_mac_7[47:32]  <= S_lb_wr_data;
                                       
            C_PLA2_AIR_MAC_0_P0        : O_pla2_air_mac_0[15:0]   <= S_lb_wr_data;
            C_PLA2_AIR_MAC_1_P0        : O_pla2_air_mac_1[15:0]   <= S_lb_wr_data;
            C_PLA2_AIR_MAC_2_P0        : O_pla2_air_mac_2[15:0]   <= S_lb_wr_data;
            C_PLA2_AIR_MAC_3_P0        : O_pla2_air_mac_3[15:0]   <= S_lb_wr_data;
            C_PLA2_AIR_MAC_4_P0        : O_pla2_air_mac_4[15:0]   <= S_lb_wr_data;
            C_PLA2_AIR_MAC_5_P0        : O_pla2_air_mac_5[15:0]   <= S_lb_wr_data;
            C_PLA2_AIR_MAC_6_P0        : O_pla2_air_mac_6[15:0]   <= S_lb_wr_data;
            C_PLA2_AIR_MAC_7_P0        : O_pla2_air_mac_7[15:0]   <= S_lb_wr_data;
            C_PLA2_AIR_MAC_0_P1        : O_pla2_air_mac_0[31:16]  <= S_lb_wr_data;
            C_PLA2_AIR_MAC_1_P1        : O_pla2_air_mac_1[31:16]  <= S_lb_wr_data;
            C_PLA2_AIR_MAC_2_P1        : O_pla2_air_mac_2[31:16]  <= S_lb_wr_data;
            C_PLA2_AIR_MAC_3_P1        : O_pla2_air_mac_3[31:16]  <= S_lb_wr_data;
            C_PLA2_AIR_MAC_4_P1        : O_pla2_air_mac_4[31:16]  <= S_lb_wr_data;
            C_PLA2_AIR_MAC_5_P1        : O_pla2_air_mac_5[31:16]  <= S_lb_wr_data;
            C_PLA2_AIR_MAC_6_P1        : O_pla2_air_mac_6[31:16]  <= S_lb_wr_data;
            C_PLA2_AIR_MAC_7_P1        : O_pla2_air_mac_7[31:16]  <= S_lb_wr_data;
            C_PLA2_AIR_MAC_0_P2        : O_pla2_air_mac_0[47:32]  <= S_lb_wr_data;
            C_PLA2_AIR_MAC_1_P2        : O_pla2_air_mac_1[47:32]  <= S_lb_wr_data;
            C_PLA2_AIR_MAC_2_P2        : O_pla2_air_mac_2[47:32]  <= S_lb_wr_data;
            C_PLA2_AIR_MAC_3_P2        : O_pla2_air_mac_3[47:32]  <= S_lb_wr_data;
            C_PLA2_AIR_MAC_4_P2        : O_pla2_air_mac_4[47:32]  <= S_lb_wr_data;
            C_PLA2_AIR_MAC_5_P2        : O_pla2_air_mac_5[47:32]  <= S_lb_wr_data;
            C_PLA2_AIR_MAC_6_P2        : O_pla2_air_mac_6[47:32]  <= S_lb_wr_data;
            C_PLA2_AIR_MAC_7_P2        : O_pla2_air_mac_7[47:32]  <= S_lb_wr_data;     
                                                       
            C_PLA0_RCU_MAC_P0          : O_pla0_rcu_mac[15:0]      <= S_lb_wr_data;     
            C_PLA0_RCU_MAC_P1          : O_pla0_rcu_mac[31:16]     <= S_lb_wr_data;     
            C_PLA0_RCU_MAC_P2          : O_pla0_rcu_mac[47:32]     <= S_lb_wr_data;  
            
            C_PLA1_RCU_MAC_P0          : O_pla1_rcu_mac[15:0]      <= S_lb_wr_data;     
            C_PLA1_RCU_MAC_P1          : O_pla1_rcu_mac[31:16]     <= S_lb_wr_data;     
            C_PLA1_RCU_MAC_P2          : O_pla1_rcu_mac[47:32]     <= S_lb_wr_data;     
                               
            C_PLA2_RCU_MAC_P0          : O_pla2_rcu_mac[15:0]      <= S_lb_wr_data;     
            C_PLA2_RCU_MAC_P1          : O_pla2_rcu_mac[31:16]     <= S_lb_wr_data;     
            C_PLA2_RCU_MAC_P2          : O_pla2_rcu_mac[47:32]     <= S_lb_wr_data;     
                                       
            C_PLA_TC_EN                : O_pla_tc_en              <= S_lb_wr_data[2:0];     
            C_PLA_FOR_EN               : O_pla_for_en             <= S_lb_wr_data[2:0];     
            C_PLA0_TC_INDEX            : O_pla0_tc_index          <= S_lb_wr_data[7:0];  
            C_PLA1_TC_INDEX            : O_pla1_tc_index          <= S_lb_wr_data[7:0];  
            C_PLA2_TC_INDEX            : O_pla2_tc_index          <= S_lb_wr_data[7:0];   
            C_FLOW_FIFO_PAUSE_SET      : O_flow_fifo_pause_set    <= S_lb_wr_data;     
            C_FLOW_FIFO_RESUME_SET     : O_flow_fifo_resume_set   <= S_lb_wr_data; 
            
            C_FLOW_FIFO_OVERFLOW_SET   : O_flow_fifo_overflow_set <= S_lb_wr_data; 
            C_PLA_SLICE_WINDOW         : O_pla_slice_window       <= S_lb_wr_data[14:0]; 
            C_REQUEST_WAIT_TIME        : O_request_wait_time      <= S_lb_wr_data[15:0];       
            C_REQUEST_WAIT_EN          : O_request_wait_en        <= S_lb_wr_data[0]; 
            C_PLA_MU_AOU_SEL           : O_pla_mu_aou_sel         <= S_lb_wr_data[2:0];   
            
            C_PLA_INT_MASK             : O_pla_int_mask           <= S_lb_wr_data[15:0];      
            C_PLA_INT_CLR              : O_pla_int_clr            <= S_lb_wr_data[15:0];    
            
            C_PLA_AIR_LINK_CHANGE_MASK_P0 : O_pla_air_link_change_mask[7:0]  <= S_lb_wr_data[7:0];   
            C_PLA_AIR_LINK_CHANGE_MASK_P1 : O_pla_air_link_change_mask[15:8] <= S_lb_wr_data[7:0]; 
            C_PLA_AIR_LINK_CHANGE_MASK_P2 : O_pla_air_link_change_mask[23:16]<= S_lb_wr_data[7:0];
            
            C_PLA_LOOP_EN              : O_pla_loop_en            <= S_lb_wr_data[2:0];
            C_PLA_PASS_EN              : O_pla_pass_en            <= S_lb_wr_data[1:0]; 
            C_LOOP_REQUEST_IFG         : O_loop_request_ifg       <= S_lb_wr_data[15:0];
            C_PLA_LOOP_LINK_P0         : O_pla_loop_link[15:0]    <= S_lb_wr_data[15:0];
            C_PLA_LOOP_LINK_P1         : O_pla_loop_link[23:16]   <= S_lb_wr_data[7:0];

            C_PLA_CNT_CLEAR            : O_cnt_clear              <= S_lb_wr_data[15:0];

            C_NUM_TEST_EN              : O_num_test_en            <= S_lb_wr_data[0];
            C_RCUB_CHK_SEL             : O_rcub_chk_sel           <= S_lb_wr_data[1:0];
                      
            C_PLA0_TEST_FREQ_0_P0      : O_pla0_test_freq_0[15:0]       <= S_lb_wr_data;   
            C_PLA0_TEST_FREQ_0_P1      : O_pla0_test_freq_0[31:16]      <= S_lb_wr_data;   
            C_PLA0_TEST_FREQ_1_P0      : O_pla0_test_freq_1[15:0]       <= S_lb_wr_data;   
            C_PLA0_TEST_FREQ_1_P1      : O_pla0_test_freq_1[31:16]      <= S_lb_wr_data;        
            C_PLA0_TEST_FREQ_2_P0      : O_pla0_test_freq_2[15:0]       <= S_lb_wr_data;   
            C_PLA0_TEST_FREQ_2_P1      : O_pla0_test_freq_2[31:16]      <= S_lb_wr_data;               
            C_PLA0_TEST_FREQ_3_P0      : O_pla0_test_freq_3[15:0]       <= S_lb_wr_data;   
            C_PLA0_TEST_FREQ_3_P1      : O_pla0_test_freq_3[31:16]      <= S_lb_wr_data;      
            C_PLA0_TEST_FREQ_4_P0      : O_pla0_test_freq_4[15:0]       <= S_lb_wr_data;   
            C_PLA0_TEST_FREQ_4_P1      : O_pla0_test_freq_4[31:16]      <= S_lb_wr_data;   
            C_PLA0_TEST_FREQ_5_P0      : O_pla0_test_freq_5[15:0]       <= S_lb_wr_data;   
            C_PLA0_TEST_FREQ_5_P1      : O_pla0_test_freq_5[31:16]      <= S_lb_wr_data;   
            C_PLA0_TEST_FREQ_6_P0      : O_pla0_test_freq_6[15:0]       <= S_lb_wr_data;   
            C_PLA0_TEST_FREQ_6_P1      : O_pla0_test_freq_6[31:16]      <= S_lb_wr_data;   
            C_PLA0_TEST_FREQ_7_P0      : O_pla0_test_freq_7[15:0]       <= S_lb_wr_data;   
            C_PLA0_TEST_FREQ_7_P1      : O_pla0_test_freq_7[31:16]      <= S_lb_wr_data;                
              
            C_PLA1_TEST_FREQ_0_P0      : O_pla1_test_freq_0[15:0]       <= S_lb_wr_data;   
            C_PLA1_TEST_FREQ_0_P1      : O_pla1_test_freq_0[31:16]      <= S_lb_wr_data;   
            C_PLA1_TEST_FREQ_1_P0      : O_pla1_test_freq_1[15:0]       <= S_lb_wr_data;   
            C_PLA1_TEST_FREQ_1_P1      : O_pla1_test_freq_1[31:16]      <= S_lb_wr_data;        
            C_PLA1_TEST_FREQ_2_P0      : O_pla1_test_freq_2[15:0]       <= S_lb_wr_data;   
            C_PLA1_TEST_FREQ_2_P1      : O_pla1_test_freq_2[31:16]      <= S_lb_wr_data;               
            C_PLA1_TEST_FREQ_3_P0      : O_pla1_test_freq_3[15:0]       <= S_lb_wr_data;   
            C_PLA1_TEST_FREQ_3_P1      : O_pla1_test_freq_3[31:16]      <= S_lb_wr_data;      
            C_PLA1_TEST_FREQ_4_P0      : O_pla1_test_freq_4[15:0]       <= S_lb_wr_data;   
            C_PLA1_TEST_FREQ_4_P1      : O_pla1_test_freq_4[31:16]      <= S_lb_wr_data;   
            C_PLA1_TEST_FREQ_5_P0      : O_pla1_test_freq_5[15:0]       <= S_lb_wr_data;   
            C_PLA1_TEST_FREQ_5_P1      : O_pla1_test_freq_5[31:16]      <= S_lb_wr_data;   
            C_PLA1_TEST_FREQ_6_P0      : O_pla1_test_freq_6[15:0]       <= S_lb_wr_data;   
            C_PLA1_TEST_FREQ_6_P1      : O_pla1_test_freq_6[31:16]      <= S_lb_wr_data;   
            C_PLA1_TEST_FREQ_7_P0      : O_pla1_test_freq_7[15:0]       <= S_lb_wr_data;   
            C_PLA1_TEST_FREQ_7_P1      : O_pla1_test_freq_7[31:16]      <= S_lb_wr_data;  
              
            C_PLA2_TEST_FREQ_0_P0      : O_pla2_test_freq_0[15:0]       <= S_lb_wr_data;   
            C_PLA2_TEST_FREQ_0_P1      : O_pla2_test_freq_0[31:16]      <= S_lb_wr_data;   
            C_PLA2_TEST_FREQ_1_P0      : O_pla2_test_freq_1[15:0]       <= S_lb_wr_data;   
            C_PLA2_TEST_FREQ_1_P1      : O_pla2_test_freq_1[31:16]      <= S_lb_wr_data;        
            C_PLA2_TEST_FREQ_2_P0      : O_pla2_test_freq_2[15:0]       <= S_lb_wr_data;   
            C_PLA2_TEST_FREQ_2_P1      : O_pla2_test_freq_2[31:16]      <= S_lb_wr_data;               
            C_PLA2_TEST_FREQ_3_P0      : O_pla2_test_freq_3[15:0]       <= S_lb_wr_data;   
            C_PLA2_TEST_FREQ_3_P1      : O_pla2_test_freq_3[31:16]      <= S_lb_wr_data;      
            C_PLA2_TEST_FREQ_4_P0      : O_pla2_test_freq_4[15:0]       <= S_lb_wr_data;   
            C_PLA2_TEST_FREQ_4_P1      : O_pla2_test_freq_4[31:16]      <= S_lb_wr_data;   
            C_PLA2_TEST_FREQ_5_P0      : O_pla2_test_freq_5[15:0]       <= S_lb_wr_data;   
            C_PLA2_TEST_FREQ_5_P1      : O_pla2_test_freq_5[31:16]      <= S_lb_wr_data;   
            C_PLA2_TEST_FREQ_6_P0      : O_pla2_test_freq_6[15:0]       <= S_lb_wr_data;   
            C_PLA2_TEST_FREQ_6_P1      : O_pla2_test_freq_6[31:16]      <= S_lb_wr_data;   
            C_PLA2_TEST_FREQ_7_P0      : O_pla2_test_freq_7[15:0]       <= S_lb_wr_data;   
            C_PLA2_TEST_FREQ_7_P1      : O_pla2_test_freq_7[31:16]      <= S_lb_wr_data;             
 
            
            C_PLA_TC_PROTECT_EN        : O_pla_tc_protect_en      <= S_lb_wr_data[2:0];    
            C_PLA_TC_PROTECT_CNT       : O_pla_tc_protect_cnt     <= S_lb_wr_data     ;    
            C_FOR_RST                  : O_module_rst                  <= S_lb_wr_data[15:0]     ; 
            C_RATE_LIMIT_TEST          : O_rate_limit_test             <= S_lb_wr_data[15:0]     ; 
//pla_tc
            C_PLA_TC_BYPASS           : O_pla_tc_bypass                <= S_lb_wr_data[1:0];
            C_CLEAR_FORWARD_EN        : O_clear_forward_en             <= S_lb_wr_data[6:0];
            C_CLEAR_EN                : O_clear_en                     <= S_lb_wr_data[3:0];
            C_CLEAR_SUBPORT0_EN       : O_clear_subport0_en            <= S_lb_wr_data[7:0];
            C_CLEAR_SUBPORT1_EN       : O_clear_subport1_en            <= S_lb_wr_data[7:0];
            C_CLEAR_SUBPORT2_EN       : O_clear_subport2_en            <= S_lb_wr_data[7:0];
            C_PLA_BACK_PAUSE_EN       : O_pause_en                     <= S_lb_wr_data[0]  ;
			C_SLICE_RD_EN_VALID_CNT_FIX	: O_slice_rd_en_valid_cnt_fix	<= 	S_lb_wr_data[5:0]	;
            default :;
        endcase
    end
    else
    begin
        O_pla_int_clr          <= 16'hffff   ;
    end
end



always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
    begin
        O_lb_rd_data <= 16'd0;
    end
    else if((!S_lb_cs_n) && (!S_lb_rd_n))   
    begin
        case(S_lb_addr)       
            C_PLA0_AIR_MAC_0_P0        : O_lb_rd_data  <= O_pla0_air_mac_0[15:0]   ;
            C_PLA0_AIR_MAC_1_P0        : O_lb_rd_data  <= O_pla0_air_mac_1[15:0]   ;
            C_PLA0_AIR_MAC_2_P0        : O_lb_rd_data  <= O_pla0_air_mac_2[15:0]   ;
            C_PLA0_AIR_MAC_3_P0        : O_lb_rd_data  <= O_pla0_air_mac_3[15:0]   ;
            C_PLA0_AIR_MAC_4_P0        : O_lb_rd_data  <= O_pla0_air_mac_4[15:0]   ;
            C_PLA0_AIR_MAC_5_P0        : O_lb_rd_data  <= O_pla0_air_mac_5[15:0]   ;
            C_PLA0_AIR_MAC_6_P0        : O_lb_rd_data  <= O_pla0_air_mac_6[15:0]   ;
            C_PLA0_AIR_MAC_7_P0        : O_lb_rd_data  <= O_pla0_air_mac_7[15:0]   ;
            C_PLA0_AIR_MAC_0_P1        : O_lb_rd_data  <= O_pla0_air_mac_0[31:16]  ;
            C_PLA0_AIR_MAC_1_P1        : O_lb_rd_data  <= O_pla0_air_mac_1[31:16]  ;
            C_PLA0_AIR_MAC_2_P1        : O_lb_rd_data  <= O_pla0_air_mac_2[31:16]  ;
            C_PLA0_AIR_MAC_3_P1        : O_lb_rd_data  <= O_pla0_air_mac_3[31:16]  ;
            C_PLA0_AIR_MAC_4_P1        : O_lb_rd_data  <= O_pla0_air_mac_4[31:16]  ;
            C_PLA0_AIR_MAC_5_P1        : O_lb_rd_data  <= O_pla0_air_mac_5[31:16]  ;
            C_PLA0_AIR_MAC_6_P1        : O_lb_rd_data  <= O_pla0_air_mac_6[31:16]  ;
            C_PLA0_AIR_MAC_7_P1        : O_lb_rd_data  <= O_pla0_air_mac_7[31:16]  ;
            C_PLA0_AIR_MAC_0_P2        : O_lb_rd_data  <= O_pla0_air_mac_0[47:32]  ;
            C_PLA0_AIR_MAC_1_P2        : O_lb_rd_data  <= O_pla0_air_mac_1[47:32]  ;
            C_PLA0_AIR_MAC_2_P2        : O_lb_rd_data  <= O_pla0_air_mac_2[47:32]  ;
            C_PLA0_AIR_MAC_3_P2        : O_lb_rd_data  <= O_pla0_air_mac_3[47:32]  ;
            C_PLA0_AIR_MAC_4_P2        : O_lb_rd_data  <= O_pla0_air_mac_4[47:32]  ;
            C_PLA0_AIR_MAC_5_P2        : O_lb_rd_data  <= O_pla0_air_mac_5[47:32]  ;
            C_PLA0_AIR_MAC_6_P2        : O_lb_rd_data  <= O_pla0_air_mac_6[47:32]  ;
            C_PLA0_AIR_MAC_7_P2        : O_lb_rd_data  <= O_pla0_air_mac_7[47:32]  ;
                                                                                  
            C_PLA1_AIR_MAC_0_P0        : O_lb_rd_data  <= O_pla1_air_mac_0[15:0]   ;
            C_PLA1_AIR_MAC_1_P0        : O_lb_rd_data  <= O_pla1_air_mac_1[15:0]   ;
            C_PLA1_AIR_MAC_2_P0        : O_lb_rd_data  <= O_pla1_air_mac_2[15:0]   ;
            C_PLA1_AIR_MAC_3_P0        : O_lb_rd_data  <= O_pla1_air_mac_3[15:0]   ;
            C_PLA1_AIR_MAC_4_P0        : O_lb_rd_data  <= O_pla1_air_mac_4[15:0]   ;
            C_PLA1_AIR_MAC_5_P0        : O_lb_rd_data  <= O_pla1_air_mac_5[15:0]   ;
            C_PLA1_AIR_MAC_6_P0        : O_lb_rd_data  <= O_pla1_air_mac_6[15:0]   ;
            C_PLA1_AIR_MAC_7_P0        : O_lb_rd_data  <= O_pla1_air_mac_7[15:0]   ;
            C_PLA1_AIR_MAC_0_P1        : O_lb_rd_data  <= O_pla1_air_mac_0[31:16]  ;
            C_PLA1_AIR_MAC_1_P1        : O_lb_rd_data  <= O_pla1_air_mac_1[31:16]  ;
            C_PLA1_AIR_MAC_2_P1        : O_lb_rd_data  <= O_pla1_air_mac_2[31:16]  ;
            C_PLA1_AIR_MAC_3_P1        : O_lb_rd_data  <= O_pla1_air_mac_3[31:16]  ;
            C_PLA1_AIR_MAC_4_P1        : O_lb_rd_data  <= O_pla1_air_mac_4[31:16]  ;
            C_PLA1_AIR_MAC_5_P1        : O_lb_rd_data  <= O_pla1_air_mac_5[31:16]  ;
            C_PLA1_AIR_MAC_6_P1        : O_lb_rd_data  <= O_pla1_air_mac_6[31:16]  ;
            C_PLA1_AIR_MAC_7_P1        : O_lb_rd_data  <= O_pla1_air_mac_7[31:16]  ;
            C_PLA1_AIR_MAC_0_P2        : O_lb_rd_data  <= O_pla1_air_mac_0[47:32]  ;
            C_PLA1_AIR_MAC_1_P2        : O_lb_rd_data  <= O_pla1_air_mac_1[47:32]  ;
            C_PLA1_AIR_MAC_2_P2        : O_lb_rd_data  <= O_pla1_air_mac_2[47:32]  ;
            C_PLA1_AIR_MAC_3_P2        : O_lb_rd_data  <= O_pla1_air_mac_3[47:32]  ;
            C_PLA1_AIR_MAC_4_P2        : O_lb_rd_data  <= O_pla1_air_mac_4[47:32]  ;
            C_PLA1_AIR_MAC_5_P2        : O_lb_rd_data  <= O_pla1_air_mac_5[47:32]  ;
            C_PLA1_AIR_MAC_6_P2        : O_lb_rd_data  <= O_pla1_air_mac_6[47:32]  ;
            C_PLA1_AIR_MAC_7_P2        : O_lb_rd_data  <= O_pla1_air_mac_7[47:32]  ;
                                                                                   
            C_PLA2_AIR_MAC_0_P0        : O_lb_rd_data  <= O_pla2_air_mac_0[15:0]   ;
            C_PLA2_AIR_MAC_1_P0        : O_lb_rd_data  <= O_pla2_air_mac_1[15:0]   ;
            C_PLA2_AIR_MAC_2_P0        : O_lb_rd_data  <= O_pla2_air_mac_2[15:0]   ;
            C_PLA2_AIR_MAC_3_P0        : O_lb_rd_data  <= O_pla2_air_mac_3[15:0]   ;
            C_PLA2_AIR_MAC_4_P0        : O_lb_rd_data  <= O_pla2_air_mac_4[15:0]   ;
            C_PLA2_AIR_MAC_5_P0        : O_lb_rd_data  <= O_pla2_air_mac_5[15:0]   ;
            C_PLA2_AIR_MAC_6_P0        : O_lb_rd_data  <= O_pla2_air_mac_6[15:0]   ;
            C_PLA2_AIR_MAC_7_P0        : O_lb_rd_data  <= O_pla2_air_mac_7[15:0]   ;
            C_PLA2_AIR_MAC_0_P1        : O_lb_rd_data  <= O_pla2_air_mac_0[31:16]  ;
            C_PLA2_AIR_MAC_1_P1        : O_lb_rd_data  <= O_pla2_air_mac_1[31:16]  ;
            C_PLA2_AIR_MAC_2_P1        : O_lb_rd_data  <= O_pla2_air_mac_2[31:16]  ;
            C_PLA2_AIR_MAC_3_P1        : O_lb_rd_data  <= O_pla2_air_mac_3[31:16]  ;
            C_PLA2_AIR_MAC_4_P1        : O_lb_rd_data  <= O_pla2_air_mac_4[31:16]  ;
            C_PLA2_AIR_MAC_5_P1        : O_lb_rd_data  <= O_pla2_air_mac_5[31:16]  ;
            C_PLA2_AIR_MAC_6_P1        : O_lb_rd_data  <= O_pla2_air_mac_6[31:16]  ;
            C_PLA2_AIR_MAC_7_P1        : O_lb_rd_data  <= O_pla2_air_mac_7[31:16]  ;
            C_PLA2_AIR_MAC_0_P2        : O_lb_rd_data  <= O_pla2_air_mac_0[47:32]  ;
            C_PLA2_AIR_MAC_1_P2        : O_lb_rd_data  <= O_pla2_air_mac_1[47:32]  ;
            C_PLA2_AIR_MAC_2_P2        : O_lb_rd_data  <= O_pla2_air_mac_2[47:32]  ;
            C_PLA2_AIR_MAC_3_P2        : O_lb_rd_data  <= O_pla2_air_mac_3[47:32]  ;
            C_PLA2_AIR_MAC_4_P2        : O_lb_rd_data  <= O_pla2_air_mac_4[47:32]  ;
            C_PLA2_AIR_MAC_5_P2        : O_lb_rd_data  <= O_pla2_air_mac_5[47:32]  ;
            C_PLA2_AIR_MAC_6_P2        : O_lb_rd_data  <= O_pla2_air_mac_6[47:32]  ;
            C_PLA2_AIR_MAC_7_P2        : O_lb_rd_data  <= O_pla2_air_mac_7[47:32]  ;                                    
            C_PLA0_RCU_MAC_P0          : O_lb_rd_data  <= O_pla0_rcu_mac[15:0]      ;
            C_PLA0_RCU_MAC_P1          : O_lb_rd_data  <= O_pla0_rcu_mac[31:16]     ;
            C_PLA0_RCU_MAC_P2          : O_lb_rd_data  <= O_pla0_rcu_mac[47:32]     ;
                                                                
            C_PLA1_RCU_MAC_P0          : O_lb_rd_data  <= O_pla1_rcu_mac[15:0]      ;
            C_PLA1_RCU_MAC_P1          : O_lb_rd_data  <= O_pla1_rcu_mac[31:16]     ;
            C_PLA1_RCU_MAC_P2          : O_lb_rd_data  <= O_pla1_rcu_mac[47:32]     ;
                                                                
            C_PLA2_RCU_MAC_P0          : O_lb_rd_data  <= O_pla2_rcu_mac[15:0]      ;
            C_PLA2_RCU_MAC_P1          : O_lb_rd_data  <= O_pla2_rcu_mac[31:16]     ;
            C_PLA2_RCU_MAC_P2          : O_lb_rd_data  <= O_pla2_rcu_mac[47:32]     ;
                                       
            C_PLA_TC_EN                : O_lb_rd_data  <= {13'd0,O_pla_tc_en}      ;     
            C_PLA_FOR_EN               : O_lb_rd_data  <= {13'd0,O_pla_for_en}      ; 
            C_PLA0_TC_INDEX            : O_lb_rd_data  <= {8'd0,O_pla0_tc_index   };  
            C_PLA1_TC_INDEX            : O_lb_rd_data  <= {8'd0,O_pla1_tc_index   };  
            C_PLA2_TC_INDEX            : O_lb_rd_data  <= {8'd0,O_pla2_tc_index   };  
            C_PLA0_AIR_LINK            : O_lb_rd_data  <= {8'd0,I_pla0_air_link   };   
            C_PLA1_AIR_LINK            : O_lb_rd_data  <= {8'd0,I_pla1_air_link   };   
            C_PLA2_AIR_LINK            : O_lb_rd_data  <= {8'd0,I_pla2_air_link   };   
            C_PLA0_AIR_REQUEST         : O_lb_rd_data  <= {8'd0,I_pla0_air_request};     
            C_PLA1_AIR_REQUEST         : O_lb_rd_data  <= {8'd0,I_pla1_air_request};     
            C_PLA2_AIR_REQUEST         : O_lb_rd_data  <= {8'd0,I_pla2_air_request};
            C_PLA0_AIR_PAUSE           : O_lb_rd_data  <= {8'd0,I_pla0_air_pause}; 
            C_PLA1_AIR_PAUSE           : O_lb_rd_data  <= {8'd0,I_pla1_air_pause}; 
            C_PLA2_AIR_PAUSE           : O_lb_rd_data  <= {8'd0,I_pla2_air_pause}; 
                                       
            C_FLOW_FIFO_PAUSE_SET      : O_lb_rd_data  <= O_flow_fifo_pause_set    ;
            C_FLOW_FIFO_RESUME_SET     : O_lb_rd_data  <= O_flow_fifo_resume_set   ;
            C_FLOW_FIFO_OVERFLOW_SET   : O_lb_rd_data  <= O_flow_fifo_overflow_set   ;
            C_PLA_SLICE_WINDOW         : O_lb_rd_data  <= {1'd0,O_pla_slice_window }; 
            
            C_REQUEST_WAIT_TIME        :  O_lb_rd_data  <= O_request_wait_time   ;       
            C_REQUEST_WAIT_EN          :  O_lb_rd_data  <= {15'd0,O_request_wait_en };      
            C_PLA_MU_AOU_SEL           : O_lb_rd_data  <= {13'd0,O_pla_mu_aou_sel };  
               
            C_PLA_INT_MASK             : O_lb_rd_data  <= O_pla_int_mask               ;            
            C_PLA_INT_CLR              : O_lb_rd_data  <= O_pla_int_clr                ;             
            C_PLA_RMU_INT              : O_lb_rd_data  <= I_pla_rmu_int                ;             
            C_PLA_INT_EVENT            : O_lb_rd_data  <= I_pla_int_event              ;           
            
            C_PLA_AIR_LINK_CHANGE_FLG_P0  : O_lb_rd_data  <= {8'd0,I_pla_air_link_change_flg[7:0]   };   
            C_PLA_AIR_LINK_CHANGE_FLG_P1  : O_lb_rd_data  <= {8'd0,I_pla_air_link_change_flg[15:8]  };   
            C_PLA_AIR_LINK_CHANGE_FLG_P2  : O_lb_rd_data  <= {8'd0,I_pla_air_link_change_flg[23:16] };   
            C_PLA_AIR_LINK_CHANGE_MASK_P0 : O_lb_rd_data  <= {8'd0,O_pla_air_link_change_mask[7:0]   };   
            C_PLA_AIR_LINK_CHANGE_MASK_P1 : O_lb_rd_data  <= {8'd0,O_pla_air_link_change_mask[15:8]  };   
            C_PLA_AIR_LINK_CHANGE_MASK_P2 : O_lb_rd_data  <= {8'd0,O_pla_air_link_change_mask[23:16] };   

            C_PLA0_RMU_RATE_P0         : O_lb_rd_data  <= I_pla0_rmu_rate[15:0]        ;   
            C_PLA0_RMU_RATE_P1         : O_lb_rd_data  <= I_pla0_rmu_rate[19:16]       ;   
            C_PLA1_RMU_RATE_P0         : O_lb_rd_data  <= I_pla1_rmu_rate[15:0]        ;   
            C_PLA1_RMU_RATE_P1         : O_lb_rd_data  <= I_pla1_rmu_rate[19:16]       ;   
            C_PLA2_RMU_RATE_P0         : O_lb_rd_data  <= I_pla2_rmu_rate[15:0]        ;   
            C_PLA2_RMU_RATE_P1         : O_lb_rd_data  <= I_pla2_rmu_rate[19:16]       ;   
            C_PLA0_CU_RATE_CHG_CNT     : O_lb_rd_data  <= I_pla0_cu_rate_chg_cnt       ;
            C_PLA1_CU_RATE_CHG_CNT     : O_lb_rd_data  <= I_pla1_cu_rate_chg_cnt       ;
            C_PLA2_CU_RATE_CHG_CNT     : O_lb_rd_data  <= I_pla2_cu_rate_chg_cnt       ;
                                       
               
            C_PLA_LOOP_EN              : O_lb_rd_data  <= {13'd0,O_pla_loop_en}; 
            C_PLA_PASS_EN              : O_lb_rd_data  <= {14'd0,O_pla_pass_en};  
            C_LOOP_REQUEST_IFG         : O_lb_rd_data  <= O_loop_request_ifg ;
            
            C_PLA_LOOP_LINK_P0         : O_lb_rd_data  <= O_pla_loop_link[15:0]   ;
            C_PLA_LOOP_LINK_P1         : O_lb_rd_data  <= O_pla_loop_link[23:16]  ;
            C_PLA_CNT_CLEAR            : O_lb_rd_data  <= O_cnt_clear[15:0]			;
            C_NUM_TEST_EN              : O_lb_rd_data  <= {15'd0,O_num_test_en};   
  
            C_FLOW0_FF_PARA_FULL_CNT    : O_lb_rd_data  <= I_flow_ff_para_full_cnt[15:0]      ;  
            C_FLOW1_FF_PARA_FULL_CNT    : O_lb_rd_data  <= I_flow_ff_para_full_cnt[31:16]      ;  
            C_FLOW2_FF_PARA_FULL_CNT    : O_lb_rd_data  <= I_flow_ff_para_full_cnt[47:32]      ;  
            C_FLOW_FF0_LEVEL           : O_lb_rd_data  <= I_flow_ff0_level      ;  
            C_FLOW_FF1_LEVEL           : O_lb_rd_data  <= I_flow_ff1_level      ;  
            C_FLOW_FF2_LEVEL           : O_lb_rd_data  <= I_flow_ff2_level      ;  
            
            C_FOR_FRAMER_55D5_CNT     :  O_lb_rd_data  <= I_for_framer_55D5_cnt     ;  
            C_FOR_FRAMER_LOSE_CNT     :  O_lb_rd_data  <= I_for_framer_lose_cnt     ;  
            C_FOR_FRAMER_LOSE_REG     :  O_lb_rd_data  <= {15'd0,I_for_framer_lose_reg}     ;  
            C_RCUB_CHK_SEL            :  O_lb_rd_data  <= {14'd0,O_rcub_chk_sel}     ; 
            C_FOR_FRAMER_ERR_CNT      :  O_lb_rd_data  <= I_for_framer_err_cnt     ;  
            
            C_FOR_EGMII_CRCERR_FRAME_CNT  :O_lb_rd_data  <= I_for_egmii_crcerr_frame_cnt ; 
            C_FOR_EGMII_OUTPUT_FRAME_CNT  :O_lb_rd_data  <= I_for_egmii_output_frame_cnt ; 
            C_FOR_EGMII_REFRAMER_ERR_CNT  :O_lb_rd_data  <= I_for_egmii_reframer_err_cnt ; 
            
            C_FLOW_FF0_FRAME_STAT_P0   : O_lb_rd_data  <= I_flow_ff0_frame_stat[15:0]  ;   
            C_FLOW_FF1_FRAME_STAT_P0   : O_lb_rd_data  <= I_flow_ff1_frame_stat[15:0]  ;   
            C_FLOW_FF2_FRAME_STAT_P0   : O_lb_rd_data  <= I_flow_ff2_frame_stat[15:0]  ;   
            C_FLOW_FF0_FRAME_STAT_P1   : O_lb_rd_data  <= I_flow_ff0_frame_stat[31:16] ;  
            C_FLOW_FF1_FRAME_STAT_P1   : O_lb_rd_data  <= I_flow_ff1_frame_stat[31:16] ;  
            C_FLOW_FF2_FRAME_STAT_P1   : O_lb_rd_data  <= I_flow_ff2_frame_stat[31:16] ;  
            C_FLOW_FF0_FRAME_STAT_P2   : O_lb_rd_data  <= I_flow_ff0_frame_stat[47:32] ;  
            C_FLOW_FF1_FRAME_STAT_P2   : O_lb_rd_data  <= I_flow_ff1_frame_stat[47:32] ;  
            C_FLOW_FF2_FRAME_STAT_P2   : O_lb_rd_data  <= I_flow_ff2_frame_stat[47:32] ;  
                                    
            C_PLA0_AIR_UNLINK_CNT      : O_lb_rd_data  <= I_pla_air_unlink_cnt[15:0] ;  
            C_PLA1_AIR_UNLINK_CNT      : O_lb_rd_data  <= I_pla_air_unlink_cnt[31:16];  
            C_PLA2_AIR_UNLINK_CNT      : O_lb_rd_data  <= I_pla_air_unlink_cnt[47:32];  
            
            
            C_FLOW_FF0_ERR_STAT_P0     : O_lb_rd_data  <= I_flow_ff0_err_stat[15:0]  ;       
            C_FLOW_FF1_ERR_STAT_P0     : O_lb_rd_data  <= I_flow_ff1_err_stat[15:0]  ;       
            C_FLOW_FF2_ERR_STAT_P0     : O_lb_rd_data  <= I_flow_ff2_err_stat[15:0]  ;    
            C_FLOW_FF0_ERR_STAT_P1     : O_lb_rd_data  <= I_flow_ff0_err_stat[31:16] ;
            C_FLOW_FF1_ERR_STAT_P1     : O_lb_rd_data  <= I_flow_ff1_err_stat[31:16] ;
            C_FLOW_FF2_ERR_STAT_P1     : O_lb_rd_data  <= I_flow_ff2_err_stat[31:16] ;
            C_FLOW_FF0_ERR_STAT_P2     : O_lb_rd_data  <= I_flow_ff0_err_stat[47:32] ;
            C_FLOW_FF1_ERR_STAT_P2     : O_lb_rd_data  <= I_flow_ff1_err_stat[47:32] ;        
            C_FLOW_FF2_ERR_STAT_P2     : O_lb_rd_data  <= I_flow_ff2_err_stat[47:32] ;
                                       
            C_SLICE_FIFO0_LEN_ERR_P0   : O_lb_rd_data  <= I_slice_fifo0_len_err[15:0]  ;   
            C_SLICE_FIFO1_LEN_ERR_P0   : O_lb_rd_data  <= I_slice_fifo1_len_err[15:0]  ;
            C_SLICE_FIFO2_LEN_ERR_P0   : O_lb_rd_data  <= I_slice_fifo2_len_err[15:0]  ;
            C_SLICE_FIFO0_LEN_ERR_P1   : O_lb_rd_data  <= I_slice_fifo0_len_err[31:16] ;   
            C_SLICE_FIFO1_LEN_ERR_P1   : O_lb_rd_data  <= I_slice_fifo1_len_err[31:16] ;   
            C_SLICE_FIFO2_LEN_ERR_P1   : O_lb_rd_data  <= I_slice_fifo2_len_err[31:16] ;   
            C_SLICE_FIFO0_LEN_ERR_P2   : O_lb_rd_data  <= I_slice_fifo0_len_err[47:32] ;   
            C_SLICE_FIFO1_LEN_ERR_P2   : O_lb_rd_data  <= I_slice_fifo1_len_err[47:32] ;   
            C_SLICE_FIFO2_LEN_ERR_P2   : O_lb_rd_data  <= I_slice_fifo2_len_err[47:32] ;   
            C_SLICE_FIFO0_LEN_ERR_P3   : O_lb_rd_data  <= I_slice_fifo0_len_err[63:48] ;   
            C_SLICE_FIFO1_LEN_ERR_P3   : O_lb_rd_data  <= I_slice_fifo1_len_err[63:48] ;   
            C_SLICE_FIFO2_LEN_ERR_P3   : O_lb_rd_data  <= I_slice_fifo2_len_err[63:48] ;   
            C_SLICE_FIFO0_LEN_ERR_P4   : O_lb_rd_data  <= I_slice_fifo0_len_err[79:64] ;  
            C_SLICE_FIFO1_LEN_ERR_P4   : O_lb_rd_data  <= I_slice_fifo1_len_err[79:64] ;  
            C_SLICE_FIFO2_LEN_ERR_P4   : O_lb_rd_data  <= I_slice_fifo2_len_err[79:64] ;  
            C_PLA0_PARA_ERR_STAT_P0    : O_lb_rd_data  <= I_pla0_para_err_stat[15:0]  ; 
            C_PLA1_PARA_ERR_STAT_P0    : O_lb_rd_data  <= I_pla1_para_err_stat[15:0]  ; 
            C_PLA2_PARA_ERR_STAT_P0    : O_lb_rd_data  <= I_pla2_para_err_stat[15:0]  ; 
            C_PLA0_PARA_ERR_STAT_P1    : O_lb_rd_data  <= I_pla0_para_err_stat[31:16]  ; 
            C_PLA1_PARA_ERR_STAT_P1    : O_lb_rd_data  <= I_pla1_para_err_stat[31:16]  ; 
            C_PLA2_PARA_ERR_STAT_P1    : O_lb_rd_data  <= I_pla2_para_err_stat[31:16]  ; 
            
            
            C_PLA00_CURRENT_ACM        : O_lb_rd_data  <= {12'd0,I_pla00_current_acm } ;
            C_PLA01_CURRENT_ACM        : O_lb_rd_data  <= {12'd0,I_pla01_current_acm } ;
            C_PLA02_CURRENT_ACM        : O_lb_rd_data  <= {12'd0,I_pla02_current_acm } ;
            C_PLA03_CURRENT_ACM        : O_lb_rd_data  <= {12'd0,I_pla03_current_acm } ;
            C_PLA04_CURRENT_ACM        : O_lb_rd_data  <= {12'd0,I_pla04_current_acm } ;
            C_PLA05_CURRENT_ACM        : O_lb_rd_data  <= {12'd0,I_pla05_current_acm } ;
            C_PLA06_CURRENT_ACM        : O_lb_rd_data  <= {12'd0,I_pla06_current_acm } ;
            C_PLA07_CURRENT_ACM        : O_lb_rd_data  <= {12'd0,I_pla07_current_acm } ;
            C_PLA10_CURRENT_ACM        : O_lb_rd_data  <= {12'd0,I_pla10_current_acm } ;
            C_PLA11_CURRENT_ACM        : O_lb_rd_data  <= {12'd0,I_pla11_current_acm } ;
            C_PLA12_CURRENT_ACM        : O_lb_rd_data  <= {12'd0,I_pla12_current_acm } ;
            C_PLA13_CURRENT_ACM        : O_lb_rd_data  <= {12'd0,I_pla13_current_acm } ;
            C_PLA14_CURRENT_ACM        : O_lb_rd_data  <= {12'd0,I_pla14_current_acm } ;
            C_PLA15_CURRENT_ACM        : O_lb_rd_data  <= {12'd0,I_pla15_current_acm } ;
            C_PLA16_CURRENT_ACM        : O_lb_rd_data  <= {12'd0,I_pla16_current_acm } ;
            C_PLA17_CURRENT_ACM        : O_lb_rd_data  <= {12'd0,I_pla17_current_acm } ;
            C_PLA20_CURRENT_ACM        : O_lb_rd_data  <= {12'd0,I_pla20_current_acm } ;
            C_PLA21_CURRENT_ACM        : O_lb_rd_data  <= {12'd0,I_pla21_current_acm } ;
            C_PLA22_CURRENT_ACM        : O_lb_rd_data  <= {12'd0,I_pla22_current_acm } ;
            C_PLA23_CURRENT_ACM        : O_lb_rd_data  <= {12'd0,I_pla23_current_acm } ;
            C_PLA24_CURRENT_ACM        : O_lb_rd_data  <= {12'd0,I_pla24_current_acm } ;
            C_PLA25_CURRENT_ACM        : O_lb_rd_data  <= {12'd0,I_pla25_current_acm } ;
            C_PLA26_CURRENT_ACM        : O_lb_rd_data  <= {12'd0,I_pla26_current_acm } ;
            C_PLA27_CURRENT_ACM        : O_lb_rd_data  <= {12'd0,I_pla27_current_acm } ;

            C_PLA00_CURRENT_FREQ_P0    : O_lb_rd_data  <= I_pla00_current_freq[15:0];
            C_PLA01_CURRENT_FREQ_P0    : O_lb_rd_data  <= I_pla01_current_freq[15:0];
            C_PLA02_CURRENT_FREQ_P0    : O_lb_rd_data  <= I_pla02_current_freq[15:0];
            C_PLA03_CURRENT_FREQ_P0    : O_lb_rd_data  <= I_pla03_current_freq[15:0];
            C_PLA04_CURRENT_FREQ_P0    : O_lb_rd_data  <= I_pla04_current_freq[15:0];
            C_PLA05_CURRENT_FREQ_P0    : O_lb_rd_data  <= I_pla05_current_freq[15:0];
            C_PLA06_CURRENT_FREQ_P0    : O_lb_rd_data  <= I_pla06_current_freq[15:0];
            C_PLA07_CURRENT_FREQ_P0    : O_lb_rd_data  <= I_pla07_current_freq[15:0];
            C_PLA10_CURRENT_FREQ_P0    : O_lb_rd_data  <= I_pla10_current_freq[15:0];
            C_PLA11_CURRENT_FREQ_P0    : O_lb_rd_data  <= I_pla11_current_freq[15:0];
            C_PLA12_CURRENT_FREQ_P0    : O_lb_rd_data  <= I_pla12_current_freq[15:0];
            C_PLA13_CURRENT_FREQ_P0    : O_lb_rd_data  <= I_pla13_current_freq[15:0];
            C_PLA14_CURRENT_FREQ_P0    : O_lb_rd_data  <= I_pla14_current_freq[15:0];
            C_PLA15_CURRENT_FREQ_P0    : O_lb_rd_data  <= I_pla15_current_freq[15:0];
            C_PLA16_CURRENT_FREQ_P0    : O_lb_rd_data  <= I_pla16_current_freq[15:0];
            C_PLA17_CURRENT_FREQ_P0    : O_lb_rd_data  <= I_pla17_current_freq[15:0];
            C_PLA20_CURRENT_FREQ_P0    : O_lb_rd_data  <= I_pla20_current_freq[15:0];
            C_PLA21_CURRENT_FREQ_P0    : O_lb_rd_data  <= I_pla21_current_freq[15:0];
            C_PLA22_CURRENT_FREQ_P0    : O_lb_rd_data  <= I_pla22_current_freq[15:0];
            C_PLA23_CURRENT_FREQ_P0    : O_lb_rd_data  <= I_pla23_current_freq[15:0];
            C_PLA24_CURRENT_FREQ_P0    : O_lb_rd_data  <= I_pla24_current_freq[15:0];
            C_PLA25_CURRENT_FREQ_P0    : O_lb_rd_data  <= I_pla25_current_freq[15:0];
            C_PLA26_CURRENT_FREQ_P0    : O_lb_rd_data  <= I_pla26_current_freq[15:0];
            C_PLA27_CURRENT_FREQ_P0    : O_lb_rd_data  <= I_pla27_current_freq[15:0];
            
            
            C_PLA00_CURRENT_FREQ_P1    : O_lb_rd_data  <= I_pla00_current_freq[31:16];
            C_PLA01_CURRENT_FREQ_P1    : O_lb_rd_data  <= I_pla01_current_freq[31:16];
            C_PLA02_CURRENT_FREQ_P1    : O_lb_rd_data  <= I_pla02_current_freq[31:16];
            C_PLA03_CURRENT_FREQ_P1    : O_lb_rd_data  <= I_pla03_current_freq[31:16];
            C_PLA04_CURRENT_FREQ_P1    : O_lb_rd_data  <= I_pla04_current_freq[31:16];
            C_PLA05_CURRENT_FREQ_P1    : O_lb_rd_data  <= I_pla05_current_freq[31:16];
            C_PLA06_CURRENT_FREQ_P1    : O_lb_rd_data  <= I_pla06_current_freq[31:16];
            C_PLA07_CURRENT_FREQ_P1    : O_lb_rd_data  <= I_pla07_current_freq[31:16];
            C_PLA10_CURRENT_FREQ_P1    : O_lb_rd_data  <= I_pla10_current_freq[31:16];
            C_PLA11_CURRENT_FREQ_P1    : O_lb_rd_data  <= I_pla11_current_freq[31:16];
            C_PLA12_CURRENT_FREQ_P1    : O_lb_rd_data  <= I_pla12_current_freq[31:16];
            C_PLA13_CURRENT_FREQ_P1    : O_lb_rd_data  <= I_pla13_current_freq[31:16];
            C_PLA14_CURRENT_FREQ_P1    : O_lb_rd_data  <= I_pla14_current_freq[31:16];
            C_PLA15_CURRENT_FREQ_P1    : O_lb_rd_data  <= I_pla15_current_freq[31:16];
            C_PLA16_CURRENT_FREQ_P1    : O_lb_rd_data  <= I_pla16_current_freq[31:16];
            C_PLA17_CURRENT_FREQ_P1    : O_lb_rd_data  <= I_pla17_current_freq[31:16];
            C_PLA20_CURRENT_FREQ_P1    : O_lb_rd_data  <= I_pla20_current_freq[31:16];
            C_PLA21_CURRENT_FREQ_P1    : O_lb_rd_data  <= I_pla21_current_freq[31:16];
            C_PLA22_CURRENT_FREQ_P1    : O_lb_rd_data  <= I_pla22_current_freq[31:16];
            C_PLA23_CURRENT_FREQ_P1    : O_lb_rd_data  <= I_pla23_current_freq[31:16];
            C_PLA24_CURRENT_FREQ_P1    : O_lb_rd_data  <= I_pla24_current_freq[31:16];
            C_PLA25_CURRENT_FREQ_P1    : O_lb_rd_data  <= I_pla25_current_freq[31:16];
            C_PLA26_CURRENT_FREQ_P1    : O_lb_rd_data  <= I_pla26_current_freq[31:16];
            C_PLA27_CURRENT_FREQ_P1    : O_lb_rd_data  <= I_pla27_current_freq[31:16];
                   
            C_PLA00_RMU_RATE           : O_lb_rd_data  <= I_pla00_rmu_rate   ;
            C_PLA01_RMU_RATE           : O_lb_rd_data  <= I_pla01_rmu_rate   ;
            C_PLA02_RMU_RATE           : O_lb_rd_data  <= I_pla02_rmu_rate   ;
            C_PLA03_RMU_RATE           : O_lb_rd_data  <= I_pla03_rmu_rate   ;
            C_PLA04_RMU_RATE           : O_lb_rd_data  <= I_pla04_rmu_rate   ;
            C_PLA05_RMU_RATE           : O_lb_rd_data  <= I_pla05_rmu_rate   ;
            C_PLA06_RMU_RATE           : O_lb_rd_data  <= I_pla06_rmu_rate   ;
            C_PLA07_RMU_RATE           : O_lb_rd_data  <= I_pla07_rmu_rate   ;
            C_PLA10_RMU_RATE           : O_lb_rd_data  <= I_pla10_rmu_rate   ;
            C_PLA11_RMU_RATE           : O_lb_rd_data  <= I_pla11_rmu_rate   ;
            C_PLA12_RMU_RATE           : O_lb_rd_data  <= I_pla12_rmu_rate   ;
            C_PLA13_RMU_RATE           : O_lb_rd_data  <= I_pla13_rmu_rate   ;
            C_PLA14_RMU_RATE           : O_lb_rd_data  <= I_pla14_rmu_rate   ;
            C_PLA15_RMU_RATE           : O_lb_rd_data  <= I_pla15_rmu_rate   ;
            C_PLA16_RMU_RATE           : O_lb_rd_data  <= I_pla16_rmu_rate   ;
            C_PLA17_RMU_RATE           : O_lb_rd_data  <= I_pla17_rmu_rate   ;
            C_PLA20_RMU_RATE           : O_lb_rd_data  <= I_pla20_rmu_rate   ;
            C_PLA21_RMU_RATE           : O_lb_rd_data  <= I_pla21_rmu_rate   ;
            C_PLA22_RMU_RATE           : O_lb_rd_data  <= I_pla22_rmu_rate   ;
            C_PLA23_RMU_RATE           : O_lb_rd_data  <= I_pla23_rmu_rate   ;
            C_PLA24_RMU_RATE           : O_lb_rd_data  <= I_pla24_rmu_rate   ;
            C_PLA25_RMU_RATE           : O_lb_rd_data  <= I_pla25_rmu_rate   ;
            C_PLA26_RMU_RATE           : O_lb_rd_data  <= I_pla26_rmu_rate   ;
            C_PLA27_RMU_RATE           : O_lb_rd_data  <= I_pla27_rmu_rate   ;
                        
                        
                   
            C_PLA00_REQ_CHANGE_CNT     : O_lb_rd_data  <= I_pla00_req_change_cnt[15:0];
            C_PLA01_REQ_CHANGE_CNT     : O_lb_rd_data  <= I_pla01_req_change_cnt[15:0];
            C_PLA02_REQ_CHANGE_CNT     : O_lb_rd_data  <= I_pla02_req_change_cnt[15:0];
            C_PLA03_REQ_CHANGE_CNT     : O_lb_rd_data  <= I_pla03_req_change_cnt[15:0];
            C_PLA04_REQ_CHANGE_CNT     : O_lb_rd_data  <= I_pla04_req_change_cnt[15:0];
            C_PLA05_REQ_CHANGE_CNT     : O_lb_rd_data  <= I_pla05_req_change_cnt[15:0];
            C_PLA06_REQ_CHANGE_CNT     : O_lb_rd_data  <= I_pla06_req_change_cnt[15:0];
            C_PLA07_REQ_CHANGE_CNT     : O_lb_rd_data  <= I_pla07_req_change_cnt[15:0];
            C_PLA10_REQ_CHANGE_CNT     : O_lb_rd_data  <= I_pla10_req_change_cnt[15:0];
            C_PLA11_REQ_CHANGE_CNT     : O_lb_rd_data  <= I_pla11_req_change_cnt[15:0];
            C_PLA12_REQ_CHANGE_CNT     : O_lb_rd_data  <= I_pla12_req_change_cnt[15:0];
            C_PLA13_REQ_CHANGE_CNT     : O_lb_rd_data  <= I_pla13_req_change_cnt[15:0];
            C_PLA14_REQ_CHANGE_CNT     : O_lb_rd_data  <= I_pla14_req_change_cnt[15:0];
            C_PLA15_REQ_CHANGE_CNT     : O_lb_rd_data  <= I_pla15_req_change_cnt[15:0];
            C_PLA16_REQ_CHANGE_CNT     : O_lb_rd_data  <= I_pla16_req_change_cnt[15:0];
            C_PLA17_REQ_CHANGE_CNT     : O_lb_rd_data  <= I_pla17_req_change_cnt[15:0];
            C_PLA20_REQ_CHANGE_CNT     : O_lb_rd_data  <= I_pla20_req_change_cnt[15:0];
            C_PLA21_REQ_CHANGE_CNT     : O_lb_rd_data  <= I_pla21_req_change_cnt[15:0];
            C_PLA22_REQ_CHANGE_CNT     : O_lb_rd_data  <= I_pla22_req_change_cnt[15:0];
            C_PLA23_REQ_CHANGE_CNT     : O_lb_rd_data  <= I_pla23_req_change_cnt[15:0];
            C_PLA24_REQ_CHANGE_CNT     : O_lb_rd_data  <= I_pla24_req_change_cnt[15:0];
            C_PLA25_REQ_CHANGE_CNT     : O_lb_rd_data  <= I_pla25_req_change_cnt[15:0];
            C_PLA26_REQ_CHANGE_CNT     : O_lb_rd_data  <= I_pla26_req_change_cnt[15:0];
            C_PLA27_REQ_CHANGE_CNT     : O_lb_rd_data  <= I_pla27_req_change_cnt[15:0];
            
            C_PLA00_REQ_CNT            : O_lb_rd_data  <= I_pla00_req_change_cnt[31:16];
            C_PLA01_REQ_CNT            : O_lb_rd_data  <= I_pla01_req_change_cnt[31:16];
            C_PLA02_REQ_CNT            : O_lb_rd_data  <= I_pla02_req_change_cnt[31:16];
            C_PLA03_REQ_CNT            : O_lb_rd_data  <= I_pla03_req_change_cnt[31:16];
            C_PLA04_REQ_CNT            : O_lb_rd_data  <= I_pla04_req_change_cnt[31:16];
            C_PLA05_REQ_CNT            : O_lb_rd_data  <= I_pla05_req_change_cnt[31:16];
            C_PLA06_REQ_CNT            : O_lb_rd_data  <= I_pla06_req_change_cnt[31:16];
            C_PLA07_REQ_CNT            : O_lb_rd_data  <= I_pla07_req_change_cnt[31:16];
            C_PLA10_REQ_CNT            : O_lb_rd_data  <= I_pla10_req_change_cnt[31:16];
            C_PLA11_REQ_CNT            : O_lb_rd_data  <= I_pla11_req_change_cnt[31:16];
            C_PLA12_REQ_CNT            : O_lb_rd_data  <= I_pla12_req_change_cnt[31:16];
            C_PLA13_REQ_CNT            : O_lb_rd_data  <= I_pla13_req_change_cnt[31:16];
            C_PLA14_REQ_CNT            : O_lb_rd_data  <= I_pla14_req_change_cnt[31:16];
            C_PLA15_REQ_CNT            : O_lb_rd_data  <= I_pla15_req_change_cnt[31:16];
            C_PLA16_REQ_CNT            : O_lb_rd_data  <= I_pla16_req_change_cnt[31:16];
            C_PLA17_REQ_CNT            : O_lb_rd_data  <= I_pla17_req_change_cnt[31:16];
            C_PLA20_REQ_CNT            : O_lb_rd_data  <= I_pla20_req_change_cnt[31:16];
            C_PLA21_REQ_CNT            : O_lb_rd_data  <= I_pla21_req_change_cnt[31:16];
            C_PLA22_REQ_CNT            : O_lb_rd_data  <= I_pla22_req_change_cnt[31:16];
            C_PLA23_REQ_CNT            : O_lb_rd_data  <= I_pla23_req_change_cnt[31:16];
            C_PLA24_REQ_CNT            : O_lb_rd_data  <= I_pla24_req_change_cnt[31:16];
            C_PLA25_REQ_CNT            : O_lb_rd_data  <= I_pla25_req_change_cnt[31:16];
            C_PLA26_REQ_CNT            : O_lb_rd_data  <= I_pla26_req_change_cnt[31:16];
            C_PLA27_REQ_CNT            : O_lb_rd_data  <= I_pla27_req_change_cnt[31:16];

            C_PLA00_REQ_RATE_CHG_CNT   : O_lb_rd_data  <= I_pla00_req_change_cnt[47:32];
            C_PLA01_REQ_RATE_CHG_CNT   : O_lb_rd_data  <= I_pla01_req_change_cnt[47:32];
            C_PLA02_REQ_RATE_CHG_CNT   : O_lb_rd_data  <= I_pla02_req_change_cnt[47:32];
            C_PLA03_REQ_RATE_CHG_CNT   : O_lb_rd_data  <= I_pla03_req_change_cnt[47:32];
            C_PLA04_REQ_RATE_CHG_CNT   : O_lb_rd_data  <= I_pla04_req_change_cnt[47:32];
            C_PLA05_REQ_RATE_CHG_CNT   : O_lb_rd_data  <= I_pla05_req_change_cnt[47:32];
            C_PLA06_REQ_RATE_CHG_CNT   : O_lb_rd_data  <= I_pla06_req_change_cnt[47:32];
            C_PLA07_REQ_RATE_CHG_CNT   : O_lb_rd_data  <= I_pla07_req_change_cnt[47:32];
            C_PLA10_REQ_RATE_CHG_CNT   : O_lb_rd_data  <= I_pla10_req_change_cnt[47:32];
            C_PLA11_REQ_RATE_CHG_CNT   : O_lb_rd_data  <= I_pla11_req_change_cnt[47:32];
            C_PLA12_REQ_RATE_CHG_CNT   : O_lb_rd_data  <= I_pla12_req_change_cnt[47:32];
            C_PLA13_REQ_RATE_CHG_CNT   : O_lb_rd_data  <= I_pla13_req_change_cnt[47:32];
            C_PLA14_REQ_RATE_CHG_CNT   : O_lb_rd_data  <= I_pla14_req_change_cnt[47:32];
            C_PLA15_REQ_RATE_CHG_CNT   : O_lb_rd_data  <= I_pla15_req_change_cnt[47:32];
            C_PLA16_REQ_RATE_CHG_CNT   : O_lb_rd_data  <= I_pla16_req_change_cnt[47:32];
            C_PLA17_REQ_RATE_CHG_CNT   : O_lb_rd_data  <= I_pla17_req_change_cnt[47:32];
            C_PLA20_REQ_RATE_CHG_CNT   : O_lb_rd_data  <= I_pla20_req_change_cnt[47:32];
            C_PLA21_REQ_RATE_CHG_CNT   : O_lb_rd_data  <= I_pla21_req_change_cnt[47:32];
            C_PLA22_REQ_RATE_CHG_CNT   : O_lb_rd_data  <= I_pla22_req_change_cnt[47:32];
            C_PLA23_REQ_RATE_CHG_CNT   : O_lb_rd_data  <= I_pla23_req_change_cnt[47:32];
            C_PLA24_REQ_RATE_CHG_CNT   : O_lb_rd_data  <= I_pla24_req_change_cnt[47:32];
            C_PLA25_REQ_RATE_CHG_CNT   : O_lb_rd_data  <= I_pla25_req_change_cnt[47:32];
            C_PLA26_REQ_RATE_CHG_CNT   : O_lb_rd_data  <= I_pla26_req_change_cnt[47:32];
            C_PLA27_REQ_RATE_CHG_CNT   : O_lb_rd_data  <= I_pla27_req_change_cnt[47:32];
          

            C_PLA0_TEST_FREQ_0_P0       : O_lb_rd_data  <=  O_pla0_test_freq_0[15:0]  ;      
            C_PLA0_TEST_FREQ_0_P1       : O_lb_rd_data  <=  O_pla0_test_freq_0[31:16] ;      
            C_PLA0_TEST_FREQ_1_P0       : O_lb_rd_data  <=  O_pla0_test_freq_1[15:0]  ;      
            C_PLA0_TEST_FREQ_1_P1       : O_lb_rd_data  <=  O_pla0_test_freq_1[31:16] ;       
            C_PLA0_TEST_FREQ_2_P0       : O_lb_rd_data  <=  O_pla0_test_freq_2[15:0]  ;      
            C_PLA0_TEST_FREQ_2_P1       : O_lb_rd_data  <=  O_pla0_test_freq_2[31:16] ;              
            C_PLA0_TEST_FREQ_3_P0       : O_lb_rd_data  <=  O_pla0_test_freq_3[15:0]  ;      
            C_PLA0_TEST_FREQ_3_P1       : O_lb_rd_data  <=  O_pla0_test_freq_3[31:16] ;      
            C_PLA0_TEST_FREQ_4_P0       : O_lb_rd_data  <=  O_pla0_test_freq_4[15:0]  ;      
            C_PLA0_TEST_FREQ_4_P1       : O_lb_rd_data  <=  O_pla0_test_freq_4[31:16] ;      
            C_PLA0_TEST_FREQ_5_P0       : O_lb_rd_data  <=  O_pla0_test_freq_5[15:0]  ;      
            C_PLA0_TEST_FREQ_5_P1       : O_lb_rd_data  <=  O_pla0_test_freq_5[31:16] ;      
            C_PLA0_TEST_FREQ_6_P0       : O_lb_rd_data  <=  O_pla0_test_freq_6[15:0]  ;      
            C_PLA0_TEST_FREQ_6_P1       : O_lb_rd_data  <=  O_pla0_test_freq_6[31:16] ;      
            C_PLA0_TEST_FREQ_7_P0       : O_lb_rd_data  <=  O_pla0_test_freq_7[15:0]  ;      
            C_PLA0_TEST_FREQ_7_P1       : O_lb_rd_data  <=  O_pla0_test_freq_7[31:16] ;      
            
            C_PLA1_TEST_FREQ_0_P0       : O_lb_rd_data  <=  O_pla1_test_freq_0[15:0]  ;      
            C_PLA1_TEST_FREQ_0_P1       : O_lb_rd_data  <=  O_pla1_test_freq_0[31:16] ;      
            C_PLA1_TEST_FREQ_1_P0       : O_lb_rd_data  <=  O_pla1_test_freq_1[15:0]  ;      
            C_PLA1_TEST_FREQ_1_P1       : O_lb_rd_data  <=  O_pla1_test_freq_1[31:16] ;         
            C_PLA1_TEST_FREQ_2_P0       : O_lb_rd_data  <=  O_pla1_test_freq_2[15:0]  ;      
            C_PLA1_TEST_FREQ_2_P1       : O_lb_rd_data  <=  O_pla1_test_freq_2[31:16] ;                
            C_PLA1_TEST_FREQ_3_P0       : O_lb_rd_data  <=  O_pla1_test_freq_3[15:0]  ;      
            C_PLA1_TEST_FREQ_3_P1       : O_lb_rd_data  <=  O_pla1_test_freq_3[31:16] ;       
            C_PLA1_TEST_FREQ_4_P0       : O_lb_rd_data  <=  O_pla1_test_freq_4[15:0]  ;      
            C_PLA1_TEST_FREQ_4_P1       : O_lb_rd_data  <=  O_pla1_test_freq_4[31:16] ;      
            C_PLA1_TEST_FREQ_5_P0       : O_lb_rd_data  <=  O_pla1_test_freq_5[15:0]  ;      
            C_PLA1_TEST_FREQ_5_P1       : O_lb_rd_data  <=  O_pla1_test_freq_5[31:16] ;      
            C_PLA1_TEST_FREQ_6_P0       : O_lb_rd_data  <=  O_pla1_test_freq_6[15:0]  ;      
            C_PLA1_TEST_FREQ_6_P1       : O_lb_rd_data  <=  O_pla1_test_freq_6[31:16] ;      
            C_PLA1_TEST_FREQ_7_P0       : O_lb_rd_data  <=  O_pla1_test_freq_7[15:0]  ;      
            C_PLA1_TEST_FREQ_7_P1       : O_lb_rd_data  <=  O_pla1_test_freq_7[31:16] ;      
                                    
            C_PLA2_TEST_FREQ_0_P0       : O_lb_rd_data  <=  O_pla2_test_freq_0[15:0]  ;       
            C_PLA2_TEST_FREQ_0_P1       : O_lb_rd_data  <=  O_pla2_test_freq_0[31:16] ;       
            C_PLA2_TEST_FREQ_1_P0       : O_lb_rd_data  <=  O_pla2_test_freq_1[15:0]  ;       
            C_PLA2_TEST_FREQ_1_P1       : O_lb_rd_data  <=  O_pla2_test_freq_1[31:16] ;            
            C_PLA2_TEST_FREQ_2_P0       : O_lb_rd_data  <=  O_pla2_test_freq_2[15:0]  ;       
            C_PLA2_TEST_FREQ_2_P1       : O_lb_rd_data  <=  O_pla2_test_freq_2[31:16] ;                   
            C_PLA2_TEST_FREQ_3_P0       : O_lb_rd_data  <=  O_pla2_test_freq_3[15:0]  ;       
            C_PLA2_TEST_FREQ_3_P1       : O_lb_rd_data  <=  O_pla2_test_freq_3[31:16] ;          
            C_PLA2_TEST_FREQ_4_P0       : O_lb_rd_data  <=  O_pla2_test_freq_4[15:0]  ;       
            C_PLA2_TEST_FREQ_4_P1       : O_lb_rd_data  <=  O_pla2_test_freq_4[31:16] ;       
            C_PLA2_TEST_FREQ_5_P0       : O_lb_rd_data  <=  O_pla2_test_freq_5[15:0]  ;       
            C_PLA2_TEST_FREQ_5_P1       : O_lb_rd_data  <=  O_pla2_test_freq_5[31:16] ;       
            C_PLA2_TEST_FREQ_6_P0       : O_lb_rd_data  <=  O_pla2_test_freq_6[15:0]  ;       
            C_PLA2_TEST_FREQ_6_P1       : O_lb_rd_data  <=  O_pla2_test_freq_6[31:16] ;       
            C_PLA2_TEST_FREQ_7_P0       : O_lb_rd_data  <=  O_pla2_test_freq_7[15:0]  ;       
            C_PLA2_TEST_FREQ_7_P1       : O_lb_rd_data  <=  O_pla2_test_freq_7[31:16] ;           
            
            C_PLA_TC_PROTECT_EN        : O_lb_rd_data  <=  {13'd0,O_pla_tc_protect_en}  ;
            C_PLA_TC_PROTECT_CNT       : O_lb_rd_data  <= O_pla_tc_protect_cnt          ;     
            C_PLA0_TC_PROTECT_ERR_CNT  : O_lb_rd_data  <= I_pla0_tc_protect_err_cnt     ;     
            C_PLA1_TC_PROTECT_ERR_CNT  : O_lb_rd_data  <= I_pla1_tc_protect_err_cnt     ;     
            C_PLA2_TC_PROTECT_ERR_CNT  : O_lb_rd_data  <= I_pla2_tc_protect_err_cnt     ;     
            C_PLA_TC_PROTECT_OUT       : O_lb_rd_data  <= {13'd0,I_pla_tc_protect_out}  ;  
            C_FOR_PLA_VERSION          : O_lb_rd_data  <= C_VERSION_DATA;
            C_FOR_FRAME_CNT            : O_lb_rd_data  <= I_for_frame_cnt  ;      
            C_FOR0_INPUT_CNT           : O_lb_rd_data  <= I_for0_input_cnt     ;   
            C_FOR1_INPUT_CNT           : O_lb_rd_data  <= I_for1_input_cnt     ;   
            C_FOR2_INPUT_CNT           : O_lb_rd_data  <= I_for2_input_cnt     ;   
            C_FOR3_INPUT_CNT           : O_lb_rd_data  <= I_for3_input_cnt     ;      

            C_HC_FOR_EN                : O_lb_rd_data  <= {13'd0,I_hc_for_en}   ;    
            C_RATE_LIMIT_TEST          : O_lb_rd_data  <= O_rate_limit_test  ;    
            C_PLA0_FORIN_CRCOK_CNT     : O_lb_rd_data  <= I_pla0_forin_crcok_cnt      ;   
            C_PLA0_FORIN_CRCERR_CNT    : O_lb_rd_data  <= I_pla0_forin_crcerr_cnt     ;  
            C_PLA1_FORIN_CRCOK_CNT     : O_lb_rd_data  <= I_pla1_forin_crcok_cnt      ;  
            C_PLA1_FORIN_CRCERR_CNT    : O_lb_rd_data  <= I_pla1_forin_crcerr_cnt     ;  
            C_PLA2_FORIN_CRCOK_CNT     : O_lb_rd_data  <= I_pla2_forin_crcok_cnt      ;  
            C_PLA2_FORIN_CRCERR_CNT    : O_lb_rd_data  <= I_pla2_forin_crcerr_cnt     ;   

			C_PLA_SLICE_MAC_ERR_CNT    : O_lb_rd_data  <= I_pla_slice_mac_err_cnt   ;   
            C_PLA_SLICE_LEN_ERR_CNT    : O_lb_rd_data  <= I_pla_slice_len_err_cnt   ;   



            
            C_FOR_RST                  : O_lb_rd_data  <= O_module_rst  ;                   
            C_PLA_BACK_CRC_STAT        : O_lb_rd_data  <= I_pla_slice_crc_ok_cnt; 
            C_PLA_BACK_STAT            : O_lb_rd_data  <= I_pla_slice_crc_err_cnt;           
            C_DDR_RDY                  : O_lb_rd_data  <= {14'd0,I_ddr_rdy}  ; 
            
            C_PLA0_BACK_SLICEOK_STAT   : O_lb_rd_data  <= I_pla0_slice_ok_cnt  ;
            C_PLA0_BACK_SLICEWR_CNT    : O_lb_rd_data  <= I_pla0_slice_wr_cnt  ;
            C_PLA0_BACK_SLICERD_CNT    : O_lb_rd_data  <= I_pla0_slice_rd_cnt  ;
            C_PLA1_BACK_SLICEOK_STAT   : O_lb_rd_data  <= I_pla1_slice_ok_cnt  ;
            C_PLA1_BACK_SLICEWR_CNT    : O_lb_rd_data  <= I_pla1_slice_wr_cnt  ;
            C_PLA1_BACK_SLICERD_CNT    : O_lb_rd_data  <= I_pla1_slice_rd_cnt  ;
            C_PLA2_BACK_SLICEOK_STAT   : O_lb_rd_data  <= I_pla2_slice_ok_cnt  ;
            C_PLA2_BACK_SLICEWR_CNT    : O_lb_rd_data  <= I_pla2_slice_wr_cnt  ;
            C_PLA2_BACK_SLICERD_CNT    : O_lb_rd_data  <= I_pla2_slice_rd_cnt  ;
            
            C_DDR0_REFLOW_55D5_CNT_P0  : O_lb_rd_data  <= I_ddr0_reflow_55D5_cnt[15:0];
            C_DDR0_REFLOW_55D5_CNT_P1  : O_lb_rd_data  <= I_ddr0_reflow_55D5_cnt[31:16];
            C_DDR0_REFLOW_55D5_CNT_P2  : O_lb_rd_data  <= I_ddr0_reflow_55D5_cnt[47:32];
            C_DDR0_REFLOW_LOSE_CNT_P0  : O_lb_rd_data  <= I_ddr0_reflow_lose_cnt[15:0]; 
            C_DDR0_REFLOW_LOSE_CNT_P1  : O_lb_rd_data  <= I_ddr0_reflow_lose_cnt[31:16];
            C_DDR0_REFLOW_LOSE_CNT_P2  : O_lb_rd_data  <= I_ddr0_reflow_lose_cnt[47:32];
            C_DDR0_REFLOW_LOSE_REG     : O_lb_rd_data  <= {13'd0,I_ddr0_reflow_lose_reg}  ;
            
            
            C_PLA0_REFLOW_RDERR_CNT_P0 : O_lb_rd_data  <= I_pla0_reflow_rderr_cnt[15:0]  ;
            C_PLA0_REFLOW_RDERR_CNT_P1 : O_lb_rd_data  <= I_pla0_reflow_rderr_cnt[31:16]  ;
            C_PLA1_REFLOW_RDERR_CNT_P0 : O_lb_rd_data  <= I_pla1_reflow_rderr_cnt[15:0]  ; 
            C_PLA1_REFLOW_RDERR_CNT_P1 : O_lb_rd_data  <= I_pla1_reflow_rderr_cnt[31:16]  ;
            C_PLA2_REFLOW_RDERR_CNT_P0 : O_lb_rd_data  <= I_pla2_reflow_rderr_cnt[15:0]  ; 
            C_PLA2_REFLOW_RDERR_CNT_P1 : O_lb_rd_data  <= I_pla2_reflow_rderr_cnt[31:16]  ;
            
            
            C_PLA0_REFLOW_ID_WL       : O_lb_rd_data  <= I_pla0_reflow_id_wl[15:0];   
            C_PLA1_REFLOW_ID_WL       : O_lb_rd_data  <= I_pla1_reflow_id_wl[15:0];   
            C_PLA2_REFLOW_ID_WL       : O_lb_rd_data  <= I_pla2_reflow_id_wl[15:0];   
            C_PLA_SLICE_ID_DEPTH_ALFUL: O_lb_rd_data  <= {13'd0,I_pla_slice_id_depth_alful}  ;
           
            C_PLA_REFRAMER_in_crcok_cnt    : O_lb_rd_data  <= I_input_crcok_cnt     ;
            C_PLA_REFRAMER_in_crcerr_cnt   : O_lb_rd_data  <= I_input_crcerr_cnt    ;
            C_PLA_REFRAMER_out_crcok_cnt   : O_lb_rd_data  <= I_output_crcok_cnt    ;
            C_PLA_REFRAMER_out_crcerr_cnt  : O_lb_rd_data  <= I_output_crcerr_cnt   ;
            
            C_BACPLA0_ALL_ERR_CNT          : O_lb_rd_data  <= I_all_err_cnt         ;
            C_BACPLA0_FIFOFULL_CNT         : O_lb_rd_data  <= I_fifo_full0_cnt      ;
            C_BAC_PLA0_RAM_FULL0_CNT       : O_lb_rd_data  <= I_ram_full0_cnt       ;
            C_BACPLA0_LENGTH_ERR0_CNT      : O_lb_rd_data  <= I_length_err0_cnt     ;
           
            C_PLA_BACK_FEEDBACK_CNT        : O_lb_rd_data  <= I_feedback_cnt             ;  
            C_PLA_BACK_DROP_CNT            : O_lb_rd_data  <= I_drop_flag_cnt            ;
            C_PLA_STATE_CHANGE_CNT         : O_lb_rd_data  <= I_reframe_state_change_cnt ;
            C_SLICE_CNT                    : O_lb_rd_data  <= I_slice_cnt                ;
            C_SLICE_FIFO_EMPTY_PLA0        : O_lb_rd_data  <= {15'd0,I_pla_slice_fifo_empty_pla0}  ;
            
            C_PLA0_REFLOW_ID               : O_lb_rd_data  <= I_pla0_reflow_id_wl[31:16];     
            C_PLA1_REFLOW_ID               : O_lb_rd_data  <= I_pla1_reflow_id_wl[31:16];     
            C_PLA2_REFLOW_ID               : O_lb_rd_data  <= I_pla2_reflow_id_wl[31:16];     
                                         
            C_PLA0_REFLOW_CURRENT_STATE    : O_lb_rd_data  <= I_pla0_reflow_id_wl[47:32];   
            C_PLA1_REFLOW_CURRENT_STATE    : O_lb_rd_data  <= I_pla1_reflow_id_wl[47:32];   
            C_PLA2_REFLOW_CURRENT_STATE    : O_lb_rd_data  <= I_pla2_reflow_id_wl[47:32];   
                                                                                  
            C_PLA0_BACK_REFAMEER_55D5_NUM  : O_lb_rd_data  <=  I_reframe_pla0_55d5_cnt   ;
            C_PLA0_BACK_REFAMEER_WR_FIFO_NUM:O_lb_rd_data  <= I_pla0_reframe_fifo_wr_cnt ;
                                                        
            C_BACK0_LOSE_NUM_CNT           :O_lb_rd_data  <= I_back0_lose_num_cnt; 
            C_BACK1_LOSE_NUM_CNT           :O_lb_rd_data  <= I_back1_lose_num_cnt; 
            C_BACK2_LOSE_NUM_CNT           :O_lb_rd_data  <= I_back2_lose_num_cnt; 

			C_PLA0_SLICE_CRC_ERR_CNT	   :O_lb_rd_data  <= I_pla0_slice_crc_err_cnt	;
			C_PLA1_SLICE_CRC_ERR_CNT	   :O_lb_rd_data  <= I_pla1_slice_crc_err_cnt	;
			C_PLA2_SLICE_CRC_ERR_CNT	   :O_lb_rd_data  <= I_pla2_slice_crc_err_cnt	;

			C_DDR3A_APP_WDF_RDY_LOW_CNT_MAX:O_lb_rd_data  <= I_ddr3a_app_wdf_rdy_low_cnt_max;
            C_DDR3A_WR_APP_RDY_LOW_CNT_MAX :O_lb_rd_data  <= I_ddr3a_wr_app_rdy_low_cnt_max	;
            C_DDR3A_RD_APP_RDY_LOW_CNT_MAX :O_lb_rd_data  <= I_ddr3a_rd_app_rdy_low_cnt_max	;
            C_DDR3A_APP_WRITE_ERR_CNT	   :O_lb_rd_data  <= I_ddr3a_app_write_err_cnt		;
			C_DDR3A_BUF_FULL_CNT		   :O_lb_rd_data  <= I_ddr3a_buf_full_cnt			; 

            C_DDR3B_APP_WDF_RDY_LOW_CNT_MAX:O_lb_rd_data  <= I_ddr3b_app_wdf_rdy_low_cnt_max;
            C_DDR3B_WR_APP_RDY_LOW_CNT_MAX :O_lb_rd_data  <= I_ddr3b_wr_app_rdy_low_cnt_max	;
            C_DDR3B_RD_APP_RDY_LOW_CNT_MAX :O_lb_rd_data  <= I_ddr3b_rd_app_rdy_low_cnt_max	;
            C_DDR3B_APP_WRITE_ERR_CNT	   :O_lb_rd_data  <= I_ddr3b_app_write_err_cnt		;
			C_DDR3B_BUF_FULL_CNT		   :O_lb_rd_data  <= I_ddr3b_buf_full_cnt			; 
			C_SLICE_RD_EN_VALID_CNT_FIX	   :O_lb_rd_data  <= {10'd0,O_slice_rd_en_valid_cnt_fix};	
			C_PLA0_SLICE_ID_RANDOM_ORDER	:O_lb_rd_data <= {8'd0,I_pla0_slice_id_random_order};	
			C_PLA1_SLICE_ID_RANDOM_ORDER	:O_lb_rd_data <= {8'd0,I_pla1_slice_id_random_order};	
			C_PLA2_SLICE_ID_RANDOM_ORDER	:O_lb_rd_data <= {8'd0,I_pla2_slice_id_random_order};	
			C_PLA0_SLICE_ID_BOTTOM_ERR_CNT	:O_lb_rd_data <= I_pla0_slice_id_bottom_err_cnt		;	
			C_PLA1_SLICE_ID_BOTTOM_ERR_CNT	:O_lb_rd_data <= I_pla1_slice_id_bottom_err_cnt		;	
			C_PLA2_SLICE_ID_BOTTOM_ERR_CNT	:O_lb_rd_data <= I_pla2_slice_id_bottom_err_cnt		;	
            
//pla_tc
            C_PLA_TC_BYPASS                 : O_lb_rd_data  <= {14'h0,O_pla_tc_bypass}        ;
            C_CLEAR_FORWARD_EN              : O_lb_rd_data  <= {9'd0,O_clear_forward_en}    ;
            C_CLEAR_EN                      : O_lb_rd_data  <= {12'd0,O_clear_en}             ;
            C_CLEAR_SUBPORT0_EN             : O_lb_rd_data  <= {8'd0,O_clear_subport0_en}    ;
            C_CLEAR_SUBPORT1_EN             : O_lb_rd_data  <= {8'd0,O_clear_subport1_en}    ;
            C_CLEAR_SUBPORT2_EN             : O_lb_rd_data  <= {8'd0,O_clear_subport2_en}    ;
                    
            C_PKT_CNT_SLICE_IN_H            : O_lb_rd_data  <= I_pkt_cnt_slice_in[31:16]   ;   
            C_PKT_CNT_SLICE_IN_L            : O_lb_rd_data  <= I_pkt_cnt_slice_in[15:0]    ;   
            C_PTP_CNT_IN_H                  : O_lb_rd_data  <= I_ptp_cnt_in[31:16]         ;   
            C_PTP_CNT_IN_L                  : O_lb_rd_data  <= I_ptp_cnt_in[15:0]          ;   
            C_VLAN_PTP_CNT_IN_H             : O_lb_rd_data  <= I_vlan_ptp_cnt_in[31:16]    ;   
            C_VLAN_PTP_CNT_IN_L             : O_lb_rd_data  <= I_vlan_ptp_cnt_in[15:0]     ;   
            C_PTP_NO_VLAN_CNT_OUT_H         : O_lb_rd_data  <= I_ptp_no_vlan_cnt_out[31:16];   
            C_PTP_NO_VLAN_CNT_OUT_L         : O_lb_rd_data  <= I_ptp_no_vlan_cnt_out[15:0] ;   
            C_PTP_VLAN_CNT_OUT_H            : O_lb_rd_data  <= I_ptp_vlan_cnt_out[31:16]   ;   
            C_PTP_VLAN_CNT_OUT_L            : O_lb_rd_data  <= I_ptp_vlan_cnt_out[15:0]    ;
            C_SLICE_CNT_OUT_H               : O_lb_rd_data  <= I_slice_cnt_out[31:16]      ;
            C_SLICE_CNT_OUT_L               : O_lb_rd_data  <= I_slice_cnt_out[15:0]       ;
            C_PACKET_CNT_OUT_H              : O_lb_rd_data  <= I_packet_cnt_out[31:16]     ;
            C_PACKET_CNT_OUT_L              : O_lb_rd_data  <= I_packet_cnt_out[15:0]      ;
            C_FIFO_USEDW                    : O_lb_rd_data  <= {9'b0,I_fifo_usedw}         ;
            C_1588_PACKET_IN_NUM            : O_lb_rd_data  <= I_1588_packet_in_num        ;
            C_1588_PACKET_OUT_NUM           : O_lb_rd_data  <= I_1588_packet_out_num       ;
            C_ALL_PACKET_IN_NUM             : O_lb_rd_data  <= I_all_packet_in_num         ;
            C_ALL_PACKET_OUT_NUM            : O_lb_rd_data  <= I_all_packet_out_num        ;
            C_PLA_SLICE_SA00_CNT            : O_lb_rd_data  <= I_pla_slice_sa00_cnt        ;
            C_PLA_SLICE_SA01_CNT            : O_lb_rd_data  <= I_pla_slice_sa01_cnt        ;
            C_PLA_SLICE_SA02_CNT            : O_lb_rd_data  <= I_pla_slice_sa02_cnt        ;
            C_PLA_SLICE_SA03_CNT            : O_lb_rd_data  <= I_pla_slice_sa03_cnt        ;
            C_PLA_SLICE_SA04_CNT            : O_lb_rd_data  <= I_pla_slice_sa04_cnt        ;
            C_PLA_SLICE_SA05_CNT            : O_lb_rd_data  <= I_pla_slice_sa05_cnt        ;
            C_PLA_SLICE_SA06_CNT            : O_lb_rd_data  <= I_pla_slice_sa06_cnt        ;
            C_PLA_SLICE_SA07_CNT            : O_lb_rd_data  <= I_pla_slice_sa07_cnt        ;
            C_PLA_SLICE_SA10_CNT            : O_lb_rd_data  <= I_pla_slice_sa10_cnt        ;
            C_PLA_SLICE_SA11_CNT            : O_lb_rd_data  <= I_pla_slice_sa11_cnt        ;
            C_PLA_SLICE_SA12_CNT            : O_lb_rd_data  <= I_pla_slice_sa12_cnt        ;
            C_PLA_SLICE_SA13_CNT            : O_lb_rd_data  <= I_pla_slice_sa13_cnt        ;
            C_PLA_SLICE_SA14_CNT            : O_lb_rd_data  <= I_pla_slice_sa14_cnt        ;
            C_PLA_SLICE_SA15_CNT            : O_lb_rd_data  <= I_pla_slice_sa15_cnt        ;
            C_PLA_SLICE_SA16_CNT            : O_lb_rd_data  <= I_pla_slice_sa16_cnt        ;
            C_PLA_SLICE_SA17_CNT            : O_lb_rd_data  <= I_pla_slice_sa17_cnt        ;
            C_PLA_SLICE_SA20_CNT            : O_lb_rd_data  <= I_pla_slice_sa20_cnt        ;
            C_PLA_SLICE_SA21_CNT            : O_lb_rd_data  <= I_pla_slice_sa21_cnt        ;
            C_PLA_SLICE_SA22_CNT            : O_lb_rd_data  <= I_pla_slice_sa22_cnt        ;
            C_PLA_SLICE_SA23_CNT            : O_lb_rd_data  <= I_pla_slice_sa23_cnt        ;
            C_PLA_SLICE_SA24_CNT            : O_lb_rd_data  <= I_pla_slice_sa24_cnt        ;
            C_PLA_SLICE_SA25_CNT            : O_lb_rd_data  <= I_pla_slice_sa25_cnt        ;
            C_PLA_SLICE_SA26_CNT            : O_lb_rd_data  <= I_pla_slice_sa26_cnt        ;
            C_PLA_SLICE_SA27_CNT            : O_lb_rd_data  <= I_pla_slice_sa27_cnt        ;
            C_STATE                         : O_lb_rd_data  <= I_state                     ;
            C_PLA_BACK_RST_CNT              : O_lb_rd_data  <= I_pla_rst_cnt               ;
            
            C_PLA0_BACK_SDRM_USW_PAUSE      : O_lb_rd_data  <= I_frame_dpram_usedw_back_pla0;
            C_PLA1_BACK_SDRM_USW_PAUSE      : O_lb_rd_data  <= I_frame_dpram_usedw_back_pla1; 
            C_PLA2_BACK_SDRM_USW_PAUSE      : O_lb_rd_data  <= I_frame_dpram_usedw_back_pla2;
            
            C_PLA_PAUSE_TIME_CNT            : O_lb_rd_data  <= I_err_tme_cnt                ;
            C_PLA_OUT_INTER_SMALL_CNT       : O_lb_rd_data  <= I_small_inter_cnt            ; 
            C_PLA_BACK_PAUSE_EN             : O_lb_rd_data  <= O_pause_en                   ;                 
            

                                               
            default                         : O_lb_rd_data <= 16'haabb;
        endcase
    end
end




endmodule
