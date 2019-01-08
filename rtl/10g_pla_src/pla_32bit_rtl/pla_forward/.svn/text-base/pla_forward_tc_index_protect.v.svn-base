//FILE_HEADER-----------------------------------------------------------------
//ZTE  Copyright (C)
//ZTE Company Confidential
//----------------------------------------------------------------------------
//Project Name : RCUB PLA
//FILE NAME    : pla_schedule.v
//AUTHOR       : Li Shuai
//Department   : ZTE-BBU-SHENZHEN-DESIGN-DEPARTMENT
//Email        : li.shuai3@zte.com.cn
//----------------------------------------------------------------------------
//Module Hiberarchy :
//x          |--xxx1
//x          |--xxx2
//x xxx_xxx--|--xxx3 (为该模块包含的下一级子模块名，仅限一级，不需往下延伸，
//x          |--xxx4  如该模块没有下层模块，可不填)
//x          |--xxx5
//----------------------------------------------------------------------------
//Relaese History :
//----------------------------------------------------------------------------
//Version         Date           Author        Description
// 1.1          nov-10-2011      Li Shuai        pla_schedule
// 1.2
//----------------------------------------------------------------------------
//Main Function:
//a)pla_flow
//b)
//----------------------------------------------------------------------------
//REUSE ISSUES: xxxxxxxx
//Reset Strategy: xxxxxxxx
//Clock Strategy: xxxxxxxx
//Critical Timing: xxxxxxxx
//Asynchronous Interface: xxxxxxxx
//END_HEADER------------------------------------------------------------------
`timescale 1ns/1ns

module pla_forward_tc_index_protect(
input                   I_pla_312m5_clk           ,   ///模块全局时钟
input                   I_pla_rst                 ,   ///模块复位信号
input                   I_pla_tc_index_en         ,   ///
input                   I_pla_tc_protect_en       ,
input         [7:0]     I_pla_tc_index            ,   ///
input         [15:0]    I_pla_tc_protect_cnt      ,
input         [7:0]     I_rmuc_request            ,
output                  O_pla_tc_protect_out      ,
output reg    [15:0]    O_pla_tc_protect_out_cnt  ,
output reg              O_pla_tc_index_en     
);

reg  [15:0]  S_pla_tc_protect_cnt     ;
reg          S_pla_tc_protect_out      ;
reg          S1_pla_tc_protect_out     ;


reg  [10:0]   S_pla_312m5_4us_clk_cnt   = 11'd0  ;
reg           S_pla_4us_clk             = 1'b0   ;

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


always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
        begin
            S_pla_tc_protect_cnt <= 16'hffff;
        end
    else if(((I_pla_tc_index & I_rmuc_request) != 4'd0) || (I_pla_tc_index_en == 1'b0) || (I_pla_tc_protect_en == 1'b0))
        begin
            S_pla_tc_protect_cnt <= 16'd0;
        end
    else if(S_pla_4us_clk)
        begin
            if(S_pla_tc_protect_cnt >= I_pla_tc_protect_cnt)
                begin
                    S_pla_tc_protect_cnt <= S_pla_tc_protect_cnt;
                end
            else
                begin
                    S_pla_tc_protect_cnt <= S_pla_tc_protect_cnt + 16'd1;
                end
        end
end

always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
        begin
            S_pla_tc_protect_out <= 1'b1;
        end
    else if(S_pla_tc_protect_cnt >= I_pla_tc_protect_cnt)
        begin
            S_pla_tc_protect_out <= 1'b1;
        end
    else
        begin
            S_pla_tc_protect_out <= 1'b0;
        end
end

assign O_pla_tc_protect_out = S_pla_tc_protect_out;

always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
        begin
            O_pla_tc_index_en <= 1'b0;
        end
    else if(S_pla_tc_protect_out)
        begin
            O_pla_tc_index_en <= 1'b0;
        end
    else
        begin
            O_pla_tc_index_en <= I_pla_tc_index_en;
        end
end

always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
        begin
            S1_pla_tc_protect_out <= 1'b0;
        end
    else
        begin
            S1_pla_tc_protect_out <= S_pla_tc_protect_out;
        end
end

always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        O_pla_tc_protect_out_cnt <= 16'd0;
    end
    else if(I_pla_tc_index_en)
    begin
        if(S1_pla_tc_protect_out && S_pla_tc_protect_out && S_pla_4us_clk)    
            O_pla_tc_protect_out_cnt <= O_pla_tc_protect_out_cnt + 16'd1;
    end
end

endmodule
