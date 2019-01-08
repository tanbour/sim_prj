//FILE_HEADER-----------------------------------------------------------------
//ZTE  Copyright (C)
//ZTE Company Confidential
//----------------------------------------------------------------------------
//Project Name : rcua_top
//FILE NAME    : pla_flow.v
//AUTHOR       : Sai Bin
//Department   : Tianjin Development Department 
//Email        : sai.bin@zte.com.cn
//----------------------------------------------------------------------------
//Module Hiberarchy :
//x                           |----U011_pla_for_flow_parameter_delay 参数提取模块
//x                           |----U012_pla_for_flow_parameter_delay 参数提取模块
//x                           |----U013_pla_for_flow_parameter_delay 参数提取模块
//x                           |----U02_pla_forward_flow_delay    延时模块
//x  pla_forward_flow_32bit---|----U03_pla_for_flow_fifo 
//x                           |----U031_pla_forward_flow_fifo_one 整流模块///u010_pla_for_flow_check
//x                           |----U041_for_crc_check CRC CHECK
//x                           |----U042_for_crc_check CRC CHECK
//x                           |----U043_for_crc_check CRC CHECK
//----------------------------------------------------------------------------
//Relaese History :
//----------------------------------------------------------------------------
//Version         Date           Author        Description
// 1.0            2012-08-17     Sai Bin       New Generate
//----------------------------------------------------------------------------
//Main Function:
//a)对输入到PLA的报文进行整形，并去掉报文之间的间隙，将其堆砌到流FIFO中，
//  等待切片模块读取。该模块为三组PLA公用。
//----------------------------------------------------------------------------
//REUSE ISSUES: empty
//Reset Strategy: empty
//Clock Strategy: empty
//Critical Timing: empty
//Asynchronous Interface: empty
//END_HEADER------------------------------------------------------------------

