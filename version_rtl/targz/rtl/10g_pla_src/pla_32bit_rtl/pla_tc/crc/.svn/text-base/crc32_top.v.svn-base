//FILE_HEADER-----------------------------------------------------------------
//ZTE  Copyright (C)
//ZTE Company Confidential
//----------------------------------------------------------------------------
//Project Name : rtuh
//FILE NAME    : crc32_top.v
//AUTHOR       : jiang weiwei
//Department   : ZTE-MW
//Email        : jiang.weiwei@zte.com.cn
//----------------------------------------------------------------------------
//Module Hiberarchy :
//x                 |--U0_crc32_d32
//x                 |--U0_crc32_d24
//x crc32_top-------|--U0_crc32_d16 (为该模块包含的下一级子模块名，仅限一级，不需往下延伸，
//x                 |--U0_crc32_d8   如该模块没有下层模块，可不填)
//x                 |--xxx5
//----------------------------------------------------------------------------
//Relaese History :
//----------------------------------------------------------------------------
//Version         Date           Author        Description
// 1.1          06-10-2014    jiang weiwei    32bitCRC校验算法 
// 1.2           
//----------------------------------------------------------------------------
//Main Function:
//a)高位优先  初始全1  输入数据按字节取反
//b)xxxxxxxx
//----------------------------------------------------------------------------
//REUSE ISSUES: xxxxxxxx
//Reset Strategy: xxxxxxxx
//Clock Strategy: xxxxxxxx
//Critical Timing: xxxxxxxx
//Asynchronous Interface: xxxxxxxx
//END_HEADER------------------------------------------------------------------

`timescale 1 ns/1 ps

module crc32_top
    (
        input              I_rst    	           ,  ///复位信号，高有效                  
        input              I_sys_clk	           ,  ///系统时钟                         
        input      [31:0]  I_crc_data	           ,  ///Gmii数据              
        input      [3:0]   I_xgmii_ctl	         ,  ///EGMII数据奇偶标识  
                
        output reg [31:0]  O_crc_out                ///  
    ); 
    
    reg [31:0]  S_crc_data_d1     ;
    reg [3:0]   S_xgmii_ctl_d1    ;
    reg [3:0]   S_xgmii_ctl_d2    ;
    
    reg         S_crc_d32_rst     ;
    wire        S_crc_d32_en      ;
    
    wire        S_crc_other_rst   ;
    wire        S_crc_other_en    ;
    
    wire [31:0] S_crc_32bit_result;   
    wire [31:0] S_crc_pre_result  ; 
    wire [31:0] S_crc_24bit_result;        
    wire [31:0] S_crc_16bit_result;        
    wire [31:0] S_crc_8bit_result ;    
    
    always @(posedge I_sys_clk or posedge I_rst)
    begin
        if(I_rst)
        	begin
            S_crc_data_d1 <= 32'b0;
          end
        else
        	begin
            S_crc_data_d1 <= I_crc_data; 
          end                     
    end            
    
    always @(posedge I_sys_clk or posedge I_rst)
    begin
        if(I_rst)
        	begin
            S_xgmii_ctl_d1 <= 4'b0;
            S_xgmii_ctl_d2 <= 4'b0;
          end
        else
        	begin
            S_xgmii_ctl_d1 <= I_xgmii_ctl; 
            S_xgmii_ctl_d2 <= S_xgmii_ctl_d1; 
          end                     
    end            
    
    always @(posedge I_sys_clk or posedge I_rst)
    begin
        if(I_rst)
            S_crc_d32_rst <= 1'b1;
        else if(I_xgmii_ctl == 4'd8)
        	  S_crc_d32_rst <= 1'b1; 
        else if(I_xgmii_ctl == 4'd0 && I_crc_data[7:0] == 8'hd5)
            S_crc_d32_rst <= 1'b0; 
    end            

assign   S_crc_d32_en = (I_xgmii_ctl == 4'hf && S_xgmii_ctl_d1 == 4'h0) ? 1'b0 : (~S_xgmii_ctl_d2[3]);
              
assign   S_crc_other_rst = (I_xgmii_ctl == 4'h0) ? 1'b1 : 1'b0 ;      
assign   S_crc_other_en =  (|I_xgmii_ctl == 1'h1 && S_xgmii_ctl_d1 == 4'h0) ? 1'b1 : 1'b0; 

    crc32_d32 U0_crc32_d32
    (    
        .clk    (I_sys_clk),    
        .reset  (S_crc_d32_rst), 
        .d      (S_crc_data_d1),      
        .calc   (S_crc_d32_en),   
        .init   (1'b0),   
        .d_valid(1'b1),
        .c      (S_crc_pre_result),      
        .crc_out(S_crc_32bit_result)
    );
    
    crc32_d24 U0_crc32_d24
    (    
        .clk       (I_sys_clk),    
        .reset     (S_crc_other_rst), 
        .result_pre(S_crc_pre_result),
        .d         (S_crc_data_d1[31:8]),      
        .calc      (S_crc_other_en),   
        .init      (1'b0),   
        .d_valid   (1'b1),
        .c         (),      
        .crc_out   (S_crc_24bit_result)
    );
    
    crc32_d16 U0_crc32_d16
    (    
        .clk       (I_sys_clk),    
        .reset     (S_crc_other_rst), 
        .result_pre(S_crc_pre_result),
        .d         (S_crc_data_d1[31:16]),      
        .calc      (S_crc_other_en),   
        .init      (1'b0),   
        .d_valid   (1'b1),
        .c         (),      
        .crc_out   (S_crc_16bit_result)
    );
    
    crc32_d8 U0_crc32_d8
    (    
        .clk       (I_sys_clk),    
        .reset     (S_crc_other_rst), 
        .result_pre(S_crc_pre_result),
        .d         (S_crc_data_d1[31:24]),      
        .calc      (S_crc_other_en),   
        .init      (1'b0),   
        .d_valid   (1'b1),
        .c         (),      
        .crc_out   (S_crc_8bit_result)
    );
    
    always @(posedge I_sys_clk or posedge I_rst)
    begin
        if(I_rst)
        	  O_crc_out <= 32'b0;  
        else if(I_xgmii_ctl == 4'hf)
        begin
          case(S_xgmii_ctl_d1)
          	  4'h0: O_crc_out <= S_crc_32bit_result;
          	  4'h1: O_crc_out <= S_crc_24bit_result; 
          	  4'h3: O_crc_out <= S_crc_16bit_result; 
          	  4'h7: O_crc_out <= S_crc_8bit_result; 
          	  default:;
          endcase
        end	
    end            

endmodule 
