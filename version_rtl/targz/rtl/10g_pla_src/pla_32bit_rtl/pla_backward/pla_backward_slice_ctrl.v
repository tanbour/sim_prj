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
//x                    |--U01_wr_buff1         WRBUFFER1
//x                    |--U02_wr_buff2         WRBUFFER2
//x pla_back_ddr_ctrl--|--
//x                    |--U04_rdbuffer         RDBUFFER1
//x                    |--S_slice_state_next   ״̬��
//----------------------------------------------------------------------------
//----------------------------------------------------------------------------
//Version         Date           Author        Description
// 1.1          nov-4-2015      Li Shuai        pla_schedule
// 1.2
//----------------------------------------------------------------------------

module pla_backward_slice_ctrl
(
//==============================================
input				I_pla_312m5_clk			,
input               I_pla_rst               ,

input               I_pla_slice_rd_req		,
output reg          O_pla_slice_rd_resp		,
input		[ 14:0] I_pla_slice_rd_id		,
input		[  1:0] I_pla_xgmii_num			,	
input               I_pla_slice_rd_en		,
output reg	[ 31:0] O_pla_slice_rdata		,
//output reg	[  8:0] O_ddr3_wrbuf2_usedw	= 9'h0	,

input		[143:0] I_wrbuf2_fifo_wdata		,	
input				I_wrbuf2_fifo_wren		,
input               I_ddr_clk				,
input               I_ddr_rst				,
output reg	[  2:0]	O_app_cmd				,///input
output reg			O_app_en				,///input
output		[ 27:0]	O_app_addr				,///input
input				I_app_rdy				,///output

//====maintenance begin
input				I_cnt_clear							,
output reg	[ 15:0]	O_app_wdf_rdy_low_cnt_max	= 16'h0	,	
output reg	[ 15:0]	O_wr_app_rdy_low_cnt_max	= 16'h0	,	
output reg	[ 15:0]	O_rd_app_rdy_low_cnt_max	= 16'h0	,	
output reg	[ 15:0] O_app_write_err_cnt			= 16'h0	,	
output reg	[ 15:0]	O_ddr3_buf_full_cnt			= 16'h0	,	
input				I_crc8_chk_err						,
//====maintenance end 

output reg			O_app_wdf_wren			,///input
output reg			O_app_wdf_end			,///input
output reg  [127:0]	O_app_wdf_data			,///input
input				I_app_wdf_rdy			,///output

input		[127:0]	I_app_rd_data			,///output 
input				I_app_rd_data_valid		,///output
input				I_app_rd_data_end		 ///output

);



                    
parameter		C_SLICE_IDLE		= 5'b00001	;
parameter		C_SLICE_WR			= 5'b00010	; 
parameter		C_SLICE_WR_BUS		= 5'b00100	; 
parameter		C_SLICE_RD			= 5'b01000	;
parameter		C_SLICE_RD_BUS		= 5'b10000	; 
parameter		C_POS_IDLE			= 3'd0		;
parameter		C_POS_WR			= 3'd1		; 
parameter		C_POS_WR_BUS		= 3'd2		; 
parameter		C_POS_RD			= 3'd3		;
parameter		C_POS_RD_BUS		= 3'd4		; 

    

reg		[  1:0]	S_wrbuf2_4w_cnt			= 2'd0		;
reg				S_wrbuf2_dpram_wr_pre	= 1'b0		;           
reg		[  3:0]	S_pla_slice_rd_en_buf	= 4'b0		;	





reg				S_wrbuf2_fifo_wren					;
reg		[  3:0] S_pla_slice_rd_req_buf		 =4'h0	;
reg		[  3:0] S_rdbuf1_dpram_waddr_end_buf =4'h0	;
reg		[ 31:0]	S_pla_slice_rdata					; 
reg		[  5:0]	S_rdbuf1_dpram_raddr				;
wire	[127:0]	S_rdbuf1_dpram_rdata				;	
wire 	[  8:0] S_wrbuf2_usedw						;
//// I_ddr_clk domain
reg				R_ddr_invalid						;
wire	[143:0]	R_wrbuf2_fifo_rdata					; 
reg		[143:0]	R_wrbuf2_fifo_rdata_1d				; 
reg				R_wrbuf2_fifo_rdata_1d_end			;
reg				R_app_wdf_data_end					; 

wire			R_wrbuf2_fifo_rden					;
reg		[  4:0]	R_wrbuf2_fifo_rdcnt					;
reg		[  3:0]	R_wrbuf2_fifo_rden_buf				;
wire			R_wrbuf2_fifo_empty					;
reg		[  4:0]	R_wrbuf2_fifo_empty_buf				;
reg		[  4:0]	R_slice_state						;
reg		[  4:0]	R_slice_state_1d					;
reg		[  4:0]	R_slice_state_2d					;
reg		[  4:0]	R_slice_state_3d					;
reg		[  4:0]	R_slice_state_4d					;
reg		[  4:0]	R_slice_state_5d					;
reg		[  4:0]	R_slice_state_6d					;
reg		[  4:0]	R_slice_state_next					;
reg		[  3:0]	R_pla_slice_rd_req_buf				;
reg				R_pla_slice_rd_req_lck				;
reg		[  4:0]	R_app_wdf_wren_cnt					;
reg				R_slice_wr_cnt_end					;
reg				R_slice_wr_cnt_end_1d				;

reg		[ 15:0] R_app_addr_h						;
reg		[  3:0] R_app_addr_l						;

reg		[ 15:0] R_app_waddr_h						;
reg				R_app_waddr_h_en					;
reg				R_app_waddr_h_en_1d					;
reg		[  3:0] R_app_wr_cnt						;
reg		[  3:0] R_app_rd_cnt						;
reg				R_app_en_1d							;

