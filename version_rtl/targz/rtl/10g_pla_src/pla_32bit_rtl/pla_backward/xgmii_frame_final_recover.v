module xgmii_frame_final_recover
(
 input                I_global_rst    ,  
 input                I_312m_clk	    ,
 input  [31:0]        I_xgmii_data    ,   
 input  [3:0 ]        I_xgmii_txc     ,
 input  [1:0 ]        I_xgmii_num     ,
 input                I_crc_err       ,
 input                I_crc_ok        ,
 input                I_ptp_flag      ,
 input  [31:0]        I_crc_out       ,
 output reg [31:0]        O_xgmii_data    ,
 output reg [3:0 ]        O_xgmii_txc     ,
 output reg [1:0 ]        O_xgmii_num     


);
reg    [31:0]        S_xgmii_data_d1   ;
reg    [3:0 ]        S_xgmii_txc_d1    ;
reg    [1:0 ]        S_xgmii_num_d1    ;
reg    [31:0]        S_xgmii_data_d2   ;
reg    [3:0]         S_xgmii_txc_d2    ;
reg    [1:0]         S_xgmii_num_d2    ;
reg    [31:0]        S_xgmii_data_d3   ;
reg    [3:0]         S_xgmii_txc_d3    ;
reg    [1:0]         S_xgmii_num_d3    ;
reg    [31:0]        S_xgmii_data_d4   ;
reg    [3:0]         S_xgmii_txc_d4    ;
reg    [1:0]         S_xgmii_num_d4    ;
reg    [31:0]        S_xgmii_data_d5   ;
reg    [3:0]         S_xgmii_txc_d5    ;
reg    [1:0]         S_xgmii_num_d5    ;
reg    [1:0]         S_xgmii_num_d6    ;
reg    [3:0]         S_xgmii_txc_d6    ;
reg                  S_crc_ok          ;
reg                  S_crc_err         ;

reg                  S_crc_ok_d1       ;
reg                  S_crc_ok_d2       ;
reg                  S_crc_ok_d3       ;
reg                  S_crc_ok_d4       ;
reg                  S_crc_ok_d5       ;      
reg                  S_crc_err_d1      ;
reg                  S_crc_err_d2      ;
reg                  S_crc_err_d3      ;
reg                  S_crc_err_d4      ;
reg                  S_crc_err_d5      ;

reg  [31:0]          S_crc_out_d1      ;
reg  [31:0]          S_crc_out_d2      ;
reg  [31:0]          S_crc_out_d3      ;
reg  [31:0]          S_crc_out_d4      ;
reg  [31:0]          S_crc_out_d5      ;

reg  [31:0]          S_xgmii_data1     ;
reg                  S_packet_en_d1    ;
reg                  S_packet_en_d2    ;
reg                  S_packet_en       ;

reg                  S_flag_txc1       ;
reg                  S_flag_txc7       ;
                                      
always @ (posedge I_312m_clk )
begin
     S_crc_ok_d1  <=   I_crc_ok                 ;
     S_crc_ok_d2  <=   S_crc_ok_d1              ;
     S_crc_ok_d3  <=   S_crc_ok_d2              ;
     S_crc_ok_d4  <=   S_crc_ok_d3              ;
     S_crc_ok_d5  <=   S_crc_ok_d4              ;
                         
     S_crc_err_d1 <=  I_crc_err                 ;
     S_crc_err_d2 <=  S_crc_err_d1                 ;     
     S_crc_err_d3 <=  S_crc_err_d2                 ;     
     S_crc_err_d4 <=  S_crc_err_d3                 ;
     S_crc_err_d5 <=  S_crc_err_d4                 ;       
end

always @ (posedge I_312m_clk )
begin
    S_xgmii_data_d1   <=I_xgmii_data      ;
    S_xgmii_txc_d1    <=I_xgmii_txc       ;
    S_xgmii_num_d1    <=I_xgmii_num       ;
    S_xgmii_data_d2   <=S_xgmii_data_d1   ;
    S_xgmii_txc_d2    <=S_xgmii_txc_d1    ;
    S_xgmii_num_d2    <=S_xgmii_num_d1    ;
    S_xgmii_data_d3   <=S_xgmii_data_d2   ;    
    S_xgmii_txc_d3    <=S_xgmii_txc_d2    ;    
    S_xgmii_num_d3    <=S_xgmii_num_d2    ;
    S_xgmii_data_d4   <=S_xgmii_data_d3   ;
    S_xgmii_txc_d4    <=S_xgmii_txc_d3    ;
    S_xgmii_num_d4    <=S_xgmii_num_d3    ;            
    S_xgmii_data_d5   <=S_xgmii_data_d4   ;    
    S_xgmii_txc_d5    <=S_xgmii_txc_d4    ; 
    S_xgmii_txc_d6    <=S_xgmii_txc_d5    ;   
    S_xgmii_num_d5    <=S_xgmii_num_d4    ;
    S_xgmii_num_d6    <=S_xgmii_num_d5    ; 
    S_crc_out_d1      <=I_crc_out         ; 
    S_crc_out_d2      <=S_crc_out_d1      ;
    S_crc_out_d3      <=S_crc_out_d2      ;
    S_crc_out_d4      <=S_crc_out_d3      ;
    S_crc_out_d5      <=S_crc_out_d4      ;
    S_packet_en_d1    <=S_packet_en       ;  
    S_packet_en_d2    <=S_packet_en_d1    ;                                           
