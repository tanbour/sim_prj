module tx_pla_ptp_check
(
    input                       I_clk_312m                     ,
    input                       I_rst                          ,
    input       [31:0]          I_xgmii_data                   ,
    input       [3:0]           I_xgmii_txc                    ,
    input       [1:0]           I_xgmii_err                    ,
    input       [47:0]          I_ptp_dmac                     ,
//    input       [47:0]          I_pla_smac                     ,  
    
    input                       I_rd_cnt_clr                   ,
    output reg [31:0]           O_pkt_cnt_slice_in = 16'd0     ,
                                
    output reg [31:0]           O_xgmii_data    = 32'h07070707 ,
    output reg [3:0 ]           O_xgmii_txc     = 4'b1111      ,
    output reg [1:0]            O_xgmii_err     = 2'b0         ,
    output reg                  O_ptp_pack_flag = 1'd0         ,
    output reg                  O_ptp_vlan_flag = 1'b0         ,
    output reg [15:0]           O_slice_id      = 16'd0        ,
    output reg [15:0]           O_ptp_length    = 16'd0        ,
    output reg [31:0]           O_vlan_type     = 32'd0        ,
    output reg [3:0 ]           O_state_current = 4'd0         
);


parameter   C_XGMII_VLAN_TYPE       = 16'h8100     ;
parameter   C_XGMII_IP_TYPE         = 16'h0800     ;
parameter   C_XGMII_UDP_TYPE        = 8'h11        ;
parameter   C_XGMII_PTP_TYPE        = 16'h88f7     ;
parameter   C_XGMII_UDP_PTP         = 16'h013f     ;
parameter   C_XGMII_UDP_SUB_PTP0    = 8'h00        ;
parameter   C_XGMII_UDP_SUB_PTP1    = 8'h01        ;

parameter   C_XGMII_IDLE            = 4'h0         ;
parameter   C_XGMII_PRE             = 4'h1         ;
parameter   C_XGMII_MAC             = 4'h2         ;
parameter   C_XGMII_TYPE            = 4'h3         ;
parameter   C_XGMII_IP              = 4'h4         ;
parameter   C_XGMII_UDP             = 4'h5         ;
parameter   C_XGMII_PTP_UDP         = 4'h6         ;
parameter   C_XGMII_PTP             = 4'h7         ;
parameter   C_XGMII_SUB_PTP         = 4'h8         ;
parameter   C_XGMII_DATA            = 4'h9         ;

reg  [31:0] S_xgmii_data_d1        = 32'h07070707  ;
reg  [31:0] S_xgmii_data_d2        = 32'h07070707  ;
reg  [31:0] S_xgmii_data_d3        = 32'h07070707  ;
reg  [31:0] S_xgmii_data_d4        = 32'h07070707  ;
reg  [31:0] S_xgmii_data_d5        = 32'h07070707  ;
reg  [31:0] S_xgmii_data_d6        = 32'h07070707  ;
reg  [31:0] S_xgmii_data_d7        = 32'h07070707  ;
reg  [31:0] S_xgmii_data_d8        = 32'h07070707  ;
reg  [31:0] S_xgmii_data_d9        = 32'h07070707  ;
reg  [31:0] S_xgmii_data_d10       = 32'h07070707  ;
reg  [31:0] S_xgmii_data_d11       = 32'h07070707  ;
reg  [31:0] S_xgmii_data_d12       = 32'h07070707  ;
reg  [31:0] S_xgmii_data_d13       = 32'h07070707  ;
reg  [31:0] S_xgmii_data_d14       = 32'h07070707  ;
reg  [31:0] S_xgmii_data_d15       = 32'h07070707  ;
reg  [31:0] S_xgmii_data_d16       = 32'h07070707  ;
reg  [31:0] S_xgmii_data_d17       = 32'h07070707  ;
reg  [31:0] S_xgmii_data_d18       = 32'h07070707  ;
reg  [31:0] S_xgmii_data_d19       = 32'h07070707  ;
reg  [31:0] S_xgmii_data_d20       = 32'h07070707  ;
reg  [31:0] S_xgmii_data_d21       = 32'h07070707  ;
reg  [31:0] S_xgmii_data_d22       = 32'h07070707  ;
(*mark_debug ="true"*)reg  [31:0] S_xgmii_data_d23       = 32'h07070707  ;
reg  [31:0] S_xgmii_data_d24       = 32'h07070707  ;
reg  [31:0] S_xgmii_data_d25       = 32'h07070707  ;
reg  [31:0] S_xgmii_data_d26       = 32'h07070707  ;
reg  [31:0] S_xgmii_data_d27       = 32'h07070707  ;
reg  [31:0] S_xgmii_data_d28       = 32'h07070707  ;
reg  [31:0] S_xgmii_data_d29       = 32'h07070707  ;
reg  [31:0] S_xgmii_data_d30       = 32'h07070707  ;

