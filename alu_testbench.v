`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.08.2025 21:20:27
// Design Name: 
// Module Name: alu_testbench
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module alu_testbench ();

parameter n = 16 ;
wire sign_flag,zero_flag,overflow,done ;
wire signed [n-1:0] out ;
reg signed [n-1:0] input0,input1;
reg [4:0] control_signal;
reg sel1,sel2,sel3,clk,rst,start;

alu_design dut(out,sign_flag,zero_flag,overflow,done,input0,input1,control_signal,sel1,sel2,sel3,clk,rst,start);

always #0.3 clk = ~clk ;

initial
begin
clk = 0 ;
rst = 1 ;
start = 0;
control_signal = 5'bxxxxx;
sel1 = 1'b0 ; sel2 = 1'b0 ; sel3 = 1'b0 ;
#500 $finish;
end

initial
begin
$monitor($time," input 1 : %b input 2 : %b operation : %b result : %b",input0,input1,control_signal,out);
$dumpvars(0,alu_testbench);
$dumpfile("alu.vcd");
end

initial
begin
#0.5 control_signal = 5'd11 ;
input0 = 16'd15;input1 = 16'd20 ;rst = 0 ;
#5 control_signal = 5'd5 ;
#5 control_signal = 5'd7 ; sel1 = 1'b1 ;
#5 control_signal = 5'd9 ; sel3 = 1'b0 ;
#0.3 start = 1 ;
#5 control_signal = 5'd2 ;
#3 start = 0 ;
wait (done) ;
#0.03 rst = 1 ;
#0.03 rst = 0 ;
#5 control_signal = 5'd6 ;
#0.3 start = 1 ;
input0 = 16'd8 ; input1 = 16'd2;
#5 control_signal = 5'd2 ;
#2 start = 0 ;
end

endmodule
