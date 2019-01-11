module pla_backward_slice_schedule(
input               I_pla_312m5_clk				,
input               I_pla_rst					,
//// pla whole common 10g 
input     [1:0]     I_pla_xgmii_num				,///
input     [14:0]    I_pla_slice_id				,
input     [31:0]    I_pla_slice_payload			,
input               I_pla_slice_payload_en		,
//// 
//input		[  8:0]	I_ddr3a_wrbuf2_usedw		,	
output reg	[143:0] O_ddr3a_wrbuf2_fifo_wdata	,	
output reg			O_ddr3a_wrbuf2_fifo_wren = 1'b0	,
output reg	[  1:0]	O_ddr3a_pla_xgmii_num		,	
output reg	[ 14:0] O_ddr3a_slice_rd_id			,
output reg			O_ddr3a_slice_rd_req		,
input				I_ddr3a_slice_rd_resp		,
output reg			O_ddr3a_slice_rd_en	 = 1'b0	,
input		[ 31:0] O_ddr3a_slice_rdata			,
//input		[  8:0]	I_ddr3b_wrbuf2_usedw		,	
output reg	[143:0] O_ddr3b_wrbuf2_fifo_wdata	,	
output reg			O_ddr3b_wrbuf2_fifo_wren = 1'b0	,
output reg	[  1:0]	O_ddr3b_pla_xgmii_num		,	
output reg	[ 14:0] O_ddr3b_slice_rd_id			,
output reg			O_ddr3b_slice_rd_req		,
input				I_ddr3b_slice_rd_resp		,
output reg			O_ddr3b_slice_rd_en	= 1'b0	,
input		[ 31:0] O_ddr3b_slice_rdata			,
input				I_cnt_clear					,	
input		[  5:0]	I_slice_rd_en_valid_cnt_fix	, 
///S_pla0a_slice_rd_en_valid_cnt
//// pla group 0
output reg          O_pla0_slice_wr_resp		,
output reg  [ 14:0] O_pla0_slice_num_id			,
input               I_pla0_slice_check_ok		,///pulse
input		[ 14:0] I_pla0_slice_rd_id			,
input               I_pla0_slice_rd_req			,
output reg          O_pla0_slice_rd_resp		,
input               I_pla0_slice_data_rd		,
output reg [ 31:0]  O_pla0_slice_rdata			,
output reg [ 15:0]	O_pla0_slice_ok_cnt	= 16'h0	,
output reg [ 15:0]	O_pla0_slice_wr_cnt	= 16'h0	,
output reg [ 15:0]	O_pla0_slice_rd_cnt	= 16'h0	,
//// pla group 1 
output reg          O_pla1_slice_wr_resp		,
output reg   [14:0] O_pla1_slice_num_id			,
input               I_pla1_slice_check_ok		,///pulse
input     [14:0]    I_pla1_slice_rd_id			,
input               I_pla1_slice_rd_req			,
output reg          O_pla1_slice_rd_resp		,
input               I_pla1_slice_data_rd		,
output reg   [31:0] O_pla1_slice_rdata			,
output reg [ 15:0]	O_pla1_slice_ok_cnt	= 16'h0	,
output reg [ 15:0]	O_pla1_slice_wr_cnt	= 16'h0	,
output reg [ 15:0]	O_pla1_slice_rd_cnt	= 16'h0	,
//// pla group 2 
output reg          O_pla2_slice_wr_resp		,
output reg   [14:0] O_pla2_slice_num_id			,
input               I_pla2_slice_check_ok		,///pulse
input     [14:0]    I_pla2_slice_rd_id			,
input               I_pla2_slice_rd_req			,
output reg          O_pla2_slice_rd_resp		,
input               I_pla2_slice_data_rd		,
output reg   [31:0] O_pla2_slice_rdata			,	
output reg [ 15:0]	O_pla2_slice_ok_cnt	= 16'h0	,
output reg [ 15:0]	O_pla2_slice_wr_cnt	= 16'h0	,
output reg [ 15:0]	O_pla2_slice_rd_cnt	= 16'h0				
);

///====================================================                  
/// pla clock domain S_
/// ddr clock domain R_
reg		[ 31:0] S_pla_slice_payload_1d				; 
reg				S_pla_slice_payload_en_1d			;
reg				S_pla_slice_payload_en_2d			;
reg		[  3:0] S_wrbuf1_dpram_waddr	= 4'h0		; 
reg		[127:0]	S_wrbuf1_dpram_wdata	= 128'd0	;
reg				S_wrbuf1_dpram_wren		= 1'b0		;       
reg				S_wrbuf1_dpram_wren_pre	= 1'b0		;       
reg		[  1:0] S_wrbuf1_dpram_wcnt		= 2'b00		;
reg		[  3:0] S_wrbuf1_dpram_raddr	= 4'hf		;
wire	[127:0]	S_wrbuf1_dpram_rdata				; 
reg		[127:0]	S_wrbuf1_dpram_rdata_1d				; 
reg				S_pla_slice_check_ok				;
reg		[  7:0] S_pla_slice_check_ok_buf			;
reg				S_pla_slice_wr_resp					;
reg		[  7:0]	S_pla_slice_wr_resp_buf	= 8'h0		;
reg				S_pla_ddr3_wr_order					;
reg				S_pla_ddr3_wrinfo					;///=1'b0, ddr3a ,=1'b1,ddr3b
reg		[ 14:0] S_pla_slice_wr_id		= 15'h0		;
reg		[  1:0]	S_pla_xgmii_num			= 2'b00		;
reg		[  3:0]	S_wrbuf2_dpram_waddr    = 4'hf		;
reg				S_wrbuf2_fifo_wren					;
reg		[127:0]	S_wrbuf2_fifo_wdata					; 
reg		[143:0]	S_wrbuf2_fifo_wdata_1d				; 
reg		[  7:0] S_pla0_slice_check_ok_buf			;
reg		[ 14:0] S_pla0_lookup_addr					;
reg				S_pla0_lookup_wren					;
reg				S_pla0_lookup_wdata					;
reg		[14:0]	S_pla0_slice_rd_id_1d				;	
wire			S_pla0_lookup_rdata					;
reg				S_pla0_lookup_rdata_1d				;
reg				S_pla0_slice_rd_req_lck				;
reg		[ 7:0]	S_pla0_slice_rd_req_buf				;	
reg		[ 3:0]  S_pla0_slice_data_rd_buf  = 4'h0	;
reg		[ 3:0]  S_pla1_slice_data_rd_buf  = 4'h0	;
reg		[ 3:0]  S_pla2_slice_data_rd_buf  = 4'h0	;
reg				S_ddr3a_slice_rd_req_lck			;	
reg				S_ddr3a_slice_rd_req_lck_1d			;	
reg				S_ddr3b_slice_rd_req_lck			;	
reg				S_ddr3b_slice_rd_req_lck_1d			;	
reg		[  7:0] S_pla1_slice_check_ok_buf			;
reg		[ 14:0] S_pla1_lookup_addr					;
reg				S_pla1_lookup_wren					;
reg				S_pla1_lookup_wdata					;
reg		[14:0]	S_pla1_slice_rd_id_1d				;	
wire			S_pla1_lookup_rdata					;
reg				S_pla1_lookup_rdata_1d				;
reg				S_pla1_slice_rd_req_lck				;
reg		[ 7:0]	S_pla1_slice_rd_req_buf				;	
reg		[  7:0] S_pla2_slice_check_ok_buf			;
reg		[ 14:0] S_pla2_lookup_addr					;
reg				S_pla2_lookup_wren					;
reg				S_pla2_lookup_wdata					;
reg		[14:0]	S_pla2_slice_rd_id_1d				;	
wire			S_pla2_lookup_rdata					;
reg				S_pla2_lookup_rdata_1d				;
reg				S_pla2_slice_rd_req_lck				;
reg		[ 7:0]	S_pla2_slice_rd_req_buf				;	
reg				S_pla0a_slice_rd_en_valid			;	
reg		[ 5:0]	S_pla0a_slice_rd_en_valid_buf		;	
reg		[5:0]	S_pla0a_slice_rd_en_valid_cnt		;
reg				S_pla1a_slice_rd_en_valid			;	
reg		[ 5:0]	S_pla1a_slice_rd_en_valid_buf		;	
reg		[5:0]	S_pla1a_slice_rd_en_valid_cnt		;
reg				S_pla2a_slice_rd_en_valid			;	
reg		[ 5:0]	S_pla2a_slice_rd_en_valid_buf		;	
reg		[5:0]	S_pla2a_slice_rd_en_valid_cnt		;
reg				S_pla0b_slice_rd_en_valid			;	
reg		[ 5:0]	S_pla0b_slice_rd_en_valid_buf		;	
reg		[5:0]	S_pla0b_slice_rd_en_valid_cnt		;
reg				S_pla1b_slice_rd_en_valid			;	
reg		[ 5:0]	S_pla1b_slice_rd_en_valid_buf		;	
reg		[5:0]	S_pla1b_slice_rd_en_valid_cnt		;
reg				S_pla2b_slice_rd_en_valid			;	
reg		[ 5:0]	S_pla2b_slice_rd_en_valid_buf		;	
reg		[5:0]	S_pla2b_slice_rd_en_valid_cnt		;
reg		[ 3:0]  S_cnt_clear_buf	 = 4'h0				;	



parameter		C_DDR3_IDLE		= 4'b0001	;
parameter		C_DDR3_REQ0		= 4'b0010	; 
parameter		C_DDR3_REQ1		= 4'b0100	; 
parameter		C_DDR3_REQ2		= 4'b1000	;
parameter		C_POS_DDR3_IDLE = 2'b00		;
parameter		C_POS_DDR3_REQ0 = 2'b01		;
parameter		C_POS_DDR3_REQ1 = 2'b10		;
parameter		C_POS_DDR3_REQ2 = 2'b11		;

