//*****************************************************************************
// (c) Copyright 2009 - 2013 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSEg; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//
//*****************************************************************************
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor             : Xilinx
// \   \   \/     Version            : 2.1
//  \   \         Application        : MIG
//  /   /         Filename           : example_top.v
// /___/   /\     Date Last Modified : $Date: 2011/06/02 08:35:03 $
// \   \  /  \    Date Created       : Tue Sept 21 2010
//  \___\/\___\
//
// Device           : 7 Series
// Design Name      : DDR3 SDRAM
// Purpose          :
//   Top-level  module. This module serves as an example,
//   and allows the user to synthesize a self-contained design,
//   which they can be used to test their hardware.
//   In addition to the memory controller, the module instantiates:
//     1. Synthesizable testbench - used to model user's backend logic
//        and generate different traffic patterns
// Reference        :
// Revision History :
//*****************************************************************************

`timescale 1ps/1ps
/// by cqiu 2015.06.07
module mig_double_ddr3_wrapper (
// Start of User Design top instance
// user interface signals
output			c0_clk					,
output			c0_clk_rst				,
input	[  2:0]	c0_app_cmd				,///input
input  			c0_app_en				,///input
output  		c0_app_rdy				,///output
input	[ 27:0]	c0_app_addr				,///input
input  			c0_app_wdf_wren			,///input
input  			c0_app_wdf_end			,///input
output  		c0_app_wdf_rdy			,///output
input	[127:0]	c0_app_wdf_data			,///input
output	[127:0]	c0_app_rd_data			,///output 
output  		c0_app_rd_data_valid	,///output
output  		c0_app_rd_data_end		,///output

// user interface signals
output			c1_clk					,
output			c1_clk_rst				,
input	[  2:0]	c1_app_cmd				,///input
input	  		c1_app_en				,///input
output  		c1_app_rdy				,///output
input	[ 27:0]	c1_app_addr				,///input
input			c1_app_wdf_wren			,///input
input	  		c1_app_wdf_end			,///input
output  		c1_app_wdf_rdy			,///output
input	[127:0]	c1_app_wdf_data			,///input
output  		c1_app_rd_data_end		,///output
output  		c1_app_rd_data_valid	,///output
output	[127:0]	c1_app_rd_data			,///output 

// Inouts
inout		[ 15:0] c0_ddr3_dq			,
inout		[  1:0] c0_ddr3_dqs_n		,
inout		[  1:0] c0_ddr3_dqs_p		,
// Outputs
output		[ 13:0] c0_ddr3_addr		,
output		[  2:0] c0_ddr3_ba			,
output              c0_ddr3_ras_n		,
output              c0_ddr3_cas_n		,
output              c0_ddr3_we_n		,
output              c0_ddr3_reset_n		,
output		[  0:0] c0_ddr3_ck_p		,
output		[  0:0] c0_ddr3_ck_n		,
output      [  0:0] c0_ddr3_cke			,
output      [  0:0] c0_ddr3_odt			,
// Inouts
inout		[ 15:0] c1_ddr3_dq			,
inout		[  1:0] c1_ddr3_dqs_n		,
inout		[  1:0] c1_ddr3_dqs_p		,
// Outputs
output		[ 13:0] c1_ddr3_addr		,
output		[  2:0] c1_ddr3_ba			,
output              c1_ddr3_ras_n		,
output              c1_ddr3_cas_n		,
output              c1_ddr3_we_n		,
output              c1_ddr3_reset_n		,
output		[  0:0] c1_ddr3_ck_p		,
output		[  0:0] c1_ddr3_ck_n		,
output      [  0:0] c1_ddr3_cke			,
output      [  0:0] c1_ddr3_odt			,
// Inputs
// Single-ended system clock (250M clock for rcuc board)
input               c0_sys_clk_i		,
// Single-ended system clock
input				c1_sys_clk_i		,
// Single-ended iodelayctrl clk (reference clock 200M clock)
input               clk_ref_i			,
output              tg_compare_error	,
output              init_calib_complete	,
// System reset - Default polarity of sys_rst pin is Active Low.
// System reset polarity will change based on the option 
// selected in GUI.
input				sys_rst				
);
      
      


wire    		c0_app_sr_active		;
wire    		c0_app_ref_ack			;
wire    		c0_app_zq_ack			;
//wire    		c0_ui_clk				;///output
wire			c0_init_calib_complete	;///output

wire    		c1_app_sr_active		;
wire    		c1_app_ref_ack			;
wire    		c1_app_zq_ack			;
//wire    		c1_ui_clk				;///output
wire    		c1_init_calib_complete	;///output

assign init_calib_complete = c0_init_calib_complete && c1_init_calib_complete	;
//assign O_ddr0_app_rdy = c0_app_rdy	;
//assign O_ddr1_app_rdy = c1_app_rdy	;

//***************************************************************************
// The User design is instantiated below. The memory interface ports are
// connected to the top-level and the application interface ports are
// connected to the traffic generator module. This provides af reference
// for connecting the memory controller to system.
//***************************************************************************
  mig_double_ddr3 u_mig_double_ddr3 (
// Memory interface ports
       .c0_ddr3_addr				(c0_ddr3_addr			),
       .c0_ddr3_ba                  (c0_ddr3_ba				),
       .c0_ddr3_cas_n               (c0_ddr3_cas_n			),
       .c0_ddr3_ck_n                (c0_ddr3_ck_n			),
       .c0_ddr3_ck_p                (c0_ddr3_ck_p			),
       .c0_ddr3_cke                 (c0_ddr3_cke			),
       .c0_ddr3_ras_n               (c0_ddr3_ras_n			),
       .c0_ddr3_reset_n             (c0_ddr3_reset_n		),
       .c0_ddr3_we_n                (c0_ddr3_we_n			),
       .c0_ddr3_dq                  (c0_ddr3_dq				),
       .c0_ddr3_dqs_n               (c0_ddr3_dqs_n			),
       .c0_ddr3_dqs_p               (c0_ddr3_dqs_p			),
       .c0_init_calib_complete      (c0_init_calib_complete	), ///only index can send to cpu
 //      .device_temp_i               (12'h0                  ),
       .c0_ddr3_odt                 (c0_ddr3_odt			),
// Application interface ports
       .c0_app_addr                 (c0_app_addr			),
       .c0_app_cmd                  (c0_app_cmd				),
       .c0_app_en                   (c0_app_en				),
       .c0_app_wdf_data             (c0_app_wdf_data		),
       .c0_app_wdf_end              (c0_app_wdf_end			),
       .c0_app_wdf_wren             (c0_app_wdf_wren		),
       .c0_app_rd_data              (c0_app_rd_data			),
       .c0_app_rd_data_end          (c0_app_rd_data_end		),
       .c0_app_rd_data_valid        (c0_app_rd_data_valid	),
       .c0_app_rdy                  (c0_app_rdy				),
       .c0_app_wdf_rdy              (c0_app_wdf_rdy			),
       .c0_app_sr_req               (1'b0					),
       .c0_app_ref_req              (1'b0					),
       .c0_app_zq_req               (1'b0					),
       .c0_app_sr_active            (c0_app_sr_active		),///res
       .c0_app_ref_ack              (c0_app_ref_ack			),///res 
       .c0_app_zq_ack               (c0_app_zq_ack			),///res
       .c0_ui_clk                   (c0_clk					),///fifo ui clock
       .c0_ui_clk_sync_rst          (c0_clk_rst				),
// System Clock Ports
       .c0_sys_clk_i                (c0_sys_clk_i			),
       
// Reference Clock Ports
       .clk_ref_i                   (clk_ref_i				),
// Memory interface ports
       .c1_ddr3_addr                (c1_ddr3_addr			),
       .c1_ddr3_ba                  (c1_ddr3_ba				),
       .c1_ddr3_cas_n               (c1_ddr3_cas_n			),
       .c1_ddr3_ck_n                (c1_ddr3_ck_n			),
       .c1_ddr3_ck_p                (c1_ddr3_ck_p			),
       .c1_ddr3_cke                 (c1_ddr3_cke			),
       .c1_ddr3_ras_n               (c1_ddr3_ras_n			),
       .c1_ddr3_reset_n             (c1_ddr3_reset_n		),
       .c1_ddr3_we_n                (c1_ddr3_we_n			),
       .c1_ddr3_dq                  (c1_ddr3_dq				),
       .c1_ddr3_dqs_n               (c1_ddr3_dqs_n			),
       .c1_ddr3_dqs_p               (c1_ddr3_dqs_p			),
       .c1_init_calib_complete      (c1_init_calib_complete	),
       .c1_ddr3_odt                 (c1_ddr3_odt			),
// Application interface ports
       .c1_app_addr                 (c1_app_addr			),
       .c1_app_cmd                  (c1_app_cmd				),
       .c1_app_en                   (c1_app_en				),
       .c1_app_wdf_data             (c1_app_wdf_data		),
       .c1_app_wdf_end              (c1_app_wdf_end			),
       .c1_app_wdf_wren             (c1_app_wdf_wren		),
       .c1_app_rd_data              (c1_app_rd_data			),
       .c1_app_rd_data_end          (c1_app_rd_data_end		),
       .c1_app_rd_data_valid        (c1_app_rd_data_valid	),
       .c1_app_rdy                  (c1_app_rdy				),
       .c1_app_wdf_rdy              (c1_app_wdf_rdy			),
       .c1_app_sr_req               (1'b0					),
       .c1_app_ref_req              (1'b0					),
       .c1_app_zq_req               (1'b0					),
       .c1_app_sr_active            (c1_app_sr_active		),
       .c1_app_ref_ack              (c1_app_ref_ack			),
       .c1_app_zq_ack               (c1_app_zq_ack			),
       .c1_ui_clk                   (c1_clk					),
       .c1_ui_clk_sync_rst          (c1_clk_rst				),
// System Clock Ports
       .c1_sys_clk_i                (c1_sys_clk_i			),
       .sys_rst						(sys_rst				)

       );
// End of User Design top instance




      

endmodule
