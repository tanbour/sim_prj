`timescale 1ns/100ps
module f1_xgmii_mux(
input               I_pla_312m5_clk          ,
input               I_pla_rst                ,
input    [31:0]     I_xgmii_in_d0            ,
input    [3:0]      I_xgmii_in_c0            ,
input    [31:0]     I_xgmii_in_d1            ,
input    [3:0]      I_xgmii_in_c1            ,
output   [31:0]     O_xgmii_out_d            ,
output   [3:0]      O_xgmii_out_c 
);

reg      [31:0]     S_xgmii_in_d0_buf1;
reg      [31:0]     S_xgmii_in_d0_buf2;
reg      [31:0]     S_xgmii_in_d0_buf3;
reg      [3:0]      S_xgmii_in_c0_buf1;
reg      [3:0]      S_xgmii_in_c0_buf2;
reg      [3:0]      S_xgmii_in_c0_buf3;
reg      [31:0]     S_xgmii_in_d1_buf1;
reg      [31:0]     S_xgmii_in_d1_buf2;
reg      [31:0]     S_xgmii_in_d1_buf3;
reg      [3:0]      S_xgmii_in_c1_buf1;
reg      [3:0]      S_xgmii_in_c1_buf2;
reg      [3:0]      S_xgmii_in_c1_buf3;
reg      [3:0]      S_xgmii_in_end_flg0;
reg      [3:0]      S_xgmii_in_end_flg1;
reg      [3:0]      S_xgmii_in_end_flg0_buf1;
reg      [3:0]      S_xgmii_in_end_flg1_buf1;
reg      [3:0]      S_xgmii_in_end_flg0_buf2;
reg      [3:0]      S_xgmii_in_end_flg1_buf2;
reg      [35:0]     S_xgmii_fifo0_wdata  = 36'hf17070707;
reg                 S_xgmii_fifo0_wr   =1'b0 ;
reg                 S_xmgii_fifo0_rd   =1'b0 ;
reg                 S1_xmgii_fifo0_rd  =1'b0 ;
reg                 S2_xmgii_fifo0_rd  =1'b0 ;
wire                S_xgmii_fifo0_empty;
wire     [35:0]     S_xgmii_fifo0_rdata;
reg      [35:0]     S1_xgmii_fifo0_rdata = 36'hf17070707;
reg      [35:0]     S_xgmii_fifo1_wdata = 36'hf17070707;
reg                 S_xgmii_fifo1_wr   =1'b0 ;
reg                 S_xmgii_fifo1_rd   =1'b0 ;
reg                 S1_xmgii_fifo1_rd  =1'b0  ;
reg                 S2_xmgii_fifo1_rd  =1'b0  ;
wire                S_xgmii_fifo1_empty;
wire     [35:0]     S_xgmii_fifo1_rdata ; 
reg      [35:0]     S1_xgmii_fifo1_rdata = 36'hf17070707;
reg      [31:0]     S_xgmii_out_d      ;
reg      [3:0]      S_xgmii_out_c      ;


wire         S_xgmii_fifo0_full;
wire         S_xgmii_fifo1_full;
wire  [10:0] S_xgmii_fifo0_usedw;
wire  [11:0] S_xgmii_fifo1_usedw;

always @ (posedge I_pla_312m5_clk)
begin
end

always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_xgmii_in_d0_buf1 <= 32'd0;
            S_xgmii_in_d0_buf2 <= 32'd0;
            S_xgmii_in_d0_buf3 <= 32'd0;
            S_xgmii_in_c0_buf1 <= 4'hf ;
            S_xgmii_in_c0_buf2 <= 4'hf ;
            S_xgmii_in_c0_buf3 <= 4'hf ;
            S_xgmii_in_d1_buf1 <= 32'd0;
            S_xgmii_in_d1_buf2 <= 32'd0;
            S_xgmii_in_d1_buf3 <= 32'd0;
            S_xgmii_in_c1_buf1 <= 4'hf ;
            S_xgmii_in_c1_buf2 <= 4'hf ;
            S_xgmii_in_c1_buf3 <= 4'hf ;
        end
    else
        begin
            S_xgmii_in_d0_buf1 <= I_xgmii_in_d0;
            S_xgmii_in_d0_buf2 <= S_xgmii_in_d0_buf1;
            S_xgmii_in_d0_buf3 <= S_xgmii_in_d0_buf2;
            S_xgmii_in_c0_buf1 <= I_xgmii_in_c0 ;
            S_xgmii_in_c0_buf2 <= S_xgmii_in_c0_buf1 ;
            S_xgmii_in_c0_buf3 <= S_xgmii_in_c0_buf2 ;
            S_xgmii_in_d1_buf1 <= I_xgmii_in_d1;
            S_xgmii_in_d1_buf2 <= S_xgmii_in_d1_buf1;
            S_xgmii_in_d1_buf3 <= S_xgmii_in_d1_buf2;
            S_xgmii_in_c1_buf1 <= I_xgmii_in_c1 ;
            S_xgmii_in_c1_buf2 <= S_xgmii_in_c1_buf1 ;
            S_xgmii_in_c1_buf3 <= S_xgmii_in_c1_buf2 ;
        end
end

always @ (posedge I_pla_312m5_clk)
begin
    if((I_xgmii_in_c0 == 4'b1111) && I_xgmii_in_d0[31:24] == 8'hfd)
        begin
            S_xgmii_in_end_flg0[3] <= 1'b1;
        end
    else
        begin
            S_xgmii_in_end_flg0[3] <= 1'b0;
        end
end

always @ (posedge I_pla_312m5_clk)
begin
    if((I_xgmii_in_c0 == 4'b0111) && I_xgmii_in_d0[23:16] == 8'hfd)
        begin
            S_xgmii_in_end_flg0[2] <= 1'b1;
        end
    else
        begin
            S_xgmii_in_end_flg0[2] <= 1'b0;
        end
end

always @ (posedge I_pla_312m5_clk)
begin
    if((I_xgmii_in_c0 == 4'b0011) && I_xgmii_in_d0[15:8] == 8'hfd)
        begin
            S_xgmii_in_end_flg0[1] <= 1'b1;
        end
    else
        begin
            S_xgmii_in_end_flg0[1] <= 1'b0;
        end
end

always @ (posedge I_pla_312m5_clk)
begin
    if((I_xgmii_in_c0 == 4'b0001) && I_xgmii_in_d0[7:0] == 8'hfd)
        begin
            S_xgmii_in_end_flg0[0] <= 1'b1;
        end
    else
        begin
            S_xgmii_in_end_flg0[0] <= 1'b0;
        end
end

always @ (posedge I_pla_312m5_clk)
begin
    if((I_xgmii_in_c1 == 4'b1111) && I_xgmii_in_d1[31:24] == 8'hfd)
        begin
            S_xgmii_in_end_flg1[3] <= 1'b1;
        end
    else
        begin
            S_xgmii_in_end_flg1[3] <= 1'b0;
        end
end

always @ (posedge I_pla_312m5_clk)
begin
    if((I_xgmii_in_c1 == 4'b0111) && I_xgmii_in_d1[23:16] == 8'hfd)
        begin
            S_xgmii_in_end_flg1[2] <= 1'b1;
        end
    else
        begin
            S_xgmii_in_end_flg1[2] <= 1'b0;
        end
end

always @ (posedge I_pla_312m5_clk)
begin
    if((I_xgmii_in_c1 == 4'b0011) && I_xgmii_in_d1[15:8] == 8'hfd)
        begin
            S_xgmii_in_end_flg1[1] <= 1'b1;
        end
    else
        begin
            S_xgmii_in_end_flg1[1] <= 1'b0;
        end
end

always @ (posedge I_pla_312m5_clk)
begin
    if((I_xgmii_in_c1 == 4'b0001) && I_xgmii_in_d1[7:0] == 8'hfd)
        begin
            S_xgmii_in_end_flg1[0] <= 1'b1;
        end
    else
        begin
            S_xgmii_in_end_flg1[0] <= 1'b0;
        end
end

always @ (posedge I_pla_312m5_clk)
begin
    S_xgmii_in_end_flg0_buf1 <= S_xgmii_in_end_flg0;
    S_xgmii_in_end_flg1_buf1 <= S_xgmii_in_end_flg1;
    S_xgmii_in_end_flg0_buf2 <= S_xgmii_in_end_flg0_buf1;
    S_xgmii_in_end_flg1_buf2 <= S_xgmii_in_end_flg1_buf1;
end

always @ (posedge I_pla_312m5_clk)
begin
    if(|S_xgmii_in_end_flg0_buf2 || |S_xgmii_in_end_flg0_buf1)
        begin
            S_xgmii_fifo0_wdata <= {4'hf,32'h07070707};
            S_xgmii_fifo0_wr    <= 1'b1;
        end
    else
        begin
            S_xgmii_fifo0_wdata <= {S_xgmii_in_c0_buf1,S_xgmii_in_d0_buf1};
            S_xgmii_fifo0_wr    <= (!(&S_xgmii_in_c0_buf1) || |S_xgmii_in_end_flg0);
        end
end

always @ (posedge I_pla_312m5_clk)
begin
    if(|S_xgmii_in_end_flg1_buf2 || |S_xgmii_in_end_flg1_buf1)
        begin
            S_xgmii_fifo1_wdata <= {4'hf,32'h07070707};
            S_xgmii_fifo1_wr    <= 1'b1;
        end
    else
        begin
            S_xgmii_fifo1_wdata <= {S_xgmii_in_c1_buf1,S_xgmii_in_d1_buf1};
            S_xgmii_fifo1_wr    <= (!(&S_xgmii_in_c1_buf1) || |S_xgmii_in_end_flg1);
        end
end

always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_xmgii_fifo0_rd <= 1'b0;
        end
    else if((!S_xgmii_fifo0_empty) && !S_xmgii_fifo1_rd)
        begin
            S_xmgii_fifo0_rd <= 1'b1;
        end
    else if(S_xgmii_fifo0_rdata[35:28] == 8'hf0)
        begin
            S_xmgii_fifo0_rd <= 1'b0;
        end
end

always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_xmgii_fifo1_rd <= 1'b0;
        end
    else if((!S_xgmii_fifo1_empty) && S_xgmii_fifo0_empty && !S_xmgii_fifo0_rd)
        begin
            S_xmgii_fifo1_rd <= 1'b1;
        end
    else if(S_xgmii_fifo1_rdata[35:28] == 8'hf0 && S_xgmii_fifo1_empty)
        begin
            S_xmgii_fifo1_rd <= 1'b0;
        end
end


blk_com_fifo_1024x36 U0_blk_com_fifo_1024x36(
.I_fifo_clk      (I_pla_312m5_clk    ),
.I_fifo_rst      (I_pla_rst          ),
.I_fifo_din      (S_xgmii_fifo0_wdata),
.I_fifo_wr       (S_xgmii_fifo0_wr   ),
.I_fifo_rd       (S_xmgii_fifo0_rd   ),
.O_fifo_empty    (S_xgmii_fifo0_empty),
.O_fifo_full     (S_xgmii_fifo0_full),
.O_fifo_dout     (S_xgmii_fifo0_rdata),
.O_fifo_usedw    (S_xgmii_fifo0_usedw)
);


blk_com_fifo_4096x36_k7 U1_blk_com_fifo_1024x36(
.clk          (I_pla_312m5_clk    ),
.srst         (I_pla_rst          ),
.din          (S_xgmii_fifo1_wdata),
.wr_en        (S_xgmii_fifo1_wr   ),
.rd_en        (S_xmgii_fifo1_rd   ),
.empty        (S_xgmii_fifo1_empty),
.full         (S_xgmii_fifo1_full),
.dout         (S_xgmii_fifo1_rdata),
.data_count   (S_xgmii_fifo1_usedw)
);

always @ (posedge I_pla_312m5_clk)
begin
    S1_xmgii_fifo0_rd <= S_xmgii_fifo0_rd;
    S1_xmgii_fifo1_rd <= S_xmgii_fifo1_rd;
    S2_xmgii_fifo0_rd <= S1_xmgii_fifo0_rd;
    S2_xmgii_fifo1_rd <= S1_xmgii_fifo1_rd;   
    S1_xgmii_fifo0_rdata  <= S_xgmii_fifo0_rdata  ;
    S1_xgmii_fifo1_rdata  <= S_xgmii_fifo1_rdata  ;
     
end

always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_xgmii_out_d <= 32'h07070707;
            S_xgmii_out_c <= 4'hf ;
        end
    else
        begin
            case({S2_xmgii_fifo1_rd,S2_xmgii_fifo0_rd})
                2'b01 :
                begin
                    S_xgmii_out_d <= S1_xgmii_fifo0_rdata[31:0];
                    S_xgmii_out_c <= S1_xgmii_fifo0_rdata[35:32];
                end
                2'b10 :
                begin
                    S_xgmii_out_d <= S1_xgmii_fifo1_rdata[31:0];
                    S_xgmii_out_c <= S1_xgmii_fifo1_rdata[35:32];
                end
                default:
                begin
                    S_xgmii_out_d <= 32'h07070707;
                    S_xgmii_out_c <= 4'hf ;
                end
            endcase
        end
end

assign O_xgmii_out_d = S_xgmii_out_d;
assign O_xgmii_out_c = S_xgmii_out_c; 

endmodule
