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
//x                        |--U01_pla_forward_flow_32bit
//x                        |--U02_slice_generate
//x pla_forward_top_32bit--|--U021_pla_forward_schedule_32bit 
//x                        |--U022_pla_forward_slice_32bit  
//x                        |--U023_pla_forward_tc_index_protect  
//x                        |--U03_pla_forward_framer_32bit
//x                        |--U04_rcub_chk
//----------------------------------------------------------------------------
//Relaese History :
//----------------------------------------------------------------------------
//Version         Date           Author        Description
// 1.1          nov-30-2011      Li Shuai        pla_forward
// 1.2          Aug-28-2012      Sai Bin        modified for new pla
//----------------------------------------------------------------------------
//Main Function:
//a)8130选择 pla_forward_flow_32bit， RCUC选择 plax_forward_flow_32bit
//b)generate for(i=0;i<3;i=i+1'b1)   RCUC选择
//generate for(i=0;i<1;i=i+1'b1)    8130选择
//----------------------------------------------------------------------------
//REUSE ISSUES: xxxxxxxx
//Reset Strategy: xxxxxxxx
//Clock Strategy: xxxxxxxx
//Critical Timing: xxxxxxxx
//Asynchronous Interface: xxxxxxxx
//END_HEADER------------------------------------------------------------------

