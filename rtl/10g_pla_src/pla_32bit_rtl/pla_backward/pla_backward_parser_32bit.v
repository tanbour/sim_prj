//FILE_HEADER-----------------------------------------------------------------
//ZTE  Copyright (C)
//ZTE Company Confidential
//----------------------------------------------------------------------------
//Project Name : RCUC PLA
//FILE NAME    : pla_backward_slice_cycle_ddr.v
//AUTHOR       : 
//Department   : 
//Email        : 
//----------------------------------------------------------------------------
//Module Hiberarchy :
//x                            |--U0_pla_backward_id_calc   
//x                            |--U1_pla_backward_id_calc     
//x pla_backward_parser_32bit--|--U2_pla_backward_id_calc   
//----------------------------------------------------------------------------
//----------------------------------------------------------------------------
//Version         Date           Author        Description
// 1.1          nov-4-2015      Li Shuai        pla_schedule
// 1.2
//----------------------------------------------------------------------------


module pla_backward_parser_32bit(
input               I_pla_312m5_clk          ,
input               I_pla_rst                ,
input     [47:0]    I_pla0_air_mac_0         ,
input     [47:0]    I_pla0_air_mac_1         ,
input     [47:0]    I_pla0_air_mac_2         ,
input     [47:0]    I_pla0_air_mac_3         ,
input     [47:0]    I_pla0_air_mac_4         ,
input     [47:0]    I_pla0_air_mac_5         ,
input     [47:0]    I_pla0_air_mac_6         ,
input     [47:0]    I_pla0_air_mac_7         ,
input     [47:0]    I_pla1_air_mac_0         ,
input     [47:0]    I_pla1_air_mac_1         ,
input     [47:0]    I_pla1_air_mac_2         ,
input     [47:0]    I_pla1_air_mac_3         ,
input     [47:0]    I_pla1_air_mac_4         ,
input     [47:0]    I_pla1_air_mac_5         ,
input     [47:0]    I_pla1_air_mac_6         ,
input     [47:0]    I_pla1_air_mac_7         ,
input     [47:0]    I_pla2_air_mac_0         ,
input     [47:0]    I_pla2_air_mac_1         ,
input     [47:0]    I_pla2_air_mac_2         ,
input     [47:0]    I_pla2_air_mac_3         ,
input     [47:0]    I_pla2_air_mac_4         ,
input     [47:0]    I_pla2_air_mac_5         ,
input     [47:0]    I_pla2_air_mac_6         ,
input     [47:0]    I_pla2_air_mac_7         ,

input     [47:0]    I_pla0_rcu_mac           ,  
input     [47:0]    I_pla1_rcu_mac           ,  
input     [47:0]    I_pla2_rcu_mac           ,  

input     [31:0]    I_xgmii_rxd              ,
input     [3:0]     I_xgmii_rxc              ,
input               I_pla0_slice_wr_resp     ,
input               I_pla1_slice_wr_resp     ,
input               I_pla2_slice_wr_resp     ,

input     [14:0]    I_pla0_slice_num_id      ,
input     [14:0]    I_pla1_slice_num_id      ,
input     [14:0]    I_pla2_slice_num_id      ,

output    [1:0]     O_xgmii_pla_num          ,///当前报文所属组 
output    [14:0]    O_pla_slice_id           ,
output    [31:0]    O_pla_slice_payload      ,
output              O_pla_slice_payload_en   ,

output              O_pla0_slice_check_ok    ,///pulse
output              O_pla1_slice_check_ok    ,///pulse
output              O_pla2_slice_check_ok    ,///pulse

output    [14:0]    O_pla0_slice_id_new      ,
output              O_pla0_slice_id_new_valid,
output    [14:0]    O_pla1_slice_id_new      ,
output              O_pla1_slice_id_new_valid,
output    [14:0]    O_pla2_slice_id_new      ,
output              O_pla2_slice_id_new_valid,
output    [14:0]    O_pla0_slice_id_max      ,
output    [14:0]    O_pla0_slice_id_min      ,
output    [14:0]    O_pla1_slice_id_max      ,
output    [14:0]    O_pla1_slice_id_min      ,
output    [14:0]    O_pla2_slice_id_max      ,
output    [14:0]    O_pla2_slice_id_min      ,

input                I_cnt_clear			 ,
output reg   [15:0]  O_pla_slice_mac_err_cnt ,
output reg   [15:0]  O_pla_slice_len_err_cnt ,

output		 [ 7:0]	 O_pla0_slice_id_random_order	,
output		 [ 7:0]	 O_pla1_slice_id_random_order	,
output		 [ 7:0]	 O_pla2_slice_id_random_order	,
output		 [15:0]	 O_pla0_slice_id_bottom_err_cnt	,
output		 [15:0]	 O_pla1_slice_id_bottom_err_cnt	,
output		 [15:0]	 O_pla2_slice_id_bottom_err_cnt	,


input     [14:0]    I_pla_slice_window       ,
input     [7:0]     I_pla0_air_link          ,
input     [7:0]     I_pla1_air_link          ,
input     [7:0]     I_pla2_air_link              
);

parameter          C_XGMII_S          = 8'hFB   ,
                   C_XGMII_T          = 8'hFD   ;
parameter          C_PARSER_IDLE      = 2'd0    ,
                   C_PARSER_PRE       = 2'd1    ,
                   C_PARSER_MAC       = 2'd2    ,
                   C_PARSER_DATA      = 2'd3    ;
reg      [1:0]     S_parser_state                    ;
reg      [1:0]     S_parser_state_next               ;
reg      [31:0]    S_xgmii_rxd_buf1           = 32'd0;
reg      [31:0]    S_xgmii_rxd_buf2           = 32'd0;
reg      [31:0]    S_xgmii_rxd_buf3           = 32'd0;
reg      [31:0]    S_xgmii_rxd_buf4           = 32'd0;
reg      [3:0]     S_xgmii_rxc_buf1           = 4'hf ;
reg      [3:0]     S_xgmii_rxc_buf2           = 4'hf ;
reg      [3:0]     S_xgmii_rxc_buf3           = 4'hf ;
reg      [3:0]     S_xgmii_rxc_buf4           = 4'hf ;
reg                S_xgmii_start_flg          = 1'b0 ;
reg                S_xgmii_sfd_flg            = 1'b0 ;
reg                S_xgmii_end_flg            = 1'b0 ;
reg      [3:0]     S_xgmii_end_info           = 4'b0 ;
reg      [6:0]     S_xgmii_length_cnt         = 7'd0 ;
wire     [47:0]    S_pla_air_mac[0:23]               ;
wire     [47:0]    S_pla_rcu_mac[0:23]               ;
reg      [23:0]    S_pla_slice_da_h_ok        = 24'b0;
reg      [23:0]    S_pla_slice_da_l_ok        = 24'b0;
reg      [23:0]    S_pla_slice_sa_h_ok        = 24'b0;
reg      [23:0]    S_pla_slice_sa_l_ok        = 24'b0;
reg      [23:0]    S_pla_air_index            = 24'b0;
reg      [23:0]    S_pla_air_index_lck        = 24'b0;
reg                S_pla_slice_mac_ok         = 1'b0 ;
reg      [1:0]     S_xgmii_pla_num            = 2'b0 ;
reg      [1:0]     R_xgmii_pla_num_pre        = 2'b0 ;
reg      [14:0]    S_pla_slice_id             = 15'd0;
reg      [1:0]     S_xgmii_pla_num_lck        = 2'b0 ;
reg      [14:0]    S_pla_slice_id_lck         = 15'd0;
reg                S_pla_slice_flg            = 1'd0 ;

reg                S_pla_slice_check_ok       = 1'b0 ;
reg                S_pla0_slice_check_ok      = 1'b0 ;
reg                S_pla1_slice_check_ok      = 1'b0 ;
reg                S_pla2_slice_check_ok      = 1'b0 ;
reg                S_pla_request_check_ok     = 1'b0 ;
reg                S_pla_request_check_ok_buf = 1'b0 ;


reg      [31:0]    S_pla_slice_payload        = 32'd0;
reg                S_pla_slice_payload_en     = 1'd0 ; 
reg                S_pla0_slice_calc_pre      = 1'd0 ;
reg                S_pla1_slice_calc_pre      = 1'd0 ;
reg                S_pla2_slice_calc_pre      = 1'd0 ;
reg                S_pla0_slice_wr_resp_buf1  = 1'b0 ;
reg                S_pla1_slice_wr_resp_buf1  = 1'b0 ;
reg                S_pla2_slice_wr_resp_buf1  = 1'b0 ;
reg                S_pla0_slice_wr_resp_buf2  = 1'b0 ;
reg                S_pla1_slice_wr_resp_buf2  = 1'b0 ;
reg                S_pla2_slice_wr_resp_buf2  = 1'b0 ;
reg      [14:0]    S_pla0_slice_id_new        = 15'd0;
reg                S_pla0_slice_id_new_valid  = 1'd0 ;
reg      [14:0]    S_pla1_slice_id_new        = 15'd0;
reg                S_pla1_slice_id_new_valid  = 1'd0 ;
reg      [14:0]    S_pla2_slice_id_new        = 15'd0;
reg                S_pla2_slice_id_new_valid  = 1'd0 ;
wire     [14:0]    S_pla0_slice_id_max               ;
wire     [14:0]    S_pla0_slice_id_min               ;
wire     [14:0]    S_pla1_slice_id_max               ;
wire     [14:0]    S_pla1_slice_id_min               ;
wire     [14:0]    S_pla2_slice_id_max               ;
wire     [14:0]    S_pla2_slice_id_min               ;
reg      [14:0]    S_pla0_slice_id_max_out           ;
reg      [14:0]    S_pla0_slice_id_min_out           ;
reg      [14:0]    S_pla1_slice_id_max_out           ;
reg      [14:0]    S_pla1_slice_id_min_out           ;
reg      [14:0]    S_pla2_slice_id_max_out           ;
reg      [14:0]    S_pla2_slice_id_min_out           ;


genvar             i,j                           ;

always @ (posedge I_pla_312m5_clk)
begin
end

always @ (posedge I_pla_312m5_clk)
begin
    S_xgmii_rxd_buf1 <= I_xgmii_rxd     ;
    S_xgmii_rxd_buf2 <= S_xgmii_rxd_buf1;
    S_xgmii_rxd_buf3 <= S_xgmii_rxd_buf2;
    S_xgmii_rxd_buf4 <= S_xgmii_rxd_buf3;
    S_xgmii_rxc_buf1 <= I_xgmii_rxc     ;
    S_xgmii_rxc_buf2 <= S_xgmii_rxc_buf1;
    S_xgmii_rxc_buf3 <= S_xgmii_rxc_buf2;
    S_xgmii_rxc_buf4 <= S_xgmii_rxc_buf3;
end

always @ (posedge I_pla_312m5_clk)
begin
    if((S_xgmii_rxc_buf1 == 4'b1000) && (S_xgmii_rxd_buf1 == {C_XGMII_S,24'h555555}))
        begin
            S_xgmii_start_flg <= 1'b1;
        end
    else
        begin
            S_xgmii_start_flg <= 1'b0;
        end
end

always @ (posedge I_pla_312m5_clk)
begin
    if((S_xgmii_rxc_buf1 == 4'b0000) && (S_xgmii_rxd_buf1 == 32'h555555d5))
        begin
            S_xgmii_sfd_flg <= 1'b1;
        end
    else
        begin
            S_xgmii_sfd_flg <= 1'b0;
        end
end

always @ (posedge I_pla_312m5_clk)
begin
    if(|S_xgmii_rxc_buf1)
        begin
            S_xgmii_end_flg <= 1'b1;
        end
    else
        begin
            S_xgmii_end_flg <= 1'b0;
        end
end

