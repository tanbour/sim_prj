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
//x                                |--U01_pla_back_slice_ctrl   
//x                                |--U02_pla_back_slice_ctrl     
//x pla3_backward_slice_cycle_ddr--|--inst_example_top     DDR
//----------------------------------------------------------------------------
//----------------------------------------------------------------------------
//Version         Date           Author        Description
// 1.1          nov-4-2015      Li Shuai        pla_schedule
// 1.2
//----------------------------------------------------------------------------


module pla_backward_slice_cycle_ddr(
output  reg         O_ddr_rdy	 = 1'b0			,
output  reg         O_ddr1_rdy	 = 1'b0			,
output  reg			O_312m5_clk_rst	 = 1'b0		,	
//==============================================
input               I_pla_312m5_clk				,
//input               I_pla_rst					,
input               I_pla_ddr_rst				,
input     [1:0]     I_xgmii_pla_num				,///
input     [14:0]    I_pla_slice_id				,
input     [31:0]    I_pla_slice_payload			,
input               I_pla_slice_payload_en		,

output              O_pla0_slice_wr_resp		,
output    [14:0]    O_pla0_slice_num_id			,
input               I_pla0_slice_check_ok		,///pulse
input     [14:0]    I_pla0_slice_rd_id			,
input               I_pla0_slice_rd_req			,
output              O_pla0_slice_rd_resp		,
input               I_pla0_slice_data_rd		,
output    [31:0]    O_pla0_slice_rdata			,

output              O_pla1_slice_wr_resp		,
output    [14:0]    O_pla1_slice_num_id			,
input               I_pla1_slice_check_ok		,///pulse
input     [14:0]    I_pla1_slice_rd_id			,
input               I_pla1_slice_rd_req			,
output              O_pla1_slice_rd_resp		,
input               I_pla1_slice_data_rd		,
output    [31:0]    O_pla1_slice_rdata			,

output              O_pla2_slice_wr_resp		,
output    [14:0]    O_pla2_slice_num_id			,
input               I_pla2_slice_check_ok		,///pulse
input     [14:0]    I_pla2_slice_rd_id			,
input               I_pla2_slice_rd_req			,
output              O_pla2_slice_rd_resp		,
input               I_pla2_slice_data_rd		,
output    [31:0]    O_pla2_slice_rdata			,
input               I_cnt_clear					,
input		[  5:0]	I_slice_rd_en_valid_cnt_fix	, 
///ddr monitor
//input				I_pla_slice_crc_err_clr		, 
output    [15:0]    O_pla0_slice_ok_cnt			,
output    [15:0]    O_pla0_slice_wr_cnt			,
output    [15:0]    O_pla0_slice_rd_cnt			,
output	  [15:0]	O_pla0_slice_crc_err_cnt	,

output    [15:0]    O_pla1_slice_ok_cnt			,
output    [15:0]    O_pla1_slice_wr_cnt			,
output    [15:0]    O_pla1_slice_rd_cnt			,
output	  [15:0]	O_pla1_slice_crc_err_cnt	,

output    [15:0]    O_pla2_slice_ok_cnt			,
output    [15:0]    O_pla2_slice_wr_cnt			,
output    [15:0]    O_pla2_slice_rd_cnt			,
output	  [15:0]	O_pla2_slice_crc_err_cnt	,

output	  [15:0]	O_ddr3a_app_wdf_rdy_low_cnt_max	,	
output	  [15:0]	O_ddr3a_wr_app_rdy_low_cnt_max	,	
output	  [15:0]	O_ddr3a_rd_app_rdy_low_cnt_max	,	
output	  [15:0]	O_ddr3a_app_write_err_cnt		,	
output	  [15:0]	O_ddr3a_buf_full_cnt			,
output	  [15:0]	O_ddr3b_app_wdf_rdy_low_cnt_max	,	
output	  [15:0]	O_ddr3b_wr_app_rdy_low_cnt_max	,	
output	  [15:0]	O_ddr3b_rd_app_rdy_low_cnt_max	,	
output	  [15:0]	O_ddr3b_app_write_err_cnt		,	
output	  [15:0]	O_ddr3b_buf_full_cnt			,



///ddr outer sig,dont change pin name at first
// Inouts
inout [15:0]        c0_ddr3_dq					,
inout [1:0]         c0_ddr3_dqs_n				,
inout [1:0]         c0_ddr3_dqs_p				,
// Outputs
output [13:0]       c0_ddr3_addr				,
output [2:0]        c0_ddr3_ba					,
output              c0_ddr3_ras_n				,
output              c0_ddr3_cas_n				,
output              c0_ddr3_we_n				,
output              c0_ddr3_reset_n				,
output [0:0]        c0_ddr3_ck_p				,
output [0:0]        c0_ddr3_ck_n				,
output [0:0]        c0_ddr3_cke					,
output [0:0]        c0_ddr3_odt					,
// Inputs
// Single-ended system clock
input              c0_sys_clk_i					,
// Single-ended iodelayctrl clk (reference clock)
input              clk_ref_i					,
output             tg_compare_error				,
output             init_calib_complete			,
// Inouts
inout [15:0]       c1_ddr3_dq					,
inout [1:0]        c1_ddr3_dqs_n				,
inout [1:0]        c1_ddr3_dqs_p				,
// Outputs
output [13:0]      c1_ddr3_addr					,
output [2:0]       c1_ddr3_ba					,
output             c1_ddr3_ras_n				,
output             c1_ddr3_cas_n				,
output             c1_ddr3_we_n					,
output             c1_ddr3_reset_n				,
output [0:0]       c1_ddr3_ck_p					,
output [0:0]       c1_ddr3_ck_n					,
output [0:0]       c1_ddr3_cke					,
output [0:0]       c1_ddr3_odt					,
output             O_c0_app_rdy					,
input              c1_sys_clk_i					
);


