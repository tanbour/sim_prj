`timescale 1ns/100ps
module pla_backward_id_calc(
input               I_pla_312m5_clk          ,
input               I_pla_rst                ,
input     [7:0]     I_pla_air_link           ,
input     [14:0]    I_pla_slice_window       ,
input     [14:0]    I_pla_slice_id           ,
input     [7:0]     I_pla_air_index          ,
input               I_pla_slice_calc_pre     ,
input               I_pla_slice_check_ok     ,
output    [14:0]    O_pla_slice_id_a         ,
output    [14:0]    O_pla_slice_id_b         ,
output    [14:0]    O_pla_slice_id_c         ,
output    [14:0]    O_pla_slice_id_d         ,
output    [14:0]    O_pla_slice_id_e         ,
output    [14:0]    O_pla_slice_id_f         ,
output    [14:0]    O_pla_slice_id_g         ,
output    [14:0]    O_pla_slice_id_h         ,
output    [14:0]    O_pla_slice_id_max       ,
output    [14:0]    O_pla_slice_id_min		 , 
input				I_cnt_clear				 ,
output reg[ 7:0]	O_slice_id_random_order	 ,
output reg[15:0]	O_slice_id_bottom_err_cnt
);

reg       [15:0]    S_pla_slice_id_bottom             ;
reg       [7:0]     S_pla_slice_id_error              ;
reg       [14:0]    S_pla_slice_id[0:7]               ;
reg       [14:0]    S_pla_slice_id_temp[0:7]          ;

reg		[14:0]	S_pla_slice_id_1d[0:7]              ;
reg		[14:0]	S_pla_slice_id_2d[0:7]              ;
reg		[14:0]	S_pla_slice_id_3d[0:7]              ;

reg       [14:0]    S_pla_slice_id_max_temp1[0:3]     ;
reg       [14:0]    S_pla_slice_id_max_temp2[0:1]     ;
reg       [14:0]    S_pla_slice_id_max_temp3          ;
reg       [14:0]    S_pla_slice_id_max                ;
reg       [14:0]    S_pla_slice_id_min_temp1[0:3]     ;
reg       [14:0]    S_pla_slice_id_min_temp2[0:1]     ;
reg       [14:0]    S_pla_slice_id_min_temp3          ;
reg       [14:0]    S_pla_slice_id_min                ;
reg                 S_pla_slice_id_bigger_temp1[0:3]  ;
reg                 S_pla_slice_id_bigger_temp2[0:1]  ;
reg                 S_pla_slice_id_bigger_temp3       ;
reg                 S_pla_slice_id_smaller_temp1[0:3] ;
reg                 S_pla_slice_id_smaller_temp2[0:1] ;
reg                 S_pla_slice_id_smaller_temp3      ;
reg                 S_pla_slice_calc_pre_buf1 = 1'b0  ;
reg                 S_pla_slice_calc_pre_buf2 = 1'b0  ;
reg                 S_pla_slice_calc_pre_buf3 = 1'b0  ;
reg                 S_pla_slice_calc_pre_buf4 = 1'b0  ;
reg                 S_pla_slice_calc_pre_buf5 = 1'b0  ;
reg                 S_pla_slice_calc_pre_buf6 = 1'b0  ;
reg                 S_pla_slice_calc_pre_buf7 = 1'b0  ;
reg                 S_pla_slice_calc_pre_buf8 = 1'b0  ;
reg       [7:0]     S_pla_air_link                    ;

reg       [14:0]    S_slice_id_0;                  /////  ////
reg       [14:0]    S_slice_id_1;                  /////  ////
reg       [14:0]    S_slice_id_2;                  /////  ////
reg       [14:0]    S_slice_id_3;                  /////  ////
reg       [14:0]    S_slice_id_4;                  /////  ////
reg       [14:0]    S_slice_id_5;                  /////  ////
reg       [14:0]    S_slice_id_6;                  /////  ////
reg       [14:0]    S_slice_id_7;                  /////  ////


reg		[ 3:0]	S_slice_id_bottom_err_buf	= 4'h0	;
reg				S_slice_id_random_order[0:7]		;	



                               
genvar              i,j,k;


//////TEST
always @ (posedge I_pla_312m5_clk)
begin
    S_slice_id_0 <=  S_pla_slice_id_temp[0];
    S_slice_id_1 <=  S_pla_slice_id_temp[1];
    S_slice_id_2 <=  S_pla_slice_id_temp[2];
    S_slice_id_3 <=  S_pla_slice_id_temp[3];
    S_slice_id_4 <=  S_pla_slice_id_temp[4];
    S_slice_id_5 <=  S_pla_slice_id_temp[5];
    S_slice_id_6 <=  S_pla_slice_id_temp[6];
    S_slice_id_7 <=  S_pla_slice_id_temp[7];
end

always @ (posedge I_pla_312m5_clk)
begin
    S_pla_slice_calc_pre_buf1 <= I_pla_slice_calc_pre     ;
    S_pla_slice_calc_pre_buf2 <= S_pla_slice_calc_pre_buf1;
    S_pla_slice_calc_pre_buf3 <= S_pla_slice_calc_pre_buf2;
    S_pla_slice_calc_pre_buf4 <= S_pla_slice_calc_pre_buf3;
    S_pla_slice_calc_pre_buf5 <= S_pla_slice_calc_pre_buf4;
    S_pla_slice_calc_pre_buf6 <= S_pla_slice_calc_pre_buf5;
    S_pla_slice_calc_pre_buf7 <= S_pla_slice_calc_pre_buf6;
    S_pla_slice_calc_pre_buf8 <= S_pla_slice_calc_pre_buf7;
end

always @ (posedge I_pla_312m5_clk)
begin
    S_pla_slice_id_bottom <= {1'b1,I_pla_slice_id} - {1'b0,I_pla_slice_window};
end


generate
for(i=0;i<8;i=i+1)
begin:SLICE_ID0
    
    always @ (posedge I_pla_312m5_clk)
    begin
        if(I_pla_rst)
            begin
                S_pla_air_link[i] <= 1'b0;
            end
        else
            begin
                S_pla_air_link[i] <= I_pla_air_link[i];
            end
    end
    
    always @ (posedge I_pla_312m5_clk)
    begin
        if(S_pla_slice_calc_pre_buf1)
            begin
                case({S_pla_slice_id_bottom[14:13],S_pla_slice_id[i][14:13]})
                    4'b0011 :
                    begin
                        S_pla_slice_id_error[i] <= I_pla_air_link[i];
                    end
                    4'b1100 :
                    begin
                        S_pla_slice_id_error[i] <= 1'b0;
                    end
                    default:
                    begin
                        if(S_pla_slice_id_bottom[14:0] > S_pla_slice_id[i])
                            begin
                                S_pla_slice_id_error[i] <= I_pla_air_link[i];
                            end
                        else
                            begin
                                S_pla_slice_id_error[i] <= 1'b0;
                            end
                    end
                endcase
            end
    end
    
    always @ (posedge I_pla_312m5_clk)
    begin
        if(I_pla_rst)
            begin
                S_pla_slice_id_temp[i] <= 15'd0;
            end
        else if((S_pla_slice_calc_pre_buf2 && I_pla_air_index[i]) || (!I_pla_air_link[i] && I_pla_slice_calc_pre))
            begin
                S_pla_slice_id_temp[i] <= I_pla_slice_id;
            end
        else if(S_pla_slice_id_error[i])
            begin
                S_pla_slice_id_temp[i] <= S_pla_slice_id_bottom[14:0];
            end
        else if(I_pla_slice_calc_pre)
            begin
                S_pla_slice_id_temp[i] <= S_pla_slice_id[i];
            end
    end
    
    always @ (posedge I_pla_312m5_clk)
    begin
        if(I_pla_rst)
            begin
                S_pla_slice_id[i] <= 15'd0;
            end
        else if((I_pla_slice_check_ok && I_pla_air_index[i]) || (!I_pla_air_link[i] && I_pla_slice_check_ok))
            begin
                S_pla_slice_id[i] <= I_pla_slice_id;
            end
        else if(I_pla_slice_check_ok && S_pla_slice_id_error[i])
            begin
                S_pla_slice_id[i] <= S_pla_slice_id_bottom[14:0];
            end
        else if(I_pla_air_link[i] && !S_pla_air_link[i])
            begin
                S_pla_slice_id[i] <= S_pla_slice_id_max;
            end
        else
            begin
                S_pla_slice_id[i] <= S_pla_slice_id[i];
            end
    end


always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_slice_check_ok && I_pla_air_index[i]) 
	begin
		S_pla_slice_id_1d[i]	<=	I_pla_slice_id		;
		S_pla_slice_id_2d[i]	<=	S_pla_slice_id_1d[i];	 
		S_pla_slice_id_3d[i]	<=	S_pla_slice_id_2d[i];	 
	end
	else
	begin
		S_pla_slice_id_1d[i]	<=	S_pla_slice_id_1d[i];
		S_pla_slice_id_2d[i]	<=	S_pla_slice_id_2d[i];	 
		S_pla_slice_id_3d[i]	<=	S_pla_slice_id_3d[i];	 
	end
end

always @ (posedge I_pla_312m5_clk)
begin
	if(I_pla_rst || I_cnt_clear)
	begin
		S_slice_id_random_order[i]	<= 1'b0	;
	end
	else 
	begin
		case({S_pla_slice_id_1d[i][14],S_pla_slice_id_1d[i][13],
		      S_pla_slice_id_2d[i][14],S_pla_slice_id_2d[i][13],
		      S_pla_slice_id_3d[i][14],S_pla_slice_id_3d[i][13]})
		6'b001111:
		begin
			if(S_pla_slice_id_2d[i] <= S_pla_slice_id_3d[i] )
			begin
				S_slice_id_random_order[i]	<= 1'b1	;
			end
		end
		6'b000011:
		begin
			if(S_pla_slice_id_1d[i] <= S_pla_slice_id_2d[i] )
			begin
				S_slice_id_random_order[i]	<= 1'b1	;
			end
		end
		default:
		begin
			if( (S_pla_slice_id_1d[i] <= S_pla_slice_id_2d[i]) )
			begin
				S_slice_id_random_order[i]	<= 1'b1	;
			end
		end
		endcase
	end
end

end //// end for generate

endgenerate

generate
for(j=0;j<4;j=j+1)
begin:SLICE_ID1
    always @ (posedge I_pla_312m5_clk)
    begin
        if(I_pla_rst)
            begin
                S_pla_slice_id_bigger_temp1[j] <= 1'b0;
            end 
        else if(S_pla_slice_calc_pre_buf3)
            begin
                if(S_pla_slice_id_temp[0+j] > S_pla_slice_id_temp[4+j])
                    begin
                        S_pla_slice_id_bigger_temp1[j] <= 1'b1;
                    end
                else
                    begin
                        S_pla_slice_id_bigger_temp1[j] <= 1'b0;
                    end
            end
        else
            begin
                S_pla_slice_id_bigger_temp1[j] <= 1'b0;
            end
    end
    
    always @ (posedge I_pla_312m5_clk)
    begin
        if(I_pla_rst)
            begin
                S_pla_slice_id_max_temp1[j] <= 15'd0;
                S_pla_slice_id_min_temp1[j] <= 15'd0;
            end
        else if(S_pla_slice_calc_pre_buf4)
            begin
                case({S_pla_slice_id_temp[0+j][14:13],S_pla_slice_id_temp[4+j][14:13]})
                    4'b0011 :
                    begin
                        S_pla_slice_id_max_temp1[j] <= S_pla_slice_id_temp[0+j];
                        S_pla_slice_id_min_temp1[j] <= S_pla_slice_id_temp[4+j];
                    end
                    4'b1100 :
                    begin
                        S_pla_slice_id_max_temp1[j] <= S_pla_slice_id_temp[4+j];
                        S_pla_slice_id_min_temp1[j] <= S_pla_slice_id_temp[0+j];
                    end
                    default :
                    begin
                        if(S_pla_slice_id_bigger_temp1[j])
                            begin
                                S_pla_slice_id_max_temp1[j] <= S_pla_slice_id_temp[0+j];
                                S_pla_slice_id_min_temp1[j] <= S_pla_slice_id_temp[4+j];
                            end
                        else
                            begin
                                S_pla_slice_id_max_temp1[j] <= S_pla_slice_id_temp[4+j];
                                S_pla_slice_id_min_temp1[j] <= S_pla_slice_id_temp[0+j];
                            end
                    end
                endcase
            end
    end
end
endgenerate

generate
for(k=0;k<2;k=k+1)
begin:SLICE_ID2
    always @ (posedge I_pla_312m5_clk)
    begin
        if(I_pla_rst)
            begin
                S_pla_slice_id_bigger_temp2[k] <= 1'b0;
            end
        else if(S_pla_slice_calc_pre_buf5)
            begin
                if(S_pla_slice_id_max_temp1[0+k] > S_pla_slice_id_max_temp1[2+k])
                    begin
                        S_pla_slice_id_bigger_temp2[k] <= 1'b1;
                    end
                else
                    begin
                        S_pla_slice_id_bigger_temp2[k] <= 1'b0;
                    end
            end
        else
            begin
                S_pla_slice_id_bigger_temp2[k] <= 1'b0;
            end
    end
    
    always @ (posedge I_pla_312m5_clk)
    begin
        if(I_pla_rst)
            begin
                S_pla_slice_id_smaller_temp2[k] <= 1'b0;
            end
        else if(S_pla_slice_calc_pre_buf5)
            begin
                if(S_pla_slice_id_min_temp1[0+k] < S_pla_slice_id_min_temp1[2+k])
                    begin
                        S_pla_slice_id_smaller_temp2[k] <= 1'b1;
                    end
                else
                    begin
                        S_pla_slice_id_smaller_temp2[k] <= 1'b0;
                    end
            end
        else
            begin
                S_pla_slice_id_smaller_temp2[k] <= 1'b0;
            end
    end
    
    always @ (posedge I_pla_312m5_clk)
    begin
        if(I_pla_rst)
            begin
                S_pla_slice_id_max_temp2[k] <= 15'd0;
            end
        else if(S_pla_slice_calc_pre_buf6)
            begin
                case({S_pla_slice_id_max_temp1[0+k][14:13],S_pla_slice_id_max_temp1[2+k][14:13]})
                    4'b0011:
                    begin
                        S_pla_slice_id_max_temp2[k] <= S_pla_slice_id_max_temp1[0+k];
                    end
                    4'b1100:
                    begin
                        S_pla_slice_id_max_temp2[k] <= S_pla_slice_id_max_temp1[2+k];
                    end
                    default:
                    begin
                        if(S_pla_slice_id_bigger_temp2[k])
                            begin
                                S_pla_slice_id_max_temp2[k] <= S_pla_slice_id_max_temp1[0+k];
                            end
                        else
                            begin
                                S_pla_slice_id_max_temp2[k] <= S_pla_slice_id_max_temp1[2+k];
                            end
                    end
                endcase
            end
    end
    
    always @ (posedge I_pla_312m5_clk)
    begin
        if(I_pla_rst)
            begin
                S_pla_slice_id_min_temp2[k] <= 15'd0;
            end
        else if(S_pla_slice_calc_pre_buf6)
            begin
                case({S_pla_slice_id_min_temp1[0+k][14:13],S_pla_slice_id_min_temp1[2+k][14:13]})
                    4'b0011:
                    begin
                        S_pla_slice_id_min_temp2[k] <= S_pla_slice_id_min_temp1[2+k];
                    end
                    4'b1100:
                    begin
                        S_pla_slice_id_min_temp2[k] <= S_pla_slice_id_min_temp1[0+k];
                    end
                    default:
                    begin
                        if(S_pla_slice_id_smaller_temp2[k])
                            begin
                                S_pla_slice_id_min_temp2[k] <= S_pla_slice_id_min_temp1[0+k];
                            end
                        else
                            begin
                                S_pla_slice_id_min_temp2[k] <= S_pla_slice_id_min_temp1[2+k];
                            end
                    end
                endcase
            end
    end
    
end
endgenerate

always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_pla_slice_id_bigger_temp3 <= 1'b0;
        end
    else if(S_pla_slice_calc_pre_buf7)
        begin
            if(S_pla_slice_id_max_temp2[0] > S_pla_slice_id_max_temp2[1])
                begin
                    S_pla_slice_id_bigger_temp3 <= 1'b1;
                end
            else
                begin
                    S_pla_slice_id_bigger_temp3 <= 1'b0;
                end
        end
    else
        begin
            S_pla_slice_id_bigger_temp3 <= 1'b0;
        end
end

always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_pla_slice_id_smaller_temp3 <= 1'b0;
        end
    else if(S_pla_slice_calc_pre_buf7)
        begin
            if(S_pla_slice_id_min_temp2[0] < S_pla_slice_id_min_temp2[1])
                begin
                    S_pla_slice_id_smaller_temp3 <= 1'b1;
                end
            else
                begin
                    S_pla_slice_id_smaller_temp3 <= 1'b0;
                end
        end
    else
        begin
            S_pla_slice_id_smaller_temp3 <= 1'b0;
        end
end

always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_pla_slice_id_max_temp3 <= 15'd0;
        end
    else if(S_pla_slice_calc_pre_buf8)
        begin
            case({S_pla_slice_id_max_temp2[0][14:13],S_pla_slice_id_max_temp2[1][14:13]})
                4'b0011:
                begin
                    S_pla_slice_id_max_temp3 <= S_pla_slice_id_max_temp2[0];
                end
                4'b1100:
                begin
                    S_pla_slice_id_max_temp3 <= S_pla_slice_id_max_temp2[1];
                end
                default:
                begin
                    if(S_pla_slice_id_bigger_temp3)
                        begin
                            S_pla_slice_id_max_temp3 <= S_pla_slice_id_max_temp2[0];
                        end
                    else
                        begin
                            S_pla_slice_id_max_temp3 <= S_pla_slice_id_max_temp2[1];
                        end
                end
            endcase
        end
end

always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_pla_slice_id_min_temp3 <= 15'd0;
        end
    else if(S_pla_slice_calc_pre_buf8)
        begin
            case({S_pla_slice_id_min_temp2[0][14:13],S_pla_slice_id_min_temp2[1][14:13]})
                4'b0011:
                begin
                    S_pla_slice_id_min_temp3 <= S_pla_slice_id_min_temp2[1];
                end
                4'b1100:
                begin
                    S_pla_slice_id_min_temp3 <= S_pla_slice_id_min_temp2[0];
                end
                default:
                begin
                    if(S_pla_slice_id_smaller_temp3)
                        begin
                            S_pla_slice_id_min_temp3 <= S_pla_slice_id_min_temp2[0];
                        end
                    else
                        begin
                            S_pla_slice_id_min_temp3 <= S_pla_slice_id_min_temp2[1];
                        end
                end
            endcase
        end
end

always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst)
        begin
            S_pla_slice_id_max <= 15'd0;
            S_pla_slice_id_min <= 15'd0;
        end
    else if(I_pla_slice_check_ok)
        begin
            S_pla_slice_id_max <= S_pla_slice_id_max_temp3;
            S_pla_slice_id_min <= S_pla_slice_id_min_temp3;
        end
end

assign O_pla_slice_id_max = S_pla_slice_id_max;
assign O_pla_slice_id_min = S_pla_slice_id_min;

assign O_pla_slice_id_a   = S_pla_slice_id[0];
assign O_pla_slice_id_b   = S_pla_slice_id[1];
assign O_pla_slice_id_c   = S_pla_slice_id[2];
assign O_pla_slice_id_d   = S_pla_slice_id[3];
assign O_pla_slice_id_e   = S_pla_slice_id[4];
assign O_pla_slice_id_f   = S_pla_slice_id[5];
assign O_pla_slice_id_g   = S_pla_slice_id[6];
assign O_pla_slice_id_h   = S_pla_slice_id[7];

//====maintenance
always @ (posedge I_pla_312m5_clk)
begin
	S_slice_id_bottom_err_buf	<= {S_slice_id_bottom_err_buf[2:0],|S_pla_slice_id_error }	;
end

always @ (posedge I_pla_312m5_clk)
begin
    if(I_pla_rst || I_cnt_clear)
	begin
		O_slice_id_bottom_err_cnt	<= 16'h0								;
	end
	else if(S_slice_id_bottom_err_buf[3:2] == 2'b01)
	begin
		O_slice_id_bottom_err_cnt	<= O_slice_id_bottom_err_cnt +	16'h1	;
	end
	else
	begin
		O_slice_id_bottom_err_cnt	<= O_slice_id_bottom_err_cnt			; 
	end
end


always @ (posedge I_pla_312m5_clk)
begin
	O_slice_id_random_order	<= {S_slice_id_random_order[7],
	                           	S_slice_id_random_order[6],
	                           	S_slice_id_random_order[5],
	                           	S_slice_id_random_order[4],
	                           	S_slice_id_random_order[3],
	                           	S_slice_id_random_order[2],
	                           	S_slice_id_random_order[1],
	                           	S_slice_id_random_order[0]};
end


/////---------------------------------------------------------
///// debug	begin
/////---------------------------------------------------------
(*MARK_DEBUG ="true"*)reg   [ 7:0]  dbg_S_slice_id_random_order		;
(*MARK_DEBUG ="true"*)reg			dbg_S_slice_id_bottom_err_buf2	; 


always @ (posedge I_pla_312m5_clk )
begin
    dbg_S_slice_id_random_order		<= O_slice_id_random_order		;   
	dbg_S_slice_id_bottom_err_buf2	<= S_slice_id_bottom_err_buf[2]	;
end

/////---------------------------------------------------------
///// debug end	
/////---------------------------------------------------------


endmodule
