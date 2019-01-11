// Copyright 1986-2014 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2014.2 (lin64) Build 928826 Thu Jun  5 17:55:10 MDT 2014
// Date        : Wed Jul 15 17:26:28 2015
// Host        : localhost.localdomain running 64-bit Red Hat Enterprise Linux Server release 5.6 (Tikanga)
// Command     : write_verilog -force -mode funcsim
//               /home/public/PRJ_RCUC/DebugVersionRCUC/rcuc_big_version_0712/ipcore/blk_sdpram_16x128_k7/blk_sdpram_16x128_k7_funcsim.v
// Design      : blk_sdpram_16x128_k7
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7k325tffg676-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_2,Vivado 2014.2" *) (* CHECK_LICENSE_TYPE = "blk_sdpram_16x128_k7,blk_mem_gen_v8_2,{}" *) 
(* core_generation_info = "blk_sdpram_16x128_k7,blk_mem_gen_v8_2,{x_ipProduct=Vivado 2014.2,x_ipVendor=xilinx.com,x_ipLibrary=ip,x_ipName=blk_mem_gen,x_ipVersion=8.2,x_ipCoreRevision=1,x_ipLanguage=VERILOG,C_FAMILY=kintex7,C_XDEVICEFAMILY=kintex7,C_ELABORATION_DIR=./,C_INTERFACE_TYPE=0,C_AXI_TYPE=1,C_AXI_SLAVE_TYPE=0,C_USE_BRAM_BLOCK=0,C_ENABLE_32BIT_ADDRESS=0,C_CTRL_ECC_ALGO=NONE,C_HAS_AXI_ID=0,C_AXI_ID_WIDTH=4,C_MEM_TYPE=1,C_BYTE_SIZE=9,C_ALGORITHM=1,C_PRIM_TYPE=1,C_LOAD_INIT_FILE=0,C_INIT_FILE_NAME=no_coe_file_loaded,C_INIT_FILE=blk_sdpram_16x128_k7.mem,C_USE_DEFAULT_DATA=0,C_DEFAULT_DATA=0,C_HAS_RSTA=0,C_RST_PRIORITY_A=CE,C_RSTRAM_A=0,C_INITA_VAL=0,C_HAS_ENA=1,C_HAS_REGCEA=0,C_USE_BYTE_WEA=0,C_WEA_WIDTH=1,C_WRITE_MODE_A=WRITE_FIRST,C_WRITE_WIDTH_A=128,C_READ_WIDTH_A=128,C_WRITE_DEPTH_A=16,C_READ_DEPTH_A=16,C_ADDRA_WIDTH=4,C_HAS_RSTB=0,C_RST_PRIORITY_B=CE,C_RSTRAM_B=0,C_INITB_VAL=0,C_HAS_ENB=1,C_HAS_REGCEB=0,C_USE_BYTE_WEB=0,C_WEB_WIDTH=1,C_WRITE_MODE_B=WRITE_FIRST,C_WRITE_WIDTH_B=128,C_READ_WIDTH_B=128,C_WRITE_DEPTH_B=16,C_READ_DEPTH_B=16,C_ADDRB_WIDTH=4,C_HAS_MEM_OUTPUT_REGS_A=0,C_HAS_MEM_OUTPUT_REGS_B=1,C_HAS_MUX_OUTPUT_REGS_A=0,C_HAS_MUX_OUTPUT_REGS_B=1,C_MUX_PIPELINE_STAGES=0,C_HAS_SOFTECC_INPUT_REGS_A=0,C_HAS_SOFTECC_OUTPUT_REGS_B=0,C_USE_SOFTECC=0,C_USE_ECC=0,C_EN_ECC_PIPE=0,C_HAS_INJECTERR=0,C_SIM_COLLISION_CHECK=ALL,C_COMMON_CLK=0,C_DISABLE_WARN_BHV_COLL=0,C_EN_SLEEP_PIN=0,C_DISABLE_WARN_BHV_RANGE=0,C_COUNT_36K_BRAM=2,C_COUNT_18K_BRAM=0,C_EST_POWER_SUMMARY=Estimated Power for IP     _     13.9322 mW}" *) 
(* NotValidForBitStream *)
module blk_sdpram_16x128_k7
   (clka,
    ena,
    wea,
    addra,
    dina,
    clkb,
    enb,
    addrb,
    doutb);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) input ena;
  input [0:0]wea;
  input [3:0]addra;
  input [127:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB CLK" *) input clkb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB EN" *) input enb;
  input [3:0]addrb;
  output [127:0]doutb;

  wire [3:0]addra;
  wire [3:0]addrb;
  wire clka;
  wire clkb;
  wire [127:0]dina;
  wire [127:0]doutb;
  wire ena;
  wire enb;
  wire [0:0]wea;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_sbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire [127:0]NLW_U0_douta_UNCONNECTED;
  wire [3:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [127:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

(* C_ADDRA_WIDTH = "4" *) 
   (* C_ADDRB_WIDTH = "4" *) 
   (* C_ALGORITHM = "1" *) 
   (* C_AXI_ID_WIDTH = "4" *) 
   (* C_AXI_SLAVE_TYPE = "0" *) 
   (* C_AXI_TYPE = "1" *) 
   (* C_BYTE_SIZE = "9" *) 
   (* C_COMMON_CLK = "0" *) 
   (* C_COUNT_18K_BRAM = "0" *) 
   (* C_COUNT_36K_BRAM = "2" *) 
   (* C_CTRL_ECC_ALGO = "NONE" *) 
   (* C_DEFAULT_DATA = "0" *) 
   (* C_DISABLE_WARN_BHV_COLL = "0" *) 
   (* C_DISABLE_WARN_BHV_RANGE = "0" *) 
   (* C_ELABORATION_DIR = "./" *) 
   (* C_ENABLE_32BIT_ADDRESS = "0" *) 
   (* C_EN_ECC_PIPE = "0" *) 
   (* C_EN_SLEEP_PIN = "0" *) 
   (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     13.9322 mW" *) 
   (* C_FAMILY = "kintex7" *) 
   (* C_HAS_AXI_ID = "0" *) 
   (* C_HAS_ENA = "1" *) 
   (* C_HAS_ENB = "1" *) 
   (* C_HAS_INJECTERR = "0" *) 
   (* C_HAS_MEM_OUTPUT_REGS_A = "0" *) 
   (* C_HAS_MEM_OUTPUT_REGS_B = "1" *) 
   (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) 
   (* C_HAS_MUX_OUTPUT_REGS_B = "1" *) 
   (* C_HAS_REGCEA = "0" *) 
   (* C_HAS_REGCEB = "0" *) 
   (* C_HAS_RSTA = "0" *) 
   (* C_HAS_RSTB = "0" *) 
   (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) 
   (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
   (* C_INITA_VAL = "0" *) 
   (* C_INITB_VAL = "0" *) 
   (* C_INIT_FILE = "blk_sdpram_16x128_k7.mem" *) 
   (* C_INIT_FILE_NAME = "no_coe_file_loaded" *) 
   (* C_INTERFACE_TYPE = "0" *) 
   (* C_LOAD_INIT_FILE = "0" *) 
   (* C_MEM_TYPE = "1" *) 
   (* C_MUX_PIPELINE_STAGES = "0" *) 
   (* C_PRIM_TYPE = "1" *) 
   (* C_READ_DEPTH_A = "16" *) 
   (* C_READ_DEPTH_B = "16" *) 
   (* C_READ_WIDTH_A = "128" *) 
   (* C_READ_WIDTH_B = "128" *) 
   (* C_RSTRAM_A = "0" *) 
   (* C_RSTRAM_B = "0" *) 
   (* C_RST_PRIORITY_A = "CE" *) 
   (* C_RST_PRIORITY_B = "CE" *) 
   (* C_SIM_COLLISION_CHECK = "ALL" *) 
   (* C_USE_BRAM_BLOCK = "0" *) 
   (* C_USE_BYTE_WEA = "0" *) 
   (* C_USE_BYTE_WEB = "0" *) 
   (* C_USE_DEFAULT_DATA = "0" *) 
   (* C_USE_ECC = "0" *) 
   (* C_USE_SOFTECC = "0" *) 
   (* C_WEA_WIDTH = "1" *) 
   (* C_WEB_WIDTH = "1" *) 
   (* C_WRITE_DEPTH_A = "16" *) 
   (* C_WRITE_DEPTH_B = "16" *) 
   (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
   (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
   (* C_WRITE_WIDTH_A = "128" *) 
   (* C_WRITE_WIDTH_B = "128" *) 
   (* C_XDEVICEFAMILY = "kintex7" *) 
   (* DONT_TOUCH *) 
   (* downgradeipidentifiedwarnings = "yes" *) 
   blk_sdpram_16x128_k7_blk_mem_gen_v8_2__parameterized0 U0
       (.addra(addra),
        .addrb(addrb),
        .clka(clka),
        .clkb(clkb),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .dina(dina),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .douta(NLW_U0_douta_UNCONNECTED[127:0]),
        .doutb(doutb),
        .eccpipece(1'b0),
        .ena(ena),
        .enb(enb),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[3:0]),
        .regcea(1'b0),
        .regceb(1'b0),
        .rsta(1'b0),
        .rstb(1'b0),
        .s_aclk(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[3:0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_dbiterr(NLW_U0_s_axi_dbiterr_UNCONNECTED),
        .s_axi_injectdbiterr(1'b0),
        .s_axi_injectsbiterr(1'b0),
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[3:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[127:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb(1'b0),
        .s_axi_wvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .sleep(1'b0),
        .wea(wea),
        .web(1'b0));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_generic_cstr" *) 
module blk_sdpram_16x128_k7_blk_mem_gen_generic_cstr
   (doutb,
    enb,
    clkb,
    ena,
    clka,
    addrb,
    addra,
    dina,
    wea);
  output [127:0]doutb;
  input enb;
  input clkb;
  input ena;
  input clka;
  input [3:0]addrb;
  input [3:0]addra;
  input [127:0]dina;
  input [0:0]wea;

  wire [3:0]addra;
  wire [3:0]addrb;
  wire clka;
  wire clkb;
  wire [127:0]dina;
  wire [127:0]doutb;
  wire ena;
  wire enb;
  wire [55:0]ram_doutb;
  wire [71:0]ram_doutb0_out;
  wire [0:0]wea;

FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[0] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[0]),
        .Q(doutb[0]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[100] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb[28]),
        .Q(doutb[100]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[101] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb[29]),
        .Q(doutb[101]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[102] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb[30]),
        .Q(doutb[102]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[103] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb[31]),
        .Q(doutb[103]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[104] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb[32]),
        .Q(doutb[104]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[105] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb[33]),
        .Q(doutb[105]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[106] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb[34]),
        .Q(doutb[106]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[107] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb[35]),
        .Q(doutb[107]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[108] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb[36]),
        .Q(doutb[108]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[109] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb[37]),
        .Q(doutb[109]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[10] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[10]),
        .Q(doutb[10]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[110] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb[38]),
        .Q(doutb[110]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[111] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb[39]),
        .Q(doutb[111]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[112] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb[40]),
        .Q(doutb[112]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[113] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb[41]),
        .Q(doutb[113]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[114] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb[42]),
        .Q(doutb[114]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[115] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb[43]),
        .Q(doutb[115]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[116] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb[44]),
        .Q(doutb[116]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[117] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb[45]),
        .Q(doutb[117]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[118] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb[46]),
        .Q(doutb[118]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[119] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb[47]),
        .Q(doutb[119]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[11] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[11]),
        .Q(doutb[11]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[120] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb[48]),
        .Q(doutb[120]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[121] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb[49]),
        .Q(doutb[121]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[122] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb[50]),
        .Q(doutb[122]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[123] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb[51]),
        .Q(doutb[123]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[124] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb[52]),
        .Q(doutb[124]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[125] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb[53]),
        .Q(doutb[125]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[126] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb[54]),
        .Q(doutb[126]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[127] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb[55]),
        .Q(doutb[127]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[12] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[12]),
        .Q(doutb[12]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[13] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[13]),
        .Q(doutb[13]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[14] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[14]),
        .Q(doutb[14]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[15] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[15]),
        .Q(doutb[15]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[16] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[16]),
        .Q(doutb[16]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[17] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[17]),
        .Q(doutb[17]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[18] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[18]),
        .Q(doutb[18]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[19] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[19]),
        .Q(doutb[19]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[1] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[1]),
        .Q(doutb[1]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[20] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[20]),
        .Q(doutb[20]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[21] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[21]),
        .Q(doutb[21]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[22] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[22]),
        .Q(doutb[22]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[23] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[23]),
        .Q(doutb[23]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[24] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[24]),
        .Q(doutb[24]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[25] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[25]),
        .Q(doutb[25]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[26] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[26]),
        .Q(doutb[26]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[27] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[27]),
        .Q(doutb[27]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[28] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[28]),
        .Q(doutb[28]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[29] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[29]),
        .Q(doutb[29]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[2] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[2]),
        .Q(doutb[2]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[30] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[30]),
        .Q(doutb[30]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[31] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[31]),
        .Q(doutb[31]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[32] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[32]),
        .Q(doutb[32]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[33] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[33]),
        .Q(doutb[33]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[34] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[34]),
        .Q(doutb[34]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[35] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[35]),
        .Q(doutb[35]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[36] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[36]),
        .Q(doutb[36]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[37] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[37]),
        .Q(doutb[37]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[38] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[38]),
        .Q(doutb[38]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[39] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[39]),
        .Q(doutb[39]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[3] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[3]),
        .Q(doutb[3]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[40] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[40]),
        .Q(doutb[40]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[41] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[41]),
        .Q(doutb[41]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[42] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[42]),
        .Q(doutb[42]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[43] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[43]),
        .Q(doutb[43]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[44] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[44]),
        .Q(doutb[44]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[45] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[45]),
        .Q(doutb[45]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[46] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[46]),
        .Q(doutb[46]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[47] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[47]),
        .Q(doutb[47]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[48] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[48]),
        .Q(doutb[48]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[49] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[49]),
        .Q(doutb[49]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[4] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[4]),
        .Q(doutb[4]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[50] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[50]),
        .Q(doutb[50]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[51] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[51]),
        .Q(doutb[51]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[52] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[52]),
        .Q(doutb[52]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[53] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[53]),
        .Q(doutb[53]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[54] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[54]),
        .Q(doutb[54]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[55] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[55]),
        .Q(doutb[55]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[56] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[56]),
        .Q(doutb[56]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[57] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[57]),
        .Q(doutb[57]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[58] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[58]),
        .Q(doutb[58]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[59] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[59]),
        .Q(doutb[59]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[5] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[5]),
        .Q(doutb[5]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[60] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[60]),
        .Q(doutb[60]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[61] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[61]),
        .Q(doutb[61]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[62] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[62]),
        .Q(doutb[62]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[63] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[63]),
        .Q(doutb[63]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[64] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[64]),
        .Q(doutb[64]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[65] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[65]),
        .Q(doutb[65]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[66] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[66]),
        .Q(doutb[66]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[67] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[67]),
        .Q(doutb[67]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[68] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[68]),
        .Q(doutb[68]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[69] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[69]),
        .Q(doutb[69]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[6] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[6]),
        .Q(doutb[6]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[70] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[70]),
        .Q(doutb[70]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[71] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[71]),
        .Q(doutb[71]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[72] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb[0]),
        .Q(doutb[72]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[73] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb[1]),
        .Q(doutb[73]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[74] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb[2]),
        .Q(doutb[74]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[75] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb[3]),
        .Q(doutb[75]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[76] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb[4]),
        .Q(doutb[76]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[77] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb[5]),
        .Q(doutb[77]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[78] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb[6]),
        .Q(doutb[78]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[79] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb[7]),
        .Q(doutb[79]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[7] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[7]),
        .Q(doutb[7]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[80] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb[8]),
        .Q(doutb[80]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[81] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb[9]),
        .Q(doutb[81]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[82] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb[10]),
        .Q(doutb[82]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[83] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb[11]),
        .Q(doutb[83]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[84] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb[12]),
        .Q(doutb[84]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[85] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb[13]),
        .Q(doutb[85]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[86] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb[14]),
        .Q(doutb[86]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[87] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb[15]),
        .Q(doutb[87]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[88] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb[16]),
        .Q(doutb[88]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[89] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb[17]),
        .Q(doutb[89]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[8] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[8]),
        .Q(doutb[8]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[90] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb[18]),
        .Q(doutb[90]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[91] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb[19]),
        .Q(doutb[91]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[92] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb[20]),
        .Q(doutb[92]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[93] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb[21]),
        .Q(doutb[93]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[94] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb[22]),
        .Q(doutb[94]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[95] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb[23]),
        .Q(doutb[95]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[96] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb[24]),
        .Q(doutb[96]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[97] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb[25]),
        .Q(doutb[97]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[98] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb[26]),
        .Q(doutb[98]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[99] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb[27]),
        .Q(doutb[99]),
        .R(1'b0));
FDRE #(
    .INIT(1'b0)) 
     \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[9] 
       (.C(clkb),
        .CE(enb),
        .D(ram_doutb0_out[9]),
        .Q(doutb[9]),
        .R(1'b0));
blk_sdpram_16x128_k7_blk_mem_gen_prim_width \ramloop[0].ram.r 
       (.addra(addra),
        .addrb(addrb),
        .clka(clka),
        .clkb(clkb),
        .dina(dina[71:0]),
        .ena(ena),
        .enb(enb),
        .ram_doutb0_out(ram_doutb0_out),
        .wea(wea));
blk_sdpram_16x128_k7_blk_mem_gen_prim_width__parameterized0 \ramloop[1].ram.r 
       (.addra(addra),
        .addrb(addrb),
        .clka(clka),
        .clkb(clkb),
        .dina(dina[127:72]),
        .ena(ena),
        .enb(enb),
        .ram_doutb(ram_doutb),
        .wea(wea));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_width" *) 
module blk_sdpram_16x128_k7_blk_mem_gen_prim_width
   (ram_doutb0_out,
    enb,
    clkb,
    ena,
    clka,
    addrb,
    addra,
    dina,
    wea);
  output [71:0]ram_doutb0_out;
  input enb;
  input clkb;
  input ena;
  input clka;
  input [3:0]addrb;
  input [3:0]addra;
  input [71:0]dina;
  input [0:0]wea;

  wire [3:0]addra;
  wire [3:0]addrb;
  wire clka;
  wire clkb;
  wire [71:0]dina;
  wire ena;
  wire enb;
  wire [71:0]ram_doutb0_out;
  wire [0:0]wea;

blk_sdpram_16x128_k7_blk_mem_gen_prim_wrapper \prim_noinit.ram 
       (.addra(addra),
        .addrb(addrb),
        .clka(clka),
        .clkb(clkb),
        .dina(dina),
        .ena(ena),
        .enb(enb),
        .ram_doutb0_out(ram_doutb0_out),
        .wea(wea));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_width" *) 
module blk_sdpram_16x128_k7_blk_mem_gen_prim_width__parameterized0
   (ram_doutb,
    enb,
    clkb,
    ena,
    clka,
    addrb,
    addra,
    dina,
    wea);
  output [55:0]ram_doutb;
  input enb;
  input clkb;
  input ena;
  input clka;
  input [3:0]addrb;
  input [3:0]addra;
  input [55:0]dina;
  input [0:0]wea;

  wire [3:0]addra;
  wire [3:0]addrb;
  wire clka;
  wire clkb;
  wire [55:0]dina;
  wire ena;
  wire enb;
  wire [55:0]ram_doutb;
  wire [0:0]wea;

blk_sdpram_16x128_k7_blk_mem_gen_prim_wrapper__parameterized0 \prim_noinit.ram 
       (.addra(addra),
        .addrb(addrb),
        .clka(clka),
        .clkb(clkb),
        .dina(dina),
        .ena(ena),
        .enb(enb),
        .ram_doutb(ram_doutb),
        .wea(wea));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_wrapper" *) 
module blk_sdpram_16x128_k7_blk_mem_gen_prim_wrapper
   (ram_doutb0_out,
    enb,
    clkb,
    ena,
    clka,
    addrb,
    addra,
    dina,
    wea);
  output [71:0]ram_doutb0_out;
  input enb;
  input clkb;
  input ena;
  input clka;
  input [3:0]addrb;
  input [3:0]addra;
  input [71:0]dina;
  input [0:0]wea;

  wire [3:0]addra;
  wire [3:0]addrb;
  wire clka;
  wire clkb;
  wire [71:0]dina;
  wire ena;
  wire enb;
  wire [71:0]ram_doutb0_out;
  wire [0:0]wea;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36.ram_DBITERR_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36.ram_SBITERR_UNCONNECTED ;
  wire [7:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36.ram_ECCPARITY_UNCONNECTED ;
  wire [8:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36.ram_RDADDRECC_UNCONNECTED ;

(* box_type = "PRIMITIVE" *) 
   RAMB36E1 #(
    .DOA_REG(1),
    .DOB_REG(1),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INITP_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_10(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_11(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_12(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_13(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_14(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_15(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_16(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_17(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_18(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_19(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_20(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_21(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_22(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_23(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_24(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_25(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_26(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_27(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_28(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_29(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_30(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_31(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_32(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_33(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_34(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_35(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_36(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_37(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_38(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_39(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_40(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_41(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_42(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_43(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_44(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_45(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_46(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_47(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_48(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_49(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_50(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_51(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_52(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_53(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_54(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_55(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_56(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_57(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_58(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_59(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_60(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_61(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_62(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_63(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_64(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_65(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_66(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_67(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_68(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_69(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_70(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_71(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_72(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_73(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_74(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_75(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_76(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_77(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_78(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_79(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .INIT_FILE("NONE"),
    .IS_CLKARDCLK_INVERTED(1'b0),
    .IS_CLKBWRCLK_INVERTED(1'b0),
    .IS_ENARDEN_INVERTED(1'b0),
    .IS_ENBWREN_INVERTED(1'b0),
    .IS_RSTRAMARSTRAM_INVERTED(1'b0),
    .IS_RSTRAMB_INVERTED(1'b0),
    .IS_RSTREGARSTREG_INVERTED(1'b0),
    .IS_RSTREGB_INVERTED(1'b0),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("SDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(72),
    .READ_WIDTH_B(0),
    .RSTREG_PRIORITY_A("REGCE"),
    .RSTREG_PRIORITY_B("REGCE"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("WRITE_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(0),
    .WRITE_WIDTH_B(72)) 
     \DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36.ram 
       (.ADDRARDADDR({1'b1,1'b0,1'b0,1'b0,1'b0,1'b0,addrb,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .ADDRBWRADDR({1'b1,1'b0,1'b0,1'b0,1'b0,1'b0,addra,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CASCADEINA(1'b0),
        .CASCADEINB(1'b0),
        .CASCADEOUTA(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ),
        .CASCADEOUTB(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ),
        .CLKARDCLK(clkb),
        .CLKBWRCLK(clka),
        .DBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36.ram_DBITERR_UNCONNECTED ),
        .DIADI({dina[34:27],dina[25:18],dina[16:9],dina[7:0]}),
        .DIBDI({dina[70:63],dina[61:54],dina[52:45],dina[43:36]}),
        .DIPADIP({dina[35],dina[26],dina[17],dina[8]}),
        .DIPBDIP({dina[71],dina[62],dina[53],dina[44]}),
        .DOADO({ram_doutb0_out[34:27],ram_doutb0_out[25:18],ram_doutb0_out[16:9],ram_doutb0_out[7:0]}),
        .DOBDO({ram_doutb0_out[70:63],ram_doutb0_out[61:54],ram_doutb0_out[52:45],ram_doutb0_out[43:36]}),
        .DOPADOP({ram_doutb0_out[35],ram_doutb0_out[26],ram_doutb0_out[17],ram_doutb0_out[8]}),
        .DOPBDOP({ram_doutb0_out[71],ram_doutb0_out[62],ram_doutb0_out[53],ram_doutb0_out[44]}),
        .ECCPARITY(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36.ram_ECCPARITY_UNCONNECTED [7:0]),
        .ENARDEN(enb),
        .ENBWREN(ena),
        .INJECTDBITERR(1'b0),
        .INJECTSBITERR(1'b0),
        .RDADDRECC(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36.ram_RDADDRECC_UNCONNECTED [8:0]),
        .REGCEAREGCE(enb),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36.ram_SBITERR_UNCONNECTED ),
        .WEA({1'b0,1'b0,1'b0,1'b0}),
        .WEBWE({wea,wea,wea,wea,wea,wea,wea,wea}));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_wrapper" *) 
module blk_sdpram_16x128_k7_blk_mem_gen_prim_wrapper__parameterized0
   (ram_doutb,
    enb,
    clkb,
    ena,
    clka,
    addrb,
    addra,
    dina,
    wea);
  output [55:0]ram_doutb;
  input enb;
  input clkb;
  input ena;
  input clka;
  input [3:0]addrb;
  input [3:0]addra;
  input [55:0]dina;
  input [0:0]wea;

  wire [3:0]addra;
  wire [3:0]addrb;
  wire clka;
  wire clkb;
  wire [55:0]dina;
  wire ena;
  wire enb;
  wire \n_12_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36.ram ;
  wire \n_20_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36.ram ;
  wire \n_28_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36.ram ;
  wire \n_36_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36.ram ;
  wire \n_44_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36.ram ;
  wire \n_4_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36.ram ;
  wire \n_52_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36.ram ;
  wire \n_60_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36.ram ;
  wire \n_68_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36.ram ;
  wire \n_69_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36.ram ;
  wire \n_70_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36.ram ;
  wire \n_71_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36.ram ;
  wire \n_72_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36.ram ;
  wire \n_73_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36.ram ;
  wire \n_74_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36.ram ;
  wire \n_75_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36.ram ;
  wire [55:0]ram_doutb;
  wire [0:0]wea;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36.ram_DBITERR_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36.ram_SBITERR_UNCONNECTED ;
  wire [7:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36.ram_ECCPARITY_UNCONNECTED ;
  wire [8:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36.ram_RDADDRECC_UNCONNECTED ;

(* box_type = "PRIMITIVE" *) 
   RAMB36E1 #(
    .DOA_REG(1),
    .DOB_REG(1),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INITP_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_10(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_11(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_12(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_13(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_14(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_15(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_16(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_17(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_18(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_19(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_20(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_21(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_22(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_23(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_24(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_25(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_26(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_27(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_28(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_29(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_30(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_31(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_32(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_33(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_34(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_35(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_36(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_37(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_38(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_39(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_40(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_41(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_42(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_43(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_44(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_45(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_46(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_47(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_48(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_49(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_50(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_51(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_52(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_53(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_54(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_55(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_56(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_57(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_58(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_59(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_60(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_61(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_62(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_63(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_64(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_65(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_66(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_67(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_68(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_69(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_70(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_71(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_72(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_73(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_74(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_75(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_76(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_77(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_78(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_79(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .INIT_FILE("NONE"),
    .IS_CLKARDCLK_INVERTED(1'b0),
    .IS_CLKBWRCLK_INVERTED(1'b0),
    .IS_ENARDEN_INVERTED(1'b0),
    .IS_ENBWREN_INVERTED(1'b0),
    .IS_RSTRAMARSTRAM_INVERTED(1'b0),
    .IS_RSTRAMB_INVERTED(1'b0),
    .IS_RSTREGARSTREG_INVERTED(1'b0),
    .IS_RSTREGB_INVERTED(1'b0),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("SDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(72),
    .READ_WIDTH_B(0),
    .RSTREG_PRIORITY_A("REGCE"),
    .RSTREG_PRIORITY_B("REGCE"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("WRITE_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(0),
    .WRITE_WIDTH_B(72)) 
     \DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36.ram 
       (.ADDRARDADDR({1'b1,1'b0,1'b0,1'b0,1'b0,1'b0,addrb,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .ADDRBWRADDR({1'b1,1'b0,1'b0,1'b0,1'b0,1'b0,addra,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CASCADEINA(1'b0),
        .CASCADEINB(1'b0),
        .CASCADEOUTA(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ),
        .CASCADEOUTB(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ),
        .CLKARDCLK(clkb),
        .CLKBWRCLK(clka),
        .DBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36.ram_DBITERR_UNCONNECTED ),
        .DIADI({1'b0,dina[27:21],1'b0,dina[20:14],1'b0,dina[13:7],1'b0,dina[6:0]}),
        .DIBDI({1'b0,dina[55:49],1'b0,dina[48:42],1'b0,dina[41:35],1'b0,dina[34:28]}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO({\n_4_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36.ram ,ram_doutb[27:21],\n_12_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36.ram ,ram_doutb[20:14],\n_20_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36.ram ,ram_doutb[13:7],\n_28_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36.ram ,ram_doutb[6:0]}),
        .DOBDO({\n_36_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36.ram ,ram_doutb[55:49],\n_44_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36.ram ,ram_doutb[48:42],\n_52_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36.ram ,ram_doutb[41:35],\n_60_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36.ram ,ram_doutb[34:28]}),
        .DOPADOP({\n_68_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36.ram ,\n_69_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36.ram ,\n_70_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36.ram ,\n_71_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36.ram }),
        .DOPBDOP({\n_72_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36.ram ,\n_73_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36.ram ,\n_74_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36.ram ,\n_75_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36.ram }),
        .ECCPARITY(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36.ram_ECCPARITY_UNCONNECTED [7:0]),
        .ENARDEN(enb),
        .ENBWREN(ena),
        .INJECTDBITERR(1'b0),
        .INJECTSBITERR(1'b0),
        .RDADDRECC(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36.ram_RDADDRECC_UNCONNECTED [8:0]),
        .REGCEAREGCE(enb),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36.ram_SBITERR_UNCONNECTED ),
        .WEA({1'b0,1'b0,1'b0,1'b0}),
        .WEBWE({wea,wea,wea,wea,wea,wea,wea,wea}));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_top" *) 
module blk_sdpram_16x128_k7_blk_mem_gen_top
   (doutb,
    enb,
    clkb,
    ena,
    clka,
    addrb,
    addra,
    dina,
    wea);
  output [127:0]doutb;
  input enb;
  input clkb;
  input ena;
  input clka;
  input [3:0]addrb;
  input [3:0]addra;
  input [127:0]dina;
  input [0:0]wea;

  wire [3:0]addra;
  wire [3:0]addrb;
  wire clka;
  wire clkb;
  wire [127:0]dina;
  wire [127:0]doutb;
  wire ena;
  wire enb;
  wire [0:0]wea;

blk_sdpram_16x128_k7_blk_mem_gen_generic_cstr \valid.cstr 
       (.addra(addra),
        .addrb(addrb),
        .clka(clka),
        .clkb(clkb),
        .dina(dina),
        .doutb(doutb),
        .ena(ena),
        .enb(enb),
        .wea(wea));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_v8_2" *) (* C_FAMILY = "kintex7" *) (* C_XDEVICEFAMILY = "kintex7" *) 
(* C_ELABORATION_DIR = "./" *) (* C_INTERFACE_TYPE = "0" *) (* C_AXI_TYPE = "1" *) 
(* C_AXI_SLAVE_TYPE = "0" *) (* C_USE_BRAM_BLOCK = "0" *) (* C_ENABLE_32BIT_ADDRESS = "0" *) 
(* C_CTRL_ECC_ALGO = "NONE" *) (* C_HAS_AXI_ID = "0" *) (* C_AXI_ID_WIDTH = "4" *) 
(* C_MEM_TYPE = "1" *) (* C_BYTE_SIZE = "9" *) (* C_ALGORITHM = "1" *) 
(* C_PRIM_TYPE = "1" *) (* C_LOAD_INIT_FILE = "0" *) (* C_INIT_FILE_NAME = "no_coe_file_loaded" *) 
(* C_INIT_FILE = "blk_sdpram_16x128_k7.mem" *) (* C_USE_DEFAULT_DATA = "0" *) (* C_DEFAULT_DATA = "0" *) 
(* C_HAS_RSTA = "0" *) (* C_RST_PRIORITY_A = "CE" *) (* C_RSTRAM_A = "0" *) 
(* C_INITA_VAL = "0" *) (* C_HAS_ENA = "1" *) (* C_HAS_REGCEA = "0" *) 
(* C_USE_BYTE_WEA = "0" *) (* C_WEA_WIDTH = "1" *) (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
(* C_WRITE_WIDTH_A = "128" *) (* C_READ_WIDTH_A = "128" *) (* C_WRITE_DEPTH_A = "16" *) 
(* C_READ_DEPTH_A = "16" *) (* C_ADDRA_WIDTH = "4" *) (* C_HAS_RSTB = "0" *) 
(* C_RST_PRIORITY_B = "CE" *) (* C_RSTRAM_B = "0" *) (* C_INITB_VAL = "0" *) 
(* C_HAS_ENB = "1" *) (* C_HAS_REGCEB = "0" *) (* C_USE_BYTE_WEB = "0" *) 
(* C_WEB_WIDTH = "1" *) (* C_WRITE_MODE_B = "WRITE_FIRST" *) (* C_WRITE_WIDTH_B = "128" *) 
(* C_READ_WIDTH_B = "128" *) (* C_WRITE_DEPTH_B = "16" *) (* C_READ_DEPTH_B = "16" *) 
(* C_ADDRB_WIDTH = "4" *) (* C_HAS_MEM_OUTPUT_REGS_A = "0" *) (* C_HAS_MEM_OUTPUT_REGS_B = "1" *) 
(* C_HAS_MUX_OUTPUT_REGS_A = "0" *) (* C_HAS_MUX_OUTPUT_REGS_B = "1" *) (* C_MUX_PIPELINE_STAGES = "0" *) 
(* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) (* C_USE_SOFTECC = "0" *) 
(* C_USE_ECC = "0" *) (* C_EN_ECC_PIPE = "0" *) (* C_HAS_INJECTERR = "0" *) 
(* C_SIM_COLLISION_CHECK = "ALL" *) (* C_COMMON_CLK = "0" *) (* C_DISABLE_WARN_BHV_COLL = "0" *) 
(* C_EN_SLEEP_PIN = "0" *) (* C_DISABLE_WARN_BHV_RANGE = "0" *) (* C_COUNT_36K_BRAM = "2" *) 
(* C_COUNT_18K_BRAM = "0" *) (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     13.9322 mW" *) (* downgradeipidentifiedwarnings = "yes" *) 
module blk_sdpram_16x128_k7_blk_mem_gen_v8_2__parameterized0
   (clka,
    rsta,
    ena,
    regcea,
    wea,
    addra,
    dina,
    douta,
    clkb,
    rstb,
    enb,
    regceb,
    web,
    addrb,
    dinb,
    doutb,
    injectsbiterr,
    injectdbiterr,
    eccpipece,
    sbiterr,
    dbiterr,
    rdaddrecc,
    sleep,
    s_aclk,
    s_aresetn,
    s_axi_awid,
    s_axi_awaddr,
    s_axi_awlen,
    s_axi_awsize,
    s_axi_awburst,
    s_axi_awvalid,
    s_axi_awready,
    s_axi_wdata,
    s_axi_wstrb,
    s_axi_wlast,
    s_axi_wvalid,
    s_axi_wready,
    s_axi_bid,
    s_axi_bresp,
    s_axi_bvalid,
    s_axi_bready,
    s_axi_arid,
    s_axi_araddr,
    s_axi_arlen,
    s_axi_arsize,
    s_axi_arburst,
    s_axi_arvalid,
    s_axi_arready,
    s_axi_rid,
    s_axi_rdata,
    s_axi_rresp,
    s_axi_rlast,
    s_axi_rvalid,
    s_axi_rready,
    s_axi_injectsbiterr,
    s_axi_injectdbiterr,
    s_axi_sbiterr,
    s_axi_dbiterr,
    s_axi_rdaddrecc);
  input clka;
  input rsta;
  input ena;
  input regcea;
  input [0:0]wea;
  input [3:0]addra;
  input [127:0]dina;
  output [127:0]douta;
  input clkb;
  input rstb;
  input enb;
  input regceb;
  input [0:0]web;
  input [3:0]addrb;
  input [127:0]dinb;
  output [127:0]doutb;
  input injectsbiterr;
  input injectdbiterr;
  input eccpipece;
  output sbiterr;
  output dbiterr;
  output [3:0]rdaddrecc;
  input sleep;
  input s_aclk;
  input s_aresetn;
  input [3:0]s_axi_awid;
  input [31:0]s_axi_awaddr;
  input [7:0]s_axi_awlen;
  input [2:0]s_axi_awsize;
  input [1:0]s_axi_awburst;
  input s_axi_awvalid;
  output s_axi_awready;
  input [127:0]s_axi_wdata;
  input [0:0]s_axi_wstrb;
  input s_axi_wlast;
  input s_axi_wvalid;
  output s_axi_wready;
  output [3:0]s_axi_bid;
  output [1:0]s_axi_bresp;
  output s_axi_bvalid;
  input s_axi_bready;
  input [3:0]s_axi_arid;
  input [31:0]s_axi_araddr;
  input [7:0]s_axi_arlen;
  input [2:0]s_axi_arsize;
  input [1:0]s_axi_arburst;
  input s_axi_arvalid;
  output s_axi_arready;
  output [3:0]s_axi_rid;
  output [127:0]s_axi_rdata;
  output [1:0]s_axi_rresp;
  output s_axi_rlast;
  output s_axi_rvalid;
  input s_axi_rready;
  input s_axi_injectsbiterr;
  input s_axi_injectdbiterr;
  output s_axi_sbiterr;
  output s_axi_dbiterr;
  output [3:0]s_axi_rdaddrecc;

  wire \<const0> ;
  wire [3:0]addra;
  wire [3:0]addrb;
  wire clka;
  wire clkb;
  wire [127:0]dina;
  wire [127:0]dinb;
  wire [127:0]doutb;
  wire eccpipece;
  wire ena;
  wire enb;
  wire injectdbiterr;
  wire injectsbiterr;
  wire regcea;
  wire regceb;
  wire rsta;
  wire rstb;
  wire s_aclk;
  wire s_aresetn;
  wire [31:0]s_axi_araddr;
  wire [1:0]s_axi_arburst;
  wire [3:0]s_axi_arid;
  wire [7:0]s_axi_arlen;
  wire [2:0]s_axi_arsize;
  wire s_axi_arvalid;
  wire [31:0]s_axi_awaddr;
  wire [1:0]s_axi_awburst;
  wire [3:0]s_axi_awid;
  wire [7:0]s_axi_awlen;
  wire [2:0]s_axi_awsize;
  wire s_axi_awvalid;
  wire s_axi_bready;
  wire s_axi_injectdbiterr;
  wire s_axi_injectsbiterr;
  wire s_axi_rready;
  wire [127:0]s_axi_wdata;
  wire s_axi_wlast;
  wire [0:0]s_axi_wstrb;
  wire s_axi_wvalid;
  wire sleep;
  wire [0:0]wea;
  wire [0:0]web;

  assign dbiterr = \<const0> ;
  assign douta[127] = \<const0> ;
  assign douta[126] = \<const0> ;
  assign douta[125] = \<const0> ;
  assign douta[124] = \<const0> ;
  assign douta[123] = \<const0> ;
  assign douta[122] = \<const0> ;
  assign douta[121] = \<const0> ;
  assign douta[120] = \<const0> ;
  assign douta[119] = \<const0> ;
  assign douta[118] = \<const0> ;
  assign douta[117] = \<const0> ;
  assign douta[116] = \<const0> ;
  assign douta[115] = \<const0> ;
  assign douta[114] = \<const0> ;
  assign douta[113] = \<const0> ;
  assign douta[112] = \<const0> ;
  assign douta[111] = \<const0> ;
  assign douta[110] = \<const0> ;
  assign douta[109] = \<const0> ;
  assign douta[108] = \<const0> ;
  assign douta[107] = \<const0> ;
  assign douta[106] = \<const0> ;
  assign douta[105] = \<const0> ;
  assign douta[104] = \<const0> ;
  assign douta[103] = \<const0> ;
  assign douta[102] = \<const0> ;
  assign douta[101] = \<const0> ;
  assign douta[100] = \<const0> ;
  assign douta[99] = \<const0> ;
  assign douta[98] = \<const0> ;
  assign douta[97] = \<const0> ;
  assign douta[96] = \<const0> ;
  assign douta[95] = \<const0> ;
  assign douta[94] = \<const0> ;
  assign douta[93] = \<const0> ;
  assign douta[92] = \<const0> ;
  assign douta[91] = \<const0> ;
  assign douta[90] = \<const0> ;
  assign douta[89] = \<const0> ;
  assign douta[88] = \<const0> ;
  assign douta[87] = \<const0> ;
  assign douta[86] = \<const0> ;
  assign douta[85] = \<const0> ;
  assign douta[84] = \<const0> ;
  assign douta[83] = \<const0> ;
  assign douta[82] = \<const0> ;
  assign douta[81] = \<const0> ;
  assign douta[80] = \<const0> ;
  assign douta[79] = \<const0> ;
  assign douta[78] = \<const0> ;
  assign douta[77] = \<const0> ;
  assign douta[76] = \<const0> ;
  assign douta[75] = \<const0> ;
  assign douta[74] = \<const0> ;
  assign douta[73] = \<const0> ;
  assign douta[72] = \<const0> ;
  assign douta[71] = \<const0> ;
  assign douta[70] = \<const0> ;
  assign douta[69] = \<const0> ;
  assign douta[68] = \<const0> ;
  assign douta[67] = \<const0> ;
  assign douta[66] = \<const0> ;
  assign douta[65] = \<const0> ;
  assign douta[64] = \<const0> ;
  assign douta[63] = \<const0> ;
  assign douta[62] = \<const0> ;
  assign douta[61] = \<const0> ;
  assign douta[60] = \<const0> ;
  assign douta[59] = \<const0> ;
  assign douta[58] = \<const0> ;
  assign douta[57] = \<const0> ;
  assign douta[56] = \<const0> ;
  assign douta[55] = \<const0> ;
  assign douta[54] = \<const0> ;
  assign douta[53] = \<const0> ;
  assign douta[52] = \<const0> ;
  assign douta[51] = \<const0> ;
  assign douta[50] = \<const0> ;
  assign douta[49] = \<const0> ;
  assign douta[48] = \<const0> ;
  assign douta[47] = \<const0> ;
  assign douta[46] = \<const0> ;
  assign douta[45] = \<const0> ;
  assign douta[44] = \<const0> ;
  assign douta[43] = \<const0> ;
  assign douta[42] = \<const0> ;
  assign douta[41] = \<const0> ;
  assign douta[40] = \<const0> ;
  assign douta[39] = \<const0> ;
  assign douta[38] = \<const0> ;
  assign douta[37] = \<const0> ;
  assign douta[36] = \<const0> ;
  assign douta[35] = \<const0> ;
  assign douta[34] = \<const0> ;
  assign douta[33] = \<const0> ;
  assign douta[32] = \<const0> ;
  assign douta[31] = \<const0> ;
  assign douta[30] = \<const0> ;
  assign douta[29] = \<const0> ;
  assign douta[28] = \<const0> ;
  assign douta[27] = \<const0> ;
  assign douta[26] = \<const0> ;
  assign douta[25] = \<const0> ;
  assign douta[24] = \<const0> ;
  assign douta[23] = \<const0> ;
  assign douta[22] = \<const0> ;
  assign douta[21] = \<const0> ;
  assign douta[20] = \<const0> ;
  assign douta[19] = \<const0> ;
  assign douta[18] = \<const0> ;
  assign douta[17] = \<const0> ;
  assign douta[16] = \<const0> ;
  assign douta[15] = \<const0> ;
  assign douta[14] = \<const0> ;
  assign douta[13] = \<const0> ;
  assign douta[12] = \<const0> ;
  assign douta[11] = \<const0> ;
  assign douta[10] = \<const0> ;
  assign douta[9] = \<const0> ;
  assign douta[8] = \<const0> ;
  assign douta[7] = \<const0> ;
  assign douta[6] = \<const0> ;
  assign douta[5] = \<const0> ;
  assign douta[4] = \<const0> ;
  assign douta[3] = \<const0> ;
  assign douta[2] = \<const0> ;
  assign douta[1] = \<const0> ;
  assign douta[0] = \<const0> ;
  assign rdaddrecc[3] = \<const0> ;
  assign rdaddrecc[2] = \<const0> ;
  assign rdaddrecc[1] = \<const0> ;
  assign rdaddrecc[0] = \<const0> ;
  assign s_axi_arready = \<const0> ;
  assign s_axi_awready = \<const0> ;
  assign s_axi_bid[3] = \<const0> ;
  assign s_axi_bid[2] = \<const0> ;
  assign s_axi_bid[1] = \<const0> ;
  assign s_axi_bid[0] = \<const0> ;
  assign s_axi_bresp[1] = \<const0> ;
  assign s_axi_bresp[0] = \<const0> ;
  assign s_axi_bvalid = \<const0> ;
  assign s_axi_dbiterr = \<const0> ;
  assign s_axi_rdaddrecc[3] = \<const0> ;
  assign s_axi_rdaddrecc[2] = \<const0> ;
  assign s_axi_rdaddrecc[1] = \<const0> ;
  assign s_axi_rdaddrecc[0] = \<const0> ;
  assign s_axi_rdata[127] = \<const0> ;
  assign s_axi_rdata[126] = \<const0> ;
  assign s_axi_rdata[125] = \<const0> ;
  assign s_axi_rdata[124] = \<const0> ;
  assign s_axi_rdata[123] = \<const0> ;
  assign s_axi_rdata[122] = \<const0> ;
  assign s_axi_rdata[121] = \<const0> ;
  assign s_axi_rdata[120] = \<const0> ;
  assign s_axi_rdata[119] = \<const0> ;
  assign s_axi_rdata[118] = \<const0> ;
  assign s_axi_rdata[117] = \<const0> ;
  assign s_axi_rdata[116] = \<const0> ;
  assign s_axi_rdata[115] = \<const0> ;
  assign s_axi_rdata[114] = \<const0> ;
  assign s_axi_rdata[113] = \<const0> ;
  assign s_axi_rdata[112] = \<const0> ;
  assign s_axi_rdata[111] = \<const0> ;
  assign s_axi_rdata[110] = \<const0> ;
  assign s_axi_rdata[109] = \<const0> ;
  assign s_axi_rdata[108] = \<const0> ;
  assign s_axi_rdata[107] = \<const0> ;
  assign s_axi_rdata[106] = \<const0> ;
  assign s_axi_rdata[105] = \<const0> ;
  assign s_axi_rdata[104] = \<const0> ;
  assign s_axi_rdata[103] = \<const0> ;
  assign s_axi_rdata[102] = \<const0> ;
  assign s_axi_rdata[101] = \<const0> ;
  assign s_axi_rdata[100] = \<const0> ;
  assign s_axi_rdata[99] = \<const0> ;
  assign s_axi_rdata[98] = \<const0> ;
  assign s_axi_rdata[97] = \<const0> ;
  assign s_axi_rdata[96] = \<const0> ;
  assign s_axi_rdata[95] = \<const0> ;
  assign s_axi_rdata[94] = \<const0> ;
  assign s_axi_rdata[93] = \<const0> ;
  assign s_axi_rdata[92] = \<const0> ;
  assign s_axi_rdata[91] = \<const0> ;
  assign s_axi_rdata[90] = \<const0> ;
  assign s_axi_rdata[89] = \<const0> ;
  assign s_axi_rdata[88] = \<const0> ;
  assign s_axi_rdata[87] = \<const0> ;
  assign s_axi_rdata[86] = \<const0> ;
  assign s_axi_rdata[85] = \<const0> ;
  assign s_axi_rdata[84] = \<const0> ;
  assign s_axi_rdata[83] = \<const0> ;
  assign s_axi_rdata[82] = \<const0> ;
  assign s_axi_rdata[81] = \<const0> ;
  assign s_axi_rdata[80] = \<const0> ;
  assign s_axi_rdata[79] = \<const0> ;
  assign s_axi_rdata[78] = \<const0> ;
  assign s_axi_rdata[77] = \<const0> ;
  assign s_axi_rdata[76] = \<const0> ;
  assign s_axi_rdata[75] = \<const0> ;
  assign s_axi_rdata[74] = \<const0> ;
  assign s_axi_rdata[73] = \<const0> ;
  assign s_axi_rdata[72] = \<const0> ;
  assign s_axi_rdata[71] = \<const0> ;
  assign s_axi_rdata[70] = \<const0> ;
  assign s_axi_rdata[69] = \<const0> ;
  assign s_axi_rdata[68] = \<const0> ;
  assign s_axi_rdata[67] = \<const0> ;
  assign s_axi_rdata[66] = \<const0> ;
  assign s_axi_rdata[65] = \<const0> ;
  assign s_axi_rdata[64] = \<const0> ;
  assign s_axi_rdata[63] = \<const0> ;
  assign s_axi_rdata[62] = \<const0> ;
  assign s_axi_rdata[61] = \<const0> ;
  assign s_axi_rdata[60] = \<const0> ;
  assign s_axi_rdata[59] = \<const0> ;
  assign s_axi_rdata[58] = \<const0> ;
  assign s_axi_rdata[57] = \<const0> ;
  assign s_axi_rdata[56] = \<const0> ;
  assign s_axi_rdata[55] = \<const0> ;
  assign s_axi_rdata[54] = \<const0> ;
  assign s_axi_rdata[53] = \<const0> ;
  assign s_axi_rdata[52] = \<const0> ;
  assign s_axi_rdata[51] = \<const0> ;
  assign s_axi_rdata[50] = \<const0> ;
  assign s_axi_rdata[49] = \<const0> ;
  assign s_axi_rdata[48] = \<const0> ;
  assign s_axi_rdata[47] = \<const0> ;
  assign s_axi_rdata[46] = \<const0> ;
  assign s_axi_rdata[45] = \<const0> ;
  assign s_axi_rdata[44] = \<const0> ;
  assign s_axi_rdata[43] = \<const0> ;
  assign s_axi_rdata[42] = \<const0> ;
  assign s_axi_rdata[41] = \<const0> ;
  assign s_axi_rdata[40] = \<const0> ;
  assign s_axi_rdata[39] = \<const0> ;
  assign s_axi_rdata[38] = \<const0> ;
  assign s_axi_rdata[37] = \<const0> ;
  assign s_axi_rdata[36] = \<const0> ;
  assign s_axi_rdata[35] = \<const0> ;
  assign s_axi_rdata[34] = \<const0> ;
  assign s_axi_rdata[33] = \<const0> ;
  assign s_axi_rdata[32] = \<const0> ;
  assign s_axi_rdata[31] = \<const0> ;
  assign s_axi_rdata[30] = \<const0> ;
  assign s_axi_rdata[29] = \<const0> ;
  assign s_axi_rdata[28] = \<const0> ;
  assign s_axi_rdata[27] = \<const0> ;
  assign s_axi_rdata[26] = \<const0> ;
  assign s_axi_rdata[25] = \<const0> ;
  assign s_axi_rdata[24] = \<const0> ;
  assign s_axi_rdata[23] = \<const0> ;
  assign s_axi_rdata[22] = \<const0> ;
  assign s_axi_rdata[21] = \<const0> ;
  assign s_axi_rdata[20] = \<const0> ;
  assign s_axi_rdata[19] = \<const0> ;
  assign s_axi_rdata[18] = \<const0> ;
  assign s_axi_rdata[17] = \<const0> ;
  assign s_axi_rdata[16] = \<const0> ;
  assign s_axi_rdata[15] = \<const0> ;
  assign s_axi_rdata[14] = \<const0> ;
  assign s_axi_rdata[13] = \<const0> ;
  assign s_axi_rdata[12] = \<const0> ;
  assign s_axi_rdata[11] = \<const0> ;
  assign s_axi_rdata[10] = \<const0> ;
  assign s_axi_rdata[9] = \<const0> ;
  assign s_axi_rdata[8] = \<const0> ;
  assign s_axi_rdata[7] = \<const0> ;
  assign s_axi_rdata[6] = \<const0> ;
  assign s_axi_rdata[5] = \<const0> ;
  assign s_axi_rdata[4] = \<const0> ;
  assign s_axi_rdata[3] = \<const0> ;
  assign s_axi_rdata[2] = \<const0> ;
  assign s_axi_rdata[1] = \<const0> ;
  assign s_axi_rdata[0] = \<const0> ;
  assign s_axi_rid[3] = \<const0> ;
  assign s_axi_rid[2] = \<const0> ;
  assign s_axi_rid[1] = \<const0> ;
  assign s_axi_rid[0] = \<const0> ;
  assign s_axi_rlast = \<const0> ;
  assign s_axi_rresp[1] = \<const0> ;
  assign s_axi_rresp[0] = \<const0> ;
  assign s_axi_rvalid = \<const0> ;
  assign s_axi_sbiterr = \<const0> ;
  assign s_axi_wready = \<const0> ;
  assign sbiterr = \<const0> ;
GND GND
       (.G(\<const0> ));
blk_sdpram_16x128_k7_blk_mem_gen_v8_2_synth inst_blk_mem_gen
       (.addra(addra),
        .addrb(addrb),
        .clka(clka),
        .clkb(clkb),
        .dina(dina),
        .doutb(doutb),
        .ena(ena),
        .enb(enb),
        .wea(wea));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_v8_2_synth" *) 
module blk_sdpram_16x128_k7_blk_mem_gen_v8_2_synth
   (doutb,
    enb,
    clkb,
    ena,
    clka,
    addrb,
    addra,
    dina,
    wea);
  output [127:0]doutb;
  input enb;
  input clkb;
  input ena;
  input clka;
  input [3:0]addrb;
  input [3:0]addra;
  input [127:0]dina;
  input [0:0]wea;

  wire [3:0]addra;
  wire [3:0]addrb;
  wire clka;
  wire clkb;
  wire [127:0]dina;
  wire [127:0]doutb;
  wire ena;
  wire enb;
  wire [0:0]wea;

blk_sdpram_16x128_k7_blk_mem_gen_top \gnativebmg.native_blk_mem_gen 
       (.addra(addra),
        .addrb(addrb),
        .clka(clka),
        .clkb(clkb),
        .dina(dina),
        .doutb(doutb),
        .ena(ena),
        .enb(enb),
        .wea(wea));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (weak1, weak0) GSR = GSR_int;
    assign (weak1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