reg		[ 3:0] S_ddr3a_req_state		= 4'b0001	;
reg		[ 3:0] S_ddr3a_req_state_1d		= 4'b0001	;
reg		[ 3:0] S_ddr3a_req_state_next				;	
reg		[ 3:0] S_ddr3b_req_state		= 4'b0001	;
reg		[ 3:0] S_ddr3b_req_state_1d		= 4'b0001	;
reg		[ 3:0] S_ddr3b_req_state_next				;	


/////---------------------------------------------------------
///// debug	begin
/////---------------------------------------------------------
(*MARK_DEBUG ="true"*)reg   [1:0]    dbg_I_pla_xgmii_num			;///
(*MARK_DEBUG ="true"*)reg   [14:0]   dbg_I_pla_slice_id				;
(*MARK_DEBUG ="true"*)reg   [31:0]   dbg_I_pla_slice_payload		;
(*MARK_DEBUG ="true"*)reg            dbg_I_pla_slice_payload_en		;
(*MARK_DEBUG ="true"*)reg			 dbg_O_pla0_slice_wr_resp		;
(*MARK_DEBUG ="true"*)reg	[ 14:0]	 dbg_O_pla0_slice_num_id		;
(*MARK_DEBUG ="true"*)reg			 dbg_I_pla0_slice_check_ok		;///pulse
(*MARK_DEBUG ="true"*)reg  	[ 14:0]	 dbg_I_pla0_slice_rd_id			;
(*MARK_DEBUG ="true"*)reg			 dbg_I_pla0_slice_rd_req		;
(*MARK_DEBUG ="true"*)reg			 dbg_O_pla0_slice_rd_resp		;
(*MARK_DEBUG ="true"*)reg			 dbg_I_pla0_slice_data_rd		;
(*MARK_DEBUG ="true"*)reg	[ 31:0]	 dbg_O_pla0_slice_rdata			;
(*MARK_DEBUG ="true"*)reg	[ 3:0]	 dbg_S_ddr3a_req_state_1d		; 
(*MARK_DEBUG ="true"*)reg	[ 3:0]	 dbg_S_ddr3b_req_state_1d		; 
(*MARK_DEBUG ="true"*)reg	[ 31:0]  dbg_S_pla_slice_payload_1d		; 
(*MARK_DEBUG ="true"*)reg			 dbg_S_pla_slice_payload_en_1d			;
(*MARK_DEBUG ="true"*)reg			 dbg_S_pla_slice_check_ok				;
//(*MARK_DEBUG ="true"*)reg	[  7:0]  dbg_S_pla_slice_check_ok_buf			;
(*MARK_DEBUG ="true"*)reg			 dbg_S_pla_slice_wr_resp				;
//(*MARK_DEBUG ="true"*)reg	[  7:0]	 dbg_S_pla_slice_wr_resp_buf	        ;
(*MARK_DEBUG ="true"*)reg			 dbg_S_pla_ddr3_wr_order		        ;
(*MARK_DEBUG ="true"*)reg			 dbg_S_pla_ddr3_wrinfo		        	;///=1'b0, ddr3a ,=1'b1,ddr3b
(*MARK_DEBUG ="true"*)reg	[ 14:0]  dbg_S_pla_slice_wr_id		        	;
(*MARK_DEBUG ="true"*)reg	[  1:0]	 dbg_S_pla_xgmii_num			        ;
(*MARK_DEBUG ="true"*)reg	[  3:0]	 dbg_S_wrbuf2_dpram_waddr            	;
(*MARK_DEBUG ="true"*)reg			 dbg_S_wrbuf2_fifo_wren					;
//(*MARK_DEBUG ="true"*)reg	[127:0]	 dbg_S_wrbuf2_fifo_wdata				; 
(*MARK_DEBUG ="true"*)reg	[  7:0]  dbg_S_pla0_slice_check_ok_buf			;
(*MARK_DEBUG ="true"*)reg	[ 14:0]  dbg_S_pla0_lookup_addr					;
(*MARK_DEBUG ="true"*)reg			 dbg_S_pla0_lookup_wren					;
(*MARK_DEBUG ="true"*)reg			 dbg_S_pla0_lookup_wdata				;
(*MARK_DEBUG ="true"*)reg	[14:0]	 dbg_S_pla0_slice_rd_id_1d				;	
(*MARK_DEBUG ="true"*)reg			 dbg_S_pla0_lookup_rdata				;
(*MARK_DEBUG ="true"*)reg			 dbg_S_pla0_lookup_rdata_1d				;
(*MARK_DEBUG ="true"*)reg			 dbg_S_pla0_slice_rd_req_lck			;
(*MARK_DEBUG ="true"*)reg	[ 7:0]	 dbg_S_pla0_slice_rd_req_buf			;	
(*MARK_DEBUG ="true"*)reg	[ 3:0]   dbg_S_pla0_slice_data_rd_buf         	;
(*MARK_DEBUG ="true"*)reg	[ 3:0]   dbg_S_pla1_slice_data_rd_buf         	;
(*MARK_DEBUG ="true"*)reg	[ 3:0]   dbg_S_pla2_slice_data_rd_buf         	;
(*MARK_DEBUG ="true"*)reg			 dbg_S_ddr3a_slice_rd_req_lck			;	
(*MARK_DEBUG ="true"*)reg			 dbg_S_ddr3a_slice_rd_req_lck_1d		;	
(*MARK_DEBUG ="true"*)reg			 dbg_S_ddr3b_slice_rd_req_lck			;	
(*MARK_DEBUG ="true"*)reg			 dbg_S_ddr3b_slice_rd_req_lck_1d		;	
(*MARK_DEBUG ="true"*)reg	[  7:0]  dbg_S_pla1_slice_check_ok_buf			;
(*MARK_DEBUG ="true"*)reg	[ 14:0]  dbg_S_pla1_lookup_addr					;
(*MARK_DEBUG ="true"*)reg			 dbg_S_pla1_lookup_wren					;
(*MARK_DEBUG ="true"*)reg			 dbg_S_pla1_lookup_wdata				;
(*MARK_DEBUG ="true"*)reg	[14:0]	 dbg_S_pla1_slice_rd_id_1d				;	
(*MARK_DEBUG ="true"*)reg			 dbg_S_pla1_lookup_rdata				;
(*MARK_DEBUG ="true"*)reg			 dbg_S_pla1_lookup_rdata_1d				;
(*MARK_DEBUG ="true"*)reg			 dbg_S_pla1_slice_rd_req_lck			;
(*MARK_DEBUG ="true"*)reg	[ 7:0]	 dbg_S_pla1_slice_rd_req_buf			;	
(*MARK_DEBUG ="true"*)reg	[  7:0]  dbg_S_pla2_slice_check_ok_buf			;
(*MARK_DEBUG ="true"*)reg	[ 14:0]  dbg_S_pla2_lookup_addr					;
(*MARK_DEBUG ="true"*)reg			 dbg_S_pla2_lookup_wren					;
(*MARK_DEBUG ="true"*)reg			 dbg_S_pla2_lookup_wdata				;
(*MARK_DEBUG ="true"*)reg	[14:0]   dbg_S_pla2_slice_rd_id_1d				;	
(*MARK_DEBUG ="true"*)reg		     dbg_S_pla2_lookup_rdata				;
(*MARK_DEBUG ="true"*)reg		     dbg_S_pla2_lookup_rdata_1d				;
(*MARK_DEBUG ="true"*)reg		     dbg_S_pla2_slice_rd_req_lck			;
(*MARK_DEBUG ="true"*)reg	[ 7:0]   dbg_S_pla2_slice_rd_req_buf			;	
(*MARK_DEBUG ="true"*)reg		     dbg_S_pla0a_slice_rd_en_valid			;	
//(*MARK_DEBUG ="true"*)reg	[ 5:0]   dbg_S_pla0a_slice_rd_en_valid_buf		;	
(*MARK_DEBUG ="true"*)reg	[5:0]    dbg_S_pla0a_slice_rd_en_valid_cnt		;
(*MARK_DEBUG ="true"*)reg		     dbg_S_pla1a_slice_rd_en_valid			;	
//(*MARK_DEBUG ="true"*)reg	[ 5:0]   dbg_S_pla1a_slice_rd_en_valid_buf		;	
(*MARK_DEBUG ="true"*)reg	[5:0]    dbg_S_pla1a_slice_rd_en_valid_cnt		;
(*MARK_DEBUG ="true"*)reg		     dbg_S_pla2a_slice_rd_en_valid			;	
//(*MARK_DEBUG ="true"*)reg	[ 5:0]   dbg_S_pla2a_slice_rd_en_valid_buf		;	
(*MARK_DEBUG ="true"*)reg	[5:0]    dbg_S_pla2a_slice_rd_en_valid_cnt		;
(*MARK_DEBUG ="true"*)reg		     dbg_S_pla0b_slice_rd_en_valid			;	
//(*MARK_DEBUG ="true"*)reg	[ 5:0]   dbg_S_pla0b_slice_rd_en_valid_buf		;	
(*MARK_DEBUG ="true"*)reg	[5:0]    dbg_S_pla0b_slice_rd_en_valid_cnt		;
(*MARK_DEBUG ="true"*)reg		     dbg_S_pla1b_slice_rd_en_valid			;	
//(*MARK_DEBUG ="true"*)reg	[ 5:0]   dbg_S_pla1b_slice_rd_en_valid_buf		;	
(*MARK_DEBUG ="true"*)reg	[5:0]    dbg_S_pla1b_slice_rd_en_valid_cnt		;
(*MARK_DEBUG ="true"*)reg		     dbg_S_pla2b_slice_rd_en_valid			;	
//(*MARK_DEBUG ="true"*)reg	[ 5:0]   dbg_S_pla2b_slice_rd_en_valid_buf		;	
(*MARK_DEBUG ="true"*)reg	[5:0]    dbg_S_pla2b_slice_rd_en_valid_cnt		;



