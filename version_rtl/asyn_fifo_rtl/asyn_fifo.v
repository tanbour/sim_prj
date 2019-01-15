//--------------------------------------------------------------------------------------------------
//File Name    : asyn_fifo 
//Author       : asyn_fifo 
//--------------------------------------------------------------------------------------------------
//Module Hierarchy :
//asyn_fifo_inst |-asyn_fifo
//--------------------------------------------------------------------------------------------------
//Release History :
//Version         Date           Author        Description
// 1.0          2019-01-01       asyn_fifo		1st draft
//--------------------------------------------------------------------------------------------------
//Main Function Tree:
//a)asyn_fifo: 
//Description Function:
//asyn_fifo
//--------------------------------------------------------------------------------------------------
module asyn_fifo #(
		paramster DSIZE = 8,
		paramster ASIZE = 4 )(
input				wrst	,
input				wclk	,
input				winc	,
input	[DSIZE-1:0] wdata	,
input				rrst	,
input				rclk	,
input				rinc	,
output [DSIZE-1:0] 	rdata	,
output				rempty	,
output				wfull	
);

////////////////////////////////////////////////////////////////////////////////////////////////////
// Naming specification																			  // 
// (1) w+"xxx" name type , means write clock domain												  // 
//		such as wrst,wclk,winc,wdata, wptr, waddr,wfull, and so on								  //	
// (2) r+"xxx" name type , means read clock domain												  // 
//		such as rrst,rclk,rinc,rdata, rptr, raddr,rempty, and so on								  //	
// (3) w+q2+"xxx" name type , w means write clock domain, q2 means delay 2 clocks 				  //
//		such as wq2_rptr																		  //
// (4) r+q2+"xxx" name type , r means read clock domain, q2 means delay 2 clocks 				  //
//		such as rq2_wptr																		  //
////////////////////////////////////////////////////////////////////////////////////////////////////

wire	[ASIZE-1:0]	waddr		;
wire	[ASIZE  :0]	wptr		;
wire	[ASIZE  :0]	wq2_rptr	;
wire	[ASIZE-1:0]	raddr		;
wire	[ASIZE  :0]	rptr		;
wire	[ASIZE  :0]	rq2_wptr	;

////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                //
//    __    __    __    __    __    __    __    __    __    __    __    __    __    __    __    __//
// __|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  |/
//                                                                                                //
//                                                                                                //
////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////
//		sync_r2w																				  //	
////////////////////////////////////////////////////////////////////////////////////////////////////
sync_clka2clkb  u0_sync_r2w (
	.rst	 (wrst		),
	.clk	 (wclk		),
	.ptr	 (rptr		),
	.q2_ptr	 (wq2_rptr	)
);
////////////////////////////////////////////////////////////////////////////////////////////////////
//		sync_r2w																				  //	
////////////////////////////////////////////////////////////////////////////////////////////////////
sync_clka2clkb  u0_sync_w2r (
	.rst	 (rrst		),
	.clk	 (rclk		),
	.ptr	 (wptr		),
	.q2_ptr	 (rq2_wptr	)
);

endmodule


