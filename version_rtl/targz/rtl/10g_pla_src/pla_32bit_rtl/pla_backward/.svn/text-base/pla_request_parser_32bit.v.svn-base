//FILE_HEADER-----------------------------------------------------------------
//ZTE  Copyright (C)
//ZTE Company Confidential
//----------------------------------------------------------------------------
//Project Name :  
//FILE NAME    : pla_request_parser_32bit.v
//AUTHOR       : 
//Department   : 
//Email        : 
//----------------------------------------------------------------------------
//Module Hiberarchy :    
//x pla_request_parser_32bit--|--  U01_pla_request_gen
//x                           |--  U02_pla_request_rate_calc
//----------------------------------------------------------------------------
//Relaese History :
//----------------------------------------------------------------------------
//Version         Date           Author        Description
// 1.1          nov-10-2011      Li Shuai      pla_schedule
// 1.2
//----------------------------------------------------------------------------
//Main Function:
//----------------------------------------------------------------------------
//REUSE ISSUES: xxxxxxxx
//END_HEADER------------------------------------------------------------------


`timescale 1ns/100ps

module pla_request_parser_32bit(
input             I_pla_312m5_clk          ,
input             I_pla_rst                ,
input             I_cnt_clear              ,
input     [23:0]  I_pla_air_link_change_mask,
output    [23:0]  O_pla_air_link_change_flg ,


input     [47:0]  I_pla0_air_mac_0         ,
input     [47:0]  I_pla0_air_mac_1         ,
input     [47:0]  I_pla0_air_mac_2         ,
input     [47:0]  I_pla0_air_mac_3         ,
input     [47:0]  I_pla0_air_mac_4         ,
input     [47:0]  I_pla0_air_mac_5         ,
input     [47:0]  I_pla0_air_mac_6         ,
input     [47:0]  I_pla0_air_mac_7         ,
input     [47:0]  I_pla1_air_mac_0         ,
input     [47:0]  I_pla1_air_mac_1         ,
input     [47:0]  I_pla1_air_mac_2         ,
input     [47:0]  I_pla1_air_mac_3         ,
input     [47:0]  I_pla1_air_mac_4         ,
input     [47:0]  I_pla1_air_mac_5         ,
input     [47:0]  I_pla1_air_mac_6         ,
input     [47:0]  I_pla1_air_mac_7         ,
input     [47:0]  I_pla2_air_mac_0         ,
input     [47:0]  I_pla2_air_mac_1         ,
input     [47:0]  I_pla2_air_mac_2         ,
input     [47:0]  I_pla2_air_mac_3         ,
input     [47:0]  I_pla2_air_mac_4         ,
input     [47:0]  I_pla2_air_mac_5         ,
input     [47:0]  I_pla2_air_mac_6         ,
input     [47:0]  I_pla2_air_mac_7         ,

input     [47:0]  I_pla0_rcu_mac           ,
input     [47:0]  I_pla1_rcu_mac           ,
input     [47:0]  I_pla2_rcu_mac           ,

input     [31:0]  I_xgmii_rxd              ,
input     [3:0]   I_xgmii_rxc              ,

input      [15:0] I_request_wait_time      ,
input             I_request_wait_en        ,

output reg [31:0] O_xgmii_rxd              ,    ///过滤REQUEST报文的数据.或slice id异常报文
output reg [3:0]  O_xgmii_rxc              ,    ///

output     [7:0]  O_pla0_air_link          ,
output     [7:0]  O_pla1_air_link          ,
output     [7:0]  O_pla2_air_link          ,

output     [7:0]  O_pla0_air_request       ,
output     [7:0]  O_pla1_air_request       ,
output     [7:0]  O_pla2_air_request       ,

output     [7:0]  O_pla0_air_pause       , 
output     [7:0]  O_pla1_air_pause       ,
output     [7:0]  O_pla2_air_pause       ,
                               
input     [31:0]  I_pla0_test_freq_0   ,
input     [31:0]  I_pla0_test_freq_1   ,
input     [31:0]  I_pla0_test_freq_2   ,
input     [31:0]  I_pla0_test_freq_3   ,
input     [31:0]  I_pla0_test_freq_4   ,
input     [31:0]  I_pla0_test_freq_5   ,
input     [31:0]  I_pla0_test_freq_6   ,
input     [31:0]  I_pla0_test_freq_7   ,
input     [31:0]  I_pla1_test_freq_0   ,
input     [31:0]  I_pla1_test_freq_1   ,
input     [31:0]  I_pla1_test_freq_2   ,
input     [31:0]  I_pla1_test_freq_3   ,
input     [31:0]  I_pla1_test_freq_4   ,
input     [31:0]  I_pla1_test_freq_5   ,
input     [31:0]  I_pla1_test_freq_6   ,
input     [31:0]  I_pla1_test_freq_7   ,
input     [31:0]  I_pla2_test_freq_0   ,
input     [31:0]  I_pla2_test_freq_1   ,
input     [31:0]  I_pla2_test_freq_2   ,
input     [31:0]  I_pla2_test_freq_3   ,
input     [31:0]  I_pla2_test_freq_4   ,
input     [31:0]  I_pla2_test_freq_5   ,
input     [31:0]  I_pla2_test_freq_6   ,
input     [31:0]  I_pla2_test_freq_7   ,
                                       
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

output    [47:0]  O_pla00_req_change_cnt  ,
output    [47:0]  O_pla01_req_change_cnt  ,
output    [47:0]  O_pla02_req_change_cnt  ,
output    [47:0]  O_pla03_req_change_cnt  ,
output    [47:0]  O_pla04_req_change_cnt  ,
output    [47:0]  O_pla05_req_change_cnt  ,
output    [47:0]  O_pla06_req_change_cnt  ,
output    [47:0]  O_pla07_req_change_cnt  , 
output    [47:0]  O_pla10_req_change_cnt  ,
output    [47:0]  O_pla11_req_change_cnt  ,
output    [47:0]  O_pla12_req_change_cnt  ,
output    [47:0]  O_pla13_req_change_cnt  ,
output    [47:0]  O_pla14_req_change_cnt  ,
output    [47:0]  O_pla15_req_change_cnt  ,
output    [47:0]  O_pla16_req_change_cnt  ,
output    [47:0]  O_pla17_req_change_cnt  ,
output    [47:0]  O_pla20_req_change_cnt  ,
output    [47:0]  O_pla21_req_change_cnt  ,
output    [47:0]  O_pla22_req_change_cnt  ,
output    [47:0]  O_pla23_req_change_cnt  ,
output    [47:0]  O_pla24_req_change_cnt  ,
output    [47:0]  O_pla25_req_change_cnt  ,
output    [47:0]  O_pla26_req_change_cnt  ,
output    [47:0]  O_pla27_req_change_cnt  ,
    
input    [2:0]    I_hc_for_en            ,
input    [15:0]   I_pla_int_mask         ,  
input    [15:0]   I_pla_int_clr          ,  
output   [15:0]   O_pla_rmu_int          ,       
output   [15:0]   O_pla_int_event        ,
output            O_pla_int_n            , 
output   [19:0]   O_pla0_rmu_rate        ,
output   [19:0]   O_pla1_rmu_rate        ,
output   [19:0]   O_pla2_rmu_rate        ,
output   [15:0]   O_pla0_cu_rate_chg_cnt ,
output   [15:0]   O_pla1_cu_rate_chg_cnt ,
output   [15:0]   O_pla2_cu_rate_chg_cnt 
);

                                               
reg  [31:0]   S_xgmii_rxd                      ; ///XGMII发送数据延迟1拍信号
reg  [3:0]    S_xgmii_rxc                      ; ///XGMII发送使能延迟1拍信号
reg  [31:0]   S1_xgmii_rxd                     ; ///XGMII发送数据延迟2拍信号
reg  [3:0]    S1_xgmii_rxc                     ; ///XGMII发送使能延迟2拍信号
reg  [31:0]   S2_xgmii_rxd                     ; ///XGMII发送数据延迟3拍信号
reg  [3:0]    S2_xgmii_rxc                     ; ///XGMII发送使能延迟3拍信号
reg  [31:0]   S3_xgmii_rxd                     ; ///XGMII发送数据延迟4拍信号
reg  [3:0]    S3_xgmii_rxc                     ; ///XGMII发送使能延迟4拍信号
reg  [31:0]   S4_xgmii_rxd                     ; ///XGMII发送数据延迟5拍信号
reg  [3:0]    S4_xgmii_rxc                     ; ///XGMII发送使能延迟5拍信号
(* max_fanout = 15 *)reg  [31:0]   S5_xgmii_rxd                     ; ///XGMII发送数据延迟6拍信号
reg  [3:0]    S5_xgmii_rxc                     ; ///XGMII发送使能延迟6拍信号
reg           S_preamble_flag                  ;///
reg  [3:0]    S_cnt                            ;///    
reg           S_xgmii_data_valid               ;///
                                               
reg           S_pla_flow_flag                  ;///
                              
wire [47:0]   S_pla_air_mac        [23:0]      ;
wire [47:0]   S_pla_rcu_mac        [23:0]      ;
wire [31:0]   S_pla_test_freq       [23:0]      ;



reg  [10:0]   S_pla_312m5_4us_clk_cnt = 11'd0  ;
reg           S_pla_4us_clk           = 1'b0   ;

reg  [23:0]   S_pla_req_check_ok       = 24'b0 ;
reg  [23:0]   S_pla_link_state                 ;
     
reg  [15:0]   S_pla_req_wait_cnt   [23:0]      ;
reg  [23:0]   S_pla_req_wait_timeout   = 24'd0 ;
reg  [23:0]   S_pla_rmu_request                ;
reg  [23:0]   S_pla_rmu_pause                  ;
reg  [3:0 ]   S_pla_rmu_acm       [23:0]      ;
reg  [31:0]   S_pla_rmu_freq      [23:0]      ;
reg  [15:0]   S_pla_rmu_rate      [23:0]      ;

wire [31:0]   S_pla_current_freq   [23:0]      ;
wire [15:0]   S_pla_req_change_cnt [23:0]      ;    
wire [23:0]   S_pla_air_request                ;

reg [7:0]   S_pla_req_cnt            [23:0]      ;      
reg [7:0]   S_pla_timeout_cnt        [23:0]      ;     
 
///数据打拍
always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
    begin
        S_xgmii_rxc  <= 4'hf;
        S1_xgmii_rxc <= 4'hf; 
        S2_xgmii_rxc <= 4'hf; 
        S3_xgmii_rxc <= 4'hf;   
        S4_xgmii_rxc <= 4'hf; 
        S5_xgmii_rxc <= 4'hf; 
        
        S_xgmii_rxd  <= 32'h0;
        S1_xgmii_rxd <= 32'h0;         
        S2_xgmii_rxd <= 32'h0;         
        S3_xgmii_rxd <= 32'h0; 
        S4_xgmii_rxd <= 32'h0;  
        S5_xgmii_rxd <= 32'h0;  
        
    end     
    else
    begin
        S_xgmii_rxd    <= I_xgmii_rxd  ;
        S1_xgmii_rxd   <= S_xgmii_rxd  ;
        S2_xgmii_rxd   <= S1_xgmii_rxd ;
        S3_xgmii_rxd   <= S2_xgmii_rxd ;
        S4_xgmii_rxd   <= S3_xgmii_rxd ;
        S5_xgmii_rxd   <= S4_xgmii_rxd ;
        
        S_xgmii_rxc    <= I_xgmii_rxc  ;
        S1_xgmii_rxc   <= S_xgmii_rxc  ;
        S2_xgmii_rxc   <= S1_xgmii_rxc ;
        S3_xgmii_rxc   <= S2_xgmii_rxc ;
        S4_xgmii_rxc   <= S3_xgmii_rxc ;
        S5_xgmii_rxc   <= S4_xgmii_rxc ;
    end    
end

///连续收到Preamble的0x5555标志产生
always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
        S_preamble_flag <= 1'b0;  
    else if((S_xgmii_rxc == 4'h8)&&(S_xgmii_rxd == 32'hfb555555)&&(I_xgmii_rxc == 4'h0)&&(I_xgmii_rxd == 32'h555555d5))  ///非压缩报文 
        S_preamble_flag <= 1'b1;        
    else
        S_preamble_flag <= 1'b0;
end

always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
        S_xgmii_data_valid <= 1'b0;  
    else if(S_preamble_flag)  ///非压缩报文 
        S_xgmii_data_valid <= 1'b1;        
    else if(I_xgmii_rxc == 4'hf)
        S_xgmii_data_valid <= 1'b0;
end

///连续收到Preamble的0x5555标志产生
always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
        S_cnt <= 4'hf;  
    else if(S_preamble_flag)  ///非压缩报文
        S_cnt <= 4'd0; 
    else     
    begin
        if (S_cnt == 4'hf)
            S_cnt <= S_cnt;
        else
            S_cnt <= S_cnt + 4'b1;
    end    
end


///数据有效部分指示
always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst) 
    begin
        S_pla_flow_flag <= 1'b0;
    end    
    else if (S_xgmii_data_valid && (S_cnt == 4'd2)) 
    begin
        if (S2_xgmii_rxd == I_pla0_rcu_mac[47:16] && S1_xgmii_rxd[31:16] == I_pla0_rcu_mac[15:0] && I_xgmii_rxd[31] == 1'b0)
            S_pla_flow_flag  <= 1'b1;  
        else if (S2_xgmii_rxd == I_pla1_rcu_mac[47:16] && S1_xgmii_rxd[31:16] == I_pla1_rcu_mac[15:0] && I_xgmii_rxd[31] == 1'b0)
            S_pla_flow_flag  <= 1'b1;  
        else if (S2_xgmii_rxd == I_pla2_rcu_mac[47:16] && S1_xgmii_rxd[31:16] == I_pla2_rcu_mac[15:0] && I_xgmii_rxd[31] == 1'b0)
            S_pla_flow_flag  <= 1'b1;          
        else 
            S_pla_flow_flag  <= 1'b0;       
    end    
end


///无效的切片滤除
always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
    begin
        O_xgmii_rxd     <= 32'h07070707; 
        O_xgmii_rxc     <= 4'hf;
    end
    else if(S_pla_flow_flag == 1'b0)
    begin
        O_xgmii_rxd     <= O_xgmii_rxd; 
        O_xgmii_rxc     <= 4'hf;    
    end    
    else 
    begin
        O_xgmii_rxd     <= S5_xgmii_rxd;   
        O_xgmii_rxc     <= S5_xgmii_rxc;   
    end
end


///-------------------------------------------------------------
///输出request指示,
///-------------------------------------------------------------
assign   S_pla_air_mac[0 ] = I_pla0_air_mac_0  ;
assign   S_pla_air_mac[1 ] = I_pla0_air_mac_1  ;
assign   S_pla_air_mac[2 ] = I_pla0_air_mac_2  ;
assign   S_pla_air_mac[3 ] = I_pla0_air_mac_3  ;
assign   S_pla_air_mac[4 ] = I_pla0_air_mac_4  ;
assign   S_pla_air_mac[5 ] = I_pla0_air_mac_5  ;
assign   S_pla_air_mac[6 ] = I_pla0_air_mac_6  ;
assign   S_pla_air_mac[7 ] = I_pla0_air_mac_7  ;
assign   S_pla_air_mac[8 ] = I_pla1_air_mac_0  ;
assign   S_pla_air_mac[9 ] = I_pla1_air_mac_1  ;
assign   S_pla_air_mac[10] = I_pla1_air_mac_2  ;
assign   S_pla_air_mac[11] = I_pla1_air_mac_3  ;
assign   S_pla_air_mac[12] = I_pla1_air_mac_4  ;
assign   S_pla_air_mac[13] = I_pla1_air_mac_5  ;
assign   S_pla_air_mac[14] = I_pla1_air_mac_6  ;
assign   S_pla_air_mac[15] = I_pla1_air_mac_7  ;
assign   S_pla_air_mac[16] = I_pla2_air_mac_0  ;
assign   S_pla_air_mac[17] = I_pla2_air_mac_1  ;
assign   S_pla_air_mac[18] = I_pla2_air_mac_2  ;
assign   S_pla_air_mac[19] = I_pla2_air_mac_3  ;
assign   S_pla_air_mac[20] = I_pla2_air_mac_4  ;
assign   S_pla_air_mac[21] = I_pla2_air_mac_5  ;
assign   S_pla_air_mac[22] = I_pla2_air_mac_6  ;
assign   S_pla_air_mac[23] = I_pla2_air_mac_7  ;

assign   S_pla_rcu_mac[0 ] = I_pla0_rcu_mac ;
assign   S_pla_rcu_mac[1 ] = I_pla0_rcu_mac ;
assign   S_pla_rcu_mac[2 ] = I_pla0_rcu_mac ;
assign   S_pla_rcu_mac[3 ] = I_pla0_rcu_mac ;
assign   S_pla_rcu_mac[4 ] = I_pla0_rcu_mac ;
assign   S_pla_rcu_mac[5 ] = I_pla0_rcu_mac ;
assign   S_pla_rcu_mac[6 ] = I_pla0_rcu_mac ;
assign   S_pla_rcu_mac[7 ] = I_pla0_rcu_mac ;
assign   S_pla_rcu_mac[8 ] = I_pla1_rcu_mac ;
assign   S_pla_rcu_mac[9 ] = I_pla1_rcu_mac ;
assign   S_pla_rcu_mac[10] = I_pla1_rcu_mac ;
assign   S_pla_rcu_mac[11] = I_pla1_rcu_mac ;
assign   S_pla_rcu_mac[12] = I_pla1_rcu_mac ;
assign   S_pla_rcu_mac[13] = I_pla1_rcu_mac ;
assign   S_pla_rcu_mac[14] = I_pla1_rcu_mac ;
assign   S_pla_rcu_mac[15] = I_pla1_rcu_mac ;
assign   S_pla_rcu_mac[16] = I_pla2_rcu_mac ;
assign   S_pla_rcu_mac[17] = I_pla2_rcu_mac ;
assign   S_pla_rcu_mac[18] = I_pla2_rcu_mac ;
assign   S_pla_rcu_mac[19] = I_pla2_rcu_mac ;
assign   S_pla_rcu_mac[20] = I_pla2_rcu_mac ;
assign   S_pla_rcu_mac[21] = I_pla2_rcu_mac ;
assign   S_pla_rcu_mac[22] = I_pla2_rcu_mac ;
assign   S_pla_rcu_mac[23] = I_pla2_rcu_mac ;

assign   S_pla_test_freq[0 ]  = I_pla0_test_freq_0  ;
assign   S_pla_test_freq[1 ]  = I_pla0_test_freq_1  ;
assign   S_pla_test_freq[2 ]  = I_pla0_test_freq_2  ;
assign   S_pla_test_freq[3 ]  = I_pla0_test_freq_3  ;
assign   S_pla_test_freq[4 ]  = I_pla0_test_freq_4  ;
assign   S_pla_test_freq[5 ]  = I_pla0_test_freq_5  ;
assign   S_pla_test_freq[6 ]  = I_pla0_test_freq_6  ;
assign   S_pla_test_freq[7 ]  = I_pla0_test_freq_7  ;
assign   S_pla_test_freq[8 ]  = I_pla1_test_freq_0  ;
assign   S_pla_test_freq[9 ]  = I_pla1_test_freq_1  ;
assign   S_pla_test_freq[10]  = I_pla1_test_freq_2  ;
assign   S_pla_test_freq[11]  = I_pla1_test_freq_3  ;
assign   S_pla_test_freq[12]  = I_pla1_test_freq_4  ;
assign   S_pla_test_freq[13]  = I_pla1_test_freq_5  ;
assign   S_pla_test_freq[14]  = I_pla1_test_freq_6  ;
assign   S_pla_test_freq[15]  = I_pla1_test_freq_7  ;
assign   S_pla_test_freq[16]  = I_pla2_test_freq_0  ;
assign   S_pla_test_freq[17]  = I_pla2_test_freq_1  ;
assign   S_pla_test_freq[18]  = I_pla2_test_freq_2  ;
assign   S_pla_test_freq[19]  = I_pla2_test_freq_3  ;
assign   S_pla_test_freq[20]  = I_pla2_test_freq_4  ;
assign   S_pla_test_freq[21]  = I_pla2_test_freq_5  ;
assign   S_pla_test_freq[22]  = I_pla2_test_freq_6  ;
assign   S_pla_test_freq[23]  = I_pla2_test_freq_7  ;


always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S_pla_312m5_4us_clk_cnt <= 11'd0;
    end
    else if(S_pla_312m5_4us_clk_cnt == 11'd1249)
    begin
        S_pla_312m5_4us_clk_cnt <= 11'd0;
    end
    else
    begin
        S_pla_312m5_4us_clk_cnt <= S_pla_312m5_4us_clk_cnt + 11'd1;
    end
end


always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
begin
        S_pla_4us_clk <= 1'd0;
    end
    else if(S_pla_312m5_4us_clk_cnt == 11'd499)
    begin
        S_pla_4us_clk <= 1'b1;
    end
    else
    begin
        S_pla_4us_clk <= 1'b0;
    end
end



generate
genvar i;
for(i=0;i<24;i=i+1)
begin:REQUEST_CHECK

    always @ (posedge I_pla_312m5_clk )
    begin
        if(S_xgmii_data_valid && (S_cnt == 4'd2) && (S_pla_rcu_mac[i] == {S2_xgmii_rxd,S1_xgmii_rxd[31:16]})) 
        begin
            if ((I_xgmii_rxd[31:16] == 16'h80fc) && (S_pla_air_mac[i] == {S1_xgmii_rxd[15:0],S_xgmii_rxd})) 
            begin
               S_pla_req_check_ok[i] <= 1'b1;
            end   
            else
            begin
               S_pla_req_check_ok[i] <= 1'b0;
            end   
        end
        else if(!S_xgmii_data_valid)
        begin
            S_pla_req_check_ok[i] <= 1'b0;
        end
    end

    always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)    
    begin
        if(I_pla_rst)
        begin
            S_pla_req_wait_cnt[i] <= 16'd0;
        end
        else if(S_pla_req_check_ok[i])
        begin
            S_pla_req_wait_cnt[i] <= 16'd0;
        end
        else if(S_pla_4us_clk)
        begin
            if(S_pla_req_wait_cnt[i] == I_request_wait_time)
            begin
                S_pla_req_wait_cnt[i] <= S_pla_req_wait_cnt[i];
            end
            else
            begin
                S_pla_req_wait_cnt[i] <= S_pla_req_wait_cnt[i] + 16'd1;
            end
        end
    end
    
    always @ (posedge I_pla_312m5_clk)
    begin
        if(S_pla_req_wait_cnt[i] == I_request_wait_time)
        begin
            S_pla_req_wait_timeout[i] <= 1'b1;
        end
        else
        begin
            S_pla_req_wait_timeout[i] <= 1'b0;
        end
    end
    
    always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)   
    begin
        if(I_pla_rst)
        begin
            S_pla_link_state[i]  <= 1'b0;
        end    
        else if(S_pla_req_wait_timeout[i] && I_request_wait_en)
        begin
            S_pla_link_state[i] <= 1'b0;
        end
        else if(S_pla_req_check_ok[i] && (S_cnt == 4'd8))
        begin
            S_pla_link_state[i] <= !S5_xgmii_rxd[14];
        end
    end
    
    always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)   
    begin
       if(I_pla_rst)
       begin
           S_pla_rmu_acm[i]     <= 4'd0;
           S_pla_rmu_request[i] <= 1'b0;
           S_pla_rmu_pause[i]   <= 1'b0;
       end    
       else if(S_pla_req_check_ok[i] && (S_cnt == 4'd9))
       begin
           S_pla_rmu_acm[i]     <= S5_xgmii_rxd[19:16];
           S_pla_rmu_pause[i]   <= S5_xgmii_rxd[23];
           S_pla_rmu_request[i] <= S_pla_link_state[i];
       end
       else
       begin
           S_pla_rmu_request[i] <= 1'd0;
       end
    end
    
    always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)   
    begin
       if(I_pla_rst)
       begin
           S_pla_rmu_freq[i]   <= 32'd0;
       end    
       else if(S_pla_req_check_ok[i] && (S_cnt == 4'd10))
       begin
           S_pla_rmu_freq[i]   <= S4_xgmii_rxd[31:0];
       end
    end
    
    always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)   
    begin
       if(I_pla_rst)
       begin
           S_pla_rmu_rate[i]   <= 16'd0;
       end  
       else if (!S_pla_link_state[i])
       begin
           S_pla_rmu_rate[i]   <= 16'd0;
       end  
       else if(S_pla_req_check_ok[i] && (S_cnt == 4'd11))  
       begin
           S_pla_rmu_rate[i]   <= S4_xgmii_rxd[31:16];
       end
    end
        
    
    

    
pla_request_gen  U01_pla_request_gen
(                   
    .I_pla_main_clk       (I_pla_312m5_clk        ),      
    .I_pla_rst            (I_pla_rst              ), 
    .I_cnt_value_clr      (I_cnt_clear            ),
    .I_pla_sel            (1'b1                   ),////选择原来的I_pla_req方式，还是修改后的新方案    1sel new 
    .I_pla_req            (S_pla_rmu_request[i]   ),////来自pla_request_parser的检测信号
                                                  
    .I_pla_test_freq      (S_pla_test_freq[i]     ),
    .I_pla_rmu_freq       (S_pla_rmu_freq[i]      ),                                              
    .I_txpla_acm_mode     (S_pla_rmu_acm[i]       ), 
    .I_tx_pause           (S_pla_rmu_pause[i]     ), 
    .I_tx_link            (S_pla_link_state[i]    ), 
                                                      
    .O_pla_current_freq   (S_pla_current_freq[i]  ),  
    .O_pla_req_change_cnt (S_pla_req_change_cnt[i]),  
    .O_pla_request        (S_pla_air_request[i]   ) 
); 


    always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)   
    begin
       if(I_pla_rst)
       begin
           S_pla_req_cnt[i]   <= 8'd0;
       end    
       else if (I_cnt_clear)
       begin
           S_pla_req_cnt[i]   <= 8'd0;
       end
       else if(S_pla_req_check_ok[i] && (S_cnt == 4'd4))
       begin
           S_pla_req_cnt[i]   <= S_pla_req_cnt[i]  + 8'd1;
       end
    end
    
    always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)   
    begin
       if(I_pla_rst)
       begin
           S_pla_timeout_cnt[i] <= 8'd0;
       end 
       else if (I_cnt_clear)
       begin
           S_pla_timeout_cnt[i] <= 8'd0;
       end         
       else if(S_pla_req_wait_timeout[i])
       begin
           S_pla_timeout_cnt[i] <= S_pla_timeout_cnt[i]  + 8'd1;
       end
    end
       
end
endgenerate    

                              
assign  O_pla0_air_link        =  S_pla_link_state[7:0];
assign  O_pla1_air_link        =  S_pla_link_state[15:8];
assign  O_pla2_air_link        =  S_pla_link_state[23:16];
                              
assign  O_pla0_air_request     =  S_pla_air_request[7:0];  
assign  O_pla1_air_request     =  S_pla_air_request[15:8]; 
assign  O_pla2_air_request     =  S_pla_air_request[23:16];
                              
assign  O_pla0_air_pause       =  S_pla_rmu_pause[7:0];  
assign  O_pla1_air_pause       =  S_pla_rmu_pause[15:8]; 
assign  O_pla2_air_pause       =  S_pla_rmu_pause[23:16];
                           
assign  O_pla00_current_acm    =  S_pla_rmu_acm[0 ] ;
assign  O_pla01_current_acm    =  S_pla_rmu_acm[1 ] ;
assign  O_pla02_current_acm    =  S_pla_rmu_acm[2 ] ;
assign  O_pla03_current_acm    =  S_pla_rmu_acm[3 ] ;
assign  O_pla04_current_acm    =  S_pla_rmu_acm[4 ] ;
assign  O_pla05_current_acm    =  S_pla_rmu_acm[5 ] ;
assign  O_pla06_current_acm    =  S_pla_rmu_acm[6 ] ;
assign  O_pla07_current_acm    =  S_pla_rmu_acm[7 ] ;
assign  O_pla10_current_acm    =  S_pla_rmu_acm[8 ] ;
assign  O_pla11_current_acm    =  S_pla_rmu_acm[9 ] ;
assign  O_pla12_current_acm    =  S_pla_rmu_acm[10] ;
assign  O_pla13_current_acm    =  S_pla_rmu_acm[11] ;
assign  O_pla14_current_acm    =  S_pla_rmu_acm[12] ;
assign  O_pla15_current_acm    =  S_pla_rmu_acm[13] ;
assign  O_pla16_current_acm    =  S_pla_rmu_acm[14] ;
assign  O_pla17_current_acm    =  S_pla_rmu_acm[15] ;
assign  O_pla20_current_acm    =  S_pla_rmu_acm[16] ;
assign  O_pla21_current_acm    =  S_pla_rmu_acm[17] ;
assign  O_pla22_current_acm    =  S_pla_rmu_acm[18] ;
assign  O_pla23_current_acm    =  S_pla_rmu_acm[19] ;
assign  O_pla24_current_acm    =  S_pla_rmu_acm[20] ;
assign  O_pla25_current_acm    =  S_pla_rmu_acm[21] ;
assign  O_pla26_current_acm    =  S_pla_rmu_acm[22] ;
assign  O_pla27_current_acm    =  S_pla_rmu_acm[23] ;

assign  O_pla00_current_freq    =  S_pla_current_freq[0 ] ;
assign  O_pla01_current_freq    =  S_pla_current_freq[1 ] ;
assign  O_pla02_current_freq    =  S_pla_current_freq[2 ] ;
assign  O_pla03_current_freq    =  S_pla_current_freq[3 ] ;
assign  O_pla04_current_freq    =  S_pla_current_freq[4 ] ;
assign  O_pla05_current_freq    =  S_pla_current_freq[5 ] ;
assign  O_pla06_current_freq    =  S_pla_current_freq[6 ] ;
assign  O_pla07_current_freq    =  S_pla_current_freq[7 ] ;
assign  O_pla10_current_freq    =  S_pla_current_freq[8 ] ;
assign  O_pla11_current_freq    =  S_pla_current_freq[9 ] ;
assign  O_pla12_current_freq    =  S_pla_current_freq[10] ;
assign  O_pla13_current_freq    =  S_pla_current_freq[11] ;
assign  O_pla14_current_freq    =  S_pla_current_freq[12] ;
assign  O_pla15_current_freq    =  S_pla_current_freq[13] ;
assign  O_pla16_current_freq    =  S_pla_current_freq[14] ;
assign  O_pla17_current_freq    =  S_pla_current_freq[15] ;
assign  O_pla20_current_freq    =  S_pla_current_freq[16] ;
assign  O_pla21_current_freq    =  S_pla_current_freq[17] ;
assign  O_pla22_current_freq    =  S_pla_current_freq[18] ;
assign  O_pla23_current_freq    =  S_pla_current_freq[19] ;
assign  O_pla24_current_freq    =  S_pla_current_freq[20] ;
assign  O_pla25_current_freq    =  S_pla_current_freq[21] ;
assign  O_pla26_current_freq    =  S_pla_current_freq[22] ;
assign  O_pla27_current_freq    =  S_pla_current_freq[23] ;

assign  O_pla00_req_change_cnt[15:0]   =  S_pla_req_change_cnt[0 ] ;
assign  O_pla01_req_change_cnt[15:0]   =  S_pla_req_change_cnt[1 ] ;
assign  O_pla02_req_change_cnt[15:0]   =  S_pla_req_change_cnt[2 ] ;
assign  O_pla03_req_change_cnt[15:0]   =  S_pla_req_change_cnt[3 ] ;
assign  O_pla04_req_change_cnt[15:0]   =  S_pla_req_change_cnt[4 ] ;
assign  O_pla05_req_change_cnt[15:0]   =  S_pla_req_change_cnt[5 ] ;
assign  O_pla06_req_change_cnt[15:0]   =  S_pla_req_change_cnt[6 ] ;
assign  O_pla07_req_change_cnt[15:0]   =  S_pla_req_change_cnt[7 ] ;
assign  O_pla10_req_change_cnt[15:0]   =  S_pla_req_change_cnt[8 ] ;
assign  O_pla11_req_change_cnt[15:0]   =  S_pla_req_change_cnt[9 ] ;
assign  O_pla12_req_change_cnt[15:0]   =  S_pla_req_change_cnt[10] ;
assign  O_pla13_req_change_cnt[15:0]   =  S_pla_req_change_cnt[11] ;
assign  O_pla14_req_change_cnt[15:0]   =  S_pla_req_change_cnt[12] ;
assign  O_pla15_req_change_cnt[15:0]   =  S_pla_req_change_cnt[13] ;
assign  O_pla16_req_change_cnt[15:0]   =  S_pla_req_change_cnt[14] ;
assign  O_pla17_req_change_cnt[15:0]   =  S_pla_req_change_cnt[15] ;
assign  O_pla20_req_change_cnt[15:0]   =  S_pla_req_change_cnt[16] ;
assign  O_pla21_req_change_cnt[15:0]   =  S_pla_req_change_cnt[17] ;
assign  O_pla22_req_change_cnt[15:0]   =  S_pla_req_change_cnt[18] ;
assign  O_pla23_req_change_cnt[15:0]   =  S_pla_req_change_cnt[19] ;
assign  O_pla24_req_change_cnt[15:0]   =  S_pla_req_change_cnt[20] ;
assign  O_pla25_req_change_cnt[15:0]   =  S_pla_req_change_cnt[21] ;
assign  O_pla26_req_change_cnt[15:0]   =  S_pla_req_change_cnt[22] ;
assign  O_pla27_req_change_cnt[15:0]   =  S_pla_req_change_cnt[23] ;
    
assign  O_pla00_req_change_cnt[31:16]   =  {S_pla_req_cnt[0 ] ,S_pla_timeout_cnt[0 ]};
assign  O_pla01_req_change_cnt[31:16]   =  {S_pla_req_cnt[1 ] ,S_pla_timeout_cnt[1 ]};
assign  O_pla02_req_change_cnt[31:16]   =  {S_pla_req_cnt[2 ] ,S_pla_timeout_cnt[2 ]};
assign  O_pla03_req_change_cnt[31:16]   =  {S_pla_req_cnt[3 ] ,S_pla_timeout_cnt[3 ]};
assign  O_pla04_req_change_cnt[31:16]   =  {S_pla_req_cnt[4 ] ,S_pla_timeout_cnt[4 ]};
assign  O_pla05_req_change_cnt[31:16]   =  {S_pla_req_cnt[5 ] ,S_pla_timeout_cnt[5 ]};
assign  O_pla06_req_change_cnt[31:16]   =  {S_pla_req_cnt[6 ] ,S_pla_timeout_cnt[6 ]};
assign  O_pla07_req_change_cnt[31:16]   =  {S_pla_req_cnt[7 ] ,S_pla_timeout_cnt[7 ]};
assign  O_pla10_req_change_cnt[31:16]   =  {S_pla_req_cnt[8 ] ,S_pla_timeout_cnt[8 ]};
assign  O_pla11_req_change_cnt[31:16]   =  {S_pla_req_cnt[9 ] ,S_pla_timeout_cnt[9 ]};
assign  O_pla12_req_change_cnt[31:16]   =  {S_pla_req_cnt[10] ,S_pla_timeout_cnt[10]};
assign  O_pla13_req_change_cnt[31:16]   =  {S_pla_req_cnt[11] ,S_pla_timeout_cnt[11]};
assign  O_pla14_req_change_cnt[31:16]   =  {S_pla_req_cnt[12] ,S_pla_timeout_cnt[12]};
assign  O_pla15_req_change_cnt[31:16]   =  {S_pla_req_cnt[13] ,S_pla_timeout_cnt[13]};
assign  O_pla16_req_change_cnt[31:16]   =  {S_pla_req_cnt[14] ,S_pla_timeout_cnt[14]};
assign  O_pla17_req_change_cnt[31:16]   =  {S_pla_req_cnt[15] ,S_pla_timeout_cnt[15]};
assign  O_pla20_req_change_cnt[31:16]   =  {S_pla_req_cnt[16] ,S_pla_timeout_cnt[16]};
assign  O_pla21_req_change_cnt[31:16]   =  {S_pla_req_cnt[17] ,S_pla_timeout_cnt[17]};
assign  O_pla22_req_change_cnt[31:16]   =  {S_pla_req_cnt[18] ,S_pla_timeout_cnt[18]};
assign  O_pla23_req_change_cnt[31:16]   =  {S_pla_req_cnt[19] ,S_pla_timeout_cnt[19]};
assign  O_pla24_req_change_cnt[31:16]   =  {S_pla_req_cnt[20] ,S_pla_timeout_cnt[20]};
assign  O_pla25_req_change_cnt[31:16]   =  {S_pla_req_cnt[21] ,S_pla_timeout_cnt[21]};
assign  O_pla26_req_change_cnt[31:16]   =  {S_pla_req_cnt[22] ,S_pla_timeout_cnt[22]};
assign  O_pla27_req_change_cnt[31:16]   =  {S_pla_req_cnt[23] ,S_pla_timeout_cnt[23]};
              

assign O_pla00_rmu_rate  = S_pla_rmu_rate[0 ] ;
assign O_pla01_rmu_rate  = S_pla_rmu_rate[1 ] ;
assign O_pla02_rmu_rate  = S_pla_rmu_rate[2 ] ;
assign O_pla03_rmu_rate  = S_pla_rmu_rate[3 ] ;
assign O_pla04_rmu_rate  = S_pla_rmu_rate[4 ] ;
assign O_pla05_rmu_rate  = S_pla_rmu_rate[5 ] ;
assign O_pla06_rmu_rate  = S_pla_rmu_rate[6 ] ;
assign O_pla07_rmu_rate  = S_pla_rmu_rate[7 ] ;
assign O_pla10_rmu_rate  = S_pla_rmu_rate[8 ] ;
assign O_pla11_rmu_rate  = S_pla_rmu_rate[9 ] ;
assign O_pla12_rmu_rate  = S_pla_rmu_rate[10] ;
assign O_pla13_rmu_rate  = S_pla_rmu_rate[11] ;
assign O_pla14_rmu_rate  = S_pla_rmu_rate[12] ;
assign O_pla15_rmu_rate  = S_pla_rmu_rate[13] ;
assign O_pla16_rmu_rate  = S_pla_rmu_rate[14] ;
assign O_pla17_rmu_rate  = S_pla_rmu_rate[15] ;
assign O_pla20_rmu_rate  = S_pla_rmu_rate[16] ;
assign O_pla21_rmu_rate  = S_pla_rmu_rate[17] ;
assign O_pla22_rmu_rate  = S_pla_rmu_rate[18] ;
assign O_pla23_rmu_rate  = S_pla_rmu_rate[19] ;
assign O_pla24_rmu_rate  = S_pla_rmu_rate[20] ;
assign O_pla25_rmu_rate  = S_pla_rmu_rate[21] ;
assign O_pla26_rmu_rate  = S_pla_rmu_rate[22] ;
assign O_pla27_rmu_rate  = S_pla_rmu_rate[23] ;


pla_request_rate_calc  U02_pla_request_rate_calc
(                   
    .I_pla_main_clk        (I_pla_312m5_clk     ),
    .I_pla_rst             (I_pla_rst           ),
    .I_cnt_clear           (I_cnt_clear         ),
    .I_pla_rmu_air_link    (S_pla_link_state    ),
 
    .I_pla_air_link_change_mask (I_pla_air_link_change_mask   ),
    .O_pla_air_link_change_flg  (O_pla_air_link_change_flg    ),   
     
    .I_pla00_rmu_rate      (O_pla00_rmu_rate    ),
    .I_pla01_rmu_rate      (O_pla01_rmu_rate    ),
    .I_pla02_rmu_rate      (O_pla02_rmu_rate    ),
    .I_pla03_rmu_rate      (O_pla03_rmu_rate    ),
    .I_pla04_rmu_rate      (O_pla04_rmu_rate    ),
    .I_pla05_rmu_rate      (O_pla05_rmu_rate    ),
    .I_pla06_rmu_rate      (O_pla06_rmu_rate    ),
    .I_pla07_rmu_rate      (O_pla07_rmu_rate    ),
    .I_pla10_rmu_rate      (O_pla10_rmu_rate    ),
    .I_pla11_rmu_rate      (O_pla11_rmu_rate    ),
    .I_pla12_rmu_rate      (O_pla12_rmu_rate    ),
    .I_pla13_rmu_rate      (O_pla13_rmu_rate    ),
    .I_pla14_rmu_rate      (O_pla14_rmu_rate    ),
    .I_pla15_rmu_rate      (O_pla15_rmu_rate    ),
    .I_pla16_rmu_rate      (O_pla16_rmu_rate    ),
    .I_pla17_rmu_rate      (O_pla17_rmu_rate    ),
    .I_pla20_rmu_rate      (O_pla20_rmu_rate    ),
    .I_pla21_rmu_rate      (O_pla21_rmu_rate    ),
    .I_pla22_rmu_rate      (O_pla22_rmu_rate    ),
    .I_pla23_rmu_rate      (O_pla23_rmu_rate    ),
    .I_pla24_rmu_rate      (O_pla24_rmu_rate    ),
    .I_pla25_rmu_rate      (O_pla25_rmu_rate    ),
    .I_pla26_rmu_rate      (O_pla26_rmu_rate    ),
    .I_pla27_rmu_rate      (O_pla27_rmu_rate    ),

    .I_hc_for_en           (I_hc_for_en         ),
    .I_pla_int_mask        (I_pla_int_mask      ),
    .I_pla_int_clr         (I_pla_int_clr       ),  
                                                      
    .O_pla0_rmu_rate       (O_pla0_rmu_rate     ),
    .O_pla1_rmu_rate       (O_pla1_rmu_rate     ),
    .O_pla2_rmu_rate       (O_pla2_rmu_rate     ),
    
    .O_pla00_rmu_rate_chg_cnt   (O_pla00_req_change_cnt[47:32]),
    .O_pla01_rmu_rate_chg_cnt   (O_pla01_req_change_cnt[47:32]),
    .O_pla02_rmu_rate_chg_cnt   (O_pla02_req_change_cnt[47:32]),
    .O_pla03_rmu_rate_chg_cnt   (O_pla03_req_change_cnt[47:32]),
    .O_pla04_rmu_rate_chg_cnt   (O_pla04_req_change_cnt[47:32]),
    .O_pla05_rmu_rate_chg_cnt   (O_pla05_req_change_cnt[47:32]),
    .O_pla06_rmu_rate_chg_cnt   (O_pla06_req_change_cnt[47:32]),
    .O_pla07_rmu_rate_chg_cnt   (O_pla07_req_change_cnt[47:32]),
    .O_pla10_rmu_rate_chg_cnt   (O_pla10_req_change_cnt[47:32]),
    .O_pla11_rmu_rate_chg_cnt   (O_pla11_req_change_cnt[47:32]),
    .O_pla12_rmu_rate_chg_cnt   (O_pla12_req_change_cnt[47:32]),
    .O_pla13_rmu_rate_chg_cnt   (O_pla13_req_change_cnt[47:32]),
    .O_pla14_rmu_rate_chg_cnt   (O_pla14_req_change_cnt[47:32]),
    .O_pla15_rmu_rate_chg_cnt   (O_pla15_req_change_cnt[47:32]),
    .O_pla16_rmu_rate_chg_cnt   (O_pla16_req_change_cnt[47:32]),
    .O_pla17_rmu_rate_chg_cnt   (O_pla17_req_change_cnt[47:32]),
    .O_pla20_rmu_rate_chg_cnt   (O_pla20_req_change_cnt[47:32]),
    .O_pla21_rmu_rate_chg_cnt   (O_pla21_req_change_cnt[47:32]),
    .O_pla22_rmu_rate_chg_cnt   (O_pla22_req_change_cnt[47:32]),
    .O_pla23_rmu_rate_chg_cnt   (O_pla23_req_change_cnt[47:32]),
    .O_pla24_rmu_rate_chg_cnt   (O_pla24_req_change_cnt[47:32]),
    .O_pla25_rmu_rate_chg_cnt   (O_pla25_req_change_cnt[47:32]),
    .O_pla26_rmu_rate_chg_cnt   (O_pla26_req_change_cnt[47:32]),
    .O_pla27_rmu_rate_chg_cnt   (O_pla27_req_change_cnt[47:32]),
    
    .O_pla2_cu_rate_chg_cnt (O_pla2_cu_rate_chg_cnt),  
    .O_pla1_cu_rate_chg_cnt (O_pla1_cu_rate_chg_cnt),  
    .O_pla0_cu_rate_chg_cnt (O_pla0_cu_rate_chg_cnt),
    
    .O_pla_rmu_int          (O_pla_rmu_int         ),
    .O_pla_int_event        (O_pla_int_event       ),
    .O_pla_int_n            (O_pla_int_n           )
); 

                                                              
endmodule                               
