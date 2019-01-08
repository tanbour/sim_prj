//FILE_HEADER-----------------------------------------------------------------
//ZTE  Copyright (C)
//ZTE Company Confidential
//----------------------------------------------------------------------------
//Project Name : RCUC PLA
//FILE NAME    : rcu_pla_top_32bit.v
//AUTHOR       : 
//Department   : 
//Email        :
//----------------------------------------------------------------------------
//Module Hiberarchy :
//x                    |--U01_pla_forward_top_32bit
//x                    |--U02_pla_backward_top_32bit
//x rcu_pla_top_32bit--|--U03_pla_cpu_if_32bit
//x                    |--U04_pla_loop_set
//x                    |--U04_pla_num_test
//----------------------------------------------------------------------------
//Relaese History :
//----------------------------------------------------------------------------
//Version         Date           Author        Description
// 1.1          nov-30-2011                    
//----------------------------------------------------------------------------
//Main Function:
//a)pla_flow
//b)
//----------------------------------------------------------------------------
//REUSE ISSUES: xxxxxxxx
//Reset Strategy: xxxxxxxx
//Clock Strategy: xxxxxxxx
//Critical Timing: xxxxxxxx
//Asynchronous Interface: xxxxxxxx
//END_HEADER------------------------------------------------------------------


