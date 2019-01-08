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
//x                                 |---- 
//x                                 |----U01_pla_forward_ptp_check_32bit
//x  pla_forward_flow_parameter  ---|----U02_pla_forward_flow_delay
//----------------------------------------------------------------------------
//Relaese History :
//----------------------------------------------------------------------------
//Version         Date           Author        Description
// 1.0            2012-08-17     Sai Bin       New Generate
//----------------------------------------------------------------------------
//Main Function:提取XGMII报文参数，包含，HC标志，PTP标志，帧长、奇偶标志。
//              并将其存放到fifo中等待上层模块读取。
//   参数FIFO数据定义：
///  Bit31:18：预留
///  Bit17:16：PLA number，用于判断写入哪个流fifo
///  Bit15   ：HC报文标志
///  Bit14   ：奇偶标志
///  Bit13   ：PTP报文标志
///  Bit12:0 ：帧长
//----------------------------------------------------------------------------
//REUSE ISSUES: empty
//Reset Strategy: empty
//Clock Strategy: empty
//Critical Timing: empty
//Asynchronous Interface: empty
//END_HEADER------------------------------------------------------------------

`timescale 1ns/1ns

module pla_forward_flow_parameter
(                   
    input                I_pla_312m5_clk               ,  /////  时钟                  
    input                I_pla_rst                     ,  /////  复位                  
    input                I_cnt_clear                   ,           
    input                I_pla_tc_en                   ,  /////  组PLA TC使能              
    input        [31:0]  I_xgmii_txd                   ,  /////  待发送XGMII数据       
    input        [3:0]   I_xgmii_txc                   ,  /////  待发送XGMII控制       
    input        [1:0]   I_xgmii_pla_num               ,  /////  待发送XGMII所需PLA组号
    input                I_pla_para_fifo_rd            ,  /////  整流模块发起
    output               O_param_ff_full               ,  /////  参数FIFO满标志  
    output  reg  [31:0]  O_pla_para_fifo_rdata         ,   /////  读出的参数信息  
    output       [37:0]  O_xgmii_delayed_q             ,
    output  reg  [31:0]  O_pla_para_err_stat    =16'd0  ,
    output               O_param_ff_empty
); 

                                               
reg         S_xgmii_data_valid;        ///Preamble压缩为0x55d5后新MAC包数据有效指示
reg         S1_xgmii_data_valid;       ///Preamble压缩为0x55d5后新MAC包数据有效指示
reg[31:0]   S_xgmii_txd;               ///XGMII发送数据延迟1拍信号
reg[3:0]    S_xgmii_txc;               ///XGMII发送使能延迟1拍信号
reg[3:0]    S1_xgmii_txc;              ///XGMII发送使能延迟1拍信号
reg[1:0]    S_xgmii_pla_num;           ///待发送XGMII所需PLA组号
                                   
reg         S_preamble_flag;           ///Preamble标志                                  
reg[12:0]   S_data_length_cnt;         ///MAC包数据长度计数器
reg         S_hc_pkt_flag;             ///帧头压缩MAC包指示信号
reg         S_pkt_pf;                  ///MAC包长字节数奇偶指示信号                                     
reg         S_param_fifo_wr_en;        ///MAC包参数缓存FIFO写使能 
reg         S_pla_para_fifo_rd;        ///MAC包参数缓存FIFO读使能延迟1拍
          
wire        S_param_ff_empty;          ///参数FIFO空标志
wire[31:0]  S_pla_para_fifo_q;         ///从RAM读出的数据            
wire[9:0]   S_fifo_data_count;         ///
wire        S_ptp_header_flag         ;///

reg         S1_ptp_header_flag        ;///
(*mark_debug ="true"*) reg [31:0]  S_param_fifo_wr_data      ;

reg [7:0]   S_param_num;

reg  [15:0] S_ifg_cnt      =16'd0;

(*mark_debug ="true"*) reg         S_bit_end_err;
(*mark_debug ="true"*) reg         S_bit_start_err;
(*mark_debug ="true"*) reg         S_bit_length_err;


(*mark_debug ="true"*) reg         D_param_fifo_wr_en;
///数据打拍
always @ (posedge I_pla_312m5_clk)
begin
    D_param_fifo_wr_en <= S_param_fifo_wr_en;     
end


///数据打拍
always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
    begin
        S_param_num  <= 8'h0;
    end     
    else if(S_preamble_flag)
    begin
        S_param_num <= S_param_num + 8'd1;  
    end    
end



///数据打拍
always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
    begin
        S_xgmii_txd  <= 32'h0;
        S_xgmii_txc  <= 4'hf;
        S_pla_para_fifo_rd <= 1'b0;
        S_xgmii_pla_num  <= 2'd0;
    end     
    else
    begin
        S_xgmii_txd  <= I_xgmii_txd;
        S_xgmii_txc  <= I_xgmii_txc;  
        S_pla_para_fifo_rd <= I_pla_para_fifo_rd;
        S_xgmii_pla_num <= I_xgmii_pla_num ;     
    end    
end

///连续收到Preamble的0x5555标志产生
///帧头压缩MAC包指示信号
always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
        S_preamble_flag <= 1'b0;  
    else if((I_xgmii_txc == 4'h8)&&(I_xgmii_txd == 32'hfb5555d5) &&(S_xgmii_txc == 4'hf))  ///压缩报文
        S_preamble_flag <= 1'b1;
    else if((S_xgmii_txc == 4'h8)&&(S_xgmii_txd == 32'hfb555555)&&(I_xgmii_txc == 4'h0)&&(I_xgmii_txd == 32'h555555d5))  ///非压缩报文 
        S_preamble_flag <= 1'b1;        
    else
        S_preamble_flag <= 1'b0;
end


always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
        S_hc_pkt_flag   <= 1'b0;
    else if(I_xgmii_txc == 4'h8)
        if (I_xgmii_txd == 32'hfb5555d5)  ///压缩报文
            S_hc_pkt_flag   <= 1'b1;
        else
            S_hc_pkt_flag   <= 1'b0;
    else
        S_hc_pkt_flag   <= S_hc_pkt_flag;
end


///Preamble压缩为0x55d5后新MAC包数据有效部分指示
always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst) 
        S_xgmii_data_valid  <= 1'b0;
    else if (!(&S_xgmii_txc) && S_preamble_flag && (S_xgmii_txd[15:0] == 16'h55d5))  
        S_xgmii_data_valid  <= 1'b1;     
    else if(I_xgmii_txc == 4'hf)
        S_xgmii_data_valid  <= 1'b0;
    else if(S_xgmii_txc[0] && !S_xgmii_txc[3])   ///防止0,1,7结尾无f ,或者多个1,3,7
        S_xgmii_data_valid  <= 1'b0;
    else if (S_data_length_cnt == 13'h962 && S_xgmii_data_valid)
        S_xgmii_data_valid  <= 1'b0;
    else
        S_xgmii_data_valid <= S_xgmii_data_valid;
end

///Preamble压缩为0x55d5后新MAC包EGMII信号，包格式为0x55d5 DA SA ...... CRC 
always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
    begin
        S1_xgmii_txc         <= 4'hf;
        S1_xgmii_data_valid  <= 1'b0 ;   
    end
    else if(S_xgmii_data_valid)
    begin
        S1_xgmii_txc         <= S_xgmii_txc;
        S1_xgmii_data_valid  <= S_xgmii_data_valid;
    end      
    else
    begin
        S1_xgmii_txc         <= 4'hf;
        S1_xgmii_data_valid  <= 1'b0 ;               
    end       
end


///Preamble压缩为0x55d5后新MAC包包长计数器,长度包含包头0x55d5，以字（16bits）为单位
///对于非HC报文,偶数byte长度减掉2Byte CRC，同时奇偶标志位为0；奇数byte长度要减掉1Byte CRC，同时奇偶标志位1；
///对于HC报文,偶数byte长度不做处理;奇偶标志位0,奇数byte长度要增加1Byte无用字节，同时奇偶标志位。
///包长不计算55D5和PARAMETER,要计算有效CRC字节
always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
        S_data_length_cnt <= 13'h0; 
    else if(S_xgmii_txc == 4'h8 && I_xgmii_txc == 4'h0)
        S_data_length_cnt <= 13'h1;
    else if(S_xgmii_data_valid) 
    begin
        if(I_xgmii_txc == 4'hf) 
        begin
            if(S_hc_pkt_flag)
            begin
                if (S_xgmii_txc == 4'd0 || S_xgmii_txc == 4'd1)  
                    S_data_length_cnt <= {S_data_length_cnt[11:0],1'b0} - 13'd1; 
                else 
                    S_data_length_cnt <= {S_data_length_cnt[11:0],1'b0} - 13'd2; 
            end        
            else
            begin  ///非压缩报文
                if (S_xgmii_txc == 4'd0 || S_xgmii_txc == 4'd1) 
                    S_data_length_cnt <= {S_data_length_cnt[11:0],1'b0} - 13'd2;       
                else 
                    S_data_length_cnt <= {S_data_length_cnt[11:0],1'b0} - 13'd3;  
            end   
        end           
        else if(S_bit_length_err)
        begin
            if(S_hc_pkt_flag)
            begin
                S_data_length_cnt <= {S_data_length_cnt[11:0],1'b0} - 13'd1; 
            end
            else 
            begin
            S_data_length_cnt <= {S_data_length_cnt[11:0],1'b0} - 13'd2;      
        end
        end
        else
        begin
            S_data_length_cnt <= S_data_length_cnt + 13'h1; 
        end    
    end                                     
    else
        S_data_length_cnt <= S_data_length_cnt; 
end



///MAC包长度奇偶类型指示信号
always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst) 
        S_pkt_pf <= 1'b0;
    else if ((!S_xgmii_data_valid) && S1_xgmii_data_valid)
    begin
        if(S1_xgmii_txc == 4'b0111 ||S1_xgmii_txc == 4'b0001 )   
            S_pkt_pf <= 1'b1;  ///包长为奇数字节
        else
            S_pkt_pf <= 1'b0;  ///包长为偶数字节
    end   
    else 
        S_pkt_pf  <= S_pkt_pf;
end

///MAC包参数缓存FIFO写使能
always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst) 
        S_param_fifo_wr_en <= 1'b0;
    else if ((!S_xgmii_data_valid) && S1_xgmii_data_valid)
        S_param_fifo_wr_en <= 1'b1;
    else 
        S_param_fifo_wr_en <= 1'b0;
end

blk_com_fifo_1024x32_k7  U0_param_fifo_1024x32
(
    .srst         (I_pla_rst          ),
    .clk          (I_pla_312m5_clk    ),
    .din          ({S_param_num,6'd0,S_xgmii_pla_num,S_hc_pkt_flag,S_pkt_pf,S1_ptp_header_flag,S_data_length_cnt}),   
    .rd_en        (S_pla_para_fifo_rd ),
    .wr_en        (S_param_fifo_wr_en ),
    .empty        (S_param_ff_empty   ),
    .full         (O_param_ff_full    ),
    .dout         (S_pla_para_fifo_q  ),
    .data_count   (S_fifo_data_count  )
);


assign O_param_ff_empty = S_param_ff_empty;

always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
    begin
        S_param_fifo_wr_data <= 32'd0;
    end
    else if (S_param_fifo_wr_en)
    begin
        S_param_fifo_wr_data <= {S_param_num,6'd0,S_xgmii_pla_num,S_hc_pkt_flag,S_pkt_pf,S1_ptp_header_flag,S_data_length_cnt};
    end
end


always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
    begin
        O_pla_para_fifo_rdata <= 32'd0;
    end
    else
    begin    
        O_pla_para_fifo_rdata <= S_pla_para_fifo_q; 
    end   
end



pla_forward_ptp_check_32bit U01_pla_forward_ptp_check_32bit(
.I_sys_312m5_clk          (I_pla_312m5_clk),
.I_xgmii_d                (I_xgmii_txd),
.I_xgmii_txc              (I_xgmii_txc),
.I_xgmii_crc_err          (1'b0),
.O_xgmii_d                (),
.O_xgmii_txc              (),
.O_xgmii_crc_err          (),
.O_xgmii_udp_1588_flag    (),
.O_xgmii_ptp_header_flag  (S_ptp_header_flag),
.O_statistic_pulse        ()  
);
always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
    begin
        S1_ptp_header_flag <= 1'd0;
    end    
    else if ((!S_xgmii_data_valid) && S1_xgmii_data_valid && S_data_length_cnt > 13'h07c)
    begin
        S1_ptp_header_flag <= 1'b0;
    end
    else
    begin
        S1_ptp_header_flag <= I_pla_tc_en & S_ptp_header_flag;
    end    
end


/////DELAY延时数据/////////////////////////////////////////


reg  [31:0] S1_pla0_xgmii_txd ;                   ///EGMII发送数据延迟1拍信号
reg   [3:0] S1_pla0_xgmii_txc ;                   ///EGMII发送使能延迟1拍信号  
reg   [1:0] S1_pla0_xgmii_num ;                        
    
reg  [31:0] S2_pla0_xgmii_txd ;                   ///EGMII发送数据延迟1拍信号    
reg   [3:0] S2_pla0_xgmii_txc ;                   ///EGMII发送使能延迟1拍信号    
reg   [1:0] S2_pla0_xgmii_num ;                             

reg         S_pla0_preamble_flag;                ///Preamble标志



always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
    begin
        S1_pla0_xgmii_txd   <= 32'h07070707;
        S1_pla0_xgmii_txc   <= 4'hf;
        S1_pla0_xgmii_num   <= 2'd0;   
    end
    else 
    begin
        S1_pla0_xgmii_txd   <= I_xgmii_txd       ;  
        S1_pla0_xgmii_txc   <= I_xgmii_txc       ;
        S1_pla0_xgmii_num   <= I_xgmii_pla_num   ;
    end           
end


///连续收到Preamble的0x5555标志产生
always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
    begin
        S_pla0_preamble_flag <= 1'b0;  
    end    
    else if((I_xgmii_txc == 4'h8)&&(I_xgmii_txd == 32'hfb5555d5))  ///压缩报文
    begin
        S_pla0_preamble_flag <= 1'b1;
    end    
    else if((S1_pla0_xgmii_txc == 4'h8)&&(S1_pla0_xgmii_txd == 32'hfb555555)&&(I_xgmii_txc == 4'h0)&&(I_xgmii_txd == 32'h555555d5))  ///非压缩报文
    begin 
        S_pla0_preamble_flag <= 1'b1;    
    end          
    else if (I_xgmii_txc == 4'hf)
        S_pla0_preamble_flag <= 1'b0;
    else if(S_xgmii_txc[0] && !S_xgmii_txc[3])   ///防止0,1,7结尾无f ,或者多个1,3,7
        S_pla0_preamble_flag  <= 1'b0; 
    else if (S_data_length_cnt == 13'h962 && S_xgmii_data_valid)
        S_pla0_preamble_flag  <= 1'b0;               
    else 
        S_pla0_preamble_flag <= S_pla0_preamble_flag; 
end



///Preamble压缩为0x55d5后新MAC包EGMII信号，包格式为0x55d5 DA SA ...... CRC 
always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
    begin
        S2_pla0_xgmii_txd   <= 32'h07070707;
        S2_pla0_xgmii_txc   <= 4'hf;
        S2_pla0_xgmii_num   <= 2'd0;
    end
    else if (S_pla0_preamble_flag)
    begin
        S2_pla0_xgmii_txd   <= S1_pla0_xgmii_txd;  
        S2_pla0_xgmii_txc   <= S1_pla0_xgmii_txc;
        S2_pla0_xgmii_num   <= S1_pla0_xgmii_num;
    end      
    else
    begin
        S2_pla0_xgmii_txd   <= {24'h070707,S_param_num};///32'h07070707;       
        S2_pla0_xgmii_txc   <= 4'hf;   
        S2_pla0_xgmii_num   <= S2_pla0_xgmii_num;
    end       
end



pla_forward_flow_delay U02_pla_forward_flow_delay
(                   
.I_pla_312m5_clk          (I_pla_312m5_clk       ),
.I_pla_rst                (I_pla_rst             ),
.I_xgmii_pla_num          (S2_pla0_xgmii_num     ),
.I_xgmii_txd              (S2_pla0_xgmii_txd     ),   
.I_xgmii_txc              (S2_pla0_xgmii_txc     ),   
.O_xgmii_delayed_q        (O_xgmii_delayed_q     )    
);     



///统计1，3，7结尾异常的个数
///Preamble压缩为0x55d5后新MAC包数据有效部分指示
always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst) 
        S_bit_end_err  <= 1'b0;     
    else if(S_xgmii_txc[0] && !S_xgmii_txc[3] && I_xgmii_txc[0] && !I_xgmii_txc[3] )   ///防止0,1,7结尾无f ,或者多个1,3,7
        S_bit_end_err  <= 1'b1;
    else
        S_bit_end_err  <= 1'b0; 
end

///统计8多的个数
always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst) 
        S_bit_start_err  <= 1'b0;     
    else if(S_xgmii_txc == 4'h8 && I_xgmii_txc == 4'h8 )   ///防止0,1,7结尾无f ,或者多个1,3,7
        S_bit_start_err  <= 1'b1;
    else
        S_bit_start_err  <= 1'b0; 
end

//统计超过9600帧的个数
always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst) 
        S_bit_length_err  <= 1'b0;     
    else if(S_data_length_cnt == 13'h961 && S_xgmii_data_valid)   //
        S_bit_length_err  <= 1'b1;
    else
        S_bit_length_err  <= 1'b0; 
end

always @ (posedge I_pla_312m5_clk) ////判定满的次数
begin
	  if (I_cnt_clear)
	  begin
	      O_pla_para_err_stat[7:0] <= 8'h0 ;
	  end
    else if (S_bit_length_err) ////
    begin
        O_pla_para_err_stat[7:0] <=  O_pla_para_err_stat[7:0]  + 8'h1 ;
    end                
end

always @ (posedge I_pla_312m5_clk) ////判定满的次数
begin
	  if (I_cnt_clear)
	  begin
	      O_pla_para_err_stat[15:8]  <= 8'h0 ;
	  end
    else if (S_bit_start_err || S_bit_end_err) ////h7fe0
    begin
        O_pla_para_err_stat[15:8] <=  O_pla_para_err_stat[15:8] + 8'h1 ;
    end                
end

///包间隔寄存器

always @ (posedge I_pla_312m5_clk)
begin
    if (I_xgmii_txc == 4'hf)
    begin
         S_ifg_cnt <= S_ifg_cnt + 16'd1 ;
    end
    else
    begin
         S_ifg_cnt <= 16'd0;
    end
end

always @ (posedge I_pla_312m5_clk)
begin
    if (I_cnt_clear)
    begin
        O_pla_para_err_stat[31:16]  <= 16'b0 ;
    end      
    else if (I_xgmii_txc == 4'h8)
    begin
       if (S_ifg_cnt == 16'd1 || S_ifg_cnt == 16'd0)
        O_pla_para_err_stat[31:16]  <= O_pla_para_err_stat[31:16]   + 16'd1 ;
    end
end



endmodule





