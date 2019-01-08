//----------------------------------------------------------------------------
//File Name    : lzw_backward_decompress.v
//Author       : feng xiaoxiong
//----------------------------------------------------------------------------
//Module Hierarchy :
//xxx_inst |-lzw_backward_decompress_inst
//----------------------------------------------------------------------------
//Release History :
//Version         Date           Author        Description
// 1.0          2018-12-26     feng xiaoxiong    1st draft
//----------------------------------------------------------------------------
//Main Function:
//a)rebulid backward dictionary;
//b)receive compress data and look up dictionary;
//c)recover payload data;
//----------------------------------------------------------------------------
module lzw_backward_decompress(

input              I_sys_clk                     , ///system clock,250m clock                 ///
input              I_sys_rst                     , ///system reset,sync with 250m             ///
input              I_state_clr                   , ///clear state statistic                   ///
input       [22:0] I_dictionary_sync_data        , ///from tx dictionary                      ///
input       [13:0] I_dictionary_sync_addr        , ///from tx dictionary                      ///
input              I_dictionary_sync_wren        , ///from tx dictionary                      ///
input       [13:0] I_compress_data               , ///compressed data                         ///
input              I_compress_data_en            , ///compressed data en                      ///

output reg  [ 7:0] O_payload_data                , ///recovered payload data                  ///
output reg         O_payload_data_en               ///recovered payload data en               ///
);

reg         [22:0] S_dictionary_sync_data        ;
reg         [13:0] S_dictionary_sync_addr        ;
reg                S_dictionary_sync_wren        ;
reg         [13:0] S_compress_data               ;
reg                S_compress_data_en            ;

wire        [13:0] S_dictionary_addr             ;
wire        [22:0] S_dictionary_dout             ;

reg                S_fifo_rden                   ;
wire        [13:0] S_fifo_dout                   ;
wire               S_fifo_full                   ;
wire               S_fifo_empty                  ;
wire        [12:0] S_fifo_data_count             ;

wire               S_dictionary_recv_valid       ;
wire        [13:0] S_dictionary_recv_code        ;
wire        [ 7:0] S_dictionary_recv_data        ;
reg         [13:0] S_dictionary_recv_code_buf    ;
reg                S_bottom_flag                 ;
reg                S_bottom_flag_d1              ;
reg                S_clk_div2                    ;
reg                S_dictionary_recv_data_en     ;
reg                S_reverse_byte_flag           ;
reg         [ 4:0] S_reverse_byte_num            ;
reg                S_reverse_byte_num_wren       ;
reg                S_fifo_rden_d1                ;
reg                S_fifo_rden_d2                ;


//lzw decompress algorithm example,dictionary initial a(1) b(2) c(3)
//========================================================================================================
//             |    Clock Cycle                
//--------------------------------------------------------------------------------------------------------
//  variables  |    1         2        3        4        5        6        7        8        9       10    
//--------------------------------------------------------------------------------------------------------
// input code  |    1         2             4            3             5            2        3       10 
//      I      |    a         b             ab           c             ba           b        c           cc 
//      x      |    a         b        a        b        c        b        a        b        c        c 
//     Ix      |    ax        bx           abx           cx            bax          bx       cx      ccx
// Write Mem   |             ab(4)         ba(5)        abc(6)         cb(7)        bab(8)   bc(9)   cc(10)
//--------------------------------------------------------------------------------------------------------


///************************************************************************///
///                      rebuild backward dictionary                       ///
///************************************************************************///

always @(posedge I_sys_clk)
begin
    if(I_sys_rst)
    begin
        S_dictionary_sync_data <= 23'h0;
        S_dictionary_sync_addr <= 14'h0;
        S_dictionary_sync_wren <=  1'b0;
    end
    else
    begin
        S_dictionary_sync_data <= I_dictionary_sync_data;
        S_dictionary_sync_addr <= I_dictionary_sync_addr;
        S_dictionary_sync_wren <= I_dictionary_sync_wren;
    end
end


