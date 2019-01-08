//FILE_HEADER-----------------------------------------------------------------
//ZTE  Copyright (C)
//ZTE Company Confidential
//----------------------------------------------------------------------------
//Project Name : rcua_top
//FILE NAME    : pla_forward_framer_32bit.v
//AUTHOR       : xXX xxx                        
//Department   : Tianjin Development Department 
//Email        : sxxxx.xxx@zte.com.cn    
//----------------------------------------------------------------------------
//Module Hiberarchy :
//x                            |----U_dist_com_fifo_32x28 
//x                            |----U11_pla_id_num_chk
//x  pla_forward_framer_32bit--|----U12_for_crc_check
//----------------------------------------------------------------------------
//Relaese History :
//----------------------------------------------------------------------------
//Version         Date           Author        Description
// 1.0            2012-08-17     Sai Bin       New Generate
//----------------------------------------------------------------------------
//Main Function:提取XGMII报文参数，包含，HC标志，PTP标志，帧长、奇偶标志。
//----------------------------------------------------------------------------
//REUSE ISSUES: empty
//Reset Strategy: empty
//Clock Strategy: empty
//Critical Timing: empty
//Asynchronous Interface: empty
//END_HEADER------------------------------------------------------------------


`timescale 1ns/100ps
module pla_forward_framer_32bit(
input               I_pla_312m5_clk          , //// 时钟                
input               I_pla_rst                , //// 复位     
input               I_cnt_clear              , //// clear  
input     [47:0]    I_pla0_air_mac_0         , //// PLA0空口0 mac       
input     [47:0]    I_pla0_air_mac_1         , //// PLA0空口1 mac       
input     [47:0]    I_pla0_air_mac_2         , //// PLA0空口2 mac       
input     [47:0]    I_pla0_air_mac_3         , //// PLA0空口3 mac       
input     [47:0]    I_pla0_air_mac_4         , //// PLA0空口4 mac       
input     [47:0]    I_pla0_air_mac_5         , //// PLA0空口5 mac       
input     [47:0]    I_pla0_air_mac_6         , //// PLA0空口6 mac       
input     [47:0]    I_pla0_air_mac_7         , //// PLA0空口7 mac       
input     [47:0]    I_pla1_air_mac_0         , //// PLA1空口0 mac       
input     [47:0]    I_pla1_air_mac_1         , //// PLA1空口1 mac       
input     [47:0]    I_pla1_air_mac_2         , //// PLA1空口2 mac       
input     [47:0]    I_pla1_air_mac_3         , //// PLA1空口3 mac       
input     [47:0]    I_pla1_air_mac_4         , //// PLA1空口4 mac       
input     [47:0]    I_pla1_air_mac_5         , //// PLA1空口5 mac       
input     [47:0]    I_pla1_air_mac_6         , //// PLA1空口6 mac       
input     [47:0]    I_pla1_air_mac_7         , //// PLA1空口7 mac       
input     [47:0]    I_pla2_air_mac_0         , //// PLA2空口0 mac       
input     [47:0]    I_pla2_air_mac_1         , //// PLA2空口1 mac       
input     [47:0]    I_pla2_air_mac_2         , //// PLA2空口2 mac       
input     [47:0]    I_pla2_air_mac_3         , //// PLA2空口3 mac       
input     [47:0]    I_pla2_air_mac_4         , //// PLA2空口4 mac       
input     [47:0]    I_pla2_air_mac_5         , //// PLA2空口5 mac       
input     [47:0]    I_pla2_air_mac_6         , //// PLA2空口6 mac       
input     [47:0]    I_pla2_air_mac_7         , //// PLA2空口7 mac       
input     [47:0]    I_pla0_rcu_mac           , //// 切片发送源mac     
input     [47:0]    I_pla1_rcu_mac           , //// 切片发送源mac  
input     [47:0]    I_pla2_rcu_mac           , //// 切片发送源mac  
input     [1:0]     I_rcub_chk_sel           ,
  
input     [7:0]     I_buff0_frame_ready      , //// Pla_slice	BUFF0的存储完毕切片,可以组帧 
input     [7:0]     I_buff1_frame_ready      , //// Pla_slice	BUFF1的存储完毕切片,可以组帧 
input     [7:0]     I_buff2_frame_ready      , //// Pla_slice	BUFF2的存储完毕切片,可以组帧 
input     [23:0]    I_slice0_fifo_parameter  , //// 切片ID和切片发送方向
input     [23:0]    I_slice1_fifo_parameter  , //// 切片ID和切片发送方向
input     [23:0]    I_slice2_fifo_parameter  , //// 切片ID和切片发送方向
input     [7:0]     I_slice0_fifo_empty      , //// PLA0 切片fifo空标志 
input     [7:0]     I_slice1_fifo_empty      , //// PLA1 切片fifo空标志 
input     [7:0]     I_slice2_fifo_empty      , //// PLA2 切片fifo空标志 
input     [31:0]    I_slice0_fifo_rdata      , //// PLA0 切片fifo读数据 
input     [31:0]    I_slice1_fifo_rdata      , //// PLA1 切片fifo读数据 
input     [31:0]    I_slice2_fifo_rdata      , //// PLA2 切片fifo读数据 
output    [7:0]     O_slice0_fifo_rd         , //// PLA0 切片fifo读使能 
output    [7:0]     O_slice1_fifo_rd         , //// PLA1 切片fifo读使能 
output    [7:0]     O_slice2_fifo_rd         , //// PLA2 切片fifo读使能                     
output    [31:0]    O_xgmii_pla_slice_txd    , //// 切片报文数据        
output    [3:0]     O_xgmii_pla_slice_txc    , //// 切片报文控制  
output    [1:0]     O_xgmii_pla_slice_num    , //// 切片报文控制   
output    [15:0]    O_for_framer_55D5_cnt        ,
output    [15:0]    O_for_framer_lose_cnt        ,
output              O_for_framer_lose_reg        ,
output reg [15:0]   O_for_framer_err_cnt         ,
output reg [15:0]   O_for_frame_cnt          //// 切片报文控制      
);

parameter      C_FRAMER_IDLE    = 3'd0,
               C_FRAMER_PRE     = 3'd1,
               C_FRAMER_MAC     = 3'd2,
               C_FRAMER_ID      = 3'd3,
               C_FRAMER_PAYLOAD = 3'd4,
               C_FRAMER_CRC     = 3'd5;

reg   [2:0]    S_framer_state_current      = 3'd0 ;
reg   [2:0]    S1_framer_state_current     = 3'd0 ;
reg   [5:0]    S_buff0_frame_ready         = 6'b0 ;
reg   [5:0]    S_buff1_frame_ready         = 6'b0 ;
reg   [5:0]    S_buff2_frame_ready         = 6'b0 ;

reg   [23:0]   S_slice0_fifo_para_lck      = 24'd0;
reg   [23:0]   S_slice1_fifo_para_lck      = 24'd0;
reg   [23:0]   S_slice2_fifo_para_lck      = 24'd0;

reg   [7:0]    S_slice0_fifo_rden          = 8'd0 ;
reg   [7:0]    S_slice1_fifo_rden          = 8'd0 ;
reg   [7:0]    S_slice2_fifo_rden          = 8'd0 ;
reg   [1:0]    S_slice_para_fifo_wrcnt     = 2'b0 ;

reg   [27:0]   S_slice_para_fifo_wdata     = 28'd0;
reg            S_slice_para_fifo_wr        = 1'd0 ;
reg            S_slice_para_fifo_rden      = 1'b0 ;
reg   [1:0]    S1_slice_para_fifo_rden     = 2'b0 ;
wire  [27:0]   S_slice_para_fifo_rdata            ;
(* max_fanout = 80 *) reg   [27:0]   S1_slice_para_fifo_rdata    = 28'd0;
wire           S_slice_para_fifo_empty            ;
wire           S_slice_para_fifo_full;

wire  [5:0]    S_slice_para_fifo_count            ;

reg            S_xgmii_pla_slice_ready     = 1'b1 ;
reg   [31:0]   S_xgmii_pla_slice_txd       = 32'h07070707;
reg   [3:0]    S_xgmii_pla_slice_txc       = 4'hf ;

reg   [6:0]    S_slice_framer_cnt          = 7'd0 ;
reg   [47:0]   S_slice0_framer_da          = 48'd0;
reg   [47:0]   S_slice1_framer_da          = 48'd0;
reg   [47:0]   S_slice2_framer_da          = 48'd0;
reg   [47:0]   S_slice_framer_da           = 48'd0;
reg   [47:0]   S_slice_framer_sa           = 48'd0;
reg   [31:0]   S_slice0_fifo_rdata         = 32'd0;
reg   [31:0]   S_slice1_fifo_rdata         = 32'd0;
reg   [31:0]   S_slice2_fifo_rdata         = 32'd0;

reg   [31:0]   S_slice_framer_rdata        = 32'd0;
reg   [31:0]   S1_slice_framer_rdata       = 32'd0;

reg   [31:0]   S_xgmii_crc_data            = 32'h07070707;
reg   [3:0]    S_xgmii_crc_ctrl            = 4'hf ;
reg   [31:0]   S1_xgmii_crc_data           = 32'h07070707;
reg   [3:0]    S1_xgmii_crc_ctrl           = 4'hf ;

reg            S_xgmii_crc_rst             = 1'b0 ;
reg            S_xgmii_crc_d32_en          = 1'b0 ;
reg            S_xgmii_crc_d16_en          = 1'b0 ;
reg            S1_xgmii_crc_d16_en         = 1'b0 ;
reg            S2_xgmii_crc_d16_en         = 1'b0 ;


reg   [1:0]    S_xgmii_num   =  2'd0;
reg   [1:0]    S1_xgmii_num   =  2'd0;
reg   [1:0]    S2_xgmii_num   =  2'd0;
reg   [1:0]    S3_xgmii_num   =  2'd0;

wire  [31:0]   S_xgmii_crc_pre                    ;
wire  [31:0]   S_xgmii_crc_out                    ;


reg   [3:0]   S_pla_slice_en        ;//// PLA切片fifo读使能   
reg   [31:0]  S_pla_slice_payload ;
reg   [14:0]  S_pla_slice_id ;



always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S_buff0_frame_ready <= 6'd0;
        S_buff1_frame_ready <= 6'd0;
        S_buff2_frame_ready <= 6'd0;
    end
    else
    begin
        S_buff0_frame_ready <= {S_buff0_frame_ready[4:0],|I_buff0_frame_ready};    
        S_buff1_frame_ready <= {S_buff1_frame_ready[4:0],|I_buff1_frame_ready}; 
        S_buff2_frame_ready <= {S_buff2_frame_ready[4:0],|I_buff2_frame_ready};   
    end           
end

always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S_slice0_fifo_para_lck <= 24'd0;
        S_slice1_fifo_para_lck <= 24'd0;
        S_slice2_fifo_para_lck <= 24'd0;
    end
    else
    begin
        if(|I_slice0_fifo_parameter[7:0])
        begin
            S_slice0_fifo_para_lck <= I_slice0_fifo_parameter;
        end
        if(|I_slice1_fifo_parameter[7:0])
        begin
            S_slice1_fifo_para_lck <= I_slice1_fifo_parameter;
        end
        if(|I_slice2_fifo_parameter[7:0])
        begin
            S_slice2_fifo_para_lck <= I_slice2_fifo_parameter;
        end
    end    
end

always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S_slice_para_fifo_wrcnt <= 2'd0;
    end
    else
    begin
        if(S_slice_para_fifo_wrcnt == 2'b10)
        begin
            S_slice_para_fifo_wrcnt <= 2'b0;
        end
        else
        begin
            S_slice_para_fifo_wrcnt <= S_slice_para_fifo_wrcnt + 2'b1;
        end
    end        
end

always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S_slice_para_fifo_wdata <= 28'd0;
        S_slice_para_fifo_wr    <= 1'b0;
    end
    else
    begin
        case(S_slice_para_fifo_wrcnt)
            2'b00 :
            begin
                if(S_buff0_frame_ready[3] ||S_buff0_frame_ready[4] ||S_buff0_frame_ready[5])
                    begin
                        S_slice_para_fifo_wdata <= {2'b0,2'b00,S_slice0_fifo_para_lck};
                        S_slice_para_fifo_wr    <= 1'b1;
                    end
                else
                    begin
                        S_slice_para_fifo_wdata <= S_slice_para_fifo_wdata;
                        S_slice_para_fifo_wr    <= 1'b0;
                    end
            end
            2'b01 :
            begin
                if(S_buff1_frame_ready[3] ||S_buff1_frame_ready[4] ||S_buff1_frame_ready[5])
                    begin
                        S_slice_para_fifo_wdata <= {2'b0,2'b01,S_slice1_fifo_para_lck};
                        S_slice_para_fifo_wr    <= 1'b1;
                    end
                else
                    begin
                        S_slice_para_fifo_wdata <= S_slice_para_fifo_wdata;
                        S_slice_para_fifo_wr    <= 1'b0;
                    end
            end
            2'b10 :
            begin
                if(S_buff2_frame_ready[3] ||S_buff2_frame_ready[4] ||S_buff2_frame_ready[5])
                    begin
                        S_slice_para_fifo_wdata <= {2'b0,2'b10,S_slice2_fifo_para_lck};
                        S_slice_para_fifo_wr    <= 1'b1;
                    end
                else
                    begin
                        S_slice_para_fifo_wdata <= S_slice_para_fifo_wdata;
                        S_slice_para_fifo_wr    <= 1'b0;
                    end
            end
            default:
            begin
                S_slice_para_fifo_wdata <= S_slice_para_fifo_wdata;
                S_slice_para_fifo_wr    <= 1'b0;
            end
        endcase
    end    
end

always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S_xgmii_pla_slice_ready <= 1'b1;
    end
    else
    begin
        if(S_framer_state_current == C_FRAMER_CRC)         
        begin
            S_xgmii_pla_slice_ready <= 1'b1;
        end
        else if(S_slice_para_fifo_rden)
        begin
            S_xgmii_pla_slice_ready <= 1'b0;
        end
    end   
end

always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S_slice_para_fifo_rden <= 1'b0;
    end
    else
    begin
        if(S_xgmii_pla_slice_ready && !S_slice_para_fifo_rden && !S_slice_para_fifo_empty)
        begin
            S_slice_para_fifo_rden <= 1'b1;
        end
        else
        begin
            S_slice_para_fifo_rden <= 1'b0;
        end
    end   
end

always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
        S1_slice_para_fifo_rden <= 2'b0;
    else
        S1_slice_para_fifo_rden <= {S1_slice_para_fifo_rden[0],S_slice_para_fifo_rden}  ;
end

dist_com_fifo_32x28 U_dist_com_fifo_32x28(
	.I_fifo_clk       (I_pla_312m5_clk        ),
	.I_fifo_rst       (I_pla_rst              ),
	.I_fifo_din       (S_slice_para_fifo_wdata),
	.I_fifo_wr        (S_slice_para_fifo_wr   ),
	.I_fifo_rd        (S_slice_para_fifo_rden  ),
	.O_fifo_dout      (S_slice_para_fifo_rdata),
	.O_fifo_full      (S_slice_para_fifo_full ),                       
	.O_fifo_empty     (S_slice_para_fifo_empty ),
	.O_fifo_usedw     (S_slice_para_fifo_count )                        
);                                        


always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S1_slice_para_fifo_rdata <=  28'd0;
    end
    else 
    begin
        S1_slice_para_fifo_rdata <= S_slice_para_fifo_rdata;
    end
end

always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S_slice0_fifo_rden <= 8'd0;
    end
    else 
    begin
        if(S1_slice_para_fifo_rden[1] && (S1_slice_para_fifo_rdata[25:24] == 2'b00))
        begin
            S_slice0_fifo_rden <= S1_slice_para_fifo_rdata[7:0];
        end
        else if(|(S_slice0_fifo_rden & I_slice0_fifo_empty))
        begin
            S_slice0_fifo_rden <= 8'd0;
        end
    end    
end

always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S_slice1_fifo_rden <= 8'd0;
    end
    else 
    begin
        if(S1_slice_para_fifo_rden[1] && (S1_slice_para_fifo_rdata[25:24] == 2'b01))
        begin
            S_slice1_fifo_rden <= S1_slice_para_fifo_rdata[7:0];
        end
        else if(|(S_slice1_fifo_rden & I_slice1_fifo_empty))
        begin
            S_slice1_fifo_rden <= 8'd0;
        end
    end    
end

always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S_slice2_fifo_rden <= 8'd0;
    end
    else 
    begin
       if(S1_slice_para_fifo_rden[1] && (S1_slice_para_fifo_rdata[25:24] == 2'b10))
       begin
           S_slice2_fifo_rden <= S1_slice_para_fifo_rdata[7:0];
       end
       else if(|(S_slice2_fifo_rden & I_slice2_fifo_empty))
       begin
           S_slice2_fifo_rden <= 8'd0;
       end
   end    
end

assign O_slice0_fifo_rd = S_slice0_fifo_rden;
assign O_slice1_fifo_rd = S_slice1_fifo_rden;
assign O_slice2_fifo_rd = S_slice2_fifo_rden;

always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S_slice0_framer_da <= 48'd0;
    end
    else 
    begin
        case(S1_slice_para_fifo_rdata[7:0])
            8'b00000001 : S_slice0_framer_da <= I_pla0_air_mac_0;
            8'b00000010 : S_slice0_framer_da <= I_pla0_air_mac_1;
            8'b00000100 : S_slice0_framer_da <= I_pla0_air_mac_2;
            8'b00001000 : S_slice0_framer_da <= I_pla0_air_mac_3;
            8'b00010000 : S_slice0_framer_da <= I_pla0_air_mac_4;
            8'b00100000 : S_slice0_framer_da <= I_pla0_air_mac_5;
            8'b01000000 : S_slice0_framer_da <= I_pla0_air_mac_6;
            8'b10000000 : S_slice0_framer_da <= I_pla0_air_mac_7;
            default:      S_slice0_framer_da <= 48'd0;
        endcase
    end
end

always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S_slice1_framer_da <= 48'd0;
    end
    else 
    begin
        case(S1_slice_para_fifo_rdata[7:0])
            8'b00000001 : S_slice1_framer_da <= I_pla1_air_mac_0;
            8'b00000010 : S_slice1_framer_da <= I_pla1_air_mac_1;
            8'b00000100 : S_slice1_framer_da <= I_pla1_air_mac_2;
            8'b00001000 : S_slice1_framer_da <= I_pla1_air_mac_3;
            8'b00010000 : S_slice1_framer_da <= I_pla1_air_mac_4;
            8'b00100000 : S_slice1_framer_da <= I_pla1_air_mac_5;
            8'b01000000 : S_slice1_framer_da <= I_pla1_air_mac_6;
            8'b10000000 : S_slice1_framer_da <= I_pla1_air_mac_7;
            default:      S_slice1_framer_da <= 48'd0;
        endcase
    end
end

always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S_slice2_framer_da <= 48'd0;
    end
    else 
    begin
        case(S1_slice_para_fifo_rdata[7:0])
            8'b00000001 : S_slice2_framer_da <= I_pla2_air_mac_0;
            8'b00000010 : S_slice2_framer_da <= I_pla2_air_mac_1;
            8'b00000100 : S_slice2_framer_da <= I_pla2_air_mac_2;
            8'b00001000 : S_slice2_framer_da <= I_pla2_air_mac_3;
            8'b00010000 : S_slice2_framer_da <= I_pla2_air_mac_4;
            8'b00100000 : S_slice2_framer_da <= I_pla2_air_mac_5;
            8'b01000000 : S_slice2_framer_da <= I_pla2_air_mac_6;
            8'b10000000 : S_slice2_framer_da <= I_pla2_air_mac_7;
            default:      S_slice2_framer_da <= 48'd0;
        endcase
    end    
end

always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S_slice_framer_da <= 48'd0;
        S_slice_framer_sa <= 48'd0;
        S_xgmii_num <= 2'd0;
    end
    else 
    begin
       case(S1_slice_para_fifo_rdata[25:24])
           2'b00 : begin S_slice_framer_da <= S_slice0_framer_da; S_xgmii_num <= 2'd0; S_slice_framer_sa <= I_pla0_rcu_mac ; end
           2'b01 : begin S_slice_framer_da <= S_slice1_framer_da; S_xgmii_num <= 2'd1; S_slice_framer_sa <= I_pla1_rcu_mac ; end
           2'b10 : begin S_slice_framer_da <= S_slice2_framer_da; S_xgmii_num <= 2'd2; S_slice_framer_sa <= I_pla2_rcu_mac ; end
           default:;
       endcase
    end    
end

always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S_slice0_fifo_rdata <= 32'd0;
        S_slice1_fifo_rdata <= 32'd0;
        S_slice2_fifo_rdata <= 32'd0;
    end    
    else
    begin
        S_slice0_fifo_rdata <= I_slice0_fifo_rdata;
        S_slice1_fifo_rdata <= I_slice1_fifo_rdata;
        S_slice2_fifo_rdata <= I_slice2_fifo_rdata;
    end
end

always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S_slice_framer_rdata <= 32'd0;
    end    
    else
    begin
        case(S1_slice_para_fifo_rdata[25:24])
            2'b00 : S_slice_framer_rdata <= S_slice0_fifo_rdata;
            2'b01 : S_slice_framer_rdata <= S_slice1_fifo_rdata;
            2'b10 : S_slice_framer_rdata <= S_slice2_fifo_rdata;
            default:;
        endcase
    end    
end


always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S1_slice_framer_rdata <= 32'd0;
        S1_framer_state_current <= 3'd0;
    end    
    else 
    begin
        S1_slice_framer_rdata <= S_slice_framer_rdata;
        S1_framer_state_current <= S_framer_state_current;
    end
end


always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S_framer_state_current <= C_FRAMER_IDLE;
    end
    else
    begin
        case(S_framer_state_current)
            C_FRAMER_IDLE    :
            begin
                if(S1_slice_para_fifo_rden[0])
                    S_framer_state_current <= C_FRAMER_PRE;
                else
                    S_framer_state_current <= C_FRAMER_IDLE;
            end
            C_FRAMER_PRE     :
            begin
                if(S_slice_framer_cnt[0])
                    S_framer_state_current <= C_FRAMER_MAC;
                else
                    S_framer_state_current <= C_FRAMER_PRE;
            end
            C_FRAMER_MAC     :
            begin
                if(S_slice_framer_cnt[1])
                    S_framer_state_current <= C_FRAMER_ID;
                else
                    S_framer_state_current <= C_FRAMER_MAC;
            end
            C_FRAMER_ID      :
            begin
                S_framer_state_current <= C_FRAMER_PAYLOAD;
            end
            C_FRAMER_PAYLOAD :
            begin
                if(S_slice_framer_cnt == 7'd62)
                    S_framer_state_current <= C_FRAMER_CRC;
                else
                    S_framer_state_current <= C_FRAMER_PAYLOAD;
                end
            C_FRAMER_CRC     :
            begin
                S_framer_state_current <= C_FRAMER_IDLE;
            end
            default:
            begin
                S_framer_state_current <= C_FRAMER_IDLE;
            end    
        endcase
    end    
end


always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S_slice_framer_cnt <= 7'd0;
    end
    else 
    begin
        case(S_framer_state_current)  ///  
            C_FRAMER_PRE     :
            begin
                if(S_slice_framer_cnt[0])
                begin
                    S_slice_framer_cnt <= 7'd0;
                end
                else
                begin
                    S_slice_framer_cnt <= S_slice_framer_cnt + 7'd1;
                end
            end
            C_FRAMER_MAC     :
            begin
                if(S_slice_framer_cnt[1])
                begin
                    S_slice_framer_cnt <= 7'd0;
                end
                else
                begin
                    S_slice_framer_cnt <= S_slice_framer_cnt + 7'd1;
                end
            end
            C_FRAMER_PAYLOAD :
            begin
                if(S_slice_framer_cnt == 7'd63)
                begin
                    S_slice_framer_cnt <= 7'd0;
                end
                else
                begin
                    S_slice_framer_cnt <= S_slice_framer_cnt + 7'd1;
                end
            end
            default:
            begin
                S_slice_framer_cnt <= 7'd0;
            end
        endcase
    end
end

always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S_xgmii_crc_data   <= 32'h07070707;
        S_xgmii_crc_ctrl   <= 4'hf;
        S_xgmii_crc_d32_en <= 1'b0;
        S_xgmii_crc_d16_en <= 1'b0;
        S_xgmii_crc_rst    <= 1'b0;
    end
    else
    begin
    case(S1_framer_state_current)          
        C_FRAMER_PRE :
        begin
            if(S_slice_framer_cnt[0])
                begin
                    S_xgmii_crc_data   <= 32'hfb555555;
                    S_xgmii_crc_ctrl   <= 4'h8;
                    S_xgmii_crc_d32_en <= 1'b0;
                    S_xgmii_crc_d16_en <= 1'b0;
                    S_xgmii_crc_rst    <= 1'b1;
                end
            else
                begin
                    S_xgmii_crc_data   <= 32'h555555d5;
                    S_xgmii_crc_ctrl   <= 4'b0;
                    S_xgmii_crc_d32_en <= 1'b0;
                    S_xgmii_crc_d16_en <= 1'b0;
                    S_xgmii_crc_rst    <= 1'b0;                    
                end
        end
        C_FRAMER_MAC :
        begin
            case(S_slice_framer_cnt[1:0])
                2'b01 :
                begin
                    S_xgmii_crc_data   <= S_slice_framer_da[47:16];
                    S_xgmii_crc_ctrl   <= 4'h0;
                    S_xgmii_crc_d32_en <= 1'b1;
                    S_xgmii_crc_d16_en <= 1'b0;
                    S_xgmii_crc_rst    <= 1'b0;
                end
                2'b10 :
                begin
                    S_xgmii_crc_data   <= {S_slice_framer_da[15:0],S_slice_framer_sa[47:32]};    
                    S_xgmii_crc_ctrl   <= 4'h0;                                             
                    S_xgmii_crc_d32_en <= 1'b1;                                             
                    S_xgmii_crc_d16_en <= 1'b0;
                    S_xgmii_crc_rst    <= 1'b0;
                end
                2'b00 :
                begin
                    S_xgmii_crc_data   <= S_slice_framer_sa[31:0];
                    S_xgmii_crc_ctrl   <= 4'h0;
                    S_xgmii_crc_d32_en <= 1'b1;
                    S_xgmii_crc_d16_en <= 1'b0;
                    S_xgmii_crc_rst    <= 1'b0;
                end
                default :;
            endcase
        end
        C_FRAMER_ID :
        begin
            S_xgmii_crc_data   <= {1'b0,S1_slice_para_fifo_rdata[22:8],S_slice_framer_rdata[31:16]};
            S_xgmii_crc_ctrl   <= 4'h0;
            S_xgmii_crc_d32_en <= 1'b1;
            S_xgmii_crc_d16_en <= 1'b0;
            S_xgmii_crc_rst    <= 1'b0;
        end
        C_FRAMER_PAYLOAD :
        begin
            S_xgmii_crc_data   <= {S1_slice_framer_rdata[15:0],S_slice_framer_rdata[31:16]};
            S_xgmii_crc_ctrl   <= 4'h0;
            S_xgmii_crc_d32_en <= 1'b1;
            S_xgmii_crc_d16_en <= 1'b0;
            S_xgmii_crc_rst    <= 1'b0;
        end
        C_FRAMER_CRC :
        begin
            S_xgmii_crc_data   <= {S1_slice_framer_rdata[15:0],16'd0};
            S_xgmii_crc_ctrl   <= 4'h0;
            S_xgmii_crc_d32_en <= 1'b0;
            S_xgmii_crc_d16_en <= 1'b1;
            S_xgmii_crc_rst    <= 1'b0;
        end
        default:
        begin
            S_xgmii_crc_data   <= 32'h07070707;
            S_xgmii_crc_ctrl   <= 4'hf;
            S_xgmii_crc_d32_en <= 1'b0;
            S_xgmii_crc_d16_en <= 1'b0;
            S_xgmii_crc_rst    <= 1'b0;
        end
    endcase
    end
end

always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S1_xgmii_crc_data  <= 32'h07070707;
        S1_xgmii_crc_ctrl  <= 4'hf ;
        S1_xgmii_crc_d16_en <= 1'd0;
        S2_xgmii_crc_d16_en <= 1'd0;
        S1_xgmii_num   <=  2'd0;
        S2_xgmii_num   <=  2'd0;
        S3_xgmii_num   <=  2'd0;
    end
    else 
    begin
        S1_xgmii_crc_data <= S_xgmii_crc_data ; 
        S1_xgmii_crc_ctrl <= S_xgmii_crc_ctrl ;
        S1_xgmii_crc_d16_en <= S_xgmii_crc_d16_en ;
        S2_xgmii_crc_d16_en <= S1_xgmii_crc_d16_en;    
        S1_xgmii_num   <=  S_xgmii_num;
        S2_xgmii_num   <=  S1_xgmii_num;
        S3_xgmii_num   <=  S2_xgmii_num;
    end    
end


always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S_xgmii_pla_slice_txd <= 32'h07070707;
        S_xgmii_pla_slice_txc <= 4'hf;
    end
    else 
    begin
        if(S1_xgmii_crc_d16_en)
        begin
            S_xgmii_pla_slice_txd <= {S1_xgmii_crc_data[31:16],S_xgmii_crc_out[31:16]};
            S_xgmii_pla_slice_txc <= 4'h0;
        end
        else if(S2_xgmii_crc_d16_en)
        begin
            S_xgmii_pla_slice_txd <= {S_xgmii_crc_out[15:0],16'hfd07};
            S_xgmii_pla_slice_txc <= 4'h3;
        end
        else
        begin
            S_xgmii_pla_slice_txd <= S1_xgmii_crc_data;
            S_xgmii_pla_slice_txc <= S1_xgmii_crc_ctrl;
        end
    end        
end



always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        O_for_frame_cnt <= 16'h0;
    end
    else if(I_cnt_clear)
    begin
        O_for_frame_cnt <= 16'h0;
    end
    else if(S2_xgmii_crc_d16_en)
    begin
        O_for_frame_cnt <= O_for_frame_cnt +16'd1;
    end        
end

assign O_xgmii_pla_slice_txd = S_xgmii_pla_slice_txd;
assign O_xgmii_pla_slice_txc = S_xgmii_pla_slice_txc;
assign O_xgmii_pla_slice_num = S3_xgmii_num;


crc32_d32 U_crc32_d32(
.c           (S_xgmii_crc_pre       ),
.crc_out     (),
.d           (S_xgmii_crc_data      ),
.calc        (1'b1                  ),
.init        (S_xgmii_crc_rst       ),
.d_valid     (S_xgmii_crc_d32_en    ),
.clk         (I_pla_312m5_clk       ),
.reset       (I_pla_rst             )
); 

crc32_d16 U_crc32_d16(
.c           (        ),
.crc_out     (S_xgmii_crc_out        ),
.result_pre  (S_xgmii_crc_pre        ),
.d           (S_xgmii_crc_data[31:16]),
.calc        (1'b1                   ),
.init        (S_xgmii_crc_rst        ),
.d_valid     (S_xgmii_crc_d16_en     ),
.clk         (I_pla_312m5_clk        ),
.reset       (I_pla_rst              )
);



always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S_pla_slice_en <= 2'd0;
    end
    else 
    begin
        S_pla_slice_en[1] <= S_pla_slice_en[0];  
        S_pla_slice_en[2] <= S_pla_slice_en[1];
        S_pla_slice_en[3] <= S_pla_slice_en[0] && S_pla_slice_en[2]; 
    end
end

always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S_pla_slice_payload <= 32'h07070707;
        S_pla_slice_id      <= 15'b0;
    end
    else if(I_rcub_chk_sel == 2'd0)
    begin
        S_pla_slice_id       <= S_slice0_fifo_para_lck[22:8]; 
        S_pla_slice_payload  <= S_slice0_fifo_rdata         ;    
        S_pla_slice_en       <= S_slice0_fifo_rden;
    end
    else if(I_rcub_chk_sel == 2'd1)
    begin
        S_pla_slice_id       <= S_slice1_fifo_para_lck[22:8]; 
        S_pla_slice_payload  <= S_slice1_fifo_rdata         ; 
        S_pla_slice_en       <= S_slice1_fifo_rden;
    end
    else 
    begin
        S_pla_slice_id       <= S_slice2_fifo_para_lck[22:8]; 
        S_pla_slice_payload  <= S_slice2_fifo_rdata         ; 
        S_pla_slice_en       <= S_slice2_fifo_rden;
    end
end


//写的SLICE ID顺序检测
pla_id_seq_chk U11_pla_id_num_chk
(
.I_pla_312m5_clk         (I_pla_312m5_clk              ) ,
.I_pla_rst               (I_pla_rst                    ) ,
.I_pla_slice_id          (S_pla_slice_id               ) ,
.I_pla_slice_payload     (S_pla_slice_payload          ) ,
.I_pla_slice_en          (S_pla_slice_en[3]            ) ,
.I_cnt_clear             (I_cnt_clear                  ) ,
.O_slice_55D5_cnt        (        ) , 
.O_slice_lose_cnt        (O_for_framer_lose_cnt        ) ,
.O_slice_lose_reg        (O_for_framer_lose_reg        ) 
);


pla_for_crc_chk U12_for_crc_check (
 .I_pla_rst    	         (I_pla_rst               ),  
 .I_pla_312m5_clk	       (I_pla_312m5_clk         ),
 .I_cnt_clear            (I_cnt_clear             ), 
 .I_xgmii_data           (O_xgmii_pla_slice_txd   ),   
 .I_xgmii_txc            (O_xgmii_pla_slice_txc   ),
 .O_crc_err_reg          (          ),
 .O_crc_ok_cnt           (    ),
 .O_crc_err_cnt          (O_for_framer_55D5_cnt   )    
); 

always @ (posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        O_for_framer_err_cnt <= 16'h0;
    end
    else if(I_cnt_clear)
    begin
        O_for_framer_err_cnt <= 16'h0;
    end
    else if(S_slice_para_fifo_full)
    begin
        O_for_framer_err_cnt <= O_for_framer_err_cnt +16'd1;
    end        
end


endmodule