`timescale 1ns/1ns

module plax_forward_flow_32bit
(                   
    input                I_pla_312m5_clk               ,  /////  时钟               
    input                I_pla_rst                     ,  /////  复位  
    input          [2:0] I_pla_flow_rst                ,
    input                I_cnt_clear                   ,   ////             
    input                I_pla0_tc_en                  ,  /////  组1 PLA TC使能        
    input                I_pla1_tc_en                  ,  /////  组2 PLA TC使能        
    input                I_pla2_tc_en                  ,  /////  组3 PLA TC使能    
    input         [2:0]  I_pla_for_en                  ,        
    input         [7:0]  I_pla0_air_link              ,////空口link指示   
    input         [7:0]  I_pla1_air_link              ,////空口link指示   
    input         [7:0]  I_pla2_air_link              ,////空口link指示  
        
    input        [15:0]  I_flow_fifo_pause_set         ,  /////  流FIFO Pause交换水位,上限
    input        [15:0]  I_flow_fifo_resume_set        ,  /////  流FIFO解Pause交换水位,下限 
    input        [15:0]  I_flow_fifo_overflow_set       ,  /////  流FIFO解Pause交换水位,下限 
    input        [31:0]  I_xgmii_txd                   ,  /////  待发送XGMII数据       
    input         [3:0]  I_xgmii_txc                   ,  /////  待发送XGMII控制       
    input         [1:0]  I_xgmii_pla_num               ,  /////  待发送XGMII所需PLA组号

    input         [2:0]  I_flow_fifo_rden              ,  /////  组1PLA流FIFO读取使能  SLICE模块输出 

    output       [33:0]  O_flow_fifo0_next_rdata       ,  /////  组1PLA流FIFO下个数据  
    output       [33:0]  O_flow_fifo0_rdata            ,  /////  组1PLA流FIFO当前数据  
    output       [33:0]  O_flow_fifo1_next_rdata       ,  /////  组2PLA流FIFO下个数据  
    output       [33:0]  O_flow_fifo1_rdata            ,  /////  组2PLA流FIFO当前数据  
    output       [33:0]  O_flow_fifo2_next_rdata       ,  /////  组3PLA流FIFO下个数据  
    output       [33:0]  O_flow_fifo2_rdata            ,  /////  组3PLA流FIFO当前数据  
    
    output        [2:0]  O_pla_for_ff_pause            ,  ////   组1,2,3 PLA对应子端口Pause     
    output  reg  [47:0]  O_flow_ff_para_full_cnt       ,  /////empty signal of flow fifo 
    output  reg  [47:0]  O_pla_air_unlink_cnt          ,  /////empty signal of flow fifo 
    output        [2:0]  O_flow_fifo_empty             ,  /////empty signal of flow fifo
    output       [47:0]  O_flow_ff0_frame_stat         ,  //// FLOW fifo 帧统计
    output       [47:0]  O_flow_ff1_frame_stat         ,  //// FLOW fifo 帧统计
    output       [47:0]  O_flow_ff2_frame_stat         ,  //// FLOW fifo 帧统计
           
    output        [15:0] O_pla0_forin_crcok_cnt        ,        
    output        [15:0] O_pla0_forin_crcerr_cnt       ,       
    output        [15:0] O_pla1_forin_crcok_cnt        ,      
    output        [15:0] O_pla1_forin_crcerr_cnt       ,     
    output        [15:0] O_pla2_forin_crcok_cnt        ,      
    output        [15:0] O_pla2_forin_crcerr_cnt       ,   
    
    output        [31:0] O_pla0_para_err_stat       ,   
    output        [31:0] O_pla1_para_err_stat       ,  
    output        [31:0] O_pla2_para_err_stat       ,  

    output        [2:0]  O_flow_rst,
    output       [15:0]  O_flow_ff0_level              ,///fifo水位
    output       [15:0]  O_flow_ff1_level              ,///fifo
    output       [15:0]  O_flow_ff2_level              ,///fifo
    output       [47:0]  O_flow_ff0_err_stat           ,/////fifo空的次数  
    output       [47:0]  O_flow_ff1_err_stat           ,/////fifo空的次数
    output       [47:0]  O_flow_ff2_err_stat            /////fifo空的次数                                                     
);
     
(*mark_debug ="true"*) reg  [31:0] S_pla0_xgmii_txd ;     ///EGMII发送数据延迟1拍信号
(*mark_debug ="true"*) reg   [3:0] S_pla0_xgmii_txc ;     ///EGMII发送使能延迟1拍信号
(*mark_debug ="true"*) reg   [1:0] S_pla0_xgmii_num ;
reg  [31:0] S1_pla0_xgmii_txd ;  
reg   [3:0] S1_pla0_xgmii_txc ;  
reg   [1:0] S1_pla0_xgmii_num ;  
                     
reg  [31:0] S_pla1_xgmii_txd;                    ///EGMII发送数据延迟1拍信号
reg   [3:0] S_pla1_xgmii_txc;                    ///EGMII发送使能延迟1拍信号
reg   [1:0] S_pla1_xgmii_num;

reg  [31:0] S1_pla1_xgmii_txd;                    ///EGMII发送数据延迟1拍信号
reg   [3:0] S1_pla1_xgmii_txc;                    ///EGMII发送使能延迟1拍信号
reg   [1:0] S1_pla1_xgmii_num;

reg  [31:0] S_pla2_xgmii_txd;                    ///EGMII发送数据延迟1拍信号
reg   [3:0] S_pla2_xgmii_txc;                    ///EGMII发送使能延迟1拍信号
reg   [1:0] S_pla2_xgmii_num;

reg  [31:0] S1_pla2_xgmii_txd;                    ///EGMII发送数据延迟1拍信号
reg   [3:0] S1_pla2_xgmii_txc;                    ///EGMII发送使能延迟1拍信号
reg   [1:0] S1_pla2_xgmii_num;

wire        S_pla0_param_ff_full              ;
wire        S_pla1_param_ff_full              ;
wire        S_pla2_param_ff_full              ;


(*mark_debug ="true"*) wire        S_pla0_param_ff_empty              ;
wire        S_pla1_param_ff_empty              ;
wire        S_pla2_param_ff_empty              ;



(*mark_debug ="true"*) wire [31:0] S_pla0_para_fifo_rdata            ;
wire [31:0] S_pla1_para_fifo_rdata            ;
wire [31:0] S_pla2_para_fifo_rdata            ;
                                             
wire [37:0] S_pla0_xgmii_delayed_q            ;
wire [37:0] S_pla1_xgmii_delayed_q            ;
wire [37:0] S_pla2_xgmii_delayed_q            ;

(*mark_debug ="true"*)  reg  [35:0] S1_pla0_xgmii_delayed_q           ;
reg  [35:0] S1_pla1_xgmii_delayed_q      ;
reg  [35:0] S1_pla2_xgmii_delayed_q      ;
                                         
(*mark_debug ="true"*)wire        S_pla0_param_fifo_rden       ;
wire        S_pla1_param_fifo_rden       ;
wire        S_pla2_param_fifo_rden       ;

wire [2:0]  S_flow_para_err_flag         ;

reg         S_pla0_unlink_flag           ; 
reg         S_pla1_unlink_flag           ; 
reg         S_pla2_unlink_flag           ; 

reg         S_pla0_flow_rst              ;
reg         S_pla1_flow_rst              ;
reg         S_pla2_flow_rst              ;

reg  [2:0]  S1_pla0_flow_rst             ;
reg  [2:0]  S1_pla1_flow_rst             ;
reg  [2:0]  S1_pla2_flow_rst             ;

(* max_fanout = 62 *) reg  S2_pla0_flow_rst  ;
(* max_fanout = 62 *) reg  S2_pla1_flow_rst  ;
(* max_fanout = 62 *) reg  S2_pla2_flow_rst  ;


reg         S_flow_ff0_stop_flag  ;
reg [15:0]  S_flow_ff0_stop_cnt   ; 
reg [15:0]  S_flow_ff0_stop_frame_cnt   ;


reg         S_flow_ff1_stop_flag  ;
reg [15:0]  S_flow_ff1_stop_cnt   ; 
reg [15:0]  S_flow_ff1_stop_frame_cnt   ;


reg         S_flow_ff2_stop_flag  ;      
reg [15:0]  S_flow_ff2_stop_cnt   ;      
reg [15:0]  S_flow_ff2_stop_frame_cnt   ;
wire        S_pla0_crc_err;
wire        S_pla1_crc_err;
wire        S_pla2_crc_err;

assign O_flow_rst = {S2_pla2_flow_rst,S2_pla1_flow_rst,S2_pla0_flow_rst};

///----------------------------------------------------------------
///NUM0数据处理
///----------------------------------------------------------------
always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
    begin
        S_pla0_xgmii_txd  <= 32'h07070707;
        S_pla0_xgmii_txc  <= 4'hf;
        S_pla0_xgmii_num  <= 2'd0;   
    end     
    else if (I_xgmii_pla_num == 2'd0 && I_pla_for_en[0] &&(!S_pla0_unlink_flag))
    begin
        S_pla0_xgmii_txd  <= I_xgmii_txd      ;   
        S_pla0_xgmii_txc  <= I_xgmii_txc      ;   
        S_pla0_xgmii_num  <= 2'd0             ;   
    end             
    else 
    begin
        S_pla0_xgmii_txd  <= 32'h07070707;
        S_pla0_xgmii_txc  <= 4'hf;
        S_pla0_xgmii_num  <= 2'd0;    
    end  
end




always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
    begin
        S_flow_ff0_stop_flag  <= 1'b0;
    end     
    else if ((O_flow_ff0_level >= I_flow_fifo_overflow_set) && (S_pla0_xgmii_txc == 4'hf))
    begin
        S_flow_ff0_stop_flag <= 1'b1  ;      ////使能1 ;;;;;调试溢出为0 
    end             
    else if ((O_flow_ff0_level < I_flow_fifo_overflow_set) && (S_pla0_xgmii_txc == 4'hf))
    begin
        S_flow_ff0_stop_flag <= 1'b0 ;  
    end  
end

always @ (posedge I_pla_312m5_clk or posedge I_pla_rst) ////判定满的次数
begin
    if (I_pla_rst)
	  begin
        S_flow_ff0_stop_cnt <= 16'h0 ;
	  end
	  else if (I_cnt_clear)
	  begin
	      S_flow_ff0_stop_cnt <= 16'h0 ;
	  end
    else if (O_flow_ff0_level >= I_flow_fifo_overflow_set) 
    begin
        S_flow_ff0_stop_cnt  <= S_flow_ff0_stop_cnt + 16'd1;
    end        
end

assign O_flow_ff0_err_stat[15:0] = S_flow_ff0_stop_cnt;
assign O_flow_ff0_err_stat[31:16] = S_flow_ff0_stop_frame_cnt;

always @ (posedge I_pla_312m5_clk or posedge I_pla_rst) ////判定满的次数
begin
    if (I_pla_rst)
	  begin
        S_flow_ff0_stop_frame_cnt <= 16'h0 ;//16x16384
	  end
	  else if (I_cnt_clear)
	  begin
	      S_flow_ff0_stop_frame_cnt <= 16'h0 ;//16x16384
	  end
    else if (S_flow_ff0_stop_flag && S_pla0_xgmii_txc == 4'h8) ////h7fe0
    begin
        S_flow_ff0_stop_frame_cnt <= S_flow_ff0_stop_frame_cnt + 16'd1;
    end               
end

always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
    begin
        S1_pla0_xgmii_txd  <= 32'h07070707;
        S1_pla0_xgmii_txc  <= 4'hf;
        S1_pla0_xgmii_num  <= 2'd0;   
    end     
    else if(!S_flow_ff0_stop_flag)
    begin
        S1_pla0_xgmii_txd  <= S_pla0_xgmii_txd    ;   
        S1_pla0_xgmii_txc  <= S_pla0_xgmii_txc    ;   
        S1_pla0_xgmii_num  <= S_pla0_xgmii_num    ;   
    end             
    else 
    begin
        S1_pla0_xgmii_txd  <= 32'h07070707;
        S1_pla0_xgmii_txc  <= 4'hf;
        S1_pla0_xgmii_num  <= 2'd0;    
    end  
end

///----------------------------------------------------------------
///NUM1数据处理
///----------------------------------------------------------------
always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
    begin
        S_pla1_xgmii_txd  <= 32'h07070707;
        S_pla1_xgmii_txc  <= 4'hf;
        S_pla1_xgmii_num  <= 2'd1;   
    end     
    else if (I_xgmii_pla_num == 2'd1 && I_pla_for_en[1] &&(!S_pla1_unlink_flag))
    begin
        S_pla1_xgmii_txd  <= I_xgmii_txd      ;   
        S_pla1_xgmii_txc  <= I_xgmii_txc      ;   
        S_pla1_xgmii_num  <= 2'd1             ;   
    end             
    else 
    begin
        S_pla1_xgmii_txd  <= 32'h07070707;
        S_pla1_xgmii_txc  <= 4'hf;
        S_pla1_xgmii_num  <= 2'd1;    
    end  
end


always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
    begin
        S_flow_ff1_stop_flag  <= 1'b0;
    end     
    else if ((O_flow_ff1_level >= I_flow_fifo_overflow_set) && (S_pla1_xgmii_txc == 4'hf))
    begin
        S_flow_ff1_stop_flag <= 1'b1  ;     
    end             
    else if ((O_flow_ff1_level < I_flow_fifo_overflow_set) && (S_pla1_xgmii_txc == 4'hf))
    begin
        S_flow_ff1_stop_flag <= 1'b0 ;  
    end  
end

always @ (posedge I_pla_312m5_clk or posedge I_pla_rst) ////判定满的次数
begin
    if (I_pla_rst)
	  begin
        S_flow_ff1_stop_cnt <= 16'h0 ;
	  end
	  else if (I_cnt_clear)
	  begin
	      S_flow_ff1_stop_cnt <= 16'h0 ;
	  end
    else if (O_flow_ff1_level >= I_flow_fifo_overflow_set) 
    begin
        S_flow_ff1_stop_cnt  <= S_flow_ff1_stop_cnt + 16'd1;
    end        
end

assign O_flow_ff1_err_stat[15:0] = S_flow_ff1_stop_cnt;
assign O_flow_ff1_err_stat[31:16] = S_flow_ff1_stop_frame_cnt;

always @ (posedge I_pla_312m5_clk or posedge I_pla_rst) ////判定满的次数
begin
    if (I_pla_rst)
	  begin
        S_flow_ff1_stop_frame_cnt <= 16'h0 ;//16x16384
	  end
	  else if (I_cnt_clear)
	  begin
	      S_flow_ff1_stop_frame_cnt <= 16'h0 ;//16x16384
	  end
    else if (S_flow_ff1_stop_flag && S_pla1_xgmii_txc == 4'h8) ////h7fe0
    begin
        S_flow_ff1_stop_frame_cnt  <= S_flow_ff1_stop_frame_cnt + 16'd1;
    end        
               
end

always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
    begin
        S1_pla1_xgmii_txd  <= 32'h07070707;
        S1_pla1_xgmii_txc  <= 4'hf;
        S1_pla1_xgmii_num  <= 2'd1;   
    end     
    else if(!S_flow_ff1_stop_flag)
    begin
        S1_pla1_xgmii_txd  <= S_pla1_xgmii_txd    ;   
        S1_pla1_xgmii_txc  <= S_pla1_xgmii_txc    ;   
        S1_pla1_xgmii_num  <= S_pla1_xgmii_num    ;   
    end             
    else 
    begin
        S1_pla1_xgmii_txd  <= 32'h07070707;
        S1_pla1_xgmii_txc  <= 4'hf;
        S1_pla1_xgmii_num  <= 2'd1;    
    end  
end
///----------------------------------------------------------------
///NUM2数据处理
///----------------------------------------------------------------
always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
    begin
        S_pla2_xgmii_txd  <= 32'h07070707;
        S_pla2_xgmii_txc  <= 4'hf;
        S_pla2_xgmii_num  <= 2'd2;   
    end     
    else if (I_xgmii_pla_num == 2'd2 && I_pla_for_en[2] &&(!S_pla2_unlink_flag))
    begin
        S_pla2_xgmii_txd  <= I_xgmii_txd      ;   
        S_pla2_xgmii_txc  <= I_xgmii_txc      ;   
        S_pla2_xgmii_num  <= 2'd2             ;   
    end             
    else 
    begin
        S_pla2_xgmii_txd  <= 32'h07070707;
        S_pla2_xgmii_txc  <= 4'hf;
        S_pla2_xgmii_num  <= 2'd2;    
    end  
end


always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
    begin
        S_flow_ff2_stop_flag  <= 1'b0;
    end     
    else if ((O_flow_ff2_level >= I_flow_fifo_overflow_set) && (S_pla2_xgmii_txc == 4'hf))
    begin
        S_flow_ff2_stop_flag <= 1'b1  ;     
    end             
    else if ((O_flow_ff2_level < I_flow_fifo_overflow_set) && (S_pla2_xgmii_txc == 4'hf))
    begin
        S_flow_ff2_stop_flag <= 1'b0 ;  
    end  
end

always @ (posedge I_pla_312m5_clk or posedge I_pla_rst) ////判定满的次数
begin
    if (I_pla_rst)
	  begin
        S_flow_ff2_stop_cnt <= 16'h0 ;
	  end
	  else if (I_cnt_clear)
	  begin
	      S_flow_ff2_stop_cnt <= 16'h0 ;
	  end
    else if (O_flow_ff2_level >= I_flow_fifo_overflow_set) 
    begin
        S_flow_ff2_stop_cnt  <= S_flow_ff2_stop_cnt + 16'd1;
    end        
end

assign O_flow_ff2_err_stat[15:0] = S_flow_ff2_stop_cnt;
assign O_flow_ff2_err_stat[31:16] = S_flow_ff2_stop_frame_cnt;

always @ (posedge I_pla_312m5_clk or posedge I_pla_rst) ////判定满的次数
begin
    if (I_pla_rst)
	  begin
        S_flow_ff2_stop_frame_cnt <= 16'h0 ;//16x16384
	  end
	  else if (I_cnt_clear)
	  begin
	      S_flow_ff2_stop_frame_cnt <= 16'h0 ;//16x16384
	  end
    else if (S_flow_ff2_stop_flag && S_pla2_xgmii_txc == 4'h8) ////h7fe0
    begin
        S_flow_ff2_stop_frame_cnt  <= S_flow_ff2_stop_frame_cnt + 16'd1;
    end    
end

always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
    begin
        S1_pla2_xgmii_txd  <= 32'h07070707;
        S1_pla2_xgmii_txc  <= 4'hf;
        S1_pla2_xgmii_num  <= 2'd2;   
    end     
    else if(!S_flow_ff2_stop_flag)
    begin
        S1_pla2_xgmii_txd  <= S_pla2_xgmii_txd    ;   
        S1_pla2_xgmii_txc  <= S_pla2_xgmii_txc    ;   
        S1_pla2_xgmii_num  <= S_pla2_xgmii_num    ;   
    end             
    else 
    begin
        S1_pla2_xgmii_txd  <= 32'h07070707;
        S1_pla2_xgmii_txc  <= 4'hf;
        S1_pla2_xgmii_num  <= 2'd2;    
    end  
end
///----------------------------------------------------------------
///
///----------------------------------------------------------------
always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
        S_pla0_unlink_flag <= 1'b1;
    else if (I_pla0_air_link == 8'h0)
        S_pla0_unlink_flag <= 1'b1;
    else
        S_pla0_unlink_flag <= 1'b0;
end

always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
        S_pla1_unlink_flag <= 1'b1;
    else if (I_pla1_air_link == 8'h0)
        S_pla1_unlink_flag <= 1'b1;
    else
        S_pla1_unlink_flag <= 1'b0;
end

always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
        S_pla2_unlink_flag <= 1'b1;
    else if (I_pla2_air_link == 8'h0)
        S_pla2_unlink_flag <= 1'b1;
    else
        S_pla2_unlink_flag <= 1'b0;
end



always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
    begin
        S_pla0_flow_rst <= 1'b1;
        S1_pla0_flow_rst <= 3'd7;
        S2_pla0_flow_rst <= 1'b1;
    end
    else
    begin 
        S_pla0_flow_rst <= S_pla0_param_ff_full || I_pla_flow_rst[0] || (!I_pla_for_en[0]) ;////|| S_flow_para_err_flag[0] || S_pla0_unlink_flag;
        S1_pla0_flow_rst <= {S1_pla0_flow_rst[1:0],S_pla0_flow_rst};
        S2_pla0_flow_rst <= S1_pla0_flow_rst[2] || S1_pla0_flow_rst[1] ||S1_pla0_flow_rst[0] || S_pla0_flow_rst; 
    end        
end


always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
    begin
        S_pla1_flow_rst <= 1'b1;
        S1_pla1_flow_rst <= 3'd0;
        S2_pla1_flow_rst <= 1'b1;
    end
    else
    begin 
        S_pla1_flow_rst <= S_pla1_param_ff_full || I_pla_flow_rst[1] || (!I_pla_for_en[1]) ;///|| S_flow_para_err_flag[1] || S_pla1_unlink_flag;
        S1_pla1_flow_rst <= {S1_pla1_flow_rst[1:0],S_pla1_flow_rst};
        S2_pla1_flow_rst <= S1_pla1_flow_rst[2] || S1_pla1_flow_rst[1] ||S1_pla1_flow_rst[0] ||S_pla1_flow_rst;  
    end    
        
end


always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
    begin
        S_pla2_flow_rst <= 1'b1;
        S1_pla2_flow_rst <= 3'd0;
        S2_pla2_flow_rst <= 1'b1;
    end
    else
    begin 
        S_pla2_flow_rst <= S_pla2_param_ff_full || I_pla_flow_rst[2] || (!I_pla_for_en[2]); /// || S_flow_para_err_flag[2] || S_pla2_unlink_flag;
        S1_pla2_flow_rst <= {S1_pla2_flow_rst[1:0],S_pla2_flow_rst};
        S2_pla2_flow_rst <= S1_pla2_flow_rst[2] || S1_pla2_flow_rst[1] ||S1_pla2_flow_rst[0] ||S_pla2_flow_rst;  
    end      

end


pla_forward_flow_parameter U011_pla_for_flow_parameter_delay      ///过滤非三组的数据
(                   
.I_pla_312m5_clk          (I_pla_312m5_clk         ),  /////  时钟                  
.I_pla_rst                (S2_pla0_flow_rst        ),  /////  复位      
.I_cnt_clear              (I_cnt_clear             ),            
.I_pla_tc_en              (I_pla0_tc_en            ),  /////  组1 PLA TC使能               
.I_xgmii_txd              (S1_pla0_xgmii_txd       ),  /////  待发送XGMII数据       
.I_xgmii_txc              (S1_pla0_xgmii_txc       ),  /////  待发送XGMII控制       
.I_xgmii_pla_num          (S1_pla0_xgmii_num       ),  /////  待发送XGMII所需PLA组号
.I_pla_para_fifo_rd       (S_pla0_param_fifo_rden  ),  /////  整流模块发起 
.O_param_ff_full          (S_pla0_param_ff_full    ),
.O_pla_para_fifo_rdata    (S_pla0_para_fifo_rdata  ),
.O_param_ff_empty         (S_pla0_param_ff_empty   ),
.O_pla_para_err_stat      (O_pla0_para_err_stat    ),
.O_xgmii_delayed_q        (S_pla0_xgmii_delayed_q  )                                  
);


pla_forward_flow_parameter U012_pla_for_flow_parameter_delay    ///过滤非三组的数据
(                   
.I_pla_312m5_clk          (I_pla_312m5_clk         ),  /////  时钟                  
.I_pla_rst                (S2_pla1_flow_rst        ),  /////  复位     
.I_cnt_clear              (I_cnt_clear             ),               
.I_pla_tc_en              (I_pla1_tc_en            ),  /////  组1 PLA TC使能               
.I_xgmii_txd              (S1_pla1_xgmii_txd       ),  /////  待发送XGMII数据       
.I_xgmii_txc              (S1_pla1_xgmii_txc       ),  /////  待发送XGMII控制       
.I_xgmii_pla_num          (S1_pla1_xgmii_num       ),  /////  待发送XGMII所需PLA组号
.I_pla_para_fifo_rd       (S_pla1_param_fifo_rden  ),  /////  整流模块发起 
.O_param_ff_full          (S_pla1_param_ff_full    ),
.O_pla_para_fifo_rdata    (S_pla1_para_fifo_rdata  ),
.O_param_ff_empty         (S_pla1_param_ff_empty   ),
.O_pla_para_err_stat      (O_pla1_para_err_stat    ),
.O_xgmii_delayed_q        (S_pla1_xgmii_delayed_q  )                                 
);


pla_forward_flow_parameter U013_pla_for_flow_parameter_delay     ///过滤非三组的数据
(                   
.I_pla_312m5_clk          (I_pla_312m5_clk         ),  /////  时钟                  
.I_pla_rst                (S2_pla2_flow_rst        ),  /////  复位  
.I_cnt_clear              (I_cnt_clear             ),                  
.I_pla_tc_en              (I_pla2_tc_en            ),  /////  组1 PLA TC使能               
.I_xgmii_txd              (S1_pla2_xgmii_txd       ),  /////  待发送XGMII数据       
.I_xgmii_txc              (S1_pla2_xgmii_txc       ),  /////  待发送XGMII控制       
.I_xgmii_pla_num          (S1_pla2_xgmii_num       ),  /////  待发送XGMII所需PLA组号
.I_pla_para_fifo_rd       (S_pla2_param_fifo_rden  ),  /////  整流模块发起 
.O_param_ff_full          (S_pla2_param_ff_full    ),
.O_pla_para_fifo_rdata    (S_pla2_para_fifo_rdata  ),
.O_param_ff_empty         (S_pla2_param_ff_empty   ),
.O_pla_para_err_stat      (O_pla2_para_err_stat    ),
.O_xgmii_delayed_q        (S_pla2_xgmii_delayed_q  )                                 
);



always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
        O_flow_ff_para_full_cnt[15:0]  <= 16'd0;
    else if (I_cnt_clear)
        O_flow_ff_para_full_cnt[15:0]  <= 16'd0;
    else if(S_pla0_param_ff_full)
        O_flow_ff_para_full_cnt[15:0]  <= O_flow_ff_para_full_cnt[15:0]  + 16'd1;
end


always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
        O_flow_ff_para_full_cnt[31:16]  <= 16'd0;
    else if (I_cnt_clear)
        O_flow_ff_para_full_cnt[31:16]  <= 16'd0;
    else if(S_pla1_param_ff_full)
        O_flow_ff_para_full_cnt[31:16]  <= O_flow_ff_para_full_cnt[31:16] + 16'd1;
end


always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
        O_flow_ff_para_full_cnt[47:32] <= 16'd0;
    else if (I_cnt_clear)
        O_flow_ff_para_full_cnt[47:32] <= 16'd0;
    else if(S_pla2_param_ff_full)
        O_flow_ff_para_full_cnt[47:32] <= O_flow_ff_para_full_cnt[47:32] + 16'd1;
end



always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
        O_pla_air_unlink_cnt[15:0] <= 16'd0;
    else if (I_cnt_clear)
        O_pla_air_unlink_cnt[15:0] <= 16'd0;
    else if(S_pla0_unlink_flag)
        O_pla_air_unlink_cnt[15:0]  <= O_pla_air_unlink_cnt[15:0]  + 16'd1;
end


always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
        O_pla_air_unlink_cnt[31:16]  <= 16'd0;
    else if (I_cnt_clear)
        O_pla_air_unlink_cnt[31:16]  <= 16'd0;
    else if(S_pla1_unlink_flag)
        O_pla_air_unlink_cnt[31:16]  <= O_pla_air_unlink_cnt[31:16] + 16'd1;
end


always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
        O_pla_air_unlink_cnt[47:32] <= 16'd0;
    else if (I_cnt_clear)
        O_pla_air_unlink_cnt[47:32] <= 16'd0;
    else if(S_pla2_unlink_flag)
        O_pla_air_unlink_cnt[47:32] <= O_pla_air_unlink_cnt[47:32] + 16'd1;
end




always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
        S1_pla0_xgmii_delayed_q <= 36'hfffffffff;
    else
        S1_pla0_xgmii_delayed_q <= S_pla0_xgmii_delayed_q[35:0] ;
end

always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
        S1_pla1_xgmii_delayed_q <= 36'hfffffffff;
    else
        S1_pla1_xgmii_delayed_q <= S_pla1_xgmii_delayed_q[35:0] ;
end

always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
        S1_pla2_xgmii_delayed_q <= 36'hfffffffff;
    else
        S1_pla2_xgmii_delayed_q <= S_pla2_xgmii_delayed_q[35:0] ;
end


pla0_forward_flow_fifo_one U031_pla_forward_flow_fifo_one( 
.I_pla_312m5_clk          (I_pla_312m5_clk              ),
.I_pla_rst                (S2_pla0_flow_rst             ),
.I_flow_fifo_rden         (I_flow_fifo_rden[0]          ),
.I_pla_unlink_flag        (S_pla0_unlink_flag           ),
.I_pla_for_en             (I_pla_for_en[0]              ),
.I_cnt_clear              (I_cnt_clear                  ),
.I_delay_fifo_data        (S1_pla0_xgmii_delayed_q      ),
.I_param_fifo_rdata       (S_pla0_para_fifo_rdata       ),
.O_param_fifo_rd_en       (S_pla0_param_fifo_rden       ),
.O_flow_fifo_next_rdata   (O_flow_fifo0_next_rdata      ),
.O_flow_fifo_rdata        (O_flow_fifo0_rdata           ),
.I_flow_fifo_pause_set    (I_flow_fifo_pause_set        ),     
.I_flow_fifo_resume_set   (I_flow_fifo_resume_set       ),      
.O_flow_fifo_level        (O_flow_ff0_level             ),     
.O_flow_fifo_pause_flg    (O_pla_for_ff_pause[0]        ),
.O_flow_fifo_empty        (O_flow_fifo_empty[0]         ),
.O_flow_para_err_flag     (S_flow_para_err_flag[0]      ),
.O_flow_fifo_frame_stat   (O_flow_ff0_frame_stat        ),
.O_flow_fifo_err_stat     (O_flow_ff0_err_stat[47:32]   )
);


pla_forward_flow_fifo_one U032_pla_forward_flow_fifo_one(
.I_pla_312m5_clk          (I_pla_312m5_clk              ),
.I_pla_rst                (S2_pla1_flow_rst         ),
.I_flow_fifo_rden         (I_flow_fifo_rden[1]          ),
.I_pla_unlink_flag        (S_pla1_unlink_flag           ),
.I_pla_for_en             (I_pla_for_en[1]              ),
.I_cnt_clear              (I_cnt_clear                  ),
.I_delay_fifo_data        (S1_pla1_xgmii_delayed_q      ),
.I_param_fifo_rdata       (S_pla1_para_fifo_rdata       ),
.O_param_fifo_rd_en       (S_pla1_param_fifo_rden       ),
.O_flow_fifo_next_rdata   (O_flow_fifo1_next_rdata      ),
.O_flow_fifo_rdata        (O_flow_fifo1_rdata           ),
.I_flow_fifo_pause_set    (I_flow_fifo_pause_set        ),     
.I_flow_fifo_resume_set   (I_flow_fifo_resume_set       ),      
.O_flow_fifo_level        (O_flow_ff1_level             ),     
.O_flow_fifo_pause_flg    (O_pla_for_ff_pause[1]        ),
.O_flow_fifo_empty        (O_flow_fifo_empty[1]         ),
.O_flow_para_err_flag     (S_flow_para_err_flag[1]      ),
.O_flow_fifo_frame_stat   (O_flow_ff1_frame_stat        ),
.O_flow_fifo_err_stat     (O_flow_ff1_err_stat[47:32]   )
);

pla_forward_flow_fifo_one U033_pla_forward_flow_fifo_one(
.I_pla_312m5_clk          (I_pla_312m5_clk              ),
.I_pla_rst                (S2_pla2_flow_rst         ),
.I_pla_unlink_flag        (S_pla2_unlink_flag           ),
.I_pla_for_en             (I_pla_for_en[2]              ),
.I_flow_fifo_rden         (I_flow_fifo_rden[2]          ),
.I_cnt_clear              (I_cnt_clear                  ),
.I_delay_fifo_data        (S1_pla2_xgmii_delayed_q      ),
.I_param_fifo_rdata       (S_pla2_para_fifo_rdata       ),
.O_param_fifo_rd_en       (S_pla2_param_fifo_rden       ),
.O_flow_fifo_next_rdata   (O_flow_fifo2_next_rdata      ),
.O_flow_fifo_rdata        (O_flow_fifo2_rdata           ),
.I_flow_fifo_pause_set    (I_flow_fifo_pause_set        ),     
.I_flow_fifo_resume_set   (I_flow_fifo_resume_set       ),      
.O_flow_fifo_level        (O_flow_ff2_level             ),     
.O_flow_fifo_pause_flg    (O_pla_for_ff_pause[2]        ),
.O_flow_fifo_empty        (O_flow_fifo_empty[2]         ),
.O_flow_para_err_flag     (S_flow_para_err_flag[2]      ),
.O_flow_fifo_frame_stat   (O_flow_ff2_frame_stat        ),
.O_flow_fifo_err_stat     (O_flow_ff2_err_stat[47:32]   )
);


pla_for_crc_chk U041_for_crc_check (
 .I_pla_rst    	         (I_pla_rst               ),  
 .I_pla_312m5_clk	       (I_pla_312m5_clk         ),
 .I_cnt_clear            (I_cnt_clear             ), 
 .I_xgmii_data           (S_pla0_xgmii_txd        ),   
 .I_xgmii_txc            (S_pla0_xgmii_txc        ),
 .O_crc_err_reg          (S_pla0_crc_err          ),
 .O_crc_ok_cnt           (O_pla0_forin_crcok_cnt  ),
 .O_crc_err_cnt          (O_pla0_forin_crcerr_cnt )    
); 

pla_for_crc_chk U042_for_crc_check (
 .I_pla_rst    	         (I_pla_rst               ),  
 .I_pla_312m5_clk	       (I_pla_312m5_clk         ),
 .I_cnt_clear            (I_cnt_clear             ), 
 .I_xgmii_data           (S_pla1_xgmii_txd        ),   
 .I_xgmii_txc            (S_pla1_xgmii_txc        ),
 .O_crc_err_reg          (S_pla1_crc_err          ),
 .O_crc_ok_cnt           (O_pla1_forin_crcok_cnt  ),
 .O_crc_err_cnt          (O_pla1_forin_crcerr_cnt )    
); 


pla_for_crc_chk U043_for_crc_check (
 .I_pla_rst    	         (I_pla_rst               ),  
 .I_pla_312m5_clk	       (I_pla_312m5_clk         ),
 .I_cnt_clear            (I_cnt_clear             ), 
 .I_xgmii_data           (S_pla2_xgmii_txd        ),   
 .I_xgmii_txc            (S_pla2_xgmii_txc        ),
 .O_crc_err_reg          (S_pla2_crc_err          ),
 .O_crc_ok_cnt           (O_pla2_forin_crcok_cnt  ),
 .O_crc_err_cnt          (O_pla2_forin_crcerr_cnt )    
); 


endmodule