blk_mem_16k_23  blk_mem_16k_23_inst (
  .clka  (I_sys_clk             ), // input wire clka
  .rsta  (I_sys_rst             ), // input wire rsta
  .wea   (S_dictionary_sync_wren), // input wire [0 : 0] wea
  .ena   (1'b1                  ), // input wire [0 : 0] ena
  .addra (S_dictionary_sync_addr), // input wire [13 : 0] addra
  .dina  (S_dictionary_sync_data), // input wire [22 : 0] dina
  .douta (                      ), // output wire [22 : 0] douta
  .clkb  (I_sys_clk             ), // input wire clkb
  .rstb  (I_sys_rst             ), // input wire rstb
  .web   (1'b0                  ), // input wire [0 : 0] web
  .enb   (1'b1                  ), // input wire [0 : 0] enb
  .addrb (S_dictionary_addr     ), // input wire [13 : 0] addrb
  .dinb  (23'h0                 ), // input wire [22 : 0] dinb
  .doutb (S_dictionary_dout     )  // output wire [22 : 0] doutb
);

assign S_dictionary_addr       = (S_fifo_empty || S_bottom_flag) ? S_fifo_dout : S_dictionary_recv_code_buf;
assign S_dictionary_recv_valid = S_dictionary_dout[22]  ;
assign S_dictionary_recv_code  = S_dictionary_dout[21:8];
assign S_dictionary_recv_data  = S_dictionary_dout[7:0] ;
 
///************************************************************************///
///                          look up dictionary                            ///
///************************************************************************///

always @(posedge I_sys_clk)
begin
    if(I_sys_rst)
    begin
        S_compress_data    <= 14'h0;
        S_compress_data_en <= 1'b0 ;
    end
    else
    begin
        S_compress_data    <= I_compress_data   ;
        S_compress_data_en <= I_compress_data_en;
    end
end


fifo_8k_14bit   fifo_8k_14bit_inst (
  .clk       (I_sys_clk         ), // input wire clk
  .srst      (I_sys_rst         ), // input wire srst
  .din       (S_compress_data   ), // input wire [13 : 0] din
  .wr_en     (S_compress_data_en), // input wire wr_en
  .rd_en     (S_fifo_rden       ), // input wire rd_en
  .dout      (S_fifo_dout       ), // output wire [13 : 0] dout
  .full      (S_fifo_full       ), // output wire full
  .empty     (S_fifo_empty      ), // output wire empty
  .data_count(S_fifo_data_count )  // output wire [12 : 0] data_count
);


always @(posedge I_sys_clk)
begin
    if(I_sys_rst)
    begin
        S_clk_div2 <= 1'b1;
    end
    else 
    begin
        S_clk_div2 <= ~S_clk_div2;
    end
end


always @(posedge I_sys_clk)
begin
    if(I_sys_rst)
    begin
        S_fifo_rden <= 1'b0;
    end
    else if(S_clk_div2 && ~S_fifo_empty && (S_dictionary_addr[13:8] == 6'h0))
    begin
        S_fifo_rden <= 1'b1;
    end
    else
    begin
        S_fifo_rden <= 1'b0;
    end
end

always @(posedge I_sys_clk)
begin
    if(I_sys_rst)
    begin
        S_bottom_flag <= 1'b1;
    end
    else if(~S_clk_div2)
    begin
        if(S_dictionary_recv_valid && (S_dictionary_recv_code[13:0] == 14'h0))
        begin
            S_bottom_flag <= 1'b1;
        end
        else
        begin
            S_bottom_flag <= 1'b0;
        end
    end
end

always @(posedge I_sys_clk)
begin
    if(I_sys_rst)
    begin
        S_dictionary_recv_code_buf <= 14'h0;
    end
    else 
    begin
        S_dictionary_recv_code_buf <= S_dictionary_recv_code;
    end
end

always @(posedge I_sys_clk)
begin
    if(I_sys_rst)
    begin
        S_fifo_rden_d1 <= 1'b0;
        S_fifo_rden_d2 <= 1'b0;
    end
    else
    begin
        S_fifo_rden_d1 <= S_fifo_rden   ;
        S_fifo_rden_d2 <= S_fifo_rden_d1;
    end
end


always @(posedge I_sys_clk)
begin
    if(I_sys_rst)
    begin
        S_dictionary_recv_data_en <= 1'b0;
    end
    else if((~S_clk_div2) && (S_fifo_rden_d2 || (~S_bottom_flag)))
    begin
        S_dictionary_recv_data_en <= 1'b1;
    end
    else
    begin
        S_dictionary_recv_data_en <= 1'b0;
    end
end


always @(posedge I_sys_clk)
begin
    if(I_sys_rst)
    begin
        S_reverse_byte_flag <= 1'b0;
    end
    else if(~S_clk_div2 && ((~S_bottom_flag) || (S_dictionary_addr[13:8] != 6'h0)))
    begin
        S_reverse_byte_flag <= 1'b1;
    end
    else
    begin
        S_reverse_byte_flag <= 1'b0;
    end
end


always @(posedge I_sys_clk)
begin
    if(I_sys_rst)
    begin
        S_reverse_byte_num <= 5'h0;
    end
    else if(S_dictionary_recv_data_en)
    begin
        if(S_reverse_byte_flag)
        begin
            S_reverse_byte_num <= S_reverse_byte_num + 5'h1;
        end
        else
        begin
            S_reverse_byte_num <= 5'h0;
        end
    end
end

always @(posedge I_sys_clk)
begin
    if(I_sys_rst)
    begin
        S_bottom_flag_d1 <= 1'b0;
    end
    else
    begin
        S_bottom_flag_d1 <= S_bottom_flag;
    end
end

always @(posedge I_sys_clk)
begin
    if(I_sys_rst)
    begin
        S_reverse_byte_num_wren <= 1'b0;
    end
    else if(S_bottom_flag && (~S_bottom_flag_d1))
    begin
        S_reverse_byte_num_wren <= 1'b1;
    end
    else
    begin
        S_reverse_byte_num_wren <= 1'b0;
    end
end


    






endmodule


