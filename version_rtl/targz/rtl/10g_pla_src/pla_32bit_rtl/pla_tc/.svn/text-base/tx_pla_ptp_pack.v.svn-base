module tx_pla_ptp_pack
(      
    input              I_rst                           ,
    input              I_clk_312m                      ,
    input      [31:0]  I_xgmii_data                    ,    
    input      [3:0 ]  I_xgmii_txc                     ,    
    input      [1:0]   I_xgmii_err                     ,    
    input      [3:0]   I_state_current                 ,    
    input      [15:0]  I_slice_id                      ,
    input      [31:0]  I_vlan_type                     ,
    input      [15:0]  I_ptp_length                    ,
    input              I_ptp_vlan_flag                 ,
    input              I_ptp_pack_flag                 ,
                                                       
    input              I_rd_cnt_clr                    ,
    
    output reg [31:0]  O_ptp_cnt_in         = 32'd0    ,
    output reg [31:0]  O_vlan_ptp_cnt_in    = 32'd0    ,
    output reg [31:0]  O_ptp_no_vlan_cnt_out= 32'd0    ,
    output reg [31:0]  O_ptp_vlan_cnt_out   = 32'd0    ,
    output reg [31:0]  O_slice_cnt_out      = 32'd0    ,
    output reg [31:0]  O_packet_cnt_out     = 32'd0    ,
                                                       
    output     [31:0]  O_xgmii_data                    ,      
    output     [3:0 ]  O_xgmii_txc                     ,
    output     [1:0]   O_xgmii_err                     ,          

    output reg [31:0]  O_xgmii_ptp_data = 32'h07070707 ,
    output reg [3:0 ]  O_xgmii_ptp_txc  = 4'b1111      ,
    output reg [1:0]   O_xgmii_ptp_err  = 2'b0          
    
);

reg           S_pack_cnt_start    = 1'd0         ;
(*mark_debug ="true"*)reg    [7:0]  S_pack_cnt          = 8'd0         ;
(*mark_debug ="true"*)reg    [7:0]  S_ptp_pack_cnt      = 8'd0         ;
reg    [7:0]  S_pack_cnt_d1       = 8'd0         ;
(*mark_debug ="true"*)reg    [31:0] S_xgmii_data_pack_1 = 32'h07070707 ;
(*mark_debug ="true"*)reg    [3:0]  S_xgmii_txc_pack_1  = 4'b1111      ;
(*mark_debug ="true"*)reg    [31:0] S_xgmii_data_pack_2 = 32'h07070707 ;
(*mark_debug ="true"*)reg    [3:0]  S_xgmii_txc_pack_2  = 4'b1111      ;
(*mark_debug ="true"*)reg    [31:0] S_xgmii_data_pack_3 = 32'h07070707 ;
(*mark_debug ="true"*)reg    [3:0]  S_xgmii_txc_pack_3  = 4'b1111      ;
                                                 
reg    [3:0]  S_txc_pack_1_d1     = 4'b1111      ;
reg    [3:0]  S_txc_pack_2_d1     = 4'b1111      ;
reg    [3:0]  S_txc_pack_3_d1     = 4'b1111      ;

(*mark_debug ="true"*)reg    [31:0] S_crc_data          = 32'h07070707 ;
reg    [31:0] S_crc_data_d1       = 32'h07070707 ;
reg    [31:0] S_crc_data_d2       = 32'h07070707 ;
reg    [31:0] S_crc_data_d3       = 32'h07070707 ;
reg    [3:0]  S_crc_txc           = 4'b1111      ;
reg    [3:0]  S_crc_txc_d1        = 4'b1111      ;
reg    [3:0]  S_crc_txc_d2        = 4'b1111      ;
reg    [3:0]  S_crc_txc_d3        = 4'b1111      ;
(*mark_debug ="true"*)reg           S_ptp_pack_flag_d1  = 1'b0         ;
reg           S_ptp_pack_flag_d2  = 1'b0         ;
reg           S_ptp_pack_flag_d3  = 1'b0         ;
reg           S_ptp_pack_flag_d4  = 1'b0         ;
reg           S_ptp_pack_flag_d5  = 1'b0         ;
(*mark_debug ="true"*)reg           S_ptp_pack_flag_d6  = 1'b0         ;
reg           S_ptp_pack_flag_d7  = 1'b0         ;
reg           S_ptp_pack_flag_d8  = 1'b0         ;
reg           S_ptp_pack_flag_d9  = 1'b0         ;
reg           S_ptp_pack_flag_d10 = 1'b0         ;
reg           S_ptp_pack_flag_d11 = 1'b0         ;
                                                 