always @ (posedge I_pla_312m5_clk) 
begin
	dbg_I_pla_xgmii_num				<=I_pla_xgmii_num			;///
	dbg_I_pla_slice_id				<=I_pla_slice_id			;
	dbg_I_pla_slice_payload			<=I_pla_slice_payload		;
	dbg_I_pla_slice_payload_en		<=I_pla_slice_payload_en	;
	dbg_O_pla0_slice_wr_resp		<=O_pla0_slice_wr_resp		;
	dbg_O_pla0_slice_num_id			<=O_pla0_slice_num_id		;
	dbg_I_pla0_slice_check_ok		<=I_pla0_slice_check_ok		;///pulse
	dbg_I_pla0_slice_rd_id			<=I_pla0_slice_rd_id		;
	dbg_I_pla0_slice_rd_req			<=I_pla0_slice_rd_req		;
	dbg_O_pla0_slice_rd_resp		<=O_pla0_slice_rd_resp		;
	dbg_I_pla0_slice_data_rd		<=I_pla0_slice_data_rd		;
	dbg_O_pla0_slice_rdata			<=O_pla0_slice_rdata		;
	dbg_S_ddr3a_req_state_1d		<=S_ddr3a_req_state_1d		; 
	dbg_S_ddr3b_req_state_1d		<=S_ddr3b_req_state_1d		;
    dbg_S_pla_slice_payload_1d			<= S_pla_slice_payload_1d		                  ;
    dbg_S_pla_slice_payload_en_1d		<= S_pla_slice_payload_en_1d	                  ;
    dbg_S_pla_slice_check_ok			<= S_pla_slice_check_ok		                  ;
    //dbg_S_pla_slice_check_ok_buf		<= S_pla_slice_check_ok_buf	                  ;
    dbg_S_pla_slice_wr_resp				<= S_pla_slice_wr_resp			                  ;
    //dbg_S_pla_slice_wr_resp_buf	        <= S_pla_slice_wr_resp_buf	                      ;
    dbg_S_pla_ddr3_wr_order		        <= S_pla_ddr3_wr_order		                      ;
    dbg_S_pla_ddr3_wrinfo		        <= S_pla_ddr3_wrinfo		                      ;
    dbg_S_pla_slice_wr_id		        <= S_pla_slice_wr_id		                      ;
    dbg_S_pla_xgmii_num			        <= S_pla_xgmii_num			                      ;
    dbg_S_wrbuf2_dpram_waddr            <= S_wrbuf2_dpram_waddr                          ;
    dbg_S_wrbuf2_fifo_wren				<= S_wrbuf2_fifo_wren			                  ;
    //dbg_S_wrbuf2_fifo_wdata			<=                    ;   ;
    dbg_S_pla0_slice_check_ok_buf		<= S_pla0_slice_check_ok_buf		                  ;
    dbg_S_pla0_lookup_addr				<= S_pla0_lookup_addr				                  ;
    dbg_S_pla0_lookup_wren				<= S_pla0_lookup_wren				                  ;
    dbg_S_pla0_lookup_wdata				<= S_pla0_lookup_wdata				                  ;
    dbg_S_pla0_slice_rd_id_1d			<= S_pla0_slice_rd_id_1d			                  ;
    dbg_S_pla0_lookup_rdata				<= S_pla0_lookup_rdata				                  ;
    dbg_S_pla0_lookup_rdata_1d			<= S_pla0_lookup_rdata_1d			                  ;
    dbg_S_pla0_slice_rd_req_lck			<= S_pla0_slice_rd_req_lck			                  ;
    dbg_S_pla0_slice_rd_req_buf			<= S_pla0_slice_rd_req_buf			                  ;
    dbg_S_pla0_slice_data_rd_buf        <= S_pla0_slice_data_rd_buf                          ;
    dbg_S_pla1_slice_data_rd_buf        <= S_pla1_slice_data_rd_buf                          ;
    dbg_S_pla2_slice_data_rd_buf        <= S_pla2_slice_data_rd_buf                          ;
    dbg_S_ddr3a_slice_rd_req_lck		<= S_ddr3a_slice_rd_req_lck		                  ;
    dbg_S_ddr3a_slice_rd_req_lck_1d		<= S_ddr3a_slice_rd_req_lck_1d		                  ;
    dbg_S_ddr3b_slice_rd_req_lck		<= S_ddr3b_slice_rd_req_lck		                  ;
    dbg_S_ddr3b_slice_rd_req_lck_1d		<= S_ddr3b_slice_rd_req_lck_1d		                  ;
    dbg_S_pla1_slice_check_ok_buf		<= S_pla1_slice_check_ok_buf		                  ;
    dbg_S_pla1_lookup_addr				<= S_pla1_lookup_addr				                  ;
    dbg_S_pla1_lookup_wren				<= S_pla1_lookup_wren				                  ;
    dbg_S_pla1_lookup_wdata				<= S_pla1_lookup_wdata				                  ;
	dbg_S_pla1_slice_rd_id_1d			<= S_pla1_slice_rd_id_1d			                  ;
    dbg_S_pla1_lookup_rdata				<= S_pla1_lookup_rdata				                  ;
    dbg_S_pla1_lookup_rdata_1d			<= S_pla1_lookup_rdata_1d			                  ;
    dbg_S_pla1_slice_rd_req_lck			<= S_pla1_slice_rd_req_lck			                  ;
    dbg_S_pla1_slice_rd_req_buf			<= S_pla1_slice_rd_req_buf			                  ;
    dbg_S_pla2_slice_check_ok_buf		<= S_pla2_slice_check_ok_buf		                  ;
    dbg_S_pla2_lookup_addr				<= S_pla2_lookup_addr				                  ;
    dbg_S_pla2_lookup_wren				<= S_pla2_lookup_wren				                  ;
    dbg_S_pla2_lookup_wdata				<= S_pla2_lookup_wdata				                  ;
	dbg_S_pla2_slice_rd_id_1d			<= S_pla2_slice_rd_id_1d		                      ;
    dbg_S_pla2_lookup_rdata				<= S_pla2_lookup_rdata			                      ;
    dbg_S_pla2_lookup_rdata_1d			<= S_pla2_lookup_rdata_1d		                      ;
    dbg_S_pla2_slice_rd_req_lck			<= S_pla2_slice_rd_req_lck		                      ;
    dbg_S_pla2_slice_rd_req_buf			<= S_pla2_slice_rd_req_buf		                      ;
    dbg_S_pla0a_slice_rd_en_valid		<= S_pla0a_slice_rd_en_valid	                      ;
    //dbg_S_pla0a_slice_rd_en_valid_buf	<= S_pla0a_slice_rd_en_valid_buf                      ;
    dbg_S_pla0a_slice_rd_en_valid_cnt	<= S_pla0a_slice_rd_en_valid_cnt                      ;
    dbg_S_pla1a_slice_rd_en_valid		<= S_pla1a_slice_rd_en_valid	                      ;
    //dbg_S_pla1a_slice_rd_en_valid_buf	<= S_pla1a_slice_rd_en_valid_buf                      ;
    dbg_S_pla1a_slice_rd_en_valid_cnt	<= S_pla1a_slice_rd_en_valid_cnt                      ;
    dbg_S_pla2a_slice_rd_en_valid		<= S_pla2a_slice_rd_en_valid	                      ;
    //dbg_S_pla2a_slice_rd_en_valid_buf	<= S_pla2a_slice_rd_en_valid_buf                      ;
    dbg_S_pla2a_slice_rd_en_valid_cnt	<= S_pla2a_slice_rd_en_valid_cnt                      ;
    dbg_S_pla0b_slice_rd_en_valid		<= S_pla0b_slice_rd_en_valid	                      ;
    //dbg_S_pla0b_slice_rd_en_valid_buf	<= S_pla0b_slice_rd_en_valid_buf                      ;
    dbg_S_pla0b_slice_rd_en_valid_cnt	<= S_pla0b_slice_rd_en_valid_cnt                      ;
    dbg_S_pla1b_slice_rd_en_valid		<= S_pla1b_slice_rd_en_valid	                      ;
    //dbg_S_pla1b_slice_rd_en_valid_buf	<= S_pla1b_slice_rd_en_valid_buf                      ;
    dbg_S_pla1b_slice_rd_en_valid_cnt	<= S_pla1b_slice_rd_en_valid_cnt                      ;
    dbg_S_pla2b_slice_rd_en_valid		<= S_pla2b_slice_rd_en_valid	                      ;
    //dbg_S_pla2b_slice_rd_en_valid_buf	<= S_pla2b_slice_rd_en_valid_buf                      ;
    dbg_S_pla2b_slice_rd_en_valid_cnt	<= S_pla2b_slice_rd_en_valid_cnt                      ;
end

/////---------------------------------------------------------
///// debug end	
/////---------------------------------------------------------
always @ (posedge I_pla_312m5_clk) 
begin
    if(I_pla_rst) 
    begin
		S_pla_slice_payload_en_1d	<= 1'b0							; 
		S_pla_slice_payload_en_2d	<= 1'b0							; 
	end
	else 
	begin
		S_pla_slice_payload_en_1d	<= I_pla_slice_payload_en		; 
		S_pla_slice_payload_en_2d	<= S_pla_slice_payload_en_1d	;	
	end
end