reg     [  3:0] R_ddr0_rdy_cnt		= 4'd0		;
reg     [  3:0] R_ddr1_rdy_cnt		= 4'd0		;
reg		[  3:0] R_ddr0_rdy_buf		= 4'd0		;
reg		[  3:0] R_ddr1_rdy_buf		= 4'd0		;
reg		[  3:0]	S_312m5_ddr_rdy_buf	= 4'd0		;
reg		[  3:0]	S_312m5_clk_rst_buf	= 4'd0		;
reg				R_ddr0_rst			= 1'b0		;
reg				R_ddr1_rst			= 1'b0		;

wire			c0_clk							;
wire			c0_clk_rst						;
wire	[  2:0]	c0_app_cmd						;///input
wire 			c0_app_en						;///input
wire			c0_app_rdy						;///output
wire	[ 27:0]	c0_app_addr						;///input
wire 			c0_app_wdf_wren					;///input
wire 			c0_app_wdf_end					;///input
wire			c0_app_wdf_rdy					;///output
wire	[127:0]	c0_app_wdf_data					;///input
wire	[127:0]	c0_app_rd_data					;///output 
wire			c0_app_rd_data_valid			;///output
wire			c0_app_rd_data_end				;///output
wire			c1_clk							;
wire			c1_clk_rst						;
wire	[  2:0]	c1_app_cmd						;///input
wire 			c1_app_en						;///input
wire			c1_app_rdy						;///output
wire	[ 27:0]	c1_app_addr						;///input
wire 			c1_app_wdf_wren					;///input
wire 			c1_app_wdf_end					;///input
wire			c1_app_wdf_rdy					;///output
wire	[127:0]	c1_app_wdf_data					;///input
wire	[127:0]	c1_app_rd_data					;///output 
wire			c1_app_rd_data_valid			;///output
wire			c1_app_rd_data_end				;///output
//wire	[  8:0]	S_ddr3a_wrbuf2_usedw			;
wire	[143:0]	S_ddr3a_wrbuf2_fifo_wdata		;
wire			S_ddr3a_wrbuf2_fifo_wren		;
wire	[  1:0]	S_ddr3a_pla_xgmii_num			;	
wire	[ 14:0]	S_ddr3a_slice_rd_id				;
wire			S_ddr3a_slice_rd_req			;
wire			S_ddr3a_slice_rd_resp			;
wire			S_ddr3a_slice_rd_en				;
wire	[ 31:0]	S_ddr3a_slice_rdata				;
//wire	[  8:0]	S_ddr3b_wrbuf2_usedw			;
wire	[143:0]	S_ddr3b_wrbuf2_fifo_wdata		;
wire			S_ddr3b_wrbuf2_fifo_wren		;
wire	[  1:0]	S_ddr3b_pla_xgmii_num			;	
wire	[ 14:0]	S_ddr3b_slice_rd_id				;
wire			S_ddr3b_slice_rd_req			;
wire			S_ddr3b_slice_rd_resp			;
wire			S_ddr3b_slice_rd_en				;
wire	[ 31:0]	S_ddr3b_slice_rdata				;