reg  [3:0 ] S_xgmii_txc_d1         = 4'b1111       ;
reg  [3:0 ] S_xgmii_txc_d2         = 4'b1111       ;
reg  [3:0 ] S_xgmii_txc_d3         = 4'b1111       ;
reg  [3:0 ] S_xgmii_txc_d4         = 4'b1111       ;
reg  [3:0 ] S_xgmii_txc_d5         = 4'b1111       ;
reg  [3:0 ] S_xgmii_txc_d6         = 4'b1111       ;
reg  [3:0 ] S_xgmii_txc_d7         = 4'b1111       ;
reg  [3:0 ] S_xgmii_txc_d8         = 4'b1111       ;
reg  [3:0 ] S_xgmii_txc_d9         = 4'b1111       ;
reg  [3:0 ] S_xgmii_txc_d10        = 4'b1111       ;
reg  [3:0 ] S_xgmii_txc_d11        = 4'b1111       ;
reg  [3:0 ] S_xgmii_txc_d12        = 4'b1111       ;
reg  [3:0 ] S_xgmii_txc_d13        = 4'b1111       ;
reg  [3:0 ] S_xgmii_txc_d14        = 4'b1111       ;
reg  [3:0 ] S_xgmii_txc_d15        = 4'b1111       ;
reg  [3:0 ] S_xgmii_txc_d16        = 4'b1111       ;
reg  [3:0 ] S_xgmii_txc_d17        = 4'b1111       ;
reg  [3:0 ] S_xgmii_txc_d18        = 4'b1111       ;
reg  [3:0 ] S_xgmii_txc_d19        = 4'b1111       ;
reg  [3:0 ] S_xgmii_txc_d20        = 4'b1111       ;
reg  [3:0 ] S_xgmii_txc_d21        = 4'b1111       ;
reg  [3:0 ] S_xgmii_txc_d22        = 4'b1111       ;
(*mark_debug ="true"*)reg  [3:0 ] S_xgmii_txc_d23        = 4'b1111       ;
reg  [3:0 ] S_xgmii_txc_d24        = 4'b1111       ;
reg  [3:0 ] S_xgmii_txc_d25        = 4'b1111       ;
reg  [3:0 ] S_xgmii_txc_d26        = 4'b1111       ;
reg  [3:0 ] S_xgmii_txc_d27        = 4'b1111       ;
reg  [3:0 ] S_xgmii_txc_d28        = 4'b1111       ;
reg  [3:0 ] S_xgmii_txc_d29        = 4'b1111       ;
reg  [3:0 ] S_xgmii_txc_d30        = 4'b1111       ;

reg  [1:0]  S_xgmii_err_d1         = 2'b0          ;
reg  [1:0]  S_xgmii_err_d2         = 2'b0          ;
reg  [1:0]  S_xgmii_err_d3         = 2'b0          ;
reg  [1:0]  S_xgmii_err_d4         = 2'b0          ;
reg  [1:0]  S_xgmii_err_d5         = 2'b0          ;
reg  [1:0]  S_xgmii_err_d6         = 2'b0          ;
reg  [1:0]  S_xgmii_err_d7         = 2'b0          ;
reg  [1:0]  S_xgmii_err_d8         = 2'b0          ;
reg  [1:0]  S_xgmii_err_d9         = 2'b0          ;
reg  [1:0]  S_xgmii_err_d10        = 2'b0          ;
reg  [1:0]  S_xgmii_err_d11        = 2'b0          ;
reg  [1:0]  S_xgmii_err_d12        = 2'b0          ;
reg  [1:0]  S_xgmii_err_d13        = 2'b0          ;
reg  [1:0]  S_xgmii_err_d14        = 2'b0          ;
reg  [1:0]  S_xgmii_err_d15        = 2'b0          ;
reg  [1:0]  S_xgmii_err_d16        = 2'b0          ;
reg  [1:0]  S_xgmii_err_d17        = 2'b0          ;
reg  [1:0]  S_xgmii_err_d18        = 2'b0          ;
reg  [1:0]  S_xgmii_err_d19        = 2'b0          ;
reg  [1:0]  S_xgmii_err_d20        = 2'b0          ;
reg  [1:0]  S_xgmii_err_d21        = 2'b0          ;
reg  [1:0]  S_xgmii_err_d22        = 2'b0          ;
(*mark_debug ="true"*)reg  [1:0]  S_xgmii_err_d23        = 2'b0          ;
reg  [1:0]  S_xgmii_err_d24        = 2'b0          ;
reg  [1:0]  S_xgmii_err_d25        = 2'b0          ;
reg  [1:0]  S_xgmii_err_d26        = 2'b0          ;
reg  [1:0]  S_xgmii_err_d27        = 2'b0          ;
reg  [1:0]  S_xgmii_err_d28        = 2'b0          ;
reg  [1:0]  S_xgmii_err_d29        = 2'b0          ;
reg  [1:0]  S_xgmii_err_d30        = 2'b0          ;

