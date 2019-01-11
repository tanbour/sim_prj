module xgmii_crc_compare_16
(
 input                     I_rst    	            ,  
 input                     I_312m_clk	          ,
 input  [31:0]             I_xgmii_data          ,   
 input  [3:0]              I_xgmii_txc           ,
 input  [31:0]             I_crc_data_out        ,
 input                     I_ptp_flag            ,
 output                    O_crc_compare_signal  ,
 output reg                O_crc_wrong           ,
 output reg                O_crc_ok              ,
 output reg [31:0]         O_crc_out

);

reg  [31:0]      S_xgmii_data=32'd0               ;
reg  [3:0 ]      S_xgmii_txc =4'd0                ;
reg  [31:0]      S_xgmii_data_d1=32'd0            ;
reg  [3:0 ]      S_xgmii_txc_d1 =4'd0             ;
reg  [31:0]      S_xgmii_data_d2=32'd0            ;
reg  [3:0 ]      S_xgmii_txc_d2=4'd0              ;
                                                  
reg  [3:0]       S_xgmii_crc_txc                  ;
reg              S_compare_signal_d1              ;
reg [31:0]       S_xgmii_last_data1               ;
reg [31:0]       S_xgmii_last_data2               ;
wire             S_compare_signal                 ;
reg [31:0]       S_crc_packet_data                ;
reg              S_compare_signal_d2              ;

reg [31:0]       S_xgmii_data_com                 ;
reg [3:0 ]       S_xgmii_txc_com                  ;
reg [31:0]       S_xgmii_data_com_d1              ;
reg [3:0 ]       S_xgmii_txc_com_d1               ;
                                                  


assign  O_crc_compare_signal = S_compare_signal  ; 

always @( posedge I_312m_clk)
    begin
        S_xgmii_data_com        <=  I_xgmii_data         ;
        S_xgmii_txc_com         <=  I_xgmii_txc          ;    
        S_xgmii_data_com_d1     <=  S_xgmii_data_com     ;
        S_xgmii_txc_com_d1      <=  S_xgmii_txc_com      ;               
    
        S_xgmii_data     <=         S_xgmii_data_com     ;
        S_xgmii_txc      <=         S_xgmii_txc_com      ;
        S_xgmii_data_d1  <=         S_xgmii_data         ;
        S_xgmii_txc_d1   <=         S_xgmii_txc          ;
        S_xgmii_data_d2  <=         S_xgmii_data_d1      ;
        S_xgmii_txc_d2   <=         S_xgmii_txc_d1       ;
    end 

always @( posedge I_312m_clk)
    begin
        S_compare_signal_d1 <=  S_compare_signal ;
        S_compare_signal_d2 <=  S_compare_signal_d1 ;        
    end

///提取报文中的crc
//1提取最后两个周期数据

reg  S_packet_en                                 ;
reg  S_packet_en_d1                              ;

always @( posedge I_312m_clk)
    begin
        if(I_rst)
            begin
                S_packet_en <= 1'b0   ;
            end        
        else if(( I_xgmii_data==32'hfb555555 )&& (I_xgmii_txc == 4'h8))
            begin
                S_packet_en <= 1'b1   ;                
            end
        else if(|I_xgmii_txc )
            begin
                S_packet_en <= 1'b0   ;                  
            end
    
    end
    
always @( posedge I_312m_clk)
    begin
         S_packet_en_d1 <= S_packet_en ;
    end    


assign S_compare_signal = !S_packet_en && S_packet_en_d1 ;


always @( posedge I_312m_clk)
    begin
        if(I_rst)
            begin
                S_xgmii_last_data1 <= 32'd0   ;
            end
        else if(S_compare_signal )
            begin
                S_xgmii_last_data1 <= S_xgmii_data_com ;
            end
        else
            begin
                S_xgmii_last_data1 <= S_xgmii_last_data1 ;
            end
    end

always @( posedge I_312m_clk)
    begin
        if(I_rst)
            begin
                S_xgmii_last_data2 <= 32'd0   ;
            end
        else if(S_compare_signal )
            begin
                S_xgmii_last_data2 <= S_xgmii_data ;
            end
        else
            begin
                S_xgmii_last_data2 <= S_xgmii_last_data2 ;
            end
    end
    
always @( posedge I_312m_clk)
    begin
        if(I_rst)
            begin
                S_xgmii_crc_txc <= 4'd0   ;
            end
        else if(S_compare_signal )
            begin
                S_xgmii_crc_txc <= S_xgmii_txc_com     ;
            end
        else
            begin
                S_xgmii_crc_txc <= S_xgmii_crc_txc ;
            end
    end    

always @( posedge I_312m_clk)
    begin
        if(I_rst)
            begin
                S_crc_packet_data <= 32'd0   ;
            end
        else if(S_compare_signal_d1)
            begin
                if(S_xgmii_crc_txc==4'hf) 
                    begin
                        S_crc_packet_data <= S_xgmii_last_data2;
                    end
                else if(S_xgmii_crc_txc==4'h7)
                    begin
                        S_crc_packet_data <= {S_xgmii_last_data2[23:0],S_xgmii_last_data1[31:24] };
                    end 
                else if(S_xgmii_crc_txc==4'h3)
                    begin
                        S_crc_packet_data <= {S_xgmii_last_data2[16:0],S_xgmii_last_data1[31:16] };
                    end 
               else if(S_xgmii_crc_txc==4'h1)
                    begin
                        S_crc_packet_data <= {S_xgmii_last_data2[7:0],S_xgmii_last_data1[31:8] };
                    end 
            end
        else
            begin
                S_crc_packet_data <= S_crc_packet_data ;
            end
    end

always @( posedge I_312m_clk)
    begin
        if(I_rst)
            begin
                O_crc_wrong <= 1'b0 ;
            end
        else if(S_compare_signal_d2)
            begin
                if(S_crc_packet_data[31:16] != I_crc_data_out[31:16])
                    begin
                        O_crc_wrong <= 1'b1 ;  
                    end
                else
                    begin
                        O_crc_wrong <= 1'b0 ;                         
                    end
            end
        else
            begin
                        O_crc_wrong <= 1'b0 ;                
            end
    end
    
always @( posedge I_312m_clk)
    begin
        if(I_rst)
            begin
                O_crc_ok <= 1'b0 ;
            end
        else if(S_compare_signal_d2)
            begin
                if(S_crc_packet_data[31:16] == I_crc_data_out[31:16] || I_ptp_flag)
                    begin
                        O_crc_ok <= 1'b1 ;  
                    end
                else
                    begin
                        O_crc_ok <= 1'b0 ;                         
                    end
            end
        else
            begin
                        O_crc_ok <= 1'b0 ;                
            end
    end


always @( posedge I_312m_clk)
    begin
        if(I_rst)
            begin
                O_crc_out <= 32'b0 ;
            end        
        else if (S_compare_signal_d2)
            begin
               O_crc_out <= I_crc_data_out ; 
            end
    end


endmodule   
    
    
    