reg				R_slice_wr_cnt_en					;
reg		[  3:0]	R_slice_rd_cnt						;
reg		[  3:0]	R_slice_rd_cnt_1d					;
reg		[  3:0]	R_slice_rd_cnt_2d					;
reg		[ 14:0] R_pla_slice_rd_id		= 15'h0		;
reg		[  1:0] R_pla_xgmii_num			= 2'b0		;
reg		[  1:0] R_pla_xgmii_num_1d		= 2'b0		;
reg		[  1:0] R_pla_xgmii_num_2d		= 2'b0		;
reg		[ 14:0] R_pla_slice_rd_id_1d	= 15'h0		;
reg		[ 14:0] R_pla_slice_rd_id_2d	= 15'h0		;
reg				R_rdbuf1_dpram_wr		= 1'b0		;
reg		[127:0]	R_rdbuf1_dpram_wdata	= 128'h0	; 
reg		[  3:0]	R_rdbuf1_dpram_waddr	= 4'h0		;
reg				R_rdbuf1_dpram_waddr_end= 1'b0		;
reg		[  3:0] R_rdbuf1_dpram_waddr_end_buf		;
//reg		[  8:0] R_wrbuf2_usedw						;
//reg		[  8:0] R_wrbuf2_usedw_1d					;
reg				R_wrbuf2_rd_trigger					;
/////====Maintenance
reg		[ 15:0]	R_app_wdf_rdy_low_cnt		= 16'h0	;
reg		[ 15:0]	R_wr_app_rdy_low_cnt		= 16'h0	;
reg		[ 15:0]	R_rd_app_rdy_low_cnt		= 16'h0	;
reg		[ 15:0]	R_app_wdf_rdy_low_cnt_max	= 16'h0	;
reg		[ 15:0]	R_wr_app_rdy_low_cnt_max	= 16'h0	;
reg		[ 15:0]	R_rd_app_rdy_low_cnt_max	= 16'h0	;
reg		[  3:0]	R_app_wdf_rdy_buf			= 4'h0	;
reg		[  3:0]	R_app_rdy_buf				= 4'h0	;
reg		[  3:0]	R_cnt_clear_buf				= 4'h0	;
reg				R_app_write_err				= 1'b0	;
reg		[ 15:0] R_app_write_err_cnt			= 16'h0	;
reg		[ 15:0]	S_app_wdf_rdy_low_cnt_max_1d	= 16'h0	;
reg		[ 15:0]	S_app_wdf_rdy_low_cnt_max_2d	= 16'h0	;
reg		[ 15:0]	S_wr_app_rdy_low_cnt_max_1d		= 16'h0	;
reg		[ 15:0]	S_wr_app_rdy_low_cnt_max_2d		= 16'h0	;
reg		[ 15:0]	S_rd_app_rdy_low_cnt_max_1d		= 16'h0	;
reg		[ 15:0]	S_rd_app_rdy_low_cnt_max_2d		= 16'h0	;
reg		[ 15:0] S_app_write_err_cnt_1d			= 16'h0	;
reg		[ 15:0] S_app_write_err_cnt_2d			= 16'h0	;
reg				R_crc8_chk_err			= 1'b0	;
reg		[  8:0]	S_wrbuf2_usedw_1d		= 9'h0	;
reg		[  8:0]	S_wrbuf2_usedw_2d		= 9'h0	;
reg				S_wrbuf2_almost_full	= 1'b0	;
reg				S_wrbuf2_almost_full_1d = 1'b0	;
reg		[  3:0]	S_cnt_clear_buf			= 4'h0	;
reg		[  4:0]	S_crc8_chk_err_buf		= 5'h0	;


/*
reg				S_wrbuf2_no_empty		= 1'b0	;
reg		[  7:0]	S_wrbuf2_no_empty_buf	= 8'h0	;
reg		[  3:0] R_wrbuf2_no_empty_buf	= 4'h0	;
*/

/////---------------------------------------------------------
///// debug	begin
/////---------------------------------------------------------

(* MARK_DEBUG="true" *) reg  [  2:0] rdbg_O_app_cmd				;///input
(* MARK_DEBUG="true" *) reg  	     rdbg_O_app_en				;///input
(* MARK_DEBUG="true" *) reg  [  7:0] rdbg_O_app_addr			;///input
(* MARK_DEBUG="true" *) reg  	     rdbg_I_app_rdy				;///output
(* MARK_DEBUG="true" *) reg  	     rdbg_O_app_wdf_wren		;///input
(* MARK_DEBUG="true" *) reg  	     rdbg_O_app_wdf_end			;///input
(* MARK_DEBUG="true" *) reg  [ 31:0] rdbg_O_app_wdf_data		;///input
(* MARK_DEBUG="true" *) reg  	     rdbg_I_app_wdf_rdy			;///output
(* MARK_DEBUG="true" *) reg  [ 31:0] rdbg_I_app_rd_data			;///output 
(* MARK_DEBUG="true" *) reg  	     rdbg_I_app_rd_data_valid	;///output
(* MARK_DEBUG="true" *) reg  	     rdbg_R_crc8_chk_err		;///output