/////---------------------------------------------------------
///// debug	begin
/////---------------------------------------------------------

/////---------------------------------------------------------
///// debug end	
/////---------------------------------------------------------






//======DDR�ϵ��ʼ�����==============================================  
assign   O_c0_app_rdy = c0_app_rdy;
//==== O_ddr_rdy process
always @ (posedge c0_clk) 
begin
	if(c0_clk_rst) 
    begin
		R_ddr0_rdy_cnt  <= 4'd0					;
    end
    else if(R_ddr0_rdy_cnt== 4'hf)
    begin
		R_ddr0_rdy_cnt  <= R_ddr0_rdy_cnt		;
    end
    else if(c0_app_rdy && init_calib_complete)
    begin
		R_ddr0_rdy_cnt  <= R_ddr0_rdy_cnt + 4'h1;
    end
    else  
    begin
		R_ddr0_rdy_cnt  <= R_ddr0_rdy_cnt		;
    end
end

always @ (posedge c0_clk) 
begin
	R_ddr0_rdy_buf	<= {R_ddr0_rdy_buf[2:0],(&R_ddr0_rdy_cnt)}	;
	R_ddr0_rst		<=	~R_ddr0_rdy_buf[1]						; 
end


always @ (posedge I_pla_312m5_clk) 
begin
	O_ddr_rdy <= |R_ddr0_rdy_buf[3:2]	; 
end



//==== O_ddr1_rdy process


always @ (posedge c1_clk) 
begin
	if(c1_clk_rst) 
    begin
		R_ddr1_rdy_cnt  <= 4'd0					;
    end
    else if(R_ddr1_rdy_cnt== 4'hf)
    begin
		R_ddr1_rdy_cnt  <= R_ddr1_rdy_cnt		;
    end
    else if(c1_app_rdy && init_calib_complete)
    begin
		R_ddr1_rdy_cnt  <= R_ddr1_rdy_cnt + 4'h1;
    end
    else  
    begin
		R_ddr1_rdy_cnt  <= R_ddr1_rdy_cnt		;
    end
end


always @ (posedge c1_clk) 
begin
	R_ddr1_rdy_buf	<= {R_ddr1_rdy_buf[2:0],(&R_ddr1_rdy_cnt)}	;
	R_ddr1_rst		<=	~R_ddr1_rdy_buf[1]						; 
end

always @ (posedge I_pla_312m5_clk) 
begin
	O_ddr1_rdy <= |R_ddr1_rdy_buf[3:2]; 
end

always @(posedge I_pla_312m5_clk )
begin
	S_312m5_ddr_rdy_buf	<= {S_312m5_ddr_rdy_buf[2:0],(R_ddr0_rdy_buf[3]&&R_ddr1_rdy_buf[3])}; 
	S_312m5_clk_rst_buf	<= {S_312m5_clk_rst_buf[2:0],~S_312m5_ddr_rdy_buf[3]};/// not ready , must be reset assert
	O_312m5_clk_rst		<= S_312m5_clk_rst_buf[2]		;
end



      
mig_double_ddr3_wrapper U_mig_double_ddr3_wrapper 
  (
  //only for test inter
	.c0_clk					(c0_clk					),
	.c0_clk_rst				(c0_clk_rst				),
	.c0_app_cmd				(c0_app_cmd				),///input
	.c0_app_en				(c0_app_en				),///input
	.c0_app_rdy				(c0_app_rdy				),///output
	.c0_app_addr			(c0_app_addr			),///input
	.c0_app_wdf_wren		(c0_app_wdf_wren		),///input
	.c0_app_wdf_end			(c0_app_wdf_end			),///input
	.c0_app_wdf_rdy			(c0_app_wdf_rdy			),///output
	.c0_app_wdf_data		(c0_app_wdf_data		),///input
	.c0_app_rd_data			(c0_app_rd_data			),///output 
	.c0_app_rd_data_valid	(c0_app_rd_data_valid	),///output
	.c0_app_rd_data_end		(c0_app_rd_data_end		),///output
	.c1_clk					(c1_clk					),
	.c1_clk_rst				(c1_clk_rst				),
	.c1_app_cmd				(c1_app_cmd				),///input
	.c1_app_en				(c1_app_en				),///input
	.c1_app_rdy				(c1_app_rdy				),///output
	.c1_app_addr			(c1_app_addr			),///input
	.c1_app_wdf_wren		(c1_app_wdf_wren		),///input
	.c1_app_wdf_end			(c1_app_wdf_end			),///input
	.c1_app_wdf_rdy			(c1_app_wdf_rdy			),///output
	.c1_app_wdf_data		(c1_app_wdf_data		),///input
	.c1_app_rd_data			(c1_app_rd_data			),///output 
	.c1_app_rd_data_valid	(c1_app_rd_data_valid	),///output
	.c1_app_rd_data_end		(c1_app_rd_data_end		),///output
   ///outer sig
	.c0_ddr3_dq				(c0_ddr3_dq				),
	.c0_ddr3_dqs_n          (c0_ddr3_dqs_n			),
	.c0_ddr3_dqs_p          (c0_ddr3_dqs_p			),
	.c0_ddr3_addr           (c0_ddr3_addr			),
	.c0_ddr3_ba             (c0_ddr3_ba				),
	.c0_ddr3_ras_n          (c0_ddr3_ras_n			),
	.c0_ddr3_cas_n          (c0_ddr3_cas_n			),
	.c0_ddr3_we_n           (c0_ddr3_we_n			),
	.c0_ddr3_reset_n        (c0_ddr3_reset_n		),
	.c0_ddr3_ck_p           (c0_ddr3_ck_p			),
	.c0_ddr3_ck_n           (c0_ddr3_ck_n			),
	.c0_ddr3_cke            (c0_ddr3_cke			),
	.c0_ddr3_odt            (c0_ddr3_odt			),
	.c0_sys_clk_i           (c0_sys_clk_i			),
	.clk_ref_i              (clk_ref_i				),
	.c1_ddr3_dq             (c1_ddr3_dq				),
	.c1_ddr3_dqs_n          (c1_ddr3_dqs_n			),
	.c1_ddr3_dqs_p          (c1_ddr3_dqs_p			),
	.c1_ddr3_addr           (c1_ddr3_addr			),
	.c1_ddr3_ba             (c1_ddr3_ba				),
	.c1_ddr3_ras_n          (c1_ddr3_ras_n			),
	.c1_ddr3_cas_n          (c1_ddr3_cas_n			),
	.c1_ddr3_we_n           (c1_ddr3_we_n			),
	.c1_ddr3_reset_n        (c1_ddr3_reset_n		),
	.c1_ddr3_ck_p           (c1_ddr3_ck_p			),
	.c1_ddr3_ck_n           (c1_ddr3_ck_n			),
	.c1_ddr3_cke            (c1_ddr3_cke			),
	.c1_ddr3_odt            (c1_ddr3_odt			),
	.c1_sys_clk_i           (c1_sys_clk_i			),
	.init_calib_complete    (init_calib_complete	),///both c0 & c1
	.tg_compare_error       (tg_compare_error		),//null
	.sys_rst                (I_pla_ddr_rst			)
);      





///DDR,��ݷ�Ƭ
pla_backward_slice_schedule U0_pla_backward_slice_schedule(
.I_pla_312m5_clk			(I_pla_312m5_clk				),
//.I_pla_rst					(I_pla_rst						),
.I_pla_rst					(S_312m5_clk_rst_buf[1]			),
//.I_pla_ddr_rst				(I_pla_ddr_rst					),
//.I_ddr_rdy					(O_ddr_rdy						),

.I_pla_xgmii_num			(I_xgmii_pla_num				),///
.I_pla_slice_id				(I_pla_slice_id					),
.I_pla_slice_payload		(I_pla_slice_payload			),
.I_pla_slice_payload_en		(I_pla_slice_payload_en			),
//.I_ddr3a_wrbuf2_usedw		(S_ddr3a_wrbuf2_usedw			),	
.O_ddr3a_wrbuf2_fifo_wdata	(S_ddr3a_wrbuf2_fifo_wdata		),	
.O_ddr3a_wrbuf2_fifo_wren	(S_ddr3a_wrbuf2_fifo_wren		),
.O_ddr3a_slice_rd_req		(S_ddr3a_slice_rd_req			),
.I_ddr3a_slice_rd_resp		(S_ddr3a_slice_rd_resp			),
.O_ddr3a_pla_xgmii_num		(S_ddr3a_pla_xgmii_num			),///
.O_ddr3a_slice_rd_id		(S_ddr3a_slice_rd_id			),
.O_ddr3a_slice_rd_en		(S_ddr3a_slice_rd_en			),
.O_ddr3a_slice_rdata		(S_ddr3a_slice_rdata			),
//.I_ddr3b_wrbuf2_usedw		(S_ddr3b_wrbuf2_usedw			),	
.O_ddr3b_wrbuf2_fifo_wdata	(S_ddr3b_wrbuf2_fifo_wdata		),	
.O_ddr3b_wrbuf2_fifo_wren	(S_ddr3b_wrbuf2_fifo_wren		),
.O_ddr3b_slice_rd_req		(S_ddr3b_slice_rd_req			),
.I_ddr3b_slice_rd_resp		(S_ddr3b_slice_rd_resp			),
.O_ddr3b_pla_xgmii_num		(S_ddr3b_pla_xgmii_num			),///
.O_ddr3b_slice_rd_id		(S_ddr3b_slice_rd_id			),
.O_ddr3b_slice_rd_en		(S_ddr3b_slice_rd_en			),
.O_ddr3b_slice_rdata		(S_ddr3b_slice_rdata			),
.O_pla0_slice_wr_resp		(O_pla0_slice_wr_resp			),
.O_pla0_slice_num_id		(O_pla0_slice_num_id			),
.I_pla0_slice_check_ok		(I_pla0_slice_check_ok			),///pulse
.I_pla0_slice_rd_id			(I_pla0_slice_rd_id				),
.I_pla0_slice_rd_req		(I_pla0_slice_rd_req			),
.O_pla0_slice_rd_resp		(O_pla0_slice_rd_resp			),
.I_pla0_slice_data_rd		(I_pla0_slice_data_rd			),
.O_pla0_slice_rdata			(O_pla0_slice_rdata				),
.O_pla1_slice_wr_resp		(O_pla1_slice_wr_resp		    ),
.O_pla1_slice_num_id		(O_pla1_slice_num_id		    ),
.I_pla1_slice_check_ok		(I_pla1_slice_check_ok		    ),///pulse
.I_pla1_slice_rd_id			(I_pla1_slice_rd_id			    ),
.I_pla1_slice_rd_req		(I_pla1_slice_rd_req		    ),
.O_pla1_slice_rd_resp		(O_pla1_slice_rd_resp		    ),
.I_pla1_slice_data_rd		(I_pla1_slice_data_rd		    ),
.O_pla1_slice_rdata			(O_pla1_slice_rdata			    ),
.O_pla2_slice_wr_resp		(O_pla2_slice_wr_resp		    ),
.O_pla2_slice_num_id		(O_pla2_slice_num_id		    ),
.I_pla2_slice_check_ok		(I_pla2_slice_check_ok		    ),///pulse
.I_pla2_slice_rd_id			(I_pla2_slice_rd_id			    ),
.I_pla2_slice_rd_req		(I_pla2_slice_rd_req		    ),
.O_pla2_slice_rd_resp		(O_pla2_slice_rd_resp		    ),	
.I_pla2_slice_data_rd		(I_pla2_slice_data_rd		    ),
.O_pla2_slice_rdata			(O_pla2_slice_rdata			    ),	
.I_cnt_clear				(I_cnt_clear					),
.I_slice_rd_en_valid_cnt_fix(I_slice_rd_en_valid_cnt_fix	), 
.O_pla0_slice_ok_cnt		(O_pla0_slice_ok_cnt			),
.O_pla0_slice_wr_cnt		(O_pla0_slice_wr_cnt			),
.O_pla0_slice_rd_cnt		(O_pla0_slice_rd_cnt			),
.O_pla1_slice_ok_cnt		(O_pla1_slice_ok_cnt			),
.O_pla1_slice_wr_cnt		(O_pla1_slice_wr_cnt			),
.O_pla1_slice_rd_cnt		(O_pla1_slice_rd_cnt			),
.O_pla2_slice_ok_cnt		(O_pla2_slice_ok_cnt			),
.O_pla2_slice_wr_cnt		(O_pla2_slice_wr_cnt			),
.O_pla2_slice_rd_cnt		(O_pla2_slice_rd_cnt			)
);




pla_backward_slice_ctrl  U01_pla_back_slice_ctrl(
.I_pla_312m5_clk            (I_pla_312m5_clk					),
//.I_pla_rst                  (I_pla_rst							),
.I_pla_rst					(S_312m5_clk_rst_buf[1]			),
//.O_ddr3_wrbuf2_usedw		(S_ddr3a_wrbuf2_usedw				),	
.I_wrbuf2_fifo_wdata		(S_ddr3a_wrbuf2_fifo_wdata			),	
.I_wrbuf2_fifo_wren			(S_ddr3a_wrbuf2_fifo_wren			),
.I_pla_slice_rd_req			(S_ddr3a_slice_rd_req				),
.O_pla_slice_rd_resp		(S_ddr3a_slice_rd_resp				),
.I_pla_xgmii_num			(S_ddr3a_pla_xgmii_num				),///
.I_pla_slice_rd_id			(S_ddr3a_slice_rd_id				),
.I_pla_slice_rd_en			(S_ddr3a_slice_rd_en				),
.O_pla_slice_rdata			(S_ddr3a_slice_rdata				),
//====maintenance begin
.I_cnt_clear				(I_cnt_clear						),
.O_app_wdf_rdy_low_cnt_max	(O_ddr3a_app_wdf_rdy_low_cnt_max	),	
.O_wr_app_rdy_low_cnt_max	(O_ddr3a_wr_app_rdy_low_cnt_max		),	
.O_rd_app_rdy_low_cnt_max	(O_ddr3a_rd_app_rdy_low_cnt_max		),	
.O_app_write_err_cnt		(O_ddr3a_app_write_err_cnt			),	
.O_ddr3_buf_full_cnt		(O_ddr3a_buf_full_cnt				),	
//====maintenance end 
.I_ddr_clk					(c0_clk								),
.I_ddr_rst					(R_ddr0_rst							),
//.I_ddr_rst					(c0_clk_rst							),
.I_app_rdy					(c0_app_rdy							),///output
.O_app_cmd					(c0_app_cmd							),///input
.O_app_en					(c0_app_en							),///input
.O_app_addr					(c0_app_addr						),///input
.I_app_wdf_rdy				(c0_app_wdf_rdy						),///output
.O_app_wdf_wren				(c0_app_wdf_wren					),///input
.O_app_wdf_end				(c0_app_wdf_end						),///input
.O_app_wdf_data				(c0_app_wdf_data					),///input
.I_app_rd_data				(c0_app_rd_data						),///output 
.I_app_rd_data_valid		(c0_app_rd_data_valid				),///output
.I_app_rd_data_end			(c0_app_rd_data_end					) ///output
);


pla_backward_slice_ctrl  U02_pla_back_slice_ctrl(
.I_pla_312m5_clk            (I_pla_312m5_clk					),
//.I_pla_rst                  (I_pla_rst							),
.I_pla_rst					(S_312m5_clk_rst_buf[1]			),
//.O_ddr3_wrbuf2_usedw		(S_ddr3b_wrbuf2_usedw				),	
.I_wrbuf2_fifo_wdata		(S_ddr3b_wrbuf2_fifo_wdata			),	
.I_wrbuf2_fifo_wren			(S_ddr3b_wrbuf2_fifo_wren			),
.I_pla_slice_rd_req			(S_ddr3b_slice_rd_req				),
.O_pla_slice_rd_resp		(S_ddr3b_slice_rd_resp				),
.I_pla_xgmii_num			(S_ddr3b_pla_xgmii_num				),///
.I_pla_slice_rd_id			(S_ddr3b_slice_rd_id				),
.I_pla_slice_rd_en			(S_ddr3b_slice_rd_en				),
.O_pla_slice_rdata			(S_ddr3b_slice_rdata				),
//====maintenance begin
.I_cnt_clear				(I_cnt_clear						),
.O_app_wdf_rdy_low_cnt_max	(O_ddr3b_app_wdf_rdy_low_cnt_max	),	
.O_wr_app_rdy_low_cnt_max	(O_ddr3b_wr_app_rdy_low_cnt_max		),	
.O_rd_app_rdy_low_cnt_max	(O_ddr3b_rd_app_rdy_low_cnt_max		),	
.O_app_write_err_cnt		(O_ddr3b_app_write_err_cnt			),	
.O_ddr3_buf_full_cnt		(O_ddr3b_buf_full_cnt				),	
//====maintenance end 
.I_ddr_clk					(c1_clk								),
.I_ddr_rst					(R_ddr1_rst							),
//.I_ddr_rst					(c1_clk_rst							),
.I_app_rdy					(c1_app_rdy							),///output
.O_app_cmd					(c1_app_cmd							),///input
.O_app_en					(c1_app_en							),///input
.O_app_addr					(c1_app_addr						),///input
.I_app_wdf_rdy				(c1_app_wdf_rdy						),///output
.O_app_wdf_wren				(c1_app_wdf_wren					),///input
.O_app_wdf_end				(c1_app_wdf_end						),///input
.O_app_wdf_data				(c1_app_wdf_data					),///input
.I_app_rd_data				(c1_app_rd_data						),///output 
.I_app_rd_data_valid		(c1_app_rd_data_valid				),///output
.I_app_rd_data_end			(c1_app_rd_data_end					) ///output
);




//================Maintenance
pla_backward_slice_crc_check U0_pla_backward_slice_crc_check(
.I_pla_312m5_clk			(I_pla_312m5_clk			),
//.I_pla_rst					(I_pla_rst					),
.I_pla_rst					(S_312m5_clk_rst_buf[1]		),
.I_pla_xgmii_num			(I_xgmii_pla_num			),///
.I_pla_slice_id				(I_pla_slice_id				),
.I_pla_slice_payload		(I_pla_slice_payload		),
.I_pla_slice_payload_en		(I_pla_slice_payload_en		),
.I_pla_slice_check_ok		(I_pla0_slice_check_ok		),///pulse
.I_pla_slice_rd_resp		(O_pla0_slice_rd_resp		),
.I_pla_rd_xgmii_num			(2'b00						),
.I_pla_slice_rd_id			(I_pla0_slice_rd_id			),
.I_pla_slice_data_rd		(I_pla0_slice_data_rd		),
.I_pla_slice_rdata			(O_pla0_slice_rdata			),
.I_pla_slice_crc_err_clr	(I_cnt_clear				),
.O_pla_slice_crc_err_cnt	(O_pla0_slice_crc_err_cnt	)	
);

pla_backward_slice_crc_check U1_pla_backward_slice_crc_check(
.I_pla_312m5_clk			(I_pla_312m5_clk			),
//.I_pla_rst					(I_pla_rst					),
.I_pla_rst					(S_312m5_clk_rst_buf[1]		),
.I_pla_xgmii_num			(I_xgmii_pla_num			),///
.I_pla_slice_id				(I_pla_slice_id				),
.I_pla_slice_payload		(I_pla_slice_payload		),
.I_pla_slice_payload_en		(I_pla_slice_payload_en		),
.I_pla_slice_check_ok		(I_pla1_slice_check_ok		),///pulse
.I_pla_slice_rd_resp		(O_pla1_slice_rd_resp		),
.I_pla_rd_xgmii_num			(2'b01						),
.I_pla_slice_rd_id			(I_pla1_slice_rd_id			),
.I_pla_slice_data_rd		(I_pla1_slice_data_rd		),
.I_pla_slice_rdata			(O_pla1_slice_rdata			),
.I_pla_slice_crc_err_clr	(I_cnt_clear				),
.O_pla_slice_crc_err_cnt	(O_pla1_slice_crc_err_cnt	)	
);

pla_backward_slice_crc_check U2_pla_backward_slice_crc_check(
.I_pla_312m5_clk			(I_pla_312m5_clk			),
//.I_pla_rst					(I_pla_rst					),
.I_pla_rst					(S_312m5_clk_rst_buf[1]		),
.I_pla_xgmii_num			(I_xgmii_pla_num			),///
.I_pla_slice_id				(I_pla_slice_id				),
.I_pla_slice_payload		(I_pla_slice_payload		),
.I_pla_slice_payload_en		(I_pla_slice_payload_en		),
.I_pla_slice_check_ok		(I_pla2_slice_check_ok		),///pulse
.I_pla_slice_rd_resp		(O_pla2_slice_rd_resp		),
.I_pla_rd_xgmii_num			(2'b10						),
.I_pla_slice_rd_id			(I_pla2_slice_rd_id			),
.I_pla_slice_data_rd		(I_pla2_slice_data_rd		),
.I_pla_slice_rdata			(O_pla2_slice_rdata			),
.I_pla_slice_crc_err_clr	(I_cnt_clear				),
.O_pla_slice_crc_err_cnt	(O_pla2_slice_crc_err_cnt	)	
);


endmodule
