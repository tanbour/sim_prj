module pla_backward_reframer_sdpram_32bit

( 

input                     I_pla_312m5_clk                ,   
input                     I_pla_rst                      ,
input                     I_pla_slice_fifo_empty         ,
input    [32:0]           I_pla_slice_fifo_rdata         ,
input    [11:0]           I_pla_frame_sdpram_raddr       ,
input                     I_pla_frame_para_fifo_rd       ,
input                     I_pla_frame_sdpram_rd          ,
input                     I_pla_feedback_rd              ,
input                     I_pause_from_back_hc           ,
input                     I_pause_en                     ,
output   reg              O_pla_fifo_full=1'b0           ,

output                    O_pla_slice_fifo_rd            ,
output   [31:0]           O_pla_frame_sdpram_rdata       ,
output   [33:0]           O_pla_frame_para_fifo_rdata    ,
output                    O_pla_frame_para_fifo_empty    ,
output   reg              O_fifo_full                    ,
output   reg              O_frame_dpram_alful            ,
output   reg              O_length_err                   ,
output   reg              O_time_out_flag                ,
output   reg   [31:0]     O_feedback_fifo_rdata          ,
output   reg   [5:0 ]     O_feedback_fifo_count          ,
output   reg              O_feedback_fifo_full           ,
output   reg              O_feedback_fifo_empty          ,
output   reg              O_feedback_flag_all            ,
output   reg              O_pla_slice_fifo_empty         ,
output   reg              O_pla0_back_55d5_flag          ,
output   reg              O_frame_fifo_wren              ,
/////catch code 
output   reg   [31:0]     O_pla_bac_reframer_input_data  ,
output   reg              O_pla_bac_reframer_input_en    ,
output   reg              O_time_out_flag_catch          ,
output   reg   [3:0 ]     O_reframe_state_catch          ,
output   reg              O_length_err_catch             ,
output   reg              O_rst_pla                      ,
output   reg   [15:0]     O_frame_dpram_usedw            

     
       
);


reg  [32:0]         S_fifo_rdata                        ;
reg  [32:0]         S_fifo_rdata_d1                     ;
reg                 S_fifo_rdata_en                     ;
reg                 S_fifo_rdata_en_d1                  ;
reg                 S_fifo_data_en                      ;
reg                 S_fifo_data_en_d1                   ;
reg                 S_fifo_data_en_d2                   ;
reg                 S_pla_slice_fifo_rd                 ;
reg  [12:0]         S_length                            ;
reg  [12:0]         S_length_reverse                    ;
reg                 S_length_too_long_err ;
reg                 S_length_too_short_err;
reg                 S_length_err                        ;
reg  [12:0]         S_frame_length_cnt                  ;


reg  [31:0]         S_frame_dpram_wdata                 ;
reg                 S_frame_dpram_wren                  ; 
reg  [11:0]         S_frame_dpram_waddr                 ;


reg  [33:0]         S_frame_fifo_wdata                  ;
reg                 S_frame_fifo_wren                   ;
reg  [12:0]         S_frame_dpram_usedw                 ;
reg                 S_frame_dpram_alful                 ;


reg  [3:0]          S_reframe_state                     ;
reg  [3:0]          S_reframe_state_buf                 ;
reg  [3:0]          S_reframe_state_buf1                ;
reg  [3:0]          S_reframe_state_next                ;
reg  [3:0]          S_reframe_state_d1                  ;

reg                 S_2crc_div4equa0                    ;
reg                 S_2crc_div4equa2                    ;
reg                 S_3crc_div4equa0                    ;
reg                 S_3crc_div4equa2                    ;
reg [11:0]          S_frame_dpram_waddr_temp            ;
//wire                S_slice_head_flag                   ;
//wire                S_slice_head_flag_1                 ;
reg [7:0 ]          S_crc_length_state                  ;
reg [7:0 ]          S_crc_length_state_d1               ;
reg [7:0 ]          S_crc_length_state_d2               ;
//reg                 S_slice_head_flag_reverse           ;
wire                S_fifo_full                         ;
reg                 S_ptp_flag                          ;
reg                 S_hc_flag                           ;
reg                 S_flag1                             ;
reg                 S_flag2                             ;
reg                 S_flag2_d1                          ;
reg                 S_flag3                             ;
reg                 S_flag3_d1                          ;
reg                 S_flag4_temp                        ;
wire                S_flag4                             ;
reg                 S_flag4_d1                          ;
reg                 S_feedback_flag                     ;
reg                 S_feedback_flag_d1                  ;
reg                 S_feedback_flag_reverse             ;
reg                 S_feedback_flag_reverse_d1          ;
reg                 S_feedback_flag_reverse_d2          ;
reg                 S_time_out_flag                     ;
reg [31:0]          S_protect_cnt                       ;   
reg [11:0]          S_frame_dpram_waddr_d1              ;

reg [31:0 ]         S_feedback_wdata                    ;       
reg                 S_feedback_wren                     ;       
                                                           
wire[33:0 ]         S_feedback_fifo_rdata               ;   
wire                S_feedback_fifo_full                ;   
wire                S_feedback_fifo_empty               ;   
wire[5:0 ]          S_feedback_fifo_count               ;   
reg [32:0]          S_pla_slice_fifo_rdata              ;
reg                 S_feedback_last_flag                ;

reg                 S_hc_flag_lock                      ;        
reg                 S_ptp_flag_lock                     ;        
reg [3:0]           S_crc_length_state_lock             ;
reg                 S_reverse_head_flag                 ;

reg                 S_reverse_head_flag_d1              ;
reg                 S_reverse_head_flag_temp            ;
reg                 S_flag5                             ;
reg                 S_flag5_temp                        ;
wire                S_flag6                             ;

wire                S_reverse_head_1                    ;
wire                S_reverse_head_2                    ;
wire                S_reverse_head_3                    ;
reg                 S_reverse_head_4_temp               ;
wire                S_reverse_head_4                    ;
wire                S_reverse_head_5                    ;
wire                S_reverse_head_6                    ;
wire                S_normal_length_flag1               ;
wire                S_normal_length_flag2               ;               

reg                 S_rst_pla    =1'b0                  ;
reg                 S_rst_pla_d1 =1'b0                  ;
reg                 S_rst_pla_d2 =1'b0                  ;
reg                 S_rst_pla_d3 =1'b0                  ;
reg   [9:0]         S_rst_cnt                           ; 
wire  [9:0]         S_pla_reframe_usdw                  ; 
reg   [9:0]         S_pla_reframe_usdw_d1               ;


parameter   C_REFRAME_IDLE         =  4'b0000           ,
            C_REFRAME_NORMAL       =  4'b0001           ,///55d5 in high
            C_REFRAME_REVERSE      =  4'b0010           ,///55d5 in low			
            C_REFRAME_NORMAL_LAST  =  4'b0011           ,///55d5 in high_last
		    C_REFRAME_REVERSE_LAST =  4'b0100           ;///55d5 inlow_last
