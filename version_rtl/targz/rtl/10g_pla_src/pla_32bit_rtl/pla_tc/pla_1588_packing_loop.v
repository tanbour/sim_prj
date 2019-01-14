//FILE_HEADER-------------------------------------------------------
//ZTE Copyright(C)
// ZTE Company Confidential
//------------------------------------------------------------------
// Project Name : ZXLTE xxxx
// FILE NAME    : pla_1588_packing_loop.v
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
module pla_1588_packing_loop(
input          I_sys_312m_clk                 ,    // 
input          I_fpga_reset                   ,    //
input          I_bypass_en                    ,    //

input [3:0]    I_gmii_txc                     ,    //
input [31:0]   I_gmii_data                    ,    //
input [3:0]    I_pla_packing_txc              ,    //
input [31:0]   I_pla_packing_data             ,    //

output[3:0]    O_gmii_txc                     ,    //
output[31:0]   O_gmii_data                         //
);

reg            S_bypass_en                 = 1'b0          ;

(*mark_debug ="true"*)reg [3:0]      S_in_gmii_txc               = 4'hf          ;
(*mark_debug ="true"*)reg [31:0]     S_in_gmii_data              = 32'h07070707  ;
(*mark_debug ="true"*)reg [3:0]      S_in_pla_packing_txc        = 4'hf          ;
(*mark_debug ="true"*)reg [31:0]     S_in_pla_packing_data       = 32'h07070707  ;

(*mark_debug ="true"*)reg [3:0]      S_out_gmii_txc              = 4'hf          ;
(*mark_debug ="true"*)reg [31:0]     S_out_gmii_data             = 32'h07070707  ;

assign         O_gmii_txc   = S_out_gmii_txc    ;
assign         O_gmii_data  = S_out_gmii_data   ;

always@(posedge I_sys_312m_clk)
begin
    S_bypass_en         <= I_bypass_en          ;
end

always@(posedge I_sys_312m_clk)
begin
    S_in_gmii_txc           <= I_gmii_txc           ;
    S_in_gmii_data          <= I_gmii_data          ;
    S_in_pla_packing_txc    <= I_pla_packing_txc    ;
    S_in_pla_packing_data   <= I_pla_packing_data   ;
end

always@(posedge I_sys_312m_clk)
begin
    if(S_bypass_en)
        begin
            S_out_gmii_txc      <=  S_in_gmii_txc      ;
            S_out_gmii_data     <=  S_in_gmii_data     ;
        end
    else
        begin
            S_out_gmii_txc      <=  S_in_pla_packing_txc      ;
            S_out_gmii_data     <=  S_in_pla_packing_data     ;
        end
end

endmodule