(* MARK_DEBUG="true" *) reg			 rdbg_R_app_wdf_data_end		; 
(* MARK_DEBUG="true" *) reg			 rdbg_R_wrbuf2_fifo_rden		;
(* MARK_DEBUG="true" *) reg	[  4:0]	 rdbg_R_wrbuf2_fifo_rdcnt		;
(* MARK_DEBUG="true" *) reg	[  3:0]	 rdbg_R_wrbuf2_fifo_rden_buf	;
(* MARK_DEBUG="true" *) reg			 rdbg_R_wrbuf2_fifo_empty		;
(* MARK_DEBUG="true" *) reg	[  4:0]	 rdbg_R_wrbuf2_fifo_empty_buf	;
(* MARK_DEBUG="true" *) reg	[  4:0]	 rdbg_R_slice_state				;
(* MARK_DEBUG="true" *) reg	[  4:0]	 rdbg_R_slice_state_next		;
(* MARK_DEBUG="true" *) reg	[  3:0]	 rdbg_R_pla_slice_rd_req_buf	;
(* MARK_DEBUG="true" *) reg			 rdbg_R_pla_slice_rd_req_lck	;
(* MARK_DEBUG="true" *) reg	[  4:0]	 rdbg_R_app_wdf_wren_cnt		;
(* MARK_DEBUG="true" *) reg			 rdbg_R_slice_wr_cnt_end		;
(* MARK_DEBUG="true" *) reg			 rdbg_R_slice_wr_cnt_end_1d		;
(* MARK_DEBUG="true" *) reg	[ 15:0]  rdbg_R_app_addr_h				;
(* MARK_DEBUG="true" *) reg	[  3:0]  rdbg_R_app_addr_l				;
(* MARK_DEBUG="true" *) reg	[ 15:0]  rdbg_R_app_waddr_h				;
(* MARK_DEBUG="true" *) reg			 rdbg_R_app_waddr_h_en			;
(* MARK_DEBUG="true" *) reg			 rdbg_R_app_waddr_h_en_1d		;
(* MARK_DEBUG="true" *) reg	[  3:0]  rdbg_R_app_wr_cnt				;
(* MARK_DEBUG="true" *) reg	[  3:0]  rdbg_R_app_rd_cnt				;
(* MARK_DEBUG="true" *) reg			 rdbg_R_app_en_1d				;
(* MARK_DEBUG="true" *) reg			 rdbg_R_slice_wr_cnt_en			;
(* MARK_DEBUG="true" *) reg	[  3:0]	 rdbg_R_slice_rd_cnt			;
(* MARK_DEBUG="true" *) reg	[  3:0]	 rdbg_R_slice_rd_cnt_1d			;
(* MARK_DEBUG="true" *) reg	[  3:0]	 rdbg_R_slice_rd_cnt_2d			;
(* MARK_DEBUG="true" *) reg	[ 14:0]  rdbg_R_pla_slice_rd_id			;	
(* MARK_DEBUG="true" *) reg	[  1:0]  rdbg_R_pla_xgmii_num			;	
(* MARK_DEBUG="true" *) reg	[ 14:0]  rdbg_R_pla_slice_rd_id_1d		;	
(* MARK_DEBUG="true" *) reg			 rdbg_R_rdbuf1_dpram_wr			;	
(* MARK_DEBUG="true" *) reg	[127:0]	 rdbg_R_rdbuf1_dpram_wdata		;	
(* MARK_DEBUG="true" *) reg	[  3:0]	 rdbg_R_rdbuf1_dpram_waddr		;	
(* MARK_DEBUG="true" *) reg			 rdbg_R_rdbuf1_dpram_waddr_end	;
(* MARK_DEBUG="true" *) reg			 rdbg_R_wrbuf2_rd_trigger		;
always @(posedge I_ddr_clk)
begin
	rdbg_O_app_cmd				<= O_app_cmd				;	
    rdbg_O_app_en				<= O_app_en					;	
    rdbg_O_app_addr				<= O_app_addr[ 7:0]			; 
    rdbg_I_app_rdy				<= I_app_rdy				;	
    rdbg_O_app_wdf_wren			<= O_app_wdf_wren			; 
    rdbg_O_app_wdf_end			<= O_app_wdf_end			;	
    rdbg_O_app_wdf_data			<= O_app_wdf_data[ 31:0]	; 
    rdbg_I_app_wdf_rdy			<= I_app_wdf_rdy			;	
    rdbg_I_app_rd_data			<= I_app_rd_data[ 31:0]		;	
    rdbg_I_app_rd_data_valid	<= I_app_rd_data_valid		;
	rdbg_R_crc8_chk_err			<= R_crc8_chk_err			;

	rdbg_R_app_wdf_data_end			<= R_app_wdf_data_end				; 
	rdbg_R_wrbuf2_fifo_rden			<= R_wrbuf2_fifo_rden				;
	rdbg_R_wrbuf2_fifo_rdcnt		<= R_wrbuf2_fifo_rdcnt				;
	rdbg_R_wrbuf2_fifo_rden_buf		<= R_wrbuf2_fifo_rden_buf			;
	rdbg_R_wrbuf2_fifo_empty		<= R_wrbuf2_fifo_empty				;
	rdbg_R_wrbuf2_fifo_empty_buf	<= R_wrbuf2_fifo_empty_buf			;
	rdbg_R_slice_state				<= R_slice_state					;
	rdbg_R_slice_state_next			<= R_slice_state_next				;
	rdbg_R_pla_slice_rd_req_buf		<= R_pla_slice_rd_req_buf			;
	rdbg_R_pla_slice_rd_req_lck		<= R_pla_slice_rd_req_lck			;
	rdbg_R_app_wdf_wren_cnt			<= R_app_wdf_wren_cnt				;
	rdbg_R_slice_wr_cnt_end			<= R_slice_wr_cnt_end				;
	rdbg_R_slice_wr_cnt_end_1d		<= R_slice_wr_cnt_end_1d			;
	rdbg_R_app_addr_h				<= R_app_addr_h						;
	rdbg_R_app_addr_l				<= R_app_addr_l						;
	rdbg_R_app_waddr_h				<= R_app_waddr_h					;
	rdbg_R_app_waddr_h_en			<= R_app_waddr_h_en					;
	rdbg_R_app_waddr_h_en_1d		<= R_app_waddr_h_en_1d				;
	rdbg_R_app_wr_cnt				<= R_app_wr_cnt						;
	rdbg_R_app_rd_cnt				<= R_app_rd_cnt						;
	rdbg_R_app_en_1d				<= R_app_en_1d						;
	rdbg_R_slice_wr_cnt_en			<= R_slice_wr_cnt_en				;
	rdbg_R_slice_rd_cnt				<= R_slice_rd_cnt					;
	rdbg_R_slice_rd_cnt_1d			<= R_slice_rd_cnt_1d				;
	rdbg_R_slice_rd_cnt_2d			<= R_slice_rd_cnt_2d				;
	rdbg_R_pla_slice_rd_id			<= R_pla_slice_rd_id				;	
	rdbg_R_pla_xgmii_num			<= R_pla_xgmii_num					;	
	rdbg_R_pla_slice_rd_id_1d		<= R_pla_slice_rd_id_1d				;	
	rdbg_R_rdbuf1_dpram_wr			<= R_rdbuf1_dpram_wr				;	
	rdbg_R_rdbuf1_dpram_wdata		<= R_rdbuf1_dpram_wdata				;	
	rdbg_R_rdbuf1_dpram_waddr		<= R_rdbuf1_dpram_waddr				;	
	rdbg_R_rdbuf1_dpram_waddr_end	<= R_rdbuf1_dpram_waddr_end			;
	rdbg_R_wrbuf2_rd_trigger		<= R_wrbuf2_rd_trigger				;


end

/////---------------------------------------------------------
///// debug end	
/////---------------------------------------------------------
always @ (posedge I_pla_312m5_clk) 
begin
	S_crc8_chk_err_buf	<= {S_crc8_chk_err_buf[3:0],I_crc8_chk_err};	
end

always @ (posedge I_ddr_clk) 
begin
	R_crc8_chk_err		<= |S_crc8_chk_err_buf	;
end


///========I_pla_312m5_clk============================================                  
////=== delay
always @ (posedge I_pla_312m5_clk) 
begin
	/*
    if(I_pla_rst)
    begin
		S_pla_slice_rd_req_buf		<= 4'h0			;
		S_rdbuf1_dpram_waddr_end_buf<= 4'h0			;
		//O_ddr3_wrbuf2_usedw			<= 9'd0			;
		S_pla_slice_rd_en_buf		<= 4'h0			;	
    end
    else
    begin
	*/
		S_pla_slice_rd_req_buf		<= {S_pla_slice_rd_req_buf[2:0],I_pla_slice_rd_req}				; 
		S_rdbuf1_dpram_waddr_end_buf<= {S_rdbuf1_dpram_waddr_end_buf[2:0],|R_rdbuf1_dpram_waddr_end_buf[3:2]}	;
		//O_ddr3_wrbuf2_usedw			<= S_wrbuf2_usedw		;
		S_pla_slice_rd_en_buf		<= {S_pla_slice_rd_en_buf[2:0],I_pla_slice_rd_en}	;	
	//end
end




///128 wr data
blk_diff_fifo_512x144_k7	U1_blk_diff_fifo_512x144_k7(
	.rst			(I_ddr_rst				),
	.wr_clk			(I_pla_312m5_clk		),
	.rd_clk			(I_ddr_clk				),
	//.din			(S_wrbuf2_fifo_wdata_1d[143:0]),
	//.wr_en			(S_wrbuf2_fifo_wren		),
	.din			(I_wrbuf2_fifo_wdata[143:0]),
	.wr_en			(I_wrbuf2_fifo_wren		),
	.rd_en			(R_wrbuf2_fifo_rden		),
	.dout			(R_wrbuf2_fifo_rdata[143:0]	),
	.full			(						),
	.empty			(R_wrbuf2_fifo_empty	),
//	.rd_data_count	(R_wrbuf2_usedw			),
	.rd_data_count	(),
	.wr_data_count	(S_wrbuf2_usedw			)
);


