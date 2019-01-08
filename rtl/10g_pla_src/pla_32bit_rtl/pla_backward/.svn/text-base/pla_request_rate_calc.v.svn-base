//FILE_HEADER-----------------------------------------------------------------
//ZTE  Copyright (C)
//ZTE Company Confidential
//----------------------------------------------------------------------------
//Project Name : 
//FILE NAME    : pla_request_rate_calc.v
//AUTHOR       : xXX xxx                        
//Department   : Tianjin Development Department 
//Email        : sxxxx.xxx@zte.com.cn    
//----------------------------------------------------------------------------
//Module Hiberarchy :
//x                            |----P0_PLA_RMU_RATE
//x                            |----P1_PLA_RATE_LINK_INT_POS
//x  pla_request_rate_calc  ---|----
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

module pla_request_rate_calc
(                   
    input                  I_pla_main_clk     ,
    input                  I_pla_rst          ,
    input                  I_cnt_clear        ,
               
    input      [23:0]      I_pla_rmu_air_link  ,
    input      [23:0]      I_pla_air_link_change_mask,
    output     [23:0]      O_pla_air_link_change_flg ,
    
    input      [15:0]      I_pla00_rmu_rate   ,
    input      [15:0]      I_pla01_rmu_rate   ,
    input      [15:0]      I_pla02_rmu_rate   ,
    input      [15:0]      I_pla03_rmu_rate   ,
    input      [15:0]      I_pla04_rmu_rate   ,
    input      [15:0]      I_pla05_rmu_rate   ,
    input      [15:0]      I_pla06_rmu_rate   ,
    input      [15:0]      I_pla07_rmu_rate   ,
    input      [15:0]      I_pla10_rmu_rate   ,
    input      [15:0]      I_pla11_rmu_rate   ,
    input      [15:0]      I_pla12_rmu_rate   ,
    input      [15:0]      I_pla13_rmu_rate   ,
    input      [15:0]      I_pla14_rmu_rate   ,
    input      [15:0]      I_pla15_rmu_rate   ,
    input      [15:0]      I_pla16_rmu_rate   ,
    input      [15:0]      I_pla17_rmu_rate   ,
    input      [15:0]      I_pla20_rmu_rate   ,
    input      [15:0]      I_pla21_rmu_rate   ,
    input      [15:0]      I_pla22_rmu_rate   ,
    input      [15:0]      I_pla23_rmu_rate   ,
    input      [15:0]      I_pla24_rmu_rate   ,
    input      [15:0]      I_pla25_rmu_rate   ,
    input      [15:0]      I_pla26_rmu_rate   ,
    input      [15:0]      I_pla27_rmu_rate   ,

    output reg [19:0]      O_pla0_rmu_rate     ,
    output reg [19:0]      O_pla1_rmu_rate     ,
    output reg [19:0]      O_pla2_rmu_rate     ,
    
    output reg [15:0]      O_pla0_cu_rate_chg_cnt ,
    output reg [15:0]      O_pla1_cu_rate_chg_cnt ,
    output reg [15:0]      O_pla2_cu_rate_chg_cnt ,
    
    output     [15:0]      O_pla00_rmu_rate_chg_cnt ,
    output     [15:0]      O_pla01_rmu_rate_chg_cnt ,
    output     [15:0]      O_pla02_rmu_rate_chg_cnt ,
    output     [15:0]      O_pla03_rmu_rate_chg_cnt ,
    output     [15:0]      O_pla04_rmu_rate_chg_cnt ,
    output     [15:0]      O_pla05_rmu_rate_chg_cnt ,
    output     [15:0]      O_pla06_rmu_rate_chg_cnt ,
    output     [15:0]      O_pla07_rmu_rate_chg_cnt ,
    output     [15:0]      O_pla10_rmu_rate_chg_cnt ,
    output     [15:0]      O_pla11_rmu_rate_chg_cnt ,
    output     [15:0]      O_pla12_rmu_rate_chg_cnt ,
    output     [15:0]      O_pla13_rmu_rate_chg_cnt ,
    output     [15:0]      O_pla14_rmu_rate_chg_cnt ,
    output     [15:0]      O_pla15_rmu_rate_chg_cnt ,
    output     [15:0]      O_pla16_rmu_rate_chg_cnt ,
    output     [15:0]      O_pla17_rmu_rate_chg_cnt ,
    output     [15:0]      O_pla20_rmu_rate_chg_cnt ,
    output     [15:0]      O_pla21_rmu_rate_chg_cnt ,
    output     [15:0]      O_pla22_rmu_rate_chg_cnt ,
    output     [15:0]      O_pla23_rmu_rate_chg_cnt ,
    output     [15:0]      O_pla24_rmu_rate_chg_cnt ,
    output     [15:0]      O_pla25_rmu_rate_chg_cnt ,
    output     [15:0]      O_pla26_rmu_rate_chg_cnt ,
    output     [15:0]      O_pla27_rmu_rate_chg_cnt ,
    
    input       [15:0]     I_pla_int_mask  ,    
    input       [15:0]     I_pla_int_clr   ,
    input       [2:0]      I_hc_for_en     ,
            
    output reg  [15:0]     O_pla_rmu_int , 
    output reg  [15:0]     O_pla_int_event ,
    output reg             O_pla_int_n     

      
);                

