module pla_backward_slice_crc_check(
input               I_pla_312m5_clk				,
input               I_pla_rst					,
//// pla whole common 10g 
input     [1:0]     I_pla_xgmii_num				,///
input     [14:0]    I_pla_slice_id				,
input     [31:0]    I_pla_slice_payload			,
input               I_pla_slice_payload_en		,
//// pla  group 
input               I_pla_slice_check_ok		,///pulse
input				I_pla_slice_rd_resp			,	
input		[  1:0]	I_pla_rd_xgmii_num			,
input		[ 14:0] I_pla_slice_rd_id			,
input               I_pla_slice_data_rd			,
input		[ 31:0] I_pla_slice_rdata			,
input				I_pla_slice_crc_err_clr		,
output reg	[ 15:0]	O_pla_slice_crc_err_cnt	=16'h0		
);
reg		[  1:0] S_pla_rd_xgmii_num_1d			= 2'b0	;	
reg		[  1:0] S_pla_xgmii_num_1d				= 2'b0	;	
reg		[ 14:0] S_pla_slice_id_1d				= 15'd0	;	
reg		[ 31:0] S_pla_slice_payload_1d			= 32'h0	; 
reg		[ 31:0] S_pla_slice_payload_2d			= 32'h0	; 
reg				S_pla_slice_payload_en_1d		= 1'b0	;
reg				S_pla_slice_payload_en_2d		= 1'b0	;
reg				S_pla_slice_payload_en_3d		= 1'b0	;
reg				S_pla_slice_payload_en_4d		= 1'b0	;
reg				S_pla_slice_payload_en_5d		= 1'b0	;
reg		[  4:0]	S_pla_slice_check_ok_buf		= 5'h0	;
reg		[  4:0] S_pla_slice_rd_resp_buf			= 5'h0	;			
reg		[ 14:0]	S_pla_slice_wr_id_1d			= 15'd0	;
reg		[ 14:0]	S_pla_slice_rd_id_1d			= 15'd0	;
reg		[ 15:0]	S_pla_slice_data_rd_buf			= 16'h0	;
reg		[ 31:0]	S_pla_slice_rdata_1d			= 32'h0	;
reg		[ 31:0] S_crc8_gen_din					= 32'h0	;
reg				S_crc8_gen_din_valid			= 1'b0	;
reg				S_crc8_gen_init					= 1'b0	;
wire	[  7:0]	S_crc8_gen_dout							;
reg		[ 31:0]	S_crc8_gen_dout_1d				= 32'h0	;
wire	[ 31:0] S_crc8_gen_dout_ok						;
reg				S_pla_slice_crc_err_clr_1d		= 1'b0	;
reg		[ 13:0] S_dpram_waddr					= 14'd0	; 
reg		[  8:0]	S_dpram_wdata					= 9'h0	;
reg				S_dpram_wren					= 1'b0	;
reg		[ 13:0] S_dpram_raddr					= 14'd0	; 
wire	[  8:0]	S_dpram_rdata							;
reg		[  8:0] S_crc8_dout_golden				= 9'h0	;
reg		[ 31:0] S_crc8_chk_din					= 32'h0	;
reg				S_crc8_chk_din_valid			= 1'b0	;
reg				S_crc8_chk_init					= 1'b0	;
reg				S_crc8_chk_cnt_en				= 1'b0	;
reg				S_crc8_chk_cnt_en_1d			= 1'b0	;
reg				S_crc8_chk_cnt_en_2d			= 1'b0	;
reg				S_crc8_chk_cnt_en_3d			= 1'b0	;
reg				S_crc8_chk_cnt_en_4d			= 1'b0	;
reg				S_crc8_chk_cnt_en_5d			= 1'b0	;
reg		[  5:0]	S_crc8_chk_cnt					= 6'd0	; 
wire	[  7:0]	S_crc8_chk_dout							;
reg		[  8:0]	S_crc8_chk_dout_1d				= 32'h0	;
reg				S_crc8_chk_err					= 1'b0	;


