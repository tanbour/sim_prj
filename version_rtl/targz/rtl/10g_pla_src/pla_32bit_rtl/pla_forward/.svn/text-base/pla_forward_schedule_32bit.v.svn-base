//FILE_HEADER-----------------------------------------------------------------
//ZTE  Copyright (C)
//ZTE Company Confidential
//----------------------------------------------------------------------------
//Project Name : RCUB PLA
//FILE NAME    : pla_forward_schedule_32bit.v
//AUTHOR       : xXX xxx                        
//Department   : Tianjin Development Department 
//Email        : sxxxx.xxx@zte.com.cn           
//----------------------------------------------------------------------------
//Module Hiberarchy :
//x                             |--xxx1
//x                             |--xxx2
//x pla_forward_schedule_32bit--|--xxx3 ，
//x                             |--xxx4 
//----------------------------------------------------------------------------
//Relaese History :
//----------------------------------------------------------------------------
//Version         Date           Author        Description
// 1.1          nov-10-2011      Li Shuai        pla_schedule
// 1.2
//----------------------------------------------------------------------------
//Main Function:
//a)该模块由三组PLA分别例化。主要对反向解析出来的切片报文请求Request进行调度处理。
//  调度依据为简单轮询，在切片模块不忙情况下，发出切片发送请求。同时，还支持PTP的
//  定向发送功能。由前向切片模块判断接下来的切片是否是PTP报文，如果是，则由本模块
//  进行指定端口的调度。
//----------------------------------------------------------------------------
//REUSE ISSUES: xxxxxxxx
//Reset Strategy: xxxxxxxx
//Clock Strategy: xxxxxxxx
//Critical Timing: xxxxxxxx
//Asynchronous Interface: xxxxxxxx
//END_HEADER------------------------------------------------------------------
`timescale 1ns/1ns
module pla_forward_schedule_32bit(
    input              I_pla_312m5_clk         , //// 时钟                     
    input              I_pla_rst               , //// 复位                     
    input       [7:0]  I_pla_tc_index          , //// TC定向发送方向指示  :CPU send      
    input              I_slice_ptp_req          , //// PTP报文定向发送请求 :前向切片模块发出 
         
    input       [7:0]  I_pla_air_link          , //// 空口link指示              
    input       [7:0]  I_pla_air_request       , //// 反向解析的切片请求pulse   
    input              I_pla_slice_idle        , //// 切片空闲指示，可以发送请求
    input       [7:0]  I_pla_slice_fifo_empty  , //// 切片fifo空指示，空才可发送    
    output      [7:0]  O_pla_slice_send_req       //// 处理后的切片请求pulse 
);                                                                             


///----------------- reg and wire ----------------///
reg [7:0]  S_buff_ready_reg      ; ///标识哪个buff现在可以写入，wr有效

reg        S_buff_ready_flag     ;
reg        S1_buff_ready_flag    ;
reg        S2_buff_ready_flag    ;
reg        S3_buff_ready_flag    ;
reg        S_slice_ptp_req       ; ///

reg [7:0]  S_pla_slice_req_mask  ; ///
reg [7:0]  S_pla_tc_index        ;
reg [7:0]  S_pla_air_link        ;
reg        S_pla_slice_idle      ;
//// reg [7:0]  S_req_over_flag       ; ////S_rmuc_request_en有效后开始计时，超出设定值后置位
reg [15:0] S_reqen_cnt [7:0]     ; ///S_rmuc_request_en有效计时
reg [7:0]  S_slice_req           ;


///提高REQUEST信号效率
reg [7:0] S1_pla_air_request ;

reg [7:0]S_pla_slice_fifo_empty;
reg [7:0]S1_pla_slice_fifo_empty;


always@(posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S_pla_tc_index   <= 8'h0 ;
        S_pla_air_link   <= 8'h0 ;
        S_pla_slice_idle <= 1'd0; 
        S_slice_ptp_req  <= 1'b0;
        S_pla_slice_fifo_empty <= 8'd0;
        S1_pla_slice_fifo_empty <= 8'd0;
    end
    else
    begin
        S_pla_tc_index   <= I_pla_tc_index;
        S_pla_air_link   <= I_pla_air_link;
        S_pla_slice_idle <= I_pla_slice_idle;
        S_pla_slice_fifo_empty  <= I_pla_slice_fifo_empty;
        S1_pla_slice_fifo_empty <= S_pla_slice_fifo_empty;
    end  
end


always@(posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
        S_pla_slice_req_mask <= 8'hff ;
    else if(I_slice_ptp_req)
        S_pla_slice_req_mask <= S_pla_tc_index;
    else
        S_pla_slice_req_mask <= 8'hff ;
end


assign O_pla_slice_send_req = S_buff_ready_reg;


///===============================================================
/// S_rmuc_request_en,在超时或者有切片响应时复位
/// I_pla_air_request 有效，并且还未响应发送；
/// I_pla_air_link有效，空口link，可以发送，该条件可以取消，因为不link的时候，不会有request。
/// I_pla_slice_idle有效，切片模块空闲，可以发送；目的是简化切片操作。
/// I_pla_slice_fifo_empty无效，对应的切片缓存空闲，可以发送；
/// S_pla_slice_req_mask 无效，该空口可以发送。
///===============================================================

generate
genvar i;
for(i=0;i<8;i=i+1)
begin :rmuc_request

     always@(posedge I_pla_312m5_clk or posedge I_pla_rst)
        if (I_pla_rst)
        begin
            S_slice_req[i] <= 1'b0;
            S1_pla_air_request[i] <= 1'b0;
        end    
        else 
        begin    
            if(I_pla_air_request[i] && I_pla_slice_fifo_empty[i]) 
            begin
                S_slice_req[i] <= 1'b1;
            end  
            else if(S_buff_ready_reg[i])
            begin
                S_slice_req[i] <= 1'b0 ;
            end
            else if (I_pla_slice_idle && S1_pla_air_request[i])
            begin
                S_slice_req[i] <= 1'b1;
            end     
            
            if(I_pla_air_request[i]) 
            begin
               S1_pla_air_request[i] <= 1'b1;
            end
            else if(S_buff_ready_reg[i])
            begin
               S1_pla_air_request[i] <= 1'b0;
            end  
            
        end      
     end   
endgenerate


///===============================================================
/// 在slice未进行切片时，根据已有的req_en，按照优先级发出切片使能
///===============================================================

always@(posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S_buff_ready_reg <= 8'b0 ;
        S_buff_ready_flag <= 1'b0 ;
    end
    ///正在切片则不发送写切片使能
   else if( ((!S_pla_slice_idle)) || (S_buff_ready_flag || S1_buff_ready_flag || S2_buff_ready_flag || S3_buff_ready_flag) )
    
    begin
        S_buff_ready_reg <= 8'b0 ;
        S_buff_ready_flag <= 1'b0 ;
    end
    ///按照0、1、2、3...优先级发送写切片使能    
    else if(S_pla_air_link[0] && S_slice_req[0] && S_pla_slice_req_mask[0] && S1_pla_slice_fifo_empty[0])
    begin
        S_buff_ready_reg <= 8'b00000001 ;
        S_buff_ready_flag <= 1'b1 ;
    end 
    else if(S_pla_air_link[1] && S_slice_req[1] && S_pla_slice_req_mask[1] && S1_pla_slice_fifo_empty[1])
    begin
        S_buff_ready_reg <= 8'b00000010 ;
        S_buff_ready_flag <= 1'b1 ;
    end 
    else if(S_pla_air_link[2] && S_slice_req[2] && S_pla_slice_req_mask[2] && S1_pla_slice_fifo_empty[2])
    begin
        S_buff_ready_reg <= 8'b00000100 ;
        S_buff_ready_flag <= 1'b1 ;
    end 
    else if(S_pla_air_link[3] && S_slice_req[3] && S_pla_slice_req_mask[3] && S1_pla_slice_fifo_empty[3])
    begin
        S_buff_ready_reg <= 8'b00001000 ;
        S_buff_ready_flag <= 1'b1 ;
    end 
    else if(S_pla_air_link[4] && S_slice_req[4] && S_pla_slice_req_mask[4] && S1_pla_slice_fifo_empty[4])
    begin
        S_buff_ready_reg <= 8'b00010000 ;
        S_buff_ready_flag <= 1'b1 ;
    end 
    else if(S_pla_air_link[5] && S_slice_req[5] && S_pla_slice_req_mask[5] && S1_pla_slice_fifo_empty[5])
    begin
        S_buff_ready_reg <= 8'b00100000 ;
        S_buff_ready_flag <= 1'b1 ;
    end 
    else if(S_pla_air_link[6] && S_slice_req[6] && S_pla_slice_req_mask[6] && S1_pla_slice_fifo_empty[6])
    begin
        S_buff_ready_reg <= 8'b01000000 ;
        S_buff_ready_flag <= 1'b1 ;
    end 
    else if(S_pla_air_link[7] && S_slice_req[7] && S_pla_slice_req_mask[7] && S1_pla_slice_fifo_empty[7])
    begin
        S_buff_ready_reg <= 8'b10000000 ;
        S_buff_ready_flag <= 1'b1 ;
    end 
            
    ///其他    
    else
    begin
        S_buff_ready_reg <= 8'b0 ;
        S_buff_ready_flag <= 1'b0 ;
    end 
end        


always@(posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S1_buff_ready_flag <= 1'b0 ;
        S2_buff_ready_flag <= 1'b0 ;
        S3_buff_ready_flag <= 1'b0 ;
    end       
    else
    begin
        S1_buff_ready_flag <= S_buff_ready_flag ;
        S2_buff_ready_flag <= S1_buff_ready_flag ;
        S3_buff_ready_flag <= S2_buff_ready_flag ;    
    end
end


endmodule
