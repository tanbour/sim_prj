//FILE_HEADER-------------------------------------------------------
//ZTE Copyright(C)
// ZTE Company Confidential
//------------------------------------------------------------------
// Project Name : ZXLTE xxxx
// FILE NAME    : pla_1588_packing_mac_intp.v
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
// 1.1        mm-dd-yyyy   Author       修改、增减的主要内容描述
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
module pla_1588_packing_mac_intp(
input          I_sys_312m_clk                 ,    // 
input          I_fpga_reset                   ,    //

input [1:0]    I_subport_num                  ,    //
input [15:0]   I_pla_vlan_id                  ,    //
input          I_pla_vlan_ind                 ,    //

input [47:0]   I_pla_slice_da0                ,    //
input [47:0]   I_pla_slice_da1                ,    //
input [47:0]   I_pla_slice_da2                ,    //
input [47:0]   I_pla_slice_sa00               ,    //
input [47:0]   I_pla_slice_sa01               ,    //
input [47:0]   I_pla_slice_sa02               ,    //
input [47:0]   I_pla_slice_sa03               ,    //
input [47:0]   I_pla_slice_sa04               ,    //
input [47:0]   I_pla_slice_sa05               ,    //
input [47:0]   I_pla_slice_sa06               ,    //
input [47:0]   I_pla_slice_sa07               ,    //
input [47:0]   I_pla_slice_sa10               ,    //
input [47:0]   I_pla_slice_sa11               ,    //
input [47:0]   I_pla_slice_sa12               ,    //
input [47:0]   I_pla_slice_sa13               ,    //
input [47:0]   I_pla_slice_sa14               ,    //
input [47:0]   I_pla_slice_sa15               ,    //
input [47:0]   I_pla_slice_sa16               ,    //
input [47:0]   I_pla_slice_sa17               ,    //
input [47:0]   I_pla_slice_sa20               ,    //
input [47:0]   I_pla_slice_sa21               ,    //
input [47:0]   I_pla_slice_sa22               ,    //
input [47:0]   I_pla_slice_sa23               ,    //
input [47:0]   I_pla_slice_sa24               ,    //
input [47:0]   I_pla_slice_sa25               ,    //
input [47:0]   I_pla_slice_sa26               ,    //
input [47:0]   I_pla_slice_sa27               ,    //

input          I_pla_slice_sa00_cnt_clr       ,    //
input          I_pla_slice_sa01_cnt_clr       ,    //
input          I_pla_slice_sa02_cnt_clr       ,    //
input          I_pla_slice_sa03_cnt_clr       ,    //
input          I_pla_slice_sa04_cnt_clr       ,    //
input          I_pla_slice_sa05_cnt_clr       ,    //
input          I_pla_slice_sa06_cnt_clr       ,    //
input          I_pla_slice_sa07_cnt_clr       ,    //
input          I_pla_slice_sa10_cnt_clr       ,    //
input          I_pla_slice_sa11_cnt_clr       ,    //
input          I_pla_slice_sa12_cnt_clr       ,    //
input          I_pla_slice_sa13_cnt_clr       ,    //
input          I_pla_slice_sa14_cnt_clr       ,    //
input          I_pla_slice_sa15_cnt_clr       ,    //
input          I_pla_slice_sa16_cnt_clr       ,    //
input          I_pla_slice_sa17_cnt_clr       ,    //
input          I_pla_slice_sa20_cnt_clr       ,    //
input          I_pla_slice_sa21_cnt_clr       ,    //
input          I_pla_slice_sa22_cnt_clr       ,    //
input          I_pla_slice_sa23_cnt_clr       ,    //
input          I_pla_slice_sa24_cnt_clr       ,    //
input          I_pla_slice_sa25_cnt_clr       ,    //
input          I_pla_slice_sa26_cnt_clr       ,    //
input          I_pla_slice_sa27_cnt_clr       ,    //

output[47:0]   O_pla_slice_da                 ,    //
output[47:0]   O_pla_slice_sa                 ,    //
//test start
output[15:0]   O_pla_slice_sa00_cnt           ,    //
output[15:0]   O_pla_slice_sa01_cnt           ,    //
output[15:0]   O_pla_slice_sa02_cnt           ,    //
output[15:0]   O_pla_slice_sa03_cnt           ,    //
output[15:0]   O_pla_slice_sa04_cnt           ,    //
output[15:0]   O_pla_slice_sa05_cnt           ,    //
output[15:0]   O_pla_slice_sa06_cnt           ,    //
output[15:0]   O_pla_slice_sa07_cnt           ,    //
output[15:0]   O_pla_slice_sa10_cnt           ,    //
output[15:0]   O_pla_slice_sa11_cnt           ,    //
output[15:0]   O_pla_slice_sa12_cnt           ,    //
output[15:0]   O_pla_slice_sa13_cnt           ,    //
output[15:0]   O_pla_slice_sa14_cnt           ,    //
output[15:0]   O_pla_slice_sa15_cnt           ,    //
output[15:0]   O_pla_slice_sa16_cnt           ,    //
output[15:0]   O_pla_slice_sa17_cnt           ,    //
output[15:0]   O_pla_slice_sa20_cnt           ,    //
output[15:0]   O_pla_slice_sa21_cnt           ,    //
output[15:0]   O_pla_slice_sa22_cnt           ,    //
output[15:0]   O_pla_slice_sa23_cnt           ,    //
output[15:0]   O_pla_slice_sa24_cnt           ,    //
output[15:0]   O_pla_slice_sa25_cnt           ,    //
output[15:0]   O_pla_slice_sa26_cnt           ,    //
output[15:0]   O_pla_slice_sa27_cnt                //
//test end
);

parameter      C_PLA_VLAN_DA0       = 8'd00 ,    //
               C_PLA_VLAN_DA1       = 8'd01 ,    //
               C_PLA_VLAN_DA2       = 8'd02 ,    //
               C_PLA_VLAN_SA00      = 8'd10 ,    //
               C_PLA_VLAN_SA01      = 8'd11 ,    //
               C_PLA_VLAN_SA02      = 8'd12 ,    //
               C_PLA_VLAN_SA03      = 8'd13 ,    //
               C_PLA_VLAN_SA04      = 8'd14 ,    //
               C_PLA_VLAN_SA05      = 8'd15 ,    //
               C_PLA_VLAN_SA06      = 8'd16 ,    //
               C_PLA_VLAN_SA07      = 8'd17 ,    //
               C_PLA_VLAN_SA10      = 8'd20 ,    //
               C_PLA_VLAN_SA11      = 8'd21 ,    //
               C_PLA_VLAN_SA12      = 8'd22 ,    //
               C_PLA_VLAN_SA13      = 8'd23 ,    //
               C_PLA_VLAN_SA14      = 8'd24 ,    //
               C_PLA_VLAN_SA15      = 8'd25 ,    //
               C_PLA_VLAN_SA16      = 8'd26 ,    //
               C_PLA_VLAN_SA17      = 8'd27 ,    //
               C_PLA_VLAN_SA20      = 8'd30 ,    //
               C_PLA_VLAN_SA21      = 8'd31 ,    //
               C_PLA_VLAN_SA22      = 8'd32 ,    //
               C_PLA_VLAN_SA23      = 8'd33 ,    //
               C_PLA_VLAN_SA24      = 8'd34 ,    //
               C_PLA_VLAN_SA25      = 8'd35 ,    //
               C_PLA_VLAN_SA26      = 8'd36 ,    //
               C_PLA_VLAN_SA27      = 8'd37 ;    //