reg  [3:0]  S_state_current_d1     = 4'd0          ;
reg  [3:0]  S_state_current_d2     = 4'd0          ;
reg  [3:0]  S_state_current_d3     = 4'd0          ;
reg  [3:0]  S_state_current_d4     = 4'd0          ;
reg  [3:0]  S_state_current_d5     = 4'd0          ;
reg  [3:0]  S_state_current_d6     = 4'd0          ;
reg  [3:0]  S_state_current_d7     = 4'd0          ;
reg  [3:0]  S_state_current_d8     = 4'd0          ;
reg  [3:0]  S_state_current_d9     = 4'd0          ;
reg  [3:0]  S_state_current_d10    = 4'd0          ;
reg  [3:0]  S_state_current_d11    = 4'd0          ;
reg  [3:0]  S_state_current_d12    = 4'd0          ;
reg  [3:0]  S_state_current_d13    = 4'd0          ;
reg  [3:0]  S_state_current_d14    = 4'd0          ;
reg  [3:0]  S_state_current_d15    = 4'd0          ;
reg  [3:0]  S_state_current_d16    = 4'd0          ;
reg  [3:0]  S_state_current_d17    = 4'd0          ;
reg  [3:0]  S_state_current_d18    = 4'd0          ;
reg  [3:0]  S_state_current_d19    = 4'd0          ;
reg  [3:0]  S_state_current_d20    = 4'd0          ;
reg  [3:0]  S_state_current_d21    = 4'd0          ;
reg  [3:0]  S_state_current_d22    = 4'd0          ;

reg  [31:0] S_xgmii_data            = 32'h07070707 ;
reg  [3:0 ] S_xgmii_txc             = 4'b1111      ;
reg  [1:0]  S_xgmii_err             = 2'b0         ;
reg         S_xgmii_err_flg         = 1'b0         ;
                                    
reg  [3:0]  S_state_current         = 4'd0         ;
(*mark_debug ="true"*)reg  [3:0]  S_state_next            = 4'd0         ;
                                    
(*mark_debug ="true"*)reg  [3:0]  S_mac_state_cnt         = 4'd0         ;
reg  [3:0]  S_type_state_cnt        = 4'd0         ;
reg  [3:0]  S_ip_state_cnt          = 4'd0         ;
reg  [3:0]  S_udp_state_cnt         = 4'd0         ;
reg  [3:0]  S_ptp_udp_state_cnt     = 4'd0         ;
(*mark_debug ="true"*)reg         S_ptp_udp_state_cnt_eq1 = 1'b0         ;       
(*mark_debug ="true"*)reg         S_ip_state_cnt_eq2      = 1'b0         ;
(*mark_debug ="true"*)reg         S_udp_state_cnt_eq2     = 1'b0         ;
(*mark_debug ="true"*)reg         S_mac_state_cnt_eq6     = 1'b0         ;

(*mark_debug ="true"*)reg         S_mac_en_first          = 1'b0         ;
(*mark_debug ="true"*)reg         S_mac_en_second         = 1'b0         ;
reg         S_mac_en_third          = 1'b0         ;
(*mark_debug ="true"*)reg         S_ptp_55d5_flg          = 1'b0         ;
                                    
(*mark_debug ="true"*)reg         S_ptp_mac_flag          = 1'b0         ;
(*mark_debug ="true"*)reg  [15:0] S_ptp_length            = 16'd0        ;
                                    
(*mark_debug ="true"*)reg         S_ptp_pack_flag         = 1'b0         ;
(*mark_debug ="true"*)reg         S_ptp_vlan_flag         = 1'b0         ;
                                                   
(*mark_debug ="true"*)reg  [15:0] S_ptp_slice_id          = 16'b0        ;
(*mark_debug ="true"*)reg  [15:0] S_vlan_type_h           = 16'b0        ;
(*mark_debug ="true"*)reg  [15:0] S_vlan_type_l           = 16'b0        ;
(*mark_debug ="true"*)reg         S_hc_ptp_flag           = 1'b0         ;
(*mark_debug ="true"*)reg         S_pla_ptp_flag          = 1'b0         ;