reg           S_ptp_vlan_flag_d1  = 1'b0         ;
reg           S_ptp_vlan_flag_d2  = 1'b0         ;
reg           S_ptp_vlan_flag_d3  = 1'b0         ;
reg           S_ptp_vlan_flag_d4  = 1'b0         ;
reg           S_ptp_vlan_flag_d5  = 1'b0         ;
(*mark_debug ="true"*)reg           S_ptp_vlan_flag_d6  = 1'b0         ;
reg           S_ptp_vlan_flag_d7  = 1'b0         ;

(*mark_debug ="true"*)wire   [31:0] S_crc_out                          ;

reg  [31:0] S_xgmii_data_d1       = 32'h07070707 ;
(*mark_debug ="true"*)reg  [31:0] S_xgmii_data_d2       = 32'h07070707 ;
reg  [31:0] S_xgmii_data_d3       = 32'h07070707 ;
reg  [31:0] S_xgmii_data_d4       = 32'h07070707 ;
reg  [31:0] S_xgmii_data_d5       = 32'h07070707 ;
reg  [31:0] S_xgmii_data_d6       = 32'h07070707 ;
reg  [31:0] S_xgmii_data_d7       = 32'h07070707 ;
reg  [31:0] S_xgmii_data_d8       = 32'h07070707 ;
reg  [31:0] S_xgmii_data_d9       = 32'h07070707 ;
(*mark_debug ="true"*)reg  [31:0] S_xgmii_data_d10      = 32'h07070707 ;

reg  [3:0 ] S_xgmii_txc_d1        = 4'b1111      ;
(*mark_debug ="true"*)reg  [3:0 ] S_xgmii_txc_d2        = 4'b1111      ;
reg  [3:0 ] S_xgmii_txc_d3        = 4'b1111      ;
reg  [3:0 ] S_xgmii_txc_d4        = 4'b1111      ;
reg  [3:0 ] S_xgmii_txc_d5        = 4'b1111      ;
reg  [3:0 ] S_xgmii_txc_d6        = 4'b1111      ;
reg  [3:0 ] S_xgmii_txc_d7        = 4'b1111      ;
reg  [3:0 ] S_xgmii_txc_d8        = 4'b1111      ;
reg  [3:0 ] S_xgmii_txc_d9        = 4'b1111      ;
(*mark_debug ="true"*)reg  [3:0 ] S_xgmii_txc_d10       = 4'b1111      ;

reg  [1:0]  S_xgmii_err_d1        = 2'b0         ;
reg  [1:0]  S_xgmii_err_d2        = 2'b0         ;
reg  [1:0]  S_xgmii_err_d3        = 2'b0         ;
reg  [1:0]  S_xgmii_err_d4        = 2'b0         ;
reg  [1:0]  S_xgmii_err_d5        = 2'b0         ;
reg  [1:0]  S_xgmii_err_d6        = 2'b0         ;
reg  [1:0]  S_xgmii_err_d7        = 2'b0         ;
reg  [1:0]  S_xgmii_err_d8        = 2'b0         ;
reg  [1:0]  S_xgmii_err_d9        = 2'b0         ;
reg  [1:0]  S_xgmii_err_d10       = 2'b0         ;
(*mark_debug ="true"*)reg  [1:0]  S_xgmii_err_d11       = 2'b0         ;

reg  [15:0] S_slice_id_d1         = 16'd0        ;
reg  [15:0] S_slice_id_d2         = 16'd0        ;
reg  [15:0] S_slice_id_d3         = 16'd0        ;
reg  [15:0] S_slice_id_d4         = 16'd0        ;
reg  [15:0] S_slice_id_d5         = 16'd0        ;
(*mark_debug ="true"*)reg  [15:0] S_slice_id_d6         = 16'd0        ;