(*mark_debug ="true"*)reg [1:0]      S_subport_num        = 2'h0  ;
(*mark_debug ="true"*)reg [15:0]     S_pla_vlan_id        = 16'h0 ;
reg            S_pla_vlan_ind_d1    = 1'b0  ;
reg            S_pla_vlan_ind_d2    = 1'b0  ;
reg            S_pla_vlan_ind_d3    = 1'b0  ;
reg            S_pla_vlan_id_check  = 1'b0  ;

reg [47:0]     S_pla_slice_da0      = 48'h00    ;    //
reg [47:0]     S_pla_slice_da1      = 48'h00    ;    //
reg [47:0]     S_pla_slice_da2      = 48'h00    ;    //
reg [47:0]     S_pla_slice_sa00     = 48'h00    ;    //
reg [47:0]     S_pla_slice_sa01     = 48'h00    ;    //
reg [47:0]     S_pla_slice_sa02     = 48'h00    ;    //
reg [47:0]     S_pla_slice_sa03     = 48'h00    ;    //
reg [47:0]     S_pla_slice_sa04     = 48'h00    ;    //
reg [47:0]     S_pla_slice_sa05     = 48'h00    ;    //
reg [47:0]     S_pla_slice_sa06     = 48'h00    ;    //
reg [47:0]     S_pla_slice_sa07     = 48'h00    ;    //
reg [47:0]     S_pla_slice_sa10     = 48'h00    ;    //
reg [47:0]     S_pla_slice_sa11     = 48'h00    ;    //
reg [47:0]     S_pla_slice_sa12     = 48'h00    ;    //
reg [47:0]     S_pla_slice_sa13     = 48'h00    ;    //
reg [47:0]     S_pla_slice_sa14     = 48'h00    ;    //
reg [47:0]     S_pla_slice_sa15     = 48'h00    ;    //
reg [47:0]     S_pla_slice_sa16     = 48'h00    ;    //
reg [47:0]     S_pla_slice_sa17     = 48'h00    ;    //
reg [47:0]     S_pla_slice_sa20     = 48'h00    ;    //
reg [47:0]     S_pla_slice_sa21     = 48'h00    ;    //
reg [47:0]     S_pla_slice_sa22     = 48'h00    ;    //
reg [47:0]     S_pla_slice_sa23     = 48'h00    ;    //
reg [47:0]     S_pla_slice_sa24     = 48'h00    ;    //
reg [47:0]     S_pla_slice_sa25     = 48'h00    ;    //
reg [47:0]     S_pla_slice_sa26     = 48'h00    ;    //
reg [47:0]     S_pla_slice_sa27     = 48'h00    ;    //
reg [47:0]     S_pla_slice_sa0      = 48'h00    ;    //
reg [47:0]     S_pla_slice_sa1      = 48'h00    ;    //
reg [47:0]     S_pla_slice_sa2      = 48'h00    ;    //
reg [47:0]     S_pla_slice_sa3      = 48'h00    ;    //
reg [47:0]     S_pla_slice_sa4      = 48'h00    ;    //
reg [47:0]     S_pla_slice_sa5      = 48'h00    ;    //
reg [47:0]     S_pla_slice_sa6      = 48'h00    ;    //
reg [47:0]     S_pla_slice_sa7      = 48'h00    ;    //

reg [47:0]     S_pla_slice_da       = 48'h00    ;    //
reg [47:0]     S_pla_slice_sa       = 48'h00    ;    //
//test start
reg [15:0]   S_pla_slice_sa00_cnt   = 16'h0 ;    //
reg [15:0]   S_pla_slice_sa01_cnt   = 16'h0 ;    //
reg [15:0]   S_pla_slice_sa02_cnt   = 16'h0 ;    //
reg [15:0]   S_pla_slice_sa03_cnt   = 16'h0 ;    //
reg [15:0]   S_pla_slice_sa04_cnt   = 16'h0 ;    //
reg [15:0]   S_pla_slice_sa05_cnt   = 16'h0 ;    //
reg [15:0]   S_pla_slice_sa06_cnt   = 16'h0 ;    //
reg [15:0]   S_pla_slice_sa07_cnt   = 16'h0 ;    //
reg [15:0]   S_pla_slice_sa10_cnt   = 16'h0 ;    //
reg [15:0]   S_pla_slice_sa11_cnt   = 16'h0 ;    //
reg [15:0]   S_pla_slice_sa12_cnt   = 16'h0 ;    //
reg [15:0]   S_pla_slice_sa13_cnt   = 16'h0 ;    //
reg [15:0]   S_pla_slice_sa14_cnt   = 16'h0 ;    //
reg [15:0]   S_pla_slice_sa15_cnt   = 16'h0 ;    //
reg [15:0]   S_pla_slice_sa16_cnt   = 16'h0 ;    //
reg [15:0]   S_pla_slice_sa17_cnt   = 16'h0 ;    //
reg [15:0]   S_pla_slice_sa20_cnt   = 16'h0 ;    //
reg [15:0]   S_pla_slice_sa21_cnt   = 16'h0 ;    //
reg [15:0]   S_pla_slice_sa22_cnt   = 16'h0 ;    //
reg [15:0]   S_pla_slice_sa23_cnt   = 16'h0 ;    //
reg [15:0]   S_pla_slice_sa24_cnt   = 16'h0 ;    //
reg [15:0]   S_pla_slice_sa25_cnt   = 16'h0 ;    //
reg [15:0]   S_pla_slice_sa26_cnt   = 16'h0 ;    //
reg [15:0]   S_pla_slice_sa27_cnt   = 16'h0 ;    //