always @ (posedge I_clk_312m)
begin
  S_xgmii_data_d1  <= S_xgmii_data                 ; 
  S_xgmii_data_d2  <= S_xgmii_data_d1              ; 
  S_xgmii_data_d3  <= S_xgmii_data_d2              ; 
  S_xgmii_data_d4  <= S_xgmii_data_d3              ; 
  S_xgmii_data_d5  <= S_xgmii_data_d4              ; 
  S_xgmii_data_d6  <= S_xgmii_data_d5              ; 
  S_xgmii_data_d7  <= S_xgmii_data_d6              ; 
  S_xgmii_data_d8  <= S_xgmii_data_d7              ; 
  S_xgmii_data_d9  <= S_xgmii_data_d8              ; 
  S_xgmii_data_d10 <= S_xgmii_data_d9              ; 
  S_xgmii_data_d11 <= S_xgmii_data_d10             ; 
  S_xgmii_data_d12 <= S_xgmii_data_d11             ; 
  S_xgmii_data_d13 <= S_xgmii_data_d12             ; 
  S_xgmii_data_d14 <= S_xgmii_data_d13             ; 
  S_xgmii_data_d15 <= S_xgmii_data_d14             ; 
  S_xgmii_data_d16 <= S_xgmii_data_d15             ; 
  S_xgmii_data_d17 <= S_xgmii_data_d16             ; 
  S_xgmii_data_d18 <= S_xgmii_data_d17             ; 
  S_xgmii_data_d19 <= S_xgmii_data_d18             ; 
  S_xgmii_data_d20 <= S_xgmii_data_d19             ; 
  S_xgmii_data_d21 <= S_xgmii_data_d20             ; 
  S_xgmii_data_d22 <= S_xgmii_data_d21             ; 
  S_xgmii_data_d23 <= S_xgmii_data_d22             ; 
  S_xgmii_data_d24 <= S_xgmii_data_d23             ; 
  S_xgmii_data_d25 <= S_xgmii_data_d24             ; 
  S_xgmii_data_d26 <= S_xgmii_data_d25             ; 
  S_xgmii_data_d27 <= S_xgmii_data_d26             ; 
  S_xgmii_data_d28 <= S_xgmii_data_d27             ; 
  S_xgmii_data_d29 <= S_xgmii_data_d28             ; 
  S_xgmii_data_d30 <= S_xgmii_data_d29             ; 
end

always @ (posedge I_clk_312m)
begin
  S_xgmii_txc_d1  <= S_xgmii_txc                 ; 
  S_xgmii_txc_d2  <= S_xgmii_txc_d1              ; 
  S_xgmii_txc_d3  <= S_xgmii_txc_d2              ; 
  S_xgmii_txc_d4  <= S_xgmii_txc_d3              ; 
  S_xgmii_txc_d5  <= S_xgmii_txc_d4              ; 
  S_xgmii_txc_d6  <= S_xgmii_txc_d5              ; 
  S_xgmii_txc_d7  <= S_xgmii_txc_d6              ; 
  S_xgmii_txc_d8  <= S_xgmii_txc_d7              ; 
  S_xgmii_txc_d9  <= S_xgmii_txc_d8              ; 
  S_xgmii_txc_d10 <= S_xgmii_txc_d9              ; 
  S_xgmii_txc_d11 <= S_xgmii_txc_d10             ; 
  S_xgmii_txc_d12 <= S_xgmii_txc_d11             ; 
  S_xgmii_txc_d13 <= S_xgmii_txc_d12             ; 
  S_xgmii_txc_d14 <= S_xgmii_txc_d13             ; 
  S_xgmii_txc_d15 <= S_xgmii_txc_d14             ; 
  S_xgmii_txc_d16 <= S_xgmii_txc_d15             ; 
  S_xgmii_txc_d17 <= S_xgmii_txc_d16             ; 
  S_xgmii_txc_d18 <= S_xgmii_txc_d17             ; 
  S_xgmii_txc_d19 <= S_xgmii_txc_d18             ; 
  S_xgmii_txc_d20 <= S_xgmii_txc_d19             ; 
  S_xgmii_txc_d21 <= S_xgmii_txc_d20             ; 
  S_xgmii_txc_d22 <= S_xgmii_txc_d21             ; 
  S_xgmii_txc_d23 <= S_xgmii_txc_d22             ; 
  S_xgmii_txc_d24 <= S_xgmii_txc_d23             ; 
  S_xgmii_txc_d25 <= S_xgmii_txc_d24             ; 
  S_xgmii_txc_d26 <= S_xgmii_txc_d25             ; 
  S_xgmii_txc_d27 <= S_xgmii_txc_d26             ; 
  S_xgmii_txc_d28 <= S_xgmii_txc_d27             ; 
  S_xgmii_txc_d29 <= S_xgmii_txc_d28             ; 
  S_xgmii_txc_d30 <= S_xgmii_txc_d29             ; 
end