///========I_pla_312m5_clk============================================                  
////=== delay
always @ (posedge I_pla_312m5_clk) 
begin
    if(I_pla_rst)
    begin
		S_pla_slice_payload_1d		<= 32'h0						;
		S_pla_slice_check_ok_buf	<= 8'h0							;
		S_pla0_slice_check_ok_buf	<= 8'h0							;
		S_pla1_slice_check_ok_buf	<= 8'h0							;
		S_pla2_slice_check_ok_buf	<= 8'h0							;
		S_wrbuf1_dpram_rdata_1d		<= 32'h0						;
		S_pla0_slice_rd_id_1d		<= 15'd0						;
		S_pla1_slice_rd_id_1d		<= 15'd0						;
		S_pla2_slice_rd_id_1d		<= 15'd0						;
		S_pla0_lookup_rdata_1d		<= 1'b0							;
		S_pla1_lookup_rdata_1d		<= 1'b0							;
		S_pla2_lookup_rdata_1d		<= 1'b0							;
		S_pla0a_slice_rd_en_valid_buf	<= 6'h0						;	
		S_pla1a_slice_rd_en_valid_buf	<= 6'h0						;	
		S_pla2a_slice_rd_en_valid_buf	<= 6'h0						;	
		S_pla0b_slice_rd_en_valid_buf	<= 6'h0						;	
		S_pla1b_slice_rd_en_valid_buf	<= 6'h0						;	
		S_pla2b_slice_rd_en_valid_buf	<= 6'h0						;	
		S_pla0_slice_rd_req_buf			<= 8'h0						;	
		S_pla1_slice_rd_req_buf			<= 8'h0						;	
		S_pla2_slice_rd_req_buf			<= 8'h0						;	
		S_ddr3a_slice_rd_req_lck_1d		<= 1'b0						;	
		S_ddr3b_slice_rd_req_lck_1d		<= 1'b0						;	

	end
	else
	begin
		S_pla_slice_payload_1d		<= I_pla_slice_payload			;
		S_pla_slice_check_ok_buf	<= {S_pla_slice_check_ok_buf[6:0],S_pla_slice_check_ok}; 
		S_pla0_slice_check_ok_buf	<= {S_pla0_slice_check_ok_buf[6:0],I_pla0_slice_check_ok}; 
		S_pla1_slice_check_ok_buf	<= {S_pla1_slice_check_ok_buf[6:0],I_pla1_slice_check_ok}; 
		S_pla2_slice_check_ok_buf	<= {S_pla2_slice_check_ok_buf[6:0],I_pla2_slice_check_ok}; 
		S_wrbuf1_dpram_rdata_1d		<= S_wrbuf1_dpram_rdata			;
		S_pla0_slice_rd_id_1d		<= I_pla0_slice_rd_id			; 
		S_pla1_slice_rd_id_1d		<= I_pla1_slice_rd_id			; 
		S_pla2_slice_rd_id_1d		<= I_pla2_slice_rd_id			; 
		S_pla0_lookup_rdata_1d		<= S_pla0_lookup_rdata			;
		S_pla1_lookup_rdata_1d		<= S_pla1_lookup_rdata			;
		S_pla2_lookup_rdata_1d		<= S_pla2_lookup_rdata			;
		S_pla0a_slice_rd_en_valid_buf <={S_pla0a_slice_rd_en_valid_buf[4:0],S_pla0a_slice_rd_en_valid}; 
		S_pla1a_slice_rd_en_valid_buf <={S_pla1a_slice_rd_en_valid_buf[4:0],S_pla1a_slice_rd_en_valid}; 
		S_pla2a_slice_rd_en_valid_buf <={S_pla2a_slice_rd_en_valid_buf[4:0],S_pla2a_slice_rd_en_valid}; 
		S_pla0b_slice_rd_en_valid_buf <={S_pla0b_slice_rd_en_valid_buf[4:0],S_pla0b_slice_rd_en_valid}; 
		S_pla1b_slice_rd_en_valid_buf <={S_pla1b_slice_rd_en_valid_buf[4:0],S_pla1b_slice_rd_en_valid}; 
		S_pla2b_slice_rd_en_valid_buf <={S_pla2b_slice_rd_en_valid_buf[4:0],S_pla2b_slice_rd_en_valid}; 
		S_pla0_slice_rd_req_buf			<= {S_pla0_slice_rd_req_buf[6:0],I_pla0_slice_rd_req}		; 
		S_pla1_slice_rd_req_buf			<= {S_pla1_slice_rd_req_buf[6:0],I_pla1_slice_rd_req}		; 
		S_pla2_slice_rd_req_buf			<= {S_pla2_slice_rd_req_buf[6:0],I_pla2_slice_rd_req}		; 
		S_ddr3a_slice_rd_req_lck_1d		<= S_ddr3a_slice_rd_req_lck	;	
		S_ddr3b_slice_rd_req_lck_1d		<= S_ddr3b_slice_rd_req_lck	;	
	end
end

always @ (posedge I_pla_312m5_clk) 
begin
    if(I_pla_rst)
    begin
        S_wrbuf1_dpram_wdata	<= 128'h0					; 
    end
    else
    begin
        S_wrbuf1_dpram_wdata	<= {S_wrbuf1_dpram_wdata[95:0],S_pla_slice_payload_1d};
    end
end

always @ (posedge I_pla_312m5_clk) 
begin
    if(I_pla_rst)
    begin
		S_wrbuf1_dpram_wcnt	<= 2'b00;
	end
	else if(S_pla_slice_payload_en_1d)
	begin
		S_wrbuf1_dpram_wcnt	<= S_wrbuf1_dpram_wcnt+2'b01;
	end
	else
	begin
		S_wrbuf1_dpram_wcnt	<= 2'b00;
	end
end

always @ (posedge I_pla_312m5_clk) 
begin
    if(I_pla_rst)
    begin
		S_wrbuf1_dpram_wren_pre	<= 1'b0		;       
	end
	else if(S_pla_slice_payload_en_1d && (S_wrbuf1_dpram_wcnt == 2'b10) )
	begin
		S_wrbuf1_dpram_wren_pre	<= 1'b1		;       
	end
	else
	begin
		S_wrbuf1_dpram_wren_pre	<= 1'b0		;       
	end
end

always @ (posedge I_pla_312m5_clk) 
begin
    if(I_pla_rst)
    begin
		S_wrbuf1_dpram_wren	<= 1'b0						;		
	end
	else
	begin
		S_wrbuf1_dpram_wren	<= S_wrbuf1_dpram_wren_pre	;
	end
end

always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst)
	begin
		S_wrbuf1_dpram_waddr <= 4'hf						;
	end
	else if(!S_pla_slice_payload_en_1d)
	begin
		S_wrbuf1_dpram_waddr <= 4'hf						;
	end
	else if(S_wrbuf1_dpram_wren_pre)
	begin
		S_wrbuf1_dpram_waddr <= S_wrbuf1_dpram_waddr + 4'h1	;
	end
	else
	begin
		S_wrbuf1_dpram_waddr <= S_wrbuf1_dpram_waddr		; 
	end
end

////32 to 128  --check ok
blk_sdpram_16x128_k7 U0_blk_sdpram_16x128_k7(
.clka		(I_pla_312m5_clk		),
.ena		(1'b1					),
.wea		(S_wrbuf1_dpram_wren	),
.addra		(S_wrbuf1_dpram_waddr	),
.dina		(S_wrbuf1_dpram_wdata	),
.clkb		(I_pla_312m5_clk		),
//.rstb       (I_pla_rst              ),
.enb		(1'b1					),
.addrb		(S_wrbuf1_dpram_raddr	),
.doutb		(S_wrbuf1_dpram_rdata	)
);



always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
    begin
		S_pla_slice_check_ok	<= 1'b0		;	
	end
	else 
	begin
		S_pla_slice_check_ok	<=	I_pla0_slice_check_ok | I_pla1_slice_check_ok 
									| I_pla2_slice_check_ok;//// pulse   
	end
end

always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_wrbuf1_dpram_raddr <= 4'hf;
        end
    else if(S_pla_slice_check_ok) /// by cqiu
        begin
            S_wrbuf1_dpram_raddr <= 4'h0;
        end
    else if(&S_wrbuf1_dpram_raddr)
        begin
            S_wrbuf1_dpram_raddr <= 4'hf;
        end
    else
        begin
            S_wrbuf1_dpram_raddr <= S_wrbuf1_dpram_raddr + 4'd1;
        end
end

always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst)
    begin
        S_pla_slice_wr_resp   <= 1'b0;
    end
    //else if(S_wrbuf1_dpram_raddr == 4'd10)
    else if(S_wrbuf1_dpram_raddr == 4'd14)
    begin 
        S_pla_slice_wr_resp   <= 1'b1 ;
    end
    else  
    begin 
        S_pla_slice_wr_resp   <= 1'b0;
    end
end

always @ (posedge I_pla_312m5_clk)
begin
	S_pla_slice_wr_resp_buf	<= {S_pla_slice_wr_resp_buf[6:0],S_pla_slice_wr_resp };
end


always @ (posedge I_pla_312m5_clk)
begin
    //S_wrbuf2_fifo_wdata <= {S_wrbuf2_fifo_wdata[95:0],S_wrbuf1_dpram_rdata_1d};
    S_wrbuf2_fifo_wdata <= S_wrbuf1_dpram_rdata_1d		;
end

always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst)
    begin
		S_wrbuf2_fifo_wdata_1d		<= 144'd0						; 
	end
	else
	begin
		S_wrbuf2_fifo_wdata_1d		<={S_pla_xgmii_num[1:0],S_pla_slice_wr_id[13:0],
										S_wrbuf2_fifo_wdata[127:0]}	;
	end
end
always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
    begin
			S_pla_slice_wr_id			<= 15'd0				; 
			S_pla_xgmii_num				<= 2'b0					;
	end
	else if(S_pla_slice_check_ok)
    begin
			S_pla_slice_wr_id			<= I_pla_slice_id		; 
			S_pla_xgmii_num				<= I_pla_xgmii_num		; 
	end
	else
	begin
			S_pla_slice_wr_id			<= S_pla_slice_wr_id	;	
			S_pla_xgmii_num				<= S_pla_xgmii_num		; 
	end
end

always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst)
	begin
		S_pla_ddr3_wr_order	<= 1'b0					;
	end
	else if(S_pla_slice_check_ok_buf[5:4] == 2'b01)
	begin
		S_pla_ddr3_wr_order	<= ~S_pla_ddr3_wr_order	;	
	end
	else
	begin
		S_pla_ddr3_wr_order	<= S_pla_ddr3_wr_order	;	
	end
end


always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst)
	begin
			S_pla_ddr3_wrinfo	<= 1'b0						; 
	end
	else if(S_pla_slice_check_ok_buf[0]) // pulse
	begin
		//// write ddr3a ,then ddr3b,ddr3a,ddr3b ... ... ..
			S_pla_ddr3_wrinfo	<= S_pla_ddr3_wr_order		; 
			//S_pla_ddr3_wrinfo	<= 1'b0			; 
		/*
		if(I_ddr3a_wrbuf2_usedw[8:0] < I_ddr3b_wrbuf2_usedw[8:0])
		begin //// if ddr3a usedw is less than ddr3b 
			S_pla_ddr3_wrinfo	<= 1'b0						; 
		end
		else
		begin
			S_pla_ddr3_wrinfo	<= 1'b1						; 
		end
		*/
	end
	else
	begin
			S_pla_ddr3_wrinfo	<= S_pla_ddr3_wrinfo	;	
	end
end


////====O_ddr3a_wrbuf2_fifo_wdata
////====O_ddr3a_wrbuf2_fifo_wren



always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst)
	begin
            S_wrbuf2_dpram_waddr <= 4'hf;
	end
    else if(S_pla_slice_check_ok_buf[5])
    begin
            S_wrbuf2_dpram_waddr <= 4'd0;
    end
    else if(&S_wrbuf2_dpram_waddr)
    begin
            S_wrbuf2_dpram_waddr <= 4'hf						;
    end
    else
    begin
            S_wrbuf2_dpram_waddr <= S_wrbuf2_dpram_waddr + 4'h1;
    end