reg          S_pla_slice_sa00_cnt_clr   = 1'b0  ;   //
reg          S_pla_slice_sa01_cnt_clr   = 1'b0  ;   //
reg          S_pla_slice_sa02_cnt_clr   = 1'b0  ;   //
reg          S_pla_slice_sa03_cnt_clr   = 1'b0  ;   //
reg          S_pla_slice_sa04_cnt_clr   = 1'b0  ;   //
reg          S_pla_slice_sa05_cnt_clr   = 1'b0  ;   //
reg          S_pla_slice_sa06_cnt_clr   = 1'b0  ;   //
reg          S_pla_slice_sa07_cnt_clr   = 1'b0  ;   //
reg          S_pla_slice_sa10_cnt_clr   = 1'b0  ;   //
reg          S_pla_slice_sa11_cnt_clr   = 1'b0  ;   //
reg          S_pla_slice_sa12_cnt_clr   = 1'b0  ;   //
reg          S_pla_slice_sa13_cnt_clr   = 1'b0  ;   //
reg          S_pla_slice_sa14_cnt_clr   = 1'b0  ;   //
reg          S_pla_slice_sa15_cnt_clr   = 1'b0  ;   //
reg          S_pla_slice_sa16_cnt_clr   = 1'b0  ;   //
reg          S_pla_slice_sa17_cnt_clr   = 1'b0  ;   //
reg          S_pla_slice_sa20_cnt_clr   = 1'b0  ;   //
reg          S_pla_slice_sa21_cnt_clr   = 1'b0  ;   //
reg          S_pla_slice_sa22_cnt_clr   = 1'b0  ;   //
reg          S_pla_slice_sa23_cnt_clr   = 1'b0  ;   //
reg          S_pla_slice_sa24_cnt_clr   = 1'b0  ;   //
reg          S_pla_slice_sa25_cnt_clr   = 1'b0  ;   //
reg          S_pla_slice_sa26_cnt_clr   = 1'b0  ;   //
reg          S_pla_slice_sa27_cnt_clr   = 1'b0  ;   //

//test end
assign       O_pla_slice_da         = S_pla_slice_da        ;
assign       O_pla_slice_sa         = S_pla_slice_sa        ;
//test start
assign       O_pla_slice_sa00_cnt   = S_pla_slice_sa00_cnt  ;
assign       O_pla_slice_sa01_cnt   = S_pla_slice_sa01_cnt  ;
assign       O_pla_slice_sa02_cnt   = S_pla_slice_sa02_cnt  ;
assign       O_pla_slice_sa03_cnt   = S_pla_slice_sa03_cnt  ;
assign       O_pla_slice_sa04_cnt   = S_pla_slice_sa04_cnt  ;
assign       O_pla_slice_sa05_cnt   = S_pla_slice_sa05_cnt  ;
assign       O_pla_slice_sa06_cnt   = S_pla_slice_sa06_cnt  ;
assign       O_pla_slice_sa07_cnt   = S_pla_slice_sa07_cnt  ;
assign       O_pla_slice_sa10_cnt   = S_pla_slice_sa10_cnt  ;
assign       O_pla_slice_sa11_cnt   = S_pla_slice_sa11_cnt  ;
assign       O_pla_slice_sa12_cnt   = S_pla_slice_sa12_cnt  ;
assign       O_pla_slice_sa13_cnt   = S_pla_slice_sa13_cnt  ;
assign       O_pla_slice_sa14_cnt   = S_pla_slice_sa14_cnt  ;
assign       O_pla_slice_sa15_cnt   = S_pla_slice_sa15_cnt  ;
assign       O_pla_slice_sa16_cnt   = S_pla_slice_sa16_cnt  ;
assign       O_pla_slice_sa17_cnt   = S_pla_slice_sa17_cnt  ;
assign       O_pla_slice_sa20_cnt   = S_pla_slice_sa20_cnt  ;
assign       O_pla_slice_sa21_cnt   = S_pla_slice_sa21_cnt  ;
assign       O_pla_slice_sa22_cnt   = S_pla_slice_sa22_cnt  ;
assign       O_pla_slice_sa23_cnt   = S_pla_slice_sa23_cnt  ;
assign       O_pla_slice_sa24_cnt   = S_pla_slice_sa24_cnt  ;
assign       O_pla_slice_sa25_cnt   = S_pla_slice_sa25_cnt  ;
assign       O_pla_slice_sa26_cnt   = S_pla_slice_sa26_cnt  ;
assign       O_pla_slice_sa27_cnt   = S_pla_slice_sa27_cnt  ;
//test end
always@(posedge I_sys_312m_clk)
begin
    S_subport_num       <= I_subport_num    ;
    S_pla_vlan_id       <= I_pla_vlan_id    ;
    S_pla_vlan_ind_d1   <= I_pla_vlan_ind   ;
    S_pla_vlan_ind_d2   <= S_pla_vlan_ind_d1;
    S_pla_vlan_ind_d3   <= S_pla_vlan_ind_d2;
end

always@(posedge I_sys_312m_clk)
begin
    S_pla_slice_da0     <= I_pla_slice_da0  ;
    S_pla_slice_da1     <= I_pla_slice_da1  ;
    S_pla_slice_da2     <= I_pla_slice_da2  ;
    S_pla_slice_sa00    <= I_pla_slice_sa00 ;
    S_pla_slice_sa01    <= I_pla_slice_sa01 ;
    S_pla_slice_sa02    <= I_pla_slice_sa02 ;
    S_pla_slice_sa03    <= I_pla_slice_sa03 ;
    S_pla_slice_sa04    <= I_pla_slice_sa04 ;
    S_pla_slice_sa05    <= I_pla_slice_sa05 ;
    S_pla_slice_sa06    <= I_pla_slice_sa06 ;
    S_pla_slice_sa07    <= I_pla_slice_sa07 ;
    S_pla_slice_sa10    <= I_pla_slice_sa10 ;
    S_pla_slice_sa11    <= I_pla_slice_sa11 ;
    S_pla_slice_sa12    <= I_pla_slice_sa12 ;
    S_pla_slice_sa13    <= I_pla_slice_sa13 ;
    S_pla_slice_sa14    <= I_pla_slice_sa14 ;
    S_pla_slice_sa15    <= I_pla_slice_sa15 ;
    S_pla_slice_sa16    <= I_pla_slice_sa16 ;
    S_pla_slice_sa17    <= I_pla_slice_sa17 ;
    S_pla_slice_sa20    <= I_pla_slice_sa20 ;
    S_pla_slice_sa21    <= I_pla_slice_sa21 ;
    S_pla_slice_sa22    <= I_pla_slice_sa22 ;
    S_pla_slice_sa23    <= I_pla_slice_sa23 ;
    S_pla_slice_sa24    <= I_pla_slice_sa24 ;
    S_pla_slice_sa25    <= I_pla_slice_sa25 ;
    S_pla_slice_sa26    <= I_pla_slice_sa26 ;
    S_pla_slice_sa27    <= I_pla_slice_sa27 ;
end