reg  [19:0]  S_pla_rmu0_rate [2:0];
reg  [19:0]  S_pla_rmu1_rate [2:0];
reg  [19:0]  S_pla_rmu2_rate [2:0];
reg  [19:0]  S_pla_rmu3_rate [2:0];
reg  [19:0]  S_pla_rmu4_rate [2:0];
reg  [19:0]  S_pla_rmu5_rate [2:0];
reg  [19:0]  S_pla_rmu6_rate [2:0];
reg  [19:0]  S_pla_rmu7_rate [2:0];

reg  [19:0] S_pla_cu0_rate   [2:0];
reg  [19:0] S_pla_cu1_rate   [2:0];
reg  [19:0] S_pla_cu2_rate   [2:0];
reg  [19:0] S_pla_cu3_rate   [2:0];
reg  [19:0] S_pla_cu4_rate   [2:0];
reg  [19:0] S_pla_cu5_rate   [2:0];
reg  [19:0] S_pla_cu6_rate   [2:0];
                     
             
////中断处理
reg  [15:0]  S_pla_rmu_int; 

reg  [15:0]  S_pla_rmu_rate_chg_cnt [23:0];
wire [19:0]  S1_pla_rmu_rate [23:0] ;
reg  [19:0]  S2_pla_rmu_rate [23:0] ;
reg  [19:0]  S3_pla_rmu_rate [23:0] ;

//空口变化的中断处理
reg  [7:0]   S_pla_rmu_air_link_buf1 [2:0];
reg  [7:0]   S_pla_rmu_air_link_buf2 [2:0];
reg  [7:0]   S_pla_air_link_change_flg  [2:0];
reg  [7:0]   S_pla_air_link_change_mask [2:0];
reg  [2:0]   S_pla_link_cedge;