/////---------------------------------------------------------
///// debug	begin
/////---------------------------------------------------------
//(*MARK_DEBUG ="true"*)reg   [1:0]    dbg_crc8_chk_err			;///
(*MARK_DEBUG ="true"*)reg				dbg_crc8_chk_err		;///
(*MARK_DEBUG ="true"*)reg		[  8:0]	dbg_crc8_chk_dout_1d	;	
(*MARK_DEBUG ="true"*)reg		[  8:0] dbg_crc8_dout_golden	;	
(*MARK_DEBUG ="true"*)reg		[ 14:0] dbg_pla_slice_id		;
(*MARK_DEBUG ="true"*)reg		[ 31:0] dbg_pla_slice_payload	;
(*MARK_DEBUG ="true"*)reg				dbg_pla_slice_payload_en;
(*MARK_DEBUG ="true"*)reg				dbg_pla_slice_check_ok	;
(*MARK_DEBUG ="true"*)reg		[ 14:0] dbg_pla_slice_rd_id		;	
(*MARK_DEBUG ="true"*)reg		[ 31:0] dbg_crc8_chk_din		;	
(*MARK_DEBUG ="true"*)reg				dbg_crc8_chk_din_valid	;	





always @ (posedge I_pla_312m5_clk) 
begin
	dbg_crc8_chk_err		<= S_crc8_chk_err					; 
    dbg_crc8_chk_dout_1d	<= S_crc8_chk_dout_1d				;
    dbg_crc8_dout_golden	<= S_crc8_dout_golden				;
    dbg_pla_slice_id		<= I_pla_slice_id					;	
    dbg_pla_slice_payload	<= I_pla_slice_payload				;	
    dbg_pla_slice_payload_en<= I_pla_slice_payload_en			;
	dbg_pla_slice_check_ok	<= S_pla_slice_check_ok_buf[3]		;
	dbg_pla_slice_rd_id		<= I_pla_slice_rd_id				;
	dbg_crc8_chk_din		<= S_crc8_chk_din					; 
    dbg_crc8_chk_din_valid	<= S_crc8_chk_din_valid				;
end

/////---------------------------------------------------------
///// debug end	
/////---------------------------------------------------------




always @ (posedge I_pla_312m5_clk) 
begin
	S_pla_xgmii_num_1d			<=	I_pla_xgmii_num											;	
	S_pla_slice_id_1d			<=  I_pla_slice_id											;	
	S_pla_slice_payload_1d		<=  I_pla_slice_payload										;
	S_pla_slice_payload_2d		<=  S_pla_slice_payload_1d									;
	S_pla_slice_payload_en_1d	<=  I_pla_slice_payload_en									; 
	S_pla_slice_payload_en_2d	<=  S_pla_slice_payload_en_1d								; 
	S_pla_slice_payload_en_3d	<=  S_pla_slice_payload_en_2d								; 
	S_pla_slice_payload_en_4d	<=  S_pla_slice_payload_en_3d								; 
	S_pla_slice_payload_en_5d	<=  S_pla_slice_payload_en_4d								; 
	S_pla_slice_check_ok_buf	<= {S_pla_slice_check_ok_buf[3:0],I_pla_slice_check_ok}		; 
	S_pla_slice_rd_resp_buf		<= {S_pla_slice_rd_resp_buf[3:0],I_pla_slice_rd_resp}		;		
	S_pla_slice_wr_id_1d		<= S_pla_slice_id_1d										;
	S_pla_slice_data_rd_buf		<= {S_pla_slice_data_rd_buf[14:0],I_pla_slice_data_rd}		;
	S_pla_slice_rdata_1d		<= I_pla_slice_rdata										;
	S_pla_slice_crc_err_clr_1d	<= I_pla_slice_crc_err_clr									;
end

