`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/02/01 21:09:08
// Design Name: 
// Module Name: color_bar_tb
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


module color_bar_t;
bit clk;
bit arstn;
wire hs;
wire vs;
wire de;
wire [7:0]rgb_r;
wire [7:0]rgb_g;
wire [7:0]rgb_b;


always #5 clk = ~clk;
initial
    begin
        arstn = 1'b1;
        #20
        arstn = 1'b0;
        #20
        arstn = 1'b1;
    end
color_bar Dut(clk,arstn,hs,vs,de,rgb_r,rgb_g,rgb_b);
endmodule
