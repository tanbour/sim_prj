//FILE_HEADER-----------------------------------------------------------------
//ZTE  Copyright (C)
//ZTE Company Confidential
//----------------------------------------------------------------------------
//Project Name : rcua_top
//FILE NAME    : pla_flow.v
//AUTHOR       : Sai Bin
//Department   : Tianjin Development Department 
//Email        : sai.bin@zte.com.cn
//----------------------------------------------------------------------------
//Module Hiberarchy :
//x                            |----U01_blk_com_fifo_256x32 
//x                            |----U02_frame_fifo_256x32
//x  pla_forward_slice_32bit---|----U03_frame_fifo_16x24
//x                            |----
//----------------------------------------------------------------------------
//Relaese History :
//----------------------------------------------------------------------------
//Version         Date           Author        Description
// 1.0            2012-08-17     Sai Bin       New Generate
//----------------------------------------------------------------------------
//Main Function:
//a)��ģ����Ҫ�ǽ���ǰ�����ģ�����Ƭ��������,����fifo�ǿյ������,��ȡ���ݽ�
//  ��256Byte���ȵ���Ƭ������ͬʱ,��ģ�黹ά��һ����ƬID������,������Ƭ���ʱ,
//  ����ƬID�Ͷ�Ӧ����Ƭ�տڷ����͸�ǰ�����ģ�顣��ģ���������ζ�Ӧ����PLA��
//----------------------------------------------------------------------------
//REUSE ISSUES: empty
//Reset Strategy: empty
//Clock Strategy: empty
//Critical Timing: empty
//Asynchronous Interface: empty
//END_HEADER------------------------------------------------------------------