always @ (posedge I_clk_312m)
begin
  S_xgmii_err_d1  <= S_xgmii_err                 ; 
  S_xgmii_err_d2  <= S_xgmii_err_d1              ; 
  S_xgmii_err_d3  <= S_xgmii_err_d2              ; 
  S_xgmii_err_d4  <= S_xgmii_err_d3              ; 
  S_xgmii_err_d5  <= S_xgmii_err_d4              ; 
  S_xgmii_err_d6  <= S_xgmii_err_d5              ; 
  S_xgmii_err_d7  <= S_xgmii_err_d6              ; 
  S_xgmii_err_d8  <= S_xgmii_err_d7              ; 
  S_xgmii_err_d9  <= S_xgmii_err_d8              ; 
  S_xgmii_err_d10 <= S_xgmii_err_d9              ; 
  S_xgmii_err_d11 <= S_xgmii_err_d10             ; 
  S_xgmii_err_d12 <= S_xgmii_err_d11             ; 
  S_xgmii_err_d13 <= S_xgmii_err_d12             ; 
  S_xgmii_err_d14 <= S_xgmii_err_d13             ; 
  S_xgmii_err_d15 <= S_xgmii_err_d14             ; 
  S_xgmii_err_d16 <= S_xgmii_err_d15             ; 
  S_xgmii_err_d17 <= S_xgmii_err_d16             ; 
  S_xgmii_err_d18 <= S_xgmii_err_d17             ; 
  S_xgmii_err_d19 <= S_xgmii_err_d18             ; 
  S_xgmii_err_d20 <= S_xgmii_err_d19             ; 
  S_xgmii_err_d21 <= S_xgmii_err_d20             ; 
  S_xgmii_err_d22 <= S_xgmii_err_d21             ; 
  S_xgmii_err_d23 <= S_xgmii_err_d22             ; 
  S_xgmii_err_d24 <= S_xgmii_err_d23             ; 
  S_xgmii_err_d25 <= S_xgmii_err_d24             ; 
  S_xgmii_err_d26 <= S_xgmii_err_d25             ; 
  S_xgmii_err_d27 <= S_xgmii_err_d26             ; 
  S_xgmii_err_d28 <= S_xgmii_err_d27             ; 
  S_xgmii_err_d29 <= S_xgmii_err_d28             ; 
  S_xgmii_err_d30 <= S_xgmii_err_d29             ; 
end                 

always @ (posedge I_clk_312m)
begin
  S_state_current_d1  <= S_state_current         ; 
  S_state_current_d2  <= S_state_current_d1      ; 
  S_state_current_d3  <= S_state_current_d2      ; 
  S_state_current_d4  <= S_state_current_d3      ; 
  S_state_current_d5  <= S_state_current_d4      ; 
  S_state_current_d6  <= S_state_current_d5      ; 
  S_state_current_d7  <= S_state_current_d6      ; 
  S_state_current_d8  <= S_state_current_d7      ; 
  S_state_current_d9  <= S_state_current_d8      ;  
  S_state_current_d10 <= S_state_current_d9      ;        
  S_state_current_d11 <= S_state_current_d10     ;
  S_state_current_d12 <= S_state_current_d11     ;
  S_state_current_d13 <= S_state_current_d12     ;
  S_state_current_d14 <= S_state_current_d13     ;
  S_state_current_d15 <= S_state_current_d14     ;
  S_state_current_d16 <= S_state_current_d15     ; 
  S_state_current_d17 <= S_state_current_d16     ; 
  S_state_current_d18 <= S_state_current_d17     ; 
  S_state_current_d19 <= S_state_current_d18     ;  
  S_state_current_d20 <= S_state_current_d19     ;        
  S_state_current_d21 <= S_state_current_d20     ;
  S_state_current_d22 <= S_state_current_d21     ;
end                     
                      
always @ (posedge I_clk_312m)
begin
  S_xgmii_data <= I_xgmii_data  ; 
  S_xgmii_txc  <= I_xgmii_txc   ;
  S_xgmii_err  <= I_xgmii_err   ;
end

always @ (posedge I_clk_312m)
begin
  if(|S_xgmii_txc)
    begin
      S_xgmii_err_flg <= 1'b1;
    end
  else
    begin
      S_xgmii_err_flg <= 1'b0;
    end
end

always @ (posedge I_clk_312m)
begin
  if(I_rst)
    begin
      S_state_current <= C_XGMII_IDLE ;
    end                               
  else                                
    begin                             
      S_state_current <= S_state_next ;
    end
end

