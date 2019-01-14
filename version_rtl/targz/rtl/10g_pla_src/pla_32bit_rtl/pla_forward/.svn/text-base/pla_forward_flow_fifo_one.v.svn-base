//FILE_HEADER-----------------------------------------------------------------
//ZTE  Copyright (C)
//ZTE Company Confidential
//----------------------------------------------------------------------------
//Project Name : rcua_top
//FILE NAME    : pla_forward_flow_parameter.v
//AUTHOR       : xXX xxx                        
//Department   : Tianjin Development Department 
//Email        : sxxxx.xxx@zte.com.cn    
//----------------------------------------------------------------------------
//Module Hiberarchy :
//x                                |----Ui_dpram_32768x34_xilinx 
//x                                |----
//x  pla_forward_flow_fifo_one  ---|----
//----------------------------------------------------------------------------
//Relaese History :
//----------------------------------------------------------------------------
//Version         Date           Author        Description
// 1.0            2012-08-17     Sai Bin       New Generate
//----------------------------------------------------------------------------
//Main Function:提取XGMII报文参数，包含，HC标志，PTP标志，帧长、奇偶标志。
//----------------------------------------------------------------------------
//REUSE ISSUES: empty
//Reset Strategy: empty
//Clock Strategy: empty
//Critical Timing: empty
//Asynchronous Interface: empty
//END_HEADER------------------------------------------------------------------