end

always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst)
	begin
		S_wrbuf2_fifo_wren	<= 1'b0;
	end
    else if(S_pla_slice_check_ok_buf[5])
	begin
		S_wrbuf2_fifo_wren	<= 1'b1;
	end
	else if(&S_wrbuf2_dpram_waddr)
	begin
		S_wrbuf2_fifo_wren	<= 1'b0;
	end
	else
	begin
		S_wrbuf2_fifo_wren	<= S_wrbuf2_fifo_wren	;	
	end
end

////====O_ddr3a_wrbuf2_fifo_wdata
////====O_ddr3a_wrbuf2_fifo_wren
////====O_ddr3b_wrbuf2_fifo_wdata
////====O_ddr3b_wrbuf2_fifo_wren
always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst)
	begin
		O_ddr3a_wrbuf2_fifo_wdata	<= 144'd0					;		
		O_ddr3b_wrbuf2_fifo_wdata	<= 144'd0					;		
	end
	else
	begin
		O_ddr3a_wrbuf2_fifo_wdata	<= S_wrbuf2_fifo_wdata_1d	;		
		O_ddr3b_wrbuf2_fifo_wdata	<= S_wrbuf2_fifo_wdata_1d	;		
	end
end
always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst) 
	begin
		O_ddr3a_wrbuf2_fifo_wren	<= 1'b0					;
	end
	else if(!S_pla_ddr3_wrinfo)
	begin
		O_ddr3a_wrbuf2_fifo_wren	<= S_wrbuf2_fifo_wren	;
	end
	else
	begin
		O_ddr3a_wrbuf2_fifo_wren	<= 1'b0					;
	end
end
always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst) 
	begin
		O_ddr3b_wrbuf2_fifo_wren	<= 1'b0					;
	end
	else if(S_pla_ddr3_wrinfo)
	begin
		O_ddr3b_wrbuf2_fifo_wren	<= S_wrbuf2_fifo_wren	;
	end
	else
	begin
		O_ddr3b_wrbuf2_fifo_wren	<= 1'b0					;
	end
end

//// pla0 / pla1 / pla2 lookup table
//// pla0 
always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst)
	begin
		O_pla0_slice_wr_resp	<= 1'b0						; 
	end
	else if(S_pla_xgmii_num == 2'b00) 
	begin
		O_pla0_slice_wr_resp	<= S_pla_slice_wr_resp_buf[7];	
	end
	else
	begin
		O_pla0_slice_wr_resp	<= 1'b0						; 
	end
end
always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
    begin
			O_pla0_slice_num_id			<= 15'd0				; 
	end
	else if(S_pla0_slice_check_ok_buf[2])
    begin
			O_pla0_slice_num_id			<= I_pla_slice_id		; 
	end
	else
	begin
			O_pla0_slice_num_id			<= O_pla0_slice_num_id	;	
	end
end
always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst)
	begin
		S_pla0_lookup_addr	<= 15'd0			; 
	end
	else if(I_pla0_slice_check_ok) // pulse
	begin
		S_pla0_lookup_addr	<= I_pla_slice_id	; 
	end
end
always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst)
	begin
		S_pla0_lookup_wren	<= 1'b0			; 
	end
	else if(S_pla0_slice_check_ok_buf[3]) // pulse
	begin
		S_pla0_lookup_wren	<= 1'b1			; 
	end
	else
	begin
		S_pla0_lookup_wren	<= 1'b0			; 
	end
end

always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst)
	begin
		S_pla0_lookup_wdata	<= 1'b0						; 
	end
	else 
	begin
		S_pla0_lookup_wdata	<= S_pla_ddr3_wrinfo		; 
	end
end


		



////
blk_sdpram_32768x1_k7 U0_blk_sdpram_32768x1_k7(
.clka		(I_pla_312m5_clk			),
.ena		(1'b1						),
.wea		(S_pla0_lookup_wren			),
.addra		(S_pla0_lookup_addr			),
.dina		(S_pla0_lookup_wdata		),
.clkb		(I_pla_312m5_clk			),
.rstb		(I_pla_rst					),
.enb		(1'b1						),
.addrb		(S_pla0_slice_rd_id_1d		),
.doutb		(S_pla0_lookup_rdata		)
);

//// pla1 
always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst)
	begin
		O_pla1_slice_wr_resp	<= 1'b0						; 
	end
	else if(S_pla_xgmii_num == 2'b01) 
	begin
		O_pla1_slice_wr_resp	<= S_pla_slice_wr_resp_buf[7]	;	
	end
	else
	begin
		O_pla1_slice_wr_resp	<= 1'b0						; 
	end
end
always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
    begin
			O_pla1_slice_num_id			<= 15'd0				; 
	end
	else if(S_pla1_slice_check_ok_buf[2])
    begin
			O_pla1_slice_num_id			<= I_pla_slice_id		; 
	end
	else
	begin
			O_pla1_slice_num_id			<= O_pla1_slice_num_id	;	
	end
end
always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst)
	begin
		S_pla1_lookup_addr	<= 15'd0			; 
	end
	else if(I_pla1_slice_check_ok) // pulse
	begin
		S_pla1_lookup_addr	<= I_pla_slice_id	; 
	end
end
always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst)
	begin
		S_pla1_lookup_wren	<= 1'b0			; 
	end
	else if(S_pla1_slice_check_ok_buf[3]) // pulse
	begin
		S_pla1_lookup_wren	<= 1'b1			; 
	end
	else
	begin
		S_pla1_lookup_wren	<= 1'b0			; 
	end
end
always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst)
	begin
		S_pla1_lookup_wdata	<= 1'b0						; 
	end
	else 
	begin
		S_pla1_lookup_wdata	<= S_pla_ddr3_wrinfo		; 
	end
end
////
blk_sdpram_32768x1_k7 U1_blk_sdpram_32768x1_k7(
.clka		(I_pla_312m5_clk			),
.ena		(1'b1						),
.wea		(S_pla1_lookup_wren			),
.addra		(S_pla1_lookup_addr			),
.dina		(S_pla1_lookup_wdata		),
.clkb		(I_pla_312m5_clk			),
.rstb		(I_pla_rst					),
.enb		(1'b1						),
.addrb		(S_pla1_slice_rd_id_1d		),
.doutb		(S_pla1_lookup_rdata		)
);
//// pla2
always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst)
	begin
		O_pla2_slice_wr_resp	<= 1'b0						; 
	end
	else if(S_pla_xgmii_num == 2'b10) 
	begin
		O_pla2_slice_wr_resp	<= S_pla_slice_wr_resp_buf[7]		;	
	end
	else
	begin
		O_pla2_slice_wr_resp	<= 1'b0						; 
	end
end
always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
    begin
			O_pla2_slice_num_id			<= 15'd0				; 
	end
	else if(S_pla2_slice_check_ok_buf[2])
    begin
			O_pla2_slice_num_id			<= I_pla_slice_id		; 
	end
	else
	begin
			O_pla2_slice_num_id			<= O_pla2_slice_num_id	;	
	end
end
always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst)
	begin
		S_pla2_lookup_addr	<= 15'd0			; 
	end
	else if(I_pla2_slice_check_ok) // pulse
	begin
		S_pla2_lookup_addr	<= I_pla_slice_id	; 
	end
end

always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst)
	begin
		S_pla2_lookup_wren	<= 1'b0			; 
	end
	else if(S_pla2_slice_check_ok_buf[3]) // pulse
	begin
		S_pla2_lookup_wren	<= 1'b1			; 
	end
	else
	begin
		S_pla2_lookup_wren	<= 1'b0			; 
	end
end	
always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst)
	begin
		S_pla2_lookup_wdata	<= 1'b0						; 
	end
	else 
	begin
		S_pla2_lookup_wdata	<= S_pla_ddr3_wrinfo		; 
	end