reg  [31:0] S_vlan_type_d1        = 32'd0        ;
reg  [31:0] S_vlan_type_d2        = 32'd0        ;
reg  [31:0] S_vlan_type_d3        = 32'd0        ;
reg  [31:0] S_vlan_type_d4        = 32'd0        ;
reg  [31:0] S_vlan_type_d5        = 32'd0        ;
(*mark_debug ="true"*)reg  [31:0] S_vlan_type_d6        = 32'd0        ;

reg  [15:0] S_ptp_length_d1       = 16'd0        ;
reg  [15:0] S_ptp_length_d2       = 16'd0        ;
reg  [15:0] S_ptp_length_d3       = 16'd0        ;
reg  [15:0] S_ptp_length_d4       = 16'd0        ;
reg  [15:0] S_ptp_length_d5       = 16'd0        ;
(*mark_debug ="true"*)reg  [15:0] S_ptp_length_d6       = 16'd0        ; 

(*mark_debug ="true"*)reg  [31:0]  S_xgmii_data = 32'h07070707     ;      
(*mark_debug ="true"*)reg  [3:0 ]  S_xgmii_txc  = 4'b1111          ;
(*mark_debug ="true"*)reg  [1:0]   S_xgmii_err  = 2'b0             ;          

assign    O_xgmii_data = S_xgmii_data ;
assign    O_xgmii_txc  = S_xgmii_txc  ;
assign    O_xgmii_err  = S_xgmii_err  ;

always @ (posedge I_clk_312m)
begin
  S_xgmii_data_d1 <= I_xgmii_data                ; 
  S_xgmii_data_d2 <= S_xgmii_data_d1             ; 
  S_xgmii_data_d3 <= S_xgmii_data_d2             ; 
  S_xgmii_data_d4 <= S_xgmii_data_d3             ; 
  S_xgmii_data_d5 <= S_xgmii_data_d4             ; 
  S_xgmii_data_d6 <= S_xgmii_data_d5             ; 
  S_xgmii_data_d7 <= S_xgmii_data_d6             ; 
  S_xgmii_data_d8 <= S_xgmii_data_d7             ; 
  S_xgmii_data_d9 <= S_xgmii_data_d8             ; 
  S_xgmii_data_d10<= S_xgmii_data_d9             ; 
end

always @ (posedge I_clk_312m)
begin
  S_xgmii_txc_d1 <= I_xgmii_txc                ; 
  S_xgmii_txc_d2 <= S_xgmii_txc_d1             ; 
  S_xgmii_txc_d3 <= S_xgmii_txc_d2             ; 
  S_xgmii_txc_d4 <= S_xgmii_txc_d3             ; 
  S_xgmii_txc_d5 <= S_xgmii_txc_d4             ; 
  S_xgmii_txc_d6 <= S_xgmii_txc_d5             ; 
  S_xgmii_txc_d7 <= S_xgmii_txc_d6             ; 
  S_xgmii_txc_d8 <= S_xgmii_txc_d7             ; 
  S_xgmii_txc_d9 <= S_xgmii_txc_d8             ; 
  S_xgmii_txc_d10 <= S_xgmii_txc_d9            ; 
end

always @ (posedge I_clk_312m)
begin
  S_xgmii_err_d1 <= I_xgmii_err                ; 
  S_xgmii_err_d2 <= S_xgmii_err_d1             ; 
  S_xgmii_err_d3 <= S_xgmii_err_d2             ; 
  S_xgmii_err_d4 <= S_xgmii_err_d3             ; 
  S_xgmii_err_d5 <= S_xgmii_err_d4             ; 
  S_xgmii_err_d6 <= S_xgmii_err_d5             ; 
  S_xgmii_err_d7 <= S_xgmii_err_d6             ; 
  S_xgmii_err_d8 <= S_xgmii_err_d7             ; 
  S_xgmii_err_d9 <= S_xgmii_err_d8             ; 
  S_xgmii_err_d10<= S_xgmii_err_d9             ;
  S_xgmii_err_d11<= S_xgmii_err_d10            ;
end