parameter   C_NULL_16              = 16'heeee           ;   	  
/*

(* mark_debug = "true" *) reg  [33:0] S_feedback_wdata_debug ; 
(* mark_debug = "true" *) reg         S_feedback_wren_debug  ;
(* mark_debug = "true" *) reg         S_pla_feedback_rd_debug;
(* mark_debug = "true" *) reg  [33:0] S_feedback_fifo_rdata_debug ;
(* mark_debug = "true" *) reg         S_feedback_fifo_full_debug ;
(* mark_debug = "true" *) reg         S_feedback_fifo_empty_debug ;
(* mark_debug = "true" *) reg  [5:0]  S_feedback_fifo_count_debug ;


always @ (posedge I_pla_312m5_clk)
begin
    
 S_feedback_wdata_debug            <= S_feedback_wdata        ;   
 S_feedback_wren_debug             <= S_feedback_wren         ;
 S_pla_feedback_rd_debug          <= I_pla_feedback_rd        ;
 S_feedback_fifo_rdata_debug      <= S_feedback_fifo_rdata    ;
 S_feedback_fifo_full_debug       <= S_feedback_fifo_full     ;
 S_feedback_fifo_empty_debug      <= S_feedback_fifo_empty    ;
 S_feedback_fifo_count_debug      <= S_feedback_fifo_count    ;

end
*/
//
//always @ (posedge I_pla_312m5_clk)
//    begin
//        if(I_pla_rst)
//            begin
//                S_pla_slice_fifo_rdata <= 33'd0 ;
//                S_fifo_rdata           <= 33'd0 ;
//                S_fifo_rdata_d1        <= 33'd0 ;
//            end
//        else
//            begin
//                S_pla_slice_fifo_rdata <=  I_pla_slice_fifo_rdata ;                
//                S_fifo_rdata           <=  S_pla_slice_fifo_rdata ;
//                S_fifo_rdata_d1        <=  S_fifo_rdata           ;
//            end
//    end

always @ (posedge I_pla_312m5_clk)
    begin
        S_pla_reframe_usdw_d1 <= S_pla_reframe_usdw ;
    end

