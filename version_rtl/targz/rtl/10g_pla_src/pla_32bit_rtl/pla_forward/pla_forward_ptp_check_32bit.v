//FILE_HEADER-------------------------------------------------------
//ZTE Copyright(C)
// ZTE Company Confidential
//------------------------------------------------------------------
// Project Name : rtuio
// FILE NAME    : pro_1588_check_32bit.v
// AUTHOR       : liu hongxia
// Department   : ZTE-BBU System Department
// Email        : liu.hongxia2@zte.com.cn
//------------------------------------------------------------------
// Module Hiberarchy:
//x                          |----xxxxx
//x                          |----xxxxx
//x pro_1588_check_32bit-----|----xxxxx
//x                          |----xxxxx
//x                          |----xxxxx
//-----------------------------------------------------------------
// Release History:
//-----------------------------------------------------------------
// Version      Date      Author        Description
// 1.0        07-25-2014  liu hongxia   1588报文解包，给出ptp_header和udp_1588指示信号
// 1.1        mm-dd-yyyy   Author       修改、增减的主要内容描述
//-----------------------------------------------------------------
//Main Function:
// a) check packet and output the flag signal of ptp header and udp 1588
//-----------------------------------------------------------------
//REUSE ISSUES: xxxxxxxx          
//Reset Strategy: synchronous reset
//Clock Strategy: xxxxxxxx
//Critical Timing: xxxxxxxx
//Asynchronous Interface: xxxxxxxx
//END_HEADER--------------------------------------------------------
`timescale 1ns/1ns

module pla_forward_ptp_check_32bit (
input             I_sys_312m5_clk           , // 系统时钟
input      [31:0] I_xgmii_d                 , // 输入xgmii
input      [ 3:0] I_xgmii_txc               , // 输入控制字
input             I_xgmii_crc_err           , // 输入crc_err
                                             
output reg [31:0] O_xgmii_d   = 32'h07070707, // 输出xgmii   
output reg [ 3:0] O_xgmii_txc = 4'hf        , // 输出控制字  
output reg        O_xgmii_crc_err = 1'b0    , // 输出crc_err 
output            O_xgmii_udp_1588_flag     , // udp_1588_flag
output reg        O_xgmii_ptp_header_flag  = 1'b0 , // ptp_header_flag
output     [ 2:0] O_statistic_pulse           //端口报文统计:bit0: 入口报文统计；bit1：帧头错误统计；bit2：CRC错统计  
);

parameter   C_XGMII_IDLE       = 3'h0,
            C_XGMII_PRE        = 3'h1,
            C_XGMII_MAC        = 3'h2,
            C_XGMII_TYPE       = 3'h3,
            C_XGMII_IP         = 3'h4,
            C_XGMII_UDP        = 3'h5,
            C_XGMII_PTP        = 3'h6,
            C_XGMII_DATA       = 3'h7;
            
reg  [2:0]  S_xgmii_state            = 3'b0 ; //
reg  [2:0]  S_xgmii_state_next       = 3'b0 ; //
reg  [1:0]  S_xgmii_state_cnt        = 2'b0 ; //
reg  [31:0] S_xgmii_d         = 32'h07070707; //
reg  [3:0]  S_xgmii_txc              = 4'hf ; //
reg         S_xgmii_crc_err          = 1'h0 ; //  
reg         S_xgmii_start_flg_pulse  = 1'h0 ; //
reg         S_xgmii_sfd_flg_pulse    = 1'h0 ; // 
reg         S_xgmii_vlan_flg_pulse   = 1'b0 ; //
reg         S_xgmii_ip_flg_pulse     = 1'b0 ; //
reg         S_xgmii_l2_ptp_flg_pulse = 1'b0 ; //
reg         S_xgmii_udp_flg_pulse    = 1'b0 ; //
reg         S_xgmii_udp_1588_flag    = 1'b0 ; //
///used in statistic
reg         S_statistic_pulse0       = 1'b0 ; /// S_statistic_pulse0
reg         S_statistic_pulse1       = 1'b0 ; /// S_statistic_pulse1
reg         S_statistic_pulse2       = 1'b0 ; /// S_statistic_pulse2


always @ (posedge I_sys_312m5_clk)
begin
    S_xgmii_d       <= I_xgmii_d       ; 
    S_xgmii_txc     <= I_xgmii_txc     ; 
    S_xgmii_crc_err <= I_xgmii_crc_err ; 	  
end

always @ (posedge I_sys_312m5_clk)
begin
    if((I_xgmii_txc == 4'h8) && (S_xgmii_txc == 4'hf) && (I_xgmii_d == 32'hfb555555))
        begin
            S_xgmii_start_flg_pulse <= 1'b1;
        end    
    else
        begin
            S_xgmii_start_flg_pulse <= 1'b0;
        end
end

always @ (posedge I_sys_312m5_clk)
begin
    if((I_xgmii_txc == 4'h0) && (I_xgmii_d == 32'h555555d5))
        begin
            S_xgmii_sfd_flg_pulse <= 1'b1;
        end
    else
        begin
            S_xgmii_sfd_flg_pulse <= 1'b0;
        end
end

always @ (posedge I_sys_312m5_clk)
begin
    if((I_xgmii_txc == 4'h0) && (I_xgmii_d[31:16] == 16'h8100))
        begin
            S_xgmii_vlan_flg_pulse <= 1'b1;
        end
    else
        begin
            S_xgmii_vlan_flg_pulse <= 1'b0;
        end
end

always @ (posedge I_sys_312m5_clk)
begin
    if((I_xgmii_txc == 4'h0) && (I_xgmii_d[31:16] == 16'h88f7))
        begin
            S_xgmii_ip_flg_pulse <= 1'b1;
        end
    else
        begin
            S_xgmii_ip_flg_pulse <= 1'b0;
        end
end

always @ (posedge I_sys_312m5_clk)
begin
    if((I_xgmii_txc == 4'h0) && (I_xgmii_d[31:16] == 16'h0800))
        begin
            S_xgmii_l2_ptp_flg_pulse <= 1'b1;
        end
    else
        begin
            S_xgmii_l2_ptp_flg_pulse <= 1'b0;
        end
end

always @ (posedge I_sys_312m5_clk)
begin
    if((S_xgmii_txc == 4'h0) && (S_xgmii_state == C_XGMII_IP) && (S_xgmii_d[7:0] == 8'd17))
        begin
            S_xgmii_udp_flg_pulse <= 1'b1;
        end
    else 
        begin
            S_xgmii_udp_flg_pulse <= 1'b0;
        end
end

always @ (posedge I_sys_312m5_clk)
begin
    if(&I_xgmii_txc)
        begin
            S_xgmii_udp_1588_flag <= 1'b0;            
        end
    else if((S_xgmii_txc == 4'h0) && (S_xgmii_state_cnt == 2'd2) && (S_xgmii_d[31:16] == 16'h013f) && (S_xgmii_state == C_XGMII_UDP) )
        begin
            if (I_xgmii_d[15:0] == 16'h0002 || I_xgmii_d[15:0] == 16'h0102) 
            begin
        	  S_xgmii_udp_1588_flag <= 1'b1;
        end 
    else
        begin
        	  S_xgmii_udp_1588_flag <= S_xgmii_udp_1588_flag;
        end     
end           
    else
        begin
        	  S_xgmii_udp_1588_flag <= S_xgmii_udp_1588_flag;
        end     
end           

always @ (posedge I_sys_312m5_clk)
begin
	  if(&I_xgmii_txc) 
	      begin 
	      	  S_xgmii_state = C_XGMII_IDLE;
	      end 
	  else
	      begin
            S_xgmii_state <= S_xgmii_state_next;
        end
end

always @ (*)
begin
    case(S_xgmii_state)
        C_XGMII_IDLE :
        begin
           if(S_xgmii_start_flg_pulse)
                begin
                    S_xgmii_state_next = C_XGMII_PRE;
                end
            else
                begin
                    S_xgmii_state_next = C_XGMII_IDLE;
                end
        end
        C_XGMII_PRE  :
        begin
        	  if(S_xgmii_sfd_flg_pulse)
                begin
                    S_xgmii_state_next = C_XGMII_MAC;
                end
            else
                begin
                	  S_xgmii_state_next = C_XGMII_IDLE;
                end
        end
        C_XGMII_MAC  :
        	  begin
                if(S_xgmii_state_cnt == 2'd2)
                    begin
                        S_xgmii_state_next = C_XGMII_TYPE;
                    end
                else
                    begin
                        S_xgmii_state_next = C_XGMII_MAC;
                    end  
            end  
        C_XGMII_TYPE :
        begin
            if(S_xgmii_vlan_flg_pulse)
                begin
                    S_xgmii_state_next = C_XGMII_TYPE;
                end
            else if(S_xgmii_l2_ptp_flg_pulse)
                begin
                    S_xgmii_state_next = C_XGMII_IP;
                end
            else if(S_xgmii_ip_flg_pulse)
                begin
                    S_xgmii_state_next = C_XGMII_PTP;
                end
            else
                begin
                    S_xgmii_state_next = C_XGMII_DATA;
                end
        end
        C_XGMII_IP   :
        begin
            if(S_xgmii_state_cnt == 2'd2)
                begin
                    if(S_xgmii_udp_flg_pulse)
                        begin
                            S_xgmii_state_next = C_XGMII_UDP;
                        end
                    else
                        begin
                            S_xgmii_state_next = C_XGMII_DATA;
                        end
                end
            else
                begin
                    S_xgmii_state_next = C_XGMII_IP;
                end
        end
        C_XGMII_UDP  :  ///5
        begin
            if(S_xgmii_state_cnt == 2'd3)
                begin
                    if(S_xgmii_udp_1588_flag)
                        begin
                            S_xgmii_state_next = C_XGMII_PTP;
                        end
                    else
                        begin
                            S_xgmii_state_next = C_XGMII_DATA;
                        end
                end
            else
                begin
                    S_xgmii_state_next = C_XGMII_UDP;
                end
        end
        C_XGMII_PTP  :
        begin
            S_xgmii_state_next = C_XGMII_PTP;
        end
        C_XGMII_DATA :
        begin
            S_xgmii_state_next = C_XGMII_DATA;
        end
        default :
        begin
            S_xgmii_state_next = C_XGMII_IDLE;
        end
    endcase
end

always @ (posedge I_sys_312m5_clk)
begin
    case(S_xgmii_state)
        C_XGMII_MAC  :
        begin
            if(S_xgmii_state_cnt == 2'd2)
                begin
                    S_xgmii_state_cnt <= 2'd0;
                end
            else
                begin
                    S_xgmii_state_cnt <= S_xgmii_state_cnt + 2'd1;
                end
        end
        C_XGMII_IP   :
        begin
            if(S_xgmii_state_cnt == 2'd2)
                begin
                    S_xgmii_state_cnt <= 2'd0;
                end
            else
                begin
                    S_xgmii_state_cnt <= S_xgmii_state_cnt + 2'd1;
                end
        end
        C_XGMII_UDP  :
        begin
             if(S_xgmii_state_cnt == 2'd3)
                begin
                    S_xgmii_state_cnt <= 2'd0;
                end
            else
                begin
                    S_xgmii_state_cnt <= S_xgmii_state_cnt + 2'd1;
                end
        end
        default :
        begin
            S_xgmii_state_cnt <= 2'd0;
        end
    endcase
end


assign O_xgmii_udp_1588_flag   = S_xgmii_udp_1588_flag;

always @ (posedge I_sys_312m5_clk)
begin
    if(S_xgmii_state == C_XGMII_PTP)
        O_xgmii_ptp_header_flag <= 1'b1; 
    else if (I_xgmii_txc == 4'h8)    
        O_xgmii_ptp_header_flag <= 1'b0;
    else
        O_xgmii_ptp_header_flag <= O_xgmii_ptp_header_flag;                
end 


always @ (posedge I_sys_312m5_clk)
begin
    O_xgmii_d       <= S_xgmii_d;
    O_xgmii_txc     <= S_xgmii_txc;
    O_xgmii_crc_err <= S_xgmii_crc_err;   
end

/////////////////////////////////////////////////////////////
///                      可维可测                         ///
/////////////////////////////////////////////////////////////  

///检测到I_xgmii_d_=fb555555且I_xgmii_txc =0x8且S_xgmii_txc=0xf ，即start检测，信号跳变一次。
always @ (posedge I_sys_312m5_clk)
begin
    if(S_xgmii_start_flg_pulse)
        S_statistic_pulse0 <= ~S_statistic_pulse0;               
end   
                   
///检测到无效帧（即sfd检测），信号跳变一次。
always @ (posedge I_sys_312m5_clk)
begin
    if((S_xgmii_state == C_XGMII_PRE) && (!S_xgmii_sfd_flg_pulse))
        S_statistic_pulse1 <= ~S_statistic_pulse1;               
end  

///检测CRC错误，信号跳变一次。
always @ (posedge I_sys_312m5_clk)
begin
    if(!S_xgmii_crc_err && I_xgmii_crc_err)
        S_statistic_pulse2 <= ~S_statistic_pulse2;               
end 

assign O_statistic_pulse = {S_statistic_pulse2,
                            S_statistic_pulse1,
                            S_statistic_pulse0};   
                            
endmodule