end
////
blk_sdpram_32768x1_k7 U2_blk_sdpram_32768x1_k7(
.clka		(I_pla_312m5_clk			),
.ena		(1'b1						),
.wea		(S_pla2_lookup_wren			),
.addra		(S_pla2_lookup_addr			),
.dina		(S_pla2_lookup_wdata		),
.clkb		(I_pla_312m5_clk			),
.rstb		(I_pla_rst					),
.enb		(1'b1						),
.addrb		(S_pla2_slice_rd_id_1d		),
.doutb		(S_pla2_lookup_rdata		)
);


always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst)
	begin
		S_pla0_slice_rd_req_lck	<= 1'b0					; 
	end
	else if(S_pla0_slice_rd_req_buf[4]) 
	begin
		S_pla0_slice_rd_req_lck	<= 1'b1					; 
	end
	else if(O_pla0_slice_rd_resp)
	begin
		S_pla0_slice_rd_req_lck	<= 1'b0					; 
	end
end

always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst)
	begin
		S_pla1_slice_rd_req_lck	<= 1'b0					; 
	end
	//else if(I_pla1_slice_rd_req) 
	else if(S_pla1_slice_rd_req_buf[4]) 
	begin
		S_pla1_slice_rd_req_lck	<= 1'b1					; 
	end
	else if(O_pla1_slice_rd_resp)
	begin
		S_pla1_slice_rd_req_lck	<= 1'b0					; 
	end
end

always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst)
	begin
		S_pla2_slice_rd_req_lck	<= 1'b0					; 
	end
	//else if(I_pla2_slice_rd_req) 
	else if(S_pla2_slice_rd_req_buf[4]) 
	begin
		S_pla2_slice_rd_req_lck	<= 1'b1					; 
	end
	else if(O_pla2_slice_rd_resp)
	begin
		S_pla2_slice_rd_req_lck	<= 1'b0					; 
	end
end

////====ddr3a state====
////update
always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst)
	begin
		S_ddr3a_req_state		<= C_DDR3_IDLE				; 
		S_ddr3a_req_state_1d	<= C_DDR3_IDLE				; 
	end
	else 
	begin
		S_ddr3a_req_state		<= S_ddr3a_req_state_next	; 
		S_ddr3a_req_state_1d	<= S_ddr3a_req_state		; 
	end
end

always @(*)
begin
	case(S_ddr3a_req_state)
	C_DDR3_IDLE:
	begin //// turn by turn , no priority
		if(S_pla0_slice_rd_req_lck && (!S_pla0_lookup_rdata) && (!S_ddr3a_req_state[C_POS_DDR3_REQ0]))
		begin
			S_ddr3a_req_state_next	<= C_DDR3_REQ0		;
		end
		else if(S_pla1_slice_rd_req_lck && (!S_pla1_lookup_rdata) && (!S_ddr3a_req_state[C_POS_DDR3_REQ1]))
		begin
			S_ddr3a_req_state_next	<= C_DDR3_REQ1		;
		end
		else if(S_pla2_slice_rd_req_lck && (!S_pla2_lookup_rdata) )
		begin
			S_ddr3a_req_state_next	<= C_DDR3_REQ2		;
		end
		else
		begin
			S_ddr3a_req_state_next	<= C_DDR3_IDLE		;
		end
	end
	C_DDR3_REQ0:
	begin
		//if(S_pla0a_slice_rd_en_valid_cnt == 6'd40) ////before the reflow module get the data from the ddr3 rbuf1 
		if(S_pla0a_slice_rd_en_valid_cnt == I_slice_rd_en_valid_cnt_fix[5:0] ) ////before the reflow module get the data from the ddr3 rbuf1 
		begin
			S_ddr3a_req_state_next	<= C_DDR3_IDLE		;
		end
		else
		begin
			S_ddr3a_req_state_next	<= C_DDR3_REQ0		;
		end
	end
	C_DDR3_REQ1:
	begin
		//if(S_pla1a_slice_rd_en_valid_cnt == 6'd40) ////before the reflow module get the data from the ddr3 rbuf1 
		if(S_pla1a_slice_rd_en_valid_cnt == I_slice_rd_en_valid_cnt_fix[5:0] ) ////before the reflow module get the data from the ddr3 rbuf1 
		begin
			S_ddr3a_req_state_next	<= C_DDR3_IDLE		;
		end
		else
		begin
			S_ddr3a_req_state_next	<= C_DDR3_REQ1		;
		end
	end
	C_DDR3_REQ2:
	begin
		//if(S_pla2a_slice_rd_en_valid_cnt == 6'd40) ////before the reflow module get the data from the ddr3 rbuf1 
		if(S_pla2a_slice_rd_en_valid_cnt == I_slice_rd_en_valid_cnt_fix[5:0]) ////before the reflow module get the data from the ddr3 rbuf1 
		begin
			S_ddr3a_req_state_next	<= C_DDR3_IDLE		;
		end
		else
		begin
			S_ddr3a_req_state_next	<= C_DDR3_REQ2		;
		end
	end
	default:
	begin
			S_ddr3a_req_state_next	<= C_DDR3_IDLE		;
	end
	endcase
end

always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst)
	begin
			O_ddr3a_slice_rd_req		<= 1'b0		;
	end
	else if( S_ddr3a_req_state[C_POS_DDR3_REQ0] || S_ddr3a_req_state[C_POS_DDR3_REQ1] 
			||S_ddr3a_req_state[C_POS_DDR3_REQ2] )
	begin
			O_ddr3a_slice_rd_req	<= S_ddr3a_slice_rd_req_lck && (!S_ddr3a_slice_rd_req_lck_1d) ; 	
	end
	else
	begin
			O_ddr3a_slice_rd_req		<= 1'b0		;
	end
end

//// pla group 0
always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst)
	begin
			O_ddr3a_pla_xgmii_num	<= 2'b00	;	
			O_ddr3a_slice_rd_id		<= 15'd0	;	
			S_ddr3a_slice_rd_req_lck	<= 1'b0		;	
	end
	else 
	begin
		case(S_ddr3a_req_state)
		C_DDR3_REQ0:
		begin
			O_ddr3a_pla_xgmii_num	<= 2'b00				;	
			O_ddr3a_slice_rd_id		<= I_pla0_slice_rd_id	;	
			if(S_pla0_slice_rd_req_lck) 
			begin
				S_ddr3a_slice_rd_req_lck	<= 1'b1			; 
			end
		end
		C_DDR3_REQ1:
		begin
			O_ddr3a_pla_xgmii_num	<= 2'b01				;	
			O_ddr3a_slice_rd_id		<= I_pla1_slice_rd_id	;	
			if(S_pla1_slice_rd_req_lck) 
			begin
				S_ddr3a_slice_rd_req_lck	<= 1'b1			; 
			end
		end
		C_DDR3_REQ2:
		begin
			O_ddr3a_pla_xgmii_num	<= 2'b10				;	
			O_ddr3a_slice_rd_id		<= I_pla2_slice_rd_id	;	
			if(S_pla2_slice_rd_req_lck) 
			begin
				S_ddr3a_slice_rd_req_lck	<= 1'b1			; 
			end
		end
		default:
		begin
			O_ddr3a_pla_xgmii_num	<= 2'b00				;	
			O_ddr3a_slice_rd_id		<= 15'd0				;	
			S_ddr3a_slice_rd_req_lck<= 1'b0					;	
		end
		endcase
	end
end


always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst)
	begin
		O_ddr3a_slice_rd_en		<= 1'b0		;	
	end
	else if(S_pla0a_slice_rd_en_valid)
	begin
		O_ddr3a_slice_rd_en		<= I_pla0_slice_data_rd	;	
	end
	else if(S_pla1a_slice_rd_en_valid)
	begin
		O_ddr3a_slice_rd_en		<= I_pla1_slice_data_rd	;	
	end
	else if(S_pla2a_slice_rd_en_valid)
	begin
		O_ddr3a_slice_rd_en		<= I_pla2_slice_data_rd	;	
	end
	else
	begin
		O_ddr3a_slice_rd_en		<= 1'b0		;	
	end
end


always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst)
	begin
			S_pla0a_slice_rd_en_valid	<= 1'b0		;	
	end
	else if(S_ddr3a_req_state[C_POS_DDR3_REQ0])
	begin
		if(I_ddr3a_slice_rd_resp)		
		begin
			S_pla0a_slice_rd_en_valid	<= 1'b1						;	
		end
		else
		begin
			S_pla0a_slice_rd_en_valid	<= S_pla0a_slice_rd_en_valid;	
		end
	end
	else if((&S_pla0a_slice_rd_en_valid_cnt[5:0]))
	begin
			S_pla0a_slice_rd_en_valid	<= 1'b0		;	
	end
end
always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst)
	begin
		S_pla0a_slice_rd_en_valid_cnt	<= 6'b0								;	
	end
	else if(O_ddr3a_slice_rd_en)
	begin
		S_pla0a_slice_rd_en_valid_cnt	<= S_pla0a_slice_rd_en_valid_cnt+6'b1;	
	end
	else
	begin
		S_pla0a_slice_rd_en_valid_cnt	<= 6'b0								;	
	end
end

always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst)
	begin
			S_pla1a_slice_rd_en_valid	<= 1'b0		;	
	end
	else if(S_ddr3a_req_state[C_POS_DDR3_REQ1])
	begin
		if(I_ddr3a_slice_rd_resp)		
		begin
			S_pla1a_slice_rd_en_valid	<= 1'b1		;	
		end
	end
	else if((&S_pla1a_slice_rd_en_valid_cnt[5:0]))
	begin
			S_pla1a_slice_rd_en_valid	<= 1'b0		;	
	end
end
always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst)
	begin
		S_pla1a_slice_rd_en_valid_cnt	<= 6'b0								;	
	end
	else if(O_ddr3a_slice_rd_en)
	begin
		S_pla1a_slice_rd_en_valid_cnt	<= S_pla1a_slice_rd_en_valid_cnt+6'b1;	
	end
	else
	begin
		S_pla1a_slice_rd_en_valid_cnt	<= 6'b0								;	
	end
end

