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
//x                             |----U0_xgmii_delay_dpram
//x                             |----
//x  pla_forward_flow_delay  ---|----
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

module pla_forward_flow_delay
(                   
    input                I_pla_312m5_clk               ,  /////  时钟               
    input                I_pla_rst                     ,  /////  复位     
    input        [1:0]   I_xgmii_pla_num               ,  ////   number         
    input        [31:0]  I_xgmii_txd                   ,  /////  待延时XGMII数据    
    input        [3:0]   I_xgmii_txc                   ,  /////  待延时XGMII控制    
    output reg   [37:0]  O_xgmii_delayed_q                /////  延时后XGMII数据和控制信号            
);                                                                                  

reg[11:0]   S_dpram_raddr;
reg[11:0]   S_dpram_waddr;
wire[37:0]  S_xgmii_delayed_q;    
reg         S_rst_flag;                                                     


///删除 非PTP报文无效CRC
reg            S_hc_pkt_flag       ;
reg    [1:0]   S1_xgmii_pla_num     ;  ////   number             
reg    [31:0]  S1_xgmii_txd         ;  /////  待延时XGMII数据    
reg    [3:0]   S1_xgmii_txc         ;  /////  待延时XGMII控制   
reg    [1:0]   S2_xgmii_pla_num     ;  ////   number             
reg    [31:0]  S2_xgmii_txd         ;  /////  待延时XGMII数据    
reg    [3:0]   S2_xgmii_txc         ;  /////  待延时XGMII控制     


always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
    begin
        S_dpram_waddr <= 12'd0;
    end
    else if(S_dpram_waddr == 12'd2402)   ///2402 
    begin
        S_dpram_waddr <= 12'd0;
    end
    else
    begin
        S_dpram_waddr <= S_dpram_waddr + 12'd1; 
    end
end 

always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
    begin
        S_dpram_raddr <= 12'd1;
    end
    else if(S_dpram_raddr == 12'd2402)  
    begin
        S_dpram_raddr <= 12'd0;
    end
    else
    begin
        S_dpram_raddr <= S_dpram_raddr + 12'd1; 
    end
end


blk_com_dpram_2560x38 U0_xgmii_delay_dpram(
///dpram_2560x38_xilinx U0_xgmii_delay_dpram(
.clka    (I_pla_312m5_clk ),
.ena     (1'b1            ),
.wea     (1'b1            ),
.addra   (S_dpram_waddr   ),
.dina    ({S2_xgmii_pla_num,S2_xgmii_txc,S2_xgmii_txd}),
.clkb    (I_pla_312m5_clk  ),
.rstb    (I_pla_rst        ),
.addrb   (S_dpram_raddr    ),
.doutb   (S_xgmii_delayed_q)
);

always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
    begin
        O_xgmii_delayed_q <=38'h0f07070707;
    end    
    else if (S_rst_flag)
    begin
        O_xgmii_delayed_q <=38'h0f07070707;
    end
    else 
    begin
        O_xgmii_delayed_q <= S_xgmii_delayed_q;  
    end     
end

always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
    begin
        S_rst_flag <= 1'b1;
    end    
    else if (S_dpram_waddr == 12'd2402)  
    begin
        S_rst_flag <= 1'b0;
    end
    else 
    begin
        S_rst_flag <= S_rst_flag;  
    end     
end

        


always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
        S_hc_pkt_flag   <= 1'b0;
    else if(I_xgmii_txc == 4'h8 && I_xgmii_txd == 32'hfb5555d5)
            S_hc_pkt_flag   <= 1'b1;
    else if (I_xgmii_txc == 4'hf)
            S_hc_pkt_flag   <= 1'b0;
end



always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if (I_pla_rst)
    begin
        S1_xgmii_pla_num  <= 2'd3;
        S1_xgmii_txd      <= 32'h07070707;
        S1_xgmii_txc      <= 4'hf;    
        S2_xgmii_pla_num  <= 2'd3;
        S2_xgmii_txd      <= 32'h07070707;
        S2_xgmii_txc      <= 4'hf;
    end 
    else 
    begin
        S1_xgmii_pla_num  <= I_xgmii_pla_num    ;
        S1_xgmii_txd      <= I_xgmii_txd        ;
        S1_xgmii_txc      <= I_xgmii_txc        ;
        S2_xgmii_pla_num  <= S1_xgmii_pla_num    ;
        S2_xgmii_txc      <= S1_xgmii_txc        ;
        
        if (I_xgmii_txc == 4'hf && !S_hc_pkt_flag && S1_xgmii_txc !=4'hf)  ///非HC包
        begin
           if (S1_xgmii_txc == 4'h0 || S1_xgmii_txc == 4'h1)
           begin
               S2_xgmii_txd <= {S1_xgmii_txd[31:16],16'h0000};              
           end
           else 
           begin
               S2_xgmii_txd <= {32'h0};      
           end
        end
        else    
        begin
             S2_xgmii_txd <= S1_xgmii_txd;
        end 
    end
end



endmodule