always @ (posedge I_clk_312m)
begin
  S_slice_id_d1 <= I_slice_id                ; 
  S_slice_id_d2 <= S_slice_id_d1             ; 
  S_slice_id_d3 <= S_slice_id_d2             ; 
  S_slice_id_d4 <= S_slice_id_d3             ; 
  S_slice_id_d5 <= S_slice_id_d4             ; 
  S_slice_id_d6 <= S_slice_id_d5             ; 
end                

always @ (posedge I_clk_312m)
begin
  S_vlan_type_d1 <= I_vlan_type                ; 
  S_vlan_type_d2 <= S_vlan_type_d1             ; 
  S_vlan_type_d3 <= S_vlan_type_d2             ; 
  S_vlan_type_d4 <= S_vlan_type_d3             ; 
  S_vlan_type_d5 <= S_vlan_type_d4             ; 
  S_vlan_type_d6 <= S_vlan_type_d5             ; 
end                 

always @ (posedge I_clk_312m)
begin
  S_ptp_length_d1 <= I_ptp_length               ; 
  S_ptp_length_d2 <= S_ptp_length_d1            ; 
  S_ptp_length_d3 <= S_ptp_length_d2            ; 
  S_ptp_length_d4 <= S_ptp_length_d3            ; 
  S_ptp_length_d5 <= S_ptp_length_d4            ; 
  S_ptp_length_d6 <= S_ptp_length_d5            ; 
end                  

always @ (posedge I_clk_312m)
begin
  S_ptp_pack_flag_d1 <= I_ptp_pack_flag    ;
  S_ptp_pack_flag_d2 <= S_ptp_pack_flag_d1 ;
  S_ptp_pack_flag_d3 <= S_ptp_pack_flag_d2 ;
  S_ptp_pack_flag_d4 <= S_ptp_pack_flag_d3 ;
  S_ptp_pack_flag_d5 <= S_ptp_pack_flag_d4 ;
  S_ptp_pack_flag_d6 <= S_ptp_pack_flag_d5 ;
  S_ptp_pack_flag_d7 <= S_ptp_pack_flag_d6 ;
  S_ptp_pack_flag_d8 <= S_ptp_pack_flag_d7 ;
  S_ptp_pack_flag_d9 <= S_ptp_pack_flag_d8 ;
  S_ptp_pack_flag_d10<= S_ptp_pack_flag_d9 ;
  S_ptp_pack_flag_d11<= S_ptp_pack_flag_d10;
  
  S_ptp_vlan_flag_d1 <= I_ptp_vlan_flag    ;
  S_ptp_vlan_flag_d2 <= S_ptp_vlan_flag_d1 ;
  S_ptp_vlan_flag_d3 <= S_ptp_vlan_flag_d2 ;
  S_ptp_vlan_flag_d4 <= S_ptp_vlan_flag_d3 ;
  S_ptp_vlan_flag_d5 <= S_ptp_vlan_flag_d4 ;
  S_ptp_vlan_flag_d6 <= S_ptp_vlan_flag_d5 ;
  S_ptp_vlan_flag_d7 <= S_ptp_vlan_flag_d6 ;
end      

always @ (posedge I_clk_312m)
begin
	if((S_xgmii_data_d5 == 32'hfb555555) && (S_xgmii_txc_d5 == 4'b1000))
		S_pack_cnt_start <= 1'b1 ;
	else
		S_pack_cnt_start <= S_pack_cnt_start ;
end      

