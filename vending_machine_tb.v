`timescale 100ns/1ps

module vending_machine_tb;

reg clk,rst;
wire [2:0] operation;

vending_machine dut (clk,rst,operation);

always #5 clk = ~clk;

initial
begin
$dumpfile("vending_machine.vcd");
$dumpvars(0,vending_machine_tb);
end

initial 
begin
clk = 0 ; rst = 1;
#7 rst = 0;
#62 rst = 1;
#9 rst = 0;
$display("operations : started(000) washing(001) spinning(010) drying(011) finished(100) halt(101)");
$monitor("time : %g clk : %b rst : %b operation : %b",$time,clk,rst,operation);
#500 $finish;
end
endmodule