always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst)
	begin
			S_pla2a_slice_rd_en_valid	<= 1'b0		;	
	end
	else if(S_ddr3a_req_state[C_POS_DDR3_REQ2])
	begin
		if(I_ddr3a_slice_rd_resp)		
		begin
			S_pla2a_slice_rd_en_valid	<= 1'b1		;	
		end
	end
	else if((&S_pla2a_slice_rd_en_valid_cnt[5:0]))
	begin
			S_pla2a_slice_rd_en_valid	<= 1'b0		;	
	end
end
always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst)
	begin
		S_pla2a_slice_rd_en_valid_cnt	<= 6'b0								;	
	end
	else if(O_ddr3a_slice_rd_en)
	begin
		S_pla2a_slice_rd_en_valid_cnt	<= S_pla2a_slice_rd_en_valid_cnt+6'b1;	
	end
	else
	begin
		S_pla2a_slice_rd_en_valid_cnt	<= 6'b0								;	
	end
end







always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst)
	begin
			O_pla0_slice_rd_resp	<= 1'b0		;	
	end
	else if(S_ddr3a_req_state[C_POS_DDR3_REQ0] || S_ddr3b_req_state[C_POS_DDR3_REQ0])
	begin
			O_pla0_slice_rd_resp	<= (I_ddr3a_slice_rd_resp &  S_ddr3a_req_state[C_POS_DDR3_REQ0])
										| (I_ddr3b_slice_rd_resp & S_ddr3b_req_state[C_POS_DDR3_REQ0]);	
	end
	else
	begin
			O_pla0_slice_rd_resp	<= 1'b0		;	
	end
end
/*
always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst)
	begin
			O_pla0_slice_rd_resp	<= 1'b0		;	
	end
	else if(S_ddr3a_req_state[C_POS_DDR3_REQ0])
	begin
			O_pla0_slice_rd_resp	<= I_ddr3a_slice_rd_resp;	
	end
	else if(S_ddr3b_req_state[C_POS_DDR3_REQ0])
	begin
			O_pla0_slice_rd_resp	<= I_ddr3b_slice_rd_resp;	
	end
	else
	begin
			O_pla0_slice_rd_resp	<= 1'b0		;	
	end
end
*/
	


always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst)
	begin
			O_pla0_slice_rdata		<= 32'h0	;	
	end
	//else if(S_ddr3a_req_state[C_POS_DDR3_REQ0])
	else if(|S_pla0a_slice_rd_en_valid_buf)
	begin
			O_pla0_slice_rdata		<= O_ddr3a_slice_rdata	;	
	end
	//else if(S_ddr3b_req_state[C_POS_DDR3_REQ0])
	else if(|S_pla0b_slice_rd_en_valid_buf)
	begin
			O_pla0_slice_rdata		<= O_ddr3b_slice_rdata	;	
	end
	else
	begin
			O_pla0_slice_rdata		<= 32'h0	;	
	end
end

always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst)
	begin
			O_pla1_slice_rd_resp	<= 1'b0		;	
	end
	else if(S_ddr3a_req_state[C_POS_DDR3_REQ1] || S_ddr3b_req_state[C_POS_DDR3_REQ1])
	begin
			O_pla1_slice_rd_resp	<= (I_ddr3a_slice_rd_resp & S_ddr3a_req_state[C_POS_DDR3_REQ1]) 
										| (I_ddr3b_slice_rd_resp & S_ddr3b_req_state[C_POS_DDR3_REQ1]) ;	
	end
	else
	begin
			O_pla1_slice_rd_resp	<= 1'b0		;	
	end
end


always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst)
	begin
			O_pla1_slice_rdata		<= 32'h0	;	
	end
	//else if(S_ddr3a_req_state[C_POS_DDR3_REQ0])
	else if(|S_pla1a_slice_rd_en_valid_buf)
	begin
			O_pla1_slice_rdata		<= O_ddr3a_slice_rdata	;	
	end
	//else if(S_ddr3b_req_state[C_POS_DDR3_REQ0])
	else if(|S_pla1b_slice_rd_en_valid_buf)
	begin
			O_pla1_slice_rdata		<= O_ddr3b_slice_rdata	;	
	end
	else
	begin
			O_pla1_slice_rdata		<= 32'h0	;	
	end
end

always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst)
	begin
			O_pla2_slice_rd_resp	<= 1'b0		;	
	end
	else if(S_ddr3a_req_state[C_POS_DDR3_REQ2] || S_ddr3b_req_state[C_POS_DDR3_REQ2])
	begin
			O_pla2_slice_rd_resp	<= (I_ddr3a_slice_rd_resp & S_ddr3a_req_state[C_POS_DDR3_REQ2])
										| (I_ddr3b_slice_rd_resp & S_ddr3b_req_state[C_POS_DDR3_REQ2]);	
	end
	else
	begin
			O_pla2_slice_rd_resp	<= 1'b0		;	
	end
end

always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst)
	begin
			O_pla2_slice_rdata		<= 32'h0	;	
	end
	//else if(S_ddr3a_req_state[C_POS_DDR3_REQ0])
	else if(|S_pla2a_slice_rd_en_valid_buf)
	begin
			O_pla2_slice_rdata		<= O_ddr3a_slice_rdata	;	
	end
	//else if(S_ddr3b_req_state[C_POS_DDR3_REQ0])
	else if(|S_pla2b_slice_rd_en_valid_buf)
	begin
			O_pla2_slice_rdata		<= O_ddr3b_slice_rdata	;	
	end
	else
	begin
			O_pla2_slice_rdata		<= 32'h0	;	
	end
end



////====ddr3b state====
////update
always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst)
	begin
		S_ddr3b_req_state		<= C_DDR3_IDLE				; 
		S_ddr3b_req_state_1d	<= C_DDR3_IDLE				; 
	end
	else 
	begin
		S_ddr3b_req_state		<= S_ddr3b_req_state_next	; 
		S_ddr3b_req_state_1d	<= S_ddr3b_req_state		; 
	end
end

always @(*)
begin
	case(S_ddr3b_req_state)
	C_DDR3_IDLE:
	begin //// turn by turn , no priority
		if(S_pla0_slice_rd_req_lck && (S_pla0_lookup_rdata) && (!S_ddr3b_req_state[C_POS_DDR3_REQ0]))
		begin
			S_ddr3b_req_state_next	<= C_DDR3_REQ0		;
		end
		else if(S_pla1_slice_rd_req_lck && (S_pla1_lookup_rdata) && (!S_ddr3b_req_state[C_POS_DDR3_REQ1]))
		begin
			S_ddr3b_req_state_next	<= C_DDR3_REQ1		;
		end
		else if(S_pla2_slice_rd_req_lck && (S_pla2_lookup_rdata) )
		begin
			S_ddr3b_req_state_next	<= C_DDR3_REQ2		;
		end
		else
		begin
			S_ddr3b_req_state_next	<= C_DDR3_IDLE		;
		end
	end
	C_DDR3_REQ0:
	begin
		//if(S_pla0b_slice_rd_en_valid_cnt == 6'd40) ////before the reflow module get the data from the ddr3 rbuf1 
		if(S_pla0b_slice_rd_en_valid_cnt == I_slice_rd_en_valid_cnt_fix[5:0]) ////before the reflow module get the data from the ddr3 rbuf1 
		begin
			S_ddr3b_req_state_next	<= C_DDR3_IDLE		;
		end
		else
		begin
			S_ddr3b_req_state_next	<= C_DDR3_REQ0		;
		end
	end
	C_DDR3_REQ1:
	begin
		//if(S_pla1b_slice_rd_en_valid_cnt == 6'd40) ////before the reflow module get the data from the ddr3 rbuf1 
		if(S_pla1b_slice_rd_en_valid_cnt == I_slice_rd_en_valid_cnt_fix[5:0]) ////before the reflow module get the data from the ddr3 rbuf1 
		begin
			S_ddr3b_req_state_next	<= C_DDR3_IDLE		;
		end
		else
		begin
			S_ddr3b_req_state_next	<= C_DDR3_REQ1		;
		end
	end
	C_DDR3_REQ2:
	begin
		//if(S_pla2b_slice_rd_en_valid_cnt == 6'd40) ////before the reflow module get the data from the ddr3 rbuf1 
		if(S_pla2b_slice_rd_en_valid_cnt == I_slice_rd_en_valid_cnt_fix[5:0]) ////before the reflow module get the data from the ddr3 rbuf1 
		begin
			S_ddr3b_req_state_next	<= C_DDR3_IDLE		;
		end
		else
		begin
			S_ddr3b_req_state_next	<= C_DDR3_REQ2		;
		end
	end
	default:
	begin
			S_ddr3b_req_state_next	<= C_DDR3_IDLE		;
	end
	endcase
end

always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst)
	begin
			O_ddr3b_slice_rd_req		<= 1'b0		;
	end
	else if( S_ddr3b_req_state[C_POS_DDR3_REQ0] || S_ddr3b_req_state[C_POS_DDR3_REQ1] 
			||S_ddr3b_req_state[C_POS_DDR3_REQ2] )
	begin
			O_ddr3b_slice_rd_req	<= S_ddr3b_slice_rd_req_lck && (!S_ddr3b_slice_rd_req_lck_1d) ; 	
	end
	else
	begin
			O_ddr3b_slice_rd_req		<= 1'b0		;
	end
end

