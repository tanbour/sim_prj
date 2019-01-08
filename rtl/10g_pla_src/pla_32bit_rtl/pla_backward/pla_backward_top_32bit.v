//FILE_HEADER-----------------------------------------------------------------
//ZTE  Copyright (C)
//ZTE Company Confidential
//----------------------------------------------------------------------------
//Project Name : RCUB PLA
//FILE NAME    : pla_forward.v
//AUTHOR       : Li Shuai
//Department   : ZTE-BBU-SHENZHEN-DESIGN-DEPARTMENT
//Email        : li.shuai3@zte.com.cn
//----------------------------------------------------------------------------
//Module Hiberarchy :
//x                         |--U01_pla_request_parser
//x                         |--U02_pla_backward_parser_32bit
//x pla_backward_top_32bit--|--U03_pla_backward_slice_cycle_ddr 
//x                         |--U04_pla_backward_reflow_32bit  
//x                         |--U05_pla_backward_reflow_32bit  
//x                         |--U06_pla_backward_reflow_32bit
//x                         |--U07_pla_backward_reframer_32bit
//----------------------------------------------------------------------------
//Relaese History :
//----------------------------------------------------------------------------
//Version         Date           Author        Description
// 1.1          nov-30-2011                    pla_backward
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


`timescale 1ns/1ps
module pla_backward_top_32bit(
///for ddr simu test start
output              O_ddr1_rdy,
output              O_ddr_rdy ,
///===============================================
input               I_pla_312m5_clk          ,
input               I_pla_rst                ,
input               I_pla_ddr_rst            ,
input     [47:0]    I_pla0_air_mac_0         ,
input     [47:0]    I_pla0_air_mac_1         ,
input     [47:0]    I_pla0_air_mac_2         ,
input     [47:0]    I_pla0_air_mac_3         ,
input     [47:0]    I_pla0_air_mac_4         ,
input     [47:0]    I_pla0_air_mac_5         ,
input     [47:0]    I_pla0_air_mac_6         ,
input     [47:0]    I_pla0_air_mac_7         ,
input     [47:0]    I_pla1_air_mac_0         ,
input     [47:0]    I_pla1_air_mac_1         ,
input     [47:0]    I_pla1_air_mac_2         ,
input     [47:0]    I_pla1_air_mac_3         ,
input     [47:0]    I_pla1_air_mac_4         ,
input     [47:0]    I_pla1_air_mac_5         ,
input     [47:0]    I_pla1_air_mac_6         ,
input     [47:0]    I_pla1_air_mac_7         ,
input     [47:0]    I_pla2_air_mac_0         ,
input     [47:0]    I_pla2_air_mac_1         ,
input     [47:0]    I_pla2_air_mac_2         ,
input     [47:0]    I_pla2_air_mac_3         ,
input     [47:0]    I_pla2_air_mac_4         ,
input     [47:0]    I_pla2_air_mac_5         ,
input     [47:0]    I_pla2_air_mac_6         ,
input     [47:0]    I_pla2_air_mac_7         ,
input     [47:0]    I_pla0_rcu_mac           ,
input     [47:0]    I_pla1_rcu_mac           ,
input     [47:0]    I_pla2_rcu_mac           ,

input     [31:0]    I_xgmii_rxd              ,
input     [3:0]     I_xgmii_rxc              ,
input      [15:0]   I_cnt_clear              ,
input      [15:0]   I_request_wait_time      ,
input               I_request_wait_en        ,
input      [2:0]    I_hc_for_en              ,  

input      [15:0]   I_pla_int_mask           ,  
input      [15:0]   I_pla_int_clr            ,  
output     [15:0]   O_pla_rmu_int            ,       
output     [15:0]   O_pla_int_event          ,
output              O_pla_int_n              , 
output     [19:0]   O_pla0_rmu_rate          ,
output     [19:0]   O_pla1_rmu_rate          ,
output     [19:0]   O_pla2_rmu_rate          ,
output     [15:0]   O_pla0_cu_rate_chg_cnt   ,
output     [15:0]   O_pla1_cu_rate_chg_cnt   ,
output     [15:0]   O_pla2_cu_rate_chg_cnt   ,

output    [7:0]     O_pla0_air_link          ,
output    [7:0]     O_pla1_air_link          ,
output    [7:0]     O_pla2_air_link          ,

output    [31:0]    O_pla_xgmii_rxd          ,
output    [3:0]     O_pla_xgmii_rxc          ,
output    [1:0]     O_pla_xgmii_pla_num      ,
output              O_pla_xgmii_err          ,


///check module pla back 
output    [15:0]    O_pla_slice_crc_ok_cnt   ,///cpu interface
output    [15:0]    O_pla_slice_crc_err_cnt  ,///cpu interface
output    [15:0]    O_all_err_cnt            ,
output    [15:0]    O_fifo_full0_cnt         ,
output    [15:0]    O_ram_full0_cnt          ,
output    [15:0]    O_length_err0_cnt        ,
output    [15:0]    O_input_crcok_cnt        ,           
output    [15:0]    O_input_crcerr_cnt       ,           
output    [15:0]    O_output_crcok_cnt       ,           
output    [15:0]    O_output_crcerr_cnt      ,           
output    [15:0]    O_feedback_cnt           ,           
output    [15:0]    O_drop_flag_cnt          ,           
output    [15:0]    O_pla0_reframe_fifo_wr_cnt, 
output    [15:0]    O_reframe_pla0_55d5_cnt ,          
                                                 
output    [15:0]    O_reframe_state_change_cnt ,
output    [15:0]    O_slice_cnt                ,

input               I_pla_feedback_rd_pla0     ,
output    [31:0]    O_feedback_fifo_rdata_pla0 ,
output    [5:0 ]    O_feedback_fifo_count_pla0 ,
output              O_feedback_fifo_full_pla0  ,
output              O_feedback_fifo_empty_pla0 ,
output              O_pla_slice_fifo_empty_pla0,

input               I_pla_feedback_rd_pla1      ,
output    [31:0]    O_feedback_fifo_rdata_pla1  ,
output    [5:0 ]    O_feedback_fifo_count_pla1  ,
output              O_feedback_fifo_full_pla1   ,
output              O_feedback_fifo_empty_pla1  ,
output              O_pla_slice_fifo_empty_pla1 ,

input               I_pla_feedback_rd_pla2     ,
output    [31:0]    O_feedback_fifo_rdata_pla2 ,
output    [5:0 ]    O_feedback_fifo_count_pla2 ,
output              O_feedback_fifo_full_pla2  ,
output              O_feedback_fifo_empty_pla2 ,
output              O_pla_slice_fifo_empty_pla2 ,

input     [14:0]    I_pla_slice_window   ,
////输出到前向      
output     [7:0]    O_pla0_air_request       ,
output     [7:0]    O_pla1_air_request       ,
output     [7:0]    O_pla2_air_request       ,
           

input     [31:0]    I_pla0_test_freq_0 ,
input     [31:0]    I_pla0_test_freq_1 ,
input     [31:0]    I_pla0_test_freq_2 ,
input     [31:0]    I_pla0_test_freq_3 ,
input     [31:0]    I_pla0_test_freq_4 ,
input     [31:0]    I_pla0_test_freq_5 ,
input     [31:0]    I_pla0_test_freq_6 ,
input     [31:0]    I_pla0_test_freq_7 ,
input     [31:0]    I_pla1_test_freq_0 ,
input     [31:0]    I_pla1_test_freq_1 ,
input     [31:0]    I_pla1_test_freq_2 ,
input     [31:0]    I_pla1_test_freq_3 ,
input     [31:0]    I_pla1_test_freq_4 ,
input     [31:0]    I_pla1_test_freq_5 ,
input     [31:0]    I_pla1_test_freq_6 ,
input     [31:0]    I_pla1_test_freq_7 ,
input     [31:0]    I_pla2_test_freq_0 ,
input     [31:0]    I_pla2_test_freq_1 ,
input     [31:0]    I_pla2_test_freq_2 ,
input     [31:0]    I_pla2_test_freq_3 ,
input     [31:0]    I_pla2_test_freq_4 ,
input     [31:0]    I_pla2_test_freq_5 ,
input     [31:0]    I_pla2_test_freq_6 ,
input     [31:0]    I_pla2_test_freq_7 ,
            


///LOCAL BUS接口    
output     [7:0]    O_pla0_air_pause    ,
output     [7:0]    O_pla1_air_pause    ,
output     [7:0]    O_pla2_air_pause    ,

output    [31:0]  O_pla00_current_freq    ,
output    [31:0]  O_pla01_current_freq    ,
output    [31:0]  O_pla02_current_freq    ,
output    [31:0]  O_pla03_current_freq    ,
output    [31:0]  O_pla04_current_freq    ,
output    [31:0]  O_pla05_current_freq    ,
output    [31:0]  O_pla06_current_freq    ,
output    [31:0]  O_pla07_current_freq    ,
output    [31:0]  O_pla10_current_freq    ,
output    [31:0]  O_pla11_current_freq    ,
output    [31:0]  O_pla12_current_freq    ,
output    [31:0]  O_pla13_current_freq    ,
output    [31:0]  O_pla14_current_freq    ,
output    [31:0]  O_pla15_current_freq    ,
output    [31:0]  O_pla16_current_freq    ,
output    [31:0]  O_pla17_current_freq    ,
output    [31:0]  O_pla20_current_freq    ,
output    [31:0]  O_pla21_current_freq    ,
output    [31:0]  O_pla22_current_freq    ,
output    [31:0]  O_pla23_current_freq    ,
output    [31:0]  O_pla24_current_freq    ,
output    [31:0]  O_pla25_current_freq    ,
output    [31:0]  O_pla26_current_freq    ,
output    [31:0]  O_pla27_current_freq    ,

output    [3:0]   O_pla00_current_acm    ,
output    [3:0]   O_pla01_current_acm    ,
output    [3:0]   O_pla02_current_acm    ,
output    [3:0]   O_pla03_current_acm    ,
output    [3:0]   O_pla04_current_acm    ,
output    [3:0]   O_pla05_current_acm    ,
output    [3:0]   O_pla06_current_acm    ,
output    [3:0]   O_pla07_current_acm    ,
output    [3:0]   O_pla10_current_acm    ,
output    [3:0]   O_pla11_current_acm    ,
output    [3:0]   O_pla12_current_acm    ,
output    [3:0]   O_pla13_current_acm    ,
output    [3:0]   O_pla14_current_acm    ,
output    [3:0]   O_pla15_current_acm    ,
output    [3:0]   O_pla16_current_acm    ,
output    [3:0]   O_pla17_current_acm    ,
output    [3:0]   O_pla20_current_acm    ,
output    [3:0]   O_pla21_current_acm    ,
output    [3:0]   O_pla22_current_acm    ,
output    [3:0]   O_pla23_current_acm    ,
output    [3:0]   O_pla24_current_acm    ,
output    [3:0]   O_pla25_current_acm    ,
output    [3:0]   O_pla26_current_acm    ,
output    [3:0]   O_pla27_current_acm    ,


output    [15:0]  O_pla00_rmu_rate    ,
output    [15:0]  O_pla01_rmu_rate    ,
output    [15:0]  O_pla02_rmu_rate    ,
output    [15:0]  O_pla03_rmu_rate    ,
output    [15:0]  O_pla04_rmu_rate    ,
output    [15:0]  O_pla05_rmu_rate    ,
output    [15:0]  O_pla06_rmu_rate    ,
output    [15:0]  O_pla07_rmu_rate    ,
output    [15:0]  O_pla10_rmu_rate    ,
output    [15:0]  O_pla11_rmu_rate    ,
output    [15:0]  O_pla12_rmu_rate    ,
output    [15:0]  O_pla13_rmu_rate    ,
output    [15:0]  O_pla14_rmu_rate    ,
output    [15:0]  O_pla15_rmu_rate    ,
output    [15:0]  O_pla16_rmu_rate    ,
output    [15:0]  O_pla17_rmu_rate    ,
output    [15:0]  O_pla20_rmu_rate    ,
output    [15:0]  O_pla21_rmu_rate    ,
output    [15:0]  O_pla22_rmu_rate    ,
output    [15:0]  O_pla23_rmu_rate    ,
output    [15:0]  O_pla24_rmu_rate    ,
output    [15:0]  O_pla25_rmu_rate    ,
output    [15:0]  O_pla26_rmu_rate    ,
output    [15:0]  O_pla27_rmu_rate    ,

input     [23:0]  I_pla_air_link_change_mask,
output    [23:0]  O_pla_air_link_change_flg ,

output    [47:0]  O_pla00_req_change_cnt  ,
output    [47:0]  O_pla01_req_change_cnt  ,
output    [47:0]  O_pla02_req_change_cnt  ,
output    [47:0]  O_pla03_req_change_cnt  ,
output    [47:0]  O_pla04_req_change_cnt  ,
output    [47:0]  O_pla05_req_change_cnt  ,
output    [47:0]  O_pla06_req_change_cnt  ,
output    [47:0]  O_pla07_req_change_cnt  ,  
output    [47:0]  O_pla10_req_change_cnt ,
output    [47:0]  O_pla11_req_change_cnt ,
output    [47:0]  O_pla12_req_change_cnt ,
output    [47:0]  O_pla13_req_change_cnt ,
output    [47:0]  O_pla14_req_change_cnt ,
output    [47:0]  O_pla15_req_change_cnt ,
output    [47:0]  O_pla16_req_change_cnt ,
output    [47:0]  O_pla17_req_change_cnt ,
output    [47:0]  O_pla20_req_change_cnt  ,
output    [47:0]  O_pla21_req_change_cnt  ,
output    [47:0]  O_pla22_req_change_cnt  ,
output    [47:0]  O_pla23_req_change_cnt  ,
output    [47:0]  O_pla24_req_change_cnt  ,
output    [47:0]  O_pla25_req_change_cnt  ,
output    [47:0]  O_pla26_req_change_cnt  ,
output    [47:0]  O_pla27_req_change_cnt  ,

///ddr monitor
input		[ 5:0]	I_slice_rd_en_valid_cnt_fix		,
output		[15:0]  O_pla_slice_mac_err_cnt			,
output		[15:0]  O_pla_slice_len_err_cnt			,
output		[ 7:0]	O_pla0_slice_id_random_order	,
output		[ 7:0]	O_pla1_slice_id_random_order	,
output		[ 7:0]	O_pla2_slice_id_random_order	,
output		[15:0]	O_pla0_slice_id_bottom_err_cnt	,
output		[15:0]	O_pla1_slice_id_bottom_err_cnt	,
output		[15:0]	O_pla2_slice_id_bottom_err_cnt	,


output    [15:0]    O_pla0_slice_ok_cnt    ,
output    [15:0]    O_pla0_slice_wr_cnt    ,
output    [15:0]    O_pla0_slice_rd_cnt    ,
output    [15:0]    O_pla0_slice_crc_err_cnt	,
output    [15:0]    O_pla1_slice_ok_cnt    ,
output    [15:0]    O_pla1_slice_wr_cnt    ,
output    [15:0]    O_pla1_slice_rd_cnt    ,
output    [15:0]    O_pla1_slice_crc_err_cnt	,
output    [15:0]    O_pla2_slice_ok_cnt    ,
output    [15:0]    O_pla2_slice_wr_cnt    ,
output    [15:0]    O_pla2_slice_rd_cnt    ,
output    [15:0]    O_pla2_slice_crc_err_cnt	,

output	  [15:0]	O_ddr3a_app_wdf_rdy_low_cnt_max	,	
output	  [15:0]	O_ddr3a_wr_app_rdy_low_cnt_max	,	
output	  [15:0]	O_ddr3a_rd_app_rdy_low_cnt_max	,	
output	  [15:0]	O_ddr3a_app_write_err_cnt		,	
output	  [15:0]	O_ddr3a_buf_full_cnt			,	
output	  [15:0]	O_ddr3b_app_wdf_rdy_low_cnt_max	,	
output	  [15:0]	O_ddr3b_wr_app_rdy_low_cnt_max	,	
output	  [15:0]	O_ddr3b_rd_app_rdy_low_cnt_max	,	
output	  [15:0]	O_ddr3b_app_write_err_cnt		,	
output	  [15:0]	O_ddr3b_buf_full_cnt			,	

output    [47:0]    O_ddr0_reflow_55D5_cnt  ,
output    [47:0]    O_ddr0_reflow_lose_cnt  ,
output    [2:0]     O_ddr0_reflow_lose_reg  ,

output    [31:0]    O_pla0_reflow_rderr_cnt,
output    [31:0]    O_pla1_reflow_rderr_cnt,
output    [31:0]    O_pla2_reflow_rderr_cnt,

output    [47:0]    O_pla0_reflow_id_wl        ,
output    [47:0]    O_pla1_reflow_id_wl        ,
output    [47:0]    O_pla2_reflow_id_wl        ,
output    [2:0]     O_pla_slice_id_depth_alful,
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
input              I_pause_from_back_hc,

output [31:0] O_pla0_pla_bac_reframer_input_data_catch ,
output        O_pla0_pla_bac_reframer_input_en_catch   ,
output        O_pla0_time_out_flag_catch               ,
output [3:0 ] O_pla0_reframe_state_catch               ,
output        O_pla0_length_err_catch                  ,
output [15:0] O_pla_rst_cnt                            ,

output [15:0] O_frame_dpram_usedw_back_pla0            ,
output [15:0] O_frame_dpram_usedw_back_pla1            ,
output [15:0] O_frame_dpram_usedw_back_pla2            ,

output [15:0] O_err_tme_cnt                            ,
output [15:0] O_small_inter_cnt                        ,
input         I_pause_en                               ,
output        O_crc_wrong                              
);

wire      [31:0]    S_xgmii_rxd       ;
wire      [3:0]     S_xgmii_rxc       ;
wire      [14:0]    S_pla_slice_id              ;
wire      [31:0]    S_pla_slice_payload         ;
wire                S_pla_slice_payload_en      ;
wire      [1:0]     S_xgmii_pla_num             ;
wire                S_pla0_slice_wr_resp        ;
wire      [14:0]    S_pla0_slice_num_id         ;
wire      [14:0]    S_pla1_slice_num_id         ;
wire      [14:0]    S_pla2_slice_num_id         ;
wire                S_pla1_slice_wr_resp        ;
wire                S_pla2_slice_wr_resp        ;
wire                S_pla0_slice_check_ok       ;///pulse
wire                S_pla1_slice_check_ok       ;///pulse
wire                S_pla2_slice_check_ok       ;///pulse
wire      [14:0]    S_pla0_slice_id_new         ;
wire                S_pla0_slice_id_new_valid   ;
wire      [14:0]    S_pla1_slice_id_new         ;
wire                S_pla1_slice_id_new_valid   ;
wire      [14:0]    S_pla2_slice_id_new         ;
wire                S_pla2_slice_id_new_valid   ;
wire      [14:0]    S_pla0_slice_id_max         ;
wire      [14:0]    S_pla0_slice_id_min         ;
wire      [14:0]    S_pla1_slice_id_max         ;
wire      [14:0]    S_pla1_slice_id_min         ;
wire      [14:0]    S_pla2_slice_id_max         ;
wire      [14:0]    S_pla2_slice_id_min         ;
wire                S_pla0_slice_rd_resp        ;
wire      [31:0]    S_pla0_slice_rdata          ;
wire                S_pla0_reflow_fifo_rd       ;
wire                S_pla0_slice_rd_req         ;
wire      [14:0]    S_pla0_slice_rd_id          ;
wire                S_pla0_slice_data_rd        ;
wire      [32:0]    S_pla0_reflow_fifo_rdata    ;
wire                S_pla0_reflow_fifo_empty    ;
wire                S_pla1_slice_rd_resp        ;
wire      [31:0]    S_pla1_slice_rdata          ;
wire                S_pla1_reflow_fifo_rd       ;
wire                S_pla1_slice_rd_req         ;
wire      [14:0]    S_pla1_slice_rd_id          ;
wire                S_pla1_slice_data_rd        ;
wire      [32:0]    S_pla1_reflow_fifo_rdata    ;
wire                S_pla1_reflow_fifo_empty    ;
wire                S_pla2_slice_rd_resp        ;
wire      [31:0]    S_pla2_slice_rdata          ;
wire                S_pla2_reflow_fifo_rd       ;
wire                S_pla2_slice_rd_req         ;
wire      [14:0]    S_pla2_slice_rd_id          ;
wire                S_pla2_slice_data_rd        ;
wire      [32:0]    S_pla2_reflow_fifo_rdata    ;
wire                S_pla2_reflow_fifo_empty    ;
wire    [1:0]       S_pla_debug_num;
wire                S_crc_wrong_input           ;
wire                S_crc_ok_input              ;
wire                S_crc_wrong_output          ;
wire                S_crc_ok_output             ;
wire				S_312m5_clk_rst				;	


wire  [15:0]       S_frame_dpram_usedw_back_pla0;
wire  [15:0]       S_frame_dpram_usedw_back_pla1;
wire  [15:0]       S_frame_dpram_usedw_back_pla2;



reg [2:0]  S_ddr0_reflow_lose_reg ;
reg [2:0]  S_ddr0_reflow_trig ;

always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S_ddr0_reflow_trig <= 1'd0;
        S_ddr0_reflow_lose_reg <= 3'd0;
    end
    else 
    begin
        S_ddr0_reflow_lose_reg <= O_ddr0_reflow_lose_reg;
        S_ddr0_reflow_trig <= |S_ddr0_reflow_lose_reg;
    end
end


pla_request_parser_32bit U01_pla_request_parser(
.I_pla_312m5_clk         (I_pla_312m5_clk          ),
.I_pla_rst               (I_pla_rst                ),
.I_cnt_clear             (I_cnt_clear[0]           ),
.I_pla_air_link_change_mask (I_pla_air_link_change_mask   ),  
.O_pla_air_link_change_flg  (O_pla_air_link_change_flg    ),  
.I_pla0_air_mac_0        (I_pla0_air_mac_0         ),
.I_pla0_air_mac_1        (I_pla0_air_mac_1         ),
.I_pla0_air_mac_2        (I_pla0_air_mac_2         ),
.I_pla0_air_mac_3        (I_pla0_air_mac_3         ),
.I_pla0_air_mac_4        (I_pla0_air_mac_4         ),
.I_pla0_air_mac_5        (I_pla0_air_mac_5         ),
.I_pla0_air_mac_6        (I_pla0_air_mac_6         ),
.I_pla0_air_mac_7        (I_pla0_air_mac_7         ),
.I_pla1_air_mac_0        (I_pla1_air_mac_0         ),
.I_pla1_air_mac_1        (I_pla1_air_mac_1         ),
.I_pla1_air_mac_2        (I_pla1_air_mac_2         ),
.I_pla1_air_mac_3        (I_pla1_air_mac_3         ),
.I_pla1_air_mac_4        (I_pla1_air_mac_4         ),
.I_pla1_air_mac_5        (I_pla1_air_mac_5         ),
.I_pla1_air_mac_6        (I_pla1_air_mac_6         ),
.I_pla1_air_mac_7        (I_pla1_air_mac_7         ),
.I_pla2_air_mac_0        (I_pla2_air_mac_0         ),
.I_pla2_air_mac_1        (I_pla2_air_mac_1         ),
.I_pla2_air_mac_2        (I_pla2_air_mac_2         ),
.I_pla2_air_mac_3        (I_pla2_air_mac_3         ),
.I_pla2_air_mac_4        (I_pla2_air_mac_4         ),
.I_pla2_air_mac_5        (I_pla2_air_mac_5         ),
.I_pla2_air_mac_6        (I_pla2_air_mac_6         ),
.I_pla2_air_mac_7        (I_pla2_air_mac_7         ),
.I_pla0_rcu_mac          (I_pla0_rcu_mac           ),
.I_pla1_rcu_mac          (I_pla1_rcu_mac           ),
.I_pla2_rcu_mac          (I_pla2_rcu_mac           ),

.I_xgmii_rxd             (I_xgmii_rxd              ),
.I_xgmii_rxc             (I_xgmii_rxc              ),
.I_request_wait_time     (I_request_wait_time      ),   ////4us的整数倍，单位是4us, 1250*4us = 5ms), ///   16'd1250                 
.I_request_wait_en       (I_request_wait_en        ),       
                       
.I_hc_for_en              (I_hc_for_en             ),
.I_pla_int_mask           (I_pla_int_mask          ),
.I_pla_int_clr            (I_pla_int_clr           ),
.O_pla_rmu_int            (O_pla_rmu_int           ),
.O_pla_int_event          (O_pla_int_event         ),
.O_pla_int_n              (O_pla_int_n             ),
.O_pla0_rmu_rate          (O_pla0_rmu_rate         ),
.O_pla1_rmu_rate          (O_pla1_rmu_rate         ),
.O_pla2_rmu_rate          (O_pla2_rmu_rate         ),
.O_pla0_cu_rate_chg_cnt   (O_pla0_cu_rate_chg_cnt  ),
.O_pla1_cu_rate_chg_cnt   (O_pla1_cu_rate_chg_cnt  ),
.O_pla2_cu_rate_chg_cnt   (O_pla2_cu_rate_chg_cnt  ),                   
                       
.O_xgmii_rxd             (S_xgmii_rxd              ),    ///过滤REQUEST报文的数据
.O_xgmii_rxc             (S_xgmii_rxc              ),    ///
                                                  
.O_pla0_air_link         (O_pla0_air_link          ),
.O_pla1_air_link         (O_pla1_air_link          ),
.O_pla2_air_link         (O_pla2_air_link          ),

.O_pla0_air_request      (O_pla0_air_request       ),
.O_pla1_air_request      (O_pla1_air_request       ),
.O_pla2_air_request      (O_pla2_air_request       ),
                                                   
.O_pla0_air_pause        (O_pla0_air_pause         ),
.O_pla1_air_pause        (O_pla1_air_pause         ),
.O_pla2_air_pause        (O_pla2_air_pause         ),
                                                   
.I_pla0_test_freq_0      (I_pla0_test_freq_0    ),                                              
.I_pla0_test_freq_1      (I_pla0_test_freq_1    ),
.I_pla0_test_freq_2      (I_pla0_test_freq_2    ),
.I_pla0_test_freq_3      (I_pla0_test_freq_3    ),
.I_pla0_test_freq_4      (I_pla0_test_freq_4    ),
.I_pla0_test_freq_5      (I_pla0_test_freq_5    ),
.I_pla0_test_freq_6      (I_pla0_test_freq_6    ),
.I_pla0_test_freq_7      (I_pla0_test_freq_7    ),
.I_pla1_test_freq_0      (I_pla1_test_freq_0    ),
.I_pla1_test_freq_1      (I_pla1_test_freq_1    ),
.I_pla1_test_freq_2      (I_pla1_test_freq_2    ),
.I_pla1_test_freq_3      (I_pla1_test_freq_3    ),
.I_pla1_test_freq_4      (I_pla1_test_freq_4    ),
.I_pla1_test_freq_5      (I_pla1_test_freq_5    ),
.I_pla1_test_freq_6      (I_pla1_test_freq_6    ),
.I_pla1_test_freq_7      (I_pla1_test_freq_7    ),
.I_pla2_test_freq_0      (I_pla2_test_freq_0    ),
.I_pla2_test_freq_1      (I_pla2_test_freq_1    ),
.I_pla2_test_freq_2      (I_pla2_test_freq_2    ),
.I_pla2_test_freq_3      (I_pla2_test_freq_3    ),
.I_pla2_test_freq_4      (I_pla2_test_freq_4    ),
.I_pla2_test_freq_5      (I_pla2_test_freq_5    ),
.I_pla2_test_freq_6      (I_pla2_test_freq_6    ),
.I_pla2_test_freq_7      (I_pla2_test_freq_7    ),
                                                                         
.O_pla00_current_acm     (O_pla00_current_acm      ),
.O_pla01_current_acm     (O_pla01_current_acm      ),
.O_pla02_current_acm     (O_pla02_current_acm      ),
.O_pla03_current_acm     (O_pla03_current_acm      ),
.O_pla04_current_acm     (O_pla04_current_acm      ),
.O_pla05_current_acm     (O_pla05_current_acm      ),
.O_pla06_current_acm     (O_pla06_current_acm      ),
.O_pla07_current_acm     (O_pla07_current_acm      ),
.O_pla10_current_acm     (O_pla10_current_acm      ),
.O_pla11_current_acm     (O_pla11_current_acm      ),
.O_pla12_current_acm     (O_pla12_current_acm      ),
.O_pla13_current_acm     (O_pla13_current_acm      ),
.O_pla14_current_acm     (O_pla14_current_acm      ),
.O_pla15_current_acm     (O_pla15_current_acm      ),
.O_pla16_current_acm     (O_pla16_current_acm      ),
.O_pla17_current_acm     (O_pla17_current_acm      ),
.O_pla20_current_acm     (O_pla20_current_acm      ),
.O_pla21_current_acm     (O_pla21_current_acm      ),
.O_pla22_current_acm     (O_pla22_current_acm      ),
.O_pla23_current_acm     (O_pla23_current_acm      ),
.O_pla24_current_acm     (O_pla24_current_acm      ),
.O_pla25_current_acm     (O_pla25_current_acm      ),
.O_pla26_current_acm     (O_pla26_current_acm      ),
.O_pla27_current_acm     (O_pla27_current_acm      ),
                                                   

.O_pla00_current_freq     (O_pla00_current_freq ),
.O_pla01_current_freq     (O_pla01_current_freq ),
.O_pla02_current_freq     (O_pla02_current_freq ),
.O_pla03_current_freq     (O_pla03_current_freq ),
.O_pla04_current_freq     (O_pla04_current_freq ),
.O_pla05_current_freq     (O_pla05_current_freq ),
.O_pla06_current_freq     (O_pla06_current_freq ),
.O_pla07_current_freq     (O_pla07_current_freq ),
.O_pla10_current_freq     (O_pla10_current_freq ),
.O_pla11_current_freq     (O_pla11_current_freq ),
.O_pla12_current_freq     (O_pla12_current_freq ),
.O_pla13_current_freq     (O_pla13_current_freq ),
.O_pla14_current_freq     (O_pla14_current_freq ),
.O_pla15_current_freq     (O_pla15_current_freq ),
.O_pla16_current_freq     (O_pla16_current_freq ),
.O_pla17_current_freq     (O_pla17_current_freq ),
.O_pla20_current_freq     (O_pla20_current_freq ),
.O_pla21_current_freq     (O_pla21_current_freq ),
.O_pla22_current_freq     (O_pla22_current_freq ),
.O_pla23_current_freq     (O_pla23_current_freq ),
.O_pla24_current_freq     (O_pla24_current_freq ),
.O_pla25_current_freq     (O_pla25_current_freq ),
.O_pla26_current_freq     (O_pla26_current_freq ),
.O_pla27_current_freq     (O_pla27_current_freq ),
                                                   
.O_pla00_rmu_rate         (O_pla00_rmu_rate     ),
.O_pla01_rmu_rate         (O_pla01_rmu_rate     ),
.O_pla02_rmu_rate         (O_pla02_rmu_rate     ),
.O_pla03_rmu_rate         (O_pla03_rmu_rate     ),
.O_pla04_rmu_rate         (O_pla04_rmu_rate     ),
.O_pla05_rmu_rate         (O_pla05_rmu_rate     ),
.O_pla06_rmu_rate         (O_pla06_rmu_rate     ),
.O_pla07_rmu_rate         (O_pla07_rmu_rate     ),
.O_pla10_rmu_rate         (O_pla10_rmu_rate     ),
.O_pla11_rmu_rate         (O_pla11_rmu_rate     ),
.O_pla12_rmu_rate         (O_pla12_rmu_rate     ),
.O_pla13_rmu_rate         (O_pla13_rmu_rate     ),
.O_pla14_rmu_rate         (O_pla14_rmu_rate     ),
.O_pla15_rmu_rate         (O_pla15_rmu_rate     ),
.O_pla16_rmu_rate         (O_pla16_rmu_rate     ),
.O_pla17_rmu_rate         (O_pla17_rmu_rate     ),
.O_pla20_rmu_rate         (O_pla20_rmu_rate     ),
.O_pla21_rmu_rate         (O_pla21_rmu_rate     ),
.O_pla22_rmu_rate         (O_pla22_rmu_rate     ),
.O_pla23_rmu_rate         (O_pla23_rmu_rate     ),
.O_pla24_rmu_rate         (O_pla24_rmu_rate     ),
.O_pla25_rmu_rate         (O_pla25_rmu_rate     ),
.O_pla26_rmu_rate         (O_pla26_rmu_rate     ),
.O_pla27_rmu_rate         (O_pla27_rmu_rate     ),
                                                   
.O_pla00_req_change_cnt  (O_pla00_req_change_cnt   ),
.O_pla01_req_change_cnt  (O_pla01_req_change_cnt   ),
.O_pla02_req_change_cnt  (O_pla02_req_change_cnt   ),
.O_pla03_req_change_cnt  (O_pla03_req_change_cnt   ),
.O_pla04_req_change_cnt  (O_pla04_req_change_cnt   ),
.O_pla05_req_change_cnt  (O_pla05_req_change_cnt   ),
.O_pla06_req_change_cnt  (O_pla06_req_change_cnt   ),
.O_pla07_req_change_cnt  (O_pla07_req_change_cnt   ),  
.O_pla10_req_change_cnt  (O_pla10_req_change_cnt   ),
.O_pla11_req_change_cnt  (O_pla11_req_change_cnt   ),
.O_pla12_req_change_cnt  (O_pla12_req_change_cnt   ),
.O_pla13_req_change_cnt  (O_pla13_req_change_cnt   ),
.O_pla14_req_change_cnt  (O_pla14_req_change_cnt   ),
.O_pla15_req_change_cnt  (O_pla15_req_change_cnt   ),
.O_pla16_req_change_cnt  (O_pla16_req_change_cnt   ),
.O_pla17_req_change_cnt  (O_pla17_req_change_cnt   ),
.O_pla20_req_change_cnt  (O_pla20_req_change_cnt   ),
.O_pla21_req_change_cnt  (O_pla21_req_change_cnt   ),
.O_pla22_req_change_cnt  (O_pla22_req_change_cnt   ),
.O_pla23_req_change_cnt  (O_pla23_req_change_cnt   ),
.O_pla24_req_change_cnt  (O_pla24_req_change_cnt   ),
.O_pla25_req_change_cnt  (O_pla25_req_change_cnt   ),
.O_pla26_req_change_cnt  (O_pla26_req_change_cnt   ),
.O_pla27_req_change_cnt  (O_pla27_req_change_cnt   )
);

pla_backward_parser_32bit U02_pla_backward_parser_32bit(
.I_pla_312m5_clk             (I_pla_312m5_clk          ),
//.I_pla_rst                   (I_pla_rst                ),
.I_pla_rst                   (S_312m5_clk_rst                ),
.I_pla0_air_mac_0            (I_pla0_air_mac_0         ),
.I_pla0_air_mac_1            (I_pla0_air_mac_1         ),
.I_pla0_air_mac_2            (I_pla0_air_mac_2         ),
.I_pla0_air_mac_3            (I_pla0_air_mac_3         ),
.I_pla0_air_mac_4            (I_pla0_air_mac_4         ),
.I_pla0_air_mac_5            (I_pla0_air_mac_5         ),
.I_pla0_air_mac_6            (I_pla0_air_mac_6         ),
.I_pla0_air_mac_7            (I_pla0_air_mac_7         ),
.I_pla1_air_mac_0            (I_pla1_air_mac_0         ),
.I_pla1_air_mac_1            (I_pla1_air_mac_1         ),
.I_pla1_air_mac_2            (I_pla1_air_mac_2         ),
.I_pla1_air_mac_3            (I_pla1_air_mac_3         ),
.I_pla1_air_mac_4            (I_pla1_air_mac_4         ),
.I_pla1_air_mac_5            (I_pla1_air_mac_5         ),
.I_pla1_air_mac_6            (I_pla1_air_mac_6         ),
.I_pla1_air_mac_7            (I_pla1_air_mac_7         ),
.I_pla2_air_mac_0            (I_pla2_air_mac_0         ),
.I_pla2_air_mac_1            (I_pla2_air_mac_1         ),
.I_pla2_air_mac_2            (I_pla2_air_mac_2         ),
.I_pla2_air_mac_3            (I_pla2_air_mac_3         ),
.I_pla2_air_mac_4            (I_pla2_air_mac_4         ),
.I_pla2_air_mac_5            (I_pla2_air_mac_5         ),
.I_pla2_air_mac_6            (I_pla2_air_mac_6         ),
.I_pla2_air_mac_7            (I_pla2_air_mac_7         ),
.I_pla0_rcu_mac              (I_pla0_rcu_mac           ),
.I_pla1_rcu_mac              (I_pla1_rcu_mac           ),
.I_pla2_rcu_mac              (I_pla2_rcu_mac           ),
.I_xgmii_rxd                 (S_xgmii_rxd              ),
.I_xgmii_rxc                 (S_xgmii_rxc              ),
.I_pla0_slice_wr_resp        (S_pla0_slice_wr_resp     ),
.I_pla1_slice_wr_resp        (S_pla1_slice_wr_resp     ),
.I_pla2_slice_wr_resp        (S_pla2_slice_wr_resp     ), 
.I_pla0_slice_num_id         (S_pla0_slice_num_id),
.I_pla1_slice_num_id         (S_pla1_slice_num_id),
.I_pla2_slice_num_id         (S_pla2_slice_num_id),
.O_xgmii_pla_num             (S_xgmii_pla_num          ),///当前报文所属组
.O_pla_slice_id              (S_pla_slice_id           ),
.O_pla_slice_payload         (S_pla_slice_payload      ),
.O_pla_slice_payload_en      (S_pla_slice_payload_en   ),
.O_pla0_slice_check_ok       (S_pla0_slice_check_ok    ),///pulse
.O_pla1_slice_check_ok       (S_pla1_slice_check_ok    ),///pulse
.O_pla2_slice_check_ok       (S_pla2_slice_check_ok    ),///pulse
.O_pla0_slice_id_new         (S_pla0_slice_id_new      ),
.O_pla0_slice_id_new_valid   (S_pla0_slice_id_new_valid),
.O_pla1_slice_id_new         (S_pla1_slice_id_new      ),
.O_pla1_slice_id_new_valid   (S_pla1_slice_id_new_valid),
.O_pla2_slice_id_new         (S_pla2_slice_id_new      ),
.O_pla2_slice_id_new_valid   (S_pla2_slice_id_new_valid),
.O_pla0_slice_id_max         (S_pla0_slice_id_max      ),
.O_pla0_slice_id_min         (S_pla0_slice_id_min      ),
.O_pla1_slice_id_max         (S_pla1_slice_id_max      ),
.O_pla1_slice_id_min         (S_pla1_slice_id_min      ),
.O_pla2_slice_id_max         (S_pla2_slice_id_max      ),
.O_pla2_slice_id_min         (S_pla2_slice_id_min      ),
.I_pla_slice_window          (I_pla_slice_window       ),

.I_cnt_clear				 (I_cnt_clear[0]			),
.O_pla_slice_mac_err_cnt	 (O_pla_slice_mac_err_cnt	),
.O_pla_slice_len_err_cnt	 (O_pla_slice_len_err_cnt	),
.O_pla0_slice_id_random_order	(O_pla0_slice_id_random_order	),
.O_pla1_slice_id_random_order	(O_pla1_slice_id_random_order	),
.O_pla2_slice_id_random_order	(O_pla2_slice_id_random_order	),
.O_pla0_slice_id_bottom_err_cnt	(O_pla0_slice_id_bottom_err_cnt	),
.O_pla1_slice_id_bottom_err_cnt	(O_pla1_slice_id_bottom_err_cnt	),
.O_pla2_slice_id_bottom_err_cnt	(O_pla2_slice_id_bottom_err_cnt	),
.I_pla0_air_link             (O_pla0_air_link         ),
.I_pla1_air_link             (O_pla1_air_link         ),
.I_pla2_air_link             (O_pla2_air_link         )
);

pla_backward_slice_cycle_ddr U03_pla_backward_slice_cycle_ddr(
///for ddr simu test start
.O_ddr_rdy                    (O_ddr_rdy              ),
.O_ddr1_rdy                   (O_ddr1_rdy             ),
.O_312m5_clk_rst			  (S_312m5_clk_rst			),
///========================================================
.I_pla_312m5_clk              (I_pla_312m5_clk        ),
.I_pla_ddr_rst                (I_pla_ddr_rst          ),
//.I_pla_rst                    (I_pla_rst||(!O_ddr_rdy)),
.I_pla_slice_id               (S_pla_slice_id         ),
.I_pla_slice_payload          (S_pla_slice_payload    ),
.I_pla_slice_payload_en       (S_pla_slice_payload_en ),
.I_xgmii_pla_num              (S_xgmii_pla_num        ),
.I_pla0_slice_check_ok        (S_pla0_slice_check_ok  ),///pulse
.I_pla0_slice_rd_req          (S_pla0_slice_rd_req    ),
.I_pla0_slice_rd_id           (S_pla0_slice_rd_id     ),
.I_pla0_slice_data_rd         (S_pla0_slice_data_rd   ),
.I_pla1_slice_check_ok        (S_pla1_slice_check_ok  ),
.I_pla1_slice_rd_req          (S_pla1_slice_rd_req    ),
.I_pla1_slice_rd_id           (S_pla1_slice_rd_id     ),
.I_pla1_slice_data_rd         (S_pla1_slice_data_rd   ),
.I_pla2_slice_check_ok        (S_pla2_slice_check_ok  ),
.I_pla2_slice_rd_req          (S_pla2_slice_rd_req    ),
.I_pla2_slice_rd_id           (S_pla2_slice_rd_id     ),
.I_pla2_slice_data_rd         (S_pla2_slice_data_rd   ),
.I_cnt_clear                  (I_cnt_clear[0]		  ),
.I_slice_rd_en_valid_cnt_fix  (I_slice_rd_en_valid_cnt_fix	), 

.O_pla0_slice_wr_resp         (S_pla0_slice_wr_resp  ),  
.O_pla0_slice_num_id          (S_pla0_slice_num_id   ),
.O_pla1_slice_num_id          (S_pla1_slice_num_id   ),
.O_pla2_slice_num_id          (S_pla2_slice_num_id   ),
.O_pla0_slice_rd_resp         (S_pla0_slice_rd_resp  ),
.O_pla0_slice_rdata           (S_pla0_slice_rdata    ), 
.O_pla1_slice_wr_resp         (S_pla1_slice_wr_resp  ),
.O_pla1_slice_rd_resp         (S_pla1_slice_rd_resp  ),
.O_pla1_slice_rdata           (S_pla1_slice_rdata    ),
.O_pla2_slice_wr_resp         (S_pla2_slice_wr_resp  ),
.O_pla2_slice_rd_resp         (S_pla2_slice_rd_resp  ),
.O_pla2_slice_rdata           (S_pla2_slice_rdata    ),
///ddr monitor     
.O_pla0_slice_ok_cnt          (O_pla0_slice_ok_cnt   ),
.O_pla0_slice_wr_cnt          (O_pla0_slice_wr_cnt   ),
.O_pla0_slice_rd_cnt          (O_pla0_slice_rd_cnt   ),
.O_pla0_slice_crc_err_cnt	  (O_pla0_slice_crc_err_cnt	), 
.O_pla1_slice_ok_cnt          (O_pla1_slice_ok_cnt   ),
.O_pla1_slice_wr_cnt          (O_pla1_slice_wr_cnt   ),
.O_pla1_slice_rd_cnt          (O_pla1_slice_rd_cnt   ),
.O_pla1_slice_crc_err_cnt	  (O_pla1_slice_crc_err_cnt	), 
.O_pla2_slice_ok_cnt          (O_pla2_slice_ok_cnt   ),
.O_pla2_slice_wr_cnt          (O_pla2_slice_wr_cnt   ),
.O_pla2_slice_rd_cnt          (O_pla2_slice_rd_cnt   ),
.O_pla2_slice_crc_err_cnt	  (O_pla2_slice_crc_err_cnt	), 
.O_ddr3a_app_wdf_rdy_low_cnt_max	(O_ddr3a_app_wdf_rdy_low_cnt_max),	
.O_ddr3a_wr_app_rdy_low_cnt_max		(O_ddr3a_wr_app_rdy_low_cnt_max	),	
.O_ddr3a_rd_app_rdy_low_cnt_max		(O_ddr3a_rd_app_rdy_low_cnt_max	),	
.O_ddr3a_app_write_err_cnt			(O_ddr3a_app_write_err_cnt		),	
.O_ddr3a_buf_full_cnt				(O_ddr3a_buf_full_cnt			),	

.O_ddr3b_app_wdf_rdy_low_cnt_max	(O_ddr3b_app_wdf_rdy_low_cnt_max),	
.O_ddr3b_wr_app_rdy_low_cnt_max		(O_ddr3b_wr_app_rdy_low_cnt_max	),	
.O_ddr3b_rd_app_rdy_low_cnt_max		(O_ddr3b_rd_app_rdy_low_cnt_max	),	
.O_ddr3b_app_write_err_cnt			(O_ddr3b_app_write_err_cnt		),	
.O_ddr3b_buf_full_cnt				(O_ddr3b_buf_full_cnt			),	
/*
.O_ddr0_55D5_cnt              (O_ddr0_reflow_55D5_cnt[31:0] ),
.O_ddr0_lose_cnt              (O_ddr0_reflow_lose_cnt[31:0] ),
.O_ddr0_lose_reg              (O_ddr0_reflow_lose_reg[1:0]  ), 
*/

///ddr outer sig
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
                              
.O_c0_app_rdy                 (O_c0_app_rdy  ),   ///===
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
.tg_compare_error             ( )

);


pla_backward_reflow_32bit U04_pla_backward_reflow_32bit(
.I_pla_312m5_clk             (I_pla_312m5_clk            ),
//.I_pla_rst                   (I_pla_rst                  ),
.I_pla_rst                   (S_312m5_clk_rst			 ),
.I_cnt_clear                 (I_cnt_clear[1:0]           ),
.I_pla_slice_id_depth_set    (),                         
.I_pla_slice_id_new          (S_pla0_slice_id_new        ),
.I_pla_slice_id_new_valid    (S_pla0_slice_id_new_valid  ),
.I_pla_slice_id_max          (S_pla0_slice_id_max        ),
.I_pla_slice_id_min          (S_pla0_slice_id_min        ),
.I_pla_slice_rd_resp         (S_pla0_slice_rd_resp       ),
.I_pla_slice_rdata           (S_pla0_slice_rdata         ),
.I_pla_reflow_fifo_rd        (S_pla0_reflow_fifo_rd      ),
.O_pla_slice_rd_req          (S_pla0_slice_rd_req        ),
.O_pla_slice_rd_id           (S_pla0_slice_rd_id         ),
.O_pla_slice_data_rd         (S_pla0_slice_data_rd       ),
.O_pla_reflow_fifo_rdata     (S_pla0_reflow_fifo_rdata   ),
.O_pla_reflow_fifo_empty     (S_pla0_reflow_fifo_empty   ),
.O_pla_reflow_rderr_cnt      (O_pla0_reflow_rderr_cnt    ),
.O_pla_reflow_id_wl          (O_pla0_reflow_id_wl        ),
.O_reflow_55D5_cnt           (O_ddr0_reflow_55D5_cnt[15:0]), 
.O_reflow_lose_cnt           (O_ddr0_reflow_lose_cnt[15:0]), 
.O_reflow_lose_reg           (O_ddr0_reflow_lose_reg[0]    ), 
.O_pla_slice_id_depth_alful  (O_pla_slice_id_depth_alful[0])
);

pla_backward_reflow_32bit U05_pla_backward_reflow_32bit(
.I_pla_312m5_clk             (I_pla_312m5_clk            ),
//.I_pla_rst                   (I_pla_rst                  ),
.I_pla_rst                   (S_312m5_clk_rst			),
.I_cnt_clear                 (I_cnt_clear[1:0]           ),
.I_pla_slice_id_depth_set    (),                         
.I_pla_slice_id_new          (S_pla1_slice_id_new        ),
.I_pla_slice_id_new_valid    (S_pla1_slice_id_new_valid  ),
.I_pla_slice_id_max          (S_pla1_slice_id_max        ),
.I_pla_slice_id_min          (S_pla1_slice_id_min        ),
.I_pla_slice_rd_resp         (S_pla1_slice_rd_resp       ),
.I_pla_slice_rdata           (S_pla1_slice_rdata         ),
.I_pla_reflow_fifo_rd        (S_pla1_reflow_fifo_rd      ),
.O_pla_slice_rd_req          (S_pla1_slice_rd_req        ),
.O_pla_slice_rd_id           (S_pla1_slice_rd_id         ),
.O_pla_slice_data_rd         (S_pla1_slice_data_rd       ),
.O_pla_reflow_fifo_rdata     (S_pla1_reflow_fifo_rdata   ),
.O_pla_reflow_fifo_empty     (S_pla1_reflow_fifo_empty   ),
.O_pla_reflow_rderr_cnt      (O_pla1_reflow_rderr_cnt    ),
.O_pla_reflow_id_wl          (O_pla1_reflow_id_wl        ),
.O_reflow_55D5_cnt           (O_ddr0_reflow_55D5_cnt[31:16]), 
.O_reflow_lose_cnt           (O_ddr0_reflow_lose_cnt[31:16]), 
.O_reflow_lose_reg           (O_ddr0_reflow_lose_reg[1]    ), 
.O_pla_slice_id_depth_alful  (O_pla_slice_id_depth_alful[1])
);

pla_backward_reflow_32bit U06_pla_backward_reflow_32bit(
.I_pla_312m5_clk             (I_pla_312m5_clk            ),
//.I_pla_rst                   (I_pla_rst                  ),
.I_pla_rst                   (S_312m5_clk_rst			),
.I_cnt_clear                 (I_cnt_clear[1:0]           ),
.I_pla_slice_id_depth_set    (),                         
.I_pla_slice_id_new          (S_pla2_slice_id_new        ),
.I_pla_slice_id_new_valid    (S_pla2_slice_id_new_valid  ),
.I_pla_slice_id_max          (S_pla2_slice_id_max        ),
.I_pla_slice_id_min          (S_pla2_slice_id_min        ),
.I_pla_slice_rd_resp         (S_pla2_slice_rd_resp       ),
.I_pla_slice_rdata           (S_pla2_slice_rdata         ),
.I_pla_reflow_fifo_rd        (S_pla2_reflow_fifo_rd      ),
.O_pla_slice_rd_req          (S_pla2_slice_rd_req        ),
.O_pla_slice_rd_id           (S_pla2_slice_rd_id         ),
.O_pla_slice_data_rd         (S_pla2_slice_data_rd       ),
.O_pla_reflow_fifo_rdata     (S_pla2_reflow_fifo_rdata   ),
.O_pla_reflow_fifo_empty     (S_pla2_reflow_fifo_empty   ),
.O_pla_reflow_rderr_cnt      (O_pla2_reflow_rderr_cnt    ),
.O_pla_reflow_id_wl          (O_pla2_reflow_id_wl        ),
.O_reflow_55D5_cnt			 (O_ddr0_reflow_55D5_cnt[47:32]), 
.O_reflow_lose_cnt           (O_ddr0_reflow_lose_cnt[47:32]), 
.O_reflow_lose_reg           (O_ddr0_reflow_lose_reg[2]    ), 
.O_pla_slice_id_depth_alful  (O_pla_slice_id_depth_alful[2])
);


pla_backward_reframer_32bit U07_pla_backward_reframer_32bit(
.I_pla_312m5_clk             (I_pla_312m5_clk            ),
//.I_pla_rst                   (I_pla_rst                  ),
.I_pla_rst                   (S_312m5_clk_rst			),
.I_cnt_clear                 (I_cnt_clear[0]             ),
.I_pla0_reflow_fifo_rdata    (S_pla0_reflow_fifo_rdata   ),
.I_pla0_reflow_fifo_empty    (S_pla0_reflow_fifo_empty   ),
.I_pla1_reflow_fifo_rdata    (S_pla1_reflow_fifo_rdata   ),
.I_pla1_reflow_fifo_empty    (S_pla1_reflow_fifo_empty   ),
.I_pla2_reflow_fifo_rdata    (S_pla2_reflow_fifo_rdata   ),
.I_pla2_reflow_fifo_empty    (S_pla2_reflow_fifo_empty   ),
.I_pla_feedback_rd_pla0      (I_pla_feedback_rd_pla0     ),
.I_pla_feedback_rd_pla1      (I_pla_feedback_rd_pla1     ),
.I_pla_feedback_rd_pla2      (I_pla_feedback_rd_pla2     ),
.I_pause_from_back_hc        (I_pause_from_back_hc       ),
.I_pause_en                  (I_pause_en                 ),
                  
.O_pla0_reflow_fifo_rd       (S_pla0_reflow_fifo_rd      ),
.O_pla1_reflow_fifo_rd       (S_pla1_reflow_fifo_rd      ),
.O_pla2_reflow_fifo_rd       (S_pla2_reflow_fifo_rd      ),
.O_pla_xgmii_rxd             (O_pla_xgmii_rxd            ),
.O_pla_xgmii_rxc             (O_pla_xgmii_rxc            ),
.O_pla_xgmii_pla_num         (O_pla_xgmii_pla_num        ),
.O_pla_xgmii_err             (O_pla_xgmii_err            ),
.O_reframe_crcok_cnt         (O_pla_slice_crc_ok_cnt     ),
.O_reframe_crcerr_cnt        (O_pla_slice_crc_err_cnt    ),
.O_all_err_cnt               (O_all_err_cnt              ),
.O_fifo_full0_cnt            (O_fifo_full0_cnt           ),
.O_ram_full0_cnt             (O_ram_full0_cnt            ),
.O_length_err0_cnt           (O_length_err0_cnt          ),
.O_drop_flag_cnt             (O_drop_flag_cnt            ),
.O_feedback_cnt              (O_feedback_cnt             ),
.O_reframe_state_change_cnt  (O_reframe_state_change_cnt ), 
.O_slice_cnt                 (O_slice_cnt                ),                          
.O_feedback_fifo_rdata_pla0  (O_feedback_fifo_rdata_pla0 ),
.O_feedback_fifo_count_pla0  (O_feedback_fifo_count_pla0 ),
.O_feedback_fifo_full_pla0   (O_feedback_fifo_full_pla0  ),
.O_feedback_fifo_empty_pla0  (O_feedback_fifo_empty_pla0 ),
.O_pla_slice_fifo_empty_pla0 (O_pla_slice_fifo_empty_pla0),
.O_feedback_fifo_rdata_pla1  (O_feedback_fifo_rdata_pla1 ),   
.O_feedback_fifo_count_pla1  (O_feedback_fifo_count_pla1 ),
.O_feedback_fifo_full_pla1   (O_feedback_fifo_full_pla1  ),
.O_feedback_fifo_empty_pla1  (O_feedback_fifo_empty_pla1 ),
.O_pla_slice_fifo_empty_pla1 (O_pla_slice_fifo_empty_pla1),                         
.O_feedback_fifo_rdata_pla2  (O_feedback_fifo_rdata_pla2 ),
.O_feedback_fifo_count_pla2  (O_feedback_fifo_count_pla2 ),
.O_feedback_fifo_full_pla2   (O_feedback_fifo_full_pla2  ),
.O_feedback_fifo_empty_pla2  (O_feedback_fifo_empty_pla2 ),
.O_pla_slice_fifo_empty_pla2 (O_pla_slice_fifo_empty_pla2),
.O_reframe_pla0_55d5_cnt     (O_reframe_pla0_55d5_cnt    ),
.O_pla0_reframe_fifo_wr_cnt  (O_pla0_reframe_fifo_wr_cnt ),
.O_pla_rst_cnt               (O_pla_rst_cnt              ),

.O_frame_dpram_usedw_back_pla0( O_frame_dpram_usedw_back_pla0),
.O_frame_dpram_usedw_back_pla1( O_frame_dpram_usedw_back_pla1),
.O_frame_dpram_usedw_back_pla2( O_frame_dpram_usedw_back_pla2),
.O_err_tme_cnt                ( O_err_tme_cnt                ),
.O_small_inter_cnt            ( O_small_inter_cnt            ),
.O_crc_wrong                  ( O_crc_wrong                  )
);

/////test module crc_check
crc_no_comp_compare backpla_input_crc_check (
 .I_global_rst    	     (I_pla_rst           ),  
 .I_312m_clk	           (I_pla_312m5_clk     ),
 .I_xgmii_data           (S_xgmii_rxd         ),   
 .I_xgmii_txc            (S_xgmii_rxc         ),
 .O_crc_err              (S_crc_wrong_input   ),
 .O_crc_compare_signal   (), 
 .O_crc_ok               (S_crc_ok_input      )     

);

crc_no_comp_compare backpla_output_crc_check (
 .I_global_rst    	     (I_pla_rst            ),  
 .I_312m_clk	           (I_pla_312m5_clk      ),
 .I_xgmii_data           (O_pla_xgmii_rxd      ),   
 .I_xgmii_txc            (O_pla_xgmii_rxc      ),
 .O_crc_err              (S_crc_wrong_output   ),
 .O_crc_compare_signal   (),
 .O_crc_ok               (S_crc_ok_output      )     

);


xgmii_frame_cnt input_crc_ok_cnt(
.I_312m_clk    (I_pla_312m5_clk         ),
.I_frame_en    (S_crc_ok_input          ),
.I_cnt_clear   (I_cnt_clear[0]          ),
.O_cnt_result  (O_input_crcok_cnt       )
);


xgmii_frame_cnt input_crc_err_cnt(
.I_312m_clk    (I_pla_312m5_clk         ),
.I_frame_en    (S_crc_wrong_input       ),
.I_cnt_clear   (I_cnt_clear[0]          ),
.O_cnt_result  (O_input_crcerr_cnt      )
);                                      
                                        
xgmii_frame_cnt output_crc_ok_cnt(
     
.I_312m_clk    (I_pla_312m5_clk         ),
.I_frame_en    (S_crc_ok_output         ),
.I_cnt_clear   (I_cnt_clear[0]          ),
.O_cnt_result  (O_output_crcok_cnt      )
);                                      
                                        
xgmii_frame_cnt output_crc_err_cnt(
    
.I_312m_clk    (I_pla_312m5_clk         ),
.I_frame_en    (S_crc_wrong_output      ),
.I_cnt_clear   (I_cnt_clear[0]          ),
.O_cnt_result  (O_output_crcerr_cnt     )
);



endmodule