///////////////////////////////////////Begin Here////////////////////////////////////////
///////////////////////////////////////Begin Here////////////////////////////////////////
///////////////////////////////////////Begin Here////////////////////////////////////////
///////////////////////////////////////Begin Here////////////////////////////////////////
///////////////////////////////////////Begin Here////////////////////////////////////////
///////////////////////////////////////Begin Here////////////////////////////////////////
always @ (posedge I_ddr_clk)
begin
    if(I_ddr_rst)
    begin
		R_wrbuf2_rd_trigger			<= 1'b0					;
	end
	//else if((!R_wrbuf2_fifo_empty) && R_slice_state[C_POS_IDLE])
	else if((!R_wrbuf2_fifo_empty) && R_slice_state_next[C_POS_IDLE])
		//

	begin
		R_wrbuf2_rd_trigger			<= 1'b1					;
	end
	else if(R_slice_state[C_POS_WR])
	begin
		R_wrbuf2_rd_trigger			<= 1'b0					;
	end
	else
	begin
		R_wrbuf2_rd_trigger			<= R_wrbuf2_rd_trigger	;
	end
end

assign R_wrbuf2_fifo_rden = I_app_wdf_rdy && R_slice_state[C_POS_WR] && (!R_wrbuf2_fifo_rdcnt[4]);



always @ (posedge I_ddr_clk)
begin
    if(I_ddr_rst)
    begin
			R_wrbuf2_fifo_rdcnt	<= 5'd0							; 
	end
	else if(R_slice_state[C_POS_WR])
	begin
		if(R_wrbuf2_fifo_rden) 
		begin
			R_wrbuf2_fifo_rdcnt	<= R_wrbuf2_fifo_rdcnt + 5'd1	; 
		end
		else
		begin
			R_wrbuf2_fifo_rdcnt	<= R_wrbuf2_fifo_rdcnt			; 
		end
	end
	else
	begin
			R_wrbuf2_fifo_rdcnt	<= 5'd0							; 
	end
end



always @ (posedge I_ddr_clk)
begin
    if(I_ddr_rst)
    begin
		R_wrbuf2_fifo_rdata_1d	<= 144'd0					;
	end
	else if( R_wrbuf2_fifo_rden || (R_wrbuf2_fifo_rdcnt[4]&&I_app_wdf_rdy)) //the end 
	begin
		R_wrbuf2_fifo_rdata_1d	<= R_wrbuf2_fifo_rdata		;
	end
	else
	begin
		R_wrbuf2_fifo_rdata_1d	<= R_wrbuf2_fifo_rdata_1d	;
	end
end

///////////////////// I_app_wdf_rdy and O_app_wdf_data process////////
///////////////////// I_app_wdf_rdy and O_app_wdf_data process////////
///////////////////// I_app_wdf_rdy and O_app_wdf_data process////////
///////////////////// I_app_wdf_rdy and O_app_wdf_data process////////
///////////////////// I_app_wdf_rdy and O_app_wdf_data process////////
always @ (posedge I_ddr_clk)
begin
    if(I_ddr_rst)
    begin
			R_wrbuf2_fifo_rdata_1d_end	<= 1'b0	;
	end
	else if(R_slice_state[C_POS_WR])
	begin
		if( (R_wrbuf2_fifo_rdcnt[4]&&I_app_wdf_rdy)) //the fifo_rdata_1d end 
		begin
			R_wrbuf2_fifo_rdata_1d_end	<= 1'b1	;
		end
		else
		begin
			R_wrbuf2_fifo_rdata_1d_end	<= R_wrbuf2_fifo_rdata_1d_end	;	
		end
	end
	else
	begin
			R_wrbuf2_fifo_rdata_1d_end	<= 1'b0	;
	end
end

always @ (posedge I_ddr_clk)
begin
    if(I_ddr_rst)
    begin
			R_app_wdf_data_end		<= 1'b0	;	
	end
	else if(R_slice_state[C_POS_WR])
	begin
		if( R_wrbuf2_fifo_rdcnt[4]&&I_app_wdf_rdy && R_wrbuf2_fifo_rdata_1d_end) //the fifo_rdata_1d end 
		begin
			R_app_wdf_data_end		<= 1'b1	;	
		end
		else
		begin
			R_app_wdf_data_end		<= R_app_wdf_data_end		;	
		end
	end
	else
	begin
			R_app_wdf_data_end		<= 1'b0	;	
	end
end





always @(posedge I_ddr_clk)
begin
	if(I_ddr_rst)
	begin
			O_app_wdf_data		<= 128'd0							;
	end
	else if(I_app_wdf_rdy)
	begin
			O_app_wdf_data		<= R_wrbuf2_fifo_rdata_1d[127:0]	; 
	end
	else
	begin
			O_app_wdf_data		<= O_app_wdf_data					;	
	end
end
////    __    __    __    __    __    __    __    __    __    __    __    __    __
//// __|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  |
////
////                     _____________
////R_wrbuf2_fifo_rden                |____________________________________________
//// 
////R_wrbuf2_fifo_rdcnt    0xe | 0xf  | 0x10 0x10 ... ...
////
////                     _____________       _____      _____       ______________
////I_app_wdf_rdy                     |_____|     |____|     |_____|
////
////R_wrbuf2_fifo_rdata	   d13 | d14  | d15  d15  ... ...
////
////R_wrbuf2_fifo_rdata_1d d12 | d13  | d14  d14  | d15  d15 ... 
////
////O_app_wdf_data		   d11 | d12  | d13  d13  | d14  d14 | d15 d15 ...
////
////											   ____________________________
////R_wrbuf2_fifo_rdata_1d_end  __________________|	
////
////														   ________________
////R_app_wdf_data_end			______________________________|	    
////
////                            ________________________________________
////O_app_wdf_end			                                            |_______