always @ (posedge I_clk_312m)
begin
	if((S_xgmii_data_d5 == 32'hfb555555) && (S_xgmii_txc_d5 == 4'b1000) && S_ptp_pack_flag_d5)
		S_pack_cnt <= 8'd0;
	else if(S_pack_cnt == 8'd71)
		S_pack_cnt <= S_pack_cnt;
	else if(S_pack_cnt_start)
		S_pack_cnt <= S_pack_cnt + 8'd1;
end

always @ (posedge I_clk_312m)
begin
  S_pack_cnt_d1      <= S_pack_cnt      ;
end      

always @ (posedge I_clk_312m)
begin
	if((S_xgmii_data_d10 == 32'hfb555555) && (S_xgmii_txc_d10 == 4'b1000))
		S_ptp_pack_cnt <= 8'd0;
	else if(S_ptp_pack_cnt == 8'd71)
		S_ptp_pack_cnt <= S_ptp_pack_cnt;
	else if(S_pack_cnt_start)
		S_ptp_pack_cnt <= S_ptp_pack_cnt + 8'd1;
end

always @ (posedge I_clk_312m)
begin
	if(S_ptp_pack_flag_d6 && !S_ptp_vlan_flag_d6)
		begin
	      case(S_pack_cnt)
	      	8'd0:
	      	begin
	      		S_xgmii_data_pack_1 <= 32'hfb555555;
	      		S_xgmii_txc_pack_1  <= 4'b1000     ;
	      	end
	      	8'd1:
	      	begin
	      		S_xgmii_data_pack_1 <= 32'h555555d5;
	      		S_xgmii_txc_pack_1  <= 4'b0        ;
	      	end
	      	8'd65,8'd66,8'd67:
	      	begin
	      		S_xgmii_data_pack_1 <= 32'h0       ;
	      		S_xgmii_txc_pack_1  <= 4'b0        ;
	      	end
	      	8'd68:
	      	begin
	      		S_xgmii_data_pack_1 <= {16'd0,S_slice_id_d6};
	      		S_xgmii_txc_pack_1  <= 4'b0 ;
	      	end
	      	8'd69:
	      	begin
	      		S_xgmii_data_pack_1 <= {S_ptp_length_d6,16'd0};
	      		S_xgmii_txc_pack_1  <= 4'b0 ;
	      	end
	      	8'd70:
	      	begin
	      		S_xgmii_data_pack_1 <= {16'd0,16'hfd07};
	      		S_xgmii_txc_pack_1  <= 4'b0011 ;
	      	end
	        default:
	        begin
	      		S_xgmii_data_pack_1 <= {S_xgmii_data_d2[15:0],S_xgmii_data_d1[31:16]};
	      		S_xgmii_txc_pack_1  <= 4'b0 ;
	        end
	      endcase
    end
  else
  	begin
	    S_xgmii_data_pack_1 <= 32'h07070707;
	    S_xgmii_txc_pack_1  <= 4'b1111 ;
  	end
end

always @ (posedge I_clk_312m)
begin
	if(S_ptp_pack_flag_d6 && S_ptp_vlan_flag_d6)
		begin
	      case(S_pack_cnt)
	      	8'd0:
	      	begin
	      		S_xgmii_data_pack_2 <= 32'hfb555555;
	      		S_xgmii_txc_pack_2  <= 4'b1000     ;
	      	end
	      	8'd1:
	      	begin
	      		S_xgmii_data_pack_2 <= 32'h555555d5;
	      		S_xgmii_txc_pack_2  <= 4'b0        ;
	      	end
      	8'd2,8'd3,8'd4:
	      	begin
	      		S_xgmii_data_pack_2 <= {S_xgmii_data_d2[15:0],S_xgmii_data_d1[31:16]};
	      		S_xgmii_txc_pack_2  <= 4'b0        ;
	      	end
	      	8'd64,8'd65,8'd66:
	      	begin
	      		S_xgmii_data_pack_2 <= 32'h0       ;
	      		S_xgmii_txc_pack_2  <= 4'b0        ;
	      	end
	      	8'd67:
	      	begin
	      		S_xgmii_data_pack_2 <= {16'd0,S_vlan_type_d6[31:16]};
	      		S_xgmii_txc_pack_2  <= 4'b0        ;
	      	end
	      	8'd68:
	      	begin
	      		S_xgmii_data_pack_2 <= {S_vlan_type_d6[15:0],S_slice_id_d6};
	      		S_xgmii_txc_pack_2  <= 4'b0        ;
	      	end
	      	8'd69:
	      	begin
	      		S_xgmii_data_pack_2 <= {S_ptp_length_d6,16'd0};
	      		S_xgmii_txc_pack_2  <= 4'b0 ;
	      	end
	      	8'd70:
	      	begin
	      		S_xgmii_data_pack_2 <= {16'd0,16'hfd07};
	      		S_xgmii_txc_pack_2  <= 4'b0011 ;
	      	end
	        default:
	        begin
	      		S_xgmii_data_pack_2 <= {S_xgmii_data_d1[15:0],I_xgmii_data[31:16]};
	      		S_xgmii_txc_pack_2  <= 4'b0 ;
	        end
	      endcase
    end
  else
  	begin
	    S_xgmii_data_pack_2 <= 32'h07070707;
	    S_xgmii_txc_pack_2  <= 4'b1111 ;
  	end
end

always @ (posedge I_clk_312m)
begin
	if(!S_ptp_pack_flag_d10)
  	begin
	    S_xgmii_data_pack_3 <= S_xgmii_data_d10;
	    S_xgmii_txc_pack_3  <= S_xgmii_txc_d10;
  	end
  else
  	begin
	    S_xgmii_data_pack_3 <= 32'h07070707;
	    S_xgmii_txc_pack_3  <= 4'b1111 ;
  	end
end

always @ (posedge I_clk_312m)
begin
	if(S_ptp_pack_flag_d7 && S_ptp_vlan_flag_d7)
		begin
      if(S_pack_cnt_d1 < 8'd70)
				begin
				  S_crc_data <= S_xgmii_data_pack_2 ;
				  S_crc_txc  <= S_xgmii_txc_pack_2  ;
			  end
			else if(S_pack_cnt_d1 == 8'd70)
				begin
				  S_crc_data <= S_xgmii_data_pack_2 ;
				  S_crc_txc  <= 4'b0011  ;
				end
			else
				begin
				  S_crc_data <= 32'h07070707 ;
				  S_crc_txc  <= 4'b1111      ;
				end 
		end
	else if(S_ptp_pack_flag_d7)
		begin
		  if(S_pack_cnt_d1 < 8'd70 )
				begin
				  S_crc_data <= S_xgmii_data_pack_1 ;
				  S_crc_txc  <= S_xgmii_txc_pack_1  ;
			  end
			else if(S_pack_cnt_d1 == 8'd70)
				begin
				  S_crc_data <= S_xgmii_data_pack_1 ;
				  S_crc_txc  <= 4'b0011  ;
				end
			else
				begin
				  S_crc_data <= 32'h07070707 ;
				  S_crc_txc  <= 4'b1111      ;
				end 
		end
	else
		begin
			S_crc_data <= 32'h07070707   ;
			S_crc_txc  <= 4'b1111        ;
		end
end

always @ (posedge I_clk_312m)
begin
  S_crc_data_d1 <= S_crc_data    ;
  S_crc_data_d2 <= S_crc_data_d1 ;
  S_crc_data_d3 <= S_crc_data_d2 ;
end      

always @ (posedge I_clk_312m)
begin
  S_crc_txc_d1 <= S_crc_txc    ;
  S_crc_txc_d2 <= S_crc_txc_d1 ;
  S_crc_txc_d3 <= S_crc_txc_d2 ;
end      

crc32_top U_crc32_top
    (
     .I_rst    	           (I_rst        ),               
     .I_sys_clk	           (I_clk_312m   ),               
     .I_crc_data	         (S_crc_data   ),      
     .I_xgmii_ctl	         (S_crc_txc    ),      
     .O_crc_out            (S_crc_out    )   
    ); 

always @ (posedge I_clk_312m)
begin
	if(S_ptp_pack_flag_d11)
		begin
      if(S_ptp_pack_cnt < 8'd69 )
    		begin
    		  S_xgmii_data <= S_crc_data_d3 ;
    		  S_xgmii_txc  <= S_crc_txc_d3  ;
    		  S_xgmii_err  <= S_xgmii_err_d11  ;
    		end
    	else if(S_ptp_pack_cnt == 8'd69)
    		begin
    		  S_xgmii_data <= {S_crc_data_d3[31:16],S_crc_out[31:16]};
    		  S_xgmii_txc  <= 4'b0       ;
    		  S_xgmii_err  <= S_xgmii_err_d11;
    		end
    	else if(S_ptp_pack_cnt == 8'd70)
    		begin
    		  S_xgmii_data <= {S_crc_out[15:0],16'hfd07};
    		  S_xgmii_txc  <= 4'b0011    ;
    		  S_xgmii_err  <= S_xgmii_err_d11;
    		end   
    end
	else
		begin
		  S_xgmii_data <= S_xgmii_data_pack_3;
		  S_xgmii_txc  <= S_xgmii_txc_pack_3 ;
		  S_xgmii_err  <= S_xgmii_err_d11 ;
		end
end

always @ (posedge I_clk_312m)
begin
	if(S_ptp_pack_flag_d11)
    begin
  	  if(S_ptp_pack_cnt < 8'd69 )
    	  begin
    	    O_xgmii_ptp_data <= S_crc_data_d3 ;
    	    O_xgmii_ptp_txc  <= S_crc_txc_d3  ;
    	    O_xgmii_ptp_err  <= S_xgmii_err_d11  ;
    	  end
      else if(S_ptp_pack_cnt == 8'd69)
      	begin
      	  O_xgmii_ptp_data <= {S_crc_data_d3[31:16],S_crc_out[31:16]};
      	  O_xgmii_ptp_txc  <= 4'b0       ;
      	  O_xgmii_ptp_err  <= S_xgmii_err_d11;
      	end
      else if(S_ptp_pack_cnt == 8'd70)
      	begin
      	  O_xgmii_ptp_data <= {S_crc_out[15:0],16'hfd07};
      	  O_xgmii_ptp_txc  <= 4'b0011    ;
      	  O_xgmii_ptp_err  <= S_xgmii_err_d11;
      	end   
      else
      	begin
      	  O_xgmii_ptp_data <= 32'h07070707;
      	  O_xgmii_ptp_txc  <= 4'b1111    ;
      	  O_xgmii_ptp_err  <= S_xgmii_err_d11;
      	end   
    end
	else
		begin
  	  O_xgmii_ptp_data <= 32'h07070707;
  	  O_xgmii_ptp_txc  <= 4'b1111    ;
  	  O_xgmii_ptp_err  <= S_xgmii_err_d11;
		end
end

always @ (posedge I_clk_312m)
begin
  S_txc_pack_1_d1 <= S_xgmii_txc_pack_1 ;
  S_txc_pack_2_d1 <= S_xgmii_txc_pack_2 ;
  S_txc_pack_3_d1 <= S_xgmii_txc_pack_3 ;
end

always @ (posedge I_clk_312m)
begin
  if(I_rd_cnt_clr)
  	O_ptp_cnt_in <= 32'd0 ;
  else if(I_ptp_pack_flag && !S_ptp_pack_flag_d1)
  	O_ptp_cnt_in <= O_ptp_cnt_in + 32'd1 ;
end

always @ (posedge I_clk_312m)
begin
  if(I_rd_cnt_clr)
  	O_vlan_ptp_cnt_in <= 32'd0 ;
  else if(I_ptp_vlan_flag && !S_ptp_vlan_flag_d1)
  	O_vlan_ptp_cnt_in <= O_vlan_ptp_cnt_in + 32'd1 ;
end

always @ (posedge I_clk_312m)
begin
  if(I_rd_cnt_clr)
  	O_ptp_no_vlan_cnt_out <= 32'd0 ;
  else if(!S_xgmii_txc_pack_1[3] && S_txc_pack_1_d1[3])
  	O_ptp_no_vlan_cnt_out <= O_ptp_no_vlan_cnt_out + 32'd1 ;
end

always @ (posedge I_clk_312m)
begin
  if(I_rd_cnt_clr)
  	O_ptp_vlan_cnt_out <= 32'd0 ;
  else if(!S_xgmii_txc_pack_2[3] && S_txc_pack_2_d1[3])
  	O_ptp_vlan_cnt_out <= O_ptp_vlan_cnt_out + 32'd1 ;
end

always @ (posedge I_clk_312m)
begin
  if(I_rd_cnt_clr)
  	O_slice_cnt_out <= 32'd0 ;
  else if(!S_xgmii_txc_pack_3[3] && S_txc_pack_3_d1[3])
  	O_slice_cnt_out <= O_slice_cnt_out + 32'd1 ;
end

always @ (posedge I_clk_312m)
begin
  if(I_rd_cnt_clr)
  	O_packet_cnt_out <= 32'd0 ;
  else if(!S_crc_txc[3] && S_crc_txc_d1[3])
  	O_packet_cnt_out <= O_packet_cnt_out + 32'd1 ;
end

endmodule