always @ (*)
begin
  case(S_state_current)
    C_XGMII_IDLE :
    begin
      if((S_xgmii_txc == 4'b1000) && (S_xgmii_data == 32'hfb555555))
        begin
          S_state_next = C_XGMII_PRE;
        end
      else
        begin
          S_state_next = C_XGMII_IDLE;
        end
    end
    C_XGMII_PRE  :
    begin
      if(|S_xgmii_txc)
        begin
          S_state_next = C_XGMII_IDLE;
        end
      else if(S_xgmii_data == 32'h555555d5)
        begin
          S_state_next = C_XGMII_MAC;
        end
      else
        begin
          S_state_next = C_XGMII_IDLE;
        end
    end
    C_XGMII_MAC  :
    begin
      if(|S_xgmii_txc)
        begin
          S_state_next = C_XGMII_IDLE;
        end
      else if(S_mac_state_cnt_eq6)
        begin
          S_state_next = C_XGMII_TYPE;
        end
      else
        begin
          S_state_next = C_XGMII_MAC;
        end
    end 
    C_XGMII_TYPE :
    begin
      if(S_xgmii_err_flg)
        begin
          S_state_next = C_XGMII_IDLE;
        end
      else if(S_xgmii_data[15:0]== C_XGMII_VLAN_TYPE)
        begin
          S_state_next = C_XGMII_TYPE;
        end
      else if(S_xgmii_data[15:0]== C_XGMII_IP_TYPE)
        begin
          S_state_next = C_XGMII_IP;
        end
      else if(S_xgmii_data[15:0]== C_XGMII_PTP_TYPE)
        begin
          S_state_next = C_XGMII_PTP;
        end
      else
        begin
          S_state_next = C_XGMII_DATA;
        end
    end       
    C_XGMII_IP   :
    begin
      if(S_xgmii_err_flg)
        begin
          S_state_next = C_XGMII_IDLE;
        end
      else if(S_ip_state_cnt_eq2)
        begin
          if(S_xgmii_data[23:16]== C_XGMII_UDP_TYPE)
            begin
              S_state_next = C_XGMII_UDP;
            end
          else
            begin
              S_state_next = C_XGMII_DATA;
            end
        end
      else
        begin
          S_state_next = C_XGMII_IP;
        end
    end
    C_XGMII_UDP :
    begin
      if(S_xgmii_err_flg)
        begin
          S_state_next = C_XGMII_IDLE;
        end
      else if(S_udp_state_cnt_eq2)
        begin
          if(S_xgmii_data[15:0]== C_XGMII_UDP_PTP)
            begin
              S_state_next = C_XGMII_PTP_UDP;
            end
          else
            begin
              S_state_next = C_XGMII_DATA;
            end
        end
      else
          begin
              S_state_next = C_XGMII_UDP;
          end
    end
    C_XGMII_PTP_UDP  :
    begin
      if(S_xgmii_err_flg)
        begin
          S_state_next = C_XGMII_IDLE;
        end
      else if(S_ptp_udp_state_cnt_eq1)
      	begin
      	  if((S_xgmii_data[31:24]== C_XGMII_UDP_SUB_PTP0)||(S_xgmii_data[31:24]== C_XGMII_UDP_SUB_PTP1))
            begin
              S_state_next = C_XGMII_SUB_PTP;
            end
          else
            begin
              S_state_next = C_XGMII_DATA;
            end
      	end
      else
        begin
          S_state_next = C_XGMII_PTP_UDP;
        end
    end
    C_XGMII_PTP:
    begin
      if(S_xgmii_err_flg)
        begin
          S_state_next = C_XGMII_IDLE;
        end
      else if(((S_xgmii_data[31:24]== C_XGMII_UDP_SUB_PTP0)||(S_xgmii_data[31:24]== C_XGMII_UDP_SUB_PTP1))&& S_mac_en_first && S_mac_en_second)
        begin
          S_state_next = C_XGMII_SUB_PTP;
        end
      else
        begin
          S_state_next = C_XGMII_DATA;
        end
    end
    C_XGMII_SUB_PTP:
    begin
      if(S_xgmii_err_flg)
        begin
          S_state_next = C_XGMII_IDLE;
        end
      else
        begin
          S_state_next = C_XGMII_DATA;
        end
    end
    C_XGMII_DATA :
    begin
      if(S_xgmii_err_flg)
        begin
          S_state_next = C_XGMII_IDLE;
        end
      else
        begin
          S_state_next = C_XGMII_DATA;
        end
    end
    default :
      begin
        S_state_next = C_XGMII_IDLE;
      end
  endcase
end

always @ (posedge I_clk_312m)
begin
  if(S_state_current == C_XGMII_MAC)
  	begin
  		if(S_mac_state_cnt == 4'd5)
  			S_mac_state_cnt <= 4'd0 ;
  		else
  			S_mac_state_cnt <= S_mac_state_cnt + 4'd1;
  	end
  else
  		S_mac_state_cnt <= 4'd0;
end

always @ (posedge I_clk_312m)
begin
  if(S_state_current == C_XGMII_TYPE)
  	begin
  		if(S_type_state_cnt == 4'd1)
  			S_type_state_cnt <= 4'd0 ;
  		else
  			S_type_state_cnt <= S_type_state_cnt + 4'd1;
  	end
  else
  		S_type_state_cnt <= 4'd0;
end

always @ (posedge I_clk_312m)
begin
  if(S_state_current == C_XGMII_IP)
  	begin
  		if(S_ip_state_cnt == 4'd2)
  			S_ip_state_cnt <= 4'd0 ;
  		else
  			S_ip_state_cnt <= S_ip_state_cnt + 4'd1;
  	end
  else
  		S_ip_state_cnt <= 4'd0;
end

always @ (posedge I_clk_312m)
begin
  if(S_state_current == C_XGMII_UDP)
  	begin
  		if(S_udp_state_cnt == 4'd2)
  			S_udp_state_cnt <= 4'd0 ;
  		else
  			S_udp_state_cnt <= S_udp_state_cnt + 4'd1;
  	end
  else
  		S_udp_state_cnt <= 4'd0;
end

always @ (posedge I_clk_312m)
begin
  if(S_state_current == C_XGMII_PTP_UDP)
  	begin
  		if(S_ptp_udp_state_cnt == 4'd1)
  			S_ptp_udp_state_cnt <= 4'd0 ;
  		else
  			S_ptp_udp_state_cnt <= S_ptp_udp_state_cnt + 4'd1;
  	end
  else
  		S_ptp_udp_state_cnt <= 4'd0;
end

always @ (posedge I_clk_312m)
begin
  if((S_ptp_udp_state_cnt == 4'd0) && (S_state_current == C_XGMII_PTP_UDP))
    begin
      S_ptp_udp_state_cnt_eq1 <= 1'b1;
    end
  else
    begin
      S_ptp_udp_state_cnt_eq1 <= 1'b0;
    end
end

always @ (posedge I_clk_312m)
begin
  if(S_ip_state_cnt == 4'd1)
    begin
      S_ip_state_cnt_eq2 <= 1'b1;
    end
  else
    begin
      S_ip_state_cnt_eq2 <= 1'b0;
    end
end

always @ (posedge I_clk_312m)
begin
  if(S_udp_state_cnt == 4'd1)
    begin
      S_udp_state_cnt_eq2 <= 1'b1;
    end
  else
    begin
      S_udp_state_cnt_eq2 <= 1'b0;
    end
end

always @ (posedge I_clk_312m)
begin
  if(S_mac_state_cnt == 4'd5)
    begin
      S_mac_state_cnt_eq6 <= 1'b1;
    end
  else
    begin
      S_mac_state_cnt_eq6 <= 1'b0;
    end
end

always @ (posedge I_clk_312m)
begin
  if(S_state_current == C_XGMII_IDLE)
    begin
      S_mac_en_first <=1'b0 ;
    end
  else if(S_state_current == C_XGMII_MAC )        
    begin
      if((S_mac_state_cnt == 4'd4)&& (S_xgmii_data[15:0] == I_ptp_dmac[47:32]) )
        begin
          S_mac_en_first <= 1'b1 ;            
        end
      else
        begin
          S_mac_en_first <= S_mac_en_first ;
        end
    end        
end

always @ (posedge I_clk_312m)
begin
  if(S_state_current == C_XGMII_IDLE)
    begin
      S_mac_en_second <= 1'b0 ;
    end
  else if(S_state_current == C_XGMII_MAC )        
    begin
      if((S_mac_state_cnt == 4'd5)&& (S_xgmii_data == I_ptp_dmac[31:0]))
        begin
          S_mac_en_second <= 1'b1 ;            
        end
      else
        begin
          S_mac_en_second <= S_mac_en_second ;
        end
    end        
end

//always @ (posedge I_clk_312m)
//begin
//  if(S_state_current == C_XGMII_IDLE)
//    begin
//      S_mac_en_third <= 1'b0 ;
//    end
//  else if(S_state_current == C_XGMII_MAC )        
//    begin
//      if((S_mac_state_cnt==4'd2)&& (S_xgmii_data == I_pla_smac[31:0]) )
//        begin
//          S_mac_en_third <= 1'b1 ;            
//        end
//      else
//        begin
//          S_mac_en_third <= S_mac_en_third ;
//        end
//    end      
//end

always @ (posedge I_clk_312m)
begin
  if(S_state_current == C_XGMII_IDLE)
    begin
      S_ptp_55d5_flg <= 1'b0 ;
    end
  else if(S_state_current == C_XGMII_MAC )        
    begin
      if((S_mac_state_cnt == 4'd3)&& (S_xgmii_data[15:0] == 16'h55d5) )
        begin
          S_ptp_55d5_flg <= 1'b1 ;            
        end
      else
        begin
          S_ptp_55d5_flg <= S_ptp_55d5_flg ;
        end
    end      
end

always @ (posedge I_clk_312m)
begin
  if(S_state_current == C_XGMII_IDLE)
    begin
      S_ptp_mac_flag <= 1'b0 ;
    end
  else if((S_state_current == C_XGMII_MAC) && S_mac_en_second && S_mac_en_first)
    begin
//      S_ptp_mac_flag <= S_ptp_55d5_flg & S_mac_en_second & S_mac_en_first ;
      S_ptp_mac_flag <=  1'b1;
    end     
end

always @ (posedge I_clk_312m)
begin
  if(S_state_current == C_XGMII_IDLE)
    begin
      S_ptp_length <= 16'b0 ;
    end
  else if ((S_state_current==C_XGMII_MAC) && (S_mac_state_cnt == 4'd4))
    begin
      S_ptp_length <= S_xgmii_data[31:16];
    end     
end

always @ (posedge I_clk_312m)
begin
	if(S_state_current == C_XGMII_IDLE)
    begin
      S_hc_ptp_flag <= 1'b0 ;
    end
  else if(!S_ptp_length[15])
    begin
      S_hc_ptp_flag <= 1'b1 ;
    end
end

always @ (posedge I_clk_312m)
begin
	if(S_state_current == C_XGMII_IDLE)
    begin
    	S_pla_ptp_flag <= 1'b0;
    end
  else if(S_ptp_length[13])
    begin
      S_pla_ptp_flag <= 1'b1;
    end     
end

always @ (posedge I_clk_312m)
begin
  if(I_rst)
    begin
      S_ptp_pack_flag <= 1'b0;
    end
  else if (S_state_current == C_XGMII_IDLE)
    begin
      S_ptp_pack_flag <= 1'b0;
    end
  else if((S_state_current == C_XGMII_SUB_PTP) && S_hc_ptp_flag && S_pla_ptp_flag)
    begin
       S_ptp_pack_flag <= 1'b1;
    end        
end

always @ (posedge I_clk_312m)
begin
  if(I_rst)
    begin
      S_ptp_vlan_flag <= 1'b0;
    end
  else if (S_state_current == C_XGMII_IDLE)
    begin
      S_ptp_vlan_flag <= 1'b0;
    end
  else if((S_state_current == C_XGMII_TYPE) && (S_type_state_cnt== 4'd0) && S_xgmii_data[15:0]==16'h8100) 
    begin
       S_ptp_vlan_flag <= 1'b1;
    end        
end

always @ (posedge I_clk_312m)
begin
  if(I_rst)
    begin
      S_ptp_slice_id <= 16'b0;
    end
  else if (S_state_current == C_XGMII_IDLE)
    begin
      S_ptp_slice_id <= 16'b0;
    end
  else if((S_state_current == C_XGMII_MAC)&& (S_mac_state_cnt == 4'd3)) 
    begin
      S_ptp_slice_id <= S_xgmii_data[31:16];
    end        
end

always @ (posedge I_clk_312m)
begin
  if(I_rst)
    begin
      S_vlan_type_h <= 16'b0;
    end
  else if (S_state_current == C_XGMII_IDLE)
    begin
      S_vlan_type_h <= 16'b0;
    end
  else if((S_state_current == C_XGMII_TYPE)&& (S_type_state_cnt == 4'd0)) 
    begin
      S_vlan_type_h <= S_xgmii_data[15:0];
    end        
end

always @ (posedge I_clk_312m)
begin
  if(I_rst)
    begin
      S_vlan_type_l <= 16'b0;
    end
  else if (S_state_current == C_XGMII_IDLE)
    begin
      S_vlan_type_l <= 16'b0;
    end
  else if((S_state_current == C_XGMII_TYPE)&& (S_type_state_cnt == 4'd1)) 
    begin
      S_vlan_type_l <= S_xgmii_data[31:16];
    end        
end

always @ (posedge I_clk_312m)
begin
  if(S_state_current_d22 == C_XGMII_IDLE)
    begin
      O_ptp_pack_flag <= 1'b0 ;
      O_ptp_vlan_flag <= 1'b0 ;
      O_ptp_length    <= 16'b0;
      O_slice_id      <= 16'b0;
      O_vlan_type     <= 32'b0;
    end
  else if (S_state_current_d22 == C_XGMII_PRE)
    begin
       O_ptp_pack_flag <= S_ptp_pack_flag && S_ptp_55d5_flg   ;
       O_ptp_vlan_flag <= S_ptp_vlan_flag && S_ptp_pack_flag && S_ptp_55d5_flg ;
       O_ptp_length    <= S_ptp_length                                      ;
       O_slice_id      <= S_ptp_slice_id                                    ;
       O_vlan_type     <= {S_vlan_type_h,S_vlan_type_l}                     ;
    end
end  

always @ (posedge I_clk_312m)
begin
  O_xgmii_err  <= S_xgmii_err_d23;
  O_xgmii_data <= S_xgmii_data_d23 ;
  O_xgmii_txc  <= S_xgmii_txc_d23;    
end

always @ (posedge I_clk_312m)
begin
  if(I_rd_cnt_clr)
  	O_pkt_cnt_slice_in <= 32'd0 ;
  else if(!I_xgmii_txc[3] && S_xgmii_txc[3])
  	O_pkt_cnt_slice_in <= O_pkt_cnt_slice_in + 32'd1 ;
end

endmodule