always@(posedge I_sys_312m_clk)
begin
    if((S_pla_vlan_ind_d1) && (~S_pla_vlan_ind_d2))
        begin
            if(S_pla_vlan_id[15:3] == 13'h1f4)
                begin
                    S_pla_vlan_id_check <= 1'b1 ;
                end
            else
                begin
                    S_pla_vlan_id_check <= 1'b0 ;
                end
        end
    else
        begin
            S_pla_vlan_id_check <= S_pla_vlan_id_check ;
        end
end

//get slice_da
always@(posedge I_sys_312m_clk)
begin
    if((S_pla_vlan_ind_d2) && (~S_pla_vlan_ind_d3))
        begin
            case(S_subport_num)
            2'b00:
            begin
                S_pla_slice_da <= S_pla_slice_da0   ;
            end
            2'b01:
            begin
                S_pla_slice_da <= S_pla_slice_da1   ;
            end
            2'b10:
            begin
                S_pla_slice_da <= S_pla_slice_da2   ;
            end
            default:
            begin
                S_pla_slice_da <= 48'h0   ;
            end
            endcase
        end
    else
        begin
            S_pla_slice_da <= S_pla_slice_da   ;
        end
end
//get slice_sa, step1: subport 
always@(posedge I_sys_312m_clk)
begin
    if((S_pla_vlan_ind_d2) && (~S_pla_vlan_ind_d3))
        begin
            case(S_subport_num)
            2'b00:
            begin
                S_pla_slice_sa0 <= S_pla_slice_sa00   ;
            end
            2'b01:
            begin
                S_pla_slice_sa0 <= S_pla_slice_sa10   ;
            end
            2'b10:
            begin
                S_pla_slice_sa0 <= S_pla_slice_sa20   ;
            end
            default:
            begin
                S_pla_slice_sa0 <= S_pla_slice_sa0   ;
            end
            endcase
        end
    else
        begin
            S_pla_slice_sa0 <= S_pla_slice_sa0   ;
        end
end
always@(posedge I_sys_312m_clk)
begin
    if((S_pla_vlan_ind_d2) && (~S_pla_vlan_ind_d3))
        begin
            case(S_subport_num)
            2'b00:
            begin
                S_pla_slice_sa1 <= S_pla_slice_sa01   ;
            end
            2'b01:
            begin
                S_pla_slice_sa1 <= S_pla_slice_sa11   ;
            end
            2'b10:
            begin
                S_pla_slice_sa1 <= S_pla_slice_sa21   ;
            end
            default:
            begin
                S_pla_slice_sa1 <= S_pla_slice_sa1   ;
            end
            endcase
        end
    else
        begin
            S_pla_slice_sa1 <= S_pla_slice_sa1   ;
        end
end
always@(posedge I_sys_312m_clk)
begin
    if((S_pla_vlan_ind_d2) && (~S_pla_vlan_ind_d3))
        begin
            case(S_subport_num)
            2'b00:
            begin
                S_pla_slice_sa2 <= S_pla_slice_sa02   ;
            end
            2'b01:
            begin
                S_pla_slice_sa2 <= S_pla_slice_sa12   ;
            end
            2'b10:
            begin
                S_pla_slice_sa2 <= S_pla_slice_sa22   ;
            end
            default:
            begin
                S_pla_slice_sa2 <= S_pla_slice_sa2   ;
            end
            endcase
        end
    else
        begin
            S_pla_slice_sa2 <= S_pla_slice_sa2   ;
        end
end
always@(posedge I_sys_312m_clk)
begin
    if((S_pla_vlan_ind_d2) && (~S_pla_vlan_ind_d3))
        begin
            case(S_subport_num)
            2'b00:
            begin
                S_pla_slice_sa3 <= S_pla_slice_sa03   ;
            end
            2'b01:
            begin
                S_pla_slice_sa3 <= S_pla_slice_sa13   ;
            end
            2'b10:
            begin
                S_pla_slice_sa3 <= S_pla_slice_sa23   ;
            end
            default:
            begin
                S_pla_slice_sa3 <= S_pla_slice_sa3   ;
            end
            endcase
        end
    else
        begin
            S_pla_slice_sa3 <= S_pla_slice_sa3   ;
        end
end
always@(posedge I_sys_312m_clk)
begin
    if((S_pla_vlan_ind_d2) && (~S_pla_vlan_ind_d3))
        begin
            case(S_subport_num)
            2'b00:
            begin
                S_pla_slice_sa4 <= S_pla_slice_sa04   ;
            end
            2'b01:
            begin
                S_pla_slice_sa4 <= S_pla_slice_sa14   ;
            end
            2'b10:
            begin
                S_pla_slice_sa4 <= S_pla_slice_sa24   ;
            end
            default:
            begin
                S_pla_slice_sa4 <= S_pla_slice_sa4   ;
            end
            endcase
        end
    else
        begin
            S_pla_slice_sa4 <= S_pla_slice_sa4   ;
        end
end
always@(posedge I_sys_312m_clk)
begin
    if((S_pla_vlan_ind_d2) && (~S_pla_vlan_ind_d3))
        begin
            case(S_subport_num)
            2'b00:
            begin
                S_pla_slice_sa5 <= S_pla_slice_sa05   ;
            end
            2'b01:
            begin
                S_pla_slice_sa5 <= S_pla_slice_sa15   ;
            end
            2'b10:
            begin
                S_pla_slice_sa5 <= S_pla_slice_sa25   ;
            end
            default:
            begin
                S_pla_slice_sa5 <= S_pla_slice_sa5   ;
            end
            endcase
        end
    else
        begin
            S_pla_slice_sa5 <= S_pla_slice_sa5   ;
        end
end
always@(posedge I_sys_312m_clk)
begin
    if((S_pla_vlan_ind_d2) && (~S_pla_vlan_ind_d3))
        begin
            case(S_subport_num)
            2'b00:
            begin
                S_pla_slice_sa6 <= S_pla_slice_sa06   ;
            end
            2'b01:
            begin
                S_pla_slice_sa6 <= S_pla_slice_sa16   ;
            end
            2'b10:
            begin
                S_pla_slice_sa6 <= S_pla_slice_sa26   ;
            end
            default:
            begin
                S_pla_slice_sa6 <= S_pla_slice_sa6   ;
            end
            endcase
        end
    else
        begin
            S_pla_slice_sa6 <= S_pla_slice_sa6   ;
        end
end
always@(posedge I_sys_312m_clk)
begin
    if((S_pla_vlan_ind_d2) && (~S_pla_vlan_ind_d3))
        begin
            case(S_subport_num)
            2'b00:
            begin
                S_pla_slice_sa7 <= S_pla_slice_sa07   ;
            end
            2'b01:
            begin
                S_pla_slice_sa7 <= S_pla_slice_sa17   ;
            end
            2'b10:
            begin
                S_pla_slice_sa7 <= S_pla_slice_sa27   ;
            end
            default:
            begin
                S_pla_slice_sa7 <= S_pla_slice_sa7   ;
            end
            endcase
        end
    else
        begin
            S_pla_slice_sa7 <= S_pla_slice_sa7   ;
        end
end
//get slice_sa, step2: vlan_id
always@(posedge I_sys_312m_clk)
begin
    if((~S_pla_vlan_ind_d2) && (S_pla_vlan_ind_d3))
        begin
            if(S_pla_vlan_id_check)
                begin
                    case(S_pla_vlan_id[2:0])
                    3'h0:
                    begin
                        S_pla_slice_sa  <= S_pla_slice_sa0  ;
                    end
                    3'h1:
                    begin
                        S_pla_slice_sa  <= S_pla_slice_sa1  ;
                    end
                    3'h2:
                    begin
                        S_pla_slice_sa  <= S_pla_slice_sa2  ;
                    end
                    3'h3:
                    begin
                        S_pla_slice_sa  <= S_pla_slice_sa3  ;
                    end
                    3'h4:
                    begin
                        S_pla_slice_sa  <= S_pla_slice_sa4  ;
                    end
                    3'h5:
                    begin
                        S_pla_slice_sa  <= S_pla_slice_sa5  ;
                    end
                    3'h6:
                    begin
                        S_pla_slice_sa  <= S_pla_slice_sa6  ;
                    end
                    3'h7:
                    begin
                        S_pla_slice_sa  <= S_pla_slice_sa7  ;
                    end
                    default:
                    begin
                        S_pla_slice_sa  <= S_pla_slice_sa   ;
                    end
                    endcase
                end
            else
                begin
                    S_pla_slice_sa  <= S_pla_slice_sa   ;
                end
        end
    else
        begin
                S_pla_slice_sa  <= S_pla_slice_sa  ;
        end
end
//test start
always@(posedge I_sys_312m_clk)
begin
    S_pla_slice_sa00_cnt_clr    <= I_pla_slice_sa00_cnt_clr ;
    S_pla_slice_sa01_cnt_clr    <= I_pla_slice_sa01_cnt_clr ;
    S_pla_slice_sa02_cnt_clr    <= I_pla_slice_sa02_cnt_clr ;
    S_pla_slice_sa03_cnt_clr    <= I_pla_slice_sa03_cnt_clr ;
    S_pla_slice_sa04_cnt_clr    <= I_pla_slice_sa04_cnt_clr ;
    S_pla_slice_sa05_cnt_clr    <= I_pla_slice_sa05_cnt_clr ;
    S_pla_slice_sa06_cnt_clr    <= I_pla_slice_sa06_cnt_clr ;
    S_pla_slice_sa07_cnt_clr    <= I_pla_slice_sa07_cnt_clr ;
    S_pla_slice_sa10_cnt_clr    <= I_pla_slice_sa10_cnt_clr ;
    S_pla_slice_sa11_cnt_clr    <= I_pla_slice_sa11_cnt_clr ;
    S_pla_slice_sa12_cnt_clr    <= I_pla_slice_sa12_cnt_clr ;
    S_pla_slice_sa13_cnt_clr    <= I_pla_slice_sa13_cnt_clr ;
    S_pla_slice_sa14_cnt_clr    <= I_pla_slice_sa14_cnt_clr ;
    S_pla_slice_sa15_cnt_clr    <= I_pla_slice_sa15_cnt_clr ;
    S_pla_slice_sa16_cnt_clr    <= I_pla_slice_sa16_cnt_clr ;
    S_pla_slice_sa17_cnt_clr    <= I_pla_slice_sa17_cnt_clr ;
    S_pla_slice_sa20_cnt_clr    <= I_pla_slice_sa20_cnt_clr ;
    S_pla_slice_sa21_cnt_clr    <= I_pla_slice_sa21_cnt_clr ;
    S_pla_slice_sa22_cnt_clr    <= I_pla_slice_sa22_cnt_clr ;
    S_pla_slice_sa23_cnt_clr    <= I_pla_slice_sa23_cnt_clr ;
    S_pla_slice_sa24_cnt_clr    <= I_pla_slice_sa24_cnt_clr ;
    S_pla_slice_sa25_cnt_clr    <= I_pla_slice_sa25_cnt_clr ;
    S_pla_slice_sa26_cnt_clr    <= I_pla_slice_sa26_cnt_clr ;
    S_pla_slice_sa27_cnt_clr    <= I_pla_slice_sa27_cnt_clr ;
end
//subport_num:0
always@(posedge I_sys_312m_clk)
begin
    if(S_pla_slice_sa00_cnt_clr)
        begin
            S_pla_slice_sa00_cnt    <= 16'h0    ;
        end
    else if({S_subport_num,S_pla_vlan_id[2:0]} == 5'h00)
        begin
            if(S_pla_vlan_id_check)
                begin
                    if((~S_pla_vlan_ind_d2) && (S_pla_vlan_ind_d3))
                        begin
                            S_pla_slice_sa00_cnt    <= S_pla_slice_sa00_cnt + 1'b1  ;
                        end
                    else
                        begin
                            S_pla_slice_sa00_cnt    <= S_pla_slice_sa00_cnt  ;
                        end
                end
            else
                begin
                    S_pla_slice_sa00_cnt    <= S_pla_slice_sa00_cnt  ;
                end
        end
    else
        begin
            S_pla_slice_sa00_cnt    <= S_pla_slice_sa00_cnt  ;
        end
end
always@(posedge I_sys_312m_clk)
begin
    if(S_pla_slice_sa01_cnt_clr)
        begin
            S_pla_slice_sa01_cnt    <= 16'h0    ;
        end
    else if({S_subport_num,S_pla_vlan_id[2:0]} == 5'h01)
        begin
            if(S_pla_vlan_id_check)
                begin
                    if((~S_pla_vlan_ind_d2) && (S_pla_vlan_ind_d3))
                        begin
                            S_pla_slice_sa01_cnt    <= S_pla_slice_sa01_cnt + 1'b1  ;
                        end
                    else
                        begin
                            S_pla_slice_sa01_cnt    <= S_pla_slice_sa01_cnt  ;
                        end
                end
            else
                begin
                    S_pla_slice_sa01_cnt    <= S_pla_slice_sa01_cnt  ;
                end
        end
    else
        begin
            S_pla_slice_sa01_cnt    <= S_pla_slice_sa01_cnt  ;
        end
end
always@(posedge I_sys_312m_clk)
begin
    if(S_pla_slice_sa02_cnt_clr)
        begin
            S_pla_slice_sa02_cnt    <= 16'h0    ;
        end
    else if({S_subport_num,S_pla_vlan_id[2:0]} == 5'h2)
        begin
            if(S_pla_vlan_id_check)
                begin
                    if((~S_pla_vlan_ind_d2) && (S_pla_vlan_ind_d3))
                        begin
                            S_pla_slice_sa02_cnt    <= S_pla_slice_sa02_cnt + 1'b1  ;
                        end
                    else
                        begin
                            S_pla_slice_sa02_cnt    <= S_pla_slice_sa02_cnt  ;
                        end
                end
            else
                begin
                    S_pla_slice_sa02_cnt    <= S_pla_slice_sa02_cnt  ;
                end
        end
    else
        begin
            S_pla_slice_sa02_cnt    <= S_pla_slice_sa02_cnt  ;
        end
end
always@(posedge I_sys_312m_clk)
begin
    if(S_pla_slice_sa03_cnt_clr)
        begin
            S_pla_slice_sa03_cnt    <= 16'h0    ;
        end
    else if({S_subport_num,S_pla_vlan_id[2:0]} == 5'h3)
        begin
            if(S_pla_vlan_id_check)
                begin
                    if((~S_pla_vlan_ind_d2) && (S_pla_vlan_ind_d3))
                        begin
                            S_pla_slice_sa03_cnt    <= S_pla_slice_sa03_cnt + 1'b1  ;
                        end
                    else
                        begin
                            S_pla_slice_sa03_cnt    <= S_pla_slice_sa03_cnt  ;
                        end
                end
            else
                begin
                    S_pla_slice_sa03_cnt    <= S_pla_slice_sa03_cnt  ;
                end
        end
    else
        begin
            S_pla_slice_sa03_cnt    <= S_pla_slice_sa03_cnt  ;
        end
end
always@(posedge I_sys_312m_clk)
begin
    if(S_pla_slice_sa04_cnt_clr)
        begin
            S_pla_slice_sa04_cnt    <= 16'h0    ;
        end
    else if({S_subport_num,S_pla_vlan_id[2:0]} == 5'h4)
        begin
            if(S_pla_vlan_id_check)
                begin
                    if((~S_pla_vlan_ind_d2) && (S_pla_vlan_ind_d3))
                        begin
                            S_pla_slice_sa04_cnt    <= S_pla_slice_sa04_cnt + 1'b1  ;
                        end
                    else
                        begin
                            S_pla_slice_sa04_cnt    <= S_pla_slice_sa04_cnt  ;
                        end
                end
            else
                begin
                    S_pla_slice_sa04_cnt    <= S_pla_slice_sa04_cnt  ;
                end
        end
    else
        begin
            S_pla_slice_sa04_cnt    <= S_pla_slice_sa04_cnt  ;
        end
end
always@(posedge I_sys_312m_clk)
begin
    if(S_pla_slice_sa05_cnt_clr)
        begin
            S_pla_slice_sa05_cnt    <= 16'h0    ;
        end
    else if({S_subport_num,S_pla_vlan_id[2:0]} == 5'h5)
        begin
            if(S_pla_vlan_id_check)
                begin
                    if((~S_pla_vlan_ind_d2) && (S_pla_vlan_ind_d3))
                        begin
                            S_pla_slice_sa05_cnt    <= S_pla_slice_sa05_cnt + 1'b1  ;
                        end
                    else
                        begin
                            S_pla_slice_sa05_cnt    <= S_pla_slice_sa05_cnt  ;
                        end
                end
            else
                begin
                    S_pla_slice_sa05_cnt    <= S_pla_slice_sa05_cnt  ;
                end
        end
    else
        begin
            S_pla_slice_sa05_cnt    <= S_pla_slice_sa05_cnt  ;
        end
end
always@(posedge I_sys_312m_clk)
begin
    if(S_pla_slice_sa06_cnt_clr)
        begin
            S_pla_slice_sa06_cnt    <= 16'h0    ;
        end
    else if({S_subport_num,S_pla_vlan_id[2:0]} == 5'h6)
        begin
            if(S_pla_vlan_id_check)
                begin
                    if((~S_pla_vlan_ind_d2) && (S_pla_vlan_ind_d3))
                        begin
                            S_pla_slice_sa06_cnt    <= S_pla_slice_sa06_cnt + 1'b1  ;
                        end
                    else
                        begin
                            S_pla_slice_sa06_cnt    <= S_pla_slice_sa06_cnt  ;
                        end
                end
            else
                begin
                    S_pla_slice_sa06_cnt    <= S_pla_slice_sa06_cnt  ;
                end
        end
    else
        begin
            S_pla_slice_sa06_cnt    <= S_pla_slice_sa06_cnt  ;
        end
end
always@(posedge I_sys_312m_clk)
begin
    if(S_pla_slice_sa07_cnt_clr)
        begin
            S_pla_slice_sa07_cnt    <= 16'h0    ;
        end
    else if({S_subport_num,S_pla_vlan_id[2:0]} == 5'h7)
        begin
            if(S_pla_vlan_id_check)
                begin
                    if((~S_pla_vlan_ind_d2) && (S_pla_vlan_ind_d3))
                        begin
                            S_pla_slice_sa07_cnt    <= S_pla_slice_sa07_cnt + 1'b1  ;
                        end
                    else
                        begin
                            S_pla_slice_sa07_cnt    <= S_pla_slice_sa07_cnt  ;
                        end
                end
            else
                begin
                    S_pla_slice_sa07_cnt    <= S_pla_slice_sa07_cnt  ;
                end
        end
    else
        begin
            S_pla_slice_sa07_cnt    <= S_pla_slice_sa07_cnt  ;
        end
end
//subport_num:1
always@(posedge I_sys_312m_clk)
begin
    if(S_pla_slice_sa10_cnt_clr)
        begin
            S_pla_slice_sa10_cnt    <= 16'h0    ;
        end
    else if({S_subport_num,S_pla_vlan_id[2:0]} == 5'h8)
        begin
            if(S_pla_vlan_id_check)
                begin
                    if((~S_pla_vlan_ind_d2) && (S_pla_vlan_ind_d3))
                        begin
                            S_pla_slice_sa10_cnt    <= S_pla_slice_sa10_cnt + 1'b1  ;
                        end
                    else
                        begin
                            S_pla_slice_sa10_cnt    <= S_pla_slice_sa10_cnt  ;
                        end
                end
            else
                begin
                    S_pla_slice_sa10_cnt    <= S_pla_slice_sa10_cnt  ;
                end
        end
    else
        begin
            S_pla_slice_sa10_cnt    <= S_pla_slice_sa10_cnt  ;
        end
end
always@(posedge I_sys_312m_clk)
begin
    if(S_pla_slice_sa11_cnt_clr)
        begin
            S_pla_slice_sa11_cnt    <= 16'h0    ;
        end
    else if({S_subport_num,S_pla_vlan_id[2:0]} == 5'h9)
        begin
            if(S_pla_vlan_id_check)
                begin
                    if((~S_pla_vlan_ind_d2) && (S_pla_vlan_ind_d3))
                        begin
                            S_pla_slice_sa11_cnt    <= S_pla_slice_sa11_cnt + 1'b1  ;
                        end
                    else
                        begin
                            S_pla_slice_sa11_cnt    <= S_pla_slice_sa11_cnt  ;
                        end
                end
            else
                begin
                    S_pla_slice_sa11_cnt    <= S_pla_slice_sa11_cnt  ;
                end
        end
    else
        begin
            S_pla_slice_sa11_cnt    <= S_pla_slice_sa11_cnt  ;
        end
end
always@(posedge I_sys_312m_clk)
begin
    if(S_pla_slice_sa12_cnt_clr)
        begin
            S_pla_slice_sa12_cnt    <= 16'h0    ;
        end
    else if({S_subport_num,S_pla_vlan_id[2:0]} == 5'ha)
        begin
            if(S_pla_vlan_id_check)
                begin
                    if((~S_pla_vlan_ind_d2) && (S_pla_vlan_ind_d3))
                        begin
                            S_pla_slice_sa12_cnt    <= S_pla_slice_sa12_cnt + 1'b1  ;
                        end
                    else
                        begin
                            S_pla_slice_sa12_cnt    <= S_pla_slice_sa12_cnt  ;
                        end
                end
            else
                begin
                    S_pla_slice_sa12_cnt    <= S_pla_slice_sa12_cnt  ;
                end
        end
    else
        begin
            S_pla_slice_sa12_cnt    <= S_pla_slice_sa12_cnt  ;
        end
end
always@(posedge I_sys_312m_clk)
begin
    if(S_pla_slice_sa13_cnt_clr)
        begin
            S_pla_slice_sa13_cnt    <= 16'h0    ;
        end
    else if({S_subport_num,S_pla_vlan_id[2:0]} == 5'hb)
        begin
            if(S_pla_vlan_id_check)
                begin
                    if((~S_pla_vlan_ind_d2) && (S_pla_vlan_ind_d3))
                        begin
                            S_pla_slice_sa13_cnt    <= S_pla_slice_sa13_cnt + 1'b1  ;
                        end
                    else
                        begin
                            S_pla_slice_sa13_cnt    <= S_pla_slice_sa13_cnt  ;
                        end
                end
            else
                begin
                    S_pla_slice_sa13_cnt    <= S_pla_slice_sa13_cnt  ;
                end
        end
    else
        begin
            S_pla_slice_sa13_cnt    <= S_pla_slice_sa13_cnt  ;
        end
end
always@(posedge I_sys_312m_clk)
begin
    if(S_pla_slice_sa14_cnt_clr)
        begin
            S_pla_slice_sa14_cnt    <= 16'h0    ;
        end
    else if({S_subport_num,S_pla_vlan_id[2:0]} == 5'hc)
        begin
            if(S_pla_vlan_id_check)
                begin
                    if((~S_pla_vlan_ind_d2) && (S_pla_vlan_ind_d3))
                        begin
                            S_pla_slice_sa14_cnt    <= S_pla_slice_sa14_cnt + 1'b1  ;
                        end
                    else
                        begin
                            S_pla_slice_sa14_cnt    <= S_pla_slice_sa14_cnt  ;
                        end
                end
            else
                begin
                    S_pla_slice_sa14_cnt    <= S_pla_slice_sa14_cnt  ;
                end
        end
    else
        begin
            S_pla_slice_sa14_cnt    <= S_pla_slice_sa14_cnt  ;
        end
end
always@(posedge I_sys_312m_clk)
begin
    if(S_pla_slice_sa15_cnt_clr)
        begin
            S_pla_slice_sa15_cnt    <= 16'h0    ;
        end
    else if({S_subport_num,S_pla_vlan_id[2:0]} == 5'hd)
        begin
            if(S_pla_vlan_id_check)
                begin
                    if((~S_pla_vlan_ind_d2) && (S_pla_vlan_ind_d3))
                        begin
                            S_pla_slice_sa15_cnt    <= S_pla_slice_sa15_cnt + 1'b1  ;
                        end
                    else
                        begin
                            S_pla_slice_sa15_cnt    <= S_pla_slice_sa15_cnt  ;
                        end
                end
            else
                begin
                    S_pla_slice_sa15_cnt    <= S_pla_slice_sa15_cnt  ;
                end
        end
    else
        begin
            S_pla_slice_sa15_cnt    <= S_pla_slice_sa15_cnt  ;
        end
end
always@(posedge I_sys_312m_clk)
begin
    if(S_pla_slice_sa16_cnt_clr)
        begin
            S_pla_slice_sa16_cnt    <= 16'h0    ;
        end
    else if({S_subport_num,S_pla_vlan_id[2:0]} == 5'he)
        begin
            if(S_pla_vlan_id_check)
                begin
                    if((~S_pla_vlan_ind_d2) && (S_pla_vlan_ind_d3))
                        begin
                            S_pla_slice_sa16_cnt    <= S_pla_slice_sa16_cnt + 1'b1  ;
                        end
                    else
                        begin
                            S_pla_slice_sa16_cnt    <= S_pla_slice_sa16_cnt  ;
                        end
                end
            else
                begin
                    S_pla_slice_sa16_cnt    <= S_pla_slice_sa16_cnt  ;
                end
        end
    else
        begin
            S_pla_slice_sa16_cnt    <= S_pla_slice_sa16_cnt  ;
        end
end
always@(posedge I_sys_312m_clk)
begin
    if(S_pla_slice_sa17_cnt_clr)
        begin
            S_pla_slice_sa17_cnt    <= 16'h0    ;
        end
    else if({S_subport_num,S_pla_vlan_id[2:0]} == 5'hf)
        begin
            if(S_pla_vlan_id_check)
                begin
                    if((~S_pla_vlan_ind_d2) && (S_pla_vlan_ind_d3))
                        begin
                            S_pla_slice_sa17_cnt    <= S_pla_slice_sa17_cnt + 1'b1  ;
                        end
                    else
                        begin
                            S_pla_slice_sa17_cnt    <= S_pla_slice_sa17_cnt  ;
                        end
                end
            else
                begin
                    S_pla_slice_sa17_cnt    <= S_pla_slice_sa17_cnt  ;
                end
        end
    else
        begin
            S_pla_slice_sa17_cnt    <= S_pla_slice_sa17_cnt  ;
        end
end
//subport_num:2
always@(posedge I_sys_312m_clk)
begin
    if(S_pla_slice_sa20_cnt_clr)
        begin
            S_pla_slice_sa20_cnt    <= 16'h0    ;
        end
    else if({S_subport_num,S_pla_vlan_id[2:0]} == 5'h10)
        begin
            if(S_pla_vlan_id_check)
                begin
                    if((~S_pla_vlan_ind_d2) && (S_pla_vlan_ind_d3))
                        begin
                            S_pla_slice_sa20_cnt    <= S_pla_slice_sa20_cnt + 1'b1  ;
                        end
                    else
                        begin
                            S_pla_slice_sa20_cnt    <= S_pla_slice_sa20_cnt  ;
                        end
                end
            else
                begin
                    S_pla_slice_sa20_cnt    <= S_pla_slice_sa20_cnt  ;
                end
        end
    else
        begin
            S_pla_slice_sa20_cnt    <= S_pla_slice_sa20_cnt  ;
        end
end
always@(posedge I_sys_312m_clk)
begin
    if(S_pla_slice_sa21_cnt_clr)
        begin
            S_pla_slice_sa21_cnt    <= 16'h0    ;
        end
    else if({S_subport_num,S_pla_vlan_id[2:0]} == 5'h11)
        begin
            if(S_pla_vlan_id_check)
                begin
                    if((~S_pla_vlan_ind_d2) && (S_pla_vlan_ind_d3))
                        begin
                            S_pla_slice_sa21_cnt    <= S_pla_slice_sa21_cnt + 1'b1  ;
                        end
                    else
                        begin
                            S_pla_slice_sa21_cnt    <= S_pla_slice_sa21_cnt  ;
                        end
                end
            else
                begin
                    S_pla_slice_sa21_cnt    <= S_pla_slice_sa21_cnt  ;
                end
        end
    else
        begin
            S_pla_slice_sa21_cnt    <= S_pla_slice_sa21_cnt  ;
        end
end
always@(posedge I_sys_312m_clk)
begin
    if(S_pla_slice_sa22_cnt_clr)
        begin
            S_pla_slice_sa22_cnt    <= 16'h0    ;
        end
    else if({S_subport_num,S_pla_vlan_id[2:0]} == 5'h12)
        begin
            if(S_pla_vlan_id_check)
                begin
                    if((~S_pla_vlan_ind_d2) && (S_pla_vlan_ind_d3))
                        begin
                            S_pla_slice_sa22_cnt    <= S_pla_slice_sa22_cnt + 1'b1  ;
                        end
                    else
                        begin
                            S_pla_slice_sa22_cnt    <= S_pla_slice_sa22_cnt  ;
                        end
                end
            else
                begin
                    S_pla_slice_sa22_cnt    <= S_pla_slice_sa22_cnt  ;
                end
        end
    else
        begin
            S_pla_slice_sa22_cnt    <= S_pla_slice_sa22_cnt  ;
        end
end
always@(posedge I_sys_312m_clk)
begin
    if(S_pla_slice_sa23_cnt_clr)
        begin
            S_pla_slice_sa23_cnt    <= 16'h0    ;
        end
    else if({S_subport_num,S_pla_vlan_id[2:0]} == 5'h13)
        begin
            if(S_pla_vlan_id_check)
                begin
                    if((~S_pla_vlan_ind_d2) && (S_pla_vlan_ind_d3))
                        begin
                            S_pla_slice_sa23_cnt    <= S_pla_slice_sa23_cnt + 1'b1  ;
                        end
                    else
                        begin
                            S_pla_slice_sa23_cnt    <= S_pla_slice_sa23_cnt  ;
                        end
                end
            else
                begin
                    S_pla_slice_sa23_cnt    <= S_pla_slice_sa23_cnt  ;
                end
        end
    else
        begin
            S_pla_slice_sa23_cnt    <= S_pla_slice_sa23_cnt  ;
        end
end
always@(posedge I_sys_312m_clk)
begin
    if(S_pla_slice_sa24_cnt_clr)
        begin
            S_pla_slice_sa24_cnt    <= 16'h0    ;
        end
    else if({S_subport_num,S_pla_vlan_id[2:0]} == 5'h14)
        begin
            if(S_pla_vlan_id_check)
                begin
                    if((~S_pla_vlan_ind_d2) && (S_pla_vlan_ind_d3))
                        begin
                            S_pla_slice_sa24_cnt    <= S_pla_slice_sa24_cnt + 1'b1  ;
                        end
                    else
                        begin
                            S_pla_slice_sa24_cnt    <= S_pla_slice_sa24_cnt  ;
                        end
                end
            else
                begin
                    S_pla_slice_sa24_cnt    <= S_pla_slice_sa24_cnt  ;
                end
        end
    else
        begin
            S_pla_slice_sa24_cnt    <= S_pla_slice_sa24_cnt  ;
        end
end
always@(posedge I_sys_312m_clk)
begin
    if(S_pla_slice_sa25_cnt_clr)
        begin
            S_pla_slice_sa25_cnt    <= 16'h0    ;
        end
    else if({S_subport_num,S_pla_vlan_id[2:0]} == 5'h15)
        begin
            if(S_pla_vlan_id_check)
                begin
                    if((~S_pla_vlan_ind_d2) && (S_pla_vlan_ind_d3))
                        begin
                            S_pla_slice_sa25_cnt    <= S_pla_slice_sa25_cnt + 1'b1  ;
                        end
                    else
                        begin
                            S_pla_slice_sa25_cnt    <= S_pla_slice_sa25_cnt  ;
                        end
                end
            else
                begin
                    S_pla_slice_sa25_cnt    <= S_pla_slice_sa25_cnt  ;
                end
        end
    else
        begin
            S_pla_slice_sa25_cnt    <= S_pla_slice_sa25_cnt  ;
        end
end
always@(posedge I_sys_312m_clk)
begin
    if(S_pla_slice_sa26_cnt_clr)
        begin
            S_pla_slice_sa26_cnt    <= 16'h0    ;
        end
    else if({S_subport_num,S_pla_vlan_id[2:0]} == 5'h16)
        begin
            if(S_pla_vlan_id_check)
                begin
                    if((~S_pla_vlan_ind_d2) && (S_pla_vlan_ind_d3))
                        begin
                            S_pla_slice_sa26_cnt    <= S_pla_slice_sa26_cnt + 1'b1  ;
                        end
                    else
                        begin
                            S_pla_slice_sa26_cnt    <= S_pla_slice_sa26_cnt  ;
                        end
                end
            else
                begin
                    S_pla_slice_sa26_cnt    <= S_pla_slice_sa26_cnt  ;
                end
        end
    else
        begin
            S_pla_slice_sa26_cnt    <= S_pla_slice_sa26_cnt  ;
        end
end
always@(posedge I_sys_312m_clk)
begin
    if(S_pla_slice_sa27_cnt_clr)
        begin
            S_pla_slice_sa27_cnt    <= 16'h0    ;
        end
    else if({S_subport_num,S_pla_vlan_id[2:0]} == 5'h17)
        begin
            if(S_pla_vlan_id_check)
                begin
                    if((~S_pla_vlan_ind_d2) && (S_pla_vlan_ind_d3))
                        begin
                            S_pla_slice_sa27_cnt    <= S_pla_slice_sa27_cnt + 1'b1  ;
                        end
                    else
                        begin
                            S_pla_slice_sa27_cnt    <= S_pla_slice_sa27_cnt  ;
                        end
                end
            else
                begin
                    S_pla_slice_sa27_cnt    <= S_pla_slice_sa27_cnt  ;
                end
        end
    else
        begin
            S_pla_slice_sa27_cnt    <= S_pla_slice_sa27_cnt  ;
        end
end
//test end

endmodule