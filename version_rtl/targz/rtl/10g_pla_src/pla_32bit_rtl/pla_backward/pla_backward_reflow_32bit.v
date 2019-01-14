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
//x                             |--
//x                             |--
//x pla_backward_reflow_32bit-- |--
//x                             |--U1_pla_id_seq_chk
//----------------------------------------------------------------------------
// qc 2015 06 07 
`timescale 1ns/100ps
module pla_backward_reflow_32bit(
input               I_pla_312m5_clk            ,
input               I_pla_rst                  ,
input     [ 1:0]    I_cnt_clear                ,
input     [15:0]    I_pla_slice_id_depth_set   ,
input     [14:0]    I_pla_slice_id_new         ,
input               I_pla_slice_id_new_valid   ,
input     [14:0]    I_pla_slice_id_max         ,
input     [14:0]    I_pla_slice_id_min         ,
input               I_pla_slice_rd_resp        ,
input     [31:0]    I_pla_slice_rdata          ,
input               I_pla_reflow_fifo_rd       ,
output              O_pla_slice_rd_req         ,
output    [14:0]    O_pla_slice_rd_id          ,
output              O_pla_slice_data_rd        ,
output    [32:0]    O_pla_reflow_fifo_rdata    ,
output              O_pla_reflow_fifo_empty    ,

output reg   [31:0] O_pla_reflow_rderr_cnt     ,
output       [47:0] O_pla_reflow_id_wl         ,
output      [15:0]  O_reflow_55D5_cnt          ,
output      [15:0]  O_reflow_lose_cnt          ,
output              O_reflow_lose_reg          , 

output              O_pla_slice_id_depth_alful
);

parameter           C_REFLOW_IDLE                = 2'b00,
                    C_REFLOW_CATCH               = 2'b01,
                    C_REFLOW_READ                = 2'b10;
reg       [1:0]     S_reflow_state                      ;
reg       [1:0]     S_reflow_state_next                 ;
reg       [14:0]    S_slice_id_current           = 15'd0;
//reg					S_slice_id_current_en		 = 1'b0	;
reg       [14:0]    S1_slice_id_current          = 15'd0;
reg       [14:0]    S2_slice_id_current          = 15'd0;
reg                 S_slice_current_valid        = 1'b0 ;
reg       [11:0]    S_read_state_cnt             = 12'd0;
reg                 S_reflow_idle_flg            = 1'b0 ;
reg                 S1_reflow_idle_flg           = 1'b0 ;
reg                 S2_reflow_idle_flg           = 1'b0 ;
reg       [1:0]     S_reflow_catch_flg           = 2'b0 ;
reg                 S1_reflow_catch_flg          = 1'b0 ;
reg                 S2_reflow_catch_flg          = 1'b0 ;
reg                 S_reflow_catch_add           = 1'b0 ;
reg                 S1_reflow_catch_add			 = 1'b0 ;
reg                 S_pla_slice_rd_resp_buf      = 1'b0 ;
reg                 S_pla_slice_loss_flg         = 1'b0 ;
reg                 S_pla_slice_loss_flg_1d      = 1'b0 ;
reg       [13:0]    S_slice_valid_ram_wr_addr    = 14'd0;
reg       [ 3:0]    S_slice_valid_ram_wr_data    = 4'b0 ;
reg                 S_slice_valid_ram_wr         = 1'b0 ;
wire      [ 3:0]    S_slice_valid_ram_rd_data           ;
reg                 S_slice_valid_ram_col        = 1'b0 ;
reg                 S_slice_valid_ram_col_buf    = 1'b0 ;
reg       [ 3:0]    S_slice_valid_ram_col_data   = 4'b0 ;
reg                 S_pla_slice_rd_req           = 1'b0 ;
reg                 S_pla_slice_rd_req_buf       = 1'b0 ;
reg       [14:0]    S_pla_slice_rd_id            = 15'd0;
reg                 S_pla_slice_data_rd          = 1'b0 ;
reg                 S_pla_slice_data_rd_buf1     = 1'b0 ;
reg                 S_pla_slice_data_rd_buf2     = 1'b0 ;
reg                 S_pla_slice_data_rd_buf3     = 1'b0 ;
reg                 S_pla_slice_data_rd_buf4     = 1'b0 ;
reg                 S_pla_slice_data_rd_buf5     = 1'b0 ;
reg                 S_pla_slice_data_rd_buf6     = 1'b0 ;
reg                 S_pla_slice_data_rd_buf7     = 1'b0 ;
reg                 S_pla_slice_id_new_valid_buf = 1'b0 ;
reg       [32:0]    S_pla_reflow_fifo_wdata      = 32'b0;
reg                 S_pla_reflow_fifo_wr         = 1'b0 ;
wire      [9:0]     S_pla_reflow_fifo_usedw             ;
reg       [9:0]     S_pla_reflow_fifo_usedw_buf  = 10'd0;
reg                 S_pla_reflow_fifo_alful      = 1'b0 ;
reg                 S1_pla_reflow_fifo_alful     = 1'b0 ;
reg       [5:0]     S_pla_slice_data_rd_cnt      = 6'h3f;
reg                 S_pla_slice_id_depth_flg     = 1'b0 ;
reg       [15:0]    S_pla_reflow_id_wl           = 16'd0;
reg                 S_pla_slice_id_depth_alful   = 1'b0 ;
reg                 S_reflow_rderr_flag					;
reg                 S_reflow_rderr_flag_1d				;
reg       [31:0]    S_pla_slice_rdata_buf               ;
reg		  [31:0]    S_pla_reflow_fifo_rdata				; 

reg		  [ 3:0]	S_cnt_clear_buf				= 4'd0	;
reg	  	  [14:0]	S_clear_cnt					= 15'd0	;
reg					S_clear_cnt_en				= 1'b0	;

reg		  [14:0]    S_pla_slice_id_max_add1				; 

/////---------------------------------------------------------
///// debug	begin
/////---------------------------------------------------------
(*MARK_DEBUG ="true"*)reg   [14:0]  dbg_pla_slice_id_new			;
(*MARK_DEBUG ="true"*)reg           dbg_pla_slice_id_new_valid      ;
(*MARK_DEBUG ="true"*)reg   [14:0]  dbg_pla_slice_id_max            ;
(*MARK_DEBUG ="true"*)reg   [14:0]  dbg_pla_slice_id_min            ;
(*MARK_DEBUG ="true"*)reg           dbg_pla_slice_rd_resp           ;
(*MARK_DEBUG ="true"*)reg           dbg_pla_reflow_fifo_rd          ;
(*MARK_DEBUG ="true"*)reg           dbg_pla_slice_rd_req            ;
(*MARK_DEBUG ="true"*)reg   [32:0]  dbg_pla_reflow_fifo_rdata       ;
(*MARK_DEBUG ="true"*)reg           dbg_pla_reflow_fifo_empty       ;
(*MARK_DEBUG ="true"*)reg	[32:0]	dbg_pla_reflow_fifo_wdata		; 
(*MARK_DEBUG ="true"*)reg			dbg_pla_reflow_fifo_wr			; 
(*MARK_DEBUG ="true"*)reg   [ 1:0]  dbg_reflow_state                ;
(*MARK_DEBUG ="true"*)reg   [14:0]  dbg_slice_id_current            ;
(*MARK_DEBUG ="true"*)reg           dbg_slice_current_valid         ;
(*MARK_DEBUG ="true"*)reg   [11:0]  dbg_read_state_cnt              ;
(*MARK_DEBUG ="true"*)reg           dbg_reflow_idle_flg             ;
(*MARK_DEBUG ="true"*)reg   [1:0]   dbg_reflow_catch_flg            ;
(*MARK_DEBUG ="true"*)reg           dbg_reflow_catch_add            ;
(*MARK_DEBUG ="true"*)reg           dbg1_reflow_catch_add			;
(*MARK_DEBUG ="true"*)reg           dbg_pla_slice_rd_resp_buf       ;
(*MARK_DEBUG ="true"*)reg           dbg_pla_slice_loss_flg          ;
(*MARK_DEBUG ="true"*)reg   [13:0]  dbg_slice_valid_ram_wr_addr     ;
(*MARK_DEBUG ="true"*)reg   [ 3:0]  dbg_slice_valid_ram_wr_data     ;
(*MARK_DEBUG ="true"*)reg           dbg_slice_valid_ram_wr          ;
(*MARK_DEBUG ="true"*)reg	[ 3:0]	dbg_slice_valid_ram_rd_data     ;
(*MARK_DEBUG ="true"*)reg           dbg_slice_valid_ram_col         ;
(*MARK_DEBUG ="true"*)reg           dbg_slice_valid_ram_col_buf     ;
(*MARK_DEBUG ="true"*)reg   [ 3:0]  dbg_slice_valid_ram_col_data    ;
(*MARK_DEBUG ="true"*)reg   [14:0]  dbg_pla_slice_rd_id             ;
(*MARK_DEBUG ="true"*)reg           dbg_pla_slice_data_rd           ;
(*MARK_DEBUG ="true"*)reg           dbg_pla_slice_data_rd_buf7      ;
(*MARK_DEBUG ="true"*)reg           dbg_pla_reflow_fifo_alful       ;
(*MARK_DEBUG ="true"*)reg   [5:0]   dbg_pla_slice_data_rd_cnt       ;
(*MARK_DEBUG ="true"*)reg           dbg_reflow_rderr_flag			;
(*MARK_DEBUG ="true"*)reg           dbg_reflow_lose_reg             ; 


always @ (posedge I_pla_312m5_clk )
begin
    dbg_pla_slice_id_new           <= I_pla_slice_id_new			;   
    dbg_pla_slice_id_new_valid     <= I_pla_slice_id_new_valid      ;
    dbg_pla_slice_id_max           <= I_pla_slice_id_max            ;
    dbg_pla_slice_id_min           <= I_pla_slice_id_min            ;
    dbg_pla_slice_rd_resp          <= I_pla_slice_rd_resp           ;
    dbg_pla_reflow_fifo_rd         <= I_pla_reflow_fifo_rd          ;
    dbg_pla_slice_rd_req           <= O_pla_slice_rd_req            ;
    dbg_pla_slice_rd_id            <= O_pla_slice_rd_id             ;
    dbg_pla_slice_data_rd          <= O_pla_slice_data_rd           ;
	dbg_pla_reflow_fifo_rdata      <= O_pla_reflow_fifo_rdata       ;
    dbg_pla_reflow_fifo_empty      <= O_pla_reflow_fifo_empty		;
	dbg_pla_reflow_fifo_wdata	   <= S_pla_reflow_fifo_wdata		; 
	dbg_pla_reflow_fifo_wr		   <= S_pla_reflow_fifo_wr			; 
	dbg_reflow_state               <= S_reflow_state                ;
	dbg_slice_id_current           <= S_slice_id_current            ;
	dbg_slice_current_valid        <= S_slice_current_valid         ;
	dbg_read_state_cnt             <= S_read_state_cnt              ;
	dbg_reflow_idle_flg            <= S_reflow_idle_flg             ;
	dbg_reflow_catch_flg           <= S_reflow_catch_flg            ;
	dbg_reflow_catch_add           <= S_reflow_catch_add            ;
	dbg1_reflow_catch_add		   <= S1_reflow_catch_add		    ;
	dbg_pla_slice_rd_resp_buf      <= S_pla_slice_rd_resp_buf       ;
	dbg_pla_slice_loss_flg         <= S_pla_slice_loss_flg          ;
	dbg_slice_valid_ram_wr_addr    <= S_slice_valid_ram_wr_addr     ;
	dbg_slice_valid_ram_wr_data    <= S_slice_valid_ram_wr_data     ;
	dbg_slice_valid_ram_wr         <= S_slice_valid_ram_wr          ;
	dbg_slice_valid_ram_rd_data    <= S_slice_valid_ram_rd_data     ;
	dbg_slice_valid_ram_col        <= S_slice_valid_ram_col         ;
	dbg_slice_valid_ram_col_buf    <= S_slice_valid_ram_col_buf     ;
	dbg_slice_valid_ram_col_data   <= S_slice_valid_ram_col_data    ;
	dbg_pla_slice_rd_req           <= S_pla_slice_rd_req            ;
	dbg_pla_slice_rd_id            <= S_pla_slice_rd_id             ;
	dbg_pla_slice_data_rd          <= S_pla_slice_data_rd           ;
	dbg_pla_slice_data_rd_buf7     <= S_pla_slice_data_rd_buf7      ;
	dbg_pla_reflow_fifo_alful      <= S_pla_reflow_fifo_alful       ;
	dbg_pla_slice_data_rd_cnt      <= S_pla_slice_data_rd_cnt       ;
	dbg_reflow_rderr_flag		   <= S_reflow_rderr_flag		    ;
	dbg_reflow_lose_reg			   <= O_reflow_lose_reg				;
end
/////---------------------------------------------------------
///// debug end	
/////---------------------------------------------------------

always @ (posedge I_pla_312m5_clk) 
begin
    if(I_pla_rst)
    begin
        S_reflow_rderr_flag <= 1'b0;
    end
    else if(I_cnt_clear[0]) 
    begin
        S_reflow_rderr_flag <= 1'b0;
    end
    //else if (S_read_state_cnt == 12'h17fe)
    else if (S_read_state_cnt == 12'heee)
    begin
        S_reflow_rderr_flag <= 1'b1;
    end
    else 
    begin
        S_reflow_rderr_flag <= 1'b0;
    end
end

always @ (posedge I_pla_312m5_clk) 
begin
	S_reflow_rderr_flag_1d	<= S_reflow_rderr_flag	;
end

always @ (posedge I_pla_312m5_clk) 
begin
    if(I_pla_rst)
    begin
        O_pla_reflow_rderr_cnt[15:0] <= 16'd0								;
	end
    else if(I_cnt_clear[0]) 
    begin
        O_pla_reflow_rderr_cnt[15:0] <= 16'd0								;
	end
    else if (S_reflow_rderr_flag && (!S_reflow_rderr_flag_1d))
    begin
        O_pla_reflow_rderr_cnt[15:0]  <= O_pla_reflow_rderr_cnt[15:0] +16'd1;
	end
	else
	begin
        O_pla_reflow_rderr_cnt[15:0]  <= O_pla_reflow_rderr_cnt[15:0]		; 
	end
end



always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst)
	begin
		S_reflow_idle_flg <= 1'b0;
	end
    else if(S_slice_id_current == (I_pla_slice_id_max + 12'd1))
    begin
		S_reflow_idle_flg <= 1'b1;
	end
    else
	begin
		S_reflow_idle_flg <= 1'b0;
	end
end

always @ (posedge I_pla_312m5_clk)
begin
    S1_reflow_idle_flg <= S_reflow_idle_flg     ;
    S2_reflow_idle_flg <= S1_reflow_idle_flg	;
end


always @ (posedge I_pla_312m5_clk) 
begin
	S_pla_slice_id_max_add1	<= I_pla_slice_id_max + 14'd1 ;
end

always @ (posedge I_pla_312m5_clk) 
begin
	if(I_pla_rst)
	begin
			S_reflow_catch_flg <= 2'b00;
	end
    else if((I_pla_slice_id_min[14:13] == 2'b11) && (S_pla_slice_id_max_add1[14:13] == 2'b00))
	begin
		if((S_slice_id_current[14:13] == 2'b00) && (S_slice_id_current >S_pla_slice_id_max_add1))
		begin
			S_reflow_catch_flg <= 2'b10;
        end
		else if((S_slice_id_current[14:13] == 2'b11) && (S_slice_id_current < I_pla_slice_id_min ))
        begin
			S_reflow_catch_flg <= 2'b01;
		end
		else
		begin
			S_reflow_catch_flg <= 2'b00;
		end
    end
    else if (S_slice_id_current < I_pla_slice_id_min		)
    begin
			S_reflow_catch_flg <= 2'b01;
	end
    else if (S_slice_id_current > S_pla_slice_id_max_add1	)
    begin
			S_reflow_catch_flg <= 2'b10;
    end
    else
	begin
			S_reflow_catch_flg <= 2'b00;
	end
end

always @ (posedge I_pla_312m5_clk) 
begin
	if(I_pla_rst)
	begin
		S1_reflow_catch_flg <= 1'b0;
        S2_reflow_catch_flg <= 1'b0;
	end
    else
	begin
		S1_reflow_catch_flg <= S_reflow_catch_flg[0] | S_reflow_catch_flg[1];
        S2_reflow_catch_flg <= S1_reflow_catch_flg;
	end
end

always @ (posedge I_pla_312m5_clk) ///����ram����ӳ٣�idÿ����clk ��1
begin
	if(S_reflow_state == C_REFLOW_CATCH)
	begin
		S_reflow_catch_add <= ~S_reflow_catch_add;
	end
    else
	begin
		S_reflow_catch_add <= 1'b0;
	end
end

always @ (posedge I_pla_312m5_clk)
begin
    S1_reflow_catch_add <= S_reflow_catch_add;
end

always @ (posedge I_pla_312m5_clk)
begin
    S_pla_slice_rd_resp_buf <= I_pla_slice_rd_resp;
end

always @ (posedge I_pla_312m5_clk)
begin	
	if(I_pla_rst)
	begin
		S_reflow_state <= C_REFLOW_IDLE			;
	end
    else
	begin
		S_reflow_state <= S_reflow_state_next	;
	end
end

always @ (*)
begin
    case(S_reflow_state)
    C_REFLOW_IDLE  :
    begin
		if(S_slice_current_valid && !S_pla_reflow_fifo_alful)
        begin
			S_reflow_state_next = C_REFLOW_READ;
        end
        else if(S2_reflow_catch_flg && !S_reflow_idle_flg && !S2_reflow_idle_flg)
        begin
			S_reflow_state_next = C_REFLOW_CATCH;
        end
        else
        begin
			S_reflow_state_next = C_REFLOW_IDLE;
        end
	end
    C_REFLOW_CATCH :
    begin
		if(S_slice_current_valid && !S_pla_reflow_fifo_alful && !S_reflow_catch_add)
        begin
			S_reflow_state_next = C_REFLOW_READ;
        end
        else if(S2_reflow_catch_flg)
        begin
			S_reflow_state_next = C_REFLOW_CATCH;
        end
        else
        begin
			S_reflow_state_next = C_REFLOW_IDLE;
        end
	end
    C_REFLOW_READ  :  ///��������
    begin
		if(S_read_state_cnt == 12'hf00)   ///--dont wait,improve delay
		begin
			S_reflow_state_next = C_REFLOW_IDLE;
		end
        else if(I_pla_slice_rd_resp && !S_pla_slice_rd_resp_buf)
		begin
			S_reflow_state_next = C_REFLOW_IDLE;
		end
        else
        begin
			S_reflow_state_next = C_REFLOW_READ;
        end
    end
    default : 
	begin
			S_reflow_state_next = C_REFLOW_IDLE;
	end
    endcase
end

always @ (posedge I_pla_312m5_clk) 
begin
	if(I_pla_rst || S_cnt_clear_buf[2] )
	begin
		S_slice_id_current <= 15'd0;
		S_read_state_cnt <= 12'd0;
	end
    else
    begin
	case(S_reflow_state)
		C_REFLOW_IDLE  :
        begin
			S_read_state_cnt <= 12'd0;
            if(S_slice_current_valid && !S_pla_reflow_fifo_alful)
			begin
				S_slice_id_current	  <= S_slice_id_current + 15'd1;
            end
            else
            begin
				S_slice_id_current <= S_slice_id_current;
            end
        end
		C_REFLOW_CATCH :
        begin
			S_read_state_cnt <= 12'd0;
			if(S_reflow_catch_add)  //�жϳ�vaild��Чʱ���Ѿ�����+1����
			begin
				if(S_pla_reflow_fifo_alful || (!S_pla_reflow_fifo_alful && S1_pla_reflow_fifo_alful))
				begin
					S_slice_id_current <= S_slice_id_current;
                end
				else // changed by cqiu 
                begin
					S_slice_id_current <= S_slice_id_current + 15'd1;
                end
            end
			else if(S_slice_current_valid && !S_pla_reflow_fifo_alful)
			begin
					S_slice_id_current <= S_slice_id_current + 15'd1;
            end
            else
            begin
					S_slice_id_current <= S_slice_id_current;
            end
        end
		C_REFLOW_READ  :///
		begin
			if (S_read_state_cnt == 12'hf00)   ///2֡����  FF--3FRAME  FFF ---15֡��д��ͻ
            begin
				S_read_state_cnt <= S_read_state_cnt;   
            end     
            else 
            begin
				S_read_state_cnt <= S_read_state_cnt + 12'd1;  
            end    
        end
        default :
		begin
				S_read_state_cnt <= 12'd0;
		end
    endcase
    end
end

always @ (posedge I_pla_312m5_clk) 
begin
	if(I_pla_rst)
	begin
		S1_slice_id_current <= 15'd0				;
		S2_slice_id_current <= 15'd0				;
	end
    else
	begin
		S1_slice_id_current <= S_slice_id_current	;
        S2_slice_id_current <= S1_slice_id_current	;
	end
end

always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_slice_id_max >= (S_slice_id_current - 15'd1))
    begin
		S_pla_slice_id_depth_flg <= 1'b1;
    end
    else
    begin
		S_pla_slice_id_depth_flg <= 1'b0;
    end
end

always @ (posedge I_pla_312m5_clk) 
begin
	if(I_pla_rst)
	begin
			S_pla_reflow_id_wl <= 16'b0;
	end
    else
    begin
		if(S_pla_slice_id_depth_flg)
		begin
			S_pla_reflow_id_wl <= {1'b0,I_pla_slice_id_max} - ({1'b0,O_pla_slice_rd_id} - 16'd1);
		end
		else
		begin
			S_pla_reflow_id_wl <= {1'b1,I_pla_slice_id_max} - ({1'b0,O_pla_slice_rd_id} - 16'd1);
		end
    end
end

always @ (posedge I_pla_312m5_clk)
begin
	if(S_pla_reflow_id_wl > I_pla_slice_id_depth_set)
	begin
		S_pla_slice_id_depth_alful <= 1'b1;
	end
    else
    begin
		S_pla_slice_id_depth_alful <= 1'b0;
	end
end

always @ (posedge I_pla_312m5_clk) 
begin
    if(I_pla_rst)
	begin
        S_pla_slice_loss_flg <= 1'b0; 
    end 
    else if(I_cnt_clear[0]) 
    begin
        S_pla_slice_loss_flg <= 1'b0; 
    end
    else if(!S_pla_slice_rd_resp_buf && I_pla_slice_rd_resp) 
    begin
		S_pla_slice_loss_flg <= 1'b0;
    end
    else if((S_reflow_state == C_REFLOW_CATCH) && (S1_reflow_catch_add && !S_slice_valid_ram_rd_data))
    begin
		S_pla_slice_loss_flg <= 1'b1;
    end
end

always @ (posedge I_pla_312m5_clk) 
begin
	S_pla_slice_loss_flg_1d <= S_pla_slice_loss_flg	;
end


always @ (posedge I_pla_312m5_clk) 
begin
    if(I_pla_rst)
	begin
        O_pla_reflow_rderr_cnt[31:16] <= 16'd0									;
	end
    else if(I_cnt_clear[0]) 
    begin
        O_pla_reflow_rderr_cnt[31:16] <= 16'd0									;
	end
	else if(S_pla_slice_loss_flg && (!S_pla_slice_loss_flg_1d))
	begin
		O_pla_reflow_rderr_cnt[31:16] <= O_pla_reflow_rderr_cnt[31:16] + 16'd1	;
	end
	else
	begin
		O_pla_reflow_rderr_cnt[31:16] <= O_pla_reflow_rderr_cnt[31:16]			; 
	end
end



always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst)
	begin
		S_pla_slice_rd_req <= 1'd0;
        S_pla_slice_rd_id  <= 15'd0;
	end
    else
    begin
		case(S_reflow_state)
        C_REFLOW_IDLE  :       ///0
        begin
			if(S_slice_current_valid && !S_pla_reflow_fifo_alful)
            begin
				S_pla_slice_rd_id  <= S1_slice_id_current;
                S_pla_slice_rd_req <= 1'b1;
            end
            else
            begin
				S_pla_slice_rd_id  <= S_pla_slice_rd_id;
                S_pla_slice_rd_req <= 1'd0;
            end
        end
        C_REFLOW_CATCH :     ///1
        begin
			if(!S_reflow_catch_add && S_slice_current_valid && !S_pla_reflow_fifo_alful)
            begin
				S_pla_slice_rd_id  <= S1_slice_id_current;
                S_pla_slice_rd_req <= 1'b1;
            end
            else 
            begin
               S_pla_slice_rd_id  <= S_pla_slice_rd_id;
               S_pla_slice_rd_req <= 1'd0;
            end
        end
        default : 
        begin
				S_pla_slice_rd_id  <= S_pla_slice_rd_id;
				S_pla_slice_rd_req <= 1'd0;
        end
		endcase
    end
end

// modified by cqiu
/*
blk_sdpram_32768x1_reflow_k7 U0_blk_sdpram_32768x1_reflow_k7(
.clka		(I_pla_312m5_clk			),
.ena		(1'b1						),
.wea		(S_slice_valid_ram_wr		),
.addra		(S_slice_valid_ram_wr_addr	),
.dina		(S_slice_valid_ram_wr_data	),
.clkb		(I_pla_312m5_clk			),
.rstb		(I_pla_rst					),
.enb		(1'b1						),
.addrb		(S_slice_id_current			),
.doutb		(S_slice_valid_ram_rd_data	)
);
*/

blk_sdpram_16384x4_k7 U0_blk_sdpram_16384x4_k7(
.clka		(I_pla_312m5_clk					),
.ena		(1'b1								),
.wea		(S_slice_valid_ram_wr				),
.addra		(S_slice_valid_ram_wr_addr[13:0]	),
.dina		(S_slice_valid_ram_wr_data[3:0]		),
.clkb		(I_pla_312m5_clk					),
.rstb		(I_pla_rst							),
.enb		(1'b1								),
.addrb		(S_slice_id_current[13:0]			),
.doutb		(S_slice_valid_ram_rd_data[3:0]		)
);


/*
blk_sdpram_32768x1 U_blk_sdpram_32768x1
(
.I_porta_clk    (I_pla_312m5_clk           ),
.I_porta_addr   (S_slice_valid_ram_wr_addr ),
.I_porta_din    (S_slice_valid_ram_wr_data ),
.I_porta_wr     (S_slice_valid_ram_wr      ),
.I_portb_rst    (I_pla_rst                 ),
.I_portb_clk    (I_pla_312m5_clk           ),
.I_portb_addr   (S_slice_id_current        ),
.O_portb_dout   (S_slice_valid_ram_rd_data )
);
*/

always @ (posedge I_pla_312m5_clk)
begin
    S_pla_slice_id_new_valid_buf <= I_pla_slice_id_new_valid;
end

always @ (posedge I_pla_312m5_clk)
begin
    S_pla_slice_rd_req_buf <= S_pla_slice_rd_req;
end

always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst)
	begin
            S_slice_valid_ram_wr_addr <= 14'd0			; 
            S_slice_valid_ram_wr_data <= 1'b0			;  
            S_slice_valid_ram_wr      <= 1'b0			;  
	end
	else if(S_clear_cnt_en) /// clear
	begin
            S_slice_valid_ram_wr_addr <= S_clear_cnt[13:0]	; 
            S_slice_valid_ram_wr_data <= 1'b0;  
            S_slice_valid_ram_wr      <= 1'd1;  
	end
    else if(I_pla_slice_id_new_valid)
        begin
            S_slice_valid_ram_wr_addr <= I_pla_slice_id_new[13:0]			; 
            S_slice_valid_ram_wr_data <= {I_pla_slice_id_new[14:12],1'b1}	;
            S_slice_valid_ram_wr      <= 1'd1;  
        end
    else if((S_pla_slice_rd_req && !S_pla_slice_rd_req_buf) || (S_pla_slice_id_new_valid_buf && S_pla_slice_rd_req_buf))
        begin
            S_slice_valid_ram_wr_addr <= S_pla_slice_rd_id[13:0]			; 
            S_slice_valid_ram_wr_data <= {S_pla_slice_rd_id[14:12],1'b0}	;
            S_slice_valid_ram_wr      <= 1'd1;
        end
    else
        begin
            S_slice_valid_ram_wr_addr <= 14'd0;
            S_slice_valid_ram_wr_data <= 4'd0;
            S_slice_valid_ram_wr      <= 1'd0;
        end
end


//======== ===== =====  write here by cqiu

always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst)
	begin
			S_slice_valid_ram_col      <= 1'b0	;
            S_slice_valid_ram_col_data <= 4'h0	; 
	end
    else if(S_slice_valid_ram_wr)
    begin
		if(S_slice_id_current[13:0] == S_slice_valid_ram_wr_addr[13:0])
        begin
			S_slice_valid_ram_col      <= 1'b1;
            S_slice_valid_ram_col_data <= S_slice_valid_ram_wr_data[3:0];
        end
        else
        begin
			S_slice_valid_ram_col      <= 1'b0;
            S_slice_valid_ram_col_data <= S_slice_valid_ram_col_data;
        end
    end
    else
    begin
			S_slice_valid_ram_col      <= 1'b0;
			S_slice_valid_ram_col_data <= S_slice_valid_ram_col_data;
    end
end

always @ (posedge I_pla_312m5_clk)
begin
    S_slice_valid_ram_col_buf <= S_slice_valid_ram_col;
end

always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
        	  S_slice_current_valid <= 1'b0  ;
        end
    else if(S_slice_valid_ram_col)
        begin
            S_slice_current_valid <= (S_slice_valid_ram_col_data[3:1] == S2_slice_id_current[14:12])
									 && S_slice_valid_ram_col_data[0]	; 
			//S1_slice_id_current
        end
    else
        begin
            S_slice_current_valid <= (S_slice_valid_ram_rd_data[3:1] == S2_slice_id_current[14:12]) 
									 && S_slice_valid_ram_rd_data[0]	;
        end
end

always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_slice_rd_resp && !S_pla_slice_rd_resp_buf)
        begin
            S_pla_slice_data_rd <= 1'b1;
        end
    else if(&S_pla_slice_data_rd_cnt)
        begin
            S_pla_slice_data_rd <= 1'b0;
        end
end

always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_slice_rd_resp && !S_pla_slice_rd_resp_buf && (!S_pla_slice_data_rd) )
    // add by cqiu 2015 0704 0819
        begin
            S_pla_slice_data_rd_cnt <= 6'h0;
        end
    else if(&S_pla_slice_data_rd_cnt)
        begin
            S_pla_slice_data_rd_cnt <= S_pla_slice_data_rd_cnt;
        end
    else
        begin
            S_pla_slice_data_rd_cnt <= S_pla_slice_data_rd_cnt + 6'd1;
        end
end

always @ (posedge I_pla_312m5_clk)
begin
    S_pla_slice_data_rd_buf1 <= S_pla_slice_data_rd;
    S_pla_slice_data_rd_buf2 <= S_pla_slice_data_rd_buf1;
    S_pla_slice_data_rd_buf3 <= S_pla_slice_data_rd_buf2;
    S_pla_slice_data_rd_buf4 <= S_pla_slice_data_rd_buf3;
    S_pla_slice_data_rd_buf5 <= S_pla_slice_data_rd_buf4;
    S_pla_slice_data_rd_buf6 <= S_pla_slice_data_rd_buf5;
    S_pla_slice_data_rd_buf7 <= S_pla_slice_data_rd_buf6;
end

always @ (posedge I_pla_312m5_clk)
begin
    S_pla_slice_rdata_buf <= I_pla_slice_rdata;
end

always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst)
	begin
		S_pla_reflow_fifo_wdata <= 33'h0	;
		S_pla_reflow_fifo_wr    <= 1'b0		;
	end
/*     
    ////  gdp can't process the pluse 
	else if(I_pla_slice_rd_resp && !S_pla_slice_rd_resp_buf && S_pla_slice_loss_flg)
    begin
		S_pla_reflow_fifo_wdata <= 33'h1ffffffff;
		S_pla_reflow_fifo_wr    <= 1'b1;
    end */
	else if(S_pla_slice_data_rd_buf7)
	begin
		S_pla_reflow_fifo_wdata <= {1'b0,I_pla_slice_rdata};
        S_pla_reflow_fifo_wr    <= 1'b1;
    end
    else
    begin
		S_pla_reflow_fifo_wdata <= 33'd0;
        S_pla_reflow_fifo_wr    <= 1'b0;
	end 
end

blk_com_fifo_512x33 U_blk_com_fifo_512x33(
.I_fifo_clk       (I_pla_312m5_clk          ),
.I_fifo_rst       (I_pla_rst                ),
.I_fifo_din       (S_pla_reflow_fifo_wdata  ),
.I_fifo_wr        (S_pla_reflow_fifo_wr     ),
.I_fifo_rd        (I_pla_reflow_fifo_rd     ),
.O_fifo_empty     (O_pla_reflow_fifo_empty  ),
.O_fifo_full      (),
.O_fifo_dout      (O_pla_reflow_fifo_rdata  ),
.O_fifo_usedw     (S_pla_reflow_fifo_usedw  )
);

always @ (posedge I_pla_312m5_clk)
begin
    S_pla_reflow_fifo_usedw_buf <= S_pla_reflow_fifo_usedw;
end

always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst)
    begin
		S_pla_reflow_fifo_alful <= 1'b0;
    end
    else if(|S_pla_reflow_fifo_usedw_buf[9:8])
    begin
		S_pla_reflow_fifo_alful <= 1'b1;
    end
    else
    begin
		S_pla_reflow_fifo_alful <= 1'b0;
    end
end

always @ (posedge I_pla_312m5_clk)
begin
    S1_pla_reflow_fifo_alful <= S_pla_reflow_fifo_alful;
end

assign O_pla_slice_rd_req         = S_pla_slice_rd_req ;
assign O_pla_slice_rd_id          = S_pla_slice_rd_id  ;
assign O_pla_slice_data_rd        = S_pla_slice_data_rd;
assign O_pla_slice_id_depth_alful = S_pla_slice_id_depth_alful;
assign O_pla_reflow_id_wl[15:0]   ={1'b0,S_pla_reflow_id_wl[14:0]};

assign O_pla_reflow_id_wl[31:16]  = {1'b0,S_pla_slice_rd_id} ;
assign O_pla_reflow_id_wl[47:32]  = {14'b0,S_reflow_state_next} ;

reg S_pla_reflow_fifo_rd ;
reg [15:0] S_pla_reflow_rd_id ;
reg S_pla_reflow_fifo_rd_1d	;

always @ (posedge I_pla_312m5_clk )
begin
	S_pla_reflow_fifo_rd_1d		<= I_pla_reflow_fifo_rd	;
end

always @ (posedge I_pla_312m5_clk)
begin
    //S_pla_reflow_fifo_rd <= dbg_pla_reflow_fifo_rd && I_pla_reflow_fifo_rd;
    S_pla_reflow_fifo_rd <= S_pla_reflow_fifo_rd_1d && I_pla_reflow_fifo_rd;
end
    
always @ (posedge I_pla_312m5_clk)
begin
	if (I_pla_slice_rd_resp)
    begin
        S_pla_reflow_rd_id <=O_pla_slice_rd_id	;
    end
	else
	begin
        S_pla_reflow_rd_id <=S_pla_reflow_rd_id	;
	end
end



always @ (posedge I_pla_312m5_clk)
begin
	S_cnt_clear_buf		<= {S_cnt_clear_buf[2:0],I_cnt_clear[1]};
end

always @ (posedge I_pla_312m5_clk)
begin
	if(S_cnt_clear_buf[3:2] == 2'b01)
	begin
		S_clear_cnt_en		<= 1'b1	;
	end
	else if(&S_clear_cnt)
	begin
		S_clear_cnt_en		<= 1'b0	;
	end
	else
	begin
		S_clear_cnt_en		<= S_clear_cnt_en	;	
	end
end

always @ (posedge I_pla_312m5_clk)
begin
	if(S_cnt_clear_buf[2:1] == 2'b01)
	begin
		S_clear_cnt	<= 15'd0;
	end
	else if(S_clear_cnt_en)
	begin
		S_clear_cnt	<= S_clear_cnt	+ 15'd1;
	end
	else
	begin
		S_clear_cnt	<= 15'd0;
	end
end
	

always @ (posedge I_pla_312m5_clk)
begin
	S_pla_reflow_fifo_rdata	<= O_pla_reflow_fifo_rdata[31:0]	;
end


//�����//�����SLICE ID˳����
pla_id_seq_chk U3_pla_id_seq_chk
(
.I_pla_312m5_clk         (I_pla_312m5_clk           ) ,
.I_pla_rst               (I_pla_rst                 ) ,
.I_pla_slice_id          (S_pla_reflow_rd_id        ) ,
.I_pla_slice_payload     (S_pla_reflow_fifo_rdata[31:0] ) ,
.I_pla_slice_en          (S_pla_reflow_fifo_rd      ) ,
.I_cnt_clear             (I_cnt_clear[0]            ) ,
.O_slice_55D5_cnt        (O_reflow_55D5_cnt         ) , 
.O_slice_lose_cnt        (O_reflow_lose_cnt         ) ,
.O_slice_lose_reg        (O_reflow_lose_reg         ) 
);



endmodule
