//FILE_HEADER-----------------------------------------------------------------
//ZTE  Copyright (C)
//ZTE Company Confidential
//----------------------------------------------------------------------------
//Project Name :  
//FILE NAME    : pla_loop_set.v
//AUTHOR       : 
//Department   : 
//Email        : 
//----------------------------------------------------------------------------
//Module Hiberarchy :
//x pla_loop_set--|--  模拟空口.REQUSET报文产生的功能.并且交换MAC地址DA/SA互换
//----------------------------------------------------------------------------
//Relaese History :
//----------------------------------------------------------------------------
//Version         Date           Author        Description
// 1.1          nov-10-2011      Li Shuai      pla_schedule
// 1.2
//----------------------------------------------------------------------------
//Main Function:
//----------------------------------------------------------------------------
//REUSE ISSUES: xxxxxxxx
//END_HEADER------------------------------------------------------------------

`timescale 1ns/100ps
module pla_loop_set(

input                I_pla_312m5_clk          ,
input                I_pla_rst                ,
input       [1:0]    I_pla_loop_en            ,////LOOP选择   BIT0:rmuc外部10G环回 BIT1:rmuc内部10G环回 
input       [23:0]   I_pla_loop_link          ,
///input       [15:0]   I_pla_loop_rate          ,
input       [47:0]   I_pla0_air_mac_0         ,
input       [47:0]   I_pla0_air_mac_1         ,
input       [47:0]   I_pla0_air_mac_2         ,
input       [47:0]   I_pla0_air_mac_3         ,
input       [47:0]   I_pla0_air_mac_4         ,
input       [47:0]   I_pla0_air_mac_5         ,
input       [47:0]   I_pla0_air_mac_6         ,
input       [47:0]   I_pla0_air_mac_7         ,
input       [47:0]   I_pla1_air_mac_0         ,
input       [47:0]   I_pla1_air_mac_1         ,
input       [47:0]   I_pla1_air_mac_2         ,
input       [47:0]   I_pla1_air_mac_3         ,
input       [47:0]   I_pla1_air_mac_4         ,
input       [47:0]   I_pla1_air_mac_5         ,
input       [47:0]   I_pla1_air_mac_6         ,
input       [47:0]   I_pla1_air_mac_7         ,
input       [47:0]   I_pla2_air_mac_0         ,
input       [47:0]   I_pla2_air_mac_1         ,
input       [47:0]   I_pla2_air_mac_2         ,
input       [47:0]   I_pla2_air_mac_3         ,
input       [47:0]   I_pla2_air_mac_4         ,
input       [47:0]   I_pla2_air_mac_5         ,
input       [47:0]   I_pla2_air_mac_6         ,
input       [47:0]   I_pla2_air_mac_7         ,
input       [47:0]   I_pla0_rcu_req_mac       ,
input       [47:0]   I_pla1_rcu_req_mac       ,
input       [47:0]   I_pla2_rcu_req_mac       ,


//PLA后环回
input        [15:0]  I_loop_request_ifg      ,//反向数据带REQUEST报文间隔
input        [31:0]  I_back1_air_txd         ,//反向数据 
input        [3:0]   I_back1_air_txc         ,//
input        [31:0]  I_for2_air_txd          ,//前向输出到空口数据 
input        [3:0]   I_for2_air_txc          ,//    
output  reg  [31:0]  O_loop_xgmii_pla_txd    ,//数据带REQUEST报文
output  reg  [3:0]   O_loop_xgmii_pla_txc    
);

reg       [31:0]    S1_pla_xgmii_txd          ;
reg       [3:0]     S1_pla_xgmii_txc          ;
reg       [31:0]    S2_pla_xgmii_txd          ;
reg       [3:0]     S2_pla_xgmii_txc          ;
reg       [31:0]    S3_pla_xgmii_txd          ;
reg       [3:0]     S3_pla_xgmii_txc          ;
reg       [31:0]    S4_pla_xgmii_txd          ;
reg       [3:0]     S4_pla_xgmii_txc          ;
reg       [31:0]    S5_pla_xgmii_txd          ;
reg       [3:0]     S5_pla_xgmii_txc          ;
reg       [31:0]    S6_pla_xgmii_txd           ;
reg       [3:0]     S6_pla_xgmii_txc           ;
reg       [31:0]    S7_pla_xgmii_txd           ;
reg       [3:0]     S7_pla_xgmii_txc           ;

reg       [31:0]    S_pla_request_txd             ;
reg       [3:0]     S_pla_request_txc             ;
reg       [6:0]     S_xgmii_in_cnt                ;
reg       [15:0]    S_pla_request_send_cnt        ;
reg                 S_pla_request_send            ;
reg       [4:0]     S_pla_request_frame_cnt       ;

reg       [47:0]    S_pla_air_mac                 ;
reg       [47:0]    S_pla_rcu_req_mac             ;

reg        [4:0]    S_send_cnt                    ;                     

wire      [31:0]    S_loop_xgmii_pla_txd          ;
wire      [3:0]     S_loop_xgmii_pla_txc          ;


wire               S_pla_new_set_d2 = 1'b1;
reg                S_air_link_d2 = 1'b1;
wire               S_pla_high_ind_d1 = 1'b0;
wire      [3:0]    S_acm_tx_mode_buf2 = 4'hf;
wire      [31:0]   S_rmu_request = 32'd1289;
wire      [15:0]   S_rmu_rate = 16'd625;
reg       [15:0]   S1_rmu_rate = 16'd625;

/////前向信号处理

always@(posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        O_loop_xgmii_pla_txd <= 32'h07070707;
        O_loop_xgmii_pla_txc <= 4'hf ;
    end
    else if (|I_pla_loop_en) 
    begin  
        O_loop_xgmii_pla_txd <= S_loop_xgmii_pla_txd; 
        O_loop_xgmii_pla_txc <= S_loop_xgmii_pla_txc;
    end
    else 
    begin
        O_loop_xgmii_pla_txd <= I_back1_air_txd      ;
        O_loop_xgmii_pla_txc <= I_back1_air_txc      ;
    end
end

/////反向数据处理
///REQUEST请求为ms级别的

always@(posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S_pla_request_send_cnt <= 16'h1000;
        S_pla_request_send <= 1'b0;
    end
    else if(S_pla_request_send_cnt == I_loop_request_ifg)
    begin
        S_pla_request_send_cnt <= 16'd0;
        S_pla_request_send <= 1'b1;
    end
    else
    begin
        S_pla_request_send_cnt <= S_pla_request_send_cnt + 16'd1;
        S_pla_request_send <= 1'b0;
    end
end


always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
    begin
        S_pla_request_frame_cnt <= 5'd20;
        S_send_cnt <= 5'd0;
    end
    else if(S_pla_request_send)
    begin
        S_pla_request_frame_cnt <= 5'd0;
        S_send_cnt <= 5'd23;
    end
    else if(S_pla_request_frame_cnt == 5'd20)
    begin
        if (S_send_cnt == 5'd0) 
        begin
            S_pla_request_frame_cnt <= S_pla_request_frame_cnt;
            S_send_cnt <= 5'd0;
        end    
        else
        begin 
            S_pla_request_frame_cnt <= 5'd0;
            S_send_cnt <= S_send_cnt - 5'd1;
        end   
    end
    else
    begin
        S_pla_request_frame_cnt <= S_pla_request_frame_cnt + 5'd1;
    end
end

always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
    begin
        S_pla_air_mac <= 48'd0;
        S_air_link_d2 <= 1'b0;
        S_pla_rcu_req_mac <= 48'd0;
    end
    else  
    begin
        case(S_send_cnt)  
            5'd0     :begin S_pla_air_mac <= I_pla0_air_mac_0 ;  S_air_link_d2 <=  I_pla_loop_link[0];    S_pla_rcu_req_mac <= I_pla0_rcu_req_mac ; end
            5'd1     :begin S_pla_air_mac <= I_pla0_air_mac_1 ;  S_air_link_d2 <=  I_pla_loop_link[1];    S_pla_rcu_req_mac <= I_pla0_rcu_req_mac ; end
            5'd2     :begin S_pla_air_mac <= I_pla0_air_mac_2 ;  S_air_link_d2 <=  I_pla_loop_link[2];    S_pla_rcu_req_mac <= I_pla0_rcu_req_mac ; end
            5'd3     :begin S_pla_air_mac <= I_pla0_air_mac_3 ;  S_air_link_d2 <=  I_pla_loop_link[3];    S_pla_rcu_req_mac <= I_pla0_rcu_req_mac ; end
            5'd4     :begin S_pla_air_mac <= I_pla0_air_mac_4 ;  S_air_link_d2 <=  I_pla_loop_link[4];    S_pla_rcu_req_mac <= I_pla0_rcu_req_mac ; end
            5'd5     :begin S_pla_air_mac <= I_pla0_air_mac_5 ;  S_air_link_d2 <=  I_pla_loop_link[5];    S_pla_rcu_req_mac <= I_pla0_rcu_req_mac ; end
            5'd6     :begin S_pla_air_mac <= I_pla0_air_mac_6 ;  S_air_link_d2 <=  I_pla_loop_link[6];    S_pla_rcu_req_mac <= I_pla0_rcu_req_mac ; end
            5'd7     :begin S_pla_air_mac <= I_pla0_air_mac_7 ;  S_air_link_d2 <=  I_pla_loop_link[7];    S_pla_rcu_req_mac <= I_pla0_rcu_req_mac ; end
            5'd8     :begin S_pla_air_mac <= I_pla1_air_mac_0 ;  S_air_link_d2 <=  I_pla_loop_link[8];    S_pla_rcu_req_mac <= I_pla1_rcu_req_mac ; end
            5'd9     :begin S_pla_air_mac <= I_pla1_air_mac_1 ;  S_air_link_d2 <=  I_pla_loop_link[9];    S_pla_rcu_req_mac <= I_pla1_rcu_req_mac ; end
            5'd10    :begin S_pla_air_mac <= I_pla1_air_mac_2 ;  S_air_link_d2 <=  I_pla_loop_link[10];   S_pla_rcu_req_mac <= I_pla1_rcu_req_mac ; end
            5'd11    :begin S_pla_air_mac <= I_pla1_air_mac_3 ;  S_air_link_d2 <=  I_pla_loop_link[11];   S_pla_rcu_req_mac <= I_pla1_rcu_req_mac ; end
            5'd12    :begin S_pla_air_mac <= I_pla1_air_mac_4 ;  S_air_link_d2 <=  I_pla_loop_link[12];   S_pla_rcu_req_mac <= I_pla1_rcu_req_mac ; end
            5'd13    :begin S_pla_air_mac <= I_pla1_air_mac_5 ;  S_air_link_d2 <=  I_pla_loop_link[13];   S_pla_rcu_req_mac <= I_pla1_rcu_req_mac ; end
            5'd14    :begin S_pla_air_mac <= I_pla1_air_mac_6 ;  S_air_link_d2 <=  I_pla_loop_link[14];   S_pla_rcu_req_mac <= I_pla1_rcu_req_mac ; end
            5'd15    :begin S_pla_air_mac <= I_pla1_air_mac_7 ;  S_air_link_d2 <=  I_pla_loop_link[15];   S_pla_rcu_req_mac <= I_pla1_rcu_req_mac ; end
            5'd16    :begin S_pla_air_mac <= I_pla2_air_mac_0 ;  S_air_link_d2 <=  I_pla_loop_link[16];   S_pla_rcu_req_mac <= I_pla2_rcu_req_mac ; end
            5'd17    :begin S_pla_air_mac <= I_pla2_air_mac_1 ;  S_air_link_d2 <=  I_pla_loop_link[17];   S_pla_rcu_req_mac <= I_pla2_rcu_req_mac ; end
            5'd18    :begin S_pla_air_mac <= I_pla2_air_mac_2 ;  S_air_link_d2 <=  I_pla_loop_link[18];   S_pla_rcu_req_mac <= I_pla2_rcu_req_mac ; end
            5'd19    :begin S_pla_air_mac <= I_pla2_air_mac_3 ;  S_air_link_d2 <=  I_pla_loop_link[19];   S_pla_rcu_req_mac <= I_pla2_rcu_req_mac ; end
            5'd20    :begin S_pla_air_mac <= I_pla2_air_mac_4 ;  S_air_link_d2 <=  I_pla_loop_link[20];   S_pla_rcu_req_mac <= I_pla2_rcu_req_mac ; end
            5'd21    :begin S_pla_air_mac <= I_pla2_air_mac_5 ;  S_air_link_d2 <=  I_pla_loop_link[21];   S_pla_rcu_req_mac <= I_pla2_rcu_req_mac ; end
            5'd22    :begin S_pla_air_mac <= I_pla2_air_mac_6 ;  S_air_link_d2 <=  I_pla_loop_link[22];   S_pla_rcu_req_mac <= I_pla2_rcu_req_mac ; end
            5'd23    :begin S_pla_air_mac <= I_pla2_air_mac_7 ;  S_air_link_d2 <=  I_pla_loop_link[23];   S_pla_rcu_req_mac <= I_pla2_rcu_req_mac ; end
            default  :begin S_pla_air_mac <= I_pla0_air_mac_0 ;  S_air_link_d2 <=  I_pla_loop_link[0] ;   S_pla_rcu_req_mac <= I_pla0_rcu_req_mac ; end
        endcase    
    end    
end




always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
    begin
        S_pla_request_txd <= 32'd0;
        S_pla_request_txc <= 4'hf;
        S1_rmu_rate <= 16'hc000;
    end
    else
    begin
        case(S_pla_request_frame_cnt)
            5'd0  :
            begin
                S_pla_request_txd <= 32'hfb555555;
                S_pla_request_txc <= 4'h8;
            end
            5'd1  :
            begin
                S_pla_request_txd <= 32'h555555d5;
                S_pla_request_txc <= 4'h0;
            end
            5'd2  :
            begin
                S_pla_request_txd <= S_pla_rcu_req_mac[47:16];
                S_pla_request_txc <= 4'h0;
            end
            5'd3  :
            begin
                S_pla_request_txd <= {S_pla_rcu_req_mac[15:0],S_pla_air_mac[47:32]};
                S_pla_request_txc <= 4'h0;
            end
            5'd4  :
            begin
                S_pla_request_txd <= S_pla_air_mac[31:0];
                S_pla_request_txc <= 4'h0;
            end
            5'd5  :///requset标志和空口LINK
            begin
                S_pla_request_txd <= {16'h80fc,S_pla_new_set_d2,~S_air_link_d2,14'd0}; //,
                S_pla_request_txc <= 4'h0;
            end
            5'd6:  ///ACM &&&
            begin
                S_pla_request_txd <= {8'b0,S_pla_high_ind_d1,3'b0,S_acm_tx_mode_buf2,16'd0} ;                                                     
                S_pla_request_txc <= 4'h0;       
            end
            5'd7:
            begin
                S_pla_request_txd <= 32'h0000;
                S_pla_request_txc <= 4'h0;
                S1_rmu_rate <= S1_rmu_rate + 16'd1;
            end
            5'd8:
            begin
                S_pla_request_txd <= S_rmu_request ;///32'd1288;
                S_pla_request_txc <= 4'h0;  
            end
            5'd9:
            begin
                S_pla_request_txd <= {S_rmu_rate,16'd0} ;///32'd1288;
                S_pla_request_txc <= 4'h0;
            end            
            
            5'd10,5'd11,5'd12,5'd13,5'd14,5'd15,5'd16,5'd17 :
            begin
                S_pla_request_txd <= 32'd0;
                S_pla_request_txc <= 4'h0;            
            end      
            5'd18 :                                    
            begin                                                  
                S_pla_request_txd <= 32'hfd070707;                 
                S_pla_request_txc <= 4'hf;                         
            end                                                    
            default:                                            
            begin                                               
                S_pla_request_txd <= 32'h07070707;
                S_pla_request_txc <= 4'hf;
            end
        endcase
    end
end


always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
    begin
        S1_pla_xgmii_txd <= 32'd0;
        S1_pla_xgmii_txc <= 4'hf ;
        S2_pla_xgmii_txd <= 32'd0;
        S2_pla_xgmii_txc <= 4'hf ;
        S3_pla_xgmii_txd <= 32'd0;
        S3_pla_xgmii_txc <= 4'hf ;
        S4_pla_xgmii_txd <= 32'd0;
        S4_pla_xgmii_txc <= 4'hf ;
        S5_pla_xgmii_txd <= 32'd0;
        S5_pla_xgmii_txc <= 4'hf ;
    end
    else
    begin
       /// if (I_pla_loop_en[0])   //LOOP选择   BIT0:rmuc外部10G环回 BIT1:rmuc内部10G环回 
       /// begin
       ///      S1_pla_xgmii_txd <= I_back1_air_txd       ;
       ///      S1_pla_xgmii_txc <= I_back1_air_txc       ;
       /// end     
       /// else 
       /// begin     
       ///      S1_pla_xgmii_txd <= I_for2_air_txd ; 
       ///      S1_pla_xgmii_txc <= I_for2_air_txc ; 
       /// end
       
       S1_pla_xgmii_txd <= I_for2_air_txd ; 
       S1_pla_xgmii_txc <= I_for2_air_txc ; 
        
        S2_pla_xgmii_txd <= S1_pla_xgmii_txd;
        S2_pla_xgmii_txc <= S1_pla_xgmii_txc;
        S3_pla_xgmii_txd <= S2_pla_xgmii_txd;
        S3_pla_xgmii_txc <= S2_pla_xgmii_txc;
        S4_pla_xgmii_txd <= S3_pla_xgmii_txd;
        S4_pla_xgmii_txc <= S3_pla_xgmii_txc;
        S5_pla_xgmii_txd <= S4_pla_xgmii_txd;
        S5_pla_xgmii_txc <= S4_pla_xgmii_txc;
    end
end

always @ (posedge I_pla_312m5_clk)
begin
    if((&S3_pla_xgmii_txc == 1'b0))
    begin
        S_xgmii_in_cnt <= S_xgmii_in_cnt + 7'd1;
    end
    else
    begin
        S_xgmii_in_cnt <= 7'd0;
    end
end

always @ (posedge I_pla_312m5_clk)
begin
    if((&S3_pla_xgmii_txc) && !(&S4_pla_xgmii_txc))
    begin
        S6_pla_xgmii_txd <= 32'd0;  
        S6_pla_xgmii_txc <= 4'hf;
    end
    else if((&S4_pla_xgmii_txc) && !(&S5_pla_xgmii_txc))
    begin
        S6_pla_xgmii_txd <= 32'd0;  
        S6_pla_xgmii_txc <= 4'hf;
    end
    else
    begin
        case(S_xgmii_in_cnt)
            7'd2:
            begin
                S6_pla_xgmii_txd <= {S2_pla_xgmii_txd[15:0],S1_pla_xgmii_txd[31:16]};
                S6_pla_xgmii_txc <= S3_pla_xgmii_txc;
            end
            7'd3:
            begin
                S6_pla_xgmii_txd <= {S2_pla_xgmii_txd[15:0],S4_pla_xgmii_txd[31:16]};
                S6_pla_xgmii_txc <= S3_pla_xgmii_txc;
            end
            7'd4:
            begin
                S6_pla_xgmii_txd <= {S5_pla_xgmii_txd[15:0],S4_pla_xgmii_txd[31:16]};
                S6_pla_xgmii_txc <= S3_pla_xgmii_txc;
            end
            default :
            begin
                S6_pla_xgmii_txd <= S3_pla_xgmii_txd;
                S6_pla_xgmii_txc <= S3_pla_xgmii_txc;
            end
        endcase
    end
end

always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
    begin
        S7_pla_xgmii_txd <= 32'd0;
        S7_pla_xgmii_txc <= 4'hf ;
    end
    else
    begin
       if (I_pla_loop_en[0])   //LOOP选择   BIT0:rmuc外部10G环回（已经交换MAC）  BIT1:rmuc内部10G环回（需要内部交换mac）
       begin
           S7_pla_xgmii_txd <= I_back1_air_txd       ;
           S7_pla_xgmii_txc <= I_back1_air_txc       ;
       end     
       else 
       begin     
           S7_pla_xgmii_txd <= S6_pla_xgmii_txd;   ///前向输出并且交换MAC  
           S7_pla_xgmii_txc <= S6_pla_xgmii_txc; 
       end
    end   
end





///pla后,SW侧环回
///更换mac 并且合并
f1_xgmii_mux U01_tb_xgmii_mux(
.I_pla_312m5_clk    (I_pla_312m5_clk       ),
.I_pla_rst          (I_pla_rst             ),
.I_xgmii_in_d0      (S_pla_request_txd     ),
.I_xgmii_in_c0      (S_pla_request_txc     ),
.I_xgmii_in_d1      (S7_pla_xgmii_txd       ),
.I_xgmii_in_c1      (S7_pla_xgmii_txc       ),
.O_xgmii_out_d      (S_loop_xgmii_pla_txd  ),
.O_xgmii_out_c      (S_loop_xgmii_pla_txc  )
);


endmodule
