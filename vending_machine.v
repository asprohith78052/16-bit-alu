module vending_machine(clk,rst,operation);

input clk,rst;
output reg [2:0] operation;
reg [2:0] state;
reg [3:0] counter;
parameter s0 = 0 , s1 = 1 , s2  = 2 , s3 = 3 , s4 = 4 , s5 = 5;
parameter STARTED = 3'b000 , WASHING = 3'b001 , SPINNING = 3'b010 , DRYING = 3'b011 , FINISHED = 3'b100 , HALT = 3'b101;

always @(posedge clk or posedge rst)
begin
if (rst)
state  <= s0;
else
begin
case (state) 

s0 : begin
if (counter < 4'd3)
counter = counter + 1;
else
begin
state <= s1; 
counter <= 0;
end
end

s1 : begin
if (counter < 4'd10)
counter <= counter + 1;
else
begin
state <= s2;
counter <= 0;
end
end

s2 : begin
if (counter < 4'd5)
counter <= counter + 1;
else
begin
state <= s3;
counter <= 0;
end
end

s3 : begin
if (counter < 4'd5)
counter <= counter + 1;
else
begin
state <= s4;
counter <= 0;
end
end

s4 : begin
if (counter < 4'd3)
counter <= counter + 1;
else
begin
state <= s5;
counter <= 0;
end
end

s5 : begin
if (counter < 4'd1)
counter <= counter + 1;
else
begin
state <= s0;
counter <= 0;
end
end
 

default : begin
state <= s0;
counter <= 0;
end
endcase
end
end

always @(posedge clk or posedge rst)
begin
if (rst)
operation <= STARTED;
else
begin
case (state)
s0 : operation <= STARTED;
s1 : operation <= WASHING;
s2 : operation <= SPINNING;
s3 : operation <= DRYING;
s4 : operation <= FINISHED;
s5 : operation <= HALT;
default : operation <= STARTED;
endcase
end
end

endmodule