end




/// S_packet_en he d5 dui qi
always @ (posedge I_312m_clk )
begin
    if(I_global_rst)
        begin
            S_packet_en <= 1'b0           ;
        end
    else if(S_xgmii_txc_d4 == 8'h8 )
        begin
            S_packet_en <= 1'b1           ;            
        end
    else if(|S_xgmii_txc_d4 == 1'b1 )
        begin
            S_packet_en <= 1'b0           ;             
        end
    else
        begin
           S_packet_en <= S_packet_en     ;
        end       
end

always @ (posedge I_312m_clk )
begin
    if((I_crc_ok )&&S_packet_en && I_ptp_flag ) 
        begin
            case(S_xgmii_txc_d4)
                4'h1:
                    begin
                        S_xgmii_data1<={S_xgmii_data_d5[31:8],I_crc_out[31:24] };
                        S_flag_txc1<= 1'b1 ;
                        S_flag_txc7<= 1'b0 ;                          
                    end
                4'h3:
                    begin
                        S_xgmii_data1<={S_xgmii_data_d5[31:16],I_crc_out[31:16] };
                        S_flag_txc1<= 1'b1 ;
                        S_flag_txc7<= 1'b0 ;                            
                    end    
                4'h7:
                    begin
                        S_xgmii_data1<={S_xgmii_data_d5[31:24],I_crc_out[31:8]} ;
                        S_flag_txc7<= 1'b1 ;
                        S_flag_txc1<= 1'b0 ;                                                 
                    end
                4'hf:
                    begin
                        S_xgmii_data1<={I_crc_out} ;
                        S_flag_txc7<= 1'b0 ;
                        S_flag_txc1<= 1'b0 ;                                                 
                    end
             default:
                    begin
                        S_xgmii_data1<=S_xgmii_data_d5 ;   
                        S_flag_txc7<= 1'b0 ;           
                        S_flag_txc1<= 1'b0 ;                                   
                    end               
           endcase            
        end
       else if((I_crc_ok )&&S_packet_en) 
        begin
            case(S_xgmii_txc_d4)
                4'h1,4'h3:
                    begin
                        S_xgmii_data1<=S_xgmii_data_d5 ;
                        S_flag_txc1<= 1'b1 ;
                        S_flag_txc7<= 1'b0 ;                          
                    end
                4'h7:
                    begin
                        S_xgmii_data1<={S_xgmii_data_d5[31:8],I_crc_out[15:8]} ;
                        S_flag_txc7<= 1'b1 ;
                        S_flag_txc1<= 1'b0 ;                                                 
                    end
                4'hf:
                    begin
                        S_xgmii_data1<={I_crc_out} ;
                        S_flag_txc7<= 1'b0 ;
                        S_flag_txc1<= 1'b0 ;                                                 
                    end
             default:
                    begin
                        S_xgmii_data1<=S_xgmii_data_d5 ;   
                        S_flag_txc7<= 1'b0 ;           
                        S_flag_txc1<= 1'b0 ;                                   
                    end               
           endcase            
        end
   else
       begin
           S_flag_txc1<= 1'b0 ;
           S_flag_txc7<= 1'b0 ;
           S_xgmii_data1 <= S_xgmii_data_d5 ;  
       end
end

always @ (posedge I_312m_clk )
begin
    if(I_global_rst)
        begin
            O_xgmii_data <= 32'h07070707 ;         
        end
    else if( S_crc_ok_d2&&S_packet_en_d2) 
        begin
            case(S_xgmii_txc_d6)
                4'h1:
                    begin
                        O_xgmii_data<={I_crc_out[23:0],8'hfd} ;                   
                    end
                4'h3:
                    begin
                        O_xgmii_data<={I_crc_out[15:0],16'hfd07} ;                          
                    end
                4'h7:
                    begin
                        O_xgmii_data<={I_crc_out[7:0],24'hfd0707} ;                                               
                    end
                4'hf:
                    begin
                        O_xgmii_data<=32'hfd070707 ;                                              
                    end
             default:
                    begin
                        O_xgmii_data<=S_xgmii_data1 ;                                     
                    end               
           endcase            
        end        
   else
       begin
           O_xgmii_data <= S_xgmii_data1 ;  
       end
end

always @ (posedge I_312m_clk )
begin
    if(I_global_rst)
        begin
            O_xgmii_txc <= 4'hf ;
            O_xgmii_num <= 2'b0 ;
        end
    else
        begin
           O_xgmii_txc <=S_xgmii_txc_d6 ;  
           O_xgmii_num <=S_xgmii_num_d6 ; 
        end
end


endmodule