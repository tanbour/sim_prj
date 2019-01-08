//FILE_HEADER-------------------------------------------------------
//ZTE Copyright(C)
// ZTE Company Confidential
//------------------------------------------------------------------
// Project Name : ZXLTE xxxx
// FILE NAME    : pla_1588_packing.v
// AUTHOR       : sun.lijun
// Department   : ZTE-BBU System Department
// Email        : sun.lijun9@zte.com.cn
//------------------------------------------------------------------
// Module Hiberarchy:
//x pla_1588_depacking----- 
//-----------------------------------------------------------------
// Release History:
//-----------------------------------------------------------------
// Version      Date      Author        Description
// 1.0        5-25-2015   sun.lijun   initial version
// 1.1        mm-dd-yyyy   Author       �޸ġ���������Ҫ��������
//-----------------------------------------------------------------
//Main Function:
// a)calc cf, add Tin.
//-----------------------------------------------------------------
//REUSE ISSUES: xxxxxxxx          
//Reset Strategy: synchronous reset
//Clock Strategy: xxxxxxxx
//Critical Timing: xxxxxxxx
//Asynchronous Interface: xxxxxxxx
//END_HEADER--------------------------------------------------------
`timescale 1ns / 100ps
module pla_1588_packing(
input          I_sys_312m_clk                 ,    // 
input          I_fpga_reset                   ,    //

input [3:0]    I_gmii_txc                     ,    //
input [31:0]   I_gmii_data                    ,    //

input [47:0]   I_pla_slice_da                 ,    //
input [47:0]   I_pla_slice_sa                 ,    //

input          I_1588_packet_in_num_clr       ,    //
input          I_1588_packet_out_num_clr      ,    //
input          I_all_packet_in_num_clr        ,    //
input          I_all_packet_out_num_clr       ,    //

output[3:0]    O_gmii_txc                     ,    //
output[31:0]   O_gmii_data                    ,    //

output[15:0]   O_pla_vlan_id                  ,    //
output         O_pla_vlan_ind                 ,    //

output[6:0]    O_fifo_usedw                   ,    //
output[15:0]   O_1588_packet_in_num           ,    //
output[15:0]   O_1588_packet_out_num          ,    //
output[15:0]   O_all_packet_in_num            ,    //
output[15:0]   O_all_packet_out_num           ,    //
output[63:0]   O_state                        
);

parameter      C_GMII_CHECK_IDLE                 = 8'b00000001   ,                                  //0x1
               C_GMII_CHECK_PRE                  = 8'b00000010   ,                                  //0x2
               C_GMII_CHECK_MAC                  = 8'b00000100   ,                                  //0x4
               C_GMII_CHECK_TYPE                 = 8'b00001000   ,                                  //0x8
               C_GMII_CHECK_IP                   = 8'b00010000   ,                                  //0x10
               C_GMII_CHECK_UDP                  = 8'b00100000   ,                                  //0x20
               C_GMII_CHECK_PTP                  = 8'b01000000   ,                                  //0x40
               C_GMII_CHECK_DATA                 = 8'b10000000   ;                                  //0x80

parameter      C_GMII_CHECK_IDLE_POS             = 4'd0 , 
               C_GMII_CHECK_PRE_POS              = 4'd1 , 
               C_GMII_CHECK_MAC_POS              = 4'd2 ,
               C_GMII_CHECK_TYPE_POS             = 4'd3 ,
               C_GMII_CHECK_IP_POS               = 4'd4 ,
               C_GMII_CHECK_UDP_POS              = 4'd5 ,
               C_GMII_CHECK_PTP_POS              = 4'd6 ,
               C_GMII_CHECK_DATA_POS             = 4'd7 ;

parameter      C_HEAD_VLAN_TYPE                  = 16'h8100 ,
               C_IP_TYPE                         = 16'h0800 ,
               C_MAC_PTP_TYPE                    = 16'h88f7 ,
               C_TAIL_VLAN_TYPE                  = 16'h8100 ;
//before fifo
reg [31:0]     S_in_gmii_data               = 32'h0 ;
reg [31:0]     S_in_gmii_data_d1            = 32'h0 ;
reg [31:0]     S_in_gmii_data_d2            = 32'h0 ;
reg [31:0]     S_in_gmii_data_d3            = 32'h0 ;

reg [3:0]      S_in_gmii_txc                = 4'h0  ;
reg [3:0]      S_in_gmii_txc_d1             = 4'h0  ;
reg [3:0]      S_in_gmii_txc_d2             = 4'h0  ;
reg [3:0]      S_in_gmii_txc_d3             = 4'h0  ;

reg [3:0]      S_check_length_cnt           = 4'd0  ;
reg [8:0]      S_in_gmii_cnt                = 9'd0  ;
//state machine
reg [7:0]      S_gmii_check_state           = 8'h0  ;
reg [7:0]      S_gmii_check_state_next      = 8'h0  ;

reg [31:0]     S_in_gmii_type               = 32'h0 ;
reg [31:0]     S_in_gmii_tail_type          = 32'h0 ;
reg [31:0]     S_head_vlan                  = 32'h0 ;
reg            S_head_vlan_flag             = 1'b0  ;
reg            S_head_vlan_flag_d1          = 1'b0  ;
reg            S_check_mac_ptp_flag         = 1'b0  ;
reg            S_check_udp_flag             = 1'b0  ;
reg            S_check_udp_ptp_flag         = 1'b0  ;
reg            S_sync_dreq_en               = 1'b0  ;
reg            S_tail_vlan_flag             = 1'b0  ;
reg [31:0]     S_tail_vlan                  = 32'h0 ;
reg [15:0]     S_slice_id                   = 16'h0 ;
reg [15:0]     S_slice_len                  = 16'h0 ;

reg [15:0]     S_pla_vlan_id                = 16'h0 ;      
reg            S_pla_vlan_ind               = 1'b0  ;

reg [31:0]     S_head_vlan_lock             = 32'h0 ;
reg            S_head_vlan_flag_lock        = 1'h0  ;
reg            S_check_mac_ptp_flag_lock    = 1'h0  ;
reg            S_check_udp_ptp_flag_lock    = 1'h0  ;
reg            S_sync_dreq_en_lock          = 1'h0  ;
reg [31:0]     S_tail_vlan_lock             = 32'h0 ;
reg            S_tail_vlan_flag_lock        = 1'h0  ;
reg [15:0]     S_slice_id_lock              = 16'h0 ;
reg [15:0]     S_slice_len_lock             = 16'h0 ;
reg [47:0]     S_pla_slice_da_lock          = 48'h0 ;
reg [47:0]     S_pla_slice_sa_lock          = 48'h0 ;
reg            S_ptp_flag                   = 1'b0  ;
reg            S_tail_vlan_flag_lock_out    = 1'b0  ;
reg            S_ptp_flag_out               = 1'b0  ;

reg [35:0]     S_fifo_wr_data               = 36'h0 ;
reg            S_fifo_rd_en                 = 1'b0  ;
reg            S_fifo_wr_en                 = 1'b0  ;
wire[35:0]     S_fifo_rd_data                       ;
wire[6:0]      S_fifo_usedw                         ;
reg [6:0]      S_fifo_usedw_d               = 7'h0  ;
reg [6:0]      S_fifo_usedw_dd              = 7'h0  ;
//after fifo
reg [31:0]     S_fifo_out_data              = 32'h0 ;
reg [31:0]     S_fifo_out_data_d1           = 32'h0 ;
reg [31:0]     S_fifo_out_data_d2           = 32'h0 ;
reg [3:0]      S_fifo_out_txc               = 4'h0  ;
reg [3:0]      S_fifo_out_txc_d1            = 4'h0  ;
reg [3:0]      S_fifo_out_txc_d2            = 4'h0  ;
//after fifo, shift 16bits
reg [31:0]     S_fifo_out_reform_data       = 32'h0 ;
reg [31:0]     S_fifo_out_reform_data_d1    = 32'h0 ;
reg [31:0]     S_fifo_out_reform_data_d2    = 32'h0 ;

//output data
reg [31:0]     S_out_gmii_data              = 32'h0 ;
reg [31:0]     S_out_gmii_data_d1           = 32'h0 ;
reg [31:0]     S_out_gmii_data_d2           = 32'h0 ;
reg [31:0]     S_out_gmii_data_d3           = 32'h0 ;
reg [31:0]     S_out_gmii_data_d4           = 32'h0 ;
reg [31:0]     S_out_gmii_data_d5           = 32'h0 ;
reg [31:0]     S_out_gmii_data_d6           = 32'h0 ;

reg [3:0]      S_out_gmii_txc               = 4'h0  ;
reg [3:0]      S_out_gmii_txc_d1            = 4'h0  ;
reg [3:0]      S_out_gmii_txc_d2            = 4'h0  ;
reg [3:0]      S_out_gmii_txc_d3            = 4'h0  ;
reg [3:0]      S_out_gmii_txc_d4            = 4'h0  ;
reg [3:0]      S_out_gmii_txc_d5            = 4'h0  ;
reg [3:0]      S_out_gmii_txc_d6            = 4'h0  ;

reg [8:0]      S_out_gmii_cnt               = 9'd0  ;
reg [8:0]      S_out_gmii_cnt_d1            = 9'd0  ;
reg [8:0]      S_out_gmii_cnt_d2            = 9'd0  ;
reg [8:0]      S_out_gmii_cnt_d3            = 9'd0  ;
reg [8:0]      S_out_gmii_cnt_d4            = 9'd0  ;
reg [8:0]      S_out_gmii_cnt_d5            = 9'd0  ;
reg [8:0]      S_out_gmii_cnt_d6            = 9'd0  ;
//out crc
reg            S_out_gmii_crc_en            = 1'b1  ;
wire[31:0]     S_out_gmii_data_crc                  ;
reg [31:0]     S_out_gmii_data_crc_d1       = 32'h0 ;

reg [15:0]     S_1588_packet_in_num         = 16'h0 ;
reg [15:0]     S_1588_packet_out_num        = 16'h0 ;
reg [15:0]     S_all_packet_in_num          = 16'h0 ;
reg [15:0]     S_all_packet_out_num         = 16'h0 ;

//test start
reg [7:0]      S_gmii_check_state_buf1      = 8'h0  ;
reg [7:0]      S_gmii_check_state_buf2      = 8'h0  ;
reg [63:0]     S_gmii_check_state_test      = 64'h0 ;
reg            S_head_vlan_flag_d           = 1'b0  ;
reg            S_check_mac_ptp_flag_d       = 1'b0  ;
reg            S_check_udp_ptp_flag_d       = 1'b0  ;
reg            S_sync_dreq_en_d             = 1'b0  ;
reg            S_head_vlan_flag_lock_d      = 1'b0  ;
reg            S_check_mac_ptp_flag_lock_d  = 1'b0  ;
reg            S_check_udp_ptp_flag_lock_d  = 1'b0  ;
reg            S_sync_dreq_en_lock_d        = 1'b0  ;
reg            S_1588_packet_in_num_clr     = 1'b0  ;
reg            S_1588_packet_out_num_clr    = 1'b0  ;
reg            S_all_packet_in_num_clr      = 1'b0  ;
reg            S_all_packet_out_num_clr     = 1'b0  ;
//test end

//signal capture start
(*mark_debug ="true"*)reg [31:0]     M_in_gmii_data               = 32'h0 ;
(*mark_debug ="true"*)reg [3:0]      M_in_gmii_txc                = 4'h0  ;
(*mark_debug ="true"*)reg [3:0]      M_check_length_cnt           = 4'd0  ;
(*mark_debug ="true"*)reg [8:0]      M_in_gmii_cnt                = 9'd0  ;
(*mark_debug ="true"*)reg [7:0]      M_gmii_check_state_next      = 8'h0  ;
(*mark_debug ="true"*)reg            M_head_vlan_flag             = 1'b0  ;
(*mark_debug ="true"*)reg            M_head_vlan_flag_d1          = 1'b0  ;
(*mark_debug ="true"*)reg            M_check_mac_ptp_flag         = 1'b0  ;
(*mark_debug ="true"*)reg            M_check_udp_flag             = 1'b0  ;
(*mark_debug ="true"*)reg            M_check_udp_ptp_flag         = 1'b0  ;
(*mark_debug ="true"*)reg            M_sync_dreq_en               = 1'b0  ;
(*mark_debug ="true"*)reg            M_tail_vlan_flag             = 1'b0  ;
(*mark_debug ="true"*)reg [31:0]     M_tail_vlan                  = 32'h0 ;
(*mark_debug ="true"*)reg            M_pla_vlan_ind               = 1'b0  ;
(*mark_debug ="true"*)reg            M_check_mac_ptp_flag_lock    = 1'h0  ;
(*mark_debug ="true"*)reg            M_check_udp_ptp_flag_lock    = 1'h0  ;
(*mark_debug ="true"*)reg [15:0]     M_slice_id_lock              = 16'h0 ;
(*mark_debug ="true"*)reg [47:0]     M_pla_slice_sa_lock          = 48'h0 ;
(*mark_debug ="true"*)reg            M_ptp_flag                   = 1'b0  ;
(*mark_debug ="true"*)reg [6:0]      M_fifo_usedw_d               = 7'h0  ;
(*mark_debug ="true"*)reg [6:0]      M_fifo_usedw_dd              = 7'h0  ;
(*mark_debug ="true"*)reg [31:0]     M_fifo_out_data              = 32'h0 ;
(*mark_debug ="true"*)reg [3:0]      M_fifo_out_txc               = 4'h0  ;
(*mark_debug ="true"*)reg [31:0]     M_fifo_out_reform_data_d2    = 32'h0 ;
(*mark_debug ="true"*)reg [31:0]     M_out_gmii_data              = 32'h0 ;
(*mark_debug ="true"*)reg [31:0]     M_out_gmii_data_d6           = 32'h0 ;
(*mark_debug ="true"*)reg [3:0]      M_out_gmii_txc               = 4'h0  ;
(*mark_debug ="true"*)reg [3:0]      M_out_gmii_txc_d6            = 4'h0  ;
(*mark_debug ="true"*)reg            M_out_gmii_crc_en            = 1'b1  ;
(*mark_debug ="true"*)reg [31:0]     M_out_gmii_data_crc_d1       = 32'h0 ;
(*mark_debug ="true"*)reg            M_fifo_rd_en                 = 1'b1  ;
(*mark_debug ="true"*)reg            M_fifo_wr_en                 = 1'b1  ;
(*mark_debug ="true"*)reg            M_fpga_reset                 = 1'b0  ;

//signal capture end


assign  O_pla_vlan_id           = S_pla_vlan_id     ;
assign  O_pla_vlan_ind          = S_pla_vlan_ind    ;
        
assign  O_gmii_txc              = S_out_gmii_txc_d6 ;
assign  O_gmii_data             = S_out_gmii_data_d6;

assign  O_1588_packet_in_num    = S_1588_packet_in_num  ;
assign  O_1588_packet_out_num   = S_1588_packet_out_num ;
assign  O_all_packet_in_num     = S_all_packet_in_num   ;
assign  O_all_packet_out_num    = S_all_packet_out_num  ;

//test start
assign         O_state          = S_gmii_check_state_test   ;
assign         O_fifo_usedw     = S_fifo_usedw_d            ;
//test end


always@(posedge I_sys_312m_clk)
begin
    S_in_gmii_data      <= I_gmii_data          ;
    S_in_gmii_data_d1   <= S_in_gmii_data       ;
    S_in_gmii_data_d2   <= S_in_gmii_data_d1    ;
    S_in_gmii_data_d3   <= S_in_gmii_data_d2    ;
end
always@(posedge I_sys_312m_clk)
begin
    S_in_gmii_txc       <= I_gmii_txc           ;
    S_in_gmii_txc_d1    <= S_in_gmii_txc        ;
    S_in_gmii_txc_d2    <= S_in_gmii_txc_d1     ;
    S_in_gmii_txc_d3    <= S_in_gmii_txc_d2     ;
end

always@(posedge I_sys_312m_clk)
begin
    S_gmii_check_state     <= S_gmii_check_state_next         ;
end

always@(*)
begin
    if(S_gmii_check_state[C_GMII_CHECK_IDLE_POS])
        begin
            if(S_in_gmii_txc == 4'h8)
                begin
                    S_gmii_check_state_next = C_GMII_CHECK_PRE  ;
                end
            else
                begin
                    S_gmii_check_state_next = C_GMII_CHECK_IDLE  ;
                end
        end
    else if(S_gmii_check_state[C_GMII_CHECK_PRE_POS])
        begin
            if(|S_in_gmii_txc)
                        begin
                            S_gmii_check_state_next = C_GMII_CHECK_IDLE  ;
                        end
            else if(S_check_length_cnt == 4'h1)
                begin
                    S_gmii_check_state_next = C_GMII_CHECK_MAC  ;
                end
            else
                begin
                    S_gmii_check_state_next = C_GMII_CHECK_PRE  ;
                end
        end
    else if(S_gmii_check_state[C_GMII_CHECK_MAC_POS])
        begin
            if(|S_in_gmii_txc)
                begin
                    S_gmii_check_state_next = C_GMII_CHECK_IDLE  ;
                end
            else if(S_check_length_cnt == 4'd2)
                begin
                    S_gmii_check_state_next = C_GMII_CHECK_TYPE  ;
                end
            else
                begin
                    S_gmii_check_state_next = C_GMII_CHECK_MAC  ;
                end
        end
    else if(S_gmii_check_state[C_GMII_CHECK_TYPE_POS])
        begin
            if(|S_in_gmii_txc)
                begin
                    S_gmii_check_state_next = C_GMII_CHECK_IDLE  ;
                end
            else if(S_in_gmii_data_d1[31:16] == C_HEAD_VLAN_TYPE)
                begin
                    S_gmii_check_state_next = C_GMII_CHECK_TYPE  ;
                end
            else if(S_in_gmii_data_d1[31:16] == C_IP_TYPE)
                begin
                    S_gmii_check_state_next = C_GMII_CHECK_IP  ;
                end
            else if(S_in_gmii_data_d1[31:16] == C_MAC_PTP_TYPE)
                begin
                    S_gmii_check_state_next = C_GMII_CHECK_PTP  ;
                end
            else
                begin
                    S_gmii_check_state_next = C_GMII_CHECK_DATA  ;
                end
        end
    else if(S_gmii_check_state[C_GMII_CHECK_IP_POS])
        begin
            if(|S_in_gmii_txc)
                begin
                    S_gmii_check_state_next = C_GMII_CHECK_IDLE  ;
                end
            else if(S_check_length_cnt == 4'd4)
                begin
                    if(S_check_udp_flag)
                        begin
                            S_gmii_check_state_next = C_GMII_CHECK_UDP  ;
                        end
                    else
                        begin
                            S_gmii_check_state_next = C_GMII_CHECK_DATA  ;
                        end
                end
            else
                begin
                    S_gmii_check_state_next = C_GMII_CHECK_IP  ;
                end
        end
    else if(S_gmii_check_state[C_GMII_CHECK_UDP_POS])
        begin
            if(|S_in_gmii_txc)
                begin
                    S_gmii_check_state_next = C_GMII_CHECK_IDLE  ;
                end
            else if(S_check_length_cnt == 4'd1)
                begin
                    if(S_check_udp_ptp_flag)
                        begin
                            S_gmii_check_state_next = C_GMII_CHECK_PTP  ;
                        end
                    else
                        begin
                            S_gmii_check_state_next = C_GMII_CHECK_DATA  ;
                        end
                end
            else
                begin
                    S_gmii_check_state_next = C_GMII_CHECK_UDP  ;
                end
        end
    else if(S_gmii_check_state[C_GMII_CHECK_PTP_POS])
        begin
            if(|S_in_gmii_txc)
                begin
                    S_gmii_check_state_next = C_GMII_CHECK_IDLE  ;
                end
            else if(S_check_length_cnt == 4'd14)
                begin
                    S_gmii_check_state_next = C_GMII_CHECK_DATA  ;
                end
            else
                begin
                    S_gmii_check_state_next = C_GMII_CHECK_PTP  ;
                end
        end
    else if(S_gmii_check_state[C_GMII_CHECK_DATA_POS])
        begin
            if(|S_in_gmii_txc)
                begin
                    S_gmii_check_state_next = C_GMII_CHECK_IDLE  ;
                end
            else
                begin
                    S_gmii_check_state_next = C_GMII_CHECK_DATA  ;
                end
        end
    else
        begin
            S_gmii_check_state_next = C_GMII_CHECK_IDLE  ;
        end
end

always @ (posedge I_sys_312m_clk)
begin
    if(S_gmii_check_state[C_GMII_CHECK_PRE_POS])
        begin
            if(S_check_length_cnt == 4'd1)
                begin
                    S_check_length_cnt <= 4'd0  ;
                end
            else
                begin
                    S_check_length_cnt <= S_check_length_cnt + 1'b1  ;
                end
        end
    else if(S_gmii_check_state[C_GMII_CHECK_MAC_POS])
        begin
            if(S_check_length_cnt == 4'd2)
                begin
                    S_check_length_cnt <= 4'd0  ;
                end
            else
                begin
                    S_check_length_cnt <= S_check_length_cnt + 1'b1  ;
                end
        end
    else if(S_gmii_check_state[C_GMII_CHECK_IP_POS])
        begin
            if(S_check_length_cnt == 4'd4)
                begin
                    S_check_length_cnt <= 4'd0  ;
                end
            else
                begin
                    S_check_length_cnt <= S_check_length_cnt + 1'b1  ;
                end
        end
    else if(S_gmii_check_state[C_GMII_CHECK_UDP_POS])
        begin
            if(S_check_length_cnt == 4'd1)
                begin
                    S_check_length_cnt <= 4'd0  ;
                end
            else
                begin
                    S_check_length_cnt <= S_check_length_cnt + 1'b1  ;
                end
        end
    else if(S_gmii_check_state[C_GMII_CHECK_PTP_POS])
        begin
            if(S_check_length_cnt == 4'd14)
                begin
                    S_check_length_cnt <= 4'd0  ;
                end
            else
                begin
                    S_check_length_cnt <= S_check_length_cnt + 1'b1  ;
                end
        end
    else
        begin
            S_check_length_cnt <= S_check_length_cnt  ;
        end
end
always@(posedge I_sys_312m_clk)
begin
    if(S_gmii_check_state[C_GMII_CHECK_PRE_POS])
        begin
            S_in_gmii_cnt  <= S_in_gmii_cnt + 9'd1   ;
        end
    else if(|S_in_gmii_txc)
        begin
            S_in_gmii_cnt  <= 9'd0   ;
        end
    else if((|S_in_gmii_cnt) != 1'b0)
        begin
            S_in_gmii_cnt  <= S_in_gmii_cnt + 9'd1   ;
        end
end

always@(posedge I_sys_312m_clk)
begin
    if(S_gmii_check_state[C_GMII_CHECK_TYPE_POS])
        begin
            S_in_gmii_type  <= S_in_gmii_data_d1   ;
        end
    else
        begin
            S_in_gmii_type  <= S_in_gmii_type   ;
        end
end

always@(posedge I_sys_312m_clk)
begin
    if(S_in_gmii_cnt == 9'd70)
        begin
            S_head_vlan       <= S_head_vlan      ;
            S_head_vlan_flag  <= 1'b0             ;
        end
    else if(S_in_gmii_type[31:16] == C_HEAD_VLAN_TYPE)
        begin
            S_head_vlan       <= S_in_gmii_type   ;
            S_head_vlan_flag  <= 1'b1             ;
        end
    else
        begin
            S_head_vlan       <= S_head_vlan      ;
            S_head_vlan_flag  <= S_head_vlan_flag ;
        end
end

always@(posedge I_sys_312m_clk)
begin
    if(S_gmii_check_state[C_GMII_CHECK_TYPE_POS])
        begin
            if(S_in_gmii_data_d1[31:16] == C_MAC_PTP_TYPE)
                begin
                    S_check_mac_ptp_flag   <= 1'b1 ;
                end
            else
                begin
                    S_check_mac_ptp_flag   <= 1'b0 ;
                end
        end
    else if(S_in_gmii_cnt == 9'd70)
        begin
            S_check_mac_ptp_flag  <= 1'b0   ;
        end
    else
        begin
            S_check_mac_ptp_flag  <= S_check_mac_ptp_flag   ;
        end
end

always@(posedge I_sys_312m_clk)
begin
    if(S_gmii_check_state[C_GMII_CHECK_IP_POS])
        begin
            if(S_check_length_cnt == 4'd1)
                begin
                    if(S_in_gmii_data_d1[7:0] == 8'h11)
                        begin
                            S_check_udp_flag   <= 1'b1 ;
                        end
                    else
                        begin
                            S_check_udp_flag   <= 1'b0 ;
                        end
                end
            else
                begin
                    S_check_udp_flag   <= S_check_udp_flag ;
                end
        end
    else if(S_in_gmii_cnt == 9'd70)
        begin
            S_check_udp_flag  <= 1'b0   ;
        end
    else
        begin
            S_check_udp_flag  <= S_check_udp_flag   ;
        end
end

always@(posedge I_sys_312m_clk)
begin
    if(S_gmii_check_state[C_GMII_CHECK_UDP_POS])
        begin
            if(S_check_length_cnt == 4'd0)
                begin
                    if(S_in_gmii_data_d1[31:16] == 16'h13f)
                        begin
                            S_check_udp_ptp_flag   <= 1'b1 ;
                        end
                    else
                        begin
                            S_check_udp_ptp_flag   <= 1'b0 ;
                        end
                end
            else
                begin
                    S_check_udp_ptp_flag   <= S_check_udp_ptp_flag ;
                end
        end
    else if(S_in_gmii_cnt == 9'd70)
        begin
            S_check_udp_ptp_flag  <= 1'b0   ;
        end
    else
        begin
            S_check_udp_ptp_flag  <= S_check_udp_ptp_flag   ;
        end
end

always@(posedge I_sys_312m_clk)
begin
    if(S_gmii_check_state[C_GMII_CHECK_PTP_POS])
        begin
            if(S_check_length_cnt == 4'd0)
                begin
                    if(S_in_gmii_data_d2[15:9] == 7'h0)                                                //sync & delay_req
                        begin
                            S_sync_dreq_en   <= 1'b1 ;
                        end
                    else
                        begin
                            S_sync_dreq_en   <= 1'b0 ;
                        end
                end
            else
                begin
                    S_sync_dreq_en   <= S_sync_dreq_en ;
                end
        end
    else if(S_in_gmii_cnt == 9'd70)
        begin
            S_sync_dreq_en  <= 1'b0   ;
        end
    else
        begin
            S_sync_dreq_en   <= S_sync_dreq_en ;
        end
end

always@(posedge I_sys_312m_clk)                                                                     
begin
    if(S_in_gmii_cnt == 9'd68)
        begin
            S_in_gmii_tail_type <= {S_in_gmii_data_d1[15:0],S_in_gmii_data[31:16]}   ;
        end
    else
        begin
            S_in_gmii_tail_type <= S_in_gmii_tail_type  ;
        end
end

always@(posedge I_sys_312m_clk)
begin
    if(S_in_gmii_cnt == 9'd70)
        begin
            S_tail_vlan       <= S_tail_vlan      ;
            S_tail_vlan_flag  <= 1'b0             ;
        end
    else if(S_in_gmii_cnt == 9'd69)
        begin
            if(S_in_gmii_tail_type[31:16] == C_TAIL_VLAN_TYPE)
                begin
                    S_tail_vlan       <= S_in_gmii_tail_type   ;
                    S_tail_vlan_flag  <= 1'b1                  ;
                end
            else
                begin
                    S_tail_vlan       <= S_tail_vlan   ;
                    S_tail_vlan_flag  <= 1'b0          ;
                end
        end
    else
        begin
            S_tail_vlan       <= S_tail_vlan      ;
            S_tail_vlan_flag  <= S_tail_vlan_flag ;
        end
end

always@(posedge I_sys_312m_clk)
begin
    if(S_gmii_check_state[C_GMII_CHECK_DATA_POS])
        begin
            if(S_in_gmii_cnt == 9'd69)
                begin
                    S_slice_id    <= S_in_gmii_data_d1[15:0] ;
                    S_slice_len   <= S_in_gmii_data[31:16]   ;
                end
            else
                begin
                    S_slice_id    <= S_slice_id  ;
                    S_slice_len   <= S_slice_len ;
                end
        end
    else
        begin
            S_slice_id    <= S_slice_id  ;
            S_slice_len   <= S_slice_len ;
        end
end

//check info lock
always@(posedge I_sys_312m_clk)
begin
    if((|S_in_gmii_txc != 4'h0) && (S_in_gmii_txc_d1 == 4'h0))   //S_in_gmii_cnt == 9'd70
        begin
            S_head_vlan_lock            <= S_head_vlan             ;
            S_head_vlan_flag_lock       <= S_head_vlan_flag        ;
            S_check_mac_ptp_flag_lock   <= S_check_mac_ptp_flag    ;
            S_check_udp_ptp_flag_lock   <= S_check_udp_ptp_flag    ;
            S_sync_dreq_en_lock         <= S_sync_dreq_en          ;
            S_tail_vlan_lock            <= S_tail_vlan             ;
            S_tail_vlan_flag_lock       <= S_tail_vlan_flag        ;
            S_slice_id_lock             <= S_slice_id              ;
            S_slice_len_lock            <= S_slice_len             ;
            S_pla_slice_da_lock         <= I_pla_slice_da          ;
            S_pla_slice_sa_lock         <= I_pla_slice_sa          ;
        end
    else
        begin
            S_head_vlan_lock            <= S_head_vlan_lock             ;
            S_head_vlan_flag_lock       <= S_head_vlan_flag_lock        ;
            S_check_mac_ptp_flag_lock   <= S_check_mac_ptp_flag_lock    ;
            S_check_udp_ptp_flag_lock   <= S_check_udp_ptp_flag_lock    ;
            S_sync_dreq_en_lock         <= S_sync_dreq_en_lock          ;
            S_tail_vlan_lock            <= S_tail_vlan_lock             ;
            S_tail_vlan_flag_lock       <= S_tail_vlan_flag_lock        ;
            S_slice_id_lock             <= S_slice_id_lock              ;
            S_slice_len_lock            <= S_slice_len_lock             ;
            S_pla_slice_da_lock         <= S_pla_slice_da_lock          ;
            S_pla_slice_sa_lock         <= S_pla_slice_sa_lock          ;
        end
end

always@(posedge I_sys_312m_clk)                                                                     //20150721modified for origin data
begin
    if(S_out_gmii_txc == 4'h8)
        begin
            S_tail_vlan_flag_lock_out   <= S_tail_vlan_flag_lock    ;
        end
    else
        begin
            S_tail_vlan_flag_lock_out   <= S_tail_vlan_flag_lock_out    ;
        end
end

always@(posedge I_sys_312m_clk)
begin
    if(S_out_gmii_cnt == 9'd0)
        begin
            S_ptp_flag  <= (S_head_vlan_flag_lock) && (S_check_mac_ptp_flag_lock | S_check_udp_ptp_flag_lock) && (S_sync_dreq_en_lock)  ;
        end
    else
        begin
            S_ptp_flag  <= S_ptp_flag   ;
        end
end

always@(posedge I_sys_312m_clk)                                                                     //20150721modified for origin data
begin
    if(S_out_gmii_cnt_d6 == 9'd0)
        begin
            S_ptp_flag_out   <= S_ptp_flag    ;
        end
    else
        begin
            S_ptp_flag_out   <= S_ptp_flag_out    ;
        end
end
//output head_vlan, input slice_da/sa
always@(posedge I_sys_312m_clk)
begin
    S_head_vlan_flag_d1     <= S_head_vlan_flag     ;
end

always@(posedge I_sys_312m_clk)
begin
    if((~S_head_vlan_flag_d1) && (S_head_vlan_flag))
        begin
            S_pla_vlan_id   <= S_head_vlan[15:0]    ;
            S_pla_vlan_ind  <= S_head_vlan_flag     ;
        end
    else
        begin
            S_pla_vlan_id   <= S_pla_vlan_id     ;
            S_pla_vlan_ind  <= 1'b0    ;
        end
end

fifo_128_36 U0_fifo_128_36(
.aclr   (I_fpga_reset  ),
.clock  (I_sys_312m_clk),
.data   (S_fifo_wr_data),
.rdreq  (S_fifo_rd_en  ),
.wrreq  (S_fifo_wr_en  ),
.q      (S_fifo_rd_data),
.usedw  (S_fifo_usedw  )
);
always@(posedge I_sys_312m_clk)
begin
    if(I_fpga_reset)
        begin
            S_fifo_usedw_dd  <= 7'h0    ;
        end
    else
        begin
            S_fifo_usedw_dd  <= S_fifo_usedw ;
        end
end

always@(posedge I_sys_312m_clk)
begin
    if(I_fpga_reset)
        begin
            S_fifo_usedw_d  <= 7'h0    ;
        end
    else if(S_fifo_usedw_d == 7'd71)
        begin
            S_fifo_usedw_d  <= S_fifo_usedw_d   ;
        end
    else if(S_fifo_wr_en)
        begin
            S_fifo_usedw_d  <= S_fifo_usedw_d + 7'h1 ;
        end
    else
        begin
            S_fifo_usedw_d  <= S_fifo_usedw_d   ;
        end
end

always@(posedge I_sys_312m_clk)
begin
    if(I_fpga_reset)
        begin
            S_fifo_wr_data  <= 36'hf07070707    ;
        end
    else
        begin
            S_fifo_wr_data  <= {S_in_gmii_txc_d2,S_in_gmii_data_d2} ;
        end
end

always@(posedge I_sys_312m_clk)
begin
    if(I_fpga_reset)
        begin
            S_fifo_wr_en    <= 1'b0 ;
        end
    else
        begin
            S_fifo_wr_en    <= 1'b1 ;
        end
end

always@(posedge I_sys_312m_clk)
begin
    if(I_fpga_reset)
        begin
            S_fifo_rd_en <= 1'b0  ;
        end
    else if(S_fifo_usedw_dd >= 7'd69)
        begin
            S_fifo_rd_en <= 1'b1  ;
        end
    else
        begin
            S_fifo_rd_en <= S_fifo_rd_en  ;
        end
end

always@(posedge I_sys_312m_clk)
begin
    begin
        S_fifo_out_data     <= S_fifo_rd_data[31:0]  ;
        S_fifo_out_data_d1  <= S_fifo_out_data       ;
        S_fifo_out_data_d2  <= S_fifo_out_data_d1    ;
        S_fifo_out_txc      <= S_fifo_rd_data[35:32] ;
        S_fifo_out_txc_d1   <= S_fifo_out_txc        ;
        S_fifo_out_txc_d2   <= S_fifo_out_txc_d1     ;
    end
end

always@(posedge I_sys_312m_clk)
begin
    S_fifo_out_reform_data      <= {S_fifo_out_data_d2[15:0],S_fifo_out_data_d1[31:16]};
    S_fifo_out_reform_data_d1   <= S_fifo_out_reform_data      ;
    S_fifo_out_reform_data_d2   <= S_fifo_out_reform_data_d1   ;
end

always@(posedge I_sys_312m_clk)
begin
    if(S_out_gmii_txc == 4'h8)
        begin
            S_out_gmii_cnt  <= S_out_gmii_cnt + 9'd1   ;
        end
    else if(|S_out_gmii_txc == 1'b1)
        begin
            S_out_gmii_cnt  <= 9'd0   ;
        end
    else if((|S_out_gmii_cnt) != 1'b0)
        begin
            S_out_gmii_cnt  <= S_out_gmii_cnt + 9'd1   ;
        end
    else
        begin
            S_out_gmii_cnt  <= 9'd0   ;
        end
end

//reform output txc & data
always@(posedge I_sys_312m_clk)
begin
    S_out_gmii_txc_d1   <= S_out_gmii_txc       ;
    S_out_gmii_txc_d2   <= S_out_gmii_txc_d1    ;
    S_out_gmii_txc_d3   <= S_out_gmii_txc_d2    ;
    S_out_gmii_txc_d4   <= S_out_gmii_txc_d3    ;
    S_out_gmii_txc_d5   <= S_out_gmii_txc_d4    ;
    S_out_gmii_txc_d6   <= S_out_gmii_txc_d5    ;
    
    S_out_gmii_data_d1  <= S_out_gmii_data      ;
    S_out_gmii_data_d2  <= S_out_gmii_data_d1   ;
    S_out_gmii_data_d3  <= S_out_gmii_data_d2   ;
    S_out_gmii_data_d4  <= S_out_gmii_data_d3   ;
    S_out_gmii_data_d5  <= S_out_gmii_data_d4   ;
    
    S_out_gmii_cnt_d1   <= S_out_gmii_cnt       ;
    S_out_gmii_cnt_d2   <= S_out_gmii_cnt_d1    ;
    S_out_gmii_cnt_d3   <= S_out_gmii_cnt_d2    ;
    S_out_gmii_cnt_d4   <= S_out_gmii_cnt_d3    ;
    S_out_gmii_cnt_d5   <= S_out_gmii_cnt_d4    ;
    S_out_gmii_cnt_d6   <= S_out_gmii_cnt_d5    ;
end

always@(posedge I_sys_312m_clk)
begin
    if(S_out_gmii_cnt < 9'd1)
        begin
            S_out_gmii_txc      <= S_fifo_out_txc       ;
        end
    else if(S_ptp_flag)
        begin
            if(S_out_gmii_cnt == 9'd69)
                begin
                    S_out_gmii_txc <= 4'h3    ;
                end
            else if(S_out_gmii_cnt == 9'd70)
                begin
                    S_out_gmii_txc <= 4'hf    ;
                end
            else
                begin
                    S_out_gmii_txc <= S_fifo_out_txc    ;
                end
        end
    else
        begin
            S_out_gmii_txc <= S_fifo_out_txc    ;
        end
end

always@(posedge I_sys_312m_clk)
begin
    if(S_out_gmii_cnt < 9'd1)
        begin
            S_out_gmii_data <= S_fifo_out_data  ;
        end
    else if(S_ptp_flag)
        begin
            if(S_out_gmii_cnt == 9'd1)
                begin
                    S_out_gmii_data <= S_pla_slice_da_lock[47:16]  ;
                end
            else if(S_out_gmii_cnt == 9'd2)
                begin
                    S_out_gmii_data <= {S_pla_slice_da_lock[15:0],S_pla_slice_sa_lock[47:32]}  ;
                end
            else if(S_out_gmii_cnt == 9'd3)
                begin
                    S_out_gmii_data <= S_pla_slice_sa_lock[31:0]  ;
                end
            else if(S_out_gmii_cnt == 9'd4)
                begin
                    S_out_gmii_data <= {S_slice_id_lock,16'h55d5}  ;
                end
            else if(S_out_gmii_cnt == 9'd5)
                begin
                    S_out_gmii_data <= {S_slice_len_lock,S_fifo_out_reform_data_d2[15:0]}  ;
                end
            else if(S_out_gmii_cnt <= 9'd7)
                begin
                    S_out_gmii_data <= S_fifo_out_reform_data_d2  ;
                end
            else if(S_out_gmii_cnt == 9'd8)
                begin
                    if(S_tail_vlan_flag_lock_out)                                                   //20150721modified for origin data
                        begin
                            S_out_gmii_data <= {S_fifo_out_reform_data_d2[31:16],S_tail_vlan_lock[31:16]}  ;
                        end
                    else
                        begin
                            S_out_gmii_data <= {S_fifo_out_reform_data_d2[31:16],S_fifo_out_reform_data_d1[15:0]}    ;
                        end
                end
            else if(S_out_gmii_cnt == 9'd9)
                begin
                    if(S_tail_vlan_flag_lock_out)                                                   //20150721modified for origin data
                        begin
                            S_out_gmii_data <= {S_tail_vlan_lock[15:0],S_fifo_out_reform_data_d2[15:0]}  ;
                        end
                    else
                        begin
                            S_out_gmii_data <= S_fifo_out_reform_data_d1    ;
                        end
                end
            else if(S_out_gmii_cnt < 9'd69)
                if(S_tail_vlan_flag_lock_out)                                                       //20150721modified for origin data
                    begin
                        S_out_gmii_data <= S_fifo_out_reform_data_d2    ;
                    end
                else
                    begin
                        S_out_gmii_data <= S_fifo_out_reform_data_d1    ;
                    end
//            else if(S_out_gmii_cnt < 9'd69)                                                       //20150721modified for origin data
//                begin
//                    S_out_gmii_data <= 32'h0    ;                                                 
//                end
            else if(S_out_gmii_cnt == 9'd69)                                                        //20150721modified for origin data
                begin
                    if(S_tail_vlan_flag_lock_out)
                        begin
                            S_out_gmii_data <= {S_fifo_out_reform_data_d2[31:16],16'hfd07}    ;
                        end
                    else
                        begin
                            S_out_gmii_data <= {S_fifo_out_reform_data_d1[31:16],16'hfd07}    ;
                        end
                end
            else if(S_out_gmii_cnt == 9'd70)
                begin
                    S_out_gmii_data <= 32'h07070707    ;
                end
//            else                                                                                  //20150721modified for origin data
//                begin
//                    S_out_gmii_data <= S_fifo_out_reform_data_d2    ;
//                end
        end
    else
        begin
            S_out_gmii_data <= S_fifo_out_data    ;
        end
end

//always@(posedge I_sys_312m_clk)
//begin
//    if(S_out_gmii_txc == 4'h8)
//        begin
//            S_out_gmii_crc_en   <= 1'b0 ;
//        end
//    else if((S_out_gmii_txc_d3 == 4'hf) && (S_out_gmii_txc == 4'hf))
//        begin
//            S_out_gmii_crc_en   <= 1'b1 ;
//        end
//    else
//        begin
//            S_out_gmii_crc_en   <= S_out_gmii_crc_en ;
//        end
//end

crc32_top U0_crc32_top(
.I_rst    	           (I_fpga_reset        ),                  
.I_sys_clk	           (I_sys_312m_clk      ),                 
.I_crc_data	           (S_out_gmii_data_d1  ),      
.I_xgmii_ctl	       (S_out_gmii_txc_d1   ),   
.O_crc_out             (S_out_gmii_data_crc )   
); 

always@(posedge I_sys_312m_clk)
begin
    S_out_gmii_data_crc_d1  <= S_out_gmii_data_crc      ;
end

always@(posedge I_sys_312m_clk)
begin
    if(S_ptp_flag_out)                                                                              //20150721modified for origin data
        begin
            if(S_out_gmii_cnt_d6 == 9'd68)
                begin
                    S_out_gmii_data_d6  <= {S_out_gmii_data_d5[31:16],S_out_gmii_data_crc_d1[31:16]}      ;
                end
            else if(S_out_gmii_cnt_d6 == 9'd69)
                begin
                    S_out_gmii_data_d6  <= {S_out_gmii_data_crc_d1[15:0],S_out_gmii_data_d5[15:0]}      ;
                end
            else
                begin
                    S_out_gmii_data_d6  <= S_out_gmii_data_d5      ;
                end
        end
    else
        begin
            S_out_gmii_data_d6  <= S_out_gmii_data_d5      ;
        end
end

//test start
always@(posedge I_sys_312m_clk)
begin
    S_1588_packet_in_num_clr    <= I_1588_packet_in_num_clr     ;
    S_1588_packet_out_num_clr   <= I_1588_packet_out_num_clr    ;
    S_all_packet_in_num_clr     <= I_all_packet_in_num_clr      ;
    S_all_packet_out_num_clr    <= I_all_packet_out_num_clr     ;
end

always@(posedge I_sys_312m_clk)
begin
    S_gmii_check_state_buf1     <= S_gmii_check_state       ;
    S_gmii_check_state_buf2     <= S_gmii_check_state_buf1  ;
end

always@(posedge I_sys_312m_clk)
begin
    if(S_gmii_check_state_buf1 != S_gmii_check_state_buf2)
        begin
            S_gmii_check_state_test <= {S_gmii_check_state_test[55:0],S_gmii_check_state_buf2[7:0]}  ;
        end
    else
        begin
            S_gmii_check_state_test <= S_gmii_check_state_test  ;
        end
end

always@(posedge I_sys_312m_clk)
begin
    S_head_vlan_flag_d          <= S_head_vlan_flag             ;
    S_check_mac_ptp_flag_d      <= S_check_mac_ptp_flag         ;
    S_check_udp_ptp_flag_d      <= S_check_udp_ptp_flag         ;
    S_sync_dreq_en_d            <= S_sync_dreq_en               ;
    
    S_head_vlan_flag_lock_d     <= S_head_vlan_flag_lock        ;
    S_check_mac_ptp_flag_lock_d <= S_check_mac_ptp_flag_lock    ;
    S_check_udp_ptp_flag_lock_d <= S_check_udp_ptp_flag_lock    ;
    S_sync_dreq_en_lock_d       <= S_sync_dreq_en_lock          ;
    
end

always@(posedge I_sys_312m_clk)
begin
    if(S_all_packet_in_num_clr)
        begin
            S_all_packet_in_num <= 16'h0   ;
        end
    else if(S_in_gmii_txc_d1 == 4'd3)
        begin
            S_all_packet_in_num <= S_all_packet_in_num + 1'b1   ;
        end
    else
        begin
            S_all_packet_in_num <= S_all_packet_in_num   ;
        end
end

always@(posedge I_sys_312m_clk)
begin
    if(S_1588_packet_in_num_clr)
        begin
            S_1588_packet_in_num    <= 16'h0    ;
        end
    else if(S_in_gmii_txc_d1 == 4'd3)
        begin
            if((S_head_vlan_flag_d) && (S_check_mac_ptp_flag_d || S_check_udp_ptp_flag_d) && (S_sync_dreq_en_d))
                begin
                    S_1588_packet_in_num <= S_1588_packet_in_num + 1'b1   ;
                end
            else
                begin
                    S_1588_packet_in_num <= S_1588_packet_in_num   ;
                end
        end
    else
        begin
            S_1588_packet_in_num <= S_1588_packet_in_num   ;
        end
end


always@(posedge I_sys_312m_clk)
begin
    if(S_all_packet_out_num_clr)
        begin
            S_all_packet_out_num    <= 16'h0 ;
        end
    else if(S_out_gmii_txc_d6 == 4'd3)
        begin
            S_all_packet_out_num <= S_all_packet_out_num + 1'b1   ;
        end
    else
        begin
            S_all_packet_out_num <= S_all_packet_out_num   ;
        end
end

always@(posedge I_sys_312m_clk)
begin
    if(S_1588_packet_out_num_clr)
        begin
            S_1588_packet_out_num   <= 16'h0    ;
        end
    else if(S_out_gmii_txc_d6 == 4'd3)
        begin
            if((S_head_vlan_flag_lock_d) && (S_check_mac_ptp_flag_lock_d || S_check_udp_ptp_flag_lock_d) && (S_sync_dreq_en_lock_d))
                begin
                    S_1588_packet_out_num <= S_1588_packet_out_num + 1'b1   ;
                end
            else
                begin
                    S_1588_packet_out_num <= S_1588_packet_out_num   ;
                end
        end
    else
        begin
            S_1588_packet_out_num <= S_1588_packet_out_num   ;
        end
end
//test end

//signal capture start
always@(posedge I_sys_312m_clk)
begin
    M_in_gmii_data               <= S_in_gmii_data            ;
    M_in_gmii_txc                <= S_in_gmii_txc             ;
    M_check_length_cnt           <= S_check_length_cnt        ;
    M_in_gmii_cnt                <= S_in_gmii_cnt             ;
    M_gmii_check_state_next      <= S_gmii_check_state_next   ;
    M_head_vlan_flag             <= S_head_vlan_flag          ;
    M_head_vlan_flag_d1          <= S_head_vlan_flag_d1       ;
    M_check_mac_ptp_flag         <= S_check_mac_ptp_flag      ;
    M_check_udp_flag             <= S_check_udp_flag          ;
    M_check_udp_ptp_flag         <= S_check_udp_ptp_flag      ;
    M_sync_dreq_en               <= S_sync_dreq_en            ;
    M_tail_vlan_flag             <= S_tail_vlan_flag          ;
    M_tail_vlan                  <= S_tail_vlan               ;
    M_pla_vlan_ind               <= S_pla_vlan_ind            ;
    M_check_mac_ptp_flag_lock    <= S_check_mac_ptp_flag_lock ;
    M_check_udp_ptp_flag_lock    <= S_check_udp_ptp_flag_lock ;
    M_slice_id_lock              <= S_slice_id_lock           ;
    M_pla_slice_sa_lock          <= S_pla_slice_sa_lock       ;
    M_ptp_flag                   <= S_ptp_flag                ;
    M_fifo_usedw_d               <= S_fifo_usedw_d            ;
    M_fifo_usedw_dd              <= S_fifo_usedw_dd           ;
    M_fifo_out_data              <= S_fifo_out_data           ;
    M_fifo_out_txc               <= S_fifo_out_txc            ;
    M_fifo_out_reform_data_d2    <= S_fifo_out_reform_data_d2 ;
    M_out_gmii_data              <= S_out_gmii_data           ;
    M_out_gmii_data_d6           <= S_out_gmii_data_d6        ;
    M_out_gmii_txc               <= S_out_gmii_txc            ;
    M_out_gmii_txc_d6            <= S_out_gmii_txc_d6         ;
    M_out_gmii_crc_en            <= S_out_gmii_crc_en         ;
    M_out_gmii_data_crc_d1       <= S_out_gmii_data_crc_d1    ;
    M_fifo_rd_en                 <= S_fifo_rd_en              ;
    M_fifo_wr_en                 <= S_fifo_wr_en              ;
    M_fpga_reset                 <= I_fpga_reset              ;
end
//signal capture end
endmodule