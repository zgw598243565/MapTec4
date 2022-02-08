`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/02/01 19:28:03
// Design Name: 
// Module Name: ImageCounter
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


module ImageCounter #
(
    parameter IW = 640,
    parameter IH = 480,
    parameter DW = 8,
    parameter IW_DW = 12, /* Width of the column counter */ 
    parameter IH_DW = 12 /* Width of the line counter */
)
(clk,arstn,vsync,hsync,dvalid,line_counter,column_counter);


input clk;
input arstn;
input vsync;
input hsync;
input dvalid;

output reg [IH_DW-1:0]line_counter;
output reg [IW_DW-1:0]column_counter;


reg rst_all; /* reset signal for line_counter and column_counter when vsync valid*/
always@(posedge clk or negedge arstn)
    begin
        if(~arstn)
            rst_all <= 1'b1;
        else
        begin
            if(vsync == 1'b1)
                rst_all <= 1'b1;
            else
                rst_all <= 1'b0;
        end
    end
    
wire dvalid_rise; /* dvalid rise edge */
reg dvalid_r;
always@(posedge clk or negedge arstn)
    begin
        if(~arstn)
            dvalid_r <= 1'b0;
        else
            dvalid_r <= dvalid;
    end

assign dvalid_rise = (~dvalid_r) & dvalid;


/* line counter  */
always@(posedge clk)
    begin
        if(rst_all)
            line_counter[IH_DW-1:0] <= {IH_DW{1'b0}};
        else
            if(dvalid_rise)
            begin
                line_counter[IH_DW-1:0] <= line_counter[IH_DW-1:0] + {{IH_DW-1{1'b0}},1'b1};
            end
    end

/* column counter */
always@(posedge clk)
    begin
        if(rst_all)
            line_counter[IW_DW-1:0]<= {IW_DW{1'b0}};
        else
            begin
                if(dvalid_rise)
                    column_counter[IW_DW-1:0] <= {{IW_DW-1{1'b0}},1'b1};
                else
                    begin
                        if(dvalid)
                            column_counter[IW_DW-1:0] <= column_counter[IW_DW-1:0] + {{IW_DW-1{1'b0}},1'b1};
                    end 
            end
    end
endmodule

















