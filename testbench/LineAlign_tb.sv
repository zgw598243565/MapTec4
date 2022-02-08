`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/02/04 10:14:00
// Design Name: 
// Module Name: LineAlign_tb
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


module LineAlign_tb;
bit clk;
bit arstn;
bit [13:0]data_in;
bit datain_valid;
wire [3*14-1:0]data_out;
wire dataout_valid;
wire [13:0]data_out0;
wire [13:0]data_out1;
wire [13:0]data_out2;
integer i,j;
always #5 clk = ~clk;
initial
    begin
        datain_valid = 1'b0;
        arstn = 1'b1;
        data_in = 0;
        #20
        arstn = 1'b0;
        #20
        arstn = 1'b1;
        for(i=1;i<13;i=i+1)
            begin
                for(j=1;j<241;j=j+1)
                    begin
                        @(posedge clk);
                        #2 
                            data_in = j;
                            datain_valid = 1'b1;
                            //$display("%d ",data_in);
                    end
                   // $display("\n");
            end
        @(posedge clk);
            datain_valid = 1'b0;
        #2000 $finish;
    end




assign data_out0[13:0] = data_out[13:0];
assign data_out1[13:0] = data_out[27:14];
assign data_out2[13:0] = data_out[41:28];
LineAlign #(
    .DATA_WIDTH(14),
    .BUFFER_DEPTH(256),
    .FIFO_WIDTH(8),
    .LINE_NUM(3),
    .IMAGE_WIDTH(240)
    
)DUT(clk,arstn,data_in,datain_valid,data_out,dataout_valid);
endmodule