//// pla group 0
always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst)
	begin
			O_ddr3b_pla_xgmii_num	<= 2'b00	;	
			O_ddr3b_slice_rd_id		<= 15'd0	;	
			S_ddr3b_slice_rd_req_lck<= 1'b0		;	
	end
	else 
	begin
		case(S_ddr3b_req_state)
		C_DDR3_REQ0:
		begin
			O_ddr3b_pla_xgmii_num	<= 2'b00				;	
			O_ddr3b_slice_rd_id		<= I_pla0_slice_rd_id	;	
			if(S_pla0_slice_rd_req_lck) 
			begin
				S_ddr3b_slice_rd_req_lck	<= 1'b1; 
			end

			//O_ddr3b_slice_rd_req	<= S_pla0_slice_rd_req_lck ;	
		end
		C_DDR3_REQ1:
		begin
			O_ddr3b_pla_xgmii_num	<= 2'b01				;	
			O_ddr3b_slice_rd_id		<= I_pla1_slice_rd_id	;	
			//O_ddr3b_slice_rd_req	<= S_pla1_slice_rd_req_lck ;	
			if(S_pla1_slice_rd_req_lck) 
			begin
				S_ddr3b_slice_rd_req_lck	<= 1'b1; 
			end
		end
		C_DDR3_REQ2:
		begin
			O_ddr3b_pla_xgmii_num	<= 2'b10				;	
			O_ddr3b_slice_rd_id		<= I_pla2_slice_rd_id	;	
			//O_ddr3b_slice_rd_req	<= S_pla2_slice_rd_req_lck ;	
			if(S_pla2_slice_rd_req_lck) 
			begin
				S_ddr3b_slice_rd_req_lck	<= 1'b1; 
			end
		end
		default:
		begin
			O_ddr3b_pla_xgmii_num	<= 2'b00				;	
			O_ddr3b_slice_rd_id		<= 15'd0				;	
			S_ddr3b_slice_rd_req_lck	<= 1'b0				; 
		end
		endcase
	end
end


always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst)
	begin
		O_ddr3b_slice_rd_en		<= 1'b0		;	
	end
	else if(S_pla0b_slice_rd_en_valid)
	begin
		O_ddr3b_slice_rd_en		<= I_pla0_slice_data_rd	;	
	end
	else if(S_pla1b_slice_rd_en_valid)
	begin
		O_ddr3b_slice_rd_en		<= I_pla1_slice_data_rd	;	
	end
	else if(S_pla2b_slice_rd_en_valid)
	begin
		O_ddr3b_slice_rd_en		<= I_pla2_slice_data_rd	;	
	end
	else
	begin
		O_ddr3b_slice_rd_en		<= 1'b0		;	
	end
end


always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst)
	begin
			S_pla0b_slice_rd_en_valid	<= 1'b0		;	
	end
	else if(S_ddr3b_req_state[C_POS_DDR3_REQ0])
	begin
		if(I_ddr3b_slice_rd_resp)		
		begin
			S_pla0b_slice_rd_en_valid	<= 1'b1		;	
		end
	end
	else if((&S_pla0b_slice_rd_en_valid_cnt[5:0]))
	begin
			S_pla0b_slice_rd_en_valid	<= 1'b0		;	
	end
end
always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst)
	begin
		S_pla0b_slice_rd_en_valid_cnt	<= 6'b0								;	
	end
	else if(O_ddr3b_slice_rd_en)
	begin
		S_pla0b_slice_rd_en_valid_cnt	<= S_pla0b_slice_rd_en_valid_cnt+6'b1;	
	end
	else
	begin
		S_pla0b_slice_rd_en_valid_cnt	<= 6'b0								;	
	end
end

always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst)
	begin
			S_pla1b_slice_rd_en_valid	<= 1'b0		;	
	end
	else if(S_ddr3b_req_state[C_POS_DDR3_REQ1])
	begin
		if(I_ddr3b_slice_rd_resp)		
		begin
			S_pla1b_slice_rd_en_valid	<= 1'b1		;	
		end
	end
	else if((&S_pla1b_slice_rd_en_valid_cnt[5:0]))
	begin
			S_pla1b_slice_rd_en_valid	<= 1'b0		;	
	end
end
always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst)
	begin
		S_pla1b_slice_rd_en_valid_cnt	<= 6'b0								;	
	end
	else if(O_ddr3b_slice_rd_en)
	begin
		S_pla1b_slice_rd_en_valid_cnt	<= S_pla1b_slice_rd_en_valid_cnt+6'b1;	
	end
	else
	begin
		S_pla1b_slice_rd_en_valid_cnt	<= 6'b0								;	
	end
end

always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst)
	begin
			S_pla2b_slice_rd_en_valid	<= 1'b0		;	
	end
	else if(S_ddr3b_req_state[C_POS_DDR3_REQ2])
	begin
		if(I_ddr3b_slice_rd_resp)		
		begin
			S_pla2b_slice_rd_en_valid	<= 1'b1		;	
		end
	end
	else if((&S_pla2b_slice_rd_en_valid_cnt[5:0]))
	begin
			S_pla2b_slice_rd_en_valid	<= 1'b0		;	
	end
end
always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst)
	begin
		S_pla2b_slice_rd_en_valid_cnt	<= 6'b0								;	
	end
	else if(O_ddr3b_slice_rd_en)
	begin
		S_pla2b_slice_rd_en_valid_cnt	<= S_pla2b_slice_rd_en_valid_cnt+6'b1;	
	end
	else
	begin
		S_pla2b_slice_rd_en_valid_cnt	<= 6'b0								;	
	end
end

//================Maintenance

always @ (posedge I_pla_312m5_clk)
begin
	S_pla0_slice_data_rd_buf <= {S_pla0_slice_data_rd_buf[2:0],I_pla0_slice_data_rd };
	S_pla1_slice_data_rd_buf <= {S_pla1_slice_data_rd_buf[2:0],I_pla1_slice_data_rd };
	S_pla2_slice_data_rd_buf <= {S_pla2_slice_data_rd_buf[2:0],I_pla2_slice_data_rd };
	S_cnt_clear_buf			 <= {S_cnt_clear_buf[2:0],I_cnt_clear}; 
end

//==== pla0 group
always @ (posedge I_pla_312m5_clk)
begin
	if(S_cnt_clear_buf[1])
	begin
		O_pla0_slice_ok_cnt <= 16'h0	; 
	end
	else if( S_pla0_slice_check_ok_buf[4] )
	begin
		O_pla0_slice_ok_cnt <= O_pla0_slice_ok_cnt + 16'h1	; 
	end
	else
	begin
		O_pla0_slice_ok_cnt <= O_pla0_slice_ok_cnt			; 
	end
end
always @ (posedge I_pla_312m5_clk)
begin
	if(S_cnt_clear_buf[1])
	begin
		O_pla0_slice_wr_cnt <= 16'h0	; 
	end
	else if(O_pla0_slice_wr_resp)
	begin
		O_pla0_slice_wr_cnt	<= O_pla0_slice_wr_cnt + 16'h1	;	
	end
	else
	begin
		O_pla0_slice_wr_cnt	<= O_pla0_slice_wr_cnt			; 
	end
end
always @ (posedge I_pla_312m5_clk)
begin
	if(S_cnt_clear_buf[1])
	begin
		O_pla0_slice_rd_cnt <= 16'h0	; 
	end
	else if(S_pla0_slice_data_rd_buf[2:1] == 2'b01)
	begin
		O_pla0_slice_rd_cnt	<= O_pla0_slice_rd_cnt + 16'h1	;	
	end
	else
	begin
		O_pla0_slice_rd_cnt	<= O_pla0_slice_rd_cnt			; 
	end
end

//==== pla1 group
always @ (posedge I_pla_312m5_clk)
begin
	if(S_cnt_clear_buf[2])
	begin
		O_pla1_slice_ok_cnt <= 16'h0	; 
	end
	else if( S_pla1_slice_check_ok_buf[4] )
	begin
		O_pla1_slice_ok_cnt <= O_pla1_slice_ok_cnt + 16'h1	; 
	end
	else
	begin
		O_pla1_slice_ok_cnt <= O_pla1_slice_ok_cnt			; 
	end
end
always @ (posedge I_pla_312m5_clk)
begin
	if(S_cnt_clear_buf[2])
	begin
		O_pla1_slice_wr_cnt <= 16'h0	; 
	end
	else if(O_pla1_slice_wr_resp)
	begin
		O_pla1_slice_wr_cnt	<= O_pla1_slice_wr_cnt + 16'h1	;	
	end
	else
	begin
		O_pla1_slice_wr_cnt	<= O_pla1_slice_wr_cnt			; 
	end
end
always @ (posedge I_pla_312m5_clk)
begin
	if(S_cnt_clear_buf[2])
	begin
		O_pla1_slice_rd_cnt <= 16'h0	; 
	end
	else if(S_pla1_slice_data_rd_buf[2:1] == 2'b01)
	begin
		O_pla1_slice_rd_cnt	<= O_pla1_slice_rd_cnt + 16'h1	;	
	end
	else
	begin
		O_pla1_slice_rd_cnt	<= O_pla1_slice_rd_cnt			; 
	end
end
//==== pla2 group
always @ (posedge I_pla_312m5_clk)
begin
	if(S_cnt_clear_buf[3])
	begin
		O_pla2_slice_ok_cnt <= 16'h0	; 
	end
	else if( S_pla2_slice_check_ok_buf[4] )
	begin
		O_pla2_slice_ok_cnt <= O_pla2_slice_ok_cnt + 16'h1	; 
	end
	else
	begin
		O_pla2_slice_ok_cnt <= O_pla2_slice_ok_cnt			; 
	end
end
always @ (posedge I_pla_312m5_clk)
begin
	if(S_cnt_clear_buf[3])
	begin
		O_pla2_slice_wr_cnt <= 16'h0	; 
	end
	else if(O_pla2_slice_wr_resp)
	begin
		O_pla2_slice_wr_cnt	<= O_pla2_slice_wr_cnt + 16'h1	;	
	end
	else
	begin
		O_pla2_slice_wr_cnt	<= O_pla2_slice_wr_cnt			; 
	end
end
always @ (posedge I_pla_312m5_clk)
begin
	if(S_cnt_clear_buf[3])
	begin
		O_pla2_slice_rd_cnt <= 16'h0	; 
	end
	else if(S_pla2_slice_data_rd_buf[2:1] == 2'b01)
	begin
		O_pla2_slice_rd_cnt	<= O_pla2_slice_rd_cnt + 16'h1	;	
	end
	else
	begin
		O_pla2_slice_rd_cnt	<= O_pla2_slice_rd_cnt			; 
	end
end



endmodule