`timescale 1ns/100ps
module rcu_pla_top_32bit
(
output               O_ddr_rdy               ,       ///for ddr simu test start

input                I_pla_312m5_clk          ,
input                I_pla_rst                ,
input                I_global_arst            ,
      
input                I_lb_clk                 ,              
input                I_lb_cs_n                ,      
input                I_lb_we_n                ,      
input                I_lb_rd_n                ,      
input     [10:0]     I_lb_addr                ,      
input     [15:0]     I_lb_wr_data             ,    
output    [15:0]     O_lb_rd_data             ,            
///前向输入输出
input      [2:0]     I_hc_for_en              ,
input      [31:0]    I_for_xgmii_hc_txd       ,
input      [3:0]     I_for_xgmii_hc_txc       ,
input      [1:0]     I_for_xgmii_hc_num       , 
output reg [31:0]    O_for_xgmii_pla_txd      ,
output reg [3:0]     O_for_xgmii_pla_txc      ,
output reg [1:0]     O_for_xgmii_pla_num      ,
//反向输入输出
input      [31:0]    I_back_xgmii_rxd         ,
input      [3:0]     I_back_xgmii_rxc         ,
input      [1:0]     I_back_xgmii_num         ,//added by slj, 20150616
output reg [31:0]    O_back_xgmii_pla_rxd     , 
output reg [3:0]     O_back_xgmii_pla_rxc     , 
output reg [1:0]     O_back_xgmii_pla_num     ,

output    [2:0]     O_pla_for_ff_pause       ,////锟斤拷1,2,3 PLA锟斤拷应锟接端匡拷Pause    
output               O_pla_int_n              , 


///ddr outer sig,dont change pin name at first
// Inouts
inout [15:0]        c0_ddr3_dq,
inout [1:0]         c0_ddr3_dqs_n,
inout [1:0]         c0_ddr3_dqs_p,

// Outputs
output [13:0]      c0_ddr3_addr,
output [2:0]       c0_ddr3_ba,
output             c0_ddr3_ras_n,
output             c0_ddr3_cas_n,
output             c0_ddr3_we_n,
output             c0_ddr3_reset_n,
output [0:0]       c0_ddr3_ck_p,
output [0:0]       c0_ddr3_ck_n,
output [0:0]       c0_ddr3_cke,
output [0:0]       c0_ddr3_odt,

// Inputs
// Single-ended system clock
input              c0_sys_clk_i,
// Single-ended iodelayctrl clk (reference clock)
input              clk_ref_i,
///output             tg_compare_error,
output             init_calib_complete,
   
// Inouts
inout [15:0]       c1_ddr3_dq,
inout [1:0]        c1_ddr3_dqs_n,
inout [1:0]        c1_ddr3_dqs_p,

// Outputs
output [13:0]      c1_ddr3_addr,
output [2:0]       c1_ddr3_ba,
output             c1_ddr3_ras_n,
output             c1_ddr3_cas_n,
output             c1_ddr3_we_n,
output             c1_ddr3_reset_n,
output [0:0]       c1_ddr3_ck_p,
output [0:0]       c1_ddr3_ck_n,
output [0:0]       c1_ddr3_cke,
output [0:0]       c1_ddr3_odt,

///for test
output             O_c0_app_rdy ,

// Inputs

// Single-ended system clock
input              c1_sys_clk_i,
input              I_pause_from_back_hc     ,
//////hc feed back  
input            I_pla_feedback_rd_pla0     ,
output [31:0 ]   O_feedback_fifo_rdata_pla0 ,
output [5:0 ]    O_feedback_fifo_count_pla0 ,
output           O_feedback_fifo_full_pla0  ,
output           O_feedback_fifo_empty_pla0 ,

input            I_pla_feedback_rd_pla1     ,
output [31:0 ]   O_feedback_fifo_rdata_pla1 ,
output [5:0 ]    O_feedback_fifo_count_pla1 ,
output           O_feedback_fifo_full_pla1  ,
output           O_feedback_fifo_empty_pla1 ,

input            I_pla_feedback_rd_pla2     ,
output [31:0 ]   O_feedback_fifo_rdata_pla2 ,
output [5:0 ]    O_feedback_fifo_count_pla2 ,
output           O_feedback_fifo_full_pla2  ,
output           O_feedback_fifo_empty_pla2 ,

output  [31:0] O_pla0_pla_bac_reframer_input_data_catch,
output         O_pla0_pla_bac_reframer_input_en_catch  ,
output         O_pla0_time_out_flag_catch              ,
output  [3:0]  O_pla0_reframe_state_catch              ,
output         O_pla0_length_err_catch                 ,
output         O_crc_wrong 
);





wire  [2:0]    S_pla_tc_en                 ;////CPU配置的定向发送使能   
wire  [2:0]    S_pla_for_en                ;
wire  [7:0]    S_pla0_tc_index             ;////PTP切片发送方向 0    
wire  [7:0]    S_pla1_tc_index             ;////PTP切片发送方向 1     
wire  [7:0]    S_pla2_tc_index             ;////PTP切片发送方向 2  
wire  [7:0]    S_pla0_air_link             ;////空口link指示   
wire  [7:0]    S_pla1_air_link             ;////空口link指示   
wire  [7:0]    S_pla2_air_link             ;////空口link指示           
wire  [7:0]    S_pla0_air_request          ;////反向解析的切片请求pulse   
wire  [7:0]    S_pla1_air_request          ;////反向解析的切片请求pulse   
wire  [7:0]    S_pla2_air_request          ;////反向解析的切片请求pulse
wire  [7:0]    S_pla0_air_pause            ;////
wire  [7:0]    S_pla1_air_pause            ;////
wire  [7:0]    S_pla2_air_pause            ;////

wire  [15:0]   S_flow_fifo_pause_set       ;////流FIFO Pause交换水位,上限           
wire  [15:0]   S_flow_fifo_resume_set      ;////流FIFO解Pause交换水位,下限 
wire  [15:0]   S_flow_fifo_overflow_set    ;

wire  [2:0]    S_pla_loop_en               ;////LOOP选择   BIT0:rmuc外部10G环回 BIT1:rmuc内部10G环回 
wire  [1:0]    S_pla_pass_en               ;////LOOP选择   BIT0:rmuc外部10G环回 BIT1:rmuc内部10G环回 
wire  [15:0]   S_loop_request_ifg          ;///反向数据带REQUEST报文间隔 16'h1400
wire  [23:0]   S_pla_loop_link             ;

wire  [31:0]   S_back_loop_request_txd     ;////
wire  [3:0]    S_back_loop_request_txc     ;////

wire  [15:0]   S_cnt_clear                 ;


////CPU测试接口 前向
wire [47:0]   S_flow_ff0_frame_stat        ;////FLOW fifo 帧统计
wire [47:0]   S_flow_ff1_frame_stat        ;////FLOW fifo 帧统计
wire [47:0]   S_flow_ff2_frame_stat        ;////FLOW fifo 帧统计         
wire [47:0]   S_flow_ff0_err_stat          ;////fifo空的次数  
wire [47:0]   S_flow_ff1_err_stat          ;////fifo空的次数
wire [47:0]   S_flow_ff2_err_stat          ;////fifo空的次数 
wire [79:0]   S_slice_fifo0_len_err        ;////测试寄存器
wire [79:0]   S_slice_fifo1_len_err        ;////测试寄存器
wire [79:0]   S_slice_fifo2_len_err        ;////测试寄存器
wire [15:0]   S_flow_ff0_level             ;//// 
wire [15:0]   S_flow_ff1_level             ;////
wire [15:0]   S_flow_ff2_level             ;////
wire [47:0]   S_flow_ff_para_full_cnt      ;
wire [47:0]   S_pla_air_unlink_cnt         ; 

wire  [31:0]  S_pla0_para_err_stat   ;
wire  [31:0]  S_pla1_para_err_stat   ;
wire  [31:0]  S_pla2_para_err_stat   ;


wire [2:0]    S_pla_tc_protect_en          ;////
wire [15:0]   S_pla_tc_protect_cnt         ;////
wire [15:0]   S_pla0_tc_protect_err_cnt    ;////
wire [15:0]   S_pla1_tc_protect_err_cnt    ;////
wire [15:0]   S_pla2_tc_protect_err_cnt    ;////
wire [2:0]    S_pla_tc_protect_out         ;////
        


wire  [47:0]   S_pla0_air_mac_0  ;//// PLA0空口0 mac       
wire  [47:0]   S_pla0_air_mac_1  ;//// PLA0空口1 mac       
wire  [47:0]   S_pla0_air_mac_2  ;//// PLA0空口2 mac       
wire  [47:0]   S_pla0_air_mac_3  ;//// PLA0空口3 mac       
wire  [47:0]   S_pla0_air_mac_4  ;//// PLA0空口4 mac       
wire  [47:0]   S_pla0_air_mac_5  ;//// PLA0空口5 mac       
wire  [47:0]   S_pla0_air_mac_6  ;//// PLA0空口6 mac       
wire  [47:0]   S_pla0_air_mac_7  ;//// PLA0空口7 mac       
wire  [47:0]   S_pla1_air_mac_0  ;//// PLA1空口0 mac       
wire  [47:0]   S_pla1_air_mac_1  ;//// PLA1空口1 mac       
wire  [47:0]   S_pla1_air_mac_2  ;//// PLA1空口2 mac       
wire  [47:0]   S_pla1_air_mac_3  ;//// PLA1空口3 mac       
wire  [47:0]   S_pla1_air_mac_4  ;//// PLA1空口4 mac       
wire  [47:0]   S_pla1_air_mac_5  ;//// PLA1空口5 mac       
wire  [47:0]   S_pla1_air_mac_6  ;//// PLA1空口6 mac       
wire  [47:0]   S_pla1_air_mac_7  ;//// PLA1空口7 mac       
wire  [47:0]   S_pla2_air_mac_0  ;//// PLA2空口0 mac       
wire  [47:0]   S_pla2_air_mac_1  ;//// PLA2空口1 mac       
wire  [47:0]   S_pla2_air_mac_2  ;//// PLA2空口2 mac       
wire  [47:0]   S_pla2_air_mac_3  ;//// PLA2空口3 mac       
wire  [47:0]   S_pla2_air_mac_4  ;//// PLA2空口4 mac       
wire  [47:0]   S_pla2_air_mac_5  ;//// PLA2空口5 mac       
wire  [47:0]   S_pla2_air_mac_6  ;//// PLA2空口6 mac       
wire  [47:0]   S_pla2_air_mac_7  ;//// PLA2空口7 mac   
    
wire  [47:0]   S_pla0_rcu_mac    ;//// 切片发送源mac      
wire  [47:0]   S_pla1_rcu_mac    ;//// 切片发送源mac    
wire  [47:0]   S_pla2_rcu_mac    ;//// 切片发送源mac    

wire  [1:0]    S_rcub_chk_sel    ;       
///BACK REQUEST
wire  [14:0]   S_pla_slice_window  ;

wire  [3:0]   S_pla00_current_acm     ;
wire  [3:0]   S_pla01_current_acm     ;
wire  [3:0]   S_pla02_current_acm     ;
wire  [3:0]   S_pla03_current_acm     ;
wire  [3:0]   S_pla04_current_acm     ;
wire  [3:0]   S_pla05_current_acm     ;
wire  [3:0]   S_pla06_current_acm     ;
wire  [3:0]   S_pla07_current_acm     ;
wire  [3:0]   S_pla10_current_acm     ;
wire  [3:0]   S_pla11_current_acm     ;
wire  [3:0]   S_pla12_current_acm     ;
wire  [3:0]   S_pla13_current_acm     ;
wire  [3:0]   S_pla14_current_acm     ;
wire  [3:0]   S_pla15_current_acm     ;
wire  [3:0]   S_pla16_current_acm     ;
wire  [3:0]   S_pla17_current_acm     ;
wire  [3:0]   S_pla20_current_acm     ;
wire  [3:0]   S_pla21_current_acm     ;
wire  [3:0]   S_pla22_current_acm     ;
wire  [3:0]   S_pla23_current_acm     ;
wire  [3:0]   S_pla24_current_acm     ;
wire  [3:0]   S_pla25_current_acm     ;
wire  [3:0]   S_pla26_current_acm     ;
wire  [3:0]   S_pla27_current_acm     ;

wire  [31:0]  S_pla00_current_freq   ;
wire  [31:0]  S_pla01_current_freq   ;
wire  [31:0]  S_pla02_current_freq   ;
wire  [31:0]  S_pla03_current_freq   ;
wire  [31:0]  S_pla04_current_freq   ;
wire  [31:0]  S_pla05_current_freq   ;
wire  [31:0]  S_pla06_current_freq   ;
wire  [31:0]  S_pla07_current_freq   ;
wire  [31:0]  S_pla10_current_freq   ;
wire  [31:0]  S_pla11_current_freq   ;
wire  [31:0]  S_pla12_current_freq   ;
wire  [31:0]  S_pla13_current_freq   ;
wire  [31:0]  S_pla14_current_freq   ;
wire  [31:0]  S_pla15_current_freq   ;
wire  [31:0]  S_pla16_current_freq   ;
wire  [31:0]  S_pla17_current_freq   ;
wire  [31:0]  S_pla20_current_freq   ;
wire  [31:0]  S_pla21_current_freq   ;
wire  [31:0]  S_pla22_current_freq   ;
wire  [31:0]  S_pla23_current_freq   ;
wire  [31:0]  S_pla24_current_freq   ;
wire  [31:0]  S_pla25_current_freq   ;
wire  [31:0]  S_pla26_current_freq   ;
wire  [31:0]  S_pla27_current_freq   ;

wire  [15:0]  S_pla00_rmu_rate     ;
wire  [15:0]  S_pla01_rmu_rate     ;
wire  [15:0]  S_pla02_rmu_rate     ;
wire  [15:0]  S_pla03_rmu_rate     ;
wire  [15:0]  S_pla04_rmu_rate     ;
wire  [15:0]  S_pla05_rmu_rate     ;
wire  [15:0]  S_pla06_rmu_rate     ;
wire  [15:0]  S_pla07_rmu_rate     ;
wire  [15:0]  S_pla10_rmu_rate     ;
wire  [15:0]  S_pla11_rmu_rate     ;
wire  [15:0]  S_pla12_rmu_rate     ;
wire  [15:0]  S_pla13_rmu_rate     ;
wire  [15:0]  S_pla14_rmu_rate     ;
wire  [15:0]  S_pla15_rmu_rate     ;
wire  [15:0]  S_pla16_rmu_rate     ;
wire  [15:0]  S_pla17_rmu_rate     ;
wire  [15:0]  S_pla20_rmu_rate     ;
wire  [15:0]  S_pla21_rmu_rate     ;
wire  [15:0]  S_pla22_rmu_rate     ;
wire  [15:0]  S_pla23_rmu_rate     ;
wire  [15:0]  S_pla24_rmu_rate     ;
wire  [15:0]  S_pla25_rmu_rate     ;
wire  [15:0]  S_pla26_rmu_rate     ;
wire  [15:0]  S_pla27_rmu_rate     ;

wire  [47:0]   S_pla00_req_change_cnt  ;
wire  [47:0]   S_pla01_req_change_cnt  ;
wire  [47:0]   S_pla02_req_change_cnt  ;
wire  [47:0]   S_pla03_req_change_cnt  ;
wire  [47:0]   S_pla04_req_change_cnt  ;
wire  [47:0]   S_pla05_req_change_cnt  ;
wire  [47:0]   S_pla06_req_change_cnt  ;
wire  [47:0]   S_pla07_req_change_cnt  ;
wire  [47:0]   S_pla10_req_change_cnt  ;
wire  [47:0]   S_pla11_req_change_cnt  ;
wire  [47:0]   S_pla12_req_change_cnt  ;
wire  [47:0]   S_pla13_req_change_cnt  ;
wire  [47:0]   S_pla14_req_change_cnt  ;
wire  [47:0]   S_pla15_req_change_cnt  ;
wire  [47:0]   S_pla16_req_change_cnt  ;
wire  [47:0]   S_pla17_req_change_cnt  ;
wire  [47:0]   S_pla20_req_change_cnt  ;
wire  [47:0]   S_pla21_req_change_cnt  ;
wire  [47:0]   S_pla22_req_change_cnt  ;
wire  [47:0]   S_pla23_req_change_cnt  ;
wire  [47:0]   S_pla24_req_change_cnt  ;
wire  [47:0]   S_pla25_req_change_cnt  ;
wire  [47:0]   S_pla26_req_change_cnt  ;
wire  [47:0]   S_pla27_req_change_cnt  ;


wire  [23:0]   S_pla_air_link_change_mask ;
wire  [23:0]   S_pla_air_link_change_flg  ;

wire  [15:0]   S_pla_back_crc_stat    ;///cpu interface      
wire  [15:0]   S_pla_back_stat        ;///cpu interface  
wire  [15:0]   S_all_err_cnt          ;
wire  [15:0]   S_fifo_full0_cnt       ;
wire  [15:0]   S_ram_full0_cnt        ;
wire  [15:0]   S_length_err0_cnt      ;

wire  [31:0]  S_pla0_test_freq_0      ;
wire  [31:0]  S_pla0_test_freq_1      ;
wire  [31:0]  S_pla0_test_freq_2      ;
wire  [31:0]  S_pla0_test_freq_3      ;
wire  [31:0]  S_pla0_test_freq_4      ;
wire  [31:0]  S_pla0_test_freq_5      ;
wire  [31:0]  S_pla0_test_freq_6      ;
wire  [31:0]  S_pla0_test_freq_7      ;
wire  [31:0]  S_pla1_test_freq_0      ;
wire  [31:0]  S_pla1_test_freq_1      ;
wire  [31:0]  S_pla1_test_freq_2      ;
wire  [31:0]  S_pla1_test_freq_3      ;
wire  [31:0]  S_pla1_test_freq_4      ;
wire  [31:0]  S_pla1_test_freq_5      ;
wire  [31:0]  S_pla1_test_freq_6      ;
wire  [31:0]  S_pla1_test_freq_7      ;
wire  [31:0]  S_pla2_test_freq_0      ;
wire  [31:0]  S_pla2_test_freq_1      ;
wire  [31:0]  S_pla2_test_freq_2      ;
wire  [31:0]  S_pla2_test_freq_3      ;
wire  [31:0]  S_pla2_test_freq_4      ;
wire  [31:0]  S_pla2_test_freq_5      ;
wire  [31:0]  S_pla2_test_freq_6      ;
wire  [31:0]  S_pla2_test_freq_7      ;


wire  [15:0]   S_pla0_slice_ok_cnt    ;
wire  [15:0]   S_pla0_slice_wr_cnt    ;
wire  [15:0]   S_pla0_slice_rd_cnt    ;
wire  [15:0]   S_pla0_slice_crc_err_cnt	;

wire  [15:0]   S_pla1_slice_ok_cnt    ;
wire  [15:0]   S_pla1_slice_wr_cnt    ;
wire  [15:0]   S_pla1_slice_rd_cnt    ;
wire  [15:0]   S_pla1_slice_crc_err_cnt	;

wire  [15:0]   S_pla2_slice_ok_cnt    ;
wire  [15:0]   S_pla2_slice_wr_cnt    ;
wire  [15:0]   S_pla2_slice_rd_cnt    ;
wire  [15:0]   S_pla2_slice_crc_err_cnt	;

wire	[15:0]	S_ddr3a_app_wdf_rdy_low_cnt_max	;	
wire	[15:0]	S_ddr3a_wr_app_rdy_low_cnt_max	;	
wire	[15:0]	S_ddr3a_rd_app_rdy_low_cnt_max	;	
wire	[15:0]	S_ddr3a_app_write_err_cnt		;	
wire	[15:0]	S_ddr3a_buf_full_cnt			;	

wire	[15:0]	S_ddr3b_app_wdf_rdy_low_cnt_max	;	
wire	[15:0]	S_ddr3b_wr_app_rdy_low_cnt_max	;	
wire	[15:0]	S_ddr3b_rd_app_rdy_low_cnt_max	;	
wire	[15:0]	S_ddr3b_app_write_err_cnt		;
wire	[15:0]	S_ddr3b_buf_full_cnt			;	


wire  [31:0]   S_pla0_reflow_rderr_cnt    ;
wire  [31:0]   S_pla1_reflow_rderr_cnt    ; 
wire  [31:0]   S_pla2_reflow_rderr_cnt    ;

wire  [47:0]   S_ddr0_reflow_55D5_cnt  ;
wire  [47:0]   S_ddr0_reflow_lose_cnt  ;
wire  [2:0]    S_ddr0_reflow_lose_reg  ;
                                             
wire  [47:0]   S_pla0_reflow_id_wl          ;
wire  [47:0]   S_pla1_reflow_id_wl          ;
wire  [47:0]   S_pla2_reflow_id_wl          ;
wire  [2:0]    S_pla_slice_id_depth_alful  ;
wire  [31:0]   S_back_xgmii_pla_rxd  ;
wire  [3:0]    S_back_xgmii_pla_rxc  ;
wire  [1:0]    S_back_xgmii_pla_num  ;
wire           S_back_xgmii_pla_crc         ;

wire  [31:0]   S1_back_xgmii_pla_rxd    ;
wire  [3:0]    S1_back_xgmii_pla_rxc    ;
wire  [1:0]    S1_back_xgmii_pla_num    ;
wire  [31:0]   S_for_xgmii_pla_txd  ;
wire  [3:0]    S_for_xgmii_pla_txc  ;
wire  [1:0]    S_for_xgmii_pla_num  ;

wire  [15:0]   S_for_frame_cnt      ;
wire  [15:0]   S_for_framer_55D5_cnt ;
wire  [15:0]   S_for_framer_lose_cnt ;

wire           S_for_framer_lose_reg ;
wire  [15:0]   S_for_framer_err_cnt ;

wire  [15:0]   S_for_egmii_crcerr_frame_cnt   ;/////
wire  [15:0]   S_for_egmii_output_frame_cnt   ;/////
wire  [15:0]   S_for_egmii_reframer_err_cnt   ;/////
wire           S_for_egmii_num_chk ;

wire  [15:0]   S_for0_input_cnt     ;//// 前向输入帧统计
wire  [15:0]   S_for1_input_cnt     ;
wire  [15:0]   S_for2_input_cnt     ;
wire  [15:0]   S_for3_input_cnt     ;
wire  [15:0]    S_module_rst          ;

wire  [15:0]   S_input_crcok_cnt    ;
wire  [15:0]   S_input_crcerr_cnt   ;
wire  [15:0]   S_output_crcok_cnt   ;
wire  [15:0]   S_output_crcerr_cnt  ;
wire  [15:0]   S_reframe_pla0_55d5_cnt ;

wire  [15:0]  S_pla_slice_crc_ok_cnt ; 
wire  [15:0]  S_pla_slice_crc_err_cnt;

wire  [15:0]  S_feedback_cnt              ;
wire  [15:0]  S_drop_flag_cnt             ;
wire  [15:0]  S_reframe_state_change_cnt  ;
wire  [15:0]  S_slice_cnt                 ;

wire          S_pla_slice_fifo_empty_pla0 ;
wire          S_pla_slice_fifo_empty_pla1 ;
wire          S_pla_slice_fifo_empty_pla2 ;
wire [15:0]   S_pla0_reframe_fifo_wr_cnt  ;


wire  [31:0] S_for_xgmii_hc_txd ;
wire  [3:0]  S_for_xgmii_hc_txc ;
wire  [1:0]  S_for_xgmii_hc_num ;
wire         S_num_test_en;


wire  [15:0] S_back0_lose_num_cnt ; 
wire  [15:0] S_back1_lose_num_cnt ; 
wire  [15:0] S_back2_lose_num_cnt ; 

wire  [15:0] S_pla0_forin_crcok_cnt  ;
wire  [15:0] S_pla0_forin_crcerr_cnt ;
wire  [15:0] S_pla1_forin_crcok_cnt  ;
wire  [15:0] S_pla1_forin_crcerr_cnt ;
wire  [15:0] S_pla2_forin_crcok_cnt  ;
wire  [15:0] S_pla2_forin_crcerr_cnt ;

wire  [15:0] S_request_wait_time   ;
wire         S_request_wait_en    ; 

wire  [15:0]  S_pla_int_mask          ;
wire  [15:0]  S_pla_int_clr           ;
wire  [15:0]  S_pla_rmu_int           ;
wire  [15:0]  S_pla_int_event         ;

wire  [19:0]  S_pla0_rmu_rate         ;
wire  [19:0]  S_pla1_rmu_rate         ;
wire  [19:0]  S_pla2_rmu_rate         ;
wire  [15:0]  S_pla0_cu_rate_chg_cnt  ;
wire  [15:0]  S_pla1_cu_rate_chg_cnt  ;
wire  [15:0]  S_pla2_cu_rate_chg_cnt  ;

wire  [31:0]   S_back_xgmii_pla_tc_rxd  ;
wire  [3:0]    S_back_xgmii_pla_tc_rxc  ;

(*mark_debug ="true"*) wire  [31:0]   S_for_xgmii_pla_tc_txd   ;
(*mark_debug ="true"*) wire  [3:0]    S_for_xgmii_pla_tc_txc   ;
(*mark_debug ="true"*) wire  [1:0]    S_for_xgmii_pla_tc_num   ;

(*mark_debug ="true"*) reg  S_pla_rst;
//pla_tc
wire      [1:0]     S_pla_tc_bypass           ;
wire      [6:0]     S_clear_forward_en        ;
wire      [3:0]     S_clear_en                ;
wire      [7:0]     S_clear_subport0_en       ;
wire      [7:0]     S_clear_subport1_en       ;
wire      [7:0]     S_clear_subport2_en       ;

wire      [31:0]    S_pkt_cnt_slice_in        ;
wire      [31:0]    S_ptp_cnt_in              ;
wire      [31:0]    S_vlan_ptp_cnt_in         ;
wire      [31:0]    S_ptp_no_vlan_cnt_out     ;
wire      [31:0]    S_ptp_vlan_cnt_out        ;
wire      [31:0]    S_slice_cnt_out           ;
wire      [31:0]    S_packet_cnt_out          ;

wire      [6:0]     S_fifo_usedw              ;
wire      [15:0]    S_1588_packet_in_num      ;
wire      [15:0]    S_1588_packet_out_num     ;
wire      [15:0]    S_all_packet_in_num       ;
wire      [15:0]    S_all_packet_out_num      ;
wire      [15:0]    S_pla_slice_sa00_cnt      ;
wire      [15:0]    S_pla_slice_sa01_cnt      ;
wire      [15:0]    S_pla_slice_sa02_cnt      ;
wire      [15:0]    S_pla_slice_sa03_cnt      ;
wire      [15:0]    S_pla_slice_sa04_cnt      ;
wire      [15:0]    S_pla_slice_sa05_cnt      ;
wire      [15:0]    S_pla_slice_sa06_cnt      ;
wire      [15:0]    S_pla_slice_sa07_cnt      ;
wire      [15:0]    S_pla_slice_sa10_cnt      ;
wire      [15:0]    S_pla_slice_sa11_cnt      ;
wire      [15:0]    S_pla_slice_sa12_cnt      ;
wire      [15:0]    S_pla_slice_sa13_cnt      ;
wire      [15:0]    S_pla_slice_sa14_cnt      ;
wire      [15:0]    S_pla_slice_sa15_cnt      ;
wire      [15:0]    S_pla_slice_sa16_cnt      ;
wire      [15:0]    S_pla_slice_sa17_cnt      ;
wire      [15:0]    S_pla_slice_sa20_cnt      ;
wire      [15:0]    S_pla_slice_sa21_cnt      ;
wire      [15:0]    S_pla_slice_sa22_cnt      ;
wire      [15:0]    S_pla_slice_sa23_cnt      ;
wire      [15:0]    S_pla_slice_sa24_cnt      ;
wire      [15:0]    S_pla_slice_sa25_cnt      ;
wire      [15:0]    S_pla_slice_sa26_cnt      ;
wire      [15:0]    S_pla_slice_sa27_cnt      ;
wire      [31:0]    S_state                   ;
wire      [15:0]    S_pla_rst_cnt             ; 

reg       [2:0]     S_hc_for_en               ;
wire      [15:0]    S_rate_limit_test         ;

wire      [15:0]    S_frame_dpram_usedw_back_pla0 ;
wire      [15:0]    S_frame_dpram_usedw_back_pla1 ;
wire      [15:0]    S_frame_dpram_usedw_back_pla2 ;


wire      [15:0]    S_err_tme_cnt            ;
wire      [15:0]    S_small_inter_cnt        ; 
wire                S_pause_en               ;
wire		[ 5:0]	S_slice_rd_en_valid_cnt_fix		;
wire		[15:0]  S_pla_slice_mac_err_cnt			;
wire		[15:0]  S_pla_slice_len_err_cnt			;
wire		[ 7:0]	S_pla0_slice_id_random_order	;
wire		[ 7:0]	S_pla1_slice_id_random_order	;
wire		[ 7:0]	S_pla2_slice_id_random_order	;
wire		[15:0]	S_pla0_slice_id_bottom_err_cnt	;
wire		[15:0]	S_pla1_slice_id_bottom_err_cnt	;
wire		[15:0]	S_pla2_slice_id_bottom_err_cnt	;

//////////////////////////////////////////////////////////
///PLA前向
//////////////////////////////////////////////////////////
pla_forward_top_32bit U01_pla_forward_top_32bit
(
.I_pla_312m5_clk                (I_pla_312m5_clk         ),////时钟   
.I_pla_rst                      (I_pla_rst||S_module_rst[0] ),////复位      
.I_for_sub_rst                  (S_module_rst[15:8]      ),////复位     
.I_cnt_clear                (S_cnt_clear[0]          ),
.I_pla_tc_en                    (S_pla_tc_en             ),////CPU配置的定向发送使能   
.I_pla_for_en               (S_pla_for_en            ),
.I_pla0_tc_index                (S_pla0_tc_index         ),////PTP切片发送方向 0    
.I_pla1_tc_index                (S_pla1_tc_index         ),////PTP切片发送方向 1     
.I_pla2_tc_index                (S_pla2_tc_index         ),////PTP切片发送方向 2  
      
.I_flow_fifo_pause_set      (S_flow_fifo_pause_set   ),
.I_flow_fifo_resume_set     (S_flow_fifo_resume_set  ),
.I_flow_fifo_overflow_set   (S_flow_fifo_overflow_set),
.I_xgmii_txd                    (I_for_xgmii_hc_txd      ),////待发送XGMII数据       
.I_xgmii_txc                    (I_for_xgmii_hc_txc      ),////待发送XGMII控制       
.I_xgmii_pla_num                (I_for_xgmii_hc_num      ),////待发送XGMII所需PLA组号
                            
.I_pla0_air_link            (S_pla0_air_link         ),  
.I_pla1_air_link            (S_pla1_air_link         ),  
.I_pla2_air_link            (S_pla2_air_link         ),  
.I_pla0_air_request         (S_pla0_air_request      ),
.I_pla1_air_request         (S_pla1_air_request      ),
.I_pla2_air_request         (S_pla2_air_request      ),
                            
.O_pla_for_ff_pause             (O_pla_for_ff_pause      ),////组PLA对应子端口Pause    
.O_flow_ff0_level           (S_flow_ff0_level    ),   
.O_flow_ff1_level           (S_flow_ff1_level    ),   
.O_flow_ff2_level           (S_flow_ff2_level    ),   
.O_flow_ff_para_full_cnt    (S_flow_ff_para_full_cnt )  ,
.O_pla_air_unlink_cnt           (S_pla_air_unlink_cnt    ),
.O_flow_ff0_frame_stat      (S_flow_ff0_frame_stat   ),
.O_flow_ff1_frame_stat      (S_flow_ff1_frame_stat   ),
.O_flow_ff2_frame_stat      (S_flow_ff2_frame_stat   ),   
.O_flow_ff0_err_stat        (S_flow_ff0_err_stat     ),
.O_flow_ff1_err_stat        (S_flow_ff1_err_stat     ),
.O_flow_ff2_err_stat        (S_flow_ff2_err_stat     ),

.O_pla0_para_err_stat           (S_pla0_para_err_stat   ),
.O_pla1_para_err_stat           (S_pla1_para_err_stat   ),
.O_pla2_para_err_stat           (S_pla2_para_err_stat   ),

.O_slice_fifo0_len_err          (S_slice_fifo0_len_err   ),////测试寄存器
.O_slice_fifo1_len_err          (S_slice_fifo1_len_err   ),////测试寄存器
.O_slice_fifo2_len_err          (S_slice_fifo2_len_err   ),////测试寄存器
                                                     
.I_pla_tc_protect_en        (S_pla_tc_protect_en       ),////3'b111      
.I_pla_tc_protect_cnt       (S_pla_tc_protect_cnt      ),////6'h0020     
.O_pla0_tc_protect_err_cnt      (S_pla0_tc_protect_err_cnt ),////local bus测试寄存器
.O_pla1_tc_protect_err_cnt      (S_pla1_tc_protect_err_cnt ),////local bus测试寄存器
.O_pla2_tc_protect_err_cnt      (S_pla2_tc_protect_err_cnt ),////local bus测试寄存器
.O_pla_tc_protect_out           (S_pla_tc_protect_out      ),////local bus测试寄存器
                            
.I_pla0_air_mac_0           (S_pla0_air_mac_0          ),
.I_pla0_air_mac_1           (S_pla0_air_mac_1          ),
.I_pla0_air_mac_2           (S_pla0_air_mac_2          ),
.I_pla0_air_mac_3           (S_pla0_air_mac_3          ),
.I_pla0_air_mac_4           (S_pla0_air_mac_4          ),
.I_pla0_air_mac_5           (S_pla0_air_mac_5          ),
.I_pla0_air_mac_6           (S_pla0_air_mac_6          ),
.I_pla0_air_mac_7           (S_pla0_air_mac_7          ),
.I_pla1_air_mac_0           (S_pla1_air_mac_0          ),
.I_pla1_air_mac_1           (S_pla1_air_mac_1          ),
.I_pla1_air_mac_2           (S_pla1_air_mac_2          ),
.I_pla1_air_mac_3           (S_pla1_air_mac_3          ),
.I_pla1_air_mac_4           (S_pla1_air_mac_4          ),
.I_pla1_air_mac_5           (S_pla1_air_mac_5          ),
.I_pla1_air_mac_6           (S_pla1_air_mac_6          ),
.I_pla1_air_mac_7           (S_pla1_air_mac_7          ),
.I_pla2_air_mac_0           (S_pla2_air_mac_0          ),
.I_pla2_air_mac_1           (S_pla2_air_mac_1          ),
.I_pla2_air_mac_2           (S_pla2_air_mac_2          ),
.I_pla2_air_mac_3           (S_pla2_air_mac_3          ),
.I_pla2_air_mac_4           (S_pla2_air_mac_4          ),
.I_pla2_air_mac_5           (S_pla2_air_mac_5          ),
.I_pla2_air_mac_6           (S_pla2_air_mac_6          ),
.I_pla2_air_mac_7           (S_pla2_air_mac_7          ),
.I_pla0_rcu_mac             (S_pla0_rcu_mac            ),  
.I_pla1_rcu_mac             (S_pla1_rcu_mac            ),  
.I_pla2_rcu_mac             (S_pla2_rcu_mac            ),  
.I_rcub_chk_sel                 (S_rcub_chk_sel            ),                               
                                       
.O_xgmii_pla_slice_txd          (S_for_xgmii_pla_txd       ),//// 切片报文数据   
.O_xgmii_pla_slice_txc      (S_for_xgmii_pla_txc       ),
.O_xgmii_pla_slice_num      (S_for_xgmii_pla_num       ),

.O_for_framer_55D5_cnt      (S_for_framer_55D5_cnt     ),
.O_for_framer_lose_cnt      (S_for_framer_lose_cnt     ),
.O_for_framer_lose_reg      (S_for_framer_lose_reg     ),
.O_for_framer_err_cnt           (S_for_framer_err_cnt      ),

.O_pla0_forin_crcok_cnt         (S_pla0_forin_crcok_cnt    ),
.O_pla0_forin_crcerr_cnt        (S_pla0_forin_crcerr_cnt   ),
.O_pla1_forin_crcok_cnt         (S_pla1_forin_crcok_cnt    ),
.O_pla1_forin_crcerr_cnt        (S_pla1_forin_crcerr_cnt   ),
.O_pla2_forin_crcok_cnt         (S_pla2_forin_crcok_cnt    ),
.O_pla2_forin_crcerr_cnt        (S_pla2_forin_crcerr_cnt   ),

.O_for_egmii_crcerr_frame_cnt   (S_for_egmii_crcerr_frame_cnt ),
.O_for_egmii_output_frame_cnt   (S_for_egmii_output_frame_cnt ),
.O_for_egmii_reframer_err_cnt   (S_for_egmii_reframer_err_cnt ),
.O_for_egmii_num_chk            (S_for_egmii_num_chk ),

.O_for0_input_cnt           (S_for0_input_cnt          ),
.O_for1_input_cnt           (S_for1_input_cnt          ),
.O_for2_input_cnt           (S_for2_input_cnt          ),
.O_for3_input_cnt           (S_for3_input_cnt          ),
.O_for_frame_cnt                (S_for_frame_cnt           )//// 切片报文控制   
); 



pla_backward_top_32bit     U02_pla_backward_top_32bit(
.O_ddr_rdy                  (O_ddr_rdy               ),
.O_ddr1_rdy                 (S_ddr1_rdy              ),
.I_pla_312m5_clk            (I_pla_312m5_clk         ),
.I_pla_rst                  (I_pla_rst  ),
.I_pla_ddr_rst              (I_pla_rst ), 

.I_pla_air_link_change_mask  (S_pla_air_link_change_mask ), 
.O_pla_air_link_change_flg   (S_pla_air_link_change_flg  ),

.I_pla0_air_mac_0           (S_pla0_air_mac_0        ),
.I_pla0_air_mac_1           (S_pla0_air_mac_1        ),
.I_pla0_air_mac_2           (S_pla0_air_mac_2        ),
.I_pla0_air_mac_3           (S_pla0_air_mac_3        ),
.I_pla0_air_mac_4           (S_pla0_air_mac_4        ),
.I_pla0_air_mac_5           (S_pla0_air_mac_5        ),
.I_pla0_air_mac_6           (S_pla0_air_mac_6        ),
.I_pla0_air_mac_7           (S_pla0_air_mac_7        ),
.I_pla1_air_mac_0           (S_pla1_air_mac_0        ),
.I_pla1_air_mac_1           (S_pla1_air_mac_1        ),
.I_pla1_air_mac_2           (S_pla1_air_mac_2        ),
.I_pla1_air_mac_3           (S_pla1_air_mac_3        ),
.I_pla1_air_mac_4           (S_pla1_air_mac_4        ),
.I_pla1_air_mac_5           (S_pla1_air_mac_5        ),
.I_pla1_air_mac_6           (S_pla1_air_mac_6        ),
.I_pla1_air_mac_7           (S_pla1_air_mac_7        ),
.I_pla2_air_mac_0           (S_pla2_air_mac_0        ),
.I_pla2_air_mac_1           (S_pla2_air_mac_1        ),
.I_pla2_air_mac_2           (S_pla2_air_mac_2        ),
.I_pla2_air_mac_3           (S_pla2_air_mac_3        ),
.I_pla2_air_mac_4           (S_pla2_air_mac_4        ),
.I_pla2_air_mac_5           (S_pla2_air_mac_5        ),
.I_pla2_air_mac_6           (S_pla2_air_mac_6        ),
.I_pla2_air_mac_7           (S_pla2_air_mac_7        ),
.I_pla0_rcu_mac             (S_pla0_rcu_mac          ),
.I_pla1_rcu_mac             (S_pla1_rcu_mac          ),
.I_pla2_rcu_mac             (S_pla2_rcu_mac          ),

.I_pla_slice_window         (S_pla_slice_window      ),
.I_request_wait_time        (S_request_wait_time    ),
.I_request_wait_en          (S_request_wait_en      ),


.I_hc_for_en                 (S_hc_for_en             ),                           
.I_pla_int_mask              (S_pla_int_mask          ),  
.I_pla_int_clr               (S_pla_int_clr           ),  
.O_pla_rmu_int               (S_pla_rmu_int           ),  
.O_pla_int_event             (S_pla_int_event         ),  
.O_pla_int_n                 (O_pla_int_n             ),  
.O_pla0_rmu_rate             (S_pla0_rmu_rate         ),  
.O_pla1_rmu_rate             (S_pla1_rmu_rate         ),  
.O_pla2_rmu_rate             (S_pla2_rmu_rate         ),  
.O_pla0_cu_rate_chg_cnt      (S_pla0_cu_rate_chg_cnt  ),  
.O_pla1_cu_rate_chg_cnt      (S_pla1_cu_rate_chg_cnt  ),  
.O_pla2_cu_rate_chg_cnt      (S_pla2_cu_rate_chg_cnt  ),  
                             
.O_pla0_air_link            (S_pla0_air_link         ),
.O_pla1_air_link            (S_pla1_air_link         ),
.O_pla2_air_link            (S_pla2_air_link         ),
.O_pla0_air_request         (S_pla0_air_request      ),
.O_pla1_air_request         (S_pla1_air_request      ),
.O_pla2_air_request         (S_pla2_air_request      ),

.O_pla0_air_pause           (S_pla0_air_pause        ),
.O_pla1_air_pause           (S_pla1_air_pause        ),
.O_pla2_air_pause           (S_pla2_air_pause        ),

.I_xgmii_rxd                (S_back_loop_request_txd ),
.I_xgmii_rxc                (S_back_loop_request_txc ),
.I_cnt_clear                (S_cnt_clear[15:0]       ),
.O_pla_xgmii_rxd            (S_back_xgmii_pla_rxd    ),
.O_pla_xgmii_rxc            (S_back_xgmii_pla_rxc    ),
.O_pla_xgmii_pla_num        (S_back_xgmii_pla_num    ), 
.O_pla_xgmii_err            (S_back_xgmii_pla_crc    ),
.O_pla_slice_crc_ok_cnt     (S_pla_slice_crc_ok_cnt  ),                
.O_pla_slice_crc_err_cnt    (S_pla_slice_crc_err_cnt ),
.O_all_err_cnt              ( S_all_err_cnt         ),
.O_fifo_full0_cnt           ( S_fifo_full0_cnt      ),
.O_ram_full0_cnt            ( S_ram_full0_cnt       ),
.O_length_err0_cnt          ( S_length_err0_cnt     ),
.O_feedback_cnt              ( S_feedback_cnt             ),
.O_drop_flag_cnt             ( S_drop_flag_cnt            ),
.O_reframe_state_change_cnt  ( S_reframe_state_change_cnt ),
.O_slice_cnt                 ( S_slice_cnt                ),
.I_pause_from_back_hc        ( I_pause_from_back_hc       ),

.I_pla_feedback_rd_pla0      (I_pla_feedback_rd_pla0      ),
.O_feedback_fifo_rdata_pla0  ( O_feedback_fifo_rdata_pla0 ),
.O_feedback_fifo_count_pla0  ( O_feedback_fifo_count_pla0 ),
.O_feedback_fifo_full_pla0   ( O_feedback_fifo_full_pla0  ),
.O_feedback_fifo_empty_pla0  ( O_feedback_fifo_empty_pla0 ),
.O_pla_slice_fifo_empty_pla0 ( S_pla_slice_fifo_empty_pla0),
.O_pla0_reframe_fifo_wr_cnt  ( S_pla0_reframe_fifo_wr_cnt ),

.I_pla_feedback_rd_pla1      (I_pla_feedback_rd_pla1      ),
.O_feedback_fifo_rdata_pla1  ( O_feedback_fifo_rdata_pla1 ),
.O_feedback_fifo_count_pla1  ( O_feedback_fifo_count_pla1 ),
.O_feedback_fifo_full_pla1   ( O_feedback_fifo_full_pla1  ),
.O_feedback_fifo_empty_pla1  ( O_feedback_fifo_empty_pla1 ),
.O_pla_slice_fifo_empty_pla1 ( S_pla_slice_fifo_empty_pla1),

.I_pla_feedback_rd_pla2      (I_pla_feedback_rd_pla2      ),
.O_feedback_fifo_rdata_pla2  ( O_feedback_fifo_rdata_pla2 ),
.O_feedback_fifo_count_pla2  ( O_feedback_fifo_count_pla2 ),
.O_feedback_fifo_full_pla2   ( O_feedback_fifo_full_pla2  ),
.O_feedback_fifo_empty_pla2  ( O_feedback_fifo_empty_pla2 ),
.O_pla_slice_fifo_empty_pla2 ( S_pla_slice_fifo_empty_pla2),
 
 
.I_pla0_test_freq_0         (S_pla0_test_freq_0     ),
.I_pla0_test_freq_1         (S_pla0_test_freq_1     ),
.I_pla0_test_freq_2         (S_pla0_test_freq_2     ),
.I_pla0_test_freq_3         (S_pla0_test_freq_3     ),
.I_pla0_test_freq_4         (S_pla0_test_freq_4     ),
.I_pla0_test_freq_5         (S_pla0_test_freq_5     ),
.I_pla0_test_freq_6         (S_pla0_test_freq_6     ),
.I_pla0_test_freq_7         (S_pla0_test_freq_7     ),
.I_pla1_test_freq_0         (S_pla1_test_freq_0     ),
.I_pla1_test_freq_1         (S_pla1_test_freq_1     ),
.I_pla1_test_freq_2         (S_pla1_test_freq_2     ),
.I_pla1_test_freq_3         (S_pla1_test_freq_3     ),
.I_pla1_test_freq_4         (S_pla1_test_freq_4     ),
.I_pla1_test_freq_5         (S_pla1_test_freq_5     ),
.I_pla1_test_freq_6         (S_pla1_test_freq_6     ),
.I_pla1_test_freq_7         (S_pla1_test_freq_7     ),
.I_pla2_test_freq_0         (S_pla2_test_freq_0     ),
.I_pla2_test_freq_1         (S_pla2_test_freq_1     ),
.I_pla2_test_freq_2         (S_pla2_test_freq_2     ),
.I_pla2_test_freq_3         (S_pla2_test_freq_3     ),
.I_pla2_test_freq_4         (S_pla2_test_freq_4     ),
.I_pla2_test_freq_5         (S_pla2_test_freq_5     ),
.I_pla2_test_freq_6         (S_pla2_test_freq_6     ),
.I_pla2_test_freq_7         (S_pla2_test_freq_7     ),

                 
.O_pla00_current_acm        (S_pla00_current_acm     ),
.O_pla01_current_acm        (S_pla01_current_acm     ),
.O_pla02_current_acm        (S_pla02_current_acm     ),
.O_pla03_current_acm        (S_pla03_current_acm     ),
.O_pla04_current_acm        (S_pla04_current_acm     ),
.O_pla05_current_acm        (S_pla05_current_acm     ),
.O_pla06_current_acm        (S_pla06_current_acm     ),
.O_pla07_current_acm        (S_pla07_current_acm     ),
.O_pla10_current_acm        (S_pla10_current_acm     ),
.O_pla11_current_acm        (S_pla11_current_acm     ),
.O_pla12_current_acm        (S_pla12_current_acm     ),
.O_pla13_current_acm        (S_pla13_current_acm     ),
.O_pla14_current_acm        (S_pla14_current_acm     ),
.O_pla15_current_acm        (S_pla15_current_acm     ),
.O_pla16_current_acm        (S_pla16_current_acm     ),
.O_pla17_current_acm        (S_pla17_current_acm     ),
.O_pla20_current_acm        (S_pla20_current_acm     ),
.O_pla21_current_acm        (S_pla21_current_acm     ),
.O_pla22_current_acm        (S_pla22_current_acm     ),
.O_pla23_current_acm        (S_pla23_current_acm     ),
.O_pla24_current_acm        (S_pla24_current_acm     ),
.O_pla25_current_acm        (S_pla25_current_acm     ),
.O_pla26_current_acm        (S_pla26_current_acm     ),
.O_pla27_current_acm        (S_pla27_current_acm     ),

.O_pla00_current_freq       (S_pla00_current_freq   ),
.O_pla01_current_freq       (S_pla01_current_freq   ),
.O_pla02_current_freq       (S_pla02_current_freq   ),
.O_pla03_current_freq       (S_pla03_current_freq   ),
.O_pla04_current_freq       (S_pla04_current_freq   ),
.O_pla05_current_freq       (S_pla05_current_freq   ),
.O_pla06_current_freq       (S_pla06_current_freq   ),
.O_pla07_current_freq       (S_pla07_current_freq   ),
.O_pla10_current_freq       (S_pla10_current_freq   ),
.O_pla11_current_freq       (S_pla11_current_freq   ),
.O_pla12_current_freq       (S_pla12_current_freq   ),
.O_pla13_current_freq       (S_pla13_current_freq   ),
.O_pla14_current_freq       (S_pla14_current_freq   ),
.O_pla15_current_freq       (S_pla15_current_freq   ),
.O_pla16_current_freq       (S_pla16_current_freq   ),
.O_pla17_current_freq       (S_pla17_current_freq   ),
.O_pla20_current_freq       (S_pla20_current_freq   ),
.O_pla21_current_freq       (S_pla21_current_freq   ),
.O_pla22_current_freq       (S_pla22_current_freq   ),
.O_pla23_current_freq       (S_pla23_current_freq   ),
.O_pla24_current_freq       (S_pla24_current_freq   ),
.O_pla25_current_freq       (S_pla25_current_freq   ),
.O_pla26_current_freq       (S_pla26_current_freq   ),
.O_pla27_current_freq       (S_pla27_current_freq   ),
                            
.O_pla00_rmu_rate           (S_pla00_rmu_rate     ),
.O_pla01_rmu_rate           (S_pla01_rmu_rate     ),
.O_pla02_rmu_rate           (S_pla02_rmu_rate     ),
.O_pla03_rmu_rate           (S_pla03_rmu_rate     ),
.O_pla04_rmu_rate           (S_pla04_rmu_rate     ),
.O_pla05_rmu_rate           (S_pla05_rmu_rate     ),
.O_pla06_rmu_rate           (S_pla06_rmu_rate     ),
.O_pla07_rmu_rate           (S_pla07_rmu_rate     ),
.O_pla10_rmu_rate           (S_pla10_rmu_rate     ),
.O_pla11_rmu_rate           (S_pla11_rmu_rate     ),
.O_pla12_rmu_rate           (S_pla12_rmu_rate     ),
.O_pla13_rmu_rate           (S_pla13_rmu_rate     ),
.O_pla14_rmu_rate           (S_pla14_rmu_rate     ),
.O_pla15_rmu_rate           (S_pla15_rmu_rate     ),
.O_pla16_rmu_rate           (S_pla16_rmu_rate     ),
.O_pla17_rmu_rate           (S_pla17_rmu_rate     ),
.O_pla20_rmu_rate           (S_pla20_rmu_rate     ),
.O_pla21_rmu_rate           (S_pla21_rmu_rate     ),
.O_pla22_rmu_rate           (S_pla22_rmu_rate     ),
.O_pla23_rmu_rate           (S_pla23_rmu_rate     ),
.O_pla24_rmu_rate           (S_pla24_rmu_rate     ),
.O_pla25_rmu_rate           (S_pla25_rmu_rate     ),
.O_pla26_rmu_rate           (S_pla26_rmu_rate     ),
.O_pla27_rmu_rate           (S_pla27_rmu_rate     ),


.O_pla00_req_change_cnt     (S_pla00_req_change_cnt  ),
.O_pla01_req_change_cnt     (S_pla01_req_change_cnt  ),
.O_pla02_req_change_cnt     (S_pla02_req_change_cnt  ),
.O_pla03_req_change_cnt     (S_pla03_req_change_cnt  ),
.O_pla04_req_change_cnt     (S_pla04_req_change_cnt  ),
.O_pla05_req_change_cnt     (S_pla05_req_change_cnt  ),
.O_pla06_req_change_cnt     (S_pla06_req_change_cnt  ),
.O_pla07_req_change_cnt     (S_pla07_req_change_cnt  ),
.O_pla10_req_change_cnt     (S_pla10_req_change_cnt  ),
.O_pla11_req_change_cnt     (S_pla11_req_change_cnt  ),
.O_pla12_req_change_cnt     (S_pla12_req_change_cnt  ),
.O_pla13_req_change_cnt     (S_pla13_req_change_cnt  ),
.O_pla14_req_change_cnt     (S_pla14_req_change_cnt  ),
.O_pla15_req_change_cnt     (S_pla15_req_change_cnt  ),
.O_pla16_req_change_cnt     (S_pla16_req_change_cnt  ),
.O_pla17_req_change_cnt     (S_pla17_req_change_cnt  ),
.O_pla20_req_change_cnt     (S_pla20_req_change_cnt  ),
.O_pla21_req_change_cnt     (S_pla21_req_change_cnt  ),
.O_pla22_req_change_cnt     (S_pla22_req_change_cnt  ),
.O_pla23_req_change_cnt     (S_pla23_req_change_cnt  ),
.O_pla24_req_change_cnt     (S_pla24_req_change_cnt  ),
.O_pla25_req_change_cnt     (S_pla25_req_change_cnt  ),
.O_pla26_req_change_cnt     (S_pla26_req_change_cnt  ),
.O_pla27_req_change_cnt     (S_pla27_req_change_cnt  ),


.O_pla_slice_mac_err_cnt		(S_pla_slice_mac_err_cnt		), 
.O_pla_slice_len_err_cnt		(S_pla_slice_len_err_cnt		), 
.O_pla0_slice_id_random_order	(S_pla0_slice_id_random_order	),
.O_pla1_slice_id_random_order	(S_pla1_slice_id_random_order	),
.O_pla2_slice_id_random_order	(S_pla2_slice_id_random_order	),
.O_pla0_slice_id_bottom_err_cnt	(S_pla0_slice_id_bottom_err_cnt	),
.O_pla1_slice_id_bottom_err_cnt	(S_pla1_slice_id_bottom_err_cnt	),
.O_pla2_slice_id_bottom_err_cnt	(S_pla2_slice_id_bottom_err_cnt	),




.I_slice_rd_en_valid_cnt_fix  (S_slice_rd_en_valid_cnt_fix	), 
.O_pla0_slice_ok_cnt        (S_pla0_slice_ok_cnt		), 
.O_pla0_slice_wr_cnt        (S_pla0_slice_wr_cnt		), 
.O_pla0_slice_rd_cnt        (S_pla0_slice_rd_cnt		), 
.O_pla0_slice_crc_err_cnt	(S_pla0_slice_crc_err_cnt	),

.O_pla1_slice_ok_cnt         (S_pla1_slice_ok_cnt), 
.O_pla1_slice_wr_cnt         (S_pla1_slice_wr_cnt), 
.O_pla1_slice_rd_cnt         (S_pla1_slice_rd_cnt),
.O_pla1_slice_crc_err_cnt	(S_pla1_slice_crc_err_cnt	),

.O_pla2_slice_ok_cnt         (S_pla2_slice_ok_cnt), 
.O_pla2_slice_wr_cnt         (S_pla2_slice_wr_cnt), 
.O_pla2_slice_rd_cnt         (S_pla2_slice_rd_cnt), 
.O_pla2_slice_crc_err_cnt	(S_pla2_slice_crc_err_cnt	),

.O_ddr3a_app_wdf_rdy_low_cnt_max	(S_ddr3a_app_wdf_rdy_low_cnt_max),	
.O_ddr3a_wr_app_rdy_low_cnt_max		(S_ddr3a_wr_app_rdy_low_cnt_max	),	
.O_ddr3a_rd_app_rdy_low_cnt_max		(S_ddr3a_rd_app_rdy_low_cnt_max	),	
.O_ddr3a_app_write_err_cnt			(S_ddr3a_app_write_err_cnt		),	
.O_ddr3a_buf_full_cnt				(S_ddr3a_buf_full_cnt			),
.O_ddr3b_app_wdf_rdy_low_cnt_max	(S_ddr3b_app_wdf_rdy_low_cnt_max),	
.O_ddr3b_wr_app_rdy_low_cnt_max		(S_ddr3b_wr_app_rdy_low_cnt_max	),	
.O_ddr3b_rd_app_rdy_low_cnt_max		(S_ddr3b_rd_app_rdy_low_cnt_max	),	
.O_ddr3b_app_write_err_cnt			(S_ddr3b_app_write_err_cnt		),
.O_ddr3b_buf_full_cnt				(S_ddr3b_buf_full_cnt			),


.O_pla0_reflow_rderr_cnt     (S_pla0_reflow_rderr_cnt),
.O_pla1_reflow_rderr_cnt     (S_pla1_reflow_rderr_cnt),
.O_pla2_reflow_rderr_cnt     (S_pla2_reflow_rderr_cnt),
.O_ddr0_reflow_55D5_cnt      (S_ddr0_reflow_55D5_cnt  ),
.O_ddr0_reflow_lose_cnt      (S_ddr0_reflow_lose_cnt  ),
.O_ddr0_reflow_lose_reg      (S_ddr0_reflow_lose_reg  ),


.O_pla0_reflow_id_wl          (S_pla0_reflow_id_wl       ),
.O_pla1_reflow_id_wl          (S_pla1_reflow_id_wl       ),
.O_pla2_reflow_id_wl          (S_pla2_reflow_id_wl       ),
.O_pla_slice_id_depth_alful   (S_pla_slice_id_depth_alful),

.c0_ddr3_dq                   (c0_ddr3_dq   ),   ///   (IO_FPGA_DDR0_DQ),
.c0_ddr3_dqs_n                (c0_ddr3_dqs_n),   ///   (IO_FPGA_DDR0_DQS_N),
.c0_ddr3_dqs_p                (c0_ddr3_dqs_p),   ///   (IO_FPGA_DDR0_DQS_P),
                                 
.c0_ddr3_addr                 (c0_ddr3_addr   ),   ///   (O_FPGA_DDR0_A),
.c0_ddr3_ba                   (c0_ddr3_ba     ),   ///   (O_FPGA_DDR0_BA),
.c0_ddr3_ras_n                (c0_ddr3_ras_n  ),   ///   (O_FPGA_DDR0_RAS_N),
.c0_ddr3_cas_n                (c0_ddr3_cas_n  ),   ///   (O_FPGA_DDR0_CAS_N),
.c0_ddr3_we_n                 (c0_ddr3_we_n   ),   ///   (O_FPGA_DDR0_WE_N),
.c0_ddr3_reset_n              (c0_ddr3_reset_n),   ///   (O_FPGA_DDR0_RST_N),
.c0_ddr3_ck_p                 (c0_ddr3_ck_p   ),   ///   (O_FPGA_DDR0_CLK_P),
.c0_ddr3_ck_n                 (c0_ddr3_ck_n   ),   ///   (O_FPGA_DDR0_CLK_N),
.c0_ddr3_cke                  (c0_ddr3_cke    ),   ///   (O_FPGA_DDR0_CKE),
.c0_ddr3_odt                  (c0_ddr3_odt    ),   ///   (O_FPGA_DDR0_ODT),
                              
.O_c0_app_rdy                 (O_c0_app_rdy),   ///===
.c0_sys_clk_i                 (c0_sys_clk_i),
                              
.clk_ref_i                    (clk_ref_i),
                              
.c1_ddr3_dq                   (c1_ddr3_dq       ),   ///   (IO_FPGA_DDR1_DQ),
.c1_ddr3_dqs_n                (c1_ddr3_dqs_n    ),   ///   (IO_FPGA_DDR1_DQS_N),
.c1_ddr3_dqs_p                (c1_ddr3_dqs_p    ),   ///   (IO_FPGA_DDR1_DQS_P),                             
.c1_ddr3_addr                 (c1_ddr3_addr     ),   ///   (O_FPGA_DDR1_A),
.c1_ddr3_ba                   (c1_ddr3_ba       ),   ///   (O_FPGA_DDR1_BA),
.c1_ddr3_ras_n                (c1_ddr3_ras_n    ),   ///   (O_FPGA_DDR1_RAS_N),
.c1_ddr3_cas_n                (c1_ddr3_cas_n    ),   ///   (O_FPGA_DDR1_CAS_N),
.c1_ddr3_we_n                 (c1_ddr3_we_n     ),   ///   (O_FPGA_DDR1_WE_N),
.c1_ddr3_reset_n              (c1_ddr3_reset_n  ),   ///   (O_FPGA_DDR1_RST_N),
.c1_ddr3_ck_p                 (c1_ddr3_ck_p     ),   ///   (O_FPGA_DDR1_CLK_P),
.c1_ddr3_ck_n                 (c1_ddr3_ck_n     ),   ///   (O_FPGA_DDR1_CLK_N),
.c1_ddr3_cke                  (c1_ddr3_cke      ),   ///   (O_FPGA_DDR1_CKE),
.c1_ddr3_odt                  (c1_ddr3_odt      ),   ///   (O_FPGA_DDR1_ODT),                            
.c1_sys_clk_i                 (c1_sys_clk_i),
                              
.init_calib_complete          (init_calib_complete),


.O_input_crcok_cnt            (S_input_crcok_cnt   ),         
.O_input_crcerr_cnt           (S_input_crcerr_cnt  ),
.O_output_crcok_cnt           (S_output_crcok_cnt  ),
.O_output_crcerr_cnt          (S_output_crcerr_cnt ),
.O_reframe_pla0_55d5_cnt      (S_reframe_pla0_55d5_cnt),

.O_pla0_pla_bac_reframer_input_data_catch(O_pla0_pla_bac_reframer_input_data_catch),
.O_pla0_pla_bac_reframer_input_en_catch  (O_pla0_pla_bac_reframer_input_en_catch  ),
.O_pla0_time_out_flag_catch              (O_pla0_time_out_flag_catch              ),
.O_pla0_reframe_state_catch              (O_pla0_reframe_state_catch              ),
.O_pla0_length_err_catch                 (O_pla0_length_err_catch                 ),
.O_pla_rst_cnt                           (S_pla_rst_cnt                           ),

.O_frame_dpram_usedw_back_pla0  (S_frame_dpram_usedw_back_pla0                   ),
.O_frame_dpram_usedw_back_pla1  (S_frame_dpram_usedw_back_pla1                   ),
.O_frame_dpram_usedw_back_pla2  (S_frame_dpram_usedw_back_pla2                   ),

 .O_err_tme_cnt                 (S_err_tme_cnt    ),  
 .I_pause_en                    (S_pause_en       ),
 .O_small_inter_cnt             (S_small_inter_cnt),
 .O_crc_wrong                   (O_crc_wrong       )
 );


pla_cpu_if_32bit U03_pla_cpu_if_32bit
(
.I_pla_312m5_clk           (I_lb_clk                  ),
.I_pla_rst                 (I_pla_rst                 ),

.I_lb_cs_n                 (I_lb_cs_n                 ),   
.I_lb_we_n                 (I_lb_we_n                 ),   
.I_lb_rd_n                 (I_lb_rd_n                 ),   
.I_lb_addr                 (I_lb_addr                 ),   
.I_lb_wr_data              (I_lb_wr_data              ),   
.O_lb_rd_data              (O_lb_rd_data              ),

.O_pla_tc_en               (S_pla_tc_en               ),
.O_pla_for_en              (S_pla_for_en              ),
.O_pla0_tc_index           (S_pla0_tc_index           ),
.O_pla1_tc_index           (S_pla1_tc_index           ),
.O_pla2_tc_index           (S_pla2_tc_index           ),

.I_pla0_air_link           (S_pla0_air_link           ),
.I_pla1_air_link           (S_pla1_air_link           ),
.I_pla2_air_link           (S_pla2_air_link           ),
.I_pla0_air_request        (S_pla0_air_request        ),
.I_pla1_air_request        (S_pla1_air_request        ),
.I_pla2_air_request        (S_pla2_air_request        ),
.I_pla0_air_pause          (S_pla0_air_pause          ),
.I_pla1_air_pause          (S_pla1_air_pause          ),
.I_pla2_air_pause          (S_pla2_air_pause          ),
.I_for_frame_cnt           (S_for_frame_cnt           ),
.I_hc_for_en               (S_hc_for_en               ),    
.O_rate_limit_test         (S_rate_limit_test         ),

.I_for0_input_cnt          (S_for0_input_cnt          ),
.I_for1_input_cnt          (S_for1_input_cnt          ),
.I_for2_input_cnt          (S_for2_input_cnt          ),
.I_for3_input_cnt          (S_for3_input_cnt          ),                                      
 
.O_pla_air_link_change_mask(S_pla_air_link_change_mask ), 
.I_pla_air_link_change_flg (S_pla_air_link_change_flg  ), 
                                     
.O_module_rst              (S_module_rst              ),
.I_ddr_rdy                 ({S_ddr1_rdy,O_ddr_rdy}    ),

.O_flow_fifo_pause_set     (S_flow_fifo_pause_set     ),
.O_flow_fifo_resume_set    (S_flow_fifo_resume_set    ),
.O_flow_fifo_overflow_set   (S_flow_fifo_overflow_set),

.O_pla_tc_protect_en       (S_pla_tc_protect_en       ),
.O_pla_tc_protect_cnt      (S_pla_tc_protect_cnt      ),
.I_pla0_tc_protect_err_cnt (S_pla0_tc_protect_err_cnt ),
.I_pla1_tc_protect_err_cnt (S_pla1_tc_protect_err_cnt ),
.I_pla2_tc_protect_err_cnt (S_pla2_tc_protect_err_cnt ),
.I_pla_tc_protect_out      (S_pla_tc_protect_out      ),

.I_flow_ff0_level          (S_flow_ff0_level          ),
.I_flow_ff1_level          (S_flow_ff1_level          ),
.I_flow_ff2_level          (S_flow_ff2_level          ),

.I_for_framer_55D5_cnt     (S_for_framer_55D5_cnt   ),
.I_for_framer_lose_cnt     (S_for_framer_lose_cnt   ),
.I_for_framer_lose_reg     (S_for_framer_lose_reg   ),
.I_for_framer_err_cnt      (S_for_framer_err_cnt      ),


.O_rcub_chk_sel            (S_rcub_chk_sel            ),    
.I_for_egmii_crcerr_frame_cnt (S_for_egmii_crcerr_frame_cnt),
.I_for_egmii_output_frame_cnt (S_for_egmii_output_frame_cnt),
.I_for_egmii_reframer_err_cnt (S_for_egmii_reframer_err_cnt),

.I_flow_ff_para_full_cnt   (S_flow_ff_para_full_cnt   ),
.I_pla_air_unlink_cnt      (S_pla_air_unlink_cnt      ),
.I_flow_ff0_frame_stat     (S_flow_ff0_frame_stat     ),
.I_flow_ff1_frame_stat     (S_flow_ff1_frame_stat     ),
.I_flow_ff2_frame_stat     (S_flow_ff2_frame_stat     ),
.I_flow_ff0_err_stat       (S_flow_ff0_err_stat       ),
.I_flow_ff1_err_stat       (S_flow_ff1_err_stat       ),
.I_flow_ff2_err_stat       (S_flow_ff2_err_stat       ),
.I_pla0_para_err_stat      (S_pla0_para_err_stat   ),
.I_pla1_para_err_stat      (S_pla1_para_err_stat   ),
.I_pla2_para_err_stat      (S_pla2_para_err_stat   ),

.I_slice_fifo0_len_err     (S_slice_fifo0_len_err     ),
.I_slice_fifo1_len_err     (S_slice_fifo1_len_err     ),
.I_slice_fifo2_len_err     (S_slice_fifo2_len_err     ),

.I_pla0_forin_crcok_cnt    (S_pla0_forin_crcok_cnt   ),
.I_pla0_forin_crcerr_cnt   (S_pla0_forin_crcerr_cnt  ),
.I_pla1_forin_crcok_cnt    (S_pla1_forin_crcok_cnt   ),
.I_pla1_forin_crcerr_cnt   (S_pla1_forin_crcerr_cnt  ),
.I_pla2_forin_crcok_cnt    (S_pla2_forin_crcok_cnt   ),
.I_pla2_forin_crcerr_cnt   (S_pla2_forin_crcerr_cnt  ),

.I_pla_rst_cnt             (S_pla_rst_cnt            ),

.O_pla0_air_mac_0          (S_pla0_air_mac_0          ),
.O_pla0_air_mac_1          (S_pla0_air_mac_1          ),
.O_pla0_air_mac_2          (S_pla0_air_mac_2          ),
.O_pla0_air_mac_3          (S_pla0_air_mac_3          ),
.O_pla0_air_mac_4          (S_pla0_air_mac_4          ),
.O_pla0_air_mac_5          (S_pla0_air_mac_5          ),
.O_pla0_air_mac_6          (S_pla0_air_mac_6          ),
.O_pla0_air_mac_7          (S_pla0_air_mac_7          ),
.O_pla1_air_mac_0          (S_pla1_air_mac_0          ),
.O_pla1_air_mac_1          (S_pla1_air_mac_1          ),
.O_pla1_air_mac_2          (S_pla1_air_mac_2          ),
.O_pla1_air_mac_3          (S_pla1_air_mac_3          ),
.O_pla1_air_mac_4          (S_pla1_air_mac_4          ),
.O_pla1_air_mac_5          (S_pla1_air_mac_5          ),
.O_pla1_air_mac_6          (S_pla1_air_mac_6          ),
.O_pla1_air_mac_7          (S_pla1_air_mac_7          ),
.O_pla2_air_mac_0          (S_pla2_air_mac_0          ),
.O_pla2_air_mac_1          (S_pla2_air_mac_1          ),
.O_pla2_air_mac_2          (S_pla2_air_mac_2          ),
.O_pla2_air_mac_3          (S_pla2_air_mac_3          ),
.O_pla2_air_mac_4          (S_pla2_air_mac_4          ),
.O_pla2_air_mac_5          (S_pla2_air_mac_5          ),
.O_pla2_air_mac_6          (S_pla2_air_mac_6          ),
.O_pla2_air_mac_7          (S_pla2_air_mac_7          ),
.O_pla0_rcu_mac            (S_pla0_rcu_mac            ),
.O_pla1_rcu_mac            (S_pla1_rcu_mac            ),
.O_pla2_rcu_mac            (S_pla2_rcu_mac            ),
.O_pla_loop_en             (S_pla_loop_en             ),

.O_pla_pass_en             (S_pla_pass_en             ),
.O_loop_request_ifg        (S_loop_request_ifg        ), 
.O_pla_loop_link           (S_pla_loop_link           ),

////back request
.O_pla_slice_window        (S_pla_slice_window        ),
.O_request_wait_time       (S_request_wait_time       ),
.O_request_wait_en         (S_request_wait_en         ),
.O_pla_mu_aou_sel          (),

.I_pla_slice_mac_err_cnt		(S_pla_slice_mac_err_cnt		), 
.I_pla_slice_len_err_cnt		(S_pla_slice_len_err_cnt		), 
.I_pla0_slice_id_random_order	(S_pla0_slice_id_random_order	),
.I_pla1_slice_id_random_order	(S_pla1_slice_id_random_order	),
.I_pla2_slice_id_random_order	(S_pla2_slice_id_random_order	),
.I_pla0_slice_id_bottom_err_cnt	(S_pla0_slice_id_bottom_err_cnt	),
.I_pla1_slice_id_bottom_err_cnt	(S_pla1_slice_id_bottom_err_cnt	),
.I_pla2_slice_id_bottom_err_cnt	(S_pla2_slice_id_bottom_err_cnt	),

.O_slice_rd_en_valid_cnt_fix  (S_slice_rd_en_valid_cnt_fix	), 
                    
.O_pla_int_mask            (S_pla_int_mask          ),  
.O_pla_int_clr             (S_pla_int_clr           ),  
.I_pla_rmu_int             (S_pla_rmu_int           ),  
.I_pla_int_event           (S_pla_int_event         ),  
.I_pla0_rmu_rate           (S_pla0_rmu_rate         ),  
.I_pla1_rmu_rate           (S_pla1_rmu_rate         ),  
.I_pla2_rmu_rate           (S_pla2_rmu_rate         ),  
.I_pla0_cu_rate_chg_cnt    (S_pla0_cu_rate_chg_cnt  ),  
.I_pla1_cu_rate_chg_cnt    (S_pla1_cu_rate_chg_cnt  ),  
.I_pla2_cu_rate_chg_cnt    (S_pla2_cu_rate_chg_cnt  ),  

.O_pla0_test_freq_0        (S_pla0_test_freq_0      ),
.O_pla0_test_freq_1        (S_pla0_test_freq_1      ),
.O_pla0_test_freq_2        (S_pla0_test_freq_2      ),
.O_pla0_test_freq_3        (S_pla0_test_freq_3      ),
.O_pla0_test_freq_4        (S_pla0_test_freq_4      ),
.O_pla0_test_freq_5        (S_pla0_test_freq_5      ),
.O_pla0_test_freq_6        (S_pla0_test_freq_6      ),
.O_pla0_test_freq_7        (S_pla0_test_freq_7      ),
.O_pla1_test_freq_0        (S_pla1_test_freq_0      ),
.O_pla1_test_freq_1        (S_pla1_test_freq_1      ),
.O_pla1_test_freq_2        (S_pla1_test_freq_2      ),
.O_pla1_test_freq_3        (S_pla1_test_freq_3      ),
.O_pla1_test_freq_4        (S_pla1_test_freq_4      ),
.O_pla1_test_freq_5        (S_pla1_test_freq_5      ),
.O_pla1_test_freq_6        (S_pla1_test_freq_6      ),
.O_pla1_test_freq_7        (S_pla1_test_freq_7      ),
.O_pla2_test_freq_0        (S_pla2_test_freq_0      ),
.O_pla2_test_freq_1        (S_pla2_test_freq_1      ),
.O_pla2_test_freq_2        (S_pla2_test_freq_2      ),
.O_pla2_test_freq_3        (S_pla2_test_freq_3      ),
.O_pla2_test_freq_4        (S_pla2_test_freq_4      ),
.O_pla2_test_freq_5        (S_pla2_test_freq_5      ),
.O_pla2_test_freq_6        (S_pla2_test_freq_6      ),
.O_pla2_test_freq_7        (S_pla2_test_freq_7      ),
                                                
.I_pla00_current_acm       (S_pla00_current_acm       ),
.I_pla01_current_acm       (S_pla01_current_acm       ),
.I_pla02_current_acm       (S_pla02_current_acm       ),
.I_pla03_current_acm       (S_pla03_current_acm       ),
.I_pla04_current_acm       (S_pla04_current_acm       ),
.I_pla05_current_acm       (S_pla05_current_acm       ),
.I_pla06_current_acm       (S_pla06_current_acm       ),
.I_pla07_current_acm       (S_pla07_current_acm       ),
.I_pla10_current_acm       (S_pla10_current_acm       ),
.I_pla11_current_acm       (S_pla11_current_acm       ),
.I_pla12_current_acm       (S_pla12_current_acm       ),
.I_pla13_current_acm       (S_pla13_current_acm       ),
.I_pla14_current_acm       (S_pla14_current_acm       ),
.I_pla15_current_acm       (S_pla15_current_acm       ),
.I_pla16_current_acm       (S_pla16_current_acm       ),
.I_pla17_current_acm       (S_pla17_current_acm       ),
.I_pla20_current_acm       (S_pla20_current_acm       ),
.I_pla21_current_acm       (S_pla21_current_acm       ),
.I_pla22_current_acm       (S_pla22_current_acm       ),
.I_pla23_current_acm       (S_pla23_current_acm       ),
.I_pla24_current_acm       (S_pla24_current_acm       ),
.I_pla25_current_acm       (S_pla25_current_acm       ),
.I_pla26_current_acm       (S_pla26_current_acm       ),
.I_pla27_current_acm       (S_pla27_current_acm       ),

.I_pla00_current_freq      (S_pla00_current_freq   ),
.I_pla01_current_freq      (S_pla01_current_freq   ),
.I_pla02_current_freq      (S_pla02_current_freq   ),
.I_pla03_current_freq      (S_pla03_current_freq   ),
.I_pla04_current_freq      (S_pla04_current_freq   ),
.I_pla05_current_freq      (S_pla05_current_freq   ),
.I_pla06_current_freq      (S_pla06_current_freq   ),
.I_pla07_current_freq      (S_pla07_current_freq   ),
.I_pla10_current_freq      (S_pla10_current_freq   ),
.I_pla11_current_freq      (S_pla11_current_freq   ),
.I_pla12_current_freq      (S_pla12_current_freq   ),
.I_pla13_current_freq      (S_pla13_current_freq   ),
.I_pla14_current_freq      (S_pla14_current_freq   ),
.I_pla15_current_freq      (S_pla15_current_freq   ),
.I_pla16_current_freq      (S_pla16_current_freq   ),
.I_pla17_current_freq      (S_pla17_current_freq   ),
.I_pla20_current_freq      (S_pla20_current_freq   ),
.I_pla21_current_freq      (S_pla21_current_freq   ),
.I_pla22_current_freq      (S_pla22_current_freq   ),
.I_pla23_current_freq      (S_pla23_current_freq   ),
.I_pla24_current_freq      (S_pla24_current_freq   ),
.I_pla25_current_freq      (S_pla25_current_freq   ),
.I_pla26_current_freq      (S_pla26_current_freq   ),
.I_pla27_current_freq      (S_pla27_current_freq   ),

.I_pla00_rmu_rate          (S_pla00_rmu_rate     ),
.I_pla01_rmu_rate          (S_pla01_rmu_rate     ),
.I_pla02_rmu_rate          (S_pla02_rmu_rate     ),
.I_pla03_rmu_rate          (S_pla03_rmu_rate     ),
.I_pla04_rmu_rate          (S_pla04_rmu_rate     ),
.I_pla05_rmu_rate          (S_pla05_rmu_rate     ),
.I_pla06_rmu_rate          (S_pla06_rmu_rate     ),
.I_pla07_rmu_rate          (S_pla07_rmu_rate     ),
.I_pla10_rmu_rate          (S_pla10_rmu_rate     ),
.I_pla11_rmu_rate          (S_pla11_rmu_rate     ),
.I_pla12_rmu_rate          (S_pla12_rmu_rate     ),
.I_pla13_rmu_rate          (S_pla13_rmu_rate     ),
.I_pla14_rmu_rate          (S_pla14_rmu_rate     ),
.I_pla15_rmu_rate          (S_pla15_rmu_rate     ),
.I_pla16_rmu_rate          (S_pla16_rmu_rate     ),
.I_pla17_rmu_rate          (S_pla17_rmu_rate     ),
.I_pla20_rmu_rate          (S_pla20_rmu_rate     ),
.I_pla21_rmu_rate          (S_pla21_rmu_rate     ),
.I_pla22_rmu_rate          (S_pla22_rmu_rate     ),
.I_pla23_rmu_rate          (S_pla23_rmu_rate     ),
.I_pla24_rmu_rate          (S_pla24_rmu_rate     ),
.I_pla25_rmu_rate          (S_pla25_rmu_rate     ),
.I_pla26_rmu_rate          (S_pla26_rmu_rate     ),
.I_pla27_rmu_rate          (S_pla27_rmu_rate     ),


.I_pla00_req_change_cnt    (S_pla00_req_change_cnt    ),
.I_pla01_req_change_cnt    (S_pla01_req_change_cnt    ),
.I_pla02_req_change_cnt    (S_pla02_req_change_cnt    ),
.I_pla03_req_change_cnt    (S_pla03_req_change_cnt    ),
.I_pla04_req_change_cnt    (S_pla04_req_change_cnt    ),
.I_pla05_req_change_cnt    (S_pla05_req_change_cnt    ),
.I_pla06_req_change_cnt    (S_pla06_req_change_cnt    ),
.I_pla07_req_change_cnt    (S_pla07_req_change_cnt    ),
.I_pla10_req_change_cnt    (S_pla10_req_change_cnt    ),
.I_pla11_req_change_cnt    (S_pla11_req_change_cnt    ),
.I_pla12_req_change_cnt    (S_pla12_req_change_cnt    ),
.I_pla13_req_change_cnt    (S_pla13_req_change_cnt    ),
.I_pla14_req_change_cnt    (S_pla14_req_change_cnt    ),
.I_pla15_req_change_cnt    (S_pla15_req_change_cnt    ),
.I_pla16_req_change_cnt    (S_pla16_req_change_cnt    ),
.I_pla17_req_change_cnt    (S_pla17_req_change_cnt    ),
.I_pla20_req_change_cnt    (S_pla20_req_change_cnt    ),
.I_pla21_req_change_cnt    (S_pla21_req_change_cnt    ),
.I_pla22_req_change_cnt    (S_pla22_req_change_cnt    ),
.I_pla23_req_change_cnt    (S_pla23_req_change_cnt    ),
.I_pla24_req_change_cnt    (S_pla24_req_change_cnt    ),
.I_pla25_req_change_cnt    (S_pla25_req_change_cnt    ),
.I_pla26_req_change_cnt    (S_pla26_req_change_cnt    ),
.I_pla27_req_change_cnt    (S_pla27_req_change_cnt    ),

.I_pla0_slice_ok_cnt       (S_pla0_slice_ok_cnt       ), 
.I_pla0_slice_wr_cnt       (S_pla0_slice_wr_cnt       ), 
.I_pla0_slice_rd_cnt       (S_pla0_slice_rd_cnt       ), 
.I_pla0_slice_crc_err_cnt  (S_pla0_slice_crc_err_cnt  ),
.I_pla1_slice_ok_cnt       (S_pla1_slice_ok_cnt       ), 
.I_pla1_slice_wr_cnt       (S_pla1_slice_wr_cnt       ), 
.I_pla1_slice_rd_cnt       (S_pla1_slice_rd_cnt       ), 
.I_pla1_slice_crc_err_cnt  (S_pla1_slice_crc_err_cnt  ),
.I_pla2_slice_ok_cnt       (S_pla2_slice_ok_cnt       ), 
.I_pla2_slice_wr_cnt       (S_pla2_slice_wr_cnt       ), 
.I_pla2_slice_rd_cnt       (S_pla2_slice_rd_cnt       ), 
.I_pla2_slice_crc_err_cnt  (S_pla2_slice_crc_err_cnt  ),
.I_ddr3a_app_wdf_rdy_low_cnt_max	(S_ddr3a_app_wdf_rdy_low_cnt_max),	
.I_ddr3a_wr_app_rdy_low_cnt_max		(S_ddr3a_wr_app_rdy_low_cnt_max	),	
.I_ddr3a_rd_app_rdy_low_cnt_max		(S_ddr3a_rd_app_rdy_low_cnt_max	),	
.I_ddr3a_app_write_err_cnt			(S_ddr3a_app_write_err_cnt		),	
.I_ddr3a_buf_full_cnt				(S_ddr3a_buf_full_cnt			),
.I_ddr3b_app_wdf_rdy_low_cnt_max	(S_ddr3b_app_wdf_rdy_low_cnt_max),	
.I_ddr3b_wr_app_rdy_low_cnt_max		(S_ddr3b_wr_app_rdy_low_cnt_max	),	
.I_ddr3b_rd_app_rdy_low_cnt_max		(S_ddr3b_rd_app_rdy_low_cnt_max	),	
.I_ddr3b_app_write_err_cnt			(S_ddr3b_app_write_err_cnt		),
.I_ddr3b_buf_full_cnt				(S_ddr3b_buf_full_cnt			),


.I_ddr0_reflow_55D5_cnt    (S_ddr0_reflow_55D5_cnt      ), 
.I_ddr0_reflow_lose_cnt    (S_ddr0_reflow_lose_cnt      ), 
.I_ddr0_reflow_lose_reg    (S_ddr0_reflow_lose_reg      ), 

.I_pla0_reflow_rderr_cnt   (S_pla0_reflow_rderr_cnt   ),
.I_pla1_reflow_rderr_cnt   (S_pla1_reflow_rderr_cnt   ),
.I_pla2_reflow_rderr_cnt   (S_pla2_reflow_rderr_cnt   ),

.I_pla0_reflow_id_wl       (S_pla0_reflow_id_wl       ),
.I_pla1_reflow_id_wl       (S_pla1_reflow_id_wl       ),
.I_pla2_reflow_id_wl       (S_pla2_reflow_id_wl       ),
.I_pla_slice_id_depth_alful(S_pla_slice_id_depth_alful),

.I_reframe_pla0_55d5_cnt   (S_reframe_pla0_55d5_cnt   ),
.I_all_err_cnt             (S_all_err_cnt             ),
.I_fifo_full0_cnt          (S_fifo_full0_cnt          ),
.I_ram_full0_cnt           (S_ram_full0_cnt           ),
.I_length_err0_cnt         (S_length_err0_cnt         ),

.O_cnt_clear               (S_cnt_clear[15:0]         ),
.I_input_crcok_cnt         (S_input_crcok_cnt         ),
.I_input_crcerr_cnt        (S_input_crcerr_cnt        ),
.I_output_crcok_cnt        (S_output_crcok_cnt        ),
.I_output_crcerr_cnt       (S_output_crcerr_cnt       ),
.O_num_test_en             (S_num_test_en              ) ,

.I_back0_lose_num_cnt      (S_back0_lose_num_cnt       ),
.I_back1_lose_num_cnt      (S_back1_lose_num_cnt       ),
.I_back2_lose_num_cnt      (S_back2_lose_num_cnt       ),

.I_pla_slice_crc_ok_cnt     (S_pla_slice_crc_ok_cnt      ),  
.I_pla_slice_crc_err_cnt    (S_pla_slice_crc_err_cnt     ),
.I_feedback_cnt              (S_feedback_cnt            ),
.I_drop_flag_cnt             (S_drop_flag_cnt           ),
.I_reframe_state_change_cnt  (S_reframe_state_change_cnt),
.I_slice_cnt                 (S_slice_cnt               ),
.I_pla_slice_fifo_empty_pla0 (S_pla_slice_fifo_empty_pla0),
.I_pla0_reframe_fifo_wr_cnt   (S_pla0_reframe_fifo_wr_cnt),
//pla_tc
.O_pla_tc_bypass           (S_pla_tc_bypass      ),
.O_clear_forward_en        (S_clear_forward_en   ),
.O_clear_en                (S_clear_en           ),
.O_clear_subport0_en       (S_clear_subport0_en  ),
.O_clear_subport1_en       (S_clear_subport1_en  ),
.O_clear_subport2_en       (S_clear_subport2_en  ),

.I_pkt_cnt_slice_in        (S_pkt_cnt_slice_in   ),
.I_ptp_cnt_in              (S_ptp_cnt_in         ),
.I_vlan_ptp_cnt_in         (S_vlan_ptp_cnt_in    ),
.I_ptp_no_vlan_cnt_out     (S_ptp_no_vlan_cnt_out),
.I_ptp_vlan_cnt_out        (S_ptp_vlan_cnt_out   ),
.I_slice_cnt_out           (S_slice_cnt_out      ),
.I_packet_cnt_out          (S_packet_cnt_out     ),

.I_fifo_usedw              (S_fifo_usedw         ),
.I_1588_packet_in_num      (S_1588_packet_in_num ),
.I_1588_packet_out_num     (S_1588_packet_out_num),
.I_all_packet_in_num       (S_all_packet_in_num  ),
.I_all_packet_out_num      (S_all_packet_out_num ),
.I_pla_slice_sa00_cnt      (S_pla_slice_sa00_cnt ),
.I_pla_slice_sa01_cnt      (S_pla_slice_sa01_cnt ),
.I_pla_slice_sa02_cnt      (S_pla_slice_sa02_cnt ),
.I_pla_slice_sa03_cnt      (S_pla_slice_sa03_cnt ),
.I_pla_slice_sa04_cnt      (S_pla_slice_sa04_cnt ),
.I_pla_slice_sa05_cnt      (S_pla_slice_sa05_cnt ),
.I_pla_slice_sa06_cnt      (S_pla_slice_sa06_cnt ),
.I_pla_slice_sa07_cnt      (S_pla_slice_sa07_cnt ),
.I_pla_slice_sa10_cnt      (S_pla_slice_sa10_cnt ),
.I_pla_slice_sa11_cnt      (S_pla_slice_sa11_cnt ),
.I_pla_slice_sa12_cnt      (S_pla_slice_sa12_cnt ),
.I_pla_slice_sa13_cnt      (S_pla_slice_sa13_cnt ),
.I_pla_slice_sa14_cnt      (S_pla_slice_sa14_cnt ),
.I_pla_slice_sa15_cnt      (S_pla_slice_sa15_cnt ),
.I_pla_slice_sa16_cnt      (S_pla_slice_sa16_cnt ),
.I_pla_slice_sa17_cnt      (S_pla_slice_sa17_cnt ),
.I_pla_slice_sa20_cnt      (S_pla_slice_sa20_cnt ),
.I_pla_slice_sa21_cnt      (S_pla_slice_sa21_cnt ),
.I_pla_slice_sa22_cnt      (S_pla_slice_sa22_cnt ),
.I_pla_slice_sa23_cnt      (S_pla_slice_sa23_cnt ),
.I_pla_slice_sa24_cnt      (S_pla_slice_sa24_cnt ),
.I_pla_slice_sa25_cnt      (S_pla_slice_sa25_cnt ),
.I_pla_slice_sa26_cnt      (S_pla_slice_sa26_cnt ),
.I_pla_slice_sa27_cnt      (S_pla_slice_sa27_cnt ),
.I_state                   (S_state              ),

.I_frame_dpram_usedw_back_pla0  (S_frame_dpram_usedw_back_pla0  ),
.I_frame_dpram_usedw_back_pla1  (S_frame_dpram_usedw_back_pla1  ),
.I_frame_dpram_usedw_back_pla2  (S_frame_dpram_usedw_back_pla2  ),

.I_err_tme_cnt             (S_err_tme_cnt       ),
.I_small_inter_cnt         (S_small_inter_cnt   ), 
.O_pause_en                (S_pause_en          )

 
);


////外部或者内部自环,提供request报文
pla_loop_set U04_pla_loop_set
(
.I_pla_312m5_clk         (I_pla_312m5_clk           ),
.I_pla_rst               (I_pla_rst                 ),
.I_pla_loop_en           (S_pla_loop_en[1:0]        ),
.I_pla_loop_link         (S_pla_loop_link           ),
.I_loop_request_ifg      (S_loop_request_ifg        ),///16'h1400                  ),//反向数据带REQUEST报文间隔

.I_pla0_air_mac_0        (S_pla0_air_mac_0          ),
.I_pla0_air_mac_1        (S_pla0_air_mac_1          ),
.I_pla0_air_mac_2        (S_pla0_air_mac_2          ),
.I_pla0_air_mac_3        (S_pla0_air_mac_3          ),
.I_pla0_air_mac_4        (S_pla0_air_mac_4          ),
.I_pla0_air_mac_5        (S_pla0_air_mac_5          ),
.I_pla0_air_mac_6        (S_pla0_air_mac_6          ),
.I_pla0_air_mac_7        (S_pla0_air_mac_7          ),
.I_pla1_air_mac_0        (S_pla1_air_mac_0          ),
.I_pla1_air_mac_1        (S_pla1_air_mac_1          ),
.I_pla1_air_mac_2        (S_pla1_air_mac_2          ),
.I_pla1_air_mac_3        (S_pla1_air_mac_3          ),
.I_pla1_air_mac_4        (S_pla1_air_mac_4          ),
.I_pla1_air_mac_5        (S_pla1_air_mac_5          ),
.I_pla1_air_mac_6        (S_pla1_air_mac_6          ),
.I_pla1_air_mac_7        (S_pla1_air_mac_7          ),
.I_pla2_air_mac_0        (S_pla2_air_mac_0          ),
.I_pla2_air_mac_1        (S_pla2_air_mac_1          ),
.I_pla2_air_mac_2        (S_pla2_air_mac_2          ),
.I_pla2_air_mac_3        (S_pla2_air_mac_3          ),
.I_pla2_air_mac_4        (S_pla2_air_mac_4          ),
.I_pla2_air_mac_5        (S_pla2_air_mac_5          ),
.I_pla2_air_mac_6        (S_pla2_air_mac_6          ),
.I_pla2_air_mac_7        (S_pla2_air_mac_7          ),

.I_pla0_rcu_req_mac      (S_pla0_rcu_mac            ),
.I_pla1_rcu_req_mac      (S_pla1_rcu_mac            ),
.I_pla2_rcu_req_mac      (S_pla2_rcu_mac            ),

.I_back1_air_txd         (S_back_xgmii_pla_tc_rxd   ),//反向数据 
.I_back1_air_txc         (S_back_xgmii_pla_tc_rxc   ),//
.I_for2_air_txd          (O_for_xgmii_pla_txd       ),//前向输出数据
.I_for2_air_txc          (O_for_xgmii_pla_txc       ),
.O_loop_xgmii_pla_txd    (S_back_loop_request_txd   ),//反向数据带REQUEST报文,输出给反向模块
.O_loop_xgmii_pla_txc    (S_back_loop_request_txc   )

);

always@(posedge I_pla_312m5_clk)
begin
    S_pla_rst <= I_pla_rst;
end

always@(posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S_hc_for_en <= 3'd0;
    end
    else if(S_rate_limit_test[15]) //透传
    begin
        S_hc_for_en <= S_rate_limit_test[2:0];
    end
    else
    begin
        S_hc_for_en <= I_hc_for_en;   
    end
end

/////反向信号PASS处理
always@(posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        O_back_xgmii_pla_rxd <= 32'd0;
        O_back_xgmii_pla_rxc <= 4'hf;
        O_back_xgmii_pla_num <= 2'd0;
    end
    else if(S_pla_pass_en[1]) //透传
    begin
        O_back_xgmii_pla_rxd  <= I_back_xgmii_rxd  ;
        O_back_xgmii_pla_rxc  <= I_back_xgmii_rxc  ;
        O_back_xgmii_pla_num  <= 2'd0;
    end
    else
    begin
        O_back_xgmii_pla_rxd <= S_back_xgmii_pla_rxd;   ///反向输出数据
        O_back_xgmii_pla_rxc <= S_back_xgmii_pla_rxc;
        O_back_xgmii_pla_num <= S_back_xgmii_pla_num;
    end
end

/////前向信号PASS处理
always@(posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        O_for_xgmii_pla_txd  <= 32'd0;
        O_for_xgmii_pla_txc  <= 4'hf;
        O_for_xgmii_pla_num  <= 2'd0; 
    end
    else if(S_pla_pass_en[0]) 
    begin
        O_for_xgmii_pla_txd <= I_for_xgmii_hc_txd  ;
        O_for_xgmii_pla_txc <= I_for_xgmii_hc_txc  ;
        O_for_xgmii_pla_num <= I_for_xgmii_hc_num  ;
    end
    else 
    begin
        O_for_xgmii_pla_txd <= S_for_xgmii_pla_tc_txd ;
        O_for_xgmii_pla_txc <= S_for_xgmii_pla_tc_txc ;
        O_for_xgmii_pla_num <= S_for_xgmii_pla_tc_num ;
    end
end




pla_ptp_top U_pla_ptp_top(
.I_clk_312m                   (I_pla_312m5_clk         ), 
.I_rst                        (I_pla_rst || S_module_rst[3]  ),  

//.I_tx_pla_dmac                (),
//.I_tx_pla_smac                (),
.I_tx_xgmii_data              (S_for_xgmii_pla_txd     ),       
.I_tx_xgmii_txc               (S_for_xgmii_pla_txc     ),       
.I_tx_xgmii_err               (S_for_xgmii_pla_num     ),

.O_xgmii_tx_data              (S_for_xgmii_pla_tc_txd  ),
.O_xgmii_tx_txc               (S_for_xgmii_pla_tc_txc  ),
.O_xgmii_tx_err               (S_for_xgmii_pla_tc_num  ),

.O_xgmii_tx_ptp_data          (                        ),                  //1588抓锟斤拷
.O_xgmii_tx_ptp_txc           (                        ),                  //1588抓锟斤拷
.O_xgmii_tx_ptp_err           (                        ),                  //1588抓锟斤拷
    ///////////锟斤拷维锟缴测部锟街接匡拷//////////////////////  
.I_pla_tc_bypass              (S_pla_tc_bypass         ),                                          //前锟斤拷锟斤拷锟斤拷bypass
.I_rd_cnt_clr                 (S_clear_forward_en[0]   ),    

.O_pkt_cnt_slice_in           (S_pkt_cnt_slice_in      ),
.O_ptp_cnt_in                 (S_ptp_cnt_in            ),
.O_vlan_ptp_cnt_in            (S_vlan_ptp_cnt_in       ),
.O_ptp_no_vlan_cnt_out        (S_ptp_no_vlan_cnt_out   ),
.O_ptp_vlan_cnt_out           (S_ptp_vlan_cnt_out      ),
.O_slice_cnt_out              (S_slice_cnt_out         ),
.O_packet_cnt_out             (S_packet_cnt_out        ),
    ///////////锟斤拷维锟缴测部锟街接匡拷end//////////////////////
//锟斤拷锟斤拷                                                 
.I_rx_xgmii_data              (I_back_xgmii_rxd        ),   
.I_rx_xgmii_txc               (I_back_xgmii_rxc        ),   
.I_rx_xgmii_err               (                        ),                  //NC

.O_xgmii_rx_data              (S_back_xgmii_pla_tc_rxd ),
.O_xgmii_rx_txc               (S_back_xgmii_pla_tc_rxc ),
.O_xgmii_rx_err               (                        ),                  //NC  

.I_subport_num                (I_back_xgmii_num        ),
.I_pla_slice_da0              (S_pla0_rcu_mac          ),
.I_pla_slice_da1              (S_pla1_rcu_mac          ),
.I_pla_slice_da2              (S_pla2_rcu_mac          ),
.I_pla_slice_sa00             (S_pla0_air_mac_0        ),
.I_pla_slice_sa01             (S_pla0_air_mac_1        ),
.I_pla_slice_sa02             (S_pla0_air_mac_2        ),
.I_pla_slice_sa03             (S_pla0_air_mac_3        ),
.I_pla_slice_sa04             (S_pla0_air_mac_4        ),
.I_pla_slice_sa05             (S_pla0_air_mac_5        ),
.I_pla_slice_sa06             (S_pla0_air_mac_6        ),
.I_pla_slice_sa07             (S_pla0_air_mac_7        ),
.I_pla_slice_sa10             (S_pla1_air_mac_0        ),
.I_pla_slice_sa11             (S_pla1_air_mac_1        ),
.I_pla_slice_sa12             (S_pla1_air_mac_2        ),
.I_pla_slice_sa13             (S_pla1_air_mac_3        ),
.I_pla_slice_sa14             (S_pla1_air_mac_4        ),
.I_pla_slice_sa15             (S_pla1_air_mac_5        ),
.I_pla_slice_sa16             (S_pla1_air_mac_6        ),
.I_pla_slice_sa17             (S_pla1_air_mac_7        ),
.I_pla_slice_sa20             (S_pla2_air_mac_0        ),
.I_pla_slice_sa21             (S_pla2_air_mac_1        ),
.I_pla_slice_sa22             (S_pla2_air_mac_2        ),
.I_pla_slice_sa23             (S_pla2_air_mac_3        ),
.I_pla_slice_sa24             (S_pla2_air_mac_4        ),
.I_pla_slice_sa25             (S_pla2_air_mac_5        ),
.I_pla_slice_sa26             (S_pla2_air_mac_6        ),
.I_pla_slice_sa27             (S_pla2_air_mac_7        ),

.I_clear_en                   (S_clear_en              ),
.I_clear_subport0_en          (S_clear_subport0_en     ),
.I_clear_subport1_en          (S_clear_subport1_en     ),
.I_clear_subport2_en          (S_clear_subport2_en     ),

.O_fifo_usedw                 (S_fifo_usedw            ),
.O_1588_packet_in_num         (S_1588_packet_in_num    ),         
.O_1588_packet_out_num        (S_1588_packet_out_num   ),     
.O_all_packet_in_num          (S_all_packet_in_num     ),     
.O_all_packet_out_num         (S_all_packet_out_num    ),     
.O_pla_slice_sa00_cnt         (S_pla_slice_sa00_cnt    ),     
.O_pla_slice_sa01_cnt         (S_pla_slice_sa01_cnt    ),     
.O_pla_slice_sa02_cnt         (S_pla_slice_sa02_cnt    ),     
.O_pla_slice_sa03_cnt         (S_pla_slice_sa03_cnt    ),     
.O_pla_slice_sa04_cnt         (S_pla_slice_sa04_cnt    ),     
.O_pla_slice_sa05_cnt         (S_pla_slice_sa05_cnt    ),     
.O_pla_slice_sa06_cnt         (S_pla_slice_sa06_cnt    ),     
.O_pla_slice_sa07_cnt         (S_pla_slice_sa07_cnt    ),     
.O_pla_slice_sa10_cnt         (S_pla_slice_sa10_cnt    ),     
.O_pla_slice_sa11_cnt         (S_pla_slice_sa11_cnt    ),     
.O_pla_slice_sa12_cnt         (S_pla_slice_sa12_cnt    ),     
.O_pla_slice_sa13_cnt         (S_pla_slice_sa13_cnt    ),     
.O_pla_slice_sa14_cnt         (S_pla_slice_sa14_cnt    ),     
.O_pla_slice_sa15_cnt         (S_pla_slice_sa15_cnt    ),     
.O_pla_slice_sa16_cnt         (S_pla_slice_sa16_cnt    ),     
.O_pla_slice_sa17_cnt         (S_pla_slice_sa17_cnt    ),     
.O_pla_slice_sa20_cnt         (S_pla_slice_sa20_cnt    ),     
.O_pla_slice_sa21_cnt         (S_pla_slice_sa21_cnt    ),     
.O_pla_slice_sa22_cnt         (S_pla_slice_sa22_cnt    ),         
.O_pla_slice_sa23_cnt         (S_pla_slice_sa23_cnt    ),            
.O_pla_slice_sa24_cnt         (S_pla_slice_sa24_cnt    ),            
.O_pla_slice_sa25_cnt         (S_pla_slice_sa25_cnt    ),            
.O_pla_slice_sa26_cnt         (S_pla_slice_sa26_cnt    ),            
.O_pla_slice_sa27_cnt         (S_pla_slice_sa27_cnt    ),            
.O_state                      (S_state                 )            
);




/// pla_num_test U04_pla_num_test
/// (                     
/// .I_pla_312m5_clk          (I_pla_312m5_clk      )  ,     
/// .I_pla_rst                (I_pla_rst            )  ,   
/// .I_num_test_en            (S_num_test_en        )  ,  
/// .I_for_xgmii_txd          (I_for_xgmii_hc_txd   )  ,     
/// .I_for_xgmii_txc          (I_for_xgmii_hc_txc   )  ,     
/// .I_for_xgmii_num          (I_for_xgmii_hc_num   )  ,     
/// .O_for_xgmii_txd          (S_for_xgmii_hc_txd   )  , 
/// .O_for_xgmii_txc          (S_for_xgmii_hc_txc   )  , 
/// .O_for_xgmii_num          (S_for_xgmii_hc_num   )  ,
/// .I_back_xgmii_txd         (S_back_xgmii_pla_rxd )  ,       
/// .I_back_xgmii_txc         (S_back_xgmii_pla_rxc )  ,       
/// .I_back_xgmii_num         (S_back_xgmii_pla_num )  ,      
/// .I_back_xgmii_err         (S_back_xgmii_pla_crc )  ,
/// .O_back_xgmii_txd         (S1_back_xgmii_pla_rxd)  ,   
/// .O_back_xgmii_txc         (S1_back_xgmii_pla_rxc)  ,   
/// .O_back_xgmii_num         (S1_back_xgmii_pla_num)  ,
/// .I_statics_clr            (S_cnt_clear       ),  
/// .O_pla0_forin_crcok_cnt   (S_pla0_forin_crcok_cnt   ),
/// .O_pla0_forin_crcerr_cnt  (S_pla0_forin_crcerr_cnt  ),
/// .O_pla1_forin_crcok_cnt   (S_pla1_forin_crcok_cnt   ),
/// .O_pla1_forin_crcerr_cnt  (S_pla1_forin_crcerr_cnt  ),
/// .O_pla2_forin_crcok_cnt   (S_pla2_forin_crcok_cnt   ),
/// .O_pla2_forin_crcerr_cnt  (S_pla2_forin_crcerr_cnt  ),
/// 
/// .O_back0_lose_cnt         (S_back0_lose_num_cnt  ),  
/// .O_back1_lose_cnt         (S_back1_lose_num_cnt  ),  
/// .O_back2_lose_cnt         (S_back2_lose_num_cnt  )
/// );

endmodule
