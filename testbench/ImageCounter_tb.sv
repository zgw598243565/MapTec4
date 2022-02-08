`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/02/01 20:38:07
// Design Name: 
// Module Name: ImageCounter_tb
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


module ImageCounter_tb;
bit clk;
bit arstn;
wire hs;
wire vs;
wire de;
wire [7:0]rgb_r;
wire [7:0]rgb_g;
wire [7:0]rgb_b;
wire [11:0]line_counter;
wire [11:0]column_counter;

always #5 clk = ~clk;
initial
    begin
        arstn = 1'b1;
        #20
        arstn = 1'b0;
        #20
        arstn = 1'b1;
       
    end

ImageCounter Dut(.clk(clk),.arstn(arstn),.vsync(vs),.hsync(hs),.dvalid(de),.line_counter(line_counter),.column_counter(column_counter));

color_bar color_bar_inst(.clk(clk),.arstn(arstn),.hs(hs),.vs(vs),.de(de),.rgb_r(rgb_r),.rgb_g(rgb_g),.rgb_b(rgb_b));
endmodule