`timescale 1ns/1ns
module pla_forward_top_32bit
(
input               I_pla_312m5_clk              ,////时钟                                 
input               I_pla_rst                    ,////复位   
input      [7:0]    I_for_sub_rst                ,////复位   
input               I_cnt_clear                  ,
input      [2:0]    I_pla_tc_en                  ,////CPU配置的定向发送使能   
input      [2:0]    I_pla_for_en                 ,
input      [7:0]    I_pla0_tc_index              ,////PTP切片发送方向 0    
input      [7:0]    I_pla1_tc_index              ,////PTP切片发送方向 1     
input      [7:0]    I_pla2_tc_index              ,////PTP切片发送方向 2        
input      [15:0]   I_flow_fifo_pause_set        ,////流FIFO Pause交换水位,上限           
input      [15:0]   I_flow_fifo_resume_set       ,////流FIFO解Pause交换水位,下限 
input      [15:0]   I_flow_fifo_overflow_set       ,  /////  流FIFO解Pause交换水位,下限 
input      [31:0]   I_xgmii_txd                  ,////待发送XGMII数据       
input      [3:0]    I_xgmii_txc                  ,////待发送XGMII控制       
input      [1:0]    I_xgmii_pla_num              ,////待发送XGMII所需PLA组号     

input      [7:0]    I_pla0_air_link              ,////空口link指示   
input      [7:0]    I_pla1_air_link              ,////空口link指示   
input      [7:0]    I_pla2_air_link              ,////空口link指示           
input      [7:0]    I_pla0_air_request           ,////反向解析的切片请求pulse   
input      [7:0]    I_pla1_air_request           ,////反向解析的切片请求pulse   
input      [7:0]    I_pla2_air_request           ,////反向解析的切片请求pulse                                       
 
output     [2:0]    O_pla_for_ff_pause          ,////组1,2,3 PLA对应子端口Pause    

input      [2:0]    I_pla_tc_protect_en          ,////tc保护使能    
input  [15:0]   I_pla_tc_protect_cnt         ,

////CPU测试接口
output     [47:0]   O_flow_ff_para_full_cnt      ,
output     [47:0]   O_pla_air_unlink_cnt         ,
output     [47:0]   O_flow_ff0_frame_stat        ,////FLOW fifo 帧统计
output     [47:0]   O_flow_ff1_frame_stat        ,////FLOW fifo 帧统计
output     [47:0]   O_flow_ff2_frame_stat        ,////FLOW fifo 帧统计
                
output     [47:0]   O_flow_ff0_err_stat          ,////fifo空的次数  
output     [47:0]   O_flow_ff1_err_stat          ,////fifo空的次数
output     [47:0]   O_flow_ff2_err_stat          ,////fifo空的次数 
output [15:0]   O_flow_ff0_level             ,///fifo水位  
output [15:0]   O_flow_ff1_level             ,///fifo      
output [15:0]   O_flow_ff2_level             ,///fifo      
    
output     [31:0]   O_pla0_para_err_stat         ,
output     [31:0]   O_pla1_para_err_stat         ,
output     [31:0]   O_pla2_para_err_stat         ,
output     [79:0]   O_slice_fifo0_len_err        ,////测试寄存器
output     [79:0]   O_slice_fifo1_len_err        ,////测试寄存器
output     [79:0]   O_slice_fifo2_len_err        ,////测试寄存器

output     [15:0]   O_pla0_tc_protect_err_cnt    ,////测试寄存器
output     [15:0]   O_pla1_tc_protect_err_cnt    ,////测试寄存器
output     [15:0]   O_pla2_tc_protect_err_cnt    ,////测试寄存器

output [2:0]    O_pla_tc_protect_out         ,////

 
////frame 模块信号
input      [47:0]   I_pla0_air_mac_0             ,//// PLA0空口0 mac       
input      [47:0]   I_pla0_air_mac_1             ,//// PLA0空口1 mac       
input      [47:0]   I_pla0_air_mac_2             ,//// PLA0空口2 mac       
input      [47:0]   I_pla0_air_mac_3             ,//// PLA0空口3 mac       
input      [47:0]   I_pla0_air_mac_4             ,//// PLA0空口4 mac       
input      [47:0]   I_pla0_air_mac_5             ,//// PLA0空口5 mac       
input      [47:0]   I_pla0_air_mac_6             ,//// PLA0空口6 mac       
input      [47:0]   I_pla0_air_mac_7             ,//// PLA0空口7 mac       
input      [47:0]   I_pla1_air_mac_0             ,//// PLA1空口0 mac       
input      [47:0]   I_pla1_air_mac_1             ,//// PLA1空口1 mac       
input      [47:0]   I_pla1_air_mac_2             ,//// PLA1空口2 mac       
input      [47:0]   I_pla1_air_mac_3             ,//// PLA1空口3 mac       
input      [47:0]   I_pla1_air_mac_4             ,//// PLA1空口4 mac       
input      [47:0]   I_pla1_air_mac_5             ,//// PLA1空口5 mac       
input      [47:0]   I_pla1_air_mac_6             ,//// PLA1空口6 mac       
input      [47:0]   I_pla1_air_mac_7             ,//// PLA1空口7 mac       
input      [47:0]   I_pla2_air_mac_0             ,//// PLA2空口0 mac       
input      [47:0]   I_pla2_air_mac_1             ,//// PLA2空口1 mac       
input      [47:0]   I_pla2_air_mac_2             ,//// PLA2空口2 mac       
input      [47:0]   I_pla2_air_mac_3             ,//// PLA2空口3 mac       
input      [47:0]   I_pla2_air_mac_4             ,//// PLA2空口4 mac       
input      [47:0]   I_pla2_air_mac_5             ,//// PLA2空口5 mac       
input      [47:0]   I_pla2_air_mac_6             ,//// PLA2空口6 mac       
input      [47:0]   I_pla2_air_mac_7             ,//// PLA2空口7 mac       
                                              
input      [47:0]   I_pla0_rcu_mac               ,//// 切片发送源mac   
input      [47:0]   I_pla1_rcu_mac               ,//// 切片发送源mac   
input      [47:0]   I_pla2_rcu_mac               ,//// 切片发送源mac   
                                                              
input      [1:0]    I_rcub_chk_sel               ,                                                                   
output     [31:0]   O_xgmii_pla_slice_txd        ,//// 切片报文数据   
output     [3:0]    O_xgmii_pla_slice_txc        ,//// 切片报文控制  
output     [1:0]    O_xgmii_pla_slice_num        ,//// 切片报文控制   
output reg [15:0]   O_for0_input_cnt             ,///
output reg [15:0]   O_for1_input_cnt             ,///
output reg [15:0]   O_for2_input_cnt             ,///
output reg [15:0]   O_for3_input_cnt             ,///

output     [15:0]   O_pla0_forin_crcok_cnt       ,////
output     [15:0]   O_pla0_forin_crcerr_cnt      ,////
output     [15:0]   O_pla1_forin_crcok_cnt       ,////
output     [15:0]   O_pla1_forin_crcerr_cnt      ,////
output     [15:0]   O_pla2_forin_crcok_cnt       ,////
output     [15:0]   O_pla2_forin_crcerr_cnt      ,////

output     [15:0]   O_for_egmii_crcerr_frame_cnt  ,
output     [15:0]   O_for_egmii_output_frame_cnt  ,
output     [15:0]   O_for_egmii_reframer_err_cnt  , 
output              O_for_egmii_num_chk          ,
output     [15:0]  O_for_framer_55D5_cnt         ,
output     [15:0]  O_for_framer_lose_cnt         ,
output             O_for_framer_lose_reg         ,
output     [15:0]   O_for_framer_err_cnt          ,
output [15:0]   O_for_frame_cnt
);


////flow module
wire  [2:0]   S_flow_fifo_rden              ; ///流fifo读使能，高低共用 
wire  [33:0]  S_flow_fifo_rdata      [2:0]  ; ///
wire  [33:0]  S_flow_fifo_next_rdata [2:0]  ; ///
wire  [2:0]   S_flow_fifo_pt                ; ///      
wire  [2:0]   S_flow_fifo_empty             ; ///empty signal of flow fifo  

////schedule and slice module
wire  [7:0]   S_pla_air_link         [2:0]  ;////空口link指示  
wire  [7:0]   S_pla_tc_index         [2:0]  ;////PTP切片发送方向  
wire  [7:0]   S_pla_air_request      [2:0]  ;////反向解析的切片请求pulse 
wire  [2:0]   S_pla_slice_idle              ;///切片空闲指示，可以发送请求
wire  [2:0]   S_slice_ptp_req               ;///PTP报文定向发送请求 :前向切片模块发出 
wire  [7:0]   S_pla_slice_send_req   [2:0]  ;///处理后的切片请求pulse    
wire  [7:0]   S_slice_fifo_rden      [2:0]  ;///组帧模块发送的slice fifo读控制信号  
wire  [31:0]  S_slice_fifo_rdata     [2:0]  ;///切片fifo读数据    
wire  [7:0]   S_pla_slice_fifo_empty [2:0]  ;///切片fifo空指示，空才可发送   
wire  [23:0]  S_slice_fifo_parameter [2:0]  ;///切片ID和切片发送方向   
wire  [7:0]   S_buff_data_length     [2:0]  ;///统计送到buff中净荷的长度，用于组帧(include 253data + 1id)
////frame module
wire  [7:0]   S_buff_frame_ready     [2:0]  ;///Pla_slice	BUFF的存储完毕切片，可以组帧
wire  [79:0]  S_slice_fifo_len_err   [2:0]  ;///测试寄存器


wire  [2:0]   S_pla_tc_slice_en             ;///
wire  [15:0]  S_pla_tc_protect_err_cnt[2:0] ;///

wire  [2:0]   S_flow_rst;

assign S_pla_tc_index[0] =  I_pla0_tc_index ; 
assign S_pla_tc_index[1] =  I_pla1_tc_index ; 
assign S_pla_tc_index[2] =  I_pla2_tc_index ;

assign S_pla_air_link[0] =  I_pla0_air_link ;  
assign S_pla_air_link[1] =  I_pla1_air_link ; 
assign S_pla_air_link[2] =  I_pla2_air_link ; 

assign S_pla_air_request[0] =  I_pla0_air_request ;  
assign S_pla_air_request[1] =  I_pla1_air_request ;  
assign S_pla_air_request[2] =  I_pla2_air_request ;  

assign O_slice_fifo0_len_err  =  S_slice_fifo_len_err[0]  ;  
assign O_slice_fifo1_len_err  =  S_slice_fifo_len_err[1]  ;  
assign O_slice_fifo2_len_err  =  S_slice_fifo_len_err[2]  ;  


assign O_pla0_tc_protect_err_cnt  =  S_pla_tc_protect_err_cnt[0]  ;  
assign O_pla1_tc_protect_err_cnt  =  S_pla_tc_protect_err_cnt[1]  ;  
assign O_pla2_tc_protect_err_cnt  =  S_pla_tc_protect_err_cnt[2]  ;  

always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        O_for0_input_cnt <= 16'b0 ;
        O_for1_input_cnt <= 16'b0 ; 
        O_for2_input_cnt <= 16'b0 ; 
        O_for3_input_cnt <= 16'b0 ; 
    end
    else if (I_cnt_clear)
    begin
        O_for0_input_cnt <= 16'b0 ;
        O_for1_input_cnt <= 16'b0 ; 
        O_for2_input_cnt <= 16'b0 ; 
        O_for3_input_cnt <= 16'b0 ; 
    end
    else if (I_xgmii_txc == 4'h8 )
    begin
        if (I_xgmii_pla_num == 2'd0)
            O_for0_input_cnt <= O_for0_input_cnt + 16'd1 ;
        else if(I_xgmii_pla_num == 2'd1)
            O_for1_input_cnt <= O_for1_input_cnt + 16'd1 ;
        else if(I_xgmii_pla_num == 2'd2)
            O_for2_input_cnt <= O_for2_input_cnt + 16'd1 ;
        else 
            O_for3_input_cnt <= O_for3_input_cnt + 16'd1 ;
    end
end



plax_forward_flow_32bit U01_pla_forward_flow_32bit
(                  
.I_pla_312m5_clk             (I_pla_312m5_clk             ),
.I_pla_rst                   (I_pla_rst                   ),
.I_pla_flow_rst              (I_for_sub_rst[2:0]          ),
.I_cnt_clear                 (I_cnt_clear                 ),
.I_pla0_tc_en                (S_pla_tc_slice_en[0]        ),
.I_pla1_tc_en                (S_pla_tc_slice_en[1]        ),
.I_pla2_tc_en                (S_pla_tc_slice_en[2]        ),
.I_pla0_air_link             (I_pla0_air_link             ),////空口link指示    ,////空口link指示   
.I_pla1_air_link             (I_pla1_air_link             ),////空口link指示    ,////空口link指示   
.I_pla2_air_link             (I_pla2_air_link             ),////空口link指示    ,////空口link指示
.I_pla_for_en                (I_pla_for_en                 ),    
.I_flow_fifo_pause_set       (I_flow_fifo_pause_set       ),
.I_flow_fifo_resume_set      (I_flow_fifo_resume_set      ),
.I_flow_fifo_overflow_set    (I_flow_fifo_overflow_set    ),
.I_xgmii_txd                 (I_xgmii_txd                 ),
.I_xgmii_txc                 (I_xgmii_txc                 ),
.I_xgmii_pla_num             (I_xgmii_pla_num             ),
.I_flow_fifo_rden            (S_flow_fifo_rden            ),    

.O_flow_fifo0_next_rdata     (S_flow_fifo_next_rdata[0]   ),
.O_flow_fifo0_rdata          (S_flow_fifo_rdata[0]        ),
.O_flow_fifo1_next_rdata     (S_flow_fifo_next_rdata[1]   ),
.O_flow_fifo1_rdata          (S_flow_fifo_rdata[1]        ),
.O_flow_fifo2_next_rdata     (S_flow_fifo_next_rdata[2]   ),
.O_flow_fifo2_rdata          (S_flow_fifo_rdata[2]        ),

.O_pla_for_ff_pause          (O_pla_for_ff_pause          ),
.O_flow_ff_para_full_cnt     (O_flow_ff_para_full_cnt     ),
.O_pla_air_unlink_cnt        (O_pla_air_unlink_cnt        ),
.O_flow_fifo_empty           (S_flow_fifo_empty           ),
.O_flow_ff0_frame_stat       (O_flow_ff0_frame_stat       ),
.O_flow_ff1_frame_stat       (O_flow_ff1_frame_stat       ),
.O_flow_ff2_frame_stat       (O_flow_ff2_frame_stat       ),   
.O_flow_ff0_level            (O_flow_ff0_level            ), 
.O_flow_ff1_level            (O_flow_ff1_level            ), 
.O_flow_ff2_level            (O_flow_ff2_level            ), 
                               
.O_pla0_forin_crcok_cnt      (O_pla0_forin_crcok_cnt     ),
.O_pla0_forin_crcerr_cnt     (O_pla0_forin_crcerr_cnt    ),
.O_pla1_forin_crcok_cnt      (O_pla1_forin_crcok_cnt     ),
.O_pla1_forin_crcerr_cnt     (O_pla1_forin_crcerr_cnt    ),
.O_pla2_forin_crcok_cnt      (O_pla2_forin_crcok_cnt     ),
.O_pla2_forin_crcerr_cnt     (O_pla2_forin_crcerr_cnt    ),
                                                             
.O_pla0_para_err_stat        (O_pla0_para_err_stat       ),
.O_pla1_para_err_stat        (O_pla1_para_err_stat       ),
.O_pla2_para_err_stat        (O_pla2_para_err_stat       ),
.O_flow_rst                  (S_flow_rst                 ),
                                                 
                                                    
.O_flow_ff0_err_stat         (O_flow_ff0_err_stat         ),
.O_flow_ff1_err_stat         (O_flow_ff1_err_stat         ),
.O_flow_ff2_err_stat         (O_flow_ff2_err_stat         )

);  


 
genvar i;
generate for(i=0;i<3;i=i+1'b1) 
///generate for(i=0;i<1;i=i+1'b1)    ///8130选择
begin: U02_slice_generate
pla_forward_schedule_32bit U021_pla_forward_schedule_32bit(
    .I_pla_312m5_clk         (I_pla_312m5_clk           ) , ///时钟                     
    .I_pla_rst               (S_flow_rst[i]||I_for_sub_rst[i] ),  ///复位                     
    .I_pla_tc_index          (S_pla_tc_index[i]         ) , ///TC定向发送方向指示  :CPU send      
    .I_slice_ptp_req         (S_slice_ptp_req[i]        ) , ///PTP报文定向发送请求 :前向切片模块发出 
    .I_pla_air_link          (S_pla_air_link[i]         ) , ///空口link指示              
    .I_pla_air_request       (S_pla_air_request[i]      ) , ///反向解析的切片请求pulse   
    .I_pla_slice_idle        (S_pla_slice_idle[i]       ) , ///切片空闲指示，可以发送请求
    .I_pla_slice_fifo_empty  (S_pla_slice_fifo_empty[i] ) , ///切片fifo空指示，空才可发送    
    .O_pla_slice_send_req    (S_pla_slice_send_req[i]   )   ///处理后的切片请求pulse    
);    


pla_forward_slice_32bit U022_pla_forward_slice_32bit
(                   
    .I_pla_312m5_clk         (I_pla_312m5_clk           ),   ///时钟                    
    .I_pla_rst               (S_flow_rst[i]||I_for_sub_rst[i] ),   ///复位                   
    .I_pla_tc_en             (S_pla_tc_slice_en[i]      ),   ///CPU配置的定向发送使能   
    .I_pla_tc_index          (S_pla_tc_index[i]         ),   ///PTP切片发送方向         
    .I_pla_slice_send_req    (S_pla_slice_send_req[i]   ),   ///调度模块发送的切片请求 
    .I_cnt_clear             (I_cnt_clear               ),
                                                             
    .I_flow_fifo_empty       (S_flow_fifo_empty[i]      ),   ///流FIFO高位空标志        
    .I_flow_fifo_rdata       (S_flow_fifo_rdata[i]      ),   ///流FIFO读数据      
    .I_flow_fifo_next_rdata  (S_flow_fifo_next_rdata[i] ),   ///流FIFO下一读数据  
    
    .I_slice_fifo2_rd        (S_slice_fifo_rden[i]      ),   ///前向组帧模块发送的slice fifo读控制信号                                          
    .O_slice_fifo_empty      (S_pla_slice_fifo_empty[i] ),   ///前向fifo空标志                 
    .O_slice_fifo_rdata      (S_slice_fifo_rdata[i]     ),   ///切片fifo读数据     
    .O_slice_fifo_parameter  (S_slice_fifo_parameter[i] ),   ///切片ID和切片发送方向   
           
    .O_slice_ptp_req         (S_slice_ptp_req[i]        ),   ///PTP切片发送请求:O_pla_slice_tc_send_req              
    .O_slice_fifo_idle       (S_pla_slice_idle[i]       ),   ///切片空闲  ,表示正在切片中，或这在准备切片，不接受其他request busy....                        
    .O_flow_fifo_rden        (S_flow_fifo_rden[i]       ),   ///流fifo读使能，高低共用                              
    .O_slice_fifo_len_err    (S_slice_fifo_len_err[i]   ),   ///测试寄存器
    
    .O_buff_frame_ready      (S_buff_frame_ready[i]     ),   ///Pla_slice	BUFF的存储完毕切片，可以组帧
    .O_buff_data_length      (S_buff_data_length[i]     ),   ///统计送到buff中净荷的长度，用于组帧(include 253data + 1id)
    .O_flow_fifo_pt          (S_flow_fifo_pt[i]         )
);     


pla_forward_tc_index_protect U023_pla_forward_tc_index_protect(
.I_pla_312m5_clk             (I_pla_312m5_clk              ),   ///模块全局时钟
.I_pla_rst                   (S_flow_rst[i]||I_for_sub_rst[i] ),  ///模块复位信号
.I_pla_tc_index_en           (I_pla_tc_en[i]               ),   ///
.I_pla_tc_protect_en         (I_pla_tc_protect_en[i]       ),   ///
.I_pla_tc_index              (S_pla_tc_index[i]            ),   ///PTP切片发送方向   
.I_pla_tc_protect_cnt        (I_pla_tc_protect_cnt         ),
.I_rmuc_request              (S_pla_air_request[i]         ),
.O_pla_tc_protect_out        (O_pla_tc_protect_out[i]      ),  ///local bus接口
.O_pla_tc_protect_out_cnt    (S_pla_tc_protect_err_cnt[i]  ),  ///local bus
.O_pla_tc_index_en           (S_pla_tc_slice_en[i]         )
);

end
endgenerate


pla_forward_framer_32bit  U03_pla_forward_framer_32bit(
.I_pla_312m5_clk             (I_pla_312m5_clk           ) ,
.I_pla_rst                   (I_pla_rst||I_for_sub_rst[4]) ,
.I_cnt_clear                 (I_cnt_clear               ),
.I_pla0_air_mac_0            (I_pla0_air_mac_0          ) ,
.I_pla0_air_mac_1            (I_pla0_air_mac_1          ) ,
.I_pla0_air_mac_2            (I_pla0_air_mac_2          ) ,
.I_pla0_air_mac_3            (I_pla0_air_mac_3          ) ,
.I_pla0_air_mac_4            (I_pla0_air_mac_4          ) ,
.I_pla0_air_mac_5            (I_pla0_air_mac_5          ) ,
.I_pla0_air_mac_6            (I_pla0_air_mac_6          ) ,
.I_pla0_air_mac_7            (I_pla0_air_mac_7          ) ,
.I_pla1_air_mac_0            (I_pla1_air_mac_0          ) ,
.I_pla1_air_mac_1            (I_pla1_air_mac_1          ) ,
.I_pla1_air_mac_2            (I_pla1_air_mac_2          ) ,
.I_pla1_air_mac_3            (I_pla1_air_mac_3          ) ,
.I_pla1_air_mac_4            (I_pla1_air_mac_4          ) ,
.I_pla1_air_mac_5            (I_pla1_air_mac_5          ) ,
.I_pla1_air_mac_6            (I_pla1_air_mac_6          ) ,
.I_pla1_air_mac_7            (I_pla1_air_mac_7          ) ,
.I_pla2_air_mac_0            (I_pla2_air_mac_0          ) ,
.I_pla2_air_mac_1            (I_pla2_air_mac_1          ) ,
.I_pla2_air_mac_2            (I_pla2_air_mac_2          ) ,
.I_pla2_air_mac_3            (I_pla2_air_mac_3          ) ,
.I_pla2_air_mac_4            (I_pla2_air_mac_4          ) ,
.I_pla2_air_mac_5            (I_pla2_air_mac_5          ) ,
.I_pla2_air_mac_6            (I_pla2_air_mac_6          ) ,
.I_pla2_air_mac_7            (I_pla2_air_mac_7          ) ,
.I_rcub_chk_sel              (I_rcub_chk_sel            ),     
.I_pla0_rcu_mac              (I_pla0_rcu_mac            ) , //// 切片发送源mac    
.I_pla1_rcu_mac              (I_pla1_rcu_mac            ) , //// 切片发送源mac    
.I_pla2_rcu_mac              (I_pla2_rcu_mac            ) , //// 切片发送源mac                                                     
.I_buff0_frame_ready         (S_buff_frame_ready[0]     ) ,
.I_buff1_frame_ready         (S_buff_frame_ready[1]     ) ,
.I_buff2_frame_ready         (S_buff_frame_ready[2]     ) ,                                                    
.I_slice0_fifo_parameter     (S_slice_fifo_parameter[0] ) ,      
.I_slice1_fifo_parameter     (S_slice_fifo_parameter[1] ) ,      
.I_slice2_fifo_parameter     (S_slice_fifo_parameter[2] ) ,      
.I_slice0_fifo_empty         (S_pla_slice_fifo_empty[0] ) ,
.I_slice1_fifo_empty         (S_pla_slice_fifo_empty[1] ) ,
.I_slice2_fifo_empty         (S_pla_slice_fifo_empty[2] ) ,                                                       
.I_slice0_fifo_rdata         (S_slice_fifo_rdata[0]     ) , 
.I_slice1_fifo_rdata         (S_slice_fifo_rdata[1]     ) ,
.I_slice2_fifo_rdata         (S_slice_fifo_rdata[2]     ) ,
                                                       
.O_slice0_fifo_rd            (S_slice_fifo_rden[0]      ) ,
.O_slice1_fifo_rd            (S_slice_fifo_rden[1]      ) ,
.O_slice2_fifo_rd            (S_slice_fifo_rden[2]      ) ,
                                                                     
.O_xgmii_pla_slice_txd       (O_xgmii_pla_slice_txd     ) ,
.O_xgmii_pla_slice_txc       (O_xgmii_pla_slice_txc     ) ,
.O_xgmii_pla_slice_num       (O_xgmii_pla_slice_num     ) ,

.O_for_framer_55D5_cnt       (O_for_framer_55D5_cnt     ) ,
.O_for_framer_lose_cnt       (O_for_framer_lose_cnt     ) ,
.O_for_framer_lose_reg       (O_for_framer_lose_reg     ) ,
.O_for_framer_err_cnt        (O_for_framer_err_cnt      ),
.O_for_frame_cnt             (O_for_frame_cnt           )
);


/*
pla_forward_data_rcub_chk U04_rcub_chk
(
.I_pla_312m5_clk           (I_pla_312m5_clk             ),
.I_pla_rst                 (I_pla_rst                   ),
.I_xgmii_pla_slice_txd     (O_xgmii_pla_slice_txd       ),
.I_xgmii_pla_slice_txc     (O_xgmii_pla_slice_txc       ),
.I_xgmii_pla_slice_num     (O_xgmii_pla_slice_num       ),
.I_statistics_value_clr    (I_cnt_clear                 ),
.I_rcub_chk_sel            (I_rcub_chk_sel              ),     
.O_pla0_num_chk            (O_for_egmii_num_chk         ),   
.O_egmii_crcok_frame_cnt   (                            ),              
.O_egmii_crcerr_frame_cnt  (O_for_egmii_crcerr_frame_cnt),              
.O_egmii_output_frame_cnt  (O_for_egmii_output_frame_cnt),              
.O_egmii_reframe_state     (                            ),
.O_egmii_reframer_err_cnt  (O_for_egmii_reframer_err_cnt),
.O_egmii_slice_lost_cnt    (                        ),
.O_frame_dpram_usedw       (                        ),
.O_pla_rx_out_hc_frame     (                        ),
.O_egmii_rx_d              (                        ),
.O_egmii_rx_dv             (                        ),
.O_egmii_rx_err            (                        ),
.O_egmii_rx_mod            (                        )
);
*/

endmodule
