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
//x pla_payload_num_chk--
//----------------------------------------------------------------------------
//----------------------------------------------------------------------------
//Version         Date           Author        Description
// 1.1          nov-4-2015      Li Shuai        pla_schedule
// 1.2
//----------------------------------------------------------------------------
module pla_id_seq_chk(

input               I_pla_312m5_clk           ,
input               I_pla_rst                 ,
input     [14:0]    I_pla_slice_id            ,
input     [31:0]    I_pla_slice_payload       ,
input               I_pla_slice_en            ,
input               I_cnt_clear               ,

output  reg  [15:0] O_slice_55D5_cnt          ,
output  reg  [15:0] O_slice_lose_cnt          ,
output  reg         O_slice_lose_reg          
             
);

reg   [14:0]    S_pla_slice_id           ;
reg             S_pla_slice_en           ;
                                             

always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
    	 S_pla_slice_en  <= 1'd0 ;
    end
    else 
    begin
       S_pla_slice_en  <= I_pla_slice_en ;
    end
end



always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
    	  O_slice_lose_cnt <=16'd0;
    	  O_slice_lose_reg <=1'd0;
    	  S_pla_slice_id <= 15'h7fff;
    end
    else if (I_cnt_clear)
    begin
    	  O_slice_lose_cnt <=16'd0;
    	  O_slice_lose_reg <=1'd0;    
    end
    else if (!S_pla_slice_en && I_pla_slice_en) 
    begin
        S_pla_slice_id  <= I_pla_slice_id; 
        if( I_pla_slice_id != S_pla_slice_id + 14'd1)    
        begin   
            O_slice_lose_cnt <= O_slice_lose_cnt +16'd1;
            O_slice_lose_reg <= 1'b1;
        end     
        else
        begin
            O_slice_lose_cnt <= O_slice_lose_cnt;
            O_slice_lose_reg <= 1'b0;
        end
    end   
    else 
    begin
       O_slice_lose_reg <= 1'b0;
    end 
end


always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
    	  O_slice_55D5_cnt <=16'd0;
    end
    else if (I_cnt_clear)
    begin
    	  O_slice_55D5_cnt <=16'd0;
    end
    else if (I_pla_slice_en) 
    begin
        if(I_pla_slice_payload[15:0] == 16'h55d5)    
        begin   
            O_slice_55D5_cnt <= O_slice_55D5_cnt +16'd1;
        end     
        else  if(I_pla_slice_payload[31:16] == 16'h55d5)    
        begin   
            O_slice_55D5_cnt <= O_slice_55D5_cnt +16'd1;
        end  
        else    
        begin
            O_slice_55D5_cnt <= O_slice_55D5_cnt;
        end
    end    
end
 



endmodule