always @(posedge I_ddr_clk)
begin
	if(I_ddr_rst)
	begin
		O_app_wdf_end			<= 1'b0	; 
		O_app_wdf_wren			<= 1'b0	;
	end
	else if(R_app_wdf_data_end && R_wrbuf2_fifo_rdcnt[4] && I_app_wdf_rdy)
	//// just like after
	begin
		O_app_wdf_end			<= 1'b0	; 
		O_app_wdf_wren			<= 1'b0	;
	end
	else if((R_wrbuf2_fifo_rdcnt==5'd2) && I_app_wdf_rdy)
	begin
		O_app_wdf_end			<= 1'b1	; 
		O_app_wdf_wren			<= 1'b1	;
	end
	else
	begin
		O_app_wdf_end			<= O_app_wdf_end	;	
		O_app_wdf_wren			<= O_app_wdf_wren	;	
	end
end
///////////////////// I_app_rdy and O_app_addr process///////////////////
///////////////////// I_app_rdy and O_app_addr process///////////////////
///////////////////// I_app_rdy and O_app_addr process///////////////////
///////////////////// I_app_rdy and O_app_addr process///////////////////
///////////////////// I_app_rdy and O_app_addr process///////////////////

always @ (posedge I_ddr_clk)
begin
    if(I_ddr_rst)
    begin
		R_app_waddr_h		<= 16'd0						;
		R_app_waddr_h_en	<= 1'b0							;

	end
	else if(R_slice_state[C_POS_WR_BUS])
	begin
		R_app_waddr_h		<= 16'd0						;
		R_app_waddr_h_en	<= 1'b0							;
	end
	else if ((R_wrbuf2_fifo_rdcnt == 5'd2) && I_app_wdf_rdy)
	begin
		R_app_waddr_h	<= R_wrbuf2_fifo_rdata_1d[143:128]	;
		R_app_waddr_h_en	<= 1'b1							;
	end
end


always @ (posedge I_ddr_clk)
begin
    if(I_ddr_rst)
    begin
		R_app_waddr_h_en_1d	<= 1'b0				; 
		R_app_en_1d			<= 1'b0				;
	end
	else
	begin
		R_app_waddr_h_en_1d	<= R_app_waddr_h_en	;
		R_app_en_1d			<= O_app_en			; 
	end
end

always @(posedge I_ddr_clk)
begin
	if(I_ddr_rst)
	begin
			R_app_wr_cnt	<=	4'd0				;
	end
	else if(R_app_waddr_h_en)
	begin
		if(&R_app_wr_cnt)
		begin
			R_app_wr_cnt	<=	R_app_wr_cnt		;	
		end
		else if(I_app_rdy)
		begin
			R_app_wr_cnt	<=	R_app_wr_cnt +4'd1	;
		end
		else
		begin
			R_app_wr_cnt	<=	R_app_wr_cnt		; 
		end
	end
	else
	begin
			R_app_wr_cnt	<=	4'd0				;
	end
end



assign O_app_addr = {4'd0,1'b0,R_app_addr_h,R_app_addr_l,3'd0};

always @ (posedge I_ddr_clk)
begin
    if(I_ddr_rst)
    begin
			R_app_addr_h	<= 16'h0		; 
	end
	else if(R_app_waddr_h_en && (!R_app_waddr_h_en_1d))
	begin
			R_app_addr_h	<= R_app_waddr_h; 
	end
	else if(R_slice_state[C_POS_RD])
	begin //// no xgmii_num[1] , only num 0 and num 1,by cqiu
			R_app_addr_h	<= {R_pla_xgmii_num[1:0],R_pla_slice_rd_id[13:0]} ;
	end     
	else
	begin
			R_app_addr_h	<= R_app_addr_h	;	
	end
end


always @ (posedge I_ddr_clk)
begin
    if(I_ddr_rst)
    begin
			R_app_addr_l	<= 4'd0					;
	end
	else if(R_app_waddr_h_en) /// write
	begin
		//if(I_app_rdy || (!R_app_waddr_h_en_1d))///load the addr 
		if(I_app_rdy)
		begin
			R_app_addr_l	<= R_app_wr_cnt[3:0]	;
		end
		else
		begin
			R_app_addr_l	<= R_app_addr_l			;	
		end
	end
	else if(R_slice_state[C_POS_RD])
	begin
		if(I_app_rdy) 
		begin
			R_app_addr_l	<=R_app_rd_cnt[3:0]		;
		end
		else
		begin
			R_app_addr_l	<= R_app_addr_l			; 
		end
	end
	else
	begin
			R_app_addr_l	<= 4'd0					; 
	end
end

always @(posedge I_ddr_clk)
begin
	if(I_ddr_rst)
	begin
			O_app_cmd	<= 3'b000	; 
	end
	else if(R_slice_state[C_POS_RD])
	begin
			O_app_cmd	<= 3'b001	; 
	end
	else 
	begin
			O_app_cmd	<= 3'b000	; 
	end
end

always @(posedge I_ddr_clk)
begin
	if(I_ddr_rst)
	begin
			O_app_en	<= 1'b0		;
	end
	else if(R_slice_state[C_POS_WR])
	begin
		//if(R_app_waddr_end)
		if( (&R_app_addr_l) && I_app_rdy )
		begin
			O_app_en	<= 1'b0		;
		end
		else if(R_app_waddr_h_en && I_app_rdy) 
		begin
			O_app_en	<= 1'b1		;
		end
		else
		begin
			O_app_en	<= O_app_en	;
		end
	end
	else if(R_slice_state[C_POS_RD])
	begin
		//if(R_app_raddr_end)
		//if(R_app_rd_cnt_end)
		if( (&R_app_addr_l) && I_app_rdy )
		begin
			O_app_en	<= 1'b0		;
		end
		else if(I_app_rdy)
		begin
			O_app_en	<= 1'b1		;
		end
		else
		begin
			O_app_en	<= O_app_en	;
		end
	end
	else
	begin
			O_app_en	<= 1'b0		;
	end
end

///////////////////// read process////////
///////////////////// read process////////

always @(posedge I_ddr_clk)
begin
	if(I_ddr_rst)
	begin
			R_app_rd_cnt	<=	4'd0				;
	end
	else if(R_slice_state[C_POS_RD])
	begin
		if(&R_app_rd_cnt)
		begin
			R_app_rd_cnt	<=	R_app_rd_cnt		;	
		end
		else if(I_app_rdy)
		begin
			R_app_rd_cnt	<=	R_app_rd_cnt +4'd1	;
		end
		else
		begin
			R_app_rd_cnt	<=	R_app_rd_cnt		; 
		end
	end
	else
	begin
			R_app_rd_cnt	<=	4'd0				;
	end
end



//////////////////////////////////////////////////Begin Here/////////////////////////
//////////////////////////////////////////////////Begin Here/////////////////////////
//////////////////////////////////////////////////Begin Here/////////////////////////
//////////////////////////////////////////////////Begin Here/////////////////////////
//////////////////////////////////////////////////Begin Here/////////////////////////
//////////////////////////////////////////////////Begin Here/////////////////////////
//////////////////////////////////////////////////Begin Here/////////////////////////

/*
always @ (posedge I_pla_312m5_clk) 
begin
    if(I_pla_rst)
    begin
		S_wrbuf2_no_empty	<= 1'b0	;
	end
	else if(|S_wrbuf2_usedw)
	begin
		S_wrbuf2_no_empty	<= 1'b1	;
	end
end

always @ (posedge I_pla_312m5_clk) 
begin
	S_wrbuf2_no_empty_buf	<= {S_wrbuf2_no_empty_buf[6:0],S_wrbuf2_no_empty};
end

always @ (posedge I_ddr_clk) 
begin
	R_wrbuf2_no_empty_buf	<= {R_wrbuf2_no_empty_buf[2:0],|S_wrbuf2_no_empty_buf[7:0]};
end
*/



//// delay
always @ (posedge I_ddr_clk)
begin
    if(I_ddr_rst)
    begin
        R_wrbuf2_fifo_empty_buf		<= 5'h1f	;
		R_pla_slice_rd_req_buf		<= 4'h0	;
        
		R_slice_rd_cnt_1d			<= 4'h0	; 
		R_slice_rd_cnt_2d			<= 4'h0	; 
		R_pla_slice_rd_id_1d		<= 15'd0;
		R_pla_slice_rd_id_2d		<= 15'd0;
		R_rdbuf1_dpram_waddr_end_buf<= 4'h0	;
//		R_wrbuf2_usedw_1d			<= 9'h0	; 
    end
    else
    begin
        R_wrbuf2_fifo_empty_buf		<= {R_wrbuf2_fifo_empty_buf[3:0],R_wrbuf2_fifo_empty}		;
		R_pla_slice_rd_req_buf		<= {R_pla_slice_rd_req_buf[2:0],(|S_pla_slice_rd_req_buf)}	;
		R_slice_rd_cnt_1d			<= R_slice_rd_cnt											; 
		R_slice_rd_cnt_2d			<= R_slice_rd_cnt_1d										; 
		R_pla_slice_rd_id_1d		<= R_pla_slice_rd_id										;
		R_pla_slice_rd_id_2d		<= R_pla_slice_rd_id_1d										;
		R_rdbuf1_dpram_waddr_end_buf<= {R_rdbuf1_dpram_waddr_end_buf[2:0],R_rdbuf1_dpram_waddr_end}; 
//		R_wrbuf2_usedw_1d			<= R_wrbuf2_usedw;
	end
end

always @ (posedge I_ddr_clk)
begin
    if(I_ddr_rst)
    begin
		R_pla_slice_rd_req_lck	<= 1'b0	;
	end
	else if(R_pla_slice_rd_req_buf[1] && (!R_pla_slice_rd_req_buf[2])  )
	begin
		R_pla_slice_rd_req_lck	<= 1'b1	;
	end
	else if(R_slice_state[C_POS_RD])	
	begin
		R_pla_slice_rd_req_lck	<= 1'b0	;
	end
	else
	begin
		R_pla_slice_rd_req_lck	<= R_pla_slice_rd_req_lck	;	
	end
end




always @ (posedge I_ddr_clk)
begin
    if(I_ddr_rst)
    begin
		R_pla_slice_rd_id			<= 15'd0			;
		R_pla_xgmii_num				<= 2'b0				;	
	end
	else if(R_pla_slice_rd_req_buf[1] && (!R_pla_slice_rd_req_buf[2]))
	begin
		R_pla_slice_rd_id			<= I_pla_slice_rd_id;
		R_pla_xgmii_num				<= I_pla_xgmii_num	; 
	end
	else
	begin
		R_pla_slice_rd_id			<= R_pla_slice_rd_id;
		R_pla_xgmii_num				<= R_pla_xgmii_num	;	
	end
end

//====update
always @ (posedge I_ddr_clk)
begin
    if(I_ddr_rst)
    begin
        R_slice_state		<= 4'd0					;
        R_slice_state_1d	<= 4'd0					;
        R_slice_state_2d	<= 4'd0					;
        R_slice_state_3d	<= 4'd0					;
        R_slice_state_4d	<= 4'd0					;
        R_slice_state_5d	<= 4'd0					;
        R_slice_state_6d	<= 4'd0					;
    end
	else
	begin
        R_slice_state		<= R_slice_state_next	;
        R_slice_state_1d	<= R_slice_state		;
        R_slice_state_2d	<= R_slice_state_1d		;	
        R_slice_state_3d	<= R_slice_state_2d		;		
        R_slice_state_4d	<= R_slice_state_3d		;		 
        R_slice_state_5d	<= R_slice_state_4d		;		
        R_slice_state_6d	<= R_slice_state_5d		;		
	end
end
/*
*/

always @(*)
begin
	case(R_slice_state)
	C_SLICE_IDLE: 
	begin
		if(  R_wrbuf2_rd_trigger )
		begin
			R_slice_state_next	<= C_SLICE_WR		;
		end
		else if(R_pla_slice_rd_req_lck)
		begin
			R_slice_state_next	<= C_SLICE_RD		;
		end
		else
		begin
			R_slice_state_next	<= C_SLICE_IDLE		;
		end
	end
	C_SLICE_WR	:
	begin
		//if( (R_slice_wr_cnt == 4'hf) && I_app_rdy && R_app_wdf_wren_cnt[4])
		if(R_app_en_1d && (!O_app_en))
		begin
			R_slice_state_next	<= C_SLICE_WR_BUS	;
		end
		else
		begin
			R_slice_state_next	<= C_SLICE_WR		;
		end
	end
	C_SLICE_WR_BUS	:
	begin
			R_slice_state_next	<= C_SLICE_IDLE		;
	end
	C_SLICE_RD		:
	begin
		//if(R_slice_rd_cnt == 4'hf && I_ddr_rdy)
		//if(R_slice_rd_cnt == 4'hf)
		if(R_app_en_1d && (!O_app_en))
        begin
			R_slice_state_next	<= C_SLICE_RD_BUS	;
        end
        else
        begin
			R_slice_state_next	<= C_SLICE_RD		;
        end
	end
	C_SLICE_RD_BUS	:
	begin
		//if(R_slice_rd_cnt_2d== 4'hf)   ///add turn delay 
		//begin
			R_slice_state_next <= C_SLICE_IDLE		;
       // end
		//else
		//begin
		//	R_slice_state_next <= C_SLICE_RD_BUS	;
		//end
	end
	default:
	begin
			R_slice_state_next	<= C_SLICE_IDLE		;
	end
	endcase
end


//R_app_wdf_wren_cnt




always @ (posedge I_ddr_clk)
begin
    if(I_ddr_rst)
    begin
		R_wrbuf2_fifo_rden_buf	<= 4'h0;
	end
	else 
	begin
		R_wrbuf2_fifo_rden_buf	<= {R_wrbuf2_fifo_rden_buf[2:0],R_wrbuf2_fifo_rden};
	end
end

/*
*/


//// only use the pla num 0 and pla num1
//assign	O_ddr_wr_data	= R_wrbuf2_fifo_rdata_1d[127:0]												;




/////////////////////////////////////////////Read ///////////////////////////////////////////////
/////////////////////////////////////////////Read ///////////////////////////////////////////////
/////////////////////////////////////////////Read ///////////////////////////////////////////////
/////////////////////////////////////////////Read ///////////////////////////////////////////////
/////////////////////////////////////////////Read ///////////////////////////////////////////////
/////////////////////////////////////////////Read ///////////////////////////////////////////////
/////////////////////////////////////////////Read ///////////////////////////////////////////////
/////////////////////////////////////////////Read ///////////////////////////////////////////////
/////////////////////////////////////////////Read ///////////////////////////////////////////////
/////////////////////////////////////////////Read ///////////////////////////////////////////////
/////////////////////////////////////////////Read ///////////////////////////////////////////////
//	O_ddr_rd_en  <= 1'b0 ;
/*
always @ (posedge I_ddr_clk)
begin
	if(I_ddr_rst)
    begin
			O_ddr_rd_en <= 1'b0;
    end
    else if(R_slice_state[C_POS_RD])
    begin
		if (R_slice_rd_cnt == 4'hf && I_ddr_rdy)
		begin
			O_ddr_rd_en <= 1'b0;
    	end
		else 
    	begin
			O_ddr_rd_en <= 1'b1; 
		end
	end
	else
	begin
			O_ddr_rd_en <= 1'b0;
	end
end
*/

/*
always @ (posedge I_ddr_clk)
begin
	if(I_ddr_rst)
    begin
			R_slice_rd_cnt <= 4'd0;  
    end
    else if(R_slice_state_3d[C_POS_RD])
    begin
		if(I_ddr_rdy && O_ddr_rd_en) ///��һ����Ҫֱ�Ӽ�1
		begin
			R_slice_rd_cnt <= R_slice_rd_cnt + 4'd1; 
		end    
		else
		begin
			R_slice_rd_cnt <= R_slice_rd_cnt ;            
		end
    end
    else
    begin
			R_slice_rd_cnt <= 4'd0; 
    end
end
*/

blk_sdpram_16x128_k7 U03_rdbuf1(
.clka	 (I_ddr_clk						),
.ena	 (1'b1							),
.wea	 (R_rdbuf1_dpram_wr				),
.addra	 (R_rdbuf1_dpram_waddr			),
.dina	 (R_rdbuf1_dpram_wdata			),
.clkb	 (I_pla_312m5_clk				),
//.rstb    (I_pla_rst                     ),
.enb	 (I_pla_slice_rd_en				),
.addrb	 (S_rdbuf1_dpram_raddr[5:2]		),
.doutb	 (S_rdbuf1_dpram_rdata			)
);

/*
assign S_rdbuffer1_dpram_wr    = I_ddr_rdata_valid ;
assign S_rdbuffer1_dpram_wdata = I_ddr_rdata;
*/

always @ (posedge I_ddr_clk)
begin
	if(I_ddr_rst)
    begin
		R_rdbuf1_dpram_wr		<=	1'b0				; 
		R_rdbuf1_dpram_wdata	<=	128'h0				;	
	end
	else
	begin
		R_rdbuf1_dpram_wr		<=	I_app_rd_data_valid	; 
		R_rdbuf1_dpram_wdata	<=	I_app_rd_data		;	
	end
end

always @ (posedge I_ddr_clk)
begin
	if(I_ddr_rst)
    begin
        R_rdbuf1_dpram_waddr	<= 4'h0							;
    end
    else if(R_rdbuf1_dpram_wr)
    begin
        R_rdbuf1_dpram_waddr	<= R_rdbuf1_dpram_waddr + 4'h1	;
    end
    else
    begin
		R_rdbuf1_dpram_waddr	<= R_rdbuf1_dpram_waddr			;
    end
end

always @ (posedge I_ddr_clk)
begin
	if(I_ddr_rst)
    begin
        R_rdbuf1_dpram_waddr_end	<= 1'b0							;
    end
    else if(R_rdbuf1_dpram_wr	&& (&R_rdbuf1_dpram_waddr) )
    begin
        R_rdbuf1_dpram_waddr_end	<= 1'b1							;
	end
	else
	begin
        R_rdbuf1_dpram_waddr_end	<= 1'b0							;
	end
end
//

//=======rdbuf1 312m5 clock domain
always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
    begin
		O_pla_slice_rd_resp <= 1'b0;
    end
    else if((!S_rdbuf1_dpram_waddr_end_buf[2]) && S_rdbuf1_dpram_waddr_end_buf[1]) 
    begin
		O_pla_slice_rd_resp <= 1'b1;
    end
    else
    begin
        O_pla_slice_rd_resp <= 1'b0;
    end
end

always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst)
	begin
		S_rdbuf1_dpram_raddr <= 6'd0;
	end
    else if(I_pla_slice_rd_en || (|S_pla_slice_rd_en_buf[2:0]))
	// consider the S_rdbuf1_dpram_raddr[1:0] from 0 1 2 3 
	begin
		S_rdbuf1_dpram_raddr <= S_rdbuf1_dpram_raddr + 6'd1;
	end
    else
	begin
		S_rdbuf1_dpram_raddr <= 6'd0;    
	end
end
always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst)
	begin
			S_pla_slice_rdata <= 32'd0;
    end
	else
	begin
		case(S_rdbuf1_dpram_raddr[1:0])
		2'b11:
		begin
            S_pla_slice_rdata <= S_rdbuf1_dpram_rdata[127:96];
		end
		2'b00:
		begin
            S_pla_slice_rdata <= S_rdbuf1_dpram_rdata[95:64];
		end
		2'b01:
		begin
            S_pla_slice_rdata <= S_rdbuf1_dpram_rdata[63:32];
		end
		2'b10:
		begin
            S_pla_slice_rdata <= S_rdbuf1_dpram_rdata[31:0];
		end
		default:
		begin
            S_pla_slice_rdata <= S_rdbuf1_dpram_rdata[31:0];
		end
		endcase
	end
end

always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst)
    begin
        O_pla_slice_rdata   <= 32'd0			; 
	end
	else
	begin
        O_pla_slice_rdata   <= S_pla_slice_rdata; 
	end
end



/////====Maintenance
//====delay 
always @ (posedge I_ddr_clk)
begin
	R_app_wdf_rdy_buf	<= {R_app_wdf_rdy_buf[2:0],I_app_wdf_rdy}	;
	R_app_rdy_buf		<= {R_app_rdy_buf[2:0],I_app_rdy};	
	R_cnt_clear_buf		<= {R_cnt_clear_buf[2:0],I_cnt_clear};
end

//====The writing data cmd must be finished earily than having send the write cmd (write addr cmd),  
always @ (posedge I_ddr_clk)
begin
	if(R_slice_state_1d[C_POS_WR])
	begin
		R_app_write_err	<= (!R_app_wdf_data_end) && (R_app_en_1d) && (!O_app_en); 
	end
	else
	begin
		R_app_write_err	<= 1'b0	;
	end
end

always @ (posedge I_ddr_clk)
begin
	if(R_cnt_clear_buf[2])
	begin
		R_app_write_err_cnt		<= 16'h0;	
	end
	else if(&R_app_write_err_cnt)
	begin
		R_app_write_err_cnt		<= R_app_write_err_cnt	;	
	end
	else if(R_app_write_err)
	begin
		R_app_write_err_cnt		<= R_app_write_err_cnt	+ 16'h1;	
	end
	else
	begin
		R_app_write_err_cnt		<= R_app_write_err_cnt	;	
	end
end



//====R_rd_app_rdy_low_cnt_max
always @ (posedge I_ddr_clk)
begin
	if(R_slice_state_3d[C_POS_RD])
	begin
		if(~R_app_rdy_buf[1])
		begin
			R_rd_app_rdy_low_cnt	<= R_rd_app_rdy_low_cnt + 16'h1	;	
		end
		else
		begin
			R_rd_app_rdy_low_cnt	<= R_rd_app_rdy_low_cnt			;
		end
	end
	else
	begin
			R_rd_app_rdy_low_cnt	<= 16'h0						; 
	end
end
always @ (posedge I_ddr_clk)
begin
	if(R_cnt_clear_buf[1])
	begin
			R_rd_app_rdy_low_cnt_max<= 16'h0						; 
	end
	else if((!R_slice_state_2d[C_POS_RD]) && R_slice_state_3d[C_POS_RD])
	begin
		if(R_rd_app_rdy_low_cnt_max <  R_rd_app_rdy_low_cnt ) 
		begin
			R_rd_app_rdy_low_cnt_max <= R_rd_app_rdy_low_cnt		; 
		end
		else
		begin
			R_rd_app_rdy_low_cnt_max <= R_rd_app_rdy_low_cnt_max	; 
		end
	end
	else
	begin
			R_rd_app_rdy_low_cnt_max <= R_rd_app_rdy_low_cnt_max	; 
	end
end



//====R_wr_app_rdy_low_cnt_max
always @ (posedge I_ddr_clk)
begin
	if(R_slice_state_3d[C_POS_WR])
	begin
		if(~R_app_rdy_buf[1])
		begin
			R_wr_app_rdy_low_cnt	<= R_wr_app_rdy_low_cnt + 16'h1	;	
		end
		else
		begin
			R_wr_app_rdy_low_cnt	<= R_wr_app_rdy_low_cnt			;
		end
	end
	else
	begin
			R_wr_app_rdy_low_cnt	<= 16'h0						; 
	end
end
always @ (posedge I_ddr_clk)
begin
	if(R_cnt_clear_buf[2])
	begin
			R_wr_app_rdy_low_cnt_max<= 16'h0						; 
	end
	else if((!R_slice_state_2d[C_POS_WR]) && R_slice_state_3d[C_POS_WR])
	begin
		if(R_wr_app_rdy_low_cnt_max <  R_wr_app_rdy_low_cnt ) 
		begin
			R_wr_app_rdy_low_cnt_max <= R_wr_app_rdy_low_cnt		; 
		end
		else
		begin
			R_wr_app_rdy_low_cnt_max <= R_wr_app_rdy_low_cnt_max	; 
		end
	end
	else
	begin
			R_wr_app_rdy_low_cnt_max <= R_wr_app_rdy_low_cnt_max	; 
	end
end




//====R_app_wdf_rdy_low_cnt_max
always @ (posedge I_ddr_clk)
begin
	if(R_slice_state_3d[C_POS_WR])
	begin
		if(~R_app_wdf_rdy_buf[1])
		begin
			R_app_wdf_rdy_low_cnt	<= R_app_wdf_rdy_low_cnt + 16'h1	;
		end
		else
		begin
			R_app_wdf_rdy_low_cnt	<= R_app_wdf_rdy_low_cnt	; 
		end
	end
	else
	begin
			R_app_wdf_rdy_low_cnt	<= 16'h0	;
	end
end



always @ (posedge I_ddr_clk)
begin
	if(R_cnt_clear_buf[1])
	begin
			R_app_wdf_rdy_low_cnt_max <= 16'h0						;
	end
	else if((!R_slice_state_2d[C_POS_WR]) && R_slice_state_3d[C_POS_WR])
	begin
		if(R_app_wdf_rdy_low_cnt > 	R_app_wdf_rdy_low_cnt_max)
		begin
			R_app_wdf_rdy_low_cnt_max <= R_app_wdf_rdy_low_cnt		; 
		end
		else
		begin
			R_app_wdf_rdy_low_cnt_max <= R_app_wdf_rdy_low_cnt_max	; 
		end
	end
	else
	begin
			R_app_wdf_rdy_low_cnt_max <= R_app_wdf_rdy_low_cnt_max	; 
	end
end


//====312.5m clock
always @ (posedge I_pla_312m5_clk) 
begin
	S_app_wdf_rdy_low_cnt_max_1d	<= R_app_wdf_rdy_low_cnt_max	; 
	S_app_wdf_rdy_low_cnt_max_2d	<= S_app_wdf_rdy_low_cnt_max_1d	; 
	O_app_wdf_rdy_low_cnt_max		<= S_app_wdf_rdy_low_cnt_max_2d	; 

	S_wr_app_rdy_low_cnt_max_1d		<= R_wr_app_rdy_low_cnt_max		;
	S_wr_app_rdy_low_cnt_max_2d		<= S_wr_app_rdy_low_cnt_max_1d	;
	O_wr_app_rdy_low_cnt_max		<= S_wr_app_rdy_low_cnt_max_2d	;
	
	S_rd_app_rdy_low_cnt_max_1d		<= R_rd_app_rdy_low_cnt_max		;
	S_rd_app_rdy_low_cnt_max_2d		<= S_rd_app_rdy_low_cnt_max_1d	;
	O_rd_app_rdy_low_cnt_max		<= S_rd_app_rdy_low_cnt_max_2d	;

	S_app_write_err_cnt_1d			<= R_app_write_err_cnt			;
	S_app_write_err_cnt_2d			<= S_app_write_err_cnt_1d		;
	O_app_write_err_cnt				<= S_app_write_err_cnt_2d		;

end



always @ (posedge I_pla_312m5_clk) 
begin
	S_wrbuf2_usedw_1d		<= S_wrbuf2_usedw		;
	S_wrbuf2_usedw_2d		<= S_wrbuf2_usedw_1d	;
	S_wrbuf2_almost_full_1d	<= S_wrbuf2_almost_full	;
	S_cnt_clear_buf			<= {S_cnt_clear_buf[2:0],I_cnt_clear};
end

always @ (posedge I_pla_312m5_clk) 
begin
	S_wrbuf2_almost_full <= (&S_wrbuf2_usedw_2d[8:4])	;
end

always @ (posedge I_pla_312m5_clk) 
begin
	if(S_cnt_clear_buf[2])
	begin
		O_ddr3_buf_full_cnt	<= 16'h0						;
	end
	else if(&O_ddr3_buf_full_cnt)
	begin
		O_ddr3_buf_full_cnt	<= O_ddr3_buf_full_cnt			;	
	end
	else if(S_wrbuf2_almost_full && (!S_wrbuf2_almost_full_1d))
	begin
		O_ddr3_buf_full_cnt	<= O_ddr3_buf_full_cnt	+ 16'h1	;	
	end
	else
	begin
		O_ddr3_buf_full_cnt	<= O_ddr3_buf_full_cnt			;	
	end
end












endmodule

