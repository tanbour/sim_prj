//FILE_HEADER-----------------------------------------------------------------
//ZTE  Copyright (C)
//ZTE Company Confidential
//----------------------------------------------------------------------------
//Project Name : 
//FILE NAME    : pla_request_gen.v
//AUTHOR       : xXX xxx                        
//Department   : Tianjin Development Department 
//Email        : sxxxx.xxx@zte.com.cn    
//----------------------------------------------------------------------------
//Module Hiberarchy :
//x                      |----
//x                      |----
//x  pla_request_gen  ---|----
//----------------------------------------------------------------------------
//Relaese History :
//----------------------------------------------------------------------------
//Version         Date           Author        Description
// 1.0            2014-10-20     Z...          New Generate
//----------------------------------------------------------------------------
//Main Function:PLA reqeuest产生模块,根据反向的REQEUSET报文收到的ACM和PAUSE的
//选择request
//----------------------------------------------------------------------------
//REUSE ISSUES: empty
//Reset Strategy: empty
//Clock Strategy: empty
//Critical Timing: empty
//Asynchronous Interface: empty
//END_HEADER------------------------------------------------------------------

`timescale 1ns/1ns

module pla_request_gen
(                   
    input                  I_pla_main_clk      ,   /// 时钟               
    input                  I_pla_rst           ,   /// 复位
    input                  I_cnt_value_clr     ,
    input                  I_pla_sel           ,
    input                  I_pla_req           ,
    input        [31:0]    I_pla_test_freq     ,   /// QPSK date_rate      test使用
    input        [31:0]    I_pla_rmu_freq      ,   /// QPSK date_rate                                           
    input        [3:0]     I_txpla_acm_mode    ,   ///ACM PLA TX
    input                  I_tx_pause          ,   ///PAUSE
    input                  I_tx_link           ,   ///LINK
    
    output  reg  [31:0]    O_pla_current_freq  ,
    output  reg  [15:0]    O_pla_req_change_cnt,
    output  reg            O_pla_request     
);                                                                                  

reg  [3:0]     S_txpla_acm_mode_buf1 ;  ///ACM PLA TX
reg  [3:0]     S_txpla_acm_mode_buf2 ;  ///ACM PLA TX
reg  [3:0]     S_txpla_acm_mode_buf3 ;  ///ACM PLA TX
reg  [3:0]     S_txpla_acm_mode      ;
reg            S_tx_pause_buf1       ;  ///PAUSE
reg            S_tx_pause_buf2       ;  ///PAUSE
reg            S_tx_pause_buf3       ;  ///PAUSE
reg            S_tx_link_buf1        ;  ///LINK
reg            S_tx_link_buf2        ;  ///LINK
reg            S_tx_link_buf3        ;  ///LINK 
reg            S_pla_req_buf1        ;
reg            S_pla_req_buf2        ;
reg  [31:0]    S_current_rate        ; 
reg  [25:0]    S_req1_cnt             ;
reg            S_req_cnt_gen_flg     ;
reg            S_req_cnt_gen_flg_buf ;

reg            S_pla_request_gen     ;
reg            S_pla_request_buf1    ;
reg            S_pla_request_buf2    ;

reg  [31:0]    S_pla_test_freq    ; 


always @ (posedge I_pla_main_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
        begin
            S_pla_req_buf1 <= 1'b0;
            S_pla_req_buf2 <= 1'b0;
            S_pla_test_freq <= 32'd0;
        end
    else
        begin
            S_pla_req_buf1  <= I_pla_req;
            S_pla_req_buf2  <= S_pla_req_buf1;
            S_pla_test_freq <= I_pla_test_freq;
        end
end

always @ (posedge I_pla_main_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
        begin
            S_txpla_acm_mode_buf1 <= 4'd0;
            S_txpla_acm_mode_buf2 <= 4'd0;
            S_txpla_acm_mode_buf3 <= 4'd0;
        end
    else
        begin
            S_txpla_acm_mode_buf1 <= I_txpla_acm_mode;
            S_txpla_acm_mode_buf2 <= S_txpla_acm_mode_buf1;
            S_txpla_acm_mode_buf3 <= S_txpla_acm_mode_buf2;
        end
end

always @ (posedge I_pla_main_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
        begin
            S_tx_pause_buf1 <= 1'b0;
            S_tx_pause_buf2 <= 1'b0;
            S_tx_pause_buf3 <= 1'b0;
        end
    else
        begin
            S_tx_pause_buf1 <= I_tx_pause;
            S_tx_pause_buf2 <= S_tx_pause_buf1;
            S_tx_pause_buf3 <= S_tx_pause_buf2;
        end
end

always @ (posedge I_pla_main_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
        begin
            S_tx_link_buf1 <= 1'b0;
            S_tx_link_buf2 <= 1'b0;
            S_tx_link_buf3 <= 1'b0;
        end
    else
        begin
            S_tx_link_buf1 <= I_tx_link;
            S_tx_link_buf2 <= S_tx_link_buf1;
            S_tx_link_buf3 <= S_tx_link_buf2;
        end
end

always @ (posedge I_pla_main_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
        begin
            S_txpla_acm_mode <= 4'd0;
        end
    else if(S_txpla_acm_mode_buf2 == S_txpla_acm_mode_buf3)
        begin
            S_txpla_acm_mode <= S_txpla_acm_mode_buf3;
        end
end


always @ (posedge I_pla_main_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S_current_rate <= 32'd0;
    end    
    else if(S_pla_test_freq[31]) 
    begin
        S_current_rate <= S_pla_test_freq ;
    end
    else 
    begin
        S_current_rate <= I_pla_rmu_freq; 
    end
end

always @ (posedge I_pla_main_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        O_pla_current_freq <= 32'd0;
    end    
    else 
    begin
        O_pla_current_freq <= S_current_rate;
    end
end


always @ (posedge I_pla_main_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
        begin
            S_req1_cnt <= 26'd0;
        end
    else if(!S_tx_link_buf2 || S_req_cnt_gen_flg || S_tx_pause_buf2)/// 
        begin
            S_req1_cnt <= 26'd0; 
        end
    else
        begin
            S_req1_cnt <= S_req1_cnt + 26'd1; 
        end
end

always @ (posedge I_pla_main_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
        begin
            S_req_cnt_gen_flg <= 1'b0;
        end
    else if(S_req1_cnt >= (S_current_rate[25:0] - 26'h2) && !S_req_cnt_gen_flg)
        begin
            S_req_cnt_gen_flg <= 1'b1;
        end
    else
        begin
            S_req_cnt_gen_flg <= 1'b0;
        end
end

always @ (posedge I_pla_main_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
        begin
            S_req_cnt_gen_flg_buf <= 1'b0;
        end
    else
        begin
            S_req_cnt_gen_flg_buf <= S_req_cnt_gen_flg;///posedge 
        end
end

always @ (posedge I_pla_main_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
        begin
            S_pla_request_gen <= 1'b0;
        end
    else if((!S_req_cnt_gen_flg_buf && S_req_cnt_gen_flg) || (!S_tx_pause_buf2 && S_tx_pause_buf3))
        begin
            S_pla_request_gen <= 1'b1;
        end
    else
        begin
            S_pla_request_gen <= 1'b0;
        end
end

always @ (posedge I_pla_main_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
        begin
            S_pla_request_buf1 <= 1'b0;
        end
    else if(I_pla_sel)
        begin
            S_pla_request_buf1 <= S_pla_request_gen;
        end
    else
        begin
            S_pla_request_buf1 <= S_pla_req_buf2;
        end
end

always @ (posedge I_pla_main_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
        begin
            S_pla_request_buf2 <= 1'b0;
        end
    else
        begin
            S_pla_request_buf2 <= S_pla_request_buf1;
        end
end

always @ (posedge I_pla_main_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
        begin
            O_pla_request <= 1'b0;
        end
    else
        begin
            O_pla_request <= S_pla_request_buf1 | S_pla_request_buf2;///扩展防止采不到
        end
end



always @ (posedge I_pla_main_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
        begin
            O_pla_req_change_cnt[7:0] <= 8'd0;
        end
    else if(I_cnt_value_clr)
        begin
            O_pla_req_change_cnt[7:0] <= 8'd0;
        end
    else if(S_tx_pause_buf2 ^ S_tx_pause_buf3)
        begin
            O_pla_req_change_cnt[7:0] <= O_pla_req_change_cnt[7:0] + 8'd1;
        end
end

always @ (posedge I_pla_main_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
        begin
            O_pla_req_change_cnt[15:8] <= 8'd0;
        end
    else if(I_cnt_value_clr)
        begin
            O_pla_req_change_cnt[15:8] <= 8'd0;
        end
    else if(S_tx_link_buf2 ^ S_tx_link_buf3)
        begin
            O_pla_req_change_cnt[15:8] <= O_pla_req_change_cnt[15:8] + 8'd1;
        end
end

endmodule