`timescale 1ns/1ns

module pla_forward_flow_fifo_one
(                   
    input                I_pla_312m5_clk               ,  /////  时钟                  
    input                I_pla_rst                     ,  /////  复位         
    input                I_cnt_clear                   ,   ////                 
    input                I_pla_unlink_flag             ,        
    input                I_pla_for_en                  ,                   
    input                I_flow_fifo_rden              ,  /////  组1PLA流FIFO读取使能  SLICE模块输出 
    input        [35:0]  I_delay_fifo_data             ,  
    input        [31:0]  I_param_fifo_rdata            ,          
    output  reg          O_param_fifo_rd_en            , 
        
    output       [33:0]  O_flow_fifo_next_rdata       ,  /////  组1PLA流FIFO下个数据  
    output  reg  [33:0]  O_flow_fifo_rdata            ,  /////  组1PLA流FIFO当前数据  
    
    input        [15:0]  I_flow_fifo_pause_set         ,  /////  流FIFO Pause交换水位,上限     
    input        [15:0]  I_flow_fifo_resume_set        ,  /////  流FIFO解Pause交换水位,下限     
    output  reg          O_flow_fifo_pause_flg         ,  /////  组1PLA对应子端口Pause 
    output  reg          O_flow_fifo_empty             ,
    output  reg          O_flow_para_err_flag          ,
    
    output       [15:0]  O_flow_fifo_level             ,
    output  reg  [47:0]  O_flow_fifo_frame_stat  =48'd0      ,
    output  reg  [15:0]  O_flow_fifo_err_stat    =16'd0               
                        
);

reg [35:0]    S_ram_dout_buf0          ;
reg [35:0]    S_ram_dout_buf1          ;
reg [35:0]    S_ram_dout_buf2          ;
reg [35:0]    S_ram_dout_buf3          ;
reg [35:0]    S_ram_dout_buf4          ;
reg [35:0]    S_ram_dout_buf5          ;

reg           S_flow_data_valid        ;
reg           S1_flow_data_valid       ;
reg           S2_flow_data_valid       ;
reg           S3_flow_data_valid       ;

reg [12:0]    S_flow_fifo_wr_cnt       ;

reg [6:0]    S_slice_rd_cnt           ;

wire          S_hc_pkt_flag_ff         ;
wire          S_ptp_header_ff          ;   ///ptp帧头指示
reg           S1_ptp_header_ff         ; 
wire          S_pkt_pf_ff              ;   ///EVEN FLAG奇偶位                      
wire[12:0]    S_data_length_ff         ;   ///MAC包数据长度计数器 
reg [12:0]    S1_data_length_ff        ;   ///MAC包数据长度计数器 


reg           S_inversion_flag         ;
reg           S_fifo_wren              ;
reg [33:0]    S1_flow_fifo_wdata       ; 
reg [33:0]    S2_flow_fifo_wdata       ; 
reg [33:0]    S3_flow_fifo_wdata       ; 

reg           S_flow_fifo_wren         ;
reg[14:0]     S_flow_fifo_raddr        ;
reg[14:0]     S_flow_fifo_waddr        ;
reg[14:0]     S_fifo_usedw_buf         ;

reg [5:0]     S_flow_fifo_rden         ;
reg [14:0]    S_fifo_addr_sub          ;

reg[14:0]     S_flow_end_raddr        ;
reg           S_flow_empty_flag;
reg           S_flow_full_err_debug            ;  ///如下可能导致时序不过 


reg           S_flow_empty1_delay;
reg           S_flow_fifo_pause_flg;

reg   [33:0]  S1_flow_fifo_rdata            ; 

reg           S_para_err_flag;
reg [7:0]     S_para_err_cnt;

reg S_para_err_rd ;

always @ (posedge I_pla_312m5_clk)
begin
   S1_flow_fifo_rdata      <= O_flow_fifo_rdata       ;
end

always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst) 
    begin
        S_para_err_flag <= 1'd0;
        S_para_err_rd <= 1'b0;
    end
    else if(O_param_fifo_rd_en) ///支持两个帧间隔
    begin
        S_para_err_rd <= 1'b1;
        if (I_param_fifo_rdata[31:24] != S_ram_dout_buf1[7:0])  ///结尾处遇到PTP首
        begin
           S_para_err_flag <= 1'd1;
        end
        else
        begin       
           S_para_err_flag <= 1'd0;
        end
    end
    else
    begin
        S_para_err_rd <= 1'b0;
        S_para_err_flag <= 1'd0;
    end
end


always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst) 
    begin
        S_flow_end_raddr <= 15'd0;
    end
    else if(S_slice_rd_cnt == 7'd63)
    begin
        if (O_flow_fifo_rdata[33:31] == 3'h7)  ///结尾处遇到PTP首 3f
        begin
           S_flow_end_raddr <= S_flow_fifo_raddr - 15'd3;
        end
        else if (O_flow_fifo_next_rdata[33:31] == 3'h7) ///结尾处遇到 PTP 首  3F
        begin      
           S_flow_end_raddr <= S_flow_fifo_raddr - 15'd2;
        end
        else if (O_flow_fifo_next_rdata[33:31] == 3'h6) ///结尾处遇到 PTP 尾  30
        begin      
           S_flow_end_raddr <= S_flow_fifo_raddr - 15'd1;
        end
        else if (O_flow_fifo_rdata[33:31] == 3'h6 || S1_flow_fifo_rdata[33:31] == 3'h6) ///结尾处遇到 PTP 尾  30
        begin      
           S_flow_end_raddr <= S_flow_end_raddr;  ///63遇到ptp尾
        end
        else
        begin       
           S_flow_end_raddr <= S_flow_fifo_raddr;
        end
    end
    else if(S_slice_rd_cnt == 7'd64)
    begin
        if (O_flow_fifo_next_rdata[33:31] == 3'h7) ///结尾处遇到 PTP 首  3F
        begin      
           S_flow_end_raddr <= S_flow_fifo_raddr - 15'd2;
        end
        end
    else if (O_flow_fifo_next_rdata[33:31] == 3'h6) ///结尾处遇到 PTP 尾  30
        begin      
           S_flow_end_raddr <= S_flow_fifo_raddr - 15'd1;
    end
    else
    begin
        S_flow_end_raddr <= S_flow_end_raddr;
    end
end


always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst) 
        S_flow_empty1_delay <= 1'd0;
    else if(!I_flow_fifo_rden && S_flow_fifo_rden[0] && O_flow_fifo_empty)
        S_flow_empty1_delay <= 1'b1;
    else if(S_flow_fifo_rden[4] && !S_flow_fifo_rden[3])
        S_flow_empty1_delay <= 1'b0;
end


assign  {S_hc_pkt_flag_ff,S_pkt_pf_ff,S_ptp_header_ff,S_data_length_ff} = I_param_fifo_rdata[15:0];

///MAC包参数缓存FIFO读使能   要判断prembol满足条件
always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst) 
        O_param_fifo_rd_en <= 1'b0;
    else if(S_ram_dout_buf0[33] && (!I_delay_fifo_data[33]) && (I_delay_fifo_data[15:0] == 16'h55d5) )
        O_param_fifo_rd_en <= 1'b1;
    else 
        O_param_fifo_rd_en <= 1'b0;
end


///RAM输出数据打拍
always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
    begin 
        S_ram_dout_buf0 <= 36'hf07070707;
        S_ram_dout_buf1 <= 36'hf07070707;
        S_ram_dout_buf2 <= 36'hf07070707;
        S_ram_dout_buf3 <= 36'hf07070707;
        S_ram_dout_buf4 <= 36'hf07070707;
        S_ram_dout_buf5 <= 36'hf07070707;
        S1_data_length_ff <= 13'h0;
        S1_ptp_header_ff <= 1'd0; 
    end
    else
    begin
        S_ram_dout_buf0 <= I_delay_fifo_data;
        S_ram_dout_buf1 <= S_ram_dout_buf0;
        S_ram_dout_buf2 <= S_ram_dout_buf1;
        S_ram_dout_buf3 <= S_ram_dout_buf2;
        S_ram_dout_buf4 <= S_ram_dout_buf3;
        S_ram_dout_buf5 <= S_ram_dout_buf4;
        S1_data_length_ff <= S_data_length_ff;
        S1_ptp_header_ff <= S_ptp_header_ff;
        
    end
end

///流FIFO写使能产生\
always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst) 
        S_flow_data_valid <= 1'b0; 
    else if(S_ram_dout_buf3[33] && (!S_ram_dout_buf2[33]) && (S_ram_dout_buf2[15:0] == 16'h55d5))
        S_flow_data_valid <= 1'b1;   
    else if(S_flow_fifo_wr_cnt >= {S_data_length_ff + 13'd1}) 
        S_flow_data_valid <= 1'b0;
    else    
        S_flow_data_valid <= S_flow_data_valid;  
end

///写入流FIFO的MAC包数据计数，以字（16bits）为单位
always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst) 
        S_flow_fifo_wr_cnt <= 13'h0;
    else
    begin
        if(S_ram_dout_buf3[33] && (!S_ram_dout_buf2[33]) && (S_ram_dout_buf2[15:0] == 16'h55d5))
            S_flow_fifo_wr_cnt <= 13'h0;
        else if(S_flow_data_valid) 
            S_flow_fifo_wr_cnt <= S_flow_fifo_wr_cnt + 13'h2;
        else
            S_flow_fifo_wr_cnt <= S_flow_fifo_wr_cnt;
    end
end

///流FIFO写使能打1拍
always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
    begin 
        S1_flow_data_valid <= 1'b0;
        S2_flow_data_valid <= 1'b0;
        S3_flow_data_valid <= 1'b0;
    end
    else
    begin
        S1_flow_data_valid <= S_flow_data_valid;
        S2_flow_data_valid <= S1_flow_data_valid;
        S3_flow_data_valid <= S2_flow_data_valid; 
    end
end


///---------------------------------------------------
///各个FIFO的数据颠倒标志
///---------------------------------------------------
always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst) 
        S_inversion_flag <= 1'b0;
    else if(S2_flow_data_valid && !S1_flow_data_valid) //结尾处判断
    begin
        if (S_ptp_header_ff)
            S_inversion_flag <= 1'b0;
        else
        begin
            if (!S_data_length_ff[0]) 
                S_inversion_flag <= ~ S_inversion_flag; 
            else 
                S_inversion_flag <= S_inversion_flag;
        end          
    end 
    else if(!S2_flow_data_valid && S1_flow_data_valid && S_ptp_header_ff) //开头出判断是否PTP     
        S_inversion_flag <= 1'b0;
    ///else if(O_flow_fifo_empty && !S_flow_fifo_wren && S_flow_fifo_rden[3] && !S_flow_fifo_rden[2])///空的时候  GDP
    else if(O_flow_fifo_empty && !(S1_flow_data_valid||S_flow_fifo_wren) && S_flow_fifo_rden[3] && !S_flow_fifo_rden[2])///空的时候  GDP  
        S_inversion_flag <= 1'b0; 
    else if(!(S1_flow_data_valid||S_flow_fifo_wren) && S_fifo_addr_sub <= 15'd10 )///不写的时候，发现FIFO快空，此时翻转,未避免读空的时候把55D5读出来。
        S_inversion_flag <= 1'b0;     
    else     
        S_inversion_flag <= S_inversion_flag;      
end


///*********************************************************************
///写入流FIFO的数据 前面数据为偶数,无逆序的处理
///*********************************************************************  
///   always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
///   begin
///       if (I_pla_rst) 
///           St_flow_fifo_wdata <= 34'b0;
///       else
///       begin    
///           if(S_flow_data_valid && (!S1_flow_data_valid) && S_ptp_header_ff)
///               St_flow_fifo_wdata <= 34'h3ffffffff;
///           else if(S1_flow_data_valid && (!S2_flow_data_valid))
///               St_flow_fifo_wdata <= {2'b0,16'h55d5,I_param_fifo_rdata[15:0]};
///           else if(S2_flow_data_valid && (!S1_flow_data_valid) && S_ptp_header_ff)
///               St_flow_fifo_wdata <= 34'h300000000;   ///结尾
///           else if(S1_flow_data_valid) 
///               St_flow_fifo_wdata <= {2'b0,S_ram_dout_buf4[31:0]}; 
///           else 
///               St_flow_fifo_wdata <= {2'h1,St_flow_fifo_wdata[31:0]}; 
///       end                     
///   end
///   
///   
///   ///St_fifo_wren 和 St1_flow_fifo_wdata 数据对齐
///   always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
///   begin
///       if (I_pla_rst) 
///       begin
///           St_fifo_wren <= 1'b0;
///           St1_flow_fifo_wdata <= 34'b0;
///       end    
///       else
///       begin
///           St1_flow_fifo_wdata <= St_flow_fifo_wdata;   
///           if(S_ptp_header_ff|S1_ptp_header_ff)  ///添加3FFFFFFF和3000000数据的写使能
///               St_fifo_wren <= S3_flow_data_valid | S2_flow_data_valid | S1_flow_data_valid;
///           else 
///               St_fifo_wren <= S2_flow_data_valid;
///       end   
///   end

///*********************************************************************
///写入流FIFO的数据 前面数据为偶数,逆序的处理
///*********************************************************************  
always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst) 
    begin
        S1_flow_fifo_wdata <= 34'b0;
    end    
    else 
    begin
        if(S_ptp_header_ff)   ///PTP     
        begin   
            if(S_flow_data_valid && (!S1_flow_data_valid) && S_ptp_header_ff)
                S1_flow_fifo_wdata <= 34'h3ffffffff;
            else if(S1_flow_data_valid && (!S2_flow_data_valid))
                S1_flow_fifo_wdata <= {2'd0,16'h55d5,I_param_fifo_rdata[15:0]};
            else if(S2_flow_data_valid && (!S1_flow_data_valid) && S_ptp_header_ff)
                S1_flow_fifo_wdata <= 34'h300000000;   ///结尾
            else if(S1_flow_data_valid) 
                S1_flow_fifo_wdata <=  {2'b0,S_ram_dout_buf4[31:0]}; 
            else 
                S1_flow_fifo_wdata <= {2'h1,S1_flow_fifo_wdata[31:0]};   
        end     
        else if(!S_inversion_flag)   ///正序         
        begin   
            if(S1_flow_data_valid && (!S2_flow_data_valid))
                S1_flow_fifo_wdata <= {2'd2,16'h55d5,I_param_fifo_rdata[15:0]};
            else if(S1_flow_data_valid) 
                S1_flow_fifo_wdata <=  {2'b0,S_ram_dout_buf4[31:0]}; 
            else 
                S1_flow_fifo_wdata <= {2'h1,S1_flow_fifo_wdata[31:0]};   
        end 
        else                         ///逆序   
        begin
            if(S1_flow_data_valid && (!S2_flow_data_valid))
                S1_flow_fifo_wdata <= {2'b1,S1_flow_fifo_wdata[31:16],16'h55d5};   
            else if (S2_flow_data_valid && !S3_flow_data_valid)
                S1_flow_fifo_wdata <= {2'b0,I_param_fifo_rdata[15:0],S_ram_dout_buf4[31:16]}; 
            else if(S1_flow_data_valid ||(S2_flow_data_valid && S_data_length_ff[0])) ///奇数偶数长度差别
                S1_flow_fifo_wdata <= {2'b0,S_ram_dout_buf5[15:0],S_ram_dout_buf4[31:16]};   
            else 
                S1_flow_fifo_wdata <= {2'h1,S1_flow_fifo_wdata[31:0]} ;    
        end 
   end              
end
 
///S_fifo_wren 和 S2_flow_fifo_wdata 数据对齐
always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst) 
    begin
        S_fifo_wren <= 1'b0;
        S2_flow_fifo_wdata <= 34'b0;
        S3_flow_fifo_wdata <= 34'b0;
    end    
    else
    begin
        S2_flow_fifo_wdata <= S1_flow_fifo_wdata;    
        
        if(!S_fifo_wren && S_flow_empty_flag)  ///特殊处理,没有写指示时,利用读写的空闲期,遇到FIFO空,将fifo深度补充到3.防止读写冲突
        begin
            S3_flow_fifo_wdata <= 34'b0;
        end
        else
        begin
            S3_flow_fifo_wdata <= S2_flow_fifo_wdata;  
        end    
        if(S_ptp_header_ff|S1_ptp_header_ff)  ///添加3FFFFFFF和3000000数据的写使能
            S_fifo_wren <= S3_flow_data_valid | S2_flow_data_valid | S1_flow_data_valid;
        else if(S1_data_length_ff[0] && S_inversion_flag)     ///偶数包长且逆序
            S_fifo_wren <= S3_flow_data_valid | S2_flow_data_valid;
        else 
            S_fifo_wren <= S2_flow_data_valid;    
    end   
end


///---------------------------------------------------
///各个FIFO的写数据和写地址,写使能,地址需要根据帧头看看是否覆盖？？？？？？
///另外还要判断一下是否上一帧和本帧是否在同一个组内
///---------------------------------------------------
always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
    begin
        S_flow_fifo_wren  <= 1'h0 ;
        S_flow_fifo_waddr <= 15'd0;
    end    
    else 
    begin
        if(S_fifo_wren)
        begin
            S_flow_fifo_wren  <= S_fifo_wren ;
            if (!S_flow_fifo_wren && S_inversion_flag && !O_flow_fifo_empty)
         ////   if (!S_flow_fifo_wren && S_inversion_flag )
                S_flow_fifo_waddr <= S_flow_fifo_waddr ;
            else if (S_fifo_usedw_buf < 15'h7fe0)   ///当水位满的时候,停止写入 
                S_flow_fifo_waddr <= S_flow_fifo_waddr + 15'd1;
            else    ///当水位满的时候,丢掉一半数据 
                S_flow_fifo_waddr <= S_flow_fifo_raddr + 15'h1000;   ///1000 BUFF深度 ,仍旧不影响PAUSE帧
        end
        else if(S_flow_empty_flag)   ///特殊处理,没有写指示是，遇到FIFO空，将fifo深度补充到3.
        begin
            S_flow_fifo_wren  <= 1'h1 ;
            S_flow_fifo_waddr <= S_flow_fifo_waddr + 15'd1;
        end
        else 
        begin
            S_flow_fifo_wren  <= 1'h0 ;
            S_flow_fifo_waddr <= S_flow_fifo_waddr;
        end 
    end       
end
///---------------------------------------------------
///DPRAM  S_flow_fifo_wren和 S3_flow_fifo_wdata 对齐
///---------------------------------------------------
blk_com_dpram_32768x34  Ui_dpram_32768x34_xilinx
////blk_com_dpram_16383x34_k7  Ui_dpram_32768x34_xilinx
(
	.clka  (I_pla_312m5_clk          ),
	.ena   (S_flow_fifo_wren         ),   
	.wea   (1'b1                     ),   
	.addra (S_flow_fifo_waddr        ),
  .dina  (S3_flow_fifo_wdata       ),
  .clkb  (I_pla_312m5_clk          ),
	.rstb  (I_pla_rst                ),
	.enb   (1'b1                     ),////        I_flow_fifo_rden       
	.addrb (S_flow_fifo_raddr        ),
	.doutb (O_flow_fifo_next_rdata   )
);
///---------------------------------------------------
///读地址
///---------------------------------------------------

reg S_Xflag ;
reg S_X1flag ;

always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
    begin
        S_flow_fifo_rden  <= 6'b0; 
        O_flow_fifo_rdata <= 34'd0;
    end    
    else 
    begin
        S_flow_fifo_rden  <= {S_flow_fifo_rden[4:0],I_flow_fifo_rden};
        if(S_flow_fifo_rden[1])
        begin
            O_flow_fifo_rdata <= O_flow_fifo_next_rdata;
        end
    end
end        

always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
    begin
        S_flow_fifo_raddr <= 15'd1;
        S_Xflag <= 1'b0;
        S_X1flag<= 1'b0;
    end    
    else 
    begin
        if (I_flow_fifo_rden)
        begin 
            if (S_flow_fifo_raddr == S_flow_fifo_waddr)  ///读空的条件
            begin
                S_flow_fifo_raddr <= S_flow_fifo_raddr;
            end    
            else
            begin
                S_flow_fifo_raddr <= S_flow_fifo_raddr + 15'd1;
            end              
            S_Xflag <= 1'b0;
            S_X1flag<= 1'b0;
        end 
        else if(S_flow_fifo_rden[3] && !S_flow_fifo_rden[2])
        begin
            if (S_slice_rd_cnt >= 7'd64)//正常个数遇到空。 ///7'd67
            begin
                S_flow_fifo_raddr <= S_flow_end_raddr;     ///  S_flow_fifo_raddr <= S_flow_fifo_raddr - 15'd3;    //// ///
                if  (O_flow_fifo_next_rdata[33:32] == 2'b01)
                begin
                    S_X1flag <= 1'b1;
                end    
            end
            else if (S_flow_empty1_delay)  ///空的指针回退
            begin
                if (O_flow_fifo_next_rdata[33:32] == 2'b01) ///仍然有下一帧进来,低位为55D5
                begin
                    S_flow_fifo_raddr <= S_flow_fifo_raddr; 
                    S_Xflag <= 1'b1;
                end    
                else  ///切片结束
                begin    
                    S_flow_fifo_raddr <= S_flow_fifo_raddr + 15'd1;
                end    
            end 
            else ///非空的指针回退 (!S_flow_empty1_delay )
            begin    
                S_flow_fifo_raddr <= S_flow_fifo_raddr - 15'd3; 
            end
        end
        else 
        begin
            S_flow_fifo_raddr <= S_flow_fifo_raddr ;      
            S_Xflag <= 1'b0;
            S_X1flag<= 1'b0; 
        end
    end       
end


always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
    begin
        S_slice_rd_cnt <= 7'd0; 
    end    
    else 
    begin  
        if(S_flow_fifo_rden[0])  
        begin
            S_slice_rd_cnt <= S_slice_rd_cnt + 7'd1;
        end
        else if (!S_flow_fifo_rden[0] && I_flow_fifo_rden )
        begin   
            S_slice_rd_cnt <= 7'd0;
        end   
    end
end    



always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
    begin
        O_flow_fifo_empty <= 1'b1;
        S_fifo_addr_sub <= 15'h7fff; 
    end    
    else 
    begin  
        S_fifo_addr_sub <= S_flow_fifo_waddr - S_flow_fifo_raddr;
        
        if (S_flow_fifo_rden[4:0] == 5'd0 && !I_flow_fifo_rden)  ///读结束末尾验证
        begin
            if(S_fifo_addr_sub == 15'h7fff)  ////
            begin
                 O_flow_fifo_empty <= 1'b1;   
            end     
            else
            begin
                 O_flow_fifo_empty <= 1'b0;
            end   
        end
        else
        begin
            if((S_fifo_addr_sub <= 15'd3) || (S_fifo_addr_sub >= 15'h7ff3))  ////读空的条件  (S_fifo_addr_sub >= 15'h7ff3)不成立,在sub=7FE0的时候已经停止写入  
            begin
                O_flow_fifo_empty <= 1'b1;
            end
            else
            begin
                O_flow_fifo_empty <= 1'b0;
            end   
        end   
    end
end       


/// S_fifo_addr_sub == 3 ,可以处理

always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
    begin
        S_flow_empty_flag <= 1'b0;
    end    
    else 
    begin  
        if (S_flow_fifo_rden[4:0] == 5'd0 && !I_flow_fifo_rden)  ///读结束末尾验证
       //// if (S_flow_fifo_rden[5] && !S_flow_fifo_rden[4] ) ///读结束末尾验证
        begin
            if( S_fifo_addr_sub <= 15'd3)  ////读空的条件  (S_fifo_addr_sub >= 15'h7ff3)不成立,在sub=7FE0的时候已经停止写入  
            begin
                S_flow_empty_flag <= 1'b1;
            end     
            else
            begin
                S_flow_empty_flag <= 1'b0;
            end   
        end
        else if (S_fifo_addr_sub >= 15'd4) 
        begin
            S_flow_empty_flag <= 1'b0;
        end 
    end
end  

///---------------------------------------------------
///水位判断
///---------------------------------------------------


always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)  ////判定预计有点问题
begin
    if (I_pla_rst)
	  begin
        S_fifo_usedw_buf <= 15'h0 ;//16x16384
	  end
    else
    begin
        if(S_fifo_addr_sub >= 15'h7ffd)
            S_fifo_usedw_buf <= S_fifo_usedw_buf;  
        else 
            S_fifo_usedw_buf <= S_fifo_addr_sub; 
    end        
end


assign O_flow_fifo_level = {1'b0,S_fifo_usedw_buf};

always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
        S_flow_fifo_pause_flg <= 1'h0 ;
    else if(S_fifo_usedw_buf  >= I_flow_fifo_pause_set[14:0] )
        S_flow_fifo_pause_flg <= 1'h1 ;
    else if(S_fifo_usedw_buf  < I_flow_fifo_resume_set[14:0] )
        S_flow_fifo_pause_flg <= 1'h0 ;    
    else  
        S_flow_fifo_pause_flg <= S_flow_fifo_pause_flg ;
end


always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
        O_flow_fifo_pause_flg <= 1'h0 ;
    else if(I_pla_unlink_flag ||(!I_pla_for_en))  ///空口不ling停止发送PAUSE
        O_flow_fifo_pause_flg <= 1'h0 ;
    else   
        O_flow_fifo_pause_flg <= S_flow_fifo_pause_flg ; 
end


always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)  ////判定满的次数
begin
    if (I_pla_rst)
	  begin
        S_flow_full_err_debug <= 1'b0;
	  end
	  else if (I_cnt_clear)
	  begin
	      S_flow_full_err_debug <= 1'b0;
	  end
    else
    begin
        if (S_fifo_usedw_buf >= 15'h7fe0 && S_fifo_wren) ////h7fe0
        begin
            S_flow_full_err_debug <= 1'b1;
        end        
        else 
        begin
            S_flow_full_err_debug <= 1'b0;
        end    
    end        
end


always@(posedge I_pla_312m5_clk)  ////判定满的次数
begin
	  if (I_cnt_clear)
	  begin
	      O_flow_fifo_err_stat[7:0] <= 8'b0;
	  end
    else if(S_flow_full_err_debug)
    begin
        O_flow_fifo_err_stat[7:0] <= O_flow_fifo_err_stat[7:0] + 8'd1;  
    end        
end


always@(posedge I_pla_312m5_clk)  ////判定满的次数
begin
	  if (I_cnt_clear)
	  begin
	      O_flow_fifo_err_stat[15:8] <= 8'b0;
	  end
    else if(S_para_err_flag)
    begin
        O_flow_fifo_err_stat[15:8] <= O_flow_fifo_err_stat[15:8] + 8'd1;  
    end        
end


always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)  ////判定满的次数
begin
    if (I_pla_rst)
	  begin
	      S_para_err_cnt <= 8'b0;
	  end
    else if(S_para_err_flag)
    begin
        S_para_err_cnt <= S_para_err_cnt + 8'd1;  
    end        
end

///延时多拍。
always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)  ////判定满的次数
begin
    if (I_pla_rst)
	  begin
        O_flow_para_err_flag <= 1'b0;
	  end
    else if(S_para_err_flag && S_para_err_cnt == 8'h20)
    begin
        O_flow_para_err_flag <= 1'b1;
    end
    else 
    begin
        O_flow_para_err_flag <= 1'b0;
    end        
end

///*********************************************************************
///统计
///********************************************************************* 

always @ (posedge I_pla_312m5_clk )
begin
    if (I_cnt_clear)
    begin
        O_flow_fifo_frame_stat[15:0] <= 16'd0;
    end
    else if(I_delay_fifo_data[35] && !S_ram_dout_buf0[35])
    begin
        O_flow_fifo_frame_stat[15:0] <= O_flow_fifo_frame_stat[15:0] + 16'd1;
    end
end 

always @ (posedge I_pla_312m5_clk )
begin
    if (I_cnt_clear)
    begin
        O_flow_fifo_frame_stat[31:16] <= 8'd0;
    end
    else if(S1_flow_data_valid && !S2_flow_data_valid && S_hc_pkt_flag_ff)   ///hc统计
    begin
        O_flow_fifo_frame_stat[31:16] <= O_flow_fifo_frame_stat[31:16] + 16'd1;        
    end
end

always @ (posedge I_pla_312m5_clk )
begin
    if (I_cnt_clear)
    begin
        O_flow_fifo_frame_stat[47:32] <= 16'd0;
    end
    else if(S1_flow_data_valid && !S2_flow_data_valid && S_ptp_header_ff)   ///PTP统计
    begin
        O_flow_fifo_frame_stat[47:32] <= O_flow_fifo_frame_stat[47:32] + 16'd1;         
    end
end


endmodule





