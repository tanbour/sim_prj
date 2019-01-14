`timescale 1ns / 100ps

module tb_dut_top;

////====fsdb
initial begin
   	$helloworld;
  	$fsdbDumpvars("+fsdbfile+tb_dut_top.fsdb");
   	$fsdbDumpSVA;
end

end