`timescale 1ns/1ns

module pla_forward_slice_32bit
(                   
    input             I_pla_312m5_clk           ,   ///ʱ��                    
    input             I_pla_rst                 ,   ///��λ     
    input             I_cnt_clear               ,               
    
    ////����ģ��Ľӿ�                  
    input             I_pla_tc_en               ,   ///CPU���õĶ�����ʹ��   
    input      [7:0]  I_pla_tc_index            ,   ///PTP��Ƭ���ͷ���         
    input      [7:0]  I_pla_slice_send_req      ,   ///����ģ�鷢�͵���Ƭ����   
    ///flowģ��ӿ�            
    input             I_flow_fifo_empty         ,   ///��FIFO��λ�ձ�־        
    input      [33:0] I_flow_fifo_rdata         ,   ///��FIFO������        
    input      [33:0] I_flow_fifo_next_rdata    ,   ///��FIFO��һ������    
                   
    ///��֡ģ��ӿ�   
    input      [7:0]  I_slice_fifo2_rd          ,   ///��֡ģ�鷢�͵�slice fifo�������ź�     
                      
    output reg [31:0] O_slice_fifo_rdata        ,   ///��Ƭfifo������                 
    output reg [7:0]  O_slice_fifo_empty        ,   ///ǰ��fifo�ձ�־                 
    output reg [23:0] O_slice_fifo_parameter    ,   ///��ƬID����Ƭ���ͷ���          
    output reg        O_slice_ptp_req           ,   ///PTP��Ƭ��������:O_pla_slice_tc_send_req ,ע��O_slice_fifo_empty ��PTP�����ж�Ӧ�Ĺ�ϵ             
    output reg        O_slice_fifo_idle         ,   ///��Ƭ����,��ʾ������Ƭ��,������׼����Ƭ,����������request busy....
           
    output reg        O_flow_fifo_rden          ,   ///��fifo��ʹ��,�ߵ͹���        
    output reg        O_flow_fifo_pt            ,   ///����ָ��                       
    output reg [79:0] O_slice_fifo_len_err      ,   ///���ԼĴ���

    ///��ǰģ�鱣���Ľӿ�
    
    output reg [7:0]  O_buff_frame_ready        ,   ///Pla_slice	BUFF�Ĵ洢�����Ƭ,������֡
    output reg [7:0]  O_buff_data_length            ///ͳ���͵�buff�о��ɵĳ���,������֡(include 253data + 1id)
);                                                   

reg [14:0]  S_pla_slice_id        ; ///max 'd8096 ,[8 :0],bits of real physical space,C_SLICE_ID_PHY_MAX == 'd1024*3/4
reg [5:0]   S_flow_fifo_empty     ;
reg [7:0]   S_pla_slice_send_req  ;
reg         S_zero_flag;
reg         S1_zero_flag;
reg [6:0]   S_flow_rdcnt;
reg         S_ptp_slice_zero;
reg         S_new_slice_ready    ;  ///���Կ�ʼ����Ƭ��׼������            
reg         S1_new_slice_ready   ; 
reg         S_ff_rden            ;  ///��fifo�ľ��ɼ���ʹ��,�ᴩ������Ƭ����
reg [5:0]   S1_ff_rden           ;          
reg [7:0]   S_ff_rd_cnt          ;  ///��fifo�ľ�������
reg [7:0]   S_buff_wr_flag       ; 
    
reg         S_slice_ptp_flg       ;
reg  [7:0]  S_slice_fifo_ind      ;

reg  [31:0] S_slice_fifo1_wrdata  ;
reg         S_slice_fifo1_wren    ;
reg         S_slice_fifo1_rden    ;
wire [31:0] S_slice_fifo1_rdata   ;
wire        S_slice_fifo1_empty   ;
wire [7:0]  S_slice_fifo1_usedw   ;
wire        S_slice_fifo1_full    ;
reg  [1:0]  S1_slice_fifo1_empty  ;
reg         S1_slice_fifo1_rden   ;

wire [7:0]  S_slice_fifo2_empty   ;
reg  [7:0]  S_slice_fifo2_wren    ;
reg  [7:0]  S1_slice_fifo2_wren    ;
reg  [31:0] S_slice_fifo2_wrdata  ;
wire [31:0] S_slice_fifo2_q     [7:0] ;  
wire [7:0]  S_slice_fifo2_usedw [7:0] ; 
wire [7:0]  S_slice_fifo2_full;
reg  [7:0]  S1_slice_fifo2_usedw      ;
reg  [7:0]  S_slice_fifo2_rd;

reg         S_slice_fifo3_wren   ;
reg  [23:0] S_slice_fifo3_wrdata ;
reg         S_slice_fifo3_rden   ;
wire [23:0] S_slice_fifo3_rdata  ;
wire        S_slice_fifo3_full   ;
wire        S_slice_fifo3_empty  ;
wire [3:0]  S_slice_fifo3_usedw  ;

parameter  C_SLICE_LENGTH_MAX = 8'd64 ;     ///9'HFD   == 9'd253
parameter  C_SLICE_ID_PHY_MAX = 10'h3FF;     ///10'H2FF == 10'H300 - 10'H1;   10'H300= 10'd768 = 'd1024*3/4 real physical space


//---------------------------------------------------
//                     ��ʼ������Ƭ                         
//---------------------------------------------------
always@(posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S_flow_fifo_empty <= 6'd0 ;
        S_pla_slice_send_req <= 8'd0;
    end
    else
    begin
        S_pla_slice_send_req <= I_pla_slice_send_req;
        S_flow_fifo_empty <= {S_flow_fifo_empty[4:0],I_flow_fifo_empty };            
    end
end
                
always@(posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S_flow_rdcnt <= 7'd0 ;
    end
    else
    begin
        if (S1_ff_rden[2])
            S_flow_rdcnt <= S_flow_rdcnt + 7'd1 ;
        else 
            S_flow_rdcnt <= 7'd0 ;   
    end
end

//////*********************************************************************
///������Ƭ������S_new_slice_ready,ͬʱ����3������(wren��Ч,fifo������,��ǰ����Ƭ)�ص��߲飡  
///*********************************************************************  
always@(posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S1_ff_rden <= 6'd0 ; 
        S1_new_slice_ready <= 1'b0;
        S_new_slice_ready  <= 1'b0;
    end
    else
    begin
         if (I_pla_slice_send_req != I_pla_tc_index && O_slice_ptp_req ) ///��ǰPTP���Ĳ�������FLOW FIFO
         begin
             S_new_slice_ready <= 1'b0;
         end    
         else
         begin 
             S_new_slice_ready <= (|I_pla_slice_send_req) && (!I_flow_fifo_empty) && (!S1_ff_rden[0]) ;
         end    
        S1_new_slice_ready <= S_new_slice_ready ; 
        S1_ff_rden  <= {S1_ff_rden[4:0],S_ff_rden};
    end
end

always@(posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)  
        S_ff_rden <= 1'b0 ;
    else if(S_new_slice_ready && !S1_new_slice_ready)   ///������              
        S_ff_rden <= 1'b1 ;  
    else if(S_ff_rd_cnt >= C_SLICE_LENGTH_MAX)    
        S_ff_rden <= 1'b0 ;                             
    else
        S_ff_rden <= S_ff_rden ;
end


always@(posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
        S_ff_rd_cnt <= 8'h0 ;
    else if(S_ff_rden|S1_ff_rden[1])  ///PTP :S1_ff_rden[1]
    begin
       /// if(((I_flow_fifo_empty || S_flow_fifo_empty) && !I_flow_fifo_rdata[33]) || (S1_ff_rden[3] && !S1_ff_rden[4] && I_flow_fifo_rdata[33])) ///      
        if (S1_ff_rden[3] && !S1_ff_rden[4] && I_flow_fifo_rdata[33] && I_flow_fifo_rdata[32])   /// PTP����
           S_ff_rd_cnt <= S_ff_rd_cnt ;                                                          
        else                                
           S_ff_rd_cnt <= S_ff_rd_cnt + 8'h1 ;           
    end
    else 
        S_ff_rd_cnt <= 8'h0 ;  
end

///  
/////for sake of real physical space(1024*3/4),S_pla_slice_id should skip some id_numbers,such as [13'h300,13'400),[13'h700,13'800)... ...
/////�ж�fifo_empty��buff_empty�źţ�
/////��fifo������ʱ,ֻҪbuff�Ѿ�ready,���Ͽ�ʼ��Ƭ��
/////��fifo������ʱ,����buff�Ѿ�ready,ֻҪfifo������,�Ϳ�ʼ��Ƭ��
always@(posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S_pla_slice_id <= 15'h7fff;
        O_flow_fifo_rden <= 1'b0 ;
    end
    else if(S_ff_rden && !S1_ff_rden[0] )
    begin
        if(S_pla_slice_id[9:0] == C_SLICE_ID_PHY_MAX)/////skip some id_number,such as [13'h300,13'400)... ...
        begin
            O_flow_fifo_rden      <= 1'b1  ;
            S_pla_slice_id[9:0]   <= 10'h0 ;
            S_pla_slice_id[14:10] <= S_pla_slice_id[14:10] + 5'h1 ;
        end
        else
        begin 
            O_flow_fifo_rden <= 1'b1 ;
            S_pla_slice_id <= S_pla_slice_id + 15'h1 ;  
          ////  if (S_pla_slice_id == 15'd10)
          ////  begin
          ////     S_pla_slice_id <= S_pla_slice_id + 15'h2 ;  
          ////  end
          ////  else 
          ////  begin
          ////     S_pla_slice_id <= S_pla_slice_id + 15'h1 ;  
          ////  end 
        end
    end
    else if(((S_ff_rd_cnt <= C_SLICE_LENGTH_MAX) && (I_flow_fifo_empty && !S_flow_fifo_empty[0]) && S_ff_rden))
    begin
        O_flow_fifo_rden <= 1'b0 ;
        S_pla_slice_id <= S_pla_slice_id ;
    end
    else if ((S_flow_rdcnt != 7'd0)&&((I_flow_fifo_next_rdata[33:28] == 6'h3f)||(I_flow_fifo_rdata[33:28] == 6'h30)))///PTP����β,����������һ��PTPͷ 
    begin
        O_flow_fifo_rden <= 1'b0 ;
        S_pla_slice_id <= S_pla_slice_id ;
    end                    
    else if(S_ff_rd_cnt >= 8'd67) //�˳�����Ϊ����64+3ʱ�˳�
    begin
        O_flow_fifo_rden <= 1'b0 ;
        S_pla_slice_id <= S_pla_slice_id ; 
    end
    else
    begin
        O_flow_fifo_rden <= O_flow_fifo_rden ;
        S_pla_slice_id <= S_pla_slice_id ;
    end
end           

///����Ƭ����ʱ,�����buff�д洢��Ƭ���ɵĳ���  �������4��buff�ĳ���,�ֱ����
always@(posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
        O_buff_data_length <= 8'h0 ;
    else if(S1_ff_rden[0] && !S_ff_rden)
        O_buff_data_length <= S_ff_rd_cnt - 8'h1 ;  ///binsai ��Ϊ S_ff_rd_cnt - 1 ����
    else
        O_buff_data_length <= O_buff_data_length ;                
end            

//////*********************************************************************
///�ڿ�ʼ��Ƭ��������,ѡ�������ĸ�ͨ��buff����д��,������Ƭ������Ч   
///*********************************************************************                
always@(posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
        S_buff_wr_flag <= 8'h0 ;
    else if(S_new_slice_ready && !S1_new_slice_ready)
        S_buff_wr_flag <= S_pla_slice_send_req;
    else if(!S1_ff_rden[0] && S1_ff_rden[1]) 
        S_buff_wr_flag <= 8'h0 ;                   
    else 
        S_buff_wr_flag <= S_buff_wr_flag ;            
end

///*********************************************************************
///PTP����
///*********************************************************************  
always@(posedge I_pla_312m5_clk or posedge I_pla_rst) 
begin
    if(I_pla_rst)
    begin
        S_slice_ptp_flg <= 1'b0;  
    end
 ///   else if(I_pla_tc_en == 1'b0)
 ///   begin
 ///       S_slice_ptp_flg <= 1'b0;
 ///   end
    else if(S1_ff_rden[2] && !S1_ff_rden[3] && (I_flow_fifo_next_rdata[33:28] == 6'h3f)) ///��֡��PTP���ı�־
    ///else if(S1_ff_rden[2] && !S1_ff_rden[3] && (I_flow_fifo_next_rdata == 34'h3ffffffff)) ///��֡��PTP���ı�־
    begin
        S_slice_ptp_flg <= 1'b1;
    end    
    else if(I_flow_fifo_rdata[33:28] == 6'h30)
    begin
        S_slice_ptp_flg <= 1'b0;   
    end    
    else if(I_flow_fifo_next_rdata[33:28] == 6'h30 && I_flow_fifo_empty ) ///�յ��Ǻ� 
    begin
        S_slice_ptp_flg <= 1'b0;   
    end  
end


always@(posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        O_slice_ptp_req <= 1'b0;
    end
    else if(S1_slice_fifo1_empty[1] && I_flow_fifo_next_rdata[33:28] == 6'h3f) ///��֡��PTP����
    begin
        O_slice_ptp_req <= I_pla_tc_en;
    end    
    else if (O_slice_ptp_req && (S_slice_fifo_ind == I_pla_tc_index) && S1_ff_rden[4] && !S1_ff_rden[5] ) ///����PTP����,��������ָ���˿�,
    begin
        O_slice_ptp_req <= 1'b0;
    end
end

always@(posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S_slice_fifo_ind <= 8'b0;
    end
    else if(S1_ff_rden[2] && !S1_ff_rden[3])
    begin
        S_slice_fifo_ind <= S_buff_wr_flag;
    end
   /// else if(O_slice_ptp_req && S1_ff_rden[2] && !S1_ff_rden[3]))
   /// begin
   ///     S_slice_fifo_ind <= I_pla_tc_index;
   /// end
end


(*mark_debug ="true"*) reg S_x2_flag;
///*********************************************************************
///SLICE FIFO1 WREN WRDATA;
///*********************************************************************  
always@(posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S_slice_fifo1_wrdata <= 32'd0;
        S_zero_flag <= 1'b0;
        O_flow_fifo_pt <= 1'd0;
        S_x2_flag <= 1'b0;
    end    
    else if(S1_ff_rden[2])
        if (S_zero_flag)
        begin
            S_slice_fifo1_wrdata <= 32'h00000000;
            S_zero_flag <= 1'b1; 
            S_x2_flag <= 1'b0;
        end
        else if (!S_slice_ptp_flg && I_flow_fifo_rdata[33:28] == 6'h3f && S_flow_rdcnt != 7'd0)  ///��֡��PTP֡,����PTP����,ȫ�����Ϊ0
        begin
            S_slice_fifo1_wrdata <= 32'h00000000;
            S_zero_flag <= 1'b1;
            O_flow_fifo_pt <= 1'd1;
            S_x2_flag <= 1'b0;
        end  
        else if (S_slice_ptp_flg && I_flow_fifo_rdata[33:28] == 6'h30)  ///��֡PTP֡,��������,���0 
        begin
            S_slice_fifo1_wrdata <= 32'h00000000;
            S_zero_flag <= 1'b1;
            O_flow_fifo_pt <= 1'd1;
        end             
        else if (!S_slice_ptp_flg && S_flow_fifo_empty[3] && !S_flow_fifo_empty[4])  ///��֡��PTP֡,��������,ȫ�����Ϊ0
        begin
            if (I_flow_fifo_next_rdata[33:32] == 2'b01)     ///55d5�п�����CRCУ������  ,Ҳ�п�������һ֡��ͷ��
            begin
                S_slice_fifo1_wrdata <= {I_flow_fifo_next_rdata[31:16],16'd0};
                S_x2_flag <= 1'b1;
            end
            else
            begin
                S_slice_fifo1_wrdata <= I_flow_fifo_next_rdata;  ///����ȫ��
            end 
 
            O_flow_fifo_pt <= O_flow_fifo_pt;
            S_zero_flag <= 1'b1;
        end     
      ///  else if (!S_slice_ptp_flg && S_flow_fifo_empty[4] && !S_flow_fifo_empty[5])  ///��֡��PTP֡,��������,ȫ�����Ϊ0
      ///  begin
      ///      S_slice_fifo1_wrdata <= 32'h00000000;  ///����ȫ��
      ///      O_flow_fifo_pt <= O_flow_fifo_pt;
      ///  end    
        else
        begin 
            S_slice_fifo1_wrdata <= I_flow_fifo_rdata[31:0];
            O_flow_fifo_pt <= O_flow_fifo_pt;
            S_x2_flag <= 1'b0;
        end    
    else 
    begin 
        S_slice_fifo1_wrdata <= 32'd0;  
        S_zero_flag <= 1'b0;
        O_flow_fifo_pt <= O_flow_fifo_pt & S1_ff_rden[5];  ///֡β�ӳ�һ��ʱ��,��ֹ��ȡ������
    end      
end


                       
always@(posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S_slice_fifo1_wren <= 1'b0;
    end
    else if (S_slice_ptp_flg)
    begin
        if(!S1_ff_rden[2])
        begin
            S_slice_fifo1_wren <= 1'b0;
        end
        else if(S1_ff_rden[4])
        begin
            S_slice_fifo1_wren <= 1'b1;
        end
    end        
    else
    begin
        if(!S1_ff_rden[2])
        begin
            S_slice_fifo1_wren <= 1'b0;
        end
        else if(S1_ff_rden[3])
        begin
            S_slice_fifo1_wren <= 1'b1;
        end
    end     

end

///*********************************************************************
///SLICE FIFO1 Ԥ��д��
///*********************************************************************
blk_com_fifo_256x32  U01_blk_com_fifo_256x32
///fifo_256x32_xilinx  U01_blk_com_fifo_256x32
(
.clk         (I_pla_312m5_clk      ),
.rst         (I_pla_rst            ),
.din         (S_slice_fifo1_wrdata ),
.wr_en       (S_slice_fifo1_wren   ),
.rd_en       (S_slice_fifo1_rden   ),
.dout        (S_slice_fifo1_rdata  ),
.full        (S_slice_fifo1_full   ),
.empty       (S_slice_fifo1_empty  ),
.data_count  (S_slice_fifo1_usedw  )
);

///*********************************************************************
///SLICE FIFO1 ����
///*********************************************************************     

always@(posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S_slice_fifo1_rden <= 1'b0;
    end
    else if(!S1_slice_fifo1_empty[0] )////
    begin
        S_slice_fifo1_rden <= 1'b1;
    end
    else
    begin
        S_slice_fifo1_rden <= 1'b0;
    end
end

always@(posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S1_slice_fifo1_rden <= 1'b0;
        S1_slice_fifo1_empty <= 2'b1;
    end
    else
    begin
        S1_slice_fifo1_rden <= S_slice_fifo1_rden;
        S1_slice_fifo1_empty <= {S1_slice_fifo1_empty[0],S_slice_fifo1_empty};
    end
end


                 
///*********************************************************************
///SLICE FIFO2 д��
///*********************************************************************     

always@(posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S_slice_fifo2_wrdata <= 32'd0;
    end
    else
    begin
        S_slice_fifo2_wrdata <= S_slice_fifo1_rdata;
    end
end

always@(posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S_slice_fifo2_wren <= 8'd0;
    end
    else if(!S1_slice_fifo1_empty[0] && S1_slice_fifo1_rden)
    begin
        S_slice_fifo2_wren <= S_slice_fifo_ind;
    end
    else
    begin
        S_slice_fifo2_wren <= 8'd0;
    end
end

always@(posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S1_slice_fifo2_wren <= 8'd0;
    end
    begin
        S1_slice_fifo2_wren <= S_slice_fifo2_wren;
    end
end

always@(posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        O_slice_fifo_idle <= 1'd0;
    end
    else if(S_new_slice_ready || S_ff_rden)
    begin
        O_slice_fifo_idle <= 1'b0;
    end
    else if(S1_slice_fifo1_empty[1])
    begin
        O_slice_fifo_idle <= 1'b1;
    end
end
            

///*********************************************************************
///SLICE pla_for_slice_fifo2 
///*********************************************************************  

reg  S_slice_fifo2_rst;
reg  S_slice_fifo2_timeout;

reg [3:0] S1_slice_fifo2_timeout;
reg [11:0] S_fifo2_timeout_cnt  ; 

genvar j;  
generate for(j=0;j<8;j=j+1'b1) 
begin: pla_for_slice_fifo2
blk_com_fifo_256x32 U02_frame_fifo_256x32 (
///fifo_256x32_xilinx U02_frame_fifo_256x32 (
.clk         (I_pla_312m5_clk        ),
.rst         (I_pla_rst              ),
.din         (S_slice_fifo2_wrdata   ),
.wr_en       (S1_slice_fifo2_wren[j] ),
.rd_en       (I_slice_fifo2_rd[j]    ),
.dout        (S_slice_fifo2_q[j]     ),
.full        (S_slice_fifo2_full[j]  ),
.empty       (S_slice_fifo2_empty[j] ),
.data_count  (S_slice_fifo2_usedw[j] )
); 

end
endgenerate

///*********************************************************************  
///��ʱ������ͳ��                                           
///*********************************************************************  
always@(posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S_fifo2_timeout_cnt <= 12'b0;
    end
    else if(O_slice_fifo_empty != S_slice_fifo2_empty)
    begin
        S_fifo2_timeout_cnt <= 12'b0;
    end
    else if (S_slice_fifo3_empty && S_slice_fifo2_empty != 8'hff)
    begin
        if (S_fifo2_timeout_cnt == 12'hfff)
           S_fifo2_timeout_cnt <= S_fifo2_timeout_cnt;
        else 
           S_fifo2_timeout_cnt <= S_fifo2_timeout_cnt + 12'd1 ;
    end
    else 
    begin
        S_fifo2_timeout_cnt <= 12'b0;
    end
end

always@(posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S_slice_fifo2_timeout <= 1'b0;
    end
    else if (S_fifo2_timeout_cnt >= 12'hff0)
    begin
        S_slice_fifo2_timeout <= 1'b1;
    end
    else 
    begin
        S_slice_fifo2_timeout <= 1'b0;
    end
end

always@(posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S1_slice_fifo2_timeout <= 4'd0;
        S_slice_fifo2_rst <= 1'b1;
    end
    else 
    begin
        S1_slice_fifo2_timeout <= {S1_slice_fifo2_timeout[2:0],S_slice_fifo2_timeout};   
        S_slice_fifo2_rst <= |S1_slice_fifo2_timeout ;
    end
end

///*********************************************************************  
///SLICE FIFO2�������                                           
///*********************************************************************  
always@(posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        O_slice_fifo_rdata <= 32'd0;
        O_slice_fifo_empty <= 8'hff;
    end
    else
    begin
        O_slice_fifo_empty <= S_slice_fifo2_empty;
        case(I_slice_fifo2_rd)
            8'b00000001 : O_slice_fifo_rdata <= S_slice_fifo2_q[0];
            8'b00000010 : O_slice_fifo_rdata <= S_slice_fifo2_q[1];
            8'b00000100 : O_slice_fifo_rdata <= S_slice_fifo2_q[2];
            8'b00001000 : O_slice_fifo_rdata <= S_slice_fifo2_q[3];
            8'b00010000 : O_slice_fifo_rdata <= S_slice_fifo2_q[4];
            8'b00100000 : O_slice_fifo_rdata <= S_slice_fifo2_q[5];
            8'b01000000 : O_slice_fifo_rdata <= S_slice_fifo2_q[6];
            8'b10000000 : O_slice_fifo_rdata <= S_slice_fifo2_q[7];
            default:;
        endcase
    end
end
        
        
        
always@(posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        O_buff_frame_ready <= 8'b0;
    end
    else if(!S1_ff_rden[0] && S1_slice_fifo1_empty[0] && !S1_slice_fifo1_empty[1])
    begin
        O_buff_frame_ready <= S_slice_fifo_ind;
    end
    else
    begin
        O_buff_frame_ready <= 8'b0;
    end
end

///*********************************************************************  
///FIFO3 ��������д������                                             
///*********************************************************************


always@(posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S_slice_fifo3_wren <= 1'd0;
        S_slice_fifo3_wrdata <= 24'd0;
    end
    else if(S_slice_fifo1_rden && !S1_slice_fifo1_rden)
    begin
        S_slice_fifo3_wrdata <= {1'b0,S_pla_slice_id,S_slice_fifo_ind};
        S_slice_fifo3_wren <=1'b1;
    end
    else
    begin
        S_slice_fifo3_wren <= 1'd0;
    end
end

dist_com_fifo_16x24 U03_frame_fifo_16x24(
.clk         (I_pla_312m5_clk      ),
.rst         (I_pla_rst            ),
.din         (S_slice_fifo3_wrdata ),
.wr_en       (S_slice_fifo3_wren   ),
.rd_en       (S_slice_fifo3_rden   ),
.dout        (S_slice_fifo3_rdata  ),
.full        (S_slice_fifo3_full   ),
.empty       (S_slice_fifo3_empty  ),
.data_count  (S_slice_fifo3_usedw  )
); 



always@(posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S_slice_fifo2_rd <= 8'b0;
        O_slice_fifo_parameter <= 24'd0;
    end
    else 
    begin
        S_slice_fifo2_rd <= I_slice_fifo2_rd ;
        O_slice_fifo_parameter <= S_slice_fifo3_rdata ; 
    end
end


always@(posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S_slice_fifo3_rden <= 1'b0;
    end
    else 
    begin
        S_slice_fifo3_rden <= |O_buff_frame_ready ;
    end
end



///*********************************************************************  
///����ͳ��                                            
///*********************************************************************  

always@(posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S1_slice_fifo2_usedw <= 8'd64;
    end
    else
    begin
        case(O_buff_frame_ready)
            8'b00000001 : S1_slice_fifo2_usedw <= S_slice_fifo2_usedw[0];
            8'b00000010 : S1_slice_fifo2_usedw <= S_slice_fifo2_usedw[1];
            8'b00000100 : S1_slice_fifo2_usedw <= S_slice_fifo2_usedw[2];
            8'b00001000 : S1_slice_fifo2_usedw <= S_slice_fifo2_usedw[3];
            8'b00010000 : S1_slice_fifo2_usedw <= S_slice_fifo2_usedw[4];
            8'b00100000 : S1_slice_fifo2_usedw <= S_slice_fifo2_usedw[5];
            8'b01000000 : S1_slice_fifo2_usedw <= S_slice_fifo2_usedw[6];
            8'b10000000 : S1_slice_fifo2_usedw <= S_slice_fifo2_usedw[7];
            default:;
        endcase
    end
end


always@(posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S1_zero_flag <= 16'd0;
    end
    else 
    begin
        S1_zero_flag <= S_zero_flag;
    end
end


always@(posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        O_slice_fifo_len_err[15:0] <= 16'd0;
    end
    else if (I_cnt_clear)
    begin
        O_slice_fifo_len_err[15:0] <= 16'd0;
    end
    else if (!S1_zero_flag && S_zero_flag)
    begin
        O_slice_fifo_len_err[15:0] <= O_slice_fifo_len_err[15:0] + 16'd1;
    end
end


always@(posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        O_slice_fifo_len_err[31:16] <= 16'd0;
    end
    else if (I_cnt_clear)
    begin
        O_slice_fifo_len_err[31:16] <= 16'd0;
    end
    else if(O_buff_frame_ready && S1_slice_fifo2_usedw != 8'd63 )
        begin
            O_slice_fifo_len_err[31:16] <= O_slice_fifo_len_err[31:16] + 16'd1;
        end
    end




always@(posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        S_ptp_slice_zero <= 1'b0;
    end
   ///  else if (I_flow_fifo_rdata[33:28] == 6'h3f && S_flow_rdcnt == 7'd1 && !I_pla_tc_en) 
    else if (S_slice_ptp_flg && S_flow_rdcnt == 7'd1 && !I_pla_tc_en) 
    begin
        S_ptp_slice_zero <= 1'b1;    ////  &&
    end    
    else 
    begin
        S_ptp_slice_zero <= 1'b0;  
    end
end


always@(posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        O_slice_fifo_len_err[47:32] <= 16'd0;
    end
    else if (I_cnt_clear)
    begin
        O_slice_fifo_len_err[47:32] <= 16'd0;
    end    
    else if (S_ptp_slice_zero) 
    begin  
        O_slice_fifo_len_err[47:32] <= O_slice_fifo_len_err[47:32] + 16'd1;
    end
end


always@(posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        O_slice_fifo_len_err[63:48] <= 16'd0;
    end
    else if (I_cnt_clear)
    begin
        O_slice_fifo_len_err[63:48] <= 16'd0;
    end    
    else if (S_slice_fifo1_full || (|S_slice_fifo2_full) || S_slice_fifo3_full) 
    begin  
        O_slice_fifo_len_err[63:48] <= O_slice_fifo_len_err[63:48] + 16'd1;
    end
end

always@(posedge I_pla_312m5_clk or posedge I_pla_rst)
begin
    if(I_pla_rst)
    begin
        O_slice_fifo_len_err[79:64] <= 16'd0;
    end
    else if (I_cnt_clear)
    begin
        O_slice_fifo_len_err[79:64] <= 16'd0;
    end    
    else if (|S_fifo2_timeout_cnt) 
    begin  
        O_slice_fifo_len_err[79:64] <= O_slice_fifo_len_err[79:64] + 16'd1;
    end
end



endmodule