always @ (posedge I_pla_312m5_clk) 
begin
	if(S_pla_slice_rd_resp_buf[0] && (!S_pla_slice_rd_resp_buf[1]) )
	begin
		S_pla_rd_xgmii_num_1d		<= I_pla_rd_xgmii_num		;
		S_pla_slice_rd_id_1d		<= I_pla_slice_rd_id		;
	end
	else
	begin
		S_pla_rd_xgmii_num_1d		<= S_pla_rd_xgmii_num_1d	;
		S_pla_slice_rd_id_1d		<= S_pla_slice_rd_id_1d		;
	end
end
	



////==== crc generator
always @ (posedge I_pla_312m5_clk) 
begin
	if(I_pla_rst)
	begin
		S_crc8_gen_din			<= 32'h0	;
		S_crc8_gen_din_valid	<= 1'b0		;
	end
	else if(S_pla_slice_payload_en_2d)
	begin
		S_crc8_gen_din			<= S_pla_slice_payload_2d	;
		S_crc8_gen_din_valid	<= 1'b1						;
	end
	else if((!S_pla_slice_payload_en_2d) && S_pla_slice_payload_en_3d)
	begin
		S_crc8_gen_din			<={	15'd0,	
								S_pla_xgmii_num_1d[1:0],
								S_pla_slice_id_1d[14:0]}	;	
		S_crc8_gen_din_valid	<= 1'b1						;
	end
	else
	begin
		S_crc8_gen_din			<= 32'h0					; 
		S_crc8_gen_din_valid	<= 1'b0						;
	end
end

always @ (posedge I_pla_312m5_clk) 
begin
	S_crc8_gen_init	<= S_pla_slice_payload_en_1d && (!S_pla_slice_payload_en_2d) ;
end

pla_backward_slice_crc8_d32 U0_pla_backward_slice_crc8_d32_gen(
.c			(						),
.crc_out	(S_crc8_gen_dout		),
.d			(S_crc8_gen_din			),
.calc		(1'b1					),
.init		(S_crc8_gen_init		),
.d_valid	(S_crc8_gen_din_valid	),
.clk		(I_pla_312m5_clk		),
.reset		(I_pla_rst				)
);


always @ (posedge I_pla_312m5_clk) 
begin
	S_dpram_waddr	<= S_pla_slice_wr_id_1d[13:0]	;
	S_dpram_wren	<= S_pla_slice_check_ok_buf[3] && (!S_pla_slice_check_ok_buf[2])	;
	S_dpram_raddr	<= S_pla_slice_rd_id_1d[13:0]	;
end

always @ (posedge I_pla_312m5_clk) 
begin
	if((!S_pla_slice_payload_en_4d) && S_pla_slice_payload_en_5d)
	begin
		S_dpram_wdata	<= {1'b0,S_crc8_gen_dout}; 
	end
	else
	begin
		S_dpram_wdata	<= S_dpram_wdata		; 
	end
end
//	if((!S_pla_slice_payload_en_4d) && S_pla_slice_payload_en_5d)

blk_sdpram_16384x9_k7 U0_blk_sdpram_16384x9_k7(
.clka	(I_pla_312m5_clk	),
.ena	(1'b1				),
.wea	(S_dpram_wren		),
.addra	(S_dpram_waddr		),
.dina	(S_dpram_wdata		),
.clkb	(I_pla_312m5_clk	),
.enb	(1'b1				),
.addrb	(S_dpram_raddr		),
.doutb	(S_dpram_rdata		)
);



////==== crc check

always @ (posedge I_pla_312m5_clk) 
begin
	S_crc8_chk_init			<= S_pla_slice_data_rd_buf[1] && (!S_pla_slice_data_rd_buf[2]);
	S_crc8_chk_cnt_en_1d	<= S_crc8_chk_cnt_en		;	
	S_crc8_chk_cnt_en_2d	<= S_crc8_chk_cnt_en_1d		;	
	S_crc8_chk_cnt_en_3d	<= S_crc8_chk_cnt_en_2d		;	
	S_crc8_chk_cnt_en_4d	<= S_crc8_chk_cnt_en_3d		;	
	S_crc8_chk_cnt_en_5d	<= S_crc8_chk_cnt_en_4d		;	
end



always @ (posedge I_pla_312m5_clk) 
begin
	if( S_pla_slice_data_rd_buf[6] && (!S_pla_slice_data_rd_buf[7])) 
	// by cqiu
	begin
		S_crc8_chk_cnt_en	<= 1'b1					;
	end
	else if(&S_crc8_chk_cnt)
	begin
		S_crc8_chk_cnt_en	<= 1'b0					;
	end
	else
	begin
		S_crc8_chk_cnt_en	<= S_crc8_chk_cnt_en	;	
	end
end

always @ (posedge I_pla_312m5_clk) 
begin
	if(S_crc8_chk_cnt_en)
	begin
		S_crc8_chk_cnt	<= S_crc8_chk_cnt + 6'd1	;	 
	end
	else
	begin
		S_crc8_chk_cnt	<= 6'd0	; 
	end
end



always @ (posedge I_pla_312m5_clk) 
begin
	if(S_crc8_chk_cnt_en)
	begin
		S_crc8_chk_din_valid	<= 1'b1					;
		S_crc8_chk_din			<= S_pla_slice_rdata_1d	;	
	end
	else if((!S_crc8_chk_cnt_en) && S_crc8_chk_cnt_en_1d)
	begin
		S_crc8_chk_din_valid	<= 1'b1					;
		S_crc8_chk_din			<= {15'd0,
									S_pla_rd_xgmii_num_1d[1:0],		
									S_pla_slice_rd_id_1d[14:0]
									}	;
	end
	else
	begin
		S_crc8_chk_din_valid	<= 1'b0					;
		S_crc8_chk_din			<= 32'h0				; 
	end
end
	

always @ (posedge I_pla_312m5_clk) 
begin
	if( (!S_crc8_chk_cnt_en_3d) && S_crc8_chk_cnt_en_4d)
	begin
		S_crc8_chk_dout_1d	<= S_crc8_chk_dout		; 
	end
	else
	begin
		S_crc8_chk_dout_1d	<= S_crc8_chk_dout_1d	;
	end
end


always @ (posedge I_pla_312m5_clk) 
begin
	if( (S_crc8_chk_cnt_en_1d) && (!S_crc8_chk_cnt_en_2d))
	begin
		S_crc8_dout_golden <= S_dpram_rdata		; 
	end
	else
	begin
		S_crc8_dout_golden <= S_crc8_dout_golden; 
	end
end


always @ (posedge I_pla_312m5_clk) 
begin
	if( (!S_crc8_chk_cnt_en_4d) && S_crc8_chk_cnt_en_5d)
	begin
		S_crc8_chk_err <= ( S_crc8_chk_dout_1d != S_crc8_dout_golden ); 
	end
	else
	begin
		S_crc8_chk_err <= 1'b0	; 
	end
end


always @ (posedge I_pla_312m5_clk) 
begin
	if(S_pla_slice_crc_err_clr_1d)
	begin
		O_pla_slice_crc_err_cnt	<= 16'd0						;
	end
	else if(&O_pla_slice_crc_err_cnt)
	begin
		O_pla_slice_crc_err_cnt	<= O_pla_slice_crc_err_cnt			;	
	end
	else if(S_crc8_chk_err)
	begin
		O_pla_slice_crc_err_cnt	<= O_pla_slice_crc_err_cnt +	16'd1	;
	end
end
	


pla_backward_slice_crc8_d32 U0_pla_backward_slice_crc8_d32_chk(
.c			(						),
.crc_out	(S_crc8_chk_dout		),
.d			(S_crc8_chk_din			),
.calc		(1'b1					),
.init		(S_crc8_chk_init		),
.d_valid	(S_crc8_chk_din_valid	),
.clk		(I_pla_312m5_clk		),
.reset		(I_pla_rst				)
);


endmodule