///PLA 空口link状态改变中断处理
always @ (posedge I_pla_main_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S_pla_air_link_change_mask[0]  <= 8'd0;
        S_pla_air_link_change_mask[1]  <= 8'd0;
        S_pla_air_link_change_mask[2]  <= 8'd0;
    end
    else
    begin
        S_pla_air_link_change_mask[0]  <= I_pla_air_link_change_mask[7:0];
        S_pla_air_link_change_mask[1]  <= I_pla_air_link_change_mask[15:8];
        S_pla_air_link_change_mask[2]  <= I_pla_air_link_change_mask[23:16];
    end
end


generate
genvar p;
for(p=0;p<3;p=p+1)
begin : PLA_LINK_INT 
always @ (posedge I_pla_main_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
        begin
            S_pla_rmu_air_link_buf1[p] <= 8'd0;
            S_pla_rmu_air_link_buf2[p] <= 8'd0;
        end
    else
        begin
            S_pla_rmu_air_link_buf1[p] <= I_pla_rmu_air_link[7+8*p:8*p];
            S_pla_rmu_air_link_buf2[p] <= S_pla_rmu_air_link_buf1[p];
        end
end

always @ (posedge I_pla_main_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
        begin
            S_pla_air_link_change_flg[p] <= 16'd0;
        end
    else if((S_pla_rmu_air_link_buf1[p] ^ S_pla_rmu_air_link_buf2[p] & S_pla_air_link_change_mask[p]) != 8'd0)
        begin
            S_pla_air_link_change_flg[p] <= (S_pla_rmu_air_link_buf1[p] ^ S_pla_rmu_air_link_buf2[p]) & S_pla_air_link_change_mask[p];
        end
    else if(!I_pla_int_clr[3+p])
        begin
            S_pla_air_link_change_flg[p] <= 16'd0;
        end
end

always @ (posedge I_pla_main_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
            S_pla_link_cedge[p] <= 1'b0;
        end
    else if(!I_pla_int_clr[3+p])
        begin
            S_pla_link_cedge[p] <= 1'b0;
        end        
    else if(8'd0 == S_pla_air_link_change_mask[p])
        begin
            S_pla_link_cedge[p] <= (|S_pla_rmu_air_link_buf1[p]) ^ (|S_pla_rmu_air_link_buf2[p]);
        end
    else
        begin
            S_pla_link_cedge[p] <= |((S_pla_rmu_air_link_buf1[p] ^ S_pla_rmu_air_link_buf2[p]) & S_pla_air_link_change_mask[p]);
        end
end

end
endgenerate

assign O_pla_air_link_change_flg[7:0]   = S_pla_air_link_change_flg[0];
assign O_pla_air_link_change_flg[15:8]  = S_pla_air_link_change_flg[1];
assign O_pla_air_link_change_flg[23:16] = S_pla_air_link_change_flg[2];


always @ (posedge I_pla_main_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S_pla_rmu0_rate[2] <= 20'd0;
        S_pla_rmu1_rate[2] <= 20'd0;
        S_pla_rmu2_rate[2] <= 20'd0;
        S_pla_rmu3_rate[2] <= 20'd0;
        S_pla_rmu4_rate[2] <= 20'd0;
        S_pla_rmu5_rate[2] <= 20'd0;
        S_pla_rmu6_rate[2] <= 20'd0;
        S_pla_rmu7_rate[2] <= 20'd0; 
    end
    else 
    begin               
        S_pla_rmu0_rate[2] <= S1_pla_rmu_rate[16]  ;                                    
        S_pla_rmu1_rate[2] <= S1_pla_rmu_rate[17]  ;                                    
        S_pla_rmu2_rate[2] <= S1_pla_rmu_rate[18]  ;                                    
        S_pla_rmu3_rate[2] <= S1_pla_rmu_rate[19]  ;                                    
        S_pla_rmu4_rate[2] <= S1_pla_rmu_rate[20]  ;                                    
        S_pla_rmu5_rate[2] <= S1_pla_rmu_rate[21]  ;                                    
        S_pla_rmu6_rate[2] <= S1_pla_rmu_rate[22]  ;                                    
        S_pla_rmu7_rate[2] <= S1_pla_rmu_rate[23]  ;                                    
    end                                                                            
end

always @ (posedge I_pla_main_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S_pla_rmu0_rate[1] <= 20'd0;
        S_pla_rmu1_rate[1] <= 20'd0;
        S_pla_rmu2_rate[1] <= 20'd0;
        S_pla_rmu3_rate[1] <= 20'd0;
        S_pla_rmu4_rate[1] <= 20'd0;
        S_pla_rmu5_rate[1] <= 20'd0;
        S_pla_rmu6_rate[1] <= 20'd0;
        S_pla_rmu7_rate[1] <= 20'd0; 
    end
    else 
    begin
        S_pla_rmu0_rate[1] <= S1_pla_rmu_rate[8 ]  ;                                    
        S_pla_rmu1_rate[1] <= S1_pla_rmu_rate[9 ]  ;                                    
        S_pla_rmu2_rate[1] <= S1_pla_rmu_rate[10]  ;                                    
        S_pla_rmu3_rate[1] <= S1_pla_rmu_rate[11]  ;                                    
        S_pla_rmu4_rate[1] <= S1_pla_rmu_rate[12]  ;                                    
        S_pla_rmu5_rate[1] <= S1_pla_rmu_rate[13]  ;                                    
        S_pla_rmu6_rate[1] <= S1_pla_rmu_rate[14]  ;                                    
        S_pla_rmu7_rate[1] <= S1_pla_rmu_rate[15]  ;                                    
    end                                                                            
end                                                                                
      
always @ (posedge I_pla_main_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S_pla_rmu0_rate[0] <= 20'd0;
        S_pla_rmu1_rate[0] <= 20'd0;
        S_pla_rmu2_rate[0] <= 20'd0;
        S_pla_rmu3_rate[0] <= 20'd0;
        S_pla_rmu4_rate[0] <= 20'd0;
        S_pla_rmu5_rate[0] <= 20'd0;
        S_pla_rmu6_rate[0] <= 20'd0;
        S_pla_rmu7_rate[0] <= 20'd0; 
    end
    else 
    begin
        S_pla_rmu0_rate[0] <= S1_pla_rmu_rate[0 ] ;                                    
        S_pla_rmu1_rate[0] <= S1_pla_rmu_rate[1 ] ;                                    
        S_pla_rmu2_rate[0] <= S1_pla_rmu_rate[2 ] ;                                    
        S_pla_rmu3_rate[0] <= S1_pla_rmu_rate[3 ] ;                                    
        S_pla_rmu4_rate[0] <= S1_pla_rmu_rate[4 ] ;                                    
        S_pla_rmu5_rate[0] <= S1_pla_rmu_rate[5 ] ;                                    
        S_pla_rmu6_rate[0] <= S1_pla_rmu_rate[6 ] ;                                    
        S_pla_rmu7_rate[0] <= S1_pla_rmu_rate[7 ] ;                                    
    end                                                                             
end           
                                
                                                                     
                                                                                    
always @ (posedge I_pla_main_clk or posedge I_pla_rst)                            
begin                                                                               
    if(I_pla_rst)                                                                
    begin                                                                           
        O_pla0_rmu_rate <= 20'd0;                                                   
        O_pla1_rmu_rate <= 20'd0;                                                   
        O_pla2_rmu_rate <= 20'd0;                                                   
    end                                                                             
    else                                                                            
    begin                                                                           
        O_pla0_rmu_rate <= S_pla_cu6_rate[0];                                       
        O_pla1_rmu_rate <= S_pla_cu6_rate[1];
        O_pla2_rmu_rate <= S_pla_cu6_rate[2];        
    end
end


generate
genvar i;
for(i=0;i<3;i=i+1)
begin : P0_PLA_RMU_RATE              
always @ (posedge I_pla_main_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S_pla_cu0_rate[i]  <= 20'd0;  
        S_pla_cu1_rate[i]  <= 20'd0; 
        S_pla_cu2_rate[i]  <= 20'd0; 
        S_pla_cu3_rate[i]  <= 20'd0;  
        S_pla_cu4_rate[i]  <= 20'd0;
        S_pla_cu5_rate[i]  <= 20'd0;
        S_pla_cu6_rate[i]  <= 20'd0;     
    end
    else if (I_hc_for_en[i])
    begin
        S_pla_cu0_rate[i]  <= 20'd0;  
        S_pla_cu1_rate[i]  <= 20'd0; 
        S_pla_cu2_rate[i]  <= 20'd0; 
        S_pla_cu3_rate[i]  <= 20'd0;  
        S_pla_cu4_rate[i]  <= 20'd0;
        S_pla_cu5_rate[i]  <= 20'd0;
        S_pla_cu6_rate[i]  <= 20'd0;        
    end
    else 
    begin   
        S_pla_cu0_rate[i]  <= {4'd0,S_pla_rmu0_rate[i]} + {4'd0,S_pla_rmu1_rate[i]};      
        S_pla_cu1_rate[i]  <= {4'd0,S_pla_rmu2_rate[i]} + {4'd0,S_pla_rmu3_rate[i]};  
        S_pla_cu2_rate[i]  <= {4'd0,S_pla_rmu4_rate[i]} + {4'd0,S_pla_rmu5_rate[i]};  
        S_pla_cu3_rate[i]  <= {4'd0,S_pla_rmu6_rate[i]} + {4'd0,S_pla_rmu7_rate[i]};       
        S_pla_cu4_rate[i]  <= S_pla_cu0_rate[i] + S_pla_cu1_rate[i]; 
        S_pla_cu5_rate[i]  <= S_pla_cu2_rate[i] + S_pla_cu3_rate[i]; 
        S_pla_cu6_rate[i]  <= S_pla_cu4_rate[i] + S_pla_cu5_rate[i]; 
    end
end


end
endgenerate


//////////////////////////////////////////////////////////////////////////////
/////中断处理  
//////////////////////////////////////////////////////////////////////////////


always @ (posedge I_pla_main_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        O_pla_rmu_int[0] <= 1'd0;
        O_pla0_cu_rate_chg_cnt <= 16'd0;
    end
    else if(I_cnt_clear) 
    begin
        O_pla0_cu_rate_chg_cnt <= 16'd0;
    end
    else if (!I_pla_int_clr[0])
    begin
        O_pla_rmu_int[0] <= 1'd0;
    end      
    else if (S_pla_cu6_rate[0] != O_pla0_rmu_rate)
    begin
        O_pla_rmu_int[0] <= 1'd1;
        O_pla0_cu_rate_chg_cnt <= O_pla0_cu_rate_chg_cnt + 16'd1;
    end
end


always @ (posedge I_pla_main_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        O_pla_rmu_int[1] <= 1'd0;
        O_pla1_cu_rate_chg_cnt <= 16'd0;
    end
    else if(I_cnt_clear) 
    begin
        O_pla1_cu_rate_chg_cnt <= 16'd0;
    end
    else if (!I_pla_int_clr[1])
    begin
        O_pla_rmu_int[1] <= 1'd0;
    end    
    else if (S_pla_cu6_rate[1] != O_pla1_rmu_rate)
    begin
        O_pla_rmu_int[1] <= 1'd1;
        O_pla1_cu_rate_chg_cnt <= O_pla1_cu_rate_chg_cnt + 16'd1;
    end
end

always @ (posedge I_pla_main_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        O_pla_rmu_int[2] <= 1'd0;
        O_pla2_cu_rate_chg_cnt <= 16'd0;
    end
    else if(I_cnt_clear) 
    begin
        O_pla2_cu_rate_chg_cnt <= 16'd0;
    end    
    else if (!I_pla_int_clr[2])
    begin
        O_pla_rmu_int[2] <= 1'd0;
    end
    else if (S_pla_cu6_rate[2] != O_pla2_rmu_rate)
    begin
        O_pla_rmu_int[2] <= 1'd1;
        O_pla2_cu_rate_chg_cnt <= O_pla2_cu_rate_chg_cnt + 16'd1;
    end
end


always @ (posedge I_pla_main_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        O_pla_rmu_int[3] <= 1'd0;
    end
    else if (!I_pla_int_clr[3])
    begin
        O_pla_rmu_int[3] <= 1'd0;
    end
    else if (S_pla_link_cedge[0])
    begin
        O_pla_rmu_int[3] <= 1'd1;
    end
end

always @ (posedge I_pla_main_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        O_pla_rmu_int[4] <= 1'd0;
    end
    else if (!I_pla_int_clr[4])
    begin
        O_pla_rmu_int[4] <= 1'd0;
    end
    else if (S_pla_link_cedge[1])
    begin
        O_pla_rmu_int[4] <= 1'd1;
    end
end

always @ (posedge I_pla_main_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        O_pla_rmu_int[5] <= 1'd0;
    end
    else if (!I_pla_int_clr[5])
    begin
        O_pla_rmu_int[5] <= 1'd0;
    end
    else if (S_pla_link_cedge[2])
    begin
        O_pla_rmu_int[5] <= 1'd1;
    end
end

always @ (posedge I_pla_main_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        O_pla_rmu_int[15:6] <= 10'd0;
        S_pla_rmu_int <= 16'd0;
    end
    else 
    begin
        O_pla_rmu_int[15:6] <= 10'd0;
        S_pla_rmu_int <= O_pla_rmu_int;
    end
end
                                 
generate
genvar m;
for(m=0;m<16;m=m+1)
begin : P1_PLA_RATE_LINK_INT_POS
always @ (posedge I_pla_main_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
        O_pla_int_event[m] <= 1'b0;
    else if(O_pla_rmu_int[m] && !S_pla_rmu_int[m])
        O_pla_int_event[m] <= 1'b1;
    else
        O_pla_int_event[m] <= O_pla_int_event[m] & I_pla_int_clr[m];
end
end
endgenerate

always @ (posedge I_pla_main_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
        O_pla_int_n <= 1'h1;
    else 
        O_pla_int_n <= !(|(I_pla_int_mask & O_pla_int_event));
end

//////////////////////////////////////////////////////////////////////////////
/////测试统计  
//////////////////////////////////////////////////////////////////////////////

assign  S1_pla_rmu_rate[0 ]  = {4'd0,I_pla00_rmu_rate};
assign  S1_pla_rmu_rate[1 ]  = {4'd0,I_pla01_rmu_rate};
assign  S1_pla_rmu_rate[2 ]  = {4'd0,I_pla02_rmu_rate};
assign  S1_pla_rmu_rate[3 ]  = {4'd0,I_pla03_rmu_rate};
assign  S1_pla_rmu_rate[4 ]  = {4'd0,I_pla04_rmu_rate};
assign  S1_pla_rmu_rate[5 ]  = {4'd0,I_pla05_rmu_rate};
assign  S1_pla_rmu_rate[6 ]  = {4'd0,I_pla06_rmu_rate};
assign  S1_pla_rmu_rate[7 ]  = {4'd0,I_pla07_rmu_rate};
assign  S1_pla_rmu_rate[8 ]  = {4'd0,I_pla10_rmu_rate};
assign  S1_pla_rmu_rate[9 ]  = {4'd0,I_pla11_rmu_rate};
assign  S1_pla_rmu_rate[10]  = {4'd0,I_pla12_rmu_rate};
assign  S1_pla_rmu_rate[11]  = {4'd0,I_pla13_rmu_rate};
assign  S1_pla_rmu_rate[12]  = {4'd0,I_pla14_rmu_rate};
assign  S1_pla_rmu_rate[13]  = {4'd0,I_pla15_rmu_rate};
assign  S1_pla_rmu_rate[14]  = {4'd0,I_pla16_rmu_rate};
assign  S1_pla_rmu_rate[15]  = {4'd0,I_pla17_rmu_rate};
assign  S1_pla_rmu_rate[16]  = {4'd0,I_pla20_rmu_rate};
assign  S1_pla_rmu_rate[17]  = {4'd0,I_pla21_rmu_rate};
assign  S1_pla_rmu_rate[18]  = {4'd0,I_pla22_rmu_rate};
assign  S1_pla_rmu_rate[19]  = {4'd0,I_pla23_rmu_rate};
assign  S1_pla_rmu_rate[20]  = {4'd0,I_pla24_rmu_rate};
assign  S1_pla_rmu_rate[21]  = {4'd0,I_pla25_rmu_rate};
assign  S1_pla_rmu_rate[22]  = {4'd0,I_pla26_rmu_rate};
assign  S1_pla_rmu_rate[23]  = {4'd0,I_pla27_rmu_rate};

generate
genvar k;
for(k=0;k<24;k=k+1)
begin : P2_PLA_RATE_CNT
always @ (posedge I_pla_main_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S2_pla_rmu_rate[k] <= 16'd0;
        S3_pla_rmu_rate[k] <= 16'd0;
    end    
    else
    begin
        S2_pla_rmu_rate[k] <= S1_pla_rmu_rate[k];
        S3_pla_rmu_rate[k] <= S2_pla_rmu_rate[k];
    end 
end

always @ (posedge I_pla_main_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S_pla_rmu_rate_chg_cnt[k]  <= 16'd0;  
    end
    else if(I_cnt_clear) 
    begin
        S_pla_rmu_rate_chg_cnt[k]  <= 16'd0;  
    end
    else if(S2_pla_rmu_rate[k] != S3_pla_rmu_rate[k])
    begin    
        S_pla_rmu_rate_chg_cnt[k]  <= S_pla_rmu_rate_chg_cnt[k] + 16'd1;  
    end
end

end
endgenerate

assign   O_pla00_rmu_rate_chg_cnt  =  S_pla_rmu_rate_chg_cnt[0 ]  ;
assign   O_pla01_rmu_rate_chg_cnt  =  S_pla_rmu_rate_chg_cnt[1 ]  ;
assign   O_pla02_rmu_rate_chg_cnt  =  S_pla_rmu_rate_chg_cnt[2 ]  ;
assign   O_pla03_rmu_rate_chg_cnt  =  S_pla_rmu_rate_chg_cnt[3 ]  ;
assign   O_pla04_rmu_rate_chg_cnt  =  S_pla_rmu_rate_chg_cnt[4 ]  ;
assign   O_pla05_rmu_rate_chg_cnt  =  S_pla_rmu_rate_chg_cnt[5 ]  ;
assign   O_pla06_rmu_rate_chg_cnt  =  S_pla_rmu_rate_chg_cnt[6 ]  ;
assign   O_pla07_rmu_rate_chg_cnt  =  S_pla_rmu_rate_chg_cnt[7 ]  ;
assign   O_pla10_rmu_rate_chg_cnt  =  S_pla_rmu_rate_chg_cnt[8 ]  ;
assign   O_pla11_rmu_rate_chg_cnt  =  S_pla_rmu_rate_chg_cnt[9 ]  ;
assign   O_pla12_rmu_rate_chg_cnt  =  S_pla_rmu_rate_chg_cnt[10]  ;
assign   O_pla13_rmu_rate_chg_cnt  =  S_pla_rmu_rate_chg_cnt[11]  ;
assign   O_pla14_rmu_rate_chg_cnt  =  S_pla_rmu_rate_chg_cnt[12]  ;
assign   O_pla15_rmu_rate_chg_cnt  =  S_pla_rmu_rate_chg_cnt[13]  ;
assign   O_pla16_rmu_rate_chg_cnt  =  S_pla_rmu_rate_chg_cnt[14]  ;
assign   O_pla17_rmu_rate_chg_cnt  =  S_pla_rmu_rate_chg_cnt[15]  ;
assign   O_pla20_rmu_rate_chg_cnt  =  S_pla_rmu_rate_chg_cnt[16]  ;
assign   O_pla21_rmu_rate_chg_cnt  =  S_pla_rmu_rate_chg_cnt[17]  ;
assign   O_pla22_rmu_rate_chg_cnt  =  S_pla_rmu_rate_chg_cnt[18]  ;
assign   O_pla23_rmu_rate_chg_cnt  =  S_pla_rmu_rate_chg_cnt[19]  ;
assign   O_pla24_rmu_rate_chg_cnt  =  S_pla_rmu_rate_chg_cnt[20]  ;
assign   O_pla25_rmu_rate_chg_cnt  =  S_pla_rmu_rate_chg_cnt[21]  ;
assign   O_pla26_rmu_rate_chg_cnt  =  S_pla_rmu_rate_chg_cnt[22]  ;
assign   O_pla27_rmu_rate_chg_cnt  =  S_pla_rmu_rate_chg_cnt[23]  ;




endmodule