always @ (posedge I_pla_312m5_clk)
    begin
        if(S_pla_reframe_usdw_d1 >=10'd900 )
            begin
                O_pla_fifo_full<= 1'b1 ;
            end
        else
            begin
                O_pla_fifo_full<= 1'b0 ;                
            end
    end  
    
    

always @ (posedge I_pla_312m5_clk)
    begin
        if(I_pla_rst)
            begin
                S_rst_cnt <= 10'd0 ;
            end
        else if(O_fifo_full)
            begin
                S_rst_cnt <=S_rst_cnt+10'd1 ;
            end
        else
            begin
                S_rst_cnt <= 10'd0 ;
            end
    end                             

always @ (posedge I_pla_312m5_clk)
    begin
       if(S_rst_pla)
           begin
                S_rst_pla<= 1'b0 ;                 
           end 
       else if(S_rst_cnt ==10'd1021 )
            begin
                S_rst_pla<= 1'b1 ;
            end
        else
            begin
                S_rst_pla<= 1'b0 ;                
            end
    end  
    
always @ (posedge I_pla_312m5_clk)
begin
    S_rst_pla_d1 <= S_rst_pla     ;
    S_rst_pla_d2 <= S_rst_pla_d1  ;
    S_rst_pla_d3 <= S_rst_pla_d2  ;
end
    
    
        
 always @ (posedge I_pla_312m5_clk)
     begin
         O_rst_pla<=S_rst_pla|S_rst_pla_d1|S_rst_pla_d2|S_rst_pla_d3 ; 
     end   
    


always @ (posedge I_pla_312m5_clk)
    begin
        O_pla_bac_reframer_input_data  <= S_fifo_rdata[31:0]    ;
        O_pla_bac_reframer_input_en    <= S_fifo_data_en        ;
        O_time_out_flag_catch          <= S_time_out_flag       ;
        O_reframe_state_catch          <= S_reframe_state       ;
        O_length_err_catch             <= S_length_err          ;
         
    end
               
always @ (posedge I_pla_312m5_clk)
    begin
        if(I_pla_rst)
            begin
                S_pla_slice_fifo_rdata <= 33'd0 ;
            end
        else if (S_fifo_rdata_en)
            begin
                S_pla_slice_fifo_rdata <=  I_pla_slice_fifo_rdata ;                
            end
        else
            begin
                S_pla_slice_fifo_rdata <= 33'd0 ;
            end
    end


always @ (posedge I_pla_312m5_clk)
    begin
        if(I_pla_rst)
            begin
                S_fifo_rdata           <= 33'd0 ;
                S_fifo_rdata_d1        <= 33'd0 ;
            end
        else
            begin              
                S_fifo_rdata           <=  S_pla_slice_fifo_rdata ;
                S_fifo_rdata_d1        <=  S_fifo_rdata           ;
            end
    end



always @ (posedge I_pla_312m5_clk)
    begin
        O_frame_dpram_alful <= S_frame_dpram_alful ; 
        O_fifo_full         <= S_fifo_full         ;
        O_length_err        <= S_length_err        ;
    end
        
always @(posedge I_pla_312m5_clk )
    begin
        O_time_out_flag          <= S_time_out_flag ;
        O_pla_slice_fifo_empty   <= I_pla_slice_fifo_empty ;
    end
///S_fifo_rdata_en_d1 is same to S_fifo_rdata  

always @ (posedge I_pla_312m5_clk)
    begin
        S_fifo_rdata_en        <= S_pla_slice_fifo_rd&& !I_pla_slice_fifo_empty    ;
        S_fifo_rdata_en_d1     <= S_fifo_rdata_en        ;
        S_fifo_data_en         <= S_fifo_rdata_en_d1     ;
        S_fifo_data_en_d1      <= S_fifo_data_en         ;
        S_fifo_data_en_d2      <= S_fifo_data_en_d1      ;
    end


always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_frame_dpram_alful <= 1'b0;
        end
    else if(S_frame_dpram_usedw > 13'd4090)               ///����ʱ��Ҫ�����ݣ���ֹdpram��
        begin
            S_frame_dpram_alful <= 1'b1;
        end
    else
        begin
            S_frame_dpram_alful <= 1'b0;
        end
end

always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_frame_dpram_usedw <= 13'd0;
        end
    else if(S_frame_dpram_waddr >= I_pla_frame_sdpram_raddr)
        begin
            S_frame_dpram_usedw <= {1'b0,S_frame_dpram_waddr} - {1'b0,I_pla_frame_sdpram_raddr};
        end
    else
        begin
            S_frame_dpram_usedw <= {1'b1,S_frame_dpram_waddr} - {1'b0,I_pla_frame_sdpram_raddr};
        end
end



always @ (posedge I_pla_312m5_clk)
begin
    O_frame_dpram_usedw <= {I_pause_from_back_hc,2'd0,S_frame_dpram_usedw };
end
		    	  
always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_pla_slice_fifo_rd <= 1'b0;            
        end
    else if(I_pause_en &&  (I_pause_from_back_hc || (S_pla_reframe_usdw_d1>= 10'd900 ) && !S_pla_slice_fifo_rd ))
        begin
            S_pla_slice_fifo_rd <= 1'b0;
        end        
    else if(I_pla_slice_fifo_empty    )
        begin
            S_pla_slice_fifo_rd <= 1'b0;
        end
    else 
        begin
            S_pla_slice_fifo_rd <= 1'b1;
        end
end		    	  


////protect





always @ (posedge I_pla_312m5_clk)
    begin
        if(I_pla_rst)
            begin
                S_length_err <= 1'b0 ; 
            end                                               
        else if(S_normal_length_flag1 )
            begin
               S_length_err  <= (S_fifo_rdata[12:0]>13'd4800 ||S_fifo_rdata[12:0]<13'd10)?1'b1:1'b0 ;
            end
        else if(S_normal_length_flag2 )
            begin
               S_length_err  <= (S_fifo_rdata[12:0]>13'd4800 ||S_fifo_rdata[12:0]<13'd10)?1'b1:1'b0 ;
            end
        else if(S_reverse_head_4 || S_reverse_head_5)
            begin
                S_length_err      <= (S_pla_slice_fifo_rdata[28:16]>13'd4800 || S_pla_slice_fifo_rdata[28:16]<13'd10)?1'b1:1'b0  ;             
            end
        else if (S_reverse_head_1)
            begin
                S_length_err      <= (S_pla_slice_fifo_rdata[28:16]>13'd4800 || S_pla_slice_fifo_rdata[28:16]<13'd10)?1'b1:1'b0  ;               
            end
        else if (S_reverse_head_2 )
            begin
                S_length_err      <= (S_pla_slice_fifo_rdata[28:16]>13'd4800 || S_pla_slice_fifo_rdata[28:16]<13'd10)?1'b1:1'b0  ;               
            end
        else if (S_reverse_head_3)
            begin
                S_length_err      <= (S_pla_slice_fifo_rdata[28:16]>13'd4800 || S_pla_slice_fifo_rdata[28:16]<13'd10)?1'b1:1'b0  ;             
            end                    
        else
            begin
               S_length_err <= 1'b0 ;            
            end
    end


 

always @ (posedge I_pla_312m5_clk)
    begin
        S_reframe_state_d1 <= S_reframe_state ;
    end

assign S_normal_length_flag1 = ((S_reframe_state == C_REFRAME_REVERSE_LAST)&& (S_reframe_state_d1 == C_REFRAME_REVERSE)&& (S_fifo_rdata[31:16]== 16'h55d5)&& S_fifo_data_en&& (!(S_3crc_div4equa0|| S_2crc_div4equa0)) );
assign S_normal_length_flag2 = ((S_reframe_state == C_REFRAME_IDLE)&& (S_fifo_rdata[31:16]== 16'h55d5)&& S_fifo_data_en && !( (S_flag6)||(  S_flag3 && (S_3crc_div4equa0|| S_2crc_div4equa0) )  )                      ) ;    

always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_length      <= 13'd0                         ;
        end
    else if(S_length > 13'd4800)
        begin
		   S_length <= 13'd128                                                   ;
        end				
    else if (S_normal_length_flag1)
        begin
           S_length  <= S_fifo_rdata[12:0];
        end
    else if(S_normal_length_flag2)
        begin
           S_length  <= S_fifo_rdata[12:0];
        end
    else
        begin
           S_length <= S_length ;            
        end
end




always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_reverse_head_flag <= 1'b0 ;
        end 
    else if( (S_pla_slice_fifo_rdata[15:0] == 16'h55d5)&& S_fifo_rdata_en_d1 )
        begin
            S_reverse_head_flag <= 1'b1 ;            
        end
    else
        begin
            S_reverse_head_flag <= 1'b0 ;              
        end
end


always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_feedback_flag      <= 1'd0                         ;
        end                                                
    else if(S_normal_length_flag1 )
        begin
           S_feedback_flag  <= (S_fifo_rdata[12:0]==13'd1)?1'b1 : 1'b0  ;
        end
    else if(S_normal_length_flag2)
        begin
           S_feedback_flag  <= (S_fifo_rdata[12:0]==13'd1)?1'b1 : 1'b0  ;
        end
    else
        begin
           S_feedback_flag <= 1'b0 ;            
        end
end


always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_feedback_flag_reverse      <= 1'd0                                       ;            
        end 
    else if(S_fifo_rdata_en && S_feedback_flag_reverse )
        begin
            S_feedback_flag_reverse      <= 1'b0                            ;              
        end           
    else if(S_reverse_head_4 || S_reverse_head_5)
        begin
            S_feedback_flag_reverse      <= (S_pla_slice_fifo_rdata[28:16]==13'd1)?1'b1:1'b0      ;             
        end
    else if (S_reverse_head_1 )
        begin
            S_feedback_flag_reverse      <= (S_pla_slice_fifo_rdata[28:16]==13'd1)?1'b1:1'b0      ;                
        end
    else if (S_reverse_head_2)
        begin
            S_feedback_flag_reverse      <= (S_pla_slice_fifo_rdata[28:16]==13'd1)?1'b1:1'b0      ;               
        end
    else if (S_reverse_head_3)
        begin
            S_feedback_flag_reverse      <= (S_pla_slice_fifo_rdata[28:16]==13'd1)?1'b1:1'b0      ;               
        end 
    else 
        begin
            S_feedback_flag_reverse <= S_feedback_flag_reverse ; 
        end 
               
end




always @ (posedge I_pla_312m5_clk)
begin
    O_feedback_flag_all <= S_feedback_flag || S_feedback_flag_reverse ;
end
////reverse pla  bu ding////
 





 
assign S_reverse_head_1      =((S_reframe_state == C_REFRAME_IDLE)&& S_reverse_head_flag && S_fifo_rdata_en_d1 && (  (!(S_2crc_div4equa0||S_3crc_div4equa0))||S_feedback_flag_reverse_d1 )  );


assign S_reverse_head_2      =((S_reframe_state == C_REFRAME_REVERSE_LAST) && S_reverse_head_flag && S_fifo_rdata_en_d1&& (S_3crc_div4equa0|| S_2crc_div4equa0) );
assign S_reverse_head_3      =((S_reframe_state == C_REFRAME_NORMAL_LAST) &&  S_reverse_head_flag && S_fifo_rdata_en_d1 && !(S_2crc_div4equa0||S_3crc_div4equa0) );
assign S_reverse_head_4      = (S_reverse_head_4_temp && S_fifo_rdata_en_d1 ) || S_reverse_head_6;                                              

assign S_reverse_head_5      = ((   (S_fifo_data_en && S_flag6 && (S_3crc_div4equa2||S_2crc_div4equa2)) ||(S_fifo_data_en && S_flag3 && (S_3crc_div4equa0||S_2crc_div4equa0) )   ) && S_reverse_head_flag );

/////feedbak
assign S_reverse_head_6      = (S_reframe_state == C_REFRAME_REVERSE )&& S_fifo_rdata_en_d1 && !S_fifo_data_en && S_feedback_flag_reverse_d1 ;

always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_reverse_head_4_temp <= 1'b0 ;
        end    
    else if((S_reframe_state == C_REFRAME_REVERSE_LAST || S_reframe_state == C_REFRAME_NORMAL_LAST )&& (S_reframe_state_next== 4'd2) && (S_fifo_data_en && !S_fifo_rdata_en_d1))
        begin
            S_reverse_head_4_temp <= 1'b1 ;            
        end
    else if(S_fifo_rdata_en_d1)
        begin
            S_reverse_head_4_temp <= 1'b0 ;              
        end
    
end

          
always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_length_reverse      <= 13'd0                                              ;            
        end
    else if(S_length_reverse > 13'd4800)
        begin
		   S_length_reverse <= 13'd128                                                   ;
        end				
    else if (  S_reverse_head_4 || S_reverse_head_5)
        begin
            S_length_reverse      <= S_pla_slice_fifo_rdata[28:16]                       ;             
        end
    else if (S_reverse_head_1)
        begin
            S_length_reverse      <= S_pla_slice_fifo_rdata[28:16]                         ;               
        end
    else if (S_reverse_head_2)
        begin
            S_length_reverse      <= S_pla_slice_fifo_rdata[28:16]                         ;               
        end
    else if (S_reverse_head_3 )
        begin
            S_length_reverse      <= S_pla_slice_fifo_rdata[28:16]                         ;               
        end 
    else
        begin
            S_length_reverse      <= S_length_reverse                            ;              
        end
               
end


always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_2crc_div4equa0    <=  1'b0  ;            
        end    
    else if(S_normal_length_flag1 )
        begin
           S_2crc_div4equa0 <= (!S_fifo_rdata[14]&&  (S_fifo_rdata[0]==1'b1) );
        end
    else if(S_normal_length_flag2)
        begin
           S_2crc_div4equa0 <= (!S_fifo_rdata[14]&&  (S_fifo_rdata[0]==1'b1) );
        end
    else if(S_reverse_head_4 || S_reverse_head_5)
        begin
           S_2crc_div4equa0 <= (!S_pla_slice_fifo_rdata[30]&&  (S_pla_slice_fifo_rdata[16]==1'b1) );            
        end        
    else if (S_reverse_head_1)
        begin
           S_2crc_div4equa0 <= (!S_pla_slice_fifo_rdata[30]&&  (S_pla_slice_fifo_rdata[16]==1'b1) );
        end
    else if(S_reverse_head_2)
        begin
           S_2crc_div4equa0 <= (!S_pla_slice_fifo_rdata[30]&&  (S_pla_slice_fifo_rdata[16]==1'b1) );            
        end
    else if (S_reverse_head_3)
        begin
           S_2crc_div4equa0 <= (!S_pla_slice_fifo_rdata[30]&&  (S_pla_slice_fifo_rdata[16]==1'b1) );             
        end        
    else 
        begin
           S_2crc_div4equa0 <= S_2crc_div4equa0 ;    
        end
end

always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_2crc_div4equa2    <=  1'b0  ;            
        end    
    else if(S_normal_length_flag1 )
        begin
           S_2crc_div4equa2 <= (!S_fifo_rdata[14]&&  (S_fifo_rdata[0]==1'b0) );
        end
    else if(S_normal_length_flag2)
        begin
           S_2crc_div4equa2 <= (!S_fifo_rdata[14]&&  (S_fifo_rdata[0]==1'b0) );
        end        
    else if(S_reverse_head_4 || S_reverse_head_5)
        begin
           S_2crc_div4equa2 <= (!S_pla_slice_fifo_rdata[30]&&  (S_pla_slice_fifo_rdata[16]==1'b0) );            
        end                        
   else if(S_reverse_head_1 )
        begin
           S_2crc_div4equa2 <= (!S_pla_slice_fifo_rdata[30]&&  (S_pla_slice_fifo_rdata[16]==1'b0) );
        end 
    else if(S_reverse_head_2 )
        begin
           S_2crc_div4equa2 <= (!S_pla_slice_fifo_rdata[30]&&  (S_pla_slice_fifo_rdata[16]==1'b0) );
        end  
    else if (S_reverse_head_3 )
        begin
           S_2crc_div4equa2 <= (!S_pla_slice_fifo_rdata[30]&&  (S_pla_slice_fifo_rdata[16]==1'b0) );
        end  
                          
    else 
        begin
           S_2crc_div4equa2 <= S_2crc_div4equa2 ;    
        end
end
/////


always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_ptp_flag <= 1'b0 ;
        end
    else if(S_normal_length_flag1 )
        begin
           S_ptp_flag <=  S_fifo_rdata[13];
        end
    else if(S_normal_length_flag2)
        begin
           S_ptp_flag <=  S_fifo_rdata[13];
        end
    else if(S_reverse_head_4 || S_reverse_head_5)
        begin
          S_ptp_flag <=S_pla_slice_fifo_rdata[29];            
        end                            
   else if (S_reverse_head_1)
       begin
          S_ptp_flag <=S_pla_slice_fifo_rdata[29];  
       end
    else if(S_reverse_head_2 )
       begin
          S_ptp_flag <=S_pla_slice_fifo_rdata[29];  
       end
    else if(S_reverse_head_3)
       begin
          S_ptp_flag <=S_pla_slice_fifo_rdata[29];  
       end              
   else
       begin
          S_ptp_flag <=S_ptp_flag ;            
       end
end

always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_hc_flag <= 1'b0 ;
        end
    else if(S_normal_length_flag1 )
        begin
           S_hc_flag <=  S_fifo_rdata[15];
        end
    else if(S_normal_length_flag2)
        begin
           S_hc_flag <=  S_fifo_rdata[15];
        end 
    else if(S_reverse_head_4 || S_reverse_head_5)
        begin
          S_hc_flag <=S_pla_slice_fifo_rdata[31];              
        end               
   else if(S_reverse_head_1 )
       begin
          S_hc_flag <=S_pla_slice_fifo_rdata[31];  
       end
    else if(S_reverse_head_2 )
       begin
          S_hc_flag <=S_pla_slice_fifo_rdata[31];  
       end
    else if(S_reverse_head_3)
       begin
          S_hc_flag <=S_pla_slice_fifo_rdata[31];  
       end              
   else
       begin
          S_hc_flag <=S_hc_flag ;            
       end
end




////����ģ����Ҫ��ϸ��ĥ�������Ǵ�0��ʼ

always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_3crc_div4equa0    <=  1'b0  ;            
        end    
    else if(S_normal_length_flag1 )
        begin
           S_3crc_div4equa0 <= (S_fifo_rdata[14]&&  (S_fifo_rdata[0]==1'b1) );
        end
    else if(S_normal_length_flag2)
        begin
           S_3crc_div4equa0 <= (S_fifo_rdata[14]&&  (S_fifo_rdata[0]==1'b1) );
        end
    else if(S_reverse_head_4 || S_reverse_head_5)
        begin
           S_3crc_div4equa0 <= (S_pla_slice_fifo_rdata[30]&&  (S_pla_slice_fifo_rdata[16]==1'b1) );           
        end            
   else if (S_reverse_head_1)
        begin
           S_3crc_div4equa0 <= (S_pla_slice_fifo_rdata[30]&&  (S_pla_slice_fifo_rdata[16]==1'b1) );
        end   
   else if(S_reverse_head_2)
        begin
           S_3crc_div4equa0 <= (S_pla_slice_fifo_rdata[30]&&  (S_pla_slice_fifo_rdata[16]==1'b1) );
        end   
   else if(S_reverse_head_3 )
        begin
           S_3crc_div4equa0 <= (S_pla_slice_fifo_rdata[30]&&  (S_pla_slice_fifo_rdata[16]==1'b1) );
        end                   
                
    else 
        begin
           S_3crc_div4equa0 <= S_3crc_div4equa0 ;    
        end
end


always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_3crc_div4equa2    <=  1'b0  ;            
        end    
    else if(S_normal_length_flag1 )
        begin
           S_3crc_div4equa2 <= (S_fifo_rdata[14]&&  (S_fifo_rdata[0]==1'b0) );
        end
    else if(S_normal_length_flag2)
        begin
           S_3crc_div4equa2 <= (S_fifo_rdata[14]&&  (S_fifo_rdata[0]==1'b0) );
        end        
    else if(S_reverse_head_4 || S_reverse_head_5)
        begin
            S_3crc_div4equa2 <= (S_pla_slice_fifo_rdata[30]&&  (S_pla_slice_fifo_rdata[16]==1'b0) );           
        end        
   else if (S_reverse_head_1)
        begin
           S_3crc_div4equa2 <= (S_pla_slice_fifo_rdata[30]&&  (S_pla_slice_fifo_rdata[16]==1'b0) );
        end 
   else if(S_reverse_head_2 )
        begin
           S_3crc_div4equa2 <= (S_pla_slice_fifo_rdata[30]&&  (S_pla_slice_fifo_rdata[16]==1'b0) );
        end
   else if(S_reverse_head_3)
        begin
           S_3crc_div4equa2 <= (S_pla_slice_fifo_rdata[30]&&  (S_pla_slice_fifo_rdata[16]==1'b0) );
        end                      
    else 
        begin
           S_3crc_div4equa2 <= S_3crc_div4equa2 ;    
        end
end
/*
////check packet state machine 
(*mark_debug ="true"*) reg [3:0]      S_reframe_state_debug          ;
(*mark_debug ="true"*) reg            S_frame_dpram_alful_debug      ;                                      
(*mark_debug ="true"*) reg [31:0]     S_fifo_rdata_debug             ;
(*mark_debug ="true"*) reg            S_fifo_data_en_debug           ;
(*mark_debug ="true"*) reg            S_length_err_debug             ;
(*mark_debug ="true"*) reg [12:0]     S_frame_length_cnt_debug       ;
(*mark_debug ="true"*) reg [12:0]     S_length_debug                 ;
                                                                     
(*mark_debug ="true"*) reg [31:0]     S_frame_dpram_wdata_debug      ;
(*mark_debug ="true"*) reg            S_frame_dpram_wren_debug       ; 
(*mark_debug ="true"*) reg [11:0]     S_frame_dpram_waddr_debug      ;
                                                                     
(*mark_debug ="true"*)reg  [33:0]     S_frame_fifo_wdata_debug       ;
(*mark_debug ="true"*)reg             S_frame_fifo_wren_debug        ;
(*mark_debug ="true"*)reg             S_time_out_flag_debug          ;
(*mark_debug ="true"*)reg  [12:0]     S_length_reverse_debug         ;

(*mark_debug ="true"*)reg             S_2crc_div4equa0_debug         ;
(*mark_debug ="true"*)reg             S_2crc_div4equa2_debug         ;
(*mark_debug ="true"*)reg             S_3crc_div4equa0_debug         ;
(*mark_debug ="true"*)reg             S_3crc_div4equa2_debug         ;
(*mark_debug ="true"*)reg             S_flag6_debug                  ;
(*mark_debug ="true"*)reg             S_reverse_head_4_debug         ;
(*mark_debug ="true"*)reg             S_reverse_head_3_debug         ;
(*mark_debug ="true"*)reg             S_reverse_head_2_debug         ;
(*mark_debug ="true"*)reg             S_reverse_head_1_debug         ;
(*mark_debug ="true"*)reg             S_fifo_data_en_d1_debug        ;
(*mark_debug ="true"*)reg [3:0]       S_reframe_state_d1_debug       ;



always @ (posedge I_pla_312m5_clk) 
begin
    S_reframe_state_debug         <=  S_reframe_state                ;
    S_frame_dpram_alful_debug     <=  S_frame_dpram_alful            ;
    S_fifo_rdata_debug            <=  S_fifo_rdata                   ;
    S_fifo_data_en_debug          <=  S_fifo_data_en                 ;
    S_length_err_debug            <=  S_length_err        ;
    S_frame_length_cnt_debug      <=  S_frame_length_cnt             ;
    S_length_debug                <=  S_length                       ;               
    S_frame_dpram_wdata_debug     <=  S_frame_dpram_wdata            ;
    S_frame_dpram_wren_debug      <=  S_frame_dpram_wren             ;
    S_frame_dpram_waddr_debug     <=  S_frame_dpram_waddr            ;               
    S_frame_fifo_wdata_debug      <=  S_frame_fifo_wdata             ;
    S_frame_fifo_wren_debug       <=  S_frame_fifo_wren              ;
    S_time_out_flag_debug         <=  S_time_out_flag                ;
    S_length_reverse_debug        <=  S_length_reverse               ;
    S_2crc_div4equa0_debug        <=  S_2crc_div4equa0               ;
    S_2crc_div4equa2_debug        <=  S_2crc_div4equa2               ;
    S_3crc_div4equa0_debug        <=  S_3crc_div4equa0               ;
    S_3crc_div4equa2_debug        <=  S_3crc_div4equa2               ;
    S_flag6_debug                 <=  S_flag6                        ;
    S_reverse_head_4_debug        <=  S_reverse_head_4               ;
    S_reverse_head_3_debug        <=  S_reverse_head_3               ;
    S_reverse_head_2_debug        <=  S_reverse_head_2               ;
    S_reverse_head_1_debug        <=  S_reverse_head_1               ;
    S_fifo_data_en_d1_debug       <=  S_fifo_data_en_d1              ;
    S_reframe_state_d1_debug      <=  S_reframe_state_debug          ;
    
    
end 
*/
/////////protect time /////
always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_protect_cnt <= 32'd0;
        end    
    else if(S_fifo_data_en && !S_fifo_data_en_d1) ////posedge
        begin
            S_protect_cnt <= 32'd0;            
        end
    else if(!S_fifo_data_en)
        begin
            S_protect_cnt <= S_protect_cnt+32'd1;               
        end
end

always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_time_out_flag <= 1'b0 ;
        end    
    else if(&S_protect_cnt)
        begin
            S_time_out_flag <= 1'b1 ;            
        end
    else
        begin
           S_time_out_flag <= 1'b0 ; 
        end
end



assign S_flag6= S_flag2 && S_fifo_data_en ;
////check packet state machine

always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_reframe_state     <= C_REFRAME_IDLE;
        end
    else 
        begin
            S_reframe_state     <= S_reframe_state_next;
        end
end

always @ (*)
begin
    case(S_reframe_state)
        C_REFRAME_IDLE      : ///00
            begin                          
                  if(S_fifo_data_en && S_flag6 && (S_3crc_div4equa2||S_2crc_div4equa2))
                      begin
                          if( S_fifo_rdata[15:0]== 16'h55d5)
                              begin
                                  S_reframe_state_next = C_REFRAME_REVERSE;
                              end
                          else
                              begin
                                  S_reframe_state_next = C_REFRAME_IDLE ;
                              end
                      end
                  else if(S_fifo_data_en && S_flag6 && (S_3crc_div4equa0 ||S_2crc_div4equa0))
                      begin
                             S_reframe_state_next = C_REFRAME_IDLE;                          
                      end
                  else if(S_fifo_data_en && S_flag3 && (S_3crc_div4equa2||S_2crc_div4equa2))
                      begin
                          if( S_fifo_rdata[31:16]== 16'h55d5)
                              begin
                                  S_reframe_state_next = C_REFRAME_NORMAL;
                              end
                          else
                              begin
                                  S_reframe_state_next = C_REFRAME_IDLE ;
                              end
                      end
                  else if(S_fifo_data_en && S_flag3 && (S_3crc_div4equa0||S_2crc_div4equa0))
                      begin
                          if( S_fifo_rdata[15:0]== 16'h55d5)
                              begin
                                  S_reframe_state_next = C_REFRAME_REVERSE;
                              end
                          else
                              begin
                                  S_reframe_state_next = C_REFRAME_IDLE ;
                              end
                      end
                  else if(S_fifo_data_en && (S_fifo_rdata[15:0]== 16'h55d5))
                      begin
                          S_reframe_state_next = C_REFRAME_REVERSE;                          
                      end
                  else if(S_fifo_data_en && (S_fifo_rdata[31:16]== 16'h55d5))
                      begin
                          S_reframe_state_next = C_REFRAME_NORMAL;                          
                      end
                  else 
                      begin
                          S_reframe_state_next = C_REFRAME_IDLE ;
                      end



            end
        C_REFRAME_NORMAL : //01
            begin
                if(S_fifo_data_en && (S_fifo_rdata == 33'h1ffff_ffff))  ///frame terminal
                    begin
                        S_reframe_state_next = C_REFRAME_IDLE;
                    end
                else if(S_length_err || S_feedback_flag || S_time_out_flag) //length err
                    begin
                        S_reframe_state_next = C_REFRAME_IDLE;                    
                    end
                else if(S_fifo_data_en && (S_frame_length_cnt == {1'b0,S_length[12:1]}-13'd1))
                    begin			 
                       S_reframe_state_next = C_REFRAME_NORMAL_LAST;
                    end
                else
                    begin
                      S_reframe_state_next = C_REFRAME_NORMAL;
                    end
            end 
        C_REFRAME_REVERSE://02
            begin
                if(S_fifo_data_en && (S_fifo_rdata == 33'h1ffff_ffff))  ///frame terminal
                    begin
                        S_reframe_state_next = C_REFRAME_IDLE;
                    end
                else if(S_length_err || S_time_out_flag) //length err
                    begin
                        S_reframe_state_next = C_REFRAME_IDLE;                    
                    end              
                else if(S_feedback_flag_reverse && S_fifo_data_en) //feedback 
                    begin
                        S_reframe_state_next = C_REFRAME_IDLE;                    
                    end                
                else if(S_fifo_data_en && (S_frame_length_cnt == {1'b0,S_length_reverse[12:1]}))
                    begin			 
                       S_reframe_state_next = C_REFRAME_REVERSE_LAST;
                    end
                else
                    begin
                      S_reframe_state_next = C_REFRAME_REVERSE;
                    end                
            end     		    	  		
        C_REFRAME_NORMAL_LAST :  ///03
            begin
                if(S_fifo_data_en &&   S_fifo_rdata[15:0] == 16'h55d5 && !(S_2crc_div4equa0||S_3crc_div4equa0)  ) ///CRC==55D5
                    begin
                        S_reframe_state_next = C_REFRAME_REVERSE;
                    end            
                else
                    begin
                        S_reframe_state_next = C_REFRAME_IDLE;
                    end
            end            
        C_REFRAME_REVERSE_LAST:///04
            begin
                if(S_fifo_data_en && S_fifo_rdata[15:0] == 16'h55d5 && (S_3crc_div4equa0|| S_2crc_div4equa0) )
                    begin
                        S_reframe_state_next = C_REFRAME_REVERSE;
                    end
                else if(S_fifo_data_en && S_fifo_rdata[31:16] == 16'h55d5 && (!(S_3crc_div4equa0|| S_2crc_div4equa0)))
                    begin
                        S_reframe_state_next = C_REFRAME_NORMAL;
                    end
                else
                    begin
                        S_reframe_state_next = C_REFRAME_IDLE;
                    end              
            end    
        default : 
            begin
                S_reframe_state_next = C_REFRAME_IDLE;
            end                                   
    endcase
end

always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_frame_length_cnt <= 13'd0;  ///cong 1fff start??
        end
    else
        case(S_reframe_state)
            C_REFRAME_NORMAL,C_REFRAME_REVERSE :
                begin
                    if( S_fifo_data_en )
                        begin
                            S_frame_length_cnt <= S_frame_length_cnt + 13'd1;
                        end
                    else
                        begin
                            S_frame_length_cnt <= S_frame_length_cnt;
                        end
            end
            default : 
                begin
                    S_frame_length_cnt <= 13'd0;
                end
        endcase        
end

////wr ram

always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_frame_dpram_waddr_temp <= 12'h0;
        end
    else if( S_fifo_data_en && S_flag2 )
        begin
            S_frame_dpram_waddr_temp <= S_frame_dpram_waddr_temp+1;            
        end
    else if ((S_fifo_data_en && S_flag3)||S_flag4 ) ///hc buding
        begin
            S_frame_dpram_waddr_temp <= S_frame_dpram_waddr_temp+1;            
        end        
    else
        begin
       case(S_reframe_state)
           C_REFRAME_NORMAL,C_REFRAME_REVERSE:    ///01
                    begin
                        if(S_fifo_data_en )
                            begin
                                S_frame_dpram_waddr_temp <= S_frame_dpram_waddr_temp+1;
                            end
                        else 
                            begin
                                S_frame_dpram_waddr_temp <= S_frame_dpram_waddr_temp;
                            end
                    end
				    C_REFRAME_NORMAL_LAST,C_REFRAME_REVERSE_LAST : 
                    begin
                        if(S_fifo_data_en)
                            begin
                                S_frame_dpram_waddr_temp <= S_frame_dpram_waddr_temp + 1;
                            end
                        else 
                            begin
                                S_frame_dpram_waddr_temp <= S_frame_dpram_waddr_temp;
                            end
                    end
        default :
                begin
                    S_frame_dpram_waddr_temp <= S_frame_dpram_waddr_temp;
                end
            endcase
        end
end

always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_frame_dpram_wdata <= 32'd0;
            S_frame_dpram_wren  <= 1'd0;
            S_frame_dpram_waddr <= 12'h0;
        end
    else if(S_fifo_data_en && S_flag2)
        begin
           S_frame_dpram_wdata <= S_fifo_rdata[31:0];
           S_frame_dpram_wren  <= 1'd1; 
           S_frame_dpram_waddr <= S_frame_dpram_waddr_temp;                                  
        end
    else if(S_fifo_data_en && S_flag3)
        begin
           S_frame_dpram_wdata <= S_fifo_rdata[31:0];
           S_frame_dpram_wren  <= 1'd1; 
           S_frame_dpram_waddr <= S_frame_dpram_waddr_temp;                                  
        end     
    else if(S_flag4)////hc bu ding
        begin
           S_frame_dpram_wdata <= S_fifo_rdata[31:0];
           S_frame_dpram_wren  <= 1'd1; 
           S_frame_dpram_waddr <= S_frame_dpram_waddr_temp;                                  
        end    
    else
        begin
            case(S_reframe_state)
            
                    C_REFRAME_NORMAL,C_REFRAME_REVERSE:    ///01
                             begin
                                 if(S_fifo_data_en )
                                     begin
                                         S_frame_dpram_wdata <= S_fifo_rdata[31:0];
                                         S_frame_dpram_wren  <= 1'd1; 
                                         S_frame_dpram_waddr <= S_frame_dpram_waddr_temp;
                                     end
                                 else 
                                     begin
                                         S_frame_dpram_wdata <= 32'd0;
                                         S_frame_dpram_wren  <= 1'd0;
                                         S_frame_dpram_waddr <= S_frame_dpram_waddr;
                                     end
                             end
				             C_REFRAME_NORMAL_LAST,C_REFRAME_REVERSE_LAST : 
                             begin
                                 if(S_fifo_data_en ) ///3crc div4==1
                                     begin
                                         S_frame_dpram_wdata <= {S_fifo_rdata[31:0] };
                                         S_frame_dpram_wren  <= 1'd1; 
                                         S_frame_dpram_waddr <= S_frame_dpram_waddr_temp;
                                     end
                                 else 
                                     begin
                                         S_frame_dpram_wdata <= 32'd0;
                                         S_frame_dpram_wren  <= 1'd0;
                                         S_frame_dpram_waddr <= S_frame_dpram_waddr;
                                     end
                             end
                     default :
                             begin
                                 S_frame_dpram_wdata <= 32'd0;
                                 S_frame_dpram_wren  <= 1'd0;  
                                 S_frame_dpram_waddr <= S_frame_dpram_waddr;
                             end
               endcase
      end
end

////wr fifo


always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_reframe_state_buf1 <= C_REFRAME_IDLE;
            S_reframe_state_buf1 <= C_REFRAME_IDLE;            
        end
    else 
        begin
            S_reframe_state_buf  <= S_reframe_state    ;
            S_reframe_state_buf1 <= S_reframe_state_buf;
        end
end

always @ (posedge I_pla_312m5_clk)
begin
    S_crc_length_state_d1     <= S_crc_length_state    ;
    S_crc_length_state_d2     <= S_crc_length_state_d1 ;
    S_feedback_flag_d1        <= S_feedback_flag       ;
    S_feedback_flag_reverse_d1<= S_feedback_flag_reverse;
    S_feedback_flag_reverse_d2<= S_feedback_flag_reverse_d1;    
end

always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_crc_length_state <= 8'b0 ;
        end    
    else 
        begin
            S_crc_length_state <= {4'b0,S_2crc_div4equa2,S_2crc_div4equa0,S_3crc_div4equa2,S_3crc_div4equa0};
        end
end

////fangzhen xiugai ////////
always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_flag1 <= 8'b0 ;
        end
    else if(S_flag1 && S_frame_dpram_wren)    
        begin
            S_flag1 <= 8'b0 ;            
        end
    else if((S_reframe_state_buf1!= C_REFRAME_NORMAL)&&(S_reframe_state_buf == C_REFRAME_NORMAL  )&& !S_frame_dpram_wren )
        begin
            S_flag1 <= 1'b1;
        end
    else if((S_reframe_state_buf1!= C_REFRAME_REVERSE)&&(S_reframe_state_buf == C_REFRAME_REVERSE  ) && !S_frame_dpram_wren)        
        begin
            S_flag1 <= 1'b1;            
        end
    else
        begin
            S_flag1 <= S_flag1;             
        end
end

always @ (posedge I_pla_312m5_clk)
begin
    S_frame_dpram_waddr_d1 <= S_frame_dpram_waddr ;
end

//////31:FEEDBACK 30:HC 29:PTP 28:reverse :27-24:crc_length 

/////suocun zhu state :hc_flag ptp_flag  length 

always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_hc_flag_lock             <= 1'b0 ;
            S_ptp_flag_lock            <= 1'b0 ; 
            S_crc_length_state_lock    <= 4'b0 ;
        end
    else if((S_reframe_state == C_REFRAME_NORMAL_LAST)||(S_reframe_state == C_REFRAME_REVERSE_LAST))
        begin
            S_hc_flag_lock             <= S_hc_flag ;
            S_ptp_flag_lock            <= S_ptp_flag ;
            S_crc_length_state_lock    <= S_crc_length_state[3:0] ;           
        end
    else
        begin
            S_hc_flag_lock             <= S_hc_flag_lock           ;
            S_ptp_flag_lock            <= S_ptp_flag_lock          ;
            S_crc_length_state_lock    <= S_crc_length_state_lock  ;           
        end 
end






always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_frame_fifo_wdata <= 34'd0;
        end
    else if(S_flag1 && S_frame_dpram_wren)
        begin
            S_frame_fifo_wdata <= {22'd0,S_frame_dpram_waddr };///{hc,odd/even}            
        end
    else if((S_reframe_state_buf1!= C_REFRAME_NORMAL)&&(S_reframe_state_buf == C_REFRAME_NORMAL  ) && S_frame_dpram_wren)
        begin
            S_frame_fifo_wdata <= {22'd0,S_frame_dpram_waddr };///{hc,odd/even}
        end
    else if((S_reframe_state_buf1!= C_REFRAME_REVERSE)&&(S_reframe_state_buf == C_REFRAME_REVERSE  ) && S_frame_dpram_wren)
        begin
            S_frame_fifo_wdata <= {22'd0,S_frame_dpram_waddr };///{hc,odd/even}
        end                   
    else if(( S_reframe_state_buf == C_REFRAME_NORMAL_LAST  )&& S_fifo_data_en_d1  )
        begin
            S_frame_fifo_wdata <= {3'b0,S_hc_flag_lock,S_ptp_flag_lock,1'b0,S_crc_length_state_lock,S_frame_fifo_wdata[11:0],S_frame_dpram_waddr};
        end 
    else if(( S_reframe_state_buf == C_REFRAME_REVERSE_LAST  )&& S_fifo_data_en_d1 )
        begin
            S_frame_fifo_wdata <= {3'b0,S_hc_flag_lock,S_ptp_flag_lock,1'b1,S_crc_length_state_lock,S_frame_fifo_wdata[11:0],S_frame_dpram_waddr};            
        end 
    else if(S_flag2_d1 && S_fifo_data_en_d1)  
        begin
            S_frame_fifo_wdata <= {3'b0,S_hc_flag_lock,S_ptp_flag_lock,1'b0,S_crc_length_state_lock,S_frame_fifo_wdata[11:0],S_frame_dpram_waddr};              
        end 
    else if(S_flag3_d1 && S_fifo_data_en_d1)  
        begin
            S_frame_fifo_wdata <= {3'b0,S_hc_flag_lock,S_ptp_flag_lock,1'b1,S_crc_length_state_lock,S_frame_fifo_wdata[11:0],S_frame_dpram_waddr};            
        end
    else if(S_flag4_d1) ///hc buding normal
        begin
            S_frame_fifo_wdata <= {3'b0,S_hc_flag_lock,S_ptp_flag_lock,1'b0,S_crc_length_state_lock,S_frame_fifo_wdata[11:0],S_frame_dpram_waddr};            
        end                           
    else
       begin
            S_frame_fifo_wdata <= S_frame_fifo_wdata;
        end 
end

//////bu ding
always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_flag2<= 1'b0 ;
        end
    else if( (S_reframe_state  == C_REFRAME_NORMAL_LAST ) && !S_fifo_data_en )
        begin
            S_flag2<= 1'b1 ;            
        end
    else if(S_fifo_data_en )
        begin
            S_flag2<= 1'b0 ;            
        end    
    else
        begin
            S_flag2 <= S_flag2 ;
        end
end

always @ (posedge I_pla_312m5_clk)
begin
    S_flag2_d1 <= S_flag2 ;
    S_flag3_d1 <= S_flag3 ;
end




always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_flag3<= 1'b0 ;
        end
    else if( (S_reframe_state  == C_REFRAME_REVERSE_LAST ) && !S_fifo_data_en )
        begin
            S_flag3<= 1'b1 ;            
        end 
    else if(S_fifo_data_en)
        begin
            S_flag3<= 1'b0 ;              
        end
    else
        begin
            S_flag3 <= S_flag3 ;
        end
end

always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_flag4_temp <= 1'b0 ;
        end  
    else if((S_fifo_data_en && !S_fifo_data_en_d1 )&& (S_reframe_state_next == 4'h1)&& (S_reframe_state == 4'h0))    
        begin
            S_flag4_temp <= 1'b1 ;            
        end
    else if((S_fifo_data_en && !S_fifo_data_en_d1 ))    
        begin
            S_flag4_temp <= 1'b0 ;            
        end    
end


assign S_flag4 = S_fifo_data_en && S_flag2_d1&& S_hc_flag &&  S_flag4_temp;

always @ (posedge I_pla_312m5_clk)
begin
    S_flag4_d1 <= S_flag4 ;
end

always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_frame_fifo_wren <= 1'b0;
        end
    else if(S_frame_fifo_wren )
        begin
            S_frame_fifo_wren <= 1'b0;
        end
    else if((S_reframe_state_buf == C_REFRAME_NORMAL_LAST ) && S_fifo_data_en_d1)
        begin
            S_frame_fifo_wren <= 1'b1;
        end
    else if((S_reframe_state_buf == C_REFRAME_REVERSE_LAST ) && S_fifo_data_en_d1)
        begin
            S_frame_fifo_wren <= 1'b1;
        end
    else if(S_flag2_d1 && S_fifo_data_en_d1)  //////3 is end no en  
        begin
            S_frame_fifo_wren <= 1'b1;            
        end 
    else if(S_flag3_d1 && S_fifo_data_en_d1) ////4 is end no en  
        begin
            S_frame_fifo_wren <= 1'b1;              
        end       
    else if(S_flag4_d1) ///hc buding normal
        begin
            S_frame_fifo_wren <= 1'b1;               
        end       
    else
        begin
            S_frame_fifo_wren <= 1'b0;
        end
end

backward_frame_dpram U_backward_frame_dpram    ///4096*32
(
.I_porta_clk        (I_pla_312m5_clk            ),
.I_porta_addr       (S_frame_dpram_waddr        ),
.I_porta_din        (S_frame_dpram_wdata        ),
.I_porta_wr         (S_frame_dpram_wren         ),
.I_portb_clk        (I_pla_312m5_clk            ),
.I_portb_addr       (I_pla_frame_sdpram_raddr   ),
.O_portb_dout       (O_pla_frame_sdpram_rdata   )
);
 

block_fifo_com_clk_1024x34 u_block_fifo_com_clk_1024x34
(   
  .clk                (I_pla_312m5_clk            ),
  .srst                (I_pla_rst                  ),
  .din                (S_frame_fifo_wdata         ),
  .wr_en              (S_frame_fifo_wren          ),
  .rd_en              (I_pla_frame_para_fifo_rd   ),
  .dout               (O_pla_frame_para_fifo_rdata),
  .full               (S_fifo_full                ),
  //.almost_full        ( ),
  .empty              (O_pla_frame_para_fifo_empty),
  .data_count         (S_pla_reframe_usdw         )
);


//////feedback store ////////
always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_feedback_last_flag <= 1'b0 ;
        end
    else if(S_fifo_data_en)
        begin
            S_feedback_last_flag <= 1'b0 ;            
        end
    else if(!S_fifo_data_en && S_fifo_data_en_d1 && S_feedback_flag_reverse_d1)
        begin
            S_feedback_last_flag <= 1'b1 ;
        end        
end



                                                                                                                                                                      
always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_feedback_wren <= 1'b0 ;
        end
    else if(S_feedback_fifo_full)
        begin
            S_feedback_wren <= 1'b0 ;            
        end
    else if((S_feedback_flag || S_feedback_flag_reverse_d1 )&& S_fifo_data_en )
        begin
            S_feedback_wren <= 1'b1 ;              
        end
    else if(S_feedback_last_flag && S_fifo_data_en )
        begin
            S_feedback_wren <= 1'b1 ;  
        end
    else
        begin
            S_feedback_wren <= 1'b0 ;              
        end     
end

always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_feedback_wdata <= 32'b0 ;
        end
    else if(S_feedback_flag  && S_fifo_data_en )
        begin
            S_feedback_wdata <= S_fifo_rdata[31:0] ;              
        end
    else if(S_feedback_flag_reverse_d1 && S_fifo_data_en )
        begin
            S_feedback_wdata <= {S_fifo_rdata_d1[15:0],S_fifo_rdata[31:16]} ;               
        end  
    else if(S_feedback_last_flag && S_fifo_data_en )
        begin
            S_feedback_wdata <= {S_fifo_rdata_d1[15:0],S_fifo_rdata[31:16]} ; 
        end
    else
        begin
            S_feedback_wdata <= 32'b0 ;              
        end     
end

always @ (posedge I_pla_312m5_clk)
begin
    O_feedback_fifo_rdata   <= S_feedback_fifo_rdata[31:0] ;
    O_feedback_fifo_count   <= S_feedback_fifo_count ;
    O_feedback_fifo_full    <= S_feedback_fifo_full  ;
    O_feedback_fifo_empty   <= S_feedback_fifo_empty ;
end

    
block_fifo_com_clk_64x34 u1_feedback_store_64x34
(   
  .clk                (I_pla_312m5_clk            ),
  .rst                (I_pla_rst                  ),
  .din                ({2'b0,S_feedback_wdata }   ),
  .wr_en              (S_feedback_wren            ),
  .rd_en              (I_pla_feedback_rd          ),
  .dout               (S_feedback_fifo_rdata),
  .full               (S_feedback_fifo_full       ),
  .almost_full        ( ),
  .empty              (S_feedback_fifo_empty      ),
  .data_count         (S_feedback_fifo_count      )
);



assign O_pla_slice_fifo_rd = S_pla_slice_fifo_rd;

////test code  55d5 num     //////


always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            O_pla0_back_55d5_flag <= 1'b0 ;
        end
    else if(S_fifo_data_en )
        begin
           O_pla0_back_55d5_flag <= ((S_fifo_rdata[15:0]==16'h55d5)||(S_fifo_rdata[31:16]==16'h55d5))? 1'b1 :1'b0 ; 
        end
    else
        begin
           O_pla0_back_55d5_flag <= 1'b0 ;
        end
    
end

always @ (posedge I_pla_312m5_clk)
begin
    O_frame_fifo_wren <= S_frame_fifo_wren ;
end

endmodule