always @ (posedge I_pla_312m5_clk)
begin
    if((S_xgmii_rxc_buf1 == 4'b0001) && (S_xgmii_rxd_buf1[7:0] == C_XGMII_T))
        begin
            S_xgmii_end_info[0] <= 1'b1;
        end
    else
        begin
            S_xgmii_end_info[0] <= 1'b0;
        end
end

always @ (posedge I_pla_312m5_clk)
begin
    if((S_xgmii_rxc_buf1 == 4'b0011) && (S_xgmii_rxd_buf1[15:8] == C_XGMII_T))
        begin
            S_xgmii_end_info[1] <= 1'b1;
        end
    else
        begin
            S_xgmii_end_info[1] <= 1'b0;
        end
end

always @ (posedge I_pla_312m5_clk)
begin
    if((S_xgmii_rxc_buf1 == 4'b0111) && (S_xgmii_rxd_buf1[23:16] == C_XGMII_T))
        begin
            S_xgmii_end_info[2] <= 1'b1;
        end
    else
        begin
            S_xgmii_end_info[2] <= 1'b0;
        end
end

always @ (posedge I_pla_312m5_clk)
begin
    if((S_xgmii_rxc_buf1 == 4'b1111) && (S_xgmii_rxd_buf1[31:24] == C_XGMII_T))
        begin
            S_xgmii_end_info[3] <= 1'b1;
        end
    else
        begin
            S_xgmii_end_info[3] <= 1'b0;
        end
end

always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_parser_state <= C_PARSER_IDLE;
        end
    else
        begin
            S_parser_state <= S_parser_state_next;
        end
end

always @ (*)
begin
    case(S_parser_state)
        C_PARSER_IDLE :
        begin
            if(S_xgmii_start_flg)
                begin
                    S_parser_state_next = C_PARSER_PRE;
                end
            else
                begin
                    S_parser_state_next = C_PARSER_IDLE;
                end
        end
        C_PARSER_PRE  :
        begin
            if(S_xgmii_sfd_flg)
                begin
                    S_parser_state_next = C_PARSER_MAC;
                end
            else
                begin
                    S_parser_state_next = C_PARSER_IDLE;
                end
        end
        C_PARSER_MAC  :
        begin
            if(S_xgmii_end_flg)
                begin
                    S_parser_state_next = C_PARSER_IDLE;
                end
            else if(S_xgmii_length_cnt[1])
                begin
                    S_parser_state_next = C_PARSER_DATA;
                end
            else
                begin
                    S_parser_state_next = C_PARSER_MAC;
                end
        end
        C_PARSER_DATA :
        begin
            if(S_xgmii_end_flg)
                begin
                    S_parser_state_next = C_PARSER_IDLE;
                end
            else
                begin
                    S_parser_state_next = C_PARSER_DATA;
                end
        end
        default:
        begin
            S_parser_state_next = C_PARSER_IDLE;
        end
    endcase
end

always @ (posedge I_pla_312m5_clk)
begin
    case(S_parser_state)
        C_PARSER_MAC  :
        begin
            if(S_xgmii_length_cnt[1])
                begin
                    S_xgmii_length_cnt <= 7'd0;
                end
            else
                begin
                    S_xgmii_length_cnt <= S_xgmii_length_cnt + 7'd1;
                end
        end
        C_PARSER_DATA :
        begin
            if(&S_xgmii_length_cnt)
                begin
                    S_xgmii_length_cnt <= S_xgmii_length_cnt;
                end
            else
                begin
                    S_xgmii_length_cnt <= S_xgmii_length_cnt + 7'd1;
                end
        end
        default :
        begin
            S_xgmii_length_cnt <= 7'd0;
        end
    endcase
end



assign S_pla_air_mac[0 ] = I_pla0_air_mac_0;
assign S_pla_air_mac[1 ] = I_pla0_air_mac_1;
assign S_pla_air_mac[2 ] = I_pla0_air_mac_2;
assign S_pla_air_mac[3 ] = I_pla0_air_mac_3;
assign S_pla_air_mac[4 ] = I_pla0_air_mac_4;
assign S_pla_air_mac[5 ] = I_pla0_air_mac_5;
assign S_pla_air_mac[6 ] = I_pla0_air_mac_6;
assign S_pla_air_mac[7 ] = I_pla0_air_mac_7;
assign S_pla_air_mac[8 ] = I_pla1_air_mac_0;
assign S_pla_air_mac[9 ] = I_pla1_air_mac_1;
assign S_pla_air_mac[10] = I_pla1_air_mac_2;
assign S_pla_air_mac[11] = I_pla1_air_mac_3;
assign S_pla_air_mac[12] = I_pla1_air_mac_4;
assign S_pla_air_mac[13] = I_pla1_air_mac_5;
assign S_pla_air_mac[14] = I_pla1_air_mac_6;
assign S_pla_air_mac[15] = I_pla1_air_mac_7;
assign S_pla_air_mac[16] = I_pla2_air_mac_0;
assign S_pla_air_mac[17] = I_pla2_air_mac_1;
assign S_pla_air_mac[18] = I_pla2_air_mac_2;
assign S_pla_air_mac[19] = I_pla2_air_mac_3;
assign S_pla_air_mac[20] = I_pla2_air_mac_4;
assign S_pla_air_mac[21] = I_pla2_air_mac_5;
assign S_pla_air_mac[22] = I_pla2_air_mac_6;
assign S_pla_air_mac[23] = I_pla2_air_mac_7;

assign S_pla_rcu_mac[0 ] = I_pla0_rcu_mac ;
assign S_pla_rcu_mac[1 ] = I_pla0_rcu_mac ;
assign S_pla_rcu_mac[2 ] = I_pla0_rcu_mac ;
assign S_pla_rcu_mac[3 ] = I_pla0_rcu_mac ;
assign S_pla_rcu_mac[4 ] = I_pla0_rcu_mac ;
assign S_pla_rcu_mac[5 ] = I_pla0_rcu_mac ;
assign S_pla_rcu_mac[6 ] = I_pla0_rcu_mac ;
assign S_pla_rcu_mac[7 ] = I_pla0_rcu_mac ;
assign S_pla_rcu_mac[8 ] = I_pla1_rcu_mac ;
assign S_pla_rcu_mac[9 ] = I_pla1_rcu_mac ;
assign S_pla_rcu_mac[10] = I_pla1_rcu_mac ;
assign S_pla_rcu_mac[11] = I_pla1_rcu_mac ;
assign S_pla_rcu_mac[12] = I_pla1_rcu_mac ;
assign S_pla_rcu_mac[13] = I_pla1_rcu_mac ;
assign S_pla_rcu_mac[14] = I_pla1_rcu_mac ;
assign S_pla_rcu_mac[15] = I_pla1_rcu_mac ;
assign S_pla_rcu_mac[16] = I_pla2_rcu_mac ;
assign S_pla_rcu_mac[17] = I_pla2_rcu_mac ;
assign S_pla_rcu_mac[18] = I_pla2_rcu_mac ;
assign S_pla_rcu_mac[19] = I_pla2_rcu_mac ;
assign S_pla_rcu_mac[20] = I_pla2_rcu_mac ;
assign S_pla_rcu_mac[21] = I_pla2_rcu_mac ;
assign S_pla_rcu_mac[22] = I_pla2_rcu_mac ;
assign S_pla_rcu_mac[23] = I_pla2_rcu_mac ;

generate
for(i=0;i<24;i=i+1)
begin:SA_CHECK
    always @ (posedge I_pla_312m5_clk)
    begin
        if(S_xgmii_rxd_buf3[15:0] == S_pla_air_mac[i][47:32])
            begin
                S_pla_slice_sa_h_ok[i] <= 1'b1;
            end
        else
            begin
                S_pla_slice_sa_h_ok[i] <= 1'b0;
            end
    end
    
    always @ (posedge I_pla_312m5_clk)
    begin
        if(S_xgmii_rxd_buf2[31:0] == S_pla_air_mac[i][31:0])
            begin
                S_pla_slice_sa_l_ok[i] <= 1'b1;
            end
        else
            begin
                S_pla_slice_sa_l_ok[i] <= 1'b0;
            end
    end
    
    always @ (posedge I_pla_312m5_clk)
    begin
        if(S_xgmii_rxd_buf4 == S_pla_rcu_mac[i][47:16])
            begin
                S_pla_slice_da_h_ok[i] <= 1'b1;
            end
        else
            begin
                S_pla_slice_da_h_ok[i] <= 1'b0;
            end
    end
    
    always @ (posedge I_pla_312m5_clk)
    begin
        if(S_xgmii_rxd_buf3[31:16] == S_pla_rcu_mac[i][15:0])
            begin
                S_pla_slice_da_l_ok[i] <= 1'b1;
            end
        else
            begin
                S_pla_slice_da_l_ok[i] <= 1'b0;
            end
    end    
    
    
    
    
    always @ (posedge I_pla_312m5_clk)
    begin
        S_pla_air_index[i] <= S_pla_slice_da_h_ok[i] && S_pla_slice_da_l_ok[i] && S_pla_slice_sa_h_ok[i] && S_pla_slice_sa_l_ok[i]; 
        if((|S_pla_slice_da_h_ok[23:16]) && (|S_pla_slice_da_l_ok[23:16]) && (|S_pla_slice_sa_h_ok[23:16]) && (|S_pla_slice_sa_l_ok[23:16]))
            begin
                R_xgmii_pla_num_pre <= 2'b10;
            end
        else if((|S_pla_slice_da_h_ok[15:8]) && (|S_pla_slice_da_l_ok[15:8]) && (|S_pla_slice_sa_h_ok[15:8]) && (|S_pla_slice_sa_l_ok[15:8]))
            begin
                R_xgmii_pla_num_pre <= 2'b01;
            end
        else if((|S_pla_slice_da_h_ok[7:0]) && (|S_pla_slice_da_l_ok[7:0]) && (|S_pla_slice_sa_h_ok[7:0]) && (|S_pla_slice_sa_l_ok[7:0]))
            begin
                R_xgmii_pla_num_pre <= 2'b00;
            end
        else
            begin
                R_xgmii_pla_num_pre <= R_xgmii_pla_num_pre ;
            end
    end
    
end
endgenerate

always @ (posedge I_pla_312m5_clk)
begin
    if((S_parser_state == C_PARSER_DATA) && (S_xgmii_length_cnt == 7'd1))
        begin
            S_pla_air_index_lck <= S_pla_air_index;
        end
end

always @ (posedge I_pla_312m5_clk)
begin
    S_pla_slice_mac_ok <= |S_pla_air_index_lck;
end

always @ (posedge I_pla_312m5_clk)
begin
    if(|S_pla_air_index_lck[23:16])
        begin
            S_xgmii_pla_num <= 2'b10;
        end
    else if(|S_pla_air_index_lck[15:8])
        begin
            S_xgmii_pla_num <= 2'b01;
        end
    else
        begin
            S_xgmii_pla_num <= 2'b00;
        end
end

always @ (posedge I_pla_312m5_clk)
begin
    if((S_parser_state == C_PARSER_DATA) && (S_xgmii_length_cnt == 7'd0))
        begin
            if(!S_xgmii_rxd_buf2[31])
                begin
                    S_pla_slice_id <= S_xgmii_rxd_buf2[30:16];
                end
            else
                begin
                    S_pla_slice_id <= 15'd0;
                end
        end
end

always @ (posedge I_pla_312m5_clk)
begin
    if((S_parser_state == C_PARSER_DATA) && (S_xgmii_length_cnt == 7'd0))
        begin
            if(!S_xgmii_rxd_buf2[31])
                begin
                    S_pla_slice_flg <= 1'b1;
                end
            else
                begin
                    S_pla_slice_flg <= 1'b0;
                end
        end
end



always @ (posedge I_pla_312m5_clk)
begin
    if((S_parser_state == C_PARSER_DATA) && (S_xgmii_rxc_buf1 == 4'd0)) ///cou
        begin
            S_pla_slice_payload    <= {S_xgmii_rxd_buf2[15:0],S_xgmii_rxd_buf1[31:16]};
            S_pla_slice_payload_en <= 1'b1;
        end
    else
        begin
            S_pla_slice_payload    <= 32'd0;
            S_pla_slice_payload_en <= 1'b0;
        end
end

always @ (posedge I_pla_312m5_clk)
begin
    if((S_parser_state == C_PARSER_DATA) && S_pla_slice_mac_ok && S_pla_slice_flg && (S_xgmii_end_info == 4'b0010))
        begin
            if(S_xgmii_length_cnt == 7'd65)
                begin
                    S_pla_slice_check_ok <= 1'b1;
                end
            else
                begin
                    S_pla_slice_check_ok <= 1'b0;
                end
        end
    else
        begin
            S_pla_slice_check_ok <= 1'b0;
        end
end

always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_xgmii_pla_num_lck <= 2'b0;
            S_pla_slice_id_lck  <= 15'd0;
        end
    else if(S_pla_slice_check_ok)
        begin
            S_xgmii_pla_num_lck <= S_xgmii_pla_num;
            S_pla_slice_id_lck  <= S_pla_slice_id;
        end
end

always @ (posedge I_pla_312m5_clk)
begin
    if(S_pla_slice_check_ok && (S_xgmii_pla_num == 2'b00))
        begin
            S_pla0_slice_check_ok <= 1'b1;
        end
    else
        begin
            S_pla0_slice_check_ok <= 1'b0;
        end
end

always @ (posedge I_pla_312m5_clk)
begin
    if(S_pla_slice_check_ok && (S_xgmii_pla_num == 2'b01))
        begin
            S_pla1_slice_check_ok <= 1'b1;
        end
    else
        begin
            S_pla1_slice_check_ok <= 1'b0;
        end
end

always @ (posedge I_pla_312m5_clk)
begin
    if(S_pla_slice_check_ok && (S_xgmii_pla_num == 2'b10))
        begin
            S_pla2_slice_check_ok <= 1'b1;
        end
    else
        begin
            S_pla2_slice_check_ok <= 1'b0;
        end
end

always @ (posedge I_pla_312m5_clk)
begin
    if((S_parser_state == C_PARSER_DATA) && S_pla_slice_mac_ok && !S_pla_slice_flg && (S_xgmii_end_info == 4'b1000))
        begin
            if(S_xgmii_length_cnt == 7'd13)
                begin
                    S_pla_request_check_ok <= 1'b1;
                end
            else
                begin
                    S_pla_request_check_ok <= 1'b0;
                end
        end
    else
        begin
            S_pla_request_check_ok <= 1'b0;
        end
end

always @ (posedge I_pla_312m5_clk)
begin
    S_pla_request_check_ok_buf <= S_pla_request_check_ok;
end



always @ (posedge I_pla_312m5_clk)
begin
    if(S_xgmii_length_cnt == 7'd3)
        begin
            S_pla0_slice_calc_pre <= |S_pla_air_index_lck[7:0];
        end
    else
        begin
            S_pla0_slice_calc_pre <= 1'b0;
        end
end

always @ (posedge I_pla_312m5_clk)
begin
    if(S_xgmii_length_cnt == 7'd3)
        begin
            S_pla1_slice_calc_pre <= |S_pla_air_index_lck[15:8];
        end
    else
        begin
            S_pla1_slice_calc_pre <= 1'b0;
        end
end

always @ (posedge I_pla_312m5_clk)
begin
    if(S_xgmii_length_cnt == 7'd3)
        begin
            S_pla2_slice_calc_pre <= |S_pla_air_index_lck[23:16];
        end
    else
        begin
            S_pla2_slice_calc_pre <= 1'b0;
        end
end


pla_backward_id_calc U0_pla_backward_id_calc(
.I_pla_312m5_clk            (I_pla_312m5_clk           ),
.I_pla_rst                  (I_pla_rst                 ),
.I_pla_air_link             (I_pla0_air_link           ),
.I_pla_slice_window         (I_pla_slice_window        ), 
.I_pla_slice_id             (S_pla_slice_id            ),
.I_pla_air_index            (S_pla_air_index_lck[7:0]  ),
.I_pla_slice_calc_pre       (S_pla0_slice_calc_pre     ),
.I_pla_slice_check_ok       (S_pla0_slice_check_ok     ),
.O_pla_slice_id_a           (),
.O_pla_slice_id_b           (),
.O_pla_slice_id_c           (),
.O_pla_slice_id_d           (),
.O_pla_slice_id_e           (),
.O_pla_slice_id_f           (),
.O_pla_slice_id_g           (),
.O_pla_slice_id_h           (),
.I_cnt_clear				(I_cnt_clear					),
.O_slice_id_bottom_err_cnt	(O_pla0_slice_id_bottom_err_cnt	),
.O_slice_id_random_order	(O_pla0_slice_id_random_order	),
.O_pla_slice_id_max			(S_pla0_slice_id_max       ),
.O_pla_slice_id_min			(S_pla0_slice_id_min       )
);


pla_backward_id_calc U1_pla_backward_id_calc(
.I_pla_312m5_clk            (I_pla_312m5_clk           ),
.I_pla_rst                  (I_pla_rst                 ),
.I_pla_air_link             (I_pla1_air_link           ),
.I_pla_slice_window         (I_pla_slice_window        ), 
.I_pla_slice_id             (S_pla_slice_id            ),
.I_pla_air_index            (S_pla_air_index_lck[15:8] ),
.I_pla_slice_calc_pre       (S_pla1_slice_calc_pre     ),
.I_pla_slice_check_ok       (S_pla1_slice_check_ok     ),
.O_pla_slice_id_a           (),
.O_pla_slice_id_b           (),
.O_pla_slice_id_c           (),
.O_pla_slice_id_d           (),
.O_pla_slice_id_e           (),
.O_pla_slice_id_f           (),
.O_pla_slice_id_g           (),
.O_pla_slice_id_h           (),
.I_cnt_clear				(I_cnt_clear					),
.O_slice_id_bottom_err_cnt	(O_pla1_slice_id_bottom_err_cnt	),
.O_slice_id_random_order	(O_pla1_slice_id_random_order	),
.O_pla_slice_id_max			(S_pla1_slice_id_max       ),
.O_pla_slice_id_min			(S_pla1_slice_id_min       )
  ); 
  
pla_backward_id_calc U2_pla_backward_id_calc(
.I_pla_312m5_clk            (I_pla_312m5_clk           ),
.I_pla_rst                  (I_pla_rst                 ),
.I_pla_air_link             (I_pla2_air_link           ),
.I_pla_slice_window         (I_pla_slice_window        ), 
.I_pla_slice_id             (S_pla_slice_id            ),
.I_pla_air_index            (S_pla_air_index_lck[23:16]),
.I_pla_slice_calc_pre       (S_pla2_slice_calc_pre     ),
.I_pla_slice_check_ok       (S_pla2_slice_check_ok     ),
.O_pla_slice_id_a           (),
.O_pla_slice_id_b           (),
.O_pla_slice_id_c           (),
.O_pla_slice_id_d           (),
.O_pla_slice_id_e           (),
.O_pla_slice_id_f           (),
.O_pla_slice_id_g           (),
.O_pla_slice_id_h           (),
.I_cnt_clear				(I_cnt_clear					),
.O_slice_id_bottom_err_cnt	(O_pla2_slice_id_bottom_err_cnt	),
.O_slice_id_random_order	(O_pla2_slice_id_random_order	),
.O_pla_slice_id_max			(S_pla2_slice_id_max       ),
.O_pla_slice_id_min			(S_pla2_slice_id_min       )
);
 
////  `else
/*
assign S_pla1_slice_id_max  = 15'd0;  
assign S_pla1_slice_id_min  = 15'd0;  
assign S_pla2_slice_id_max  = 15'd0;  
assign S_pla2_slice_id_min  = 15'd0;  
*/

always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_pla0_slice_wr_resp_buf1 <= 1'b0;
            S_pla1_slice_wr_resp_buf1 <= 1'b0;
            S_pla2_slice_wr_resp_buf1 <= 1'b0;
            S_pla0_slice_wr_resp_buf2 <= 1'b0;
            S_pla1_slice_wr_resp_buf2 <= 1'b0;
            S_pla2_slice_wr_resp_buf2 <= 1'b0;
        end
    else
        begin
            S_pla0_slice_wr_resp_buf1 <= I_pla0_slice_wr_resp     ;
            S_pla1_slice_wr_resp_buf1 <= I_pla1_slice_wr_resp     ;
            S_pla2_slice_wr_resp_buf1 <= I_pla2_slice_wr_resp     ;
            S_pla0_slice_wr_resp_buf2 <= S_pla0_slice_wr_resp_buf1;
            S_pla1_slice_wr_resp_buf2 <= S_pla1_slice_wr_resp_buf1;
            S_pla2_slice_wr_resp_buf2 <= S_pla2_slice_wr_resp_buf1;
        end
end

always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_pla0_slice_id_new       <= 15'd0;  
            S_pla0_slice_id_new_valid <= 1'd0 ;
        end
    else if(I_pla0_slice_wr_resp && !S_pla0_slice_wr_resp_buf1)
        begin
            S_pla0_slice_id_new       <= I_pla0_slice_num_id[14:0];  
            S_pla0_slice_id_new_valid <= 1'd1 ;
        end
    else
        begin
            S_pla0_slice_id_new       <= S_pla0_slice_id_new;  
            S_pla0_slice_id_new_valid <= 1'd0 ;
        end
end

always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_pla1_slice_id_new       <= 15'd0;  
            S_pla1_slice_id_new_valid <= 1'd0 ;
        end
    else if(I_pla1_slice_wr_resp && !S_pla1_slice_wr_resp_buf1)
        begin
            S_pla1_slice_id_new       <= S_pla_slice_id_lck;  
            S_pla1_slice_id_new_valid <= 1'd1 ;
        end
    else
        begin
            S_pla1_slice_id_new       <= S_pla1_slice_id_new;  
            S_pla1_slice_id_new_valid <= 1'd0 ;
        end
end

always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_pla2_slice_id_new       <= 15'd0;  
            S_pla2_slice_id_new_valid <= 1'd0 ;
        end
    else if(I_pla2_slice_wr_resp && !S_pla2_slice_wr_resp_buf1)
        begin
            S_pla2_slice_id_new       <= S_pla_slice_id_lck;  
            S_pla2_slice_id_new_valid <= 1'd1 ;
        end
    else
        begin
            S_pla2_slice_id_new       <= S_pla2_slice_id_new;  
            S_pla2_slice_id_new_valid <= 1'd0 ;
        end
end

always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_pla0_slice_id_max_out <= 15'd0;
            S_pla0_slice_id_min_out <= 15'd0;
        end
    else if(S_pla0_slice_wr_resp_buf1 && !S_pla0_slice_wr_resp_buf2)
        begin
            S_pla0_slice_id_max_out <= S_pla0_slice_id_max;
            S_pla0_slice_id_min_out <= S_pla0_slice_id_min;
        end
end

always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_pla1_slice_id_max_out <= 15'd0;
            S_pla1_slice_id_min_out <= 15'd0;
        end
    else if(S_pla1_slice_wr_resp_buf1 && !S_pla1_slice_wr_resp_buf2)
        begin
            S_pla1_slice_id_max_out <= S_pla1_slice_id_max;
            S_pla1_slice_id_min_out <= S_pla1_slice_id_min;
        end
end

always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_pla2_slice_id_max_out <= 15'd0;
            S_pla2_slice_id_min_out <= 15'd0;
        end
    else if(S_pla2_slice_wr_resp_buf1 && !S_pla2_slice_wr_resp_buf2)
        begin
            S_pla2_slice_id_max_out <= S_pla2_slice_id_max;
            S_pla2_slice_id_min_out <= S_pla2_slice_id_min;
        end
end

assign O_pla_slice_id            = S_pla_slice_id           ;
assign O_pla_slice_payload       = S_pla_slice_payload      ;
assign O_pla_slice_payload_en    = S_pla_slice_payload_en   ;
assign O_pla0_slice_check_ok     = S_pla0_slice_check_ok    ;
assign O_pla1_slice_check_ok     = S_pla1_slice_check_ok    ;
assign O_pla2_slice_check_ok     = S_pla2_slice_check_ok    ;
assign O_pla0_slice_id_new       = S_pla0_slice_id_new      ;
assign O_pla0_slice_id_new_valid = S_pla0_slice_id_new_valid;
assign O_pla1_slice_id_new       = S_pla1_slice_id_new      ;
assign O_pla1_slice_id_new_valid = S_pla1_slice_id_new_valid;
assign O_pla2_slice_id_new       = S_pla2_slice_id_new      ;
assign O_pla2_slice_id_new_valid = S_pla2_slice_id_new_valid;
assign O_pla0_slice_id_max       = S_pla0_slice_id_max_out  ;
assign O_pla0_slice_id_min       = S_pla0_slice_id_min_out  ;
assign O_pla1_slice_id_max       = S_pla1_slice_id_max_out  ;
assign O_pla1_slice_id_min       = S_pla1_slice_id_min_out  ;
assign O_pla2_slice_id_max       = S_pla2_slice_id_max_out  ;
assign O_pla2_slice_id_min       = S_pla2_slice_id_min_out  ;
assign O_xgmii_pla_num           = R_xgmii_pla_num_pre      ;


////错误信息统计  长度错误

always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
    begin
        O_pla_slice_len_err_cnt <= 16'd0;
    end
    else if(I_cnt_clear)
    begin
        O_pla_slice_len_err_cnt <= 16'd0;
    end
    else if((S_parser_state == C_PARSER_DATA) && S_pla_slice_mac_ok && (S_xgmii_end_info != 4'b0000))
    begin
        if(S_xgmii_length_cnt == 7'd65 && S_xgmii_end_info == 4'b0010)
        begin
             O_pla_slice_len_err_cnt <= O_pla_slice_len_err_cnt ; 
        end
        else 
        begin
             O_pla_slice_len_err_cnt <= O_pla_slice_len_err_cnt + 16'd1; 
        end
    end
end

always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
    begin
        O_pla_slice_mac_err_cnt <= 16'd0;
    end
    else if(I_cnt_clear)
    begin
        O_pla_slice_mac_err_cnt <= 16'd0;
    end
    else if(S_xgmii_length_cnt == 7'd1 && S_pla_air_index == 8'd0 && (S_parser_state == C_PARSER_DATA))
    begin
        O_pla_slice_mac_err_cnt <= O_pla_slice_mac_err_cnt + 16'd1; 
    end
end

/////---------------------------------------------------------
///// debug	begin
/////---------------------------------------------------------
(*MARK_DEBUG ="true"*)reg			dbg_O_pla_slice_len_err_cnt	;
(*MARK_DEBUG ="true"*)reg			dbg_O_pla_slice_mac_err_cnt	; 


always @ (posedge I_pla_312m5_clk )
begin
    dbg_O_pla_slice_len_err_cnt	<= O_pla_slice_len_err_cnt[0]	;   
	dbg_O_pla_slice_mac_err_cnt	<= O_pla_slice_mac_err_cnt[0]	;
end

/////---------------------------------------------------------
///// debug end	
/////---------------------------------------------------------




endmodule
