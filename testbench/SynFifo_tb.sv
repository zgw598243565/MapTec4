`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/02/03 09:59:21
// Design Name: 
// Module Name: SynFifo_tb
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


module SynFifo_tb;
bit clk;
bit arstn;
bit [7:0]data_in;
bit wrreq;
bit rdreq;
wire [7:0]data_out;
wire [7:0]usedw;
wire empty;
wire full;

always #5 clk = ~clk;
initial
    begin
        arstn = 1'b1;
        wrreq = 1'b0;
        rdreq = 1'b0;
        #20
        arstn = 1'b0;
        #20
        arstn = 1'b1;
        #40
        for(int i = 1;i<40;i=i+1)
            begin
                @(posedge clk);
               #2 
                wrreq = 1'b1;
                data_in = i;
                
                if(i == 20)
                    begin
                        rdreq = 1'b1;
                    end
            end
       @(posedge clk);
       #2 wrreq = 1'b0;
       
       #200 $finish;
    end

SynFifo #
(
    .DATA_WIDTH(8),
    .FIFO_DEPTH(256)
)DUT
(
    .clk(clk),
    .arstn(arstn),
    .data_in(data_in),
    .wrreq(wrreq),
    .rdreq(rdreq),
    .data_out(data_out),
    .usedw(usedw),
    .empty(empty),
    .full(full)
);
endmodule
