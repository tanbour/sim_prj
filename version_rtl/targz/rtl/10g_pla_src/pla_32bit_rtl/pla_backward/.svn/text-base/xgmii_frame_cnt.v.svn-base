`timescale 1 ns / 10 ps

module xgmii_frame_cnt (
input             I_312m_clk                ,
input             I_frame_en                ,
input             I_cnt_clear               ,
output reg [15:0] O_cnt_result=16'd0
);

reg S_en_buf=1 ;

always@(posedge I_312m_clk )
begin
    S_en_buf <= I_frame_en ;
end

always@(posedge I_312m_clk )
begin  
    if(I_cnt_clear)
    begin
        O_cnt_result <= 16'h0 ;
    end
    else if(I_frame_en && !S_en_buf)
    begin
        O_cnt_result <= O_cnt_result + 1'b1 ;
    end
    else
    begin
        O_cnt_result <= O_cnt_result ;
    end
    
end

endmodule
