`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/02/03 14:19:30
// Design Name: 
// Module Name: LineBuffer_tb
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




module LineBuffer_tb;
bit clk;
bit arstn;
bit [13:0]data_in;
bit wrreq;
wire [13:0]data_out;
bit rdreq;
wire [8:0]usedw;
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
        #20
        for(int i=0;i<512;i=i+1)
        begin
            @(posedge clk);
            #2 
                data_in = i;
                wrreq = 1'b1;
                if(i==256)
                begin
                    rdreq = 1'b1;
                end
        end
        
        #200 $finish();
    end


LineBuffer #
(
    .DATA_WIDTH(14),
    .BUFFER_DEPTH(256),
    .FIFO_WIDTH(8)
)Dut
(
    .clk(clk),
    .arstn(arstn),
    .data_in(data_in),
    .wrreq(wrreq),
    .data_out(data_out),
    .rdreq(rdreq),
    .usedw(usedw),
    .empty(empty),
    .full(full)
);
endmodule

