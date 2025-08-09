`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.07.2025 20:05:20
// Design Name: alu
// Module Name: alu_design
// Project Name: parameterized 16 bit alu
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


module alu_design(out,sign_flag,zero_flag,overflow,done,input0,input1,control_signal,sel1,sel2,sel3,clk,rst,start);

parameter n = 16 ;
input signed [n-1:0] input0,input1 ;
output reg signed [n-1:0] out ;
output reg sign_flag,zero_flag,overflow;
output done;
input [4:0] control_signal;
input clk,rst,start;
input sel1,sel2,sel3;

wire signed [n-1:0] sum;
wire [n-1:0] carry;
wire overflow_add;

wire signed [n-1:0] diff;
wire [n-1:0] borrow;
wire overflow_sub;

genvar i ;

wire signed [n-1:0] quotient,remainder;

wire [n-1:0] and_result,or_result,xor_result,nor_result;

wire signed [n-1:0] result0,result1;

wire [n-1:0] lsl0,lsl1,lsr1,lsr0; 

parameter 
add = 4'd0, subtract = 4'd1, divide = 4'd2, 
AND = 4'd3, OR = 4'd4, XOR = 4'd5, NOR = 4'd6, LSL = 4'd7, LSR = 4'd8, ASR = 4'd9, equal = 4'd10, great = 4'd11, less = 4'd12;

signed_addition add_inst (sum,overflow_add,input0,input1,1'b0);
signed_subtraction sub_inst (diff,overflow_sub,input0,input1,1'b1);
asr asr_inst0 (result0,input0) ;
asr asr_inst1 (result1,input1) ;
lsl lsl_inst0 (lsl0,input0) ;
lsl lsl_inst1 (lsl1,input1) ;
lsr lsr_inst0 (lsr0,input0) ;
lsr lsr_inst1 (lsr1,input1) ;
AND g1 (and_result,input0,input1);
OR g2 (or_result,input0,input1);
XOR g3 (xor_result,input0,input1);
NOR g4 (nor_result,input0,input1);
signed_division divide_inst (quotient,remainder,input0,input1,clk,rst,start,done);

always @(posedge clk or posedge rst)
begin

if (rst)
begin
out <= 16'd0;
sign_flag <= 1'b0;
zero_flag <= 1'b0;
overflow <= 1'b0;
end

else
begin
case (control_signal)
add:
begin
out <= sum;
zero_flag <= (sum == 16'd0);
overflow <= overflow_add;
sign_flag <= sum[15];
end

subtract:
begin
out <= diff;
zero_flag <= (diff == 16'd0);
overflow <= overflow_sub;
sign_flag <= diff[15];
end

divide:
begin
if (done)
begin
out <= quotient;
zero_flag <= (quotient == 16'd0);
overflow <= 1'b0;
sign_flag <= quotient[15];
end
end

AND:
begin
out <= and_result;
zero_flag <= (and_result == 16'd0);
overflow <= 1'b0;
sign_flag <= and_result[15];
end

OR:
begin
out <= or_result;
zero_flag <= (or_result == 16'd0);
overflow <= 1'b0;
sign_flag <= or_result[15];
end

XOR:
begin
out <= xor_result;
zero_flag <= (xor_result == 16'd0);
overflow <= 1'b0;
sign_flag <= xor_result[15];
end

NOR:
begin
out <= nor_result;
zero_flag <= (nor_result == 16'd0);
overflow <= 1'b0;
sign_flag <= nor_result[15];
end

LSL:
begin
out <= (sel1)?lsl1:lsl0;
zero_flag <= (lsl0 == 16'd0);
overflow <= 1'b0;
sign_flag <= lsl0[15];
end

LSR:
begin
out <= (sel2) ? lsr1:lsr0;
zero_flag <= (lsr1 == 16'd0);
overflow <= 1'b0;
sign_flag <= lsr1[15];
end

ASR:
begin
out <= (sel3) ? result1 : result0;
zero_flag <= (out == 16'd0);
overflow <= 1'b0;
sign_flag <= out[15];
end

equal:
begin
out <= (input0 == input1) ? 16'd1 : 16'd0;
zero_flag <= (out == 16'd0);
overflow <= 1'b0;
sign_flag <= 1'b0;
end

less:
begin
out <= (input0 < input1) ? 16'd1 : 16'd0;
zero_flag <= (out == 16'd0);
overflow <= 1'b0;
sign_flag <= 1'b0;
end

great:
begin
out <= (input0 > input1) ? 16'd1 : 16'd0;
zero_flag <= (out == 16'd0);
overflow <= 1'b0;
sign_flag <= 1'b0;
end

default : 
begin
out <= 16'd0;
zero_flag <= (out == 16'd0);
overflow <= 1'b0;
sign_flag <= 1'b0;
end

endcase
end
end

endmodule

module full_adder (sum,cout,a,b,cin);

input a,b,cin;
output sum,cout;

wire temp,temp1,temp2,temp3;

xor x (sum,a,b,cin);

and a1 (temp1,a,b);
and a2 (temp2,b,cin);
and a3 (temp3,cin,a);

or o (cout,temp1,temp2,temp3);

endmodule

module signed_addition (sum,overflow,a,b,cin);

parameter n = 16 ;
input [n-1:0] a,b ;
input cin ;
output signed [n-1:0] sum ;
output reg overflow;

wire [16:0] carry ;

assign carry[0] = cin ;

genvar i ;

generate 
for (i = 0 ; i < n ; i= i + 1)
begin : fa_loop
full_adder fa (sum[i],carry[i+1],a[i],b[i],carry[i]);
end
endgenerate

always @(carry[n-1],carry[n]) overflow = carry[n-1] ^ carry[n] ;

endmodule

module signed_subtraction (diff,overflow,a,b,bin);

parameter n = 16 ;
input [n-1:0] a,b;
input bin;
output reg overflow;
output signed [n-1:0] diff;

wire [n:0] borrow;
wire [n-1:0] b_inverted;

assign borrow[0] = bin ;
assign b_inverted = ~b ;

genvar i;
generate 
for (i = 0 ; i < n ; i= i + 1)
begin : fa_loop
full_adder fa (diff[i],borrow[i+1],a[i],b_inverted[i],borrow[i]);
end
endgenerate

always @(borrow[n-1],borrow[n]) overflow = borrow[n-1] ^ borrow[n] ;

endmodule

module asr (y,a);

parameter n = 16 ;
input [n-1:0] a ;
output [n-1:0] y ;

genvar i;
generate
for (i = 0 ; i < n-1 ; i = i + 1)
begin : gen_block
assign y[i] = a[i+1];
end
endgenerate

assign y[n-1] = a[n-1];

endmodule

module lsr (y,a);

parameter n = 16 ;
input [n-1:0] a;
output [n-1:0] y;

genvar i;
generate
for (i = 0 ; i < n - 1 ; i = i + 1)
begin : gen_block
assign y[i] = a[i+1];
end
endgenerate

assign y[n-1] = 1'b0;

endmodule

module lsl (y,a);

parameter n = 16 ;
input [n-1:0] a;
output [n-1:0] y;

genvar i;
generate
for (i = n-1 ; i > 0 ; i = i - 1)
begin : gen_block
assign y[i] = a[i-1];
end
endgenerate

assign y[0] = 1'b0;

endmodule

module signed_division (quotient,remainder,dividend,divisor,clk,rst,start,done);

parameter n = 16 ;
input signed [n-1:0] dividend,divisor;
input clk,rst,start;
output reg signed [n-1:0] quotient,remainder;
output reg done;

reg [4:0] count;
reg [n-1:0] abs_dividend,abs_divisor;
reg [n-1:0] quot_temp,rem,next_rem_temp;
reg sign_dividend,sign_divisor ;
reg [1:0] state;

localparam idle=2'd0,init=2'd1,calc=2'd2,completed=2'b11;

always @(posedge clk or posedge rst)
begin
 
if(rst) 
begin
state <= idle;
done <= 0;
quotient <= 0;
remainder <= 0;
abs_dividend <= 0 ;
abs_divisor <= 0 ;
sign_divisor <= 0 ;
sign_dividend <= 0 ;
next_rem_temp <= 16'd0 ;
rem <= 16'd0 ;
quot_temp <= 16'd0 ;
count <= 5'd0 ;
end 

else 
begin

case(state)
idle: 
begin
done <= 0 ;
if (start) state <= init ;
end

init : 
begin
if (divisor == 0)
begin
quotient <= 0 ;
remainder <= 0 ;
done <= 1 ;
state <= idle ;
end

else
begin
sign_dividend <= dividend [n-1] ;
sign_divisor <= divisor [n-1] ;
abs_divisor <= (sign_divisor) ? -divisor : divisor ;
abs_dividend <= (sign_dividend) ? -dividend : dividend ;
quot_temp <= 16'd0 ;
rem <= 16'd0 ;
count <= n ;
state <= calc;
end

end

calc:
begin
next_rem_temp = (rem << 1) | abs_dividend [n-1] ;
if (next_rem_temp >= abs_divisor)
begin
quot_temp <= (quot_temp << 1) | 1 ;
rem <= next_rem_temp - abs_divisor ;
end

else
begin
quot_temp <= quot_temp << 1 ;
rem <= next_rem_temp ;
end

count <= count - 1 ;
abs_dividend <= abs_dividend << 1 ;

if (count == 1)
begin
state <= completed ;
end

end
completed: 
begin
quotient <= (sign_divisor ^ sign_dividend) ?-quot_temp : quot_temp ;
remainder <= sign_dividend ? -rem : rem ;
done<=1;
state<=idle;
end
default: state<=idle;
endcase
end
end
endmodule


module AND (out,input0,input1);

parameter n = 16 ;
input [n-1:0] input0,input1 ;
output wire [n-1:0] out ;

genvar i;
generate
for (i = 0 ; i < n ; i = i + 1)
begin : loop
and g (out[i],input0[i],input1[i]);
end
endgenerate 

endmodule

module OR (out,input0,input1);

parameter n = 16 ;
input [n-1:0] input0,input1 ;
output wire [n-1:0] out ;

genvar i;
generate
for (i = 0 ; i < n ; i = i + 1)
begin : loop
or g (out[i],input0[i],input1[i]);
end
endgenerate 

endmodule

module XOR (out,input0,input1);

parameter n = 16 ;
input [n-1:0] input0,input1 ;
output wire [n-1:0] out ;

genvar i;
generate
for (i = 0 ; i < n ; i = i + 1)
begin : loop
xor g (out[i],input0[i],input1[i]);
end
endgenerate 

endmodule

module NOR (out,input0,input1);

parameter n = 16 ;
input [n-1:0] input0,input1 ;
output wire [n-1:0] out ;

genvar i;
generate
for (i = 0 ; i < n ; i = i + 1)
begin : loop
nor g (out[i],input0[i],input1[i]);
end
endgenerate 

endmodule