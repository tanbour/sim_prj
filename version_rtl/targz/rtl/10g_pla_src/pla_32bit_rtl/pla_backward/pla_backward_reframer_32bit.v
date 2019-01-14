`timescale 1ns/100ps
module pla_backward_reframer_32bit(
input                    I_pla_312m5_clk                   ,
input                    I_pla_rst                         ,
input      [32:0]        I_pla0_reflow_fifo_rdata          ,
input                    I_pla0_reflow_fifo_empty          ,
input      [32:0]        I_pla1_reflow_fifo_rdata          ,
input                    I_pla1_reflow_fifo_empty          ,
input      [32:0]        I_pla2_reflow_fifo_rdata          ,
input                    I_pla2_reflow_fifo_empty          ,
input                    I_cnt_clear                       ,
input                    I_pla_feedback_rd_pla0            ,
input                    I_pla_feedback_rd_pla1            ,
input                    I_pla_feedback_rd_pla2            ,
input                    I_pause_from_back_hc              ,
input                    I_pause_en                        ,
output                   O_pla0_reflow_fifo_rd             ,
output                   O_pla1_reflow_fifo_rd             ,
output                   O_pla2_reflow_fifo_rd             ,
output        [31:0]     O_pla_xgmii_rxd                   ,
output        [3:0 ]     O_pla_xgmii_rxc                   ,
output        [1:0 ]     O_pla_xgmii_pla_num               ,
output                   O_pla_xgmii_err                   ,
output        [15:0]     O_reframe_crcok_cnt               , 
output        [15:0]     O_reframe_crcerr_cnt              ,
output        [15:0]     O_all_err_cnt                     ,
output        [15:0]     O_fifo_full0_cnt                  ,
output        [15:0]     O_ram_full0_cnt                   ,
output        [15:0]     O_length_err0_cnt                 ,
output        [15:0]     O_drop_flag_cnt                   ,
output        [15:0]     O_feedback_cnt                    ,
output        [15:0]     O_reframe_state_change_cnt        ,
output        [15:0]     O_slice_cnt                       ,
output        [15:0]     O_reframe_pla0_55d5_cnt           ,

output        [31:0]     O_feedback_fifo_rdata_pla0        ,
output        [5:0 ]     O_feedback_fifo_count_pla0        ,
output                   O_feedback_fifo_full_pla0         ,
output                   O_feedback_fifo_empty_pla0        ,
output                   O_pla_slice_fifo_empty_pla0       ,

output        [31:0]     O_feedback_fifo_rdata_pla1        ,
output        [5:0 ]     O_feedback_fifo_count_pla1        ,
output                   O_feedback_fifo_full_pla1         ,
output                   O_feedback_fifo_empty_pla1        ,
output                   O_pla_slice_fifo_empty_pla1       ,

output        [31:0]     O_feedback_fifo_rdata_pla2        ,
output        [5:0 ]     O_feedback_fifo_count_pla2        ,
output                   O_feedback_fifo_full_pla2         ,
output                   O_feedback_fifo_empty_pla2        ,
output                   O_pla_slice_fifo_empty_pla2       ,




output        [15:0]     O_pla0_reframe_fifo_wr_cnt        ,

output  reg   [31:0]     O_pla0_pla_bac_reframer_input_data_catch,
output  reg              O_pla0_pla_bac_reframer_input_en_catch  ,
output  reg              O_pla0_time_out_flag_catch              ,
output  reg   [3:0]      O_pla0_reframe_state_catch              ,
output  reg              O_pla0_length_err_catch                 ,
output  reg   [15:0]     O_pla_rst_cnt                           ,

output  reg   [15:0]     O_frame_dpram_usedw_back_pla0           ,
output  reg   [15:0]     O_frame_dpram_usedw_back_pla1           ,
output  reg   [15:0]     O_frame_dpram_usedw_back_pla2           ,
output  reg   [15:0]     O_err_tme_cnt=16'd0                     ,
output        [15:0 ]    O_small_inter_cnt                       ,
output  reg              O_crc_wrong                               





);

parameter           C_FRAME_IDLE                = 3'd0, 
                    C_FRAME_PRE                 = 3'd1,
                    C_FRAME_PLD                 = 3'd2,
                    C_FRAME_NOHCCRC             = 3'd4;
parameter           C_IDLE                      = 8'h07;

reg       [2:0]     S_frame_state                            ;
reg       [2:0]     S_frame_state_buf1                       ;
reg       [2:0]     S_frame_state_buf2                       ;
reg       [2:0]     S_frame_state_next                       ;
reg                 S_pla_frame_sdpram_rd[0:2]               ;

reg [11:0] S_pla_frame_sdpram_raddr_0                        ;
reg [11:0] S_pla_frame_sdpram_raddr_1                        ;
reg [11:0] S_pla_frame_sdpram_raddr_2                        ;

reg [11:0] S_pla_frame_end_addr_0                            ;
reg [11:0] S_pla_frame_end_addr_1                            ;
reg [11:0] S_pla_frame_end_addr_2                            ;


                                                             
reg       S_pla_frame_index_0=1'b0                           ;
reg       S_pla_frame_index_1=1'b0                           ;
reg       S_pla_frame_index_2=1'b0                           ;



reg                 S_pla_frame_para_fifo_rd_0               ;
reg                 S_pla_frame_para_fifo_rd_1               ;
reg                 S_pla_frame_para_fifo_rd_2               ;


wire      [31:0]    S_pla_frame_sdpram_rdata_0               ;
wire      [31:0]    S_pla_frame_sdpram_rdata_1               ;
wire      [31:0]    S_pla_frame_sdpram_rdata_2               ;

wire      [33:0]    S_pla_frame_para_fifo_rdata_0            ;
wire      [33:0]    S_pla_frame_para_fifo_rdata_1            ;
wire      [33:0]    S_pla_frame_para_fifo_rdata_2            ;

wire                S_pla_frame_para_fifo_empty_0              ;
wire                S_pla_frame_para_fifo_empty_1              ;
wire                S_pla_frame_para_fifo_empty_2              ;

reg                 S_pla_frame_para_fifo_empty_d1_0           ;
reg                 S_pla_frame_para_fifo_empty_d1_1           ;
reg                 S_pla_frame_para_fifo_empty_d1_2           ;
reg                 S_pla_frame_req_0                        ;
reg                 S_pla_frame_req_1                        ;
reg                 S_pla_frame_req_2                        ;

reg                S_pla_frame_resp_0                         ;
reg                S_pla_frame_resp_1                         ;
reg                S_pla_frame_resp_2                         ;


reg                 S_pla_frame_start_0                 = 1'b0 ;
reg                 S_pla_frame_start_1                 = 1'b0 ;
reg                 S_pla_frame_start_2                 = 1'b0 ;

reg       [35:0]    S_pla_frame_para                  = 36'b0;
wire      [11:0]    S_pla_frame_start_addr                   ;
wire      [11:0]    S_pla_frame_end_addr                     ;
wire                S_pla_frame_hc_flg                       ;
wire                S_pla_frame_odd_byte_flg                 ;
wire                S_pla_frame_odd_word_flg                 ;
reg                 S_pla_frame_odd_byte_flg_lck      = 1'b0 ;
reg                 S_pla_frame_odd_word_flg_lck      = 1'b0 ;
reg                 S_pla_frame_pre_cnt               = 1'b0 ;
reg       [11:0]    S_pla_frame_sdpram_raddr_b        = 12'd0;
reg       [31:0]    S_pla_frame_sdpram_rdata_b        = 32'd0;
reg                 S_pla_frame_sdpram_rd_end         = 1'b0 ;
reg                 S_pla_frame_sdpram_rd_end_buf1    = 1'b0 ;

reg       [31:0]    S_pla_xgmii_rxd                   = 32'd0;
reg       [3:0]     S_pla_xgmii_rxc                   = 4'hf ;
reg                 S1_pla_xgmii_rxc                  = 1'b0 ; 
reg                 S2_pla_xgmii_rxc                  = 1'b0 ; 
reg       [1:0]     S_pla_xgmii_pla_num               = 2'd0 ; 
reg       [3:0]     O_pla_xgmii_rxc_d1                = 4'h0 ;
wire                S_div4_equa0                             ;
wire                S_div4_equa2                             ;  
wire                S_3crc                                   ;
wire                S_2crc                                   ;
wire                S_crc_wrong                              ;
wire                S_crc_ok                                 ;

wire                S0_pla_frame_req                         ;  ///DEBUG
reg      [31:0]     S_pla_frame_crc_data                     ;
reg      [3:0 ]     S_pla_frame_crc_data_ctrl                ; 
reg                 S_pla_frame_pre_cnt_d1                   ; 
reg      [31:0]     S_pla_frame_sdpram_rdata_b_d1            ; 

wire                S_2crc_div4equa2                         ;  
wire                S_2crc_div4equa0                         ;
wire                S_3crc_div4equa2                         ;
wire                S_3crc_div4equa0                         ;
wire                S_fifo_full0                             ;
wire                S_frame_dpram_alful0                     ;
wire                S_length_err0                            ;
wire                S_time_out_flag_pla0                     ;
wire                S_fifo_full1                             ;
wire                S_frame_dpram_alful1                     ;
wire                S_length_err1                            ;
wire                S_time_out_flag_pla1                     ;
wire                S_fifo_full2                             ;
wire                S_frame_dpram_alful2                     ;
wire                S_length_err2                            ;
wire                S_time_out_flag_pla2                     ;

reg      [1:0]      S_pla_num                                ; 
wire     [31:0]     S_crc_out                                ;
wire                S_hc_flag                                ;
reg                 S_ptp_flag                               ;
reg                 S_ptp_flag_d1                            ;
reg                 S_ptp_flag_d2                            ;
reg                 S_ptp_flag_d3                            ;
reg                 S_ptp_flag_d4                            ;
reg                 S_ptp_flag_d5                            ;
reg                 S_ptp_flag_d6                            ;
reg                 S_ptp_flag_d7                            ;







wire                S_reverse                                ;
wire                S_normal                                 ;

wire                S_pla0_back_55d5_flag                    ;
wire                O_frame_fifo_wren_pla0                   ;
wire                S_pla1_back_55d5_flag                    ;
wire                O_frame_fifo_wren_pla1                   ;
wire                S_pla2_back_55d5_flag                    ;
wire                O_frame_fifo_wren_pla2                   ;

///////test code 
reg [7:0]   packet_num   =8'd0                               ;
reg         S_num_flag                                       ;
reg         S_num_flag_d1                                    ;
reg         S_num_flag_d2                                    ;
reg         S_num_flag_d3                                    ;
reg         S_num_flag_d4                                    ;
reg [7:0]   packet_num_d1                                    ;
reg [7:0]   S_drop_cnt                                       ;
reg         S_drop_flag                                      ;
wire        S_feedback_flag_pla0                             ;
wire        S_feedback_flag_pla1                             ;
wire        S_feedback_flag_pla2                             ;
reg         S_pla0_reflow_fifo_rd_d1                         ;
reg         S_state_chang_flag                               ;

reg         S_pla_3group_scheme_0                            ;
reg         S_pla_3group_scheme_1                            ;
reg         S_pla_3group_scheme_2                            ;


wire [31:0] S_pla0_pla_bac_reframer_input_data_catch         ;
wire        S_pla0_pla_bac_reframer_input_en_catch           ;
wire        S_pla0_time_out_flag_catch                       ;
wire [3:0 ] S_pla0_reframe_state_catch                       ;
wire        S_pla0_length_err_catch                          ;
wire        S_rst_pla_pla0                                   ;
wire        S_rst_pla_pla1                                   ;
wire        S_rst_pla_pla2                                   ;
wire [15:0] S_pla_rst_cnt                                    ;
wire [15:0] S_frame_dpram_usedw_back_pla0                    ;
wire [15:0] S_frame_dpram_usedw_back_pla1                    ;
wire [15:0] S_frame_dpram_usedw_back_pla2                    ;

wire        S_pla_fifo_full_pla0                             ;
wire        S_pla_fifo_full_pla1                             ;
wire        S_pla_fifo_full_pla2                             ;

reg [7:0]  S_fifo_full_time_cnt=8'd0 ;
reg [7:0]  S_pla_pause_time_cnt=8'd0 ;
reg        S_inter_small_flag        ;
reg  [3:0] S_inter_small_cnt= 3'd0  ;
    
    

always @ (posedge I_pla_312m5_clk)
begin
    O_pla0_pla_bac_reframer_input_data_catch    <=   S_pla0_pla_bac_reframer_input_data_catch ;
    O_pla0_pla_bac_reframer_input_en_catch      <=   S_pla0_pla_bac_reframer_input_en_catch   ;
    O_pla0_time_out_flag_catch                  <=   S_pla0_time_out_flag_catch               ;
    O_pla0_reframe_state_catch                  <=   S_pla0_reframe_state_catch               ;
    O_pla0_length_err_catch                     <=   S_pla0_length_err_catch                  ;
    
    O_frame_dpram_usedw_back_pla0               <=   S_frame_dpram_usedw_back_pla0            ; 
    O_frame_dpram_usedw_back_pla1               <=   S_frame_dpram_usedw_back_pla1            ;
    O_frame_dpram_usedw_back_pla2               <=   S_frame_dpram_usedw_back_pla2            ;
    

end


always @ (posedge I_pla_312m5_clk)
begin
    O_crc_wrong  <=  S_crc_wrong  ;
end





always @ (posedge I_pla_312m5_clk)
begin
    if(S_inter_small_cnt == 4'hf)
        begin
            S_inter_small_cnt <=  4'hf ;
        end
    else if(O_pla_xgmii_rxc==4'hf)
        begin
            S_inter_small_cnt <=S_inter_small_cnt +4'd1; 
        end
    else 
        begin
           S_inter_small_cnt <= 4'd0 ; 
        end
end



always @ (posedge I_pla_312m5_clk)
begin
    O_pla_xgmii_rxc_d1 <= O_pla_xgmii_rxc ;
end


always @ (posedge I_pla_312m5_clk)
begin
    if((O_pla_xgmii_rxc!=4'hf)&& (O_pla_xgmii_rxc_d1 == 4'hf )&& S_inter_small_cnt <=4'd1 )
        begin
            S_inter_small_flag <= 1'b1 ;
        end
    else
        begin
            S_inter_small_flag <= 1'b0 ;            
        end
end

//////////////

assign O_pla_xgmii_err = 1'b0 ;
assign O_inter_small_flag   = S_inter_small_flag ;

////3group diaodu 
/*
////to slove the not the same ok 
always @ (posedge I_pla_312m5_clk)
    begin
        if(I_pla_rst)
            begin
                S_pla_3group_scheme <= 1'b0 ;
            end        
        else if(S_frame_state_next  == C_FRAME_IDLE )
            begin
                if(!S_pla_frame_para_fifo_empty_d1_0)
                    begin
                        S_pla_3group_scheme <= 1'b1 ;
                    end
                else if(!S_pla_frame_para_fifo_empty_d1_1)
                    begin
                        S_pla_3group_scheme <= 1'b1 ;
                    end
                else if(!S_pla_frame_para_fifo_empty_d1_2)
                    begin
                        S_pla_3group_scheme <= 1'b1 ;
                    end                    
            end
        else
            begin
                        S_pla_3group_scheme <= 1'b0 ;                
            end            
    end
*/
always @ (posedge I_pla_312m5_clk)
    begin
        if(I_pla_rst)
            begin
                S_pla_3group_scheme_0 <= 1'b0 ;
            end        
        else if(S_frame_state_next  == C_FRAME_IDLE )
            begin
                if(!S_pla_frame_para_fifo_empty_d1_0)
                    begin
                        S_pla_3group_scheme_0 <= 1'b1 ;
                    end
               else
                   begin
                        S_pla_3group_scheme_0 <= 1'b0 ;                       
                   end                   
            end
        else
            begin
                        S_pla_3group_scheme_0 <= 1'b0 ;                
            end            
    end

always @ (posedge I_pla_312m5_clk)
    begin
        if(I_pla_rst)
            begin
                S_pla_3group_scheme_1 <= 1'b0 ;
            end        
        else if(S_frame_state_next  == C_FRAME_IDLE )
            begin
                if(!S_pla_frame_para_fifo_empty_d1_1)
                    begin
                        S_pla_3group_scheme_1 <= 1'b1 ;
                    end
               else
                   begin
                        S_pla_3group_scheme_1 <= 1'b0 ;                       
                   end                   
            end
        else
            begin
                        S_pla_3group_scheme_1 <= 1'b0 ;                
            end            
    end
    
 
   
/////优先级最高
always @ (posedge I_pla_312m5_clk)
    begin
        if(I_pla_rst)
            begin
                S_pla_frame_para_fifo_rd_0 <= 1'b0;
            end
        else if(!S_pla_frame_para_fifo_empty_d1_0 && !S_pla_frame_req_0 &&   !S_pla_frame_para_fifo_rd_0 && S_frame_state_next == C_FRAME_IDLE)
            begin
                S_pla_frame_para_fifo_rd_0 <= 1'b1;
            end
        else
            begin
                S_pla_frame_para_fifo_rd_0 <= 1'b0;
            end
end

always @ (posedge I_pla_312m5_clk)
    begin
        if(I_pla_rst)
            begin
                S_pla_frame_para_fifo_rd_1 <= 1'b0;
            end
        else if(!S_pla_frame_para_fifo_empty_d1_1 && S_pla_frame_para_fifo_empty_d1_0 && !S_pla_frame_req_1 &&  !S_pla_3group_scheme_0&& !S_pla_frame_para_fifo_rd_1 && S_frame_state_next == C_FRAME_IDLE)
            begin
                S_pla_frame_para_fifo_rd_1 <= 1'b1;
            end
        else
            begin
                S_pla_frame_para_fifo_rd_1 <= 1'b0;
            end
end

always @ (posedge I_pla_312m5_clk)
    begin
        if(I_pla_rst)
            begin
                S_pla_frame_para_fifo_rd_2 <= 1'b0;
            end
        else if(!S_pla_frame_para_fifo_empty_d1_2 && S_pla_frame_para_fifo_empty_d1_0 && S_pla_frame_para_fifo_empty_d1_1 &&!S_pla_frame_req_2 &&  (!(S_pla_3group_scheme_0|S_pla_3group_scheme_1)) && !S_pla_frame_para_fifo_rd_2 && S_frame_state_next == C_FRAME_IDLE)
            begin
                S_pla_frame_para_fifo_rd_2 <= 1'b1;
            end
        else
            begin
                S_pla_frame_para_fifo_rd_2 <= 1'b0;
            end
end

always @ (posedge I_pla_312m5_clk)
    begin
        if(I_pla_rst)
            begin
                S_pla_frame_req_0 <= 1'b0;
            end
        else if(S_pla_frame_resp_0)
            begin
                S_pla_frame_req_0 <= 1'b0;
            end
        else if(S_pla_frame_para_fifo_rd_0)
            begin
                S_pla_frame_req_0 <= 1'b1;
            end
    end


always @ (posedge I_pla_312m5_clk)
    begin
        if(I_pla_rst)
            begin
                S_pla_frame_req_1 <= 1'b0;
            end
        else if(S_pla_frame_resp_1)
            begin
                S_pla_frame_req_1 <= 1'b0;
            end
        else if(S_pla_frame_para_fifo_rd_1)
            begin
                S_pla_frame_req_1 <= 1'b1;
            end
    end
    
always @ (posedge I_pla_312m5_clk)
    begin
        if(I_pla_rst)
            begin
                S_pla_frame_req_2 <= 1'b0;
            end
        else if(S_pla_frame_resp_2)
            begin
                S_pla_frame_req_2 <= 1'b0;
            end
        else if(S_pla_frame_para_fifo_rd_2)
            begin
                S_pla_frame_req_2 <= 1'b1;
            end
    end    
    

always @ (posedge I_pla_312m5_clk)
    begin
         S_pla_frame_para_fifo_empty_d1_0 <=  S_pla_frame_para_fifo_empty_0 ; 
         S_pla_frame_para_fifo_empty_d1_1 <=  S_pla_frame_para_fifo_empty_1 ;
         S_pla_frame_para_fifo_empty_d1_2 <=  S_pla_frame_para_fifo_empty_2 ;  
    end   



/*
generate
for(i=0;i<3;i=i+1)
begin:PARA_RD
    always @ (posedge I_pla_312m5_clk)
    begin
        if(I_pla_rst)
            begin
                S_pla_frame_para_fifo_rd[i] <= 1'b0;
            end
        else if(!S_pla_frame_para_fifo_empty_d1[i] && !S_pla_frame_req[i] && !S_pla_frame_para_fifo_rd[i] && S_frame_state_next == C_FRAME_IDLE)
            begin
                S_pla_frame_para_fifo_rd[i] <= 1'b1;
            end
        else
            begin
                S_pla_frame_para_fifo_rd[i] <= 1'b0;
            end
    end
    
    always @ (posedge I_pla_312m5_clk)
    begin
        if(I_pla_rst)
            begin
                S_pla_frame_req[i] <= 1'b0;
            end
        else if(S_pla_frame_resp[i])
            begin
                S_pla_frame_req[i] <= 1'b0;
            end
        else if(S_pla_frame_para_fifo_rd[i])
            begin
                S_pla_frame_req[i] <= 1'b1;
            end
    end
    
    always @ (posedge I_pla_312m5_clk)
    begin
         S_pla_frame_para_fifo_empty_d1[i] <=  S_pla_frame_para_fifo_empty[i] ;   
    end    
        
end
endgenerate
*/

always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_state_chang_flag <= 1'b0 ;
        end
    else if( S_frame_state != S_frame_state_next)
        begin
            S_state_chang_flag <= 1'b1 ;
        end
    else
        begin
            S_state_chang_flag <= 1'b0 ;            
        end
end

always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_pla_frame_start_0 <= 1'b0;
            S_pla_frame_start_1 <= 1'b0;            
            S_pla_frame_start_2 <= 1'b0;            
                        
            S_pla_frame_para  <= 36'd0;
            S_pla_frame_index_0 <= 1'b0;
            S_pla_frame_index_1 <= 1'b0;            
            S_pla_frame_index_2 <= 1'b0;            
        end
    else if(S_frame_state == C_FRAME_IDLE)
        begin
            if(S_pla_frame_req_0)
                begin
                    S_pla_frame_start_0 <= 1'b1;
                    S_pla_frame_para  <= {2'b00,S_pla_frame_para_fifo_rdata_0};
                    S_pla_frame_index_0 <= 1'b1;
                    S_pla_frame_index_1 <= 1'b0;
                    S_pla_frame_index_2 <= 1'b0;
                    
                end
            else if(S_pla_frame_req_1)
                begin
                    S_pla_frame_start_1 <= 1'b1;
                    S_pla_frame_para  <= {2'b01,S_pla_frame_para_fifo_rdata_1};
                    S_pla_frame_index_0 <= 1'b0;
                    S_pla_frame_index_1 <= 1'b1;
                    S_pla_frame_index_2 <= 1'b0;
                end
            else if(S_pla_frame_req_2)
                begin
                    S_pla_frame_start_2 <= 1'b1;
                    S_pla_frame_para  <= {2'b10,S_pla_frame_para_fifo_rdata_2};
                    S_pla_frame_index_0 <= 1'b0;
                    S_pla_frame_index_1 <= 1'b0;
                    S_pla_frame_index_2 <= 1'b1;
                end
        end
    else
        begin
            S_pla_frame_start_0 <= 1'b0;
            S_pla_frame_start_1 <= 1'b0;            
            S_pla_frame_start_2 <= 1'b0; 
            S_pla_frame_para    <= S_pla_frame_para;
            S_pla_frame_index_0 <= S_pla_frame_index_0;   
            S_pla_frame_index_1 <= S_pla_frame_index_1;   
            S_pla_frame_index_2 <= S_pla_frame_index_2; 
        end  
end

always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_pla_frame_resp_0 <= 1'b0;
        end
    else if(S_pla_frame_start_0)
        begin
            S_pla_frame_resp_0 <= S_pla_frame_index_0;
        end
    else
        begin
            S_pla_frame_resp_0 <= 1'b0;
        end
end

always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_pla_frame_resp_1 <= 1'b0;
        end
    else if(S_pla_frame_start_1)
        begin
            S_pla_frame_resp_1 <= S_pla_frame_index_1;
        end
    else
        begin
            S_pla_frame_resp_1 <= 1'b0;
        end
end


always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_pla_frame_resp_2 <= 1'b0;
        end
    else if(S_pla_frame_start_2)
        begin
            S_pla_frame_resp_2 <= S_pla_frame_index_2;
        end
    else
        begin
            S_pla_frame_resp_2 <= 1'b0;
        end
end



always @ (posedge I_pla_312m5_clk)
begin
    if((S_frame_state == C_FRAME_PRE)  )
        begin
            if(S_pla_frame_pre_cnt)
                begin
                    S_pla_frame_pre_cnt <= 1'b0;
                end
            else
                begin
                    S_pla_frame_pre_cnt <= 1'b1;
                end
        end
    else
        begin
            S_pla_frame_pre_cnt <= 1'b0;
        end
end

always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_frame_state      <= C_FRAME_IDLE;
            S_frame_state_buf1 <= C_FRAME_IDLE;
            S_frame_state_buf2 <= C_FRAME_IDLE;
        end
    else
        begin
            S_frame_state      <= S_frame_state_next;
            S_frame_state_buf1 <= S_frame_state;
            S_frame_state_buf2 <= S_frame_state_buf1;
        end
end


always @ (*)
begin
    case(S_frame_state)
        C_FRAME_IDLE    :  ///0
        begin
            if (S_frame_state_buf2 == C_FRAME_IDLE) 
             begin
                if(S_pla_frame_start_0 || S_pla_frame_start_1 || S_pla_frame_start_2)
                     begin
                         S_frame_state_next = C_FRAME_PRE;
                     end
                else
                     begin
                         S_frame_state_next = C_FRAME_IDLE;
                     end
             end
            else
                 begin
                        S_frame_state_next = C_FRAME_IDLE;
                 end                   
        end
        C_FRAME_PRE : ///1
        begin
            if(S_pla_frame_pre_cnt)
                begin
                    S_frame_state_next = C_FRAME_PLD;
                end
            else
                begin
                    S_frame_state_next = C_FRAME_PRE;
                end
        end
        C_FRAME_PLD : ///2
        begin
            if(S_pla_frame_sdpram_rd_end_buf1)
                begin
                    S_frame_state_next = C_FRAME_NOHCCRC;
                end
            else
                begin
                    S_frame_state_next = C_FRAME_PLD;
                end
        end
        C_FRAME_NOHCCRC : ///4
        begin
            S_frame_state_next = C_FRAME_IDLE;
        end
        default:
        begin
            S_frame_state_next = C_FRAME_IDLE;
        end
    endcase
end

always @ (posedge I_pla_312m5_clk)
begin
    if((S_frame_state == C_FRAME_IDLE) || (S_frame_state == C_FRAME_NOHCCRC))
        begin
            S_pla_frame_sdpram_rd_end <= 1'b0;
        end
    else if(S_pla_frame_sdpram_rd_end || S_pla_frame_sdpram_rd_end_buf1)
        begin
            S_pla_frame_sdpram_rd_end <= 1'b0;
        end
    else if(S_pla_frame_sdpram_raddr_b == S_pla_frame_end_addr)
        begin
            S_pla_frame_sdpram_rd_end <= 1'b1;
        end
    else
        begin
            S_pla_frame_sdpram_rd_end <= 1'b0;
        end
end

always @ (posedge I_pla_312m5_clk)
begin
    S_pla_frame_sdpram_rd_end_buf1 <= S_pla_frame_sdpram_rd_end;
end

assign S_pla_frame_start_addr   = S_pla_frame_para[23:12];
assign S_pla_frame_end_addr     = S_pla_frame_para[11:0];





//////change by gdp 
always @ (posedge I_pla_312m5_clk)
    begin
        if(I_pla_rst)
            begin
                S_pla_frame_sdpram_raddr_0 <= 12'd0 ;
                S_pla_frame_sdpram_raddr_1 <= 12'd0 ;
                S_pla_frame_sdpram_raddr_2 <= 12'd0 ;
                S_pla_frame_end_addr_0     <= 12'd0 ;
                S_pla_frame_end_addr_1     <= 12'd0 ;
                S_pla_frame_end_addr_2     <= 12'd0 ;
            end
       else
           begin
               case(S_frame_state)
                   C_FRAME_IDLE :
                       begin
                           if(S_pla_frame_index_0)
                               begin
                                   S_pla_frame_sdpram_raddr_0 <= S_pla_frame_start_addr ;
                                   S_pla_frame_end_addr_0     <= S_pla_frame_end_addr   ;                                                                      
                               end
                           else if(S_pla_frame_index_1)
                               begin
                                   S_pla_frame_sdpram_raddr_1 <= S_pla_frame_start_addr ;
                                   S_pla_frame_end_addr_1     <= S_pla_frame_end_addr   ;                                   
                               end 
                          else if(S_pla_frame_index_2)
                               begin
                                   S_pla_frame_sdpram_raddr_2 <= S_pla_frame_start_addr ;
                                   S_pla_frame_end_addr_2     <= S_pla_frame_end_addr   ;                                   
                               end                               
                       end
                  C_FRAME_PRE,C_FRAME_PLD:
                      begin
                            if(S_pla_frame_index_0)
                               begin
                                 if(S_pla_frame_sdpram_raddr_0 == S_pla_frame_end_addr_0)
                                       begin
                                          S_pla_frame_sdpram_raddr_0 <= S_pla_frame_start_addr ;                                
                                       end
                                  else
                                       begin
                                           S_pla_frame_sdpram_raddr_0 <= S_pla_frame_sdpram_raddr_0 + 12'd1;                                
                                       end    
                               end
                            else if(S_pla_frame_index_1)
                               begin
                                   if(S_pla_frame_sdpram_raddr_1 == S_pla_frame_end_addr_1)
                                       begin
                                          S_pla_frame_sdpram_raddr_1 <= S_pla_frame_start_addr ;                                
                                       end
                                   else
                                       begin
                                           S_pla_frame_sdpram_raddr_1 <= S_pla_frame_sdpram_raddr_1 + 12'd1;                                
                                       end    
                               end
                            else if(S_pla_frame_index_2)
                               begin
                                   if(S_pla_frame_sdpram_raddr_2 == S_pla_frame_end_addr_2)
                                       begin
                                          S_pla_frame_sdpram_raddr_2 <= S_pla_frame_start_addr ;                                
                                       end
                                   else
                                       begin
                                           S_pla_frame_sdpram_raddr_2 <= S_pla_frame_sdpram_raddr_2 + 12'd1;                                
                                       end    
                               end 
                      end                              
                   default:
                       begin
                           S_pla_frame_sdpram_raddr_0 <=   S_pla_frame_sdpram_raddr_0 ;
                           S_pla_frame_sdpram_raddr_1 <=   S_pla_frame_sdpram_raddr_1 ;
                           S_pla_frame_sdpram_raddr_2 <=   S_pla_frame_sdpram_raddr_2 ;
                           S_pla_frame_end_addr_0     <=   S_pla_frame_end_addr_0     ;
                           S_pla_frame_end_addr_1     <=   S_pla_frame_end_addr_1     ;
                           S_pla_frame_end_addr_2     <=   S_pla_frame_end_addr_2     ;                                                                              
                           
                       end
                 endcase                                       
           end                        
  end        


always @ (posedge I_pla_312m5_clk)
begin
    case(S_frame_state)
        C_FRAME_IDLE    :
        begin
            S_pla_frame_sdpram_raddr_b <= S_pla_frame_start_addr  ;
        end
        C_FRAME_PRE,C_FRAME_PLD:
        begin
            if(S_pla_frame_sdpram_raddr_b == S_pla_frame_end_addr)
                begin
                    S_pla_frame_sdpram_raddr_b <= S_pla_frame_sdpram_raddr_b;
                end
            else
                begin
                    S_pla_frame_sdpram_raddr_b <= S_pla_frame_sdpram_raddr_b + 12'd1;
                end
        end
        default:;
    endcase
end

always @ (posedge I_pla_312m5_clk)
begin
    case({S_pla_frame_index_2,S_pla_frame_index_1,S_pla_frame_index_0} )
        3'b001 :
        begin
            S_pla_frame_sdpram_rdata_b <= S_pla_frame_sdpram_rdata_0;
        end
        3'b010 :
        begin
            S_pla_frame_sdpram_rdata_b <= S_pla_frame_sdpram_rdata_1;
        end
        3'b100 :
        begin
            S_pla_frame_sdpram_rdata_b <= S_pla_frame_sdpram_rdata_2;        
        end
        default:
        begin
            S_pla_frame_sdpram_rdata_b <=32'd07070707;
        end
    endcase
end

always @ (posedge I_pla_312m5_clk)
begin
   S_pla_frame_sdpram_rdata_b_d1 <= S_pla_frame_sdpram_rdata_b ; 
end

always @ (posedge I_pla_312m5_clk)
begin
     if(I_pla_rst)
         begin
             S_ptp_flag <= 1'b0 ;
         end
     else
         begin
             S_ptp_flag        <= S_pla_frame_para[29] ;
         end
end



///S_crc_length_state <= {4'b0,S_2crc_div4equa2,S_2crc_div4equa0,S_3crc_div4equa2,S_3crc_div4equa0}
///{4'b0,S_2crc_div4equa2,S_2crc_div4equa0,S_3crc_div4equa2,S_3crc_div4equa0};
 

 assign S_reverse    = S_pla_frame_para[28];
 assign S_normal     = !S_pla_frame_para[28];

assign S_2crc_div4equa2 = S_pla_frame_para[27] ;
assign S_2crc_div4equa0 = S_pla_frame_para[26] ;
assign S_3crc_div4equa2 = S_pla_frame_para[25] ;
assign S_3crc_div4equa0 = S_pla_frame_para[24] ;
assign S_hc_flag        = S_pla_frame_para[30] ;
assign S_feedback_normal       = S_pla_frame_para[31]&& !S_pla_frame_para[28] ;
assign S_feedback_reverse      = S_pla_frame_para[31]&& S_pla_frame_para[28] ;

always @ (posedge I_pla_312m5_clk)
begin
    S_pla_frame_pre_cnt_d1 <= S_pla_frame_pre_cnt ;  
    
end

always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_pla_num <= 2'd0 ;
        end    
    else if(S_frame_state_buf1 == C_FRAME_PRE)
        begin
            if(S_pla_frame_index_0)
                begin
                    S_pla_num <= 2'd0 ;
                end
            else if(S_pla_frame_index_1)
                begin
                    S_pla_num <= 2'd1 ;                    
                end
            else if(S_pla_frame_index_2)
                begin
                    S_pla_num <= 2'd2 ;                    
                end
        end
    else
        begin
            S_pla_num <= S_pla_num ;
        end
    
end

always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_pla_frame_crc_data      <= 32'h07070707;
            S_pla_frame_crc_data_ctrl <= 4'hf ;

        end
    else
        begin
            case(S_frame_state_buf1)
                C_FRAME_PRE : //1
                    begin
                        if(S_pla_frame_pre_cnt_d1)
                            begin
                                S_pla_frame_crc_data      <= S_hc_flag ? 32'hfb5555d5:32'h555555d5;
                                S_pla_frame_crc_data_ctrl <= S_hc_flag ?4'h8:4'h0;
                            end
                        else
                            begin
                                S_pla_frame_crc_data      <= S_hc_flag ? 32'h07070707:32'hfb555555;
                                S_pla_frame_crc_data_ctrl <= S_hc_flag ? 4'hf:4'h8;
                            end
                    end                    
                C_FRAME_PLD://2
                    begin
                        if(S_normal)
                            begin
                                if(S_3crc_div4equa2 && !S_hc_flag)
                                    begin
                                        S_pla_frame_crc_data      <= (S_frame_state ==C_FRAME_NOHCCRC)? {S_pla_frame_sdpram_rdata_b_d1[31:8],8'hfd}:S_pla_frame_sdpram_rdata_b_d1;
                                        S_pla_frame_crc_data_ctrl <= (S_frame_state ==C_FRAME_NOHCCRC)? 4'h1:4'h0 ;                                        
                                    end 
                                else if(S_3crc_div4equa0 && S_hc_flag)
                                    begin
                                        S_pla_frame_crc_data      <= (S_frame_state ==C_FRAME_NOHCCRC)? {S_pla_frame_sdpram_rdata_b_d1[31:8],8'hfd}:S_pla_frame_sdpram_rdata_b_d1;
                                        S_pla_frame_crc_data_ctrl <= (S_frame_state ==C_FRAME_NOHCCRC)? 4'h1:4'h0 ;                                        
                                    end 
                                else if(S_2crc_div4equa2 && S_hc_flag)
                                    begin
                                        S_pla_frame_crc_data      <= (S_frame_state ==C_FRAME_NOHCCRC)? {S_pla_frame_sdpram_rdata_b_d1[31:16],16'hfd07}:S_pla_frame_sdpram_rdata_b_d1;
                                        S_pla_frame_crc_data_ctrl <= (S_frame_state ==C_FRAME_NOHCCRC)? 4'h3:4'h0 ;                                        
                                    end
                                else if(S_3crc_div4equa2 && S_hc_flag)
                                    begin
                                        S_pla_frame_crc_data      <= (S_frame_state ==C_FRAME_NOHCCRC)? {S_pla_frame_sdpram_rdata_b_d1[31:24],24'hfd0707}:S_pla_frame_sdpram_rdata_b_d1;
                                        S_pla_frame_crc_data_ctrl <= (S_frame_state ==C_FRAME_NOHCCRC)? 4'h7:4'h0 ;                                        
                                    end                                                                                                                                                                                                                                  
                                else
                                    begin
                                         S_pla_frame_crc_data      <= S_pla_frame_sdpram_rdata_b_d1;
                                         S_pla_frame_crc_data_ctrl <= 4'h0;
                                    end
                             end
                         else if(S_reverse)
                             begin
                                if(S_2crc_div4equa2 && S_hc_flag  )
                                    begin
                                        if(S_frame_state_next ==C_FRAME_NOHCCRC )  
                                            begin
                                                S_pla_frame_crc_data       <= {S_pla_frame_sdpram_rdata_b_d1[15:0],16'hfd07 }; 
                                                S_pla_frame_crc_data_ctrl  <= 4'h3;
                                            end   
                                        else if(S_frame_state == C_FRAME_NOHCCRC)
                                            begin
                                                S_pla_frame_crc_data       <= {32'h07070707}; 
                                                S_pla_frame_crc_data_ctrl  <= 4'hf;                                                
                                            end
                                        else
                                            begin
                                                S_pla_frame_crc_data       <= {S_pla_frame_sdpram_rdata_b_d1[15:0],S_pla_frame_sdpram_rdata_b[31:16]};
                                                S_pla_frame_crc_data_ctrl  <= 4'h0;                                                               
                                            end                  
                                    end                             
                                else if(S_2crc_div4equa2)
                                    begin
                                        S_pla_frame_crc_data      <= (S_frame_state ==C_FRAME_NOHCCRC)? {32'hfd070707}:{S_pla_frame_sdpram_rdata_b_d1[15:0],S_pla_frame_sdpram_rdata_b[31:16]};
                                        S_pla_frame_crc_data_ctrl <= (S_frame_state ==C_FRAME_NOHCCRC)? 4'hf:4'h0 ;                                                                                       
                                    end
                                else if(S_2crc_div4equa0 && S_hc_flag)
                                    begin
                                        S_pla_frame_crc_data      <= (S_frame_state ==C_FRAME_NOHCCRC)? {32'hfd070707}:{S_pla_frame_sdpram_rdata_b_d1[15:0],S_pla_frame_sdpram_rdata_b[31:16]};
                                        S_pla_frame_crc_data_ctrl <= (S_frame_state ==C_FRAME_NOHCCRC)? 4'hf:4'h0 ;                                             
                                    end
                                else if(S_2crc_div4equa0)
                                    begin
                                        S_pla_frame_crc_data      <= (S_frame_state ==C_FRAME_NOHCCRC)? {32'hfffffd07}:{S_pla_frame_sdpram_rdata_b_d1[15:0],S_pla_frame_sdpram_rdata_b[31:16]};
                                        S_pla_frame_crc_data_ctrl <= (S_frame_state ==C_FRAME_NOHCCRC)? 4'h3:4'h0 ;                                             
                                    end                                    
                                else if(S_3crc_div4equa0 && S_hc_flag)
                                    begin
                                        if(S_frame_state_next ==C_FRAME_NOHCCRC )  
                                            begin
                                                S_pla_frame_crc_data       <= {S_pla_frame_sdpram_rdata_b_d1[15:0],S_pla_frame_sdpram_rdata_b[31:24],8'hfd};
                                                S_pla_frame_crc_data_ctrl  <= 4'h1;
                                            end   
                                        else if(S_frame_state == C_FRAME_NOHCCRC)
                                            begin
                                                S_pla_frame_crc_data       <= {32'h07070707}; 
                                                S_pla_frame_crc_data_ctrl  <= 4'hf;                                                
                                            end
                                        else
                                            begin
                                                S_pla_frame_crc_data       <= {S_pla_frame_sdpram_rdata_b_d1[15:0],S_pla_frame_sdpram_rdata_b[31:16]};
                                                S_pla_frame_crc_data_ctrl  <= 4'h0;                                                               
                                            end                                          
                                    end 
                                else if(S_3crc_div4equa0)
                                    begin
                                        S_pla_frame_crc_data      <= (S_frame_state ==C_FRAME_NOHCCRC)? {32'hfffd0707}:{S_pla_frame_sdpram_rdata_b_d1[15:0],S_pla_frame_sdpram_rdata_b[31:16]};
                                        S_pla_frame_crc_data_ctrl <= (S_frame_state ==C_FRAME_NOHCCRC)? 4'h7:4'h0 ;                                             
                                    end 
                                    
                                else if(S_3crc_div4equa2 && S_hc_flag)
                                    begin
                                        if(S_frame_state_next ==C_FRAME_NOHCCRC )  
                                            begin
                                                S_pla_frame_crc_data       <= {S_pla_frame_sdpram_rdata_b_d1[15:8],8'hfd,16'h0707 }; 
                                                S_pla_frame_crc_data_ctrl  <= 4'h7;
                                            end                                    
                                        else if(S_frame_state == C_FRAME_NOHCCRC)
                                            begin
                                                S_pla_frame_crc_data       <= {32'h07070707}; 
                                                S_pla_frame_crc_data_ctrl  <= 4'hf;                                                
                                            end
                                        else
                                            begin
                                                S_pla_frame_crc_data       <= {S_pla_frame_sdpram_rdata_b_d1[15:0],S_pla_frame_sdpram_rdata_b[31:16]};
                                                S_pla_frame_crc_data_ctrl  <= 4'h0;                                                               
                                            end     
                                    end                                       
                                else if(S_3crc_div4equa2)
                                    begin
                                        if(S_frame_state_next ==C_FRAME_NOHCCRC )  
                                            begin
                                                S_pla_frame_crc_data       <= {S_pla_frame_sdpram_rdata_b_d1[15:0],8'hff,8'hfd }; 
                                                S_pla_frame_crc_data_ctrl  <= 4'h1;
                                            end                                    
                                        else if(S_frame_state == C_FRAME_NOHCCRC)
                                            begin
                                                S_pla_frame_crc_data       <= {32'h07070707}; 
                                                S_pla_frame_crc_data_ctrl  <= 4'hf;                                                
                                            end
                                        else
                                            begin
                                                S_pla_frame_crc_data       <= {S_pla_frame_sdpram_rdata_b_d1[15:0],S_pla_frame_sdpram_rdata_b[31:16]};
                                                S_pla_frame_crc_data_ctrl  <= 4'h0;                                                               
                                            end     
                                    end                                                                                 
                                else
                                    begin                             
                                        S_pla_frame_crc_data      <= {S_pla_frame_sdpram_rdata_b_d1[15:0],S_pla_frame_sdpram_rdata_b[31:16]};
                                        S_pla_frame_crc_data_ctrl <= 4'h0;                                 
                                    end
                           end
                    end                
                C_FRAME_NOHCCRC://4
                    begin
                        if(S_3crc_div4equa0 && S_hc_flag)
                            begin
                                S_pla_frame_crc_data      <= S_reverse?32'h07070707:32'h07070707 ; 
                                S_pla_frame_crc_data_ctrl <= S_reverse?4'hf:4'hF         ;
                            end
                       else if(S_3crc_div4equa0  )
                            begin
                                S_pla_frame_crc_data      <= S_reverse?32'h07070707:32'hFFFD0707 ; 
                                S_pla_frame_crc_data_ctrl <= S_reverse?4'hf:4'h7         ;
                            end                              
                        else if(S_2crc_div4equa0 && S_hc_flag )
                            begin
                                S_pla_frame_crc_data      <= S_reverse?32'h07070707:32'hfd070707 ; 
                                S_pla_frame_crc_data_ctrl <= S_reverse?4'hf:4'hf         ;
                            end 
                        else if(S_2crc_div4equa0)
                            begin
                                S_pla_frame_crc_data      <= S_reverse?32'h07070707:32'hFFFFFD07 ; 
                                S_pla_frame_crc_data_ctrl <= S_reverse?4'hf:4'h3         ;
                            end                             
                        else if(S_2crc_div4equa2 && S_hc_flag)
                            begin
                                S_pla_frame_crc_data      <=S_reverse?32'h07070707:32'h07070707 ; //搞定
                                S_pla_frame_crc_data_ctrl <=S_reverse?4'hf:4'hf         ; 
                            end                              
                        else if(S_2crc_div4equa2)
                            begin
                                S_pla_frame_crc_data      <=S_reverse?32'h07070707:32'hFD070707 ; //搞定
                                S_pla_frame_crc_data_ctrl <=S_reverse?4'hf:4'hf         ; 
                            end                         
                        else if(S_3crc_div4equa2)///搞定
                            begin
                                S_pla_frame_crc_data      <=32'h07070707 ; 
                                S_pla_frame_crc_data_ctrl <=4'hf         ; 
                            end                           
                    end                                  
                default:
                begin
                    S_pla_frame_crc_data      <= 32'h07070707;
                    S_pla_frame_crc_data_ctrl <= 4'hf;
                end
            endcase
        end
end






pla_backward_reframer_sdpram_32bit U0_pla_backward_reframer_sdpram(
.I_pla_312m5_clk               (I_pla_312m5_clk                ),
.I_pla_rst                     (I_pla_rst ||S_rst_pla_pla0     ),
.I_pla_slice_fifo_empty        (I_pla0_reflow_fifo_empty       ),
.I_pla_slice_fifo_rdata        (I_pla0_reflow_fifo_rdata       ),
.I_pla_frame_sdpram_rd         (S_pla_frame_sdpram_rd_0       ),
.I_pla_frame_sdpram_raddr      (S_pla_frame_sdpram_raddr_0    ),
.I_pla_frame_para_fifo_rd      (S_pla_frame_para_fifo_rd_0    ),
.I_pla_feedback_rd             (I_pla_feedback_rd_pla0         ) ,
.I_pause_from_back_hc          (I_pause_from_back_hc           ),
.I_pause_en                    (I_pause_en                     ),
.O_pla_fifo_full               (S_pla_fifo_full_pla0            ),
.O_pla_slice_fifo_rd           (O_pla0_reflow_fifo_rd          ),
.O_pla_frame_sdpram_rdata      (S_pla_frame_sdpram_rdata_0    ),
.O_pla_frame_para_fifo_rdata   (S_pla_frame_para_fifo_rdata_0 ),
.O_pla_frame_para_fifo_empty   (S_pla_frame_para_fifo_empty_0 ),
.O_fifo_full                   (S_fifo_full0                   ), 
.O_frame_dpram_alful           (S_frame_dpram_alful0           ),
.O_length_err                  (S_length_err0                  ),
.O_time_out_flag               (S_time_out_flag_pla0           ), 
.O_feedback_fifo_rdata         (O_feedback_fifo_rdata_pla0     ), 
.O_feedback_fifo_count         (O_feedback_fifo_count_pla0     ),
.O_feedback_fifo_full          (O_feedback_fifo_full_pla0      ),
.O_feedback_fifo_empty         (O_feedback_fifo_empty_pla0     ),
.O_feedback_flag_all           (S_feedback_flag_pla0           ),
.O_pla_slice_fifo_empty        (O_pla_slice_fifo_empty_pla0    ),
.O_pla0_back_55d5_flag         (S_pla0_back_55d5_flag          ),
.O_frame_fifo_wren             (O_frame_fifo_wren_pla0         ),

.O_pla_bac_reframer_input_data (S_pla0_pla_bac_reframer_input_data_catch ),
.O_pla_bac_reframer_input_en   (S_pla0_pla_bac_reframer_input_en_catch   ),
.O_time_out_flag_catch         (S_pla0_time_out_flag_catch               ),
.O_reframe_state_catch         (S_pla0_reframe_state_catch               ),
.O_length_err_catch            (S_pla0_length_err_catch                  ),
.O_rst_pla                     (S_rst_pla_pla0                           ),
.O_frame_dpram_usedw           (S_frame_dpram_usedw_back_pla0            )

);

pla_backward_reframer_sdpram_32bit U1_pla_backward_reframer_sdpram(
.I_pla_312m5_clk               (I_pla_312m5_clk                ),
.I_pla_rst                     (I_pla_rst||S_rst_pla_pla1      ),
.I_pla_slice_fifo_empty        (I_pla1_reflow_fifo_empty       ),
.I_pla_slice_fifo_rdata        (I_pla1_reflow_fifo_rdata       ),
.I_pla_frame_sdpram_rd         (S_pla_frame_sdpram_rd_1       ),
.I_pla_frame_sdpram_raddr      (S_pla_frame_sdpram_raddr_1    ),
.I_pla_frame_para_fifo_rd      (S_pla_frame_para_fifo_rd_1    ),
.I_pla_feedback_rd             (I_pla_feedback_rd_pla1         ) ,
.I_pause_from_back_hc          (I_pause_from_back_hc           ),
.I_pause_en                    (I_pause_en                     ),
.O_pla_fifo_full               (S_pla_fifo_full_pla1           ),
.O_pla_slice_fifo_rd           (O_pla1_reflow_fifo_rd          ),
.O_pla_frame_sdpram_rdata      (S_pla_frame_sdpram_rdata_1    ),
.O_pla_frame_para_fifo_rdata   (S_pla_frame_para_fifo_rdata_1 ),
.O_pla_frame_para_fifo_empty   (S_pla_frame_para_fifo_empty_1 ),
.O_fifo_full                   (S_fifo_full1                   ), 
.O_frame_dpram_alful           (S_frame_dpram_alful1           ),
.O_length_err                  (S_length_err1                  ),
.O_time_out_flag               (S_time_out_flag_pla1           ), 
.O_feedback_fifo_rdata         (O_feedback_fifo_rdata_pla1     ), 
.O_feedback_fifo_count         (O_feedback_fifo_count_pla1     ),
.O_feedback_fifo_full          (O_feedback_fifo_full_pla1      ),
.O_feedback_fifo_empty         (O_feedback_fifo_empty_pla1     ),
.O_feedback_flag_all           (S_feedback_flag_pla1                ),
.O_pla_slice_fifo_empty        (O_pla_slice_fifo_empty_pla1    ),
.O_pla0_back_55d5_flag         (S_pla1_back_55d5_flag          ),
.O_frame_fifo_wren             (O_frame_fifo_wren_pla1         ),
.O_rst_pla                     (S_rst_pla_pla1                 ),
.O_frame_dpram_usedw           (S_frame_dpram_usedw_back_pla1  )
);


pla_backward_reframer_sdpram_32bit U2_pla_backward_reframer_sdpram(
.I_pla_312m5_clk               (I_pla_312m5_clk                ),
.I_pla_rst                     (I_pla_rst|| S_rst_pla_pla2     ),
.I_pla_slice_fifo_empty        (I_pla2_reflow_fifo_empty       ),
.I_pla_slice_fifo_rdata        (I_pla2_reflow_fifo_rdata       ),
.I_pla_frame_sdpram_rd         (S_pla_frame_sdpram_rd_2       ),
.I_pla_frame_sdpram_raddr      (S_pla_frame_sdpram_raddr_2    ),
.I_pla_frame_para_fifo_rd      (S_pla_frame_para_fifo_rd_2    ),
.I_pla_feedback_rd             (I_pla_feedback_rd_pla2         ) ,
.I_pause_from_back_hc          (I_pause_from_back_hc           ),
.I_pause_en                    (I_pause_en                     ),
.O_pla_fifo_full               (S_pla_fifo_full_pla2           ),
.O_pla_slice_fifo_rd           (O_pla2_reflow_fifo_rd          ),
.O_pla_frame_sdpram_rdata      (S_pla_frame_sdpram_rdata_2    ),
.O_pla_frame_para_fifo_rdata   (S_pla_frame_para_fifo_rdata_2 ),
.O_pla_frame_para_fifo_empty   (S_pla_frame_para_fifo_empty_2 ),
.O_fifo_full                   (S_fifo_full2                   ), 
.O_frame_dpram_alful           (S_frame_dpram_alful2           ),
.O_length_err                  (S_length_err2                  ),
.O_time_out_flag               (S_time_out_flag_pla2           ), 
.O_feedback_fifo_rdata         (O_feedback_fifo_rdata_pla2     ), 
.O_feedback_fifo_count         (O_feedback_fifo_count_pla2     ),
.O_feedback_fifo_full          (O_feedback_fifo_full_pla2      ),
.O_feedback_fifo_empty         (O_feedback_fifo_empty_pla2     ),
.O_feedback_flag_all           (S_feedback_flag_pla2           ),
.O_pla_slice_fifo_empty        (O_pla_slice_fifo_empty_pla2    ),
.O_pla0_back_55d5_flag         (S_pla2_back_55d5_flag          ),
.O_frame_fifo_wren             (O_frame_fifo_wren_pla2         ),
.O_rst_pla                     (S_rst_pla_pla2                 ),
.O_frame_dpram_usedw           (S_frame_dpram_usedw_back_pla2  )

);
/*
/////////////////debug code //////////////////////////
(*mark_debug ="true"*)reg [32:0] I_pla0_reflow_fifo_rdata_debug     ;
(*mark_debug ="true"*)reg        O_pla0_reflow_fifo_rd_debug        ;
(*mark_debug ="true"*)reg [31:0] S_pla_frame_crc_data_debug         ;
(*mark_debug ="true"*)reg [3:0 ] S_pla_frame_crc_data_ctrl_debug    ;
(*mark_debug ="true"*)reg        S_crc_wrong_debug                  ;      
(*mark_debug ="true"*)reg        S_crc_ok_debug                     ;
(*mark_debug ="true"*)reg [31:0] O_pla_xgmii_rxd_debug              ;
(*mark_debug ="true"*)reg [3:0 ] O_pla_xgmii_rxc_debug              ;
(*mark_debug ="true"*)reg [1:0 ] O_pla_xgmii_pla_num_debug          ;
(*mark_debug ="true"*)reg        S_drop_flag_debug                  ;
(*mark_debug ="true"*)reg [2:0]  S_frame_state_debug                ;
(*mark_debug ="true"*)reg        S_pla_frame_start_debug            ;
(*mark_debug ="true"*)reg        S_pla_frame_req0_debug             ; 
(*mark_debug ="true"*)reg        S_pla_frame_para_fifo_empty_d1_debug ; 
(*mark_debug ="true"*)reg        S_pla_frame_para_fifo_rd_debug      ;


always @ (posedge I_pla_312m5_clk)
    begin
        I_pla0_reflow_fifo_rdata_debug        <= I_pla0_reflow_fifo_rdata ;
        O_pla0_reflow_fifo_rd_debug           <= O_pla0_reflow_fifo_rd    ;
        S_pla_frame_crc_data_debug            <= S_pla_frame_crc_data     ; 
        S_pla_frame_crc_data_ctrl_debug       <= S_pla_frame_crc_data_ctrl;
        S_crc_wrong_debug                     <= S_crc_wrong              ;
        S_crc_ok_debug                        <= S_crc_ok                 ;
        O_pla_xgmii_rxd_debug                 <= O_pla_xgmii_rxd          ;
        O_pla_xgmii_rxc_debug                 <= O_pla_xgmii_rxc          ;
        O_pla_xgmii_pla_num_debug             <= O_pla_xgmii_pla_num      ;
        S_drop_flag_debug                     <= S_drop_flag              ;
        S_frame_state_debug                   <= S_frame_state            ;
        S_pla_frame_start_debug               <= S_pla_frame_start_0      ;
        S_pla_frame_req0_debug                <= S_pla_frame_req_0       ;
        S_pla_frame_para_fifo_empty_d1_debug  <= S_pla_frame_para_fifo_empty_d1_0;
        S_pla_frame_para_fifo_rd_debug        <= S_pla_frame_para_fifo_rd_0 ;
    end


*/

always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_ptp_flag_d1 <= 1'b0 ;
            S_ptp_flag_d2 <= 1'b0 ;
            S_ptp_flag_d3 <= 1'b0 ;
            S_ptp_flag_d4 <= 1'b0 ;
            S_ptp_flag_d5 <= 1'b0 ;
            S_ptp_flag_d6 <= 1'b0 ;
            
        end
    else
        begin
            S_ptp_flag_d1 <= S_ptp_flag ;
            S_ptp_flag_d2 <= S_ptp_flag_d1 ;
            S_ptp_flag_d3 <= S_ptp_flag_d2 ;
            S_ptp_flag_d4 <= S_ptp_flag_d3 ;
            S_ptp_flag_d5 <= S_ptp_flag_d4 ;
            S_ptp_flag_d6 <= S_ptp_flag_d5 ;
            S_ptp_flag_d7 <= S_ptp_flag_d6 ;
        end    
end        


xgmii_crc_compare_h16bit  u1_xgmii_crc_compare_h16bit
(
 .I_global_rst    	     (I_pla_rst                  ),  
 .I_312m_clk	         (I_pla_312m5_clk            ),
 .I_xgmii_data           (S_pla_frame_crc_data       ),   
 .I_xgmii_txc            (S_pla_frame_crc_data_ctrl  ),
 .I_ptp_flag             (S_ptp_flag_d1              ), 
 .O_crc_err              (S_crc_wrong                ),
 .O_crc_ok               (S_crc_ok                   ),
 .O_crc_compare_signal   (),
 .O_crc_out              (S_crc_out                  )     

);

xgmii_frame_final_recover u2_xgmii_frame_final_recover
(
 .I_global_rst    	     (I_pla_rst                  ),  
 .I_312m_clk	           (I_pla_312m5_clk            ),
 .I_xgmii_data           (S_pla_frame_crc_data       ),   
 .I_xgmii_txc            (S_pla_frame_crc_data_ctrl  ),
 .I_xgmii_num            (S_pla_num                  ),
 .I_crc_err              (S_crc_wrong                ),
 .I_crc_ok               (S_crc_ok                   ),
 .I_crc_out              (S_crc_out                  ),
 .I_ptp_flag             (S_ptp_flag_d7                 ),
 .O_xgmii_data           (O_pla_xgmii_rxd            ),
 .O_xgmii_txc            (O_pla_xgmii_rxc            ),
 .O_xgmii_num            (O_pla_xgmii_pla_num        )
  
);


////test code 



always @ (posedge I_pla_312m5_clk)
    begin
        if((S_pla_frame_crc_data_ctrl == 4'h8)&& (S_pla_frame_crc_data[31:0]==32'hfb555555)   )
             begin
                 S_num_flag<= 1'b1 ;
             end
        else
             begin
                 S_num_flag<= 1'b0 ;                 
             end
    end

always @ (posedge I_pla_312m5_clk)
    begin
        S_num_flag_d1 <= S_num_flag ;
        S_num_flag_d2 <= S_num_flag_d1 ;
        S_num_flag_d3 <= S_num_flag_d2 ;
        S_num_flag_d4 <= S_num_flag_d3 ;        
        
        packet_num_d1 <= packet_num ;
    end
always @ (posedge I_pla_312m5_clk)
    begin
         if(S_num_flag_d3)
             begin
                 packet_num [7:0] <=  {S_pla_frame_crc_data[7:0] } ;
             end
         else
             begin
                 packet_num <= packet_num ;
             end
    end
always @ (posedge I_pla_312m5_clk)
    begin
        if(I_pla_rst)
            begin
                S_drop_flag <= 1'd0 ; 
            end
        else if(((packet_num-packet_num_d1)>8'd1 ) ) 
            begin
                S_drop_flag <= 1'b1 ;   
            end
        else
            begin
                S_drop_flag <= 1'b0 ;
            end
    end
    
////////////////test code end



always @ (posedge I_pla_312m5_clk)
    begin
        S_pla0_reflow_fifo_rd_d1 <= O_pla0_reflow_fifo_rd ;
        O_pla_rst_cnt <= S_pla_rst_cnt ;        
    end


always @ (posedge I_pla_312m5_clk)
    begin
        if(I_pause_from_back_hc)
            begin
                S_pla_pause_time_cnt <=S_pla_pause_time_cnt +8'd1 ;
            end
        else
            begin
                S_pla_pause_time_cnt <= S_pla_pause_time_cnt ;
            end
    end        

     
always @ (posedge I_pla_312m5_clk)
    begin
        if(S_pla_fifo_full_pla2 || S_pla_fifo_full_pla1 || S_pla_fifo_full_pla0 )
            begin
                S_fifo_full_time_cnt <=S_fifo_full_time_cnt +8'd1 ;
            end
        else
            begin
                S_fifo_full_time_cnt <= S_fifo_full_time_cnt ;
            end
    end

always @ (posedge I_pla_312m5_clk)
    begin
        O_err_tme_cnt <= {S_pla_pause_time_cnt,S_fifo_full_time_cnt};        
    end    
            
///////the next module is to local bus 
xgmii_frame_cnt pla_rst_cnt(
.I_312m_clk    (I_pla_312m5_clk           ),
.I_frame_en    (S_rst_pla_pla0|S_rst_pla_pla1 |S_rst_pla_pla2) ,
.I_cnt_clear   (I_cnt_clear               ),
.O_cnt_result  (S_pla_rst_cnt             )
);

 
xgmii_frame_cnt small_inter_cnt(
.I_312m_clk    (I_pla_312m5_clk           ),
.I_frame_en    (S_inter_small_flag        ) ,
.I_cnt_clear   (I_cnt_clear               ),
.O_cnt_result  (O_small_inter_cnt         )
);



xgmii_frame_cnt all_err_cnt(
.I_312m_clk    (I_pla_312m5_clk           ),
.I_frame_en    (S_crc_wrong|S_fifo_full0 |S_time_out_flag_pla0) ,
.I_cnt_clear   (I_cnt_clear               ),
.O_cnt_result  (O_all_err_cnt             )
);
xgmii_frame_cnt fifo_full_cnt
(
.I_312m_clk    (I_pla_312m5_clk           ),
.I_frame_en    (S_fifo_full0 ) ,
.I_cnt_clear   (I_cnt_clear               ),
.O_cnt_result  (O_fifo_full0_cnt           )                 
);

xgmii_frame_cnt fedback_cnt
(
.I_312m_clk    (I_pla_312m5_clk           ),
.I_frame_en    (S_feedback_flag_pla0||S_feedback_flag_pla1||S_feedback_flag_pla2           ) ,
.I_cnt_clear   (I_cnt_clear               ),
.O_cnt_result  (O_feedback_cnt            )                 
);

xgmii_frame_cnt drop_flag_cnt
(
.I_312m_clk    (I_pla_312m5_clk           ),
.I_frame_en    (S_drop_flag  ) ,
.I_cnt_clear   (I_cnt_clear               ),
.O_cnt_result  (O_drop_flag_cnt           )                 
);

xgmii_frame_cnt ram_full_cnt
(
.I_312m_clk    (I_pla_312m5_clk           ),
.I_frame_en    (S_frame_dpram_alful0|| S_frame_dpram_alful1||S_frame_dpram_alful2      ) ,
.I_cnt_clear   (I_cnt_clear               ),
.O_cnt_result  (O_ram_full0_cnt           )                 
);

xgmii_frame_cnt length_err_cnt
(
.I_312m_clk    (I_pla_312m5_clk           ),
.I_frame_en    (S_length_err0 ||S_length_err1||S_length_err2             ) ,
.I_cnt_clear   (I_cnt_clear               ),
.O_cnt_result  (O_length_err0_cnt          )                 
);


xgmii_frame_cnt reframe_crc_ok_cnt(
.I_312m_clk    (I_pla_312m5_clk           ),
.I_frame_en    (S_crc_ok                  ),
.I_cnt_clear   (I_cnt_clear               ),
.O_cnt_result  (O_reframe_crcok_cnt       )
);

xgmii_frame_cnt reframe_crc_err_cnt(
.I_312m_clk    (I_pla_312m5_clk            ),
.I_frame_en    (S_crc_wrong                ),
.I_cnt_clear   (I_cnt_clear                ),
.O_cnt_result  (O_reframe_crcerr_cnt       )
);

xgmii_frame_cnt reframe_state_cnt(
.I_312m_clk    (I_pla_312m5_clk            ),
.I_frame_en    (S_state_chang_flag                ),
.I_cnt_clear   (I_cnt_clear                ),
.O_cnt_result  (O_reframe_state_change_cnt       )
);

xgmii_frame_cnt slice_cnt(
.I_312m_clk    (I_pla_312m5_clk              ),
.I_frame_en    (!O_pla0_reflow_fifo_rd&& S_pla0_reflow_fifo_rd_d1        ),
.I_cnt_clear   (I_cnt_clear                  ),
.O_cnt_result  (O_slice_cnt                  )
);

xgmii_frame_cnt reframer_pla0_back55d5_cnt(
.I_312m_clk    (I_pla_312m5_clk            ),
.I_frame_en    (S_pla0_back_55d5_flag ||S_pla1_back_55d5_flag||S_pla2_back_55d5_flag     ),
.I_cnt_clear   (I_cnt_clear                ),
.O_cnt_result  (O_reframe_pla0_55d5_cnt    )
);

xgmii_frame_cnt reframer_pla0_wrfifo_cnt(
.I_312m_clk    (I_pla_312m5_clk               ),
.I_frame_en    (O_frame_fifo_wren_pla0 || O_frame_fifo_wren_pla1||O_frame_fifo_wren_pla2        ),
.I_cnt_clear   (I_cnt_clear                   ),
.O_cnt_result  (O_pla0_reframe_fifo_wr_cnt    )
);


endmodule
