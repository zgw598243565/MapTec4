module LineBuffer #
(
    parameter DATA_WIDTH = 14,
    parameter BUFFER_DEPTH = 256,
    parameter FIFO_WIDTH = 8
)
(clk,arstn,data_in,wrreq,data_out,rdreq,usedw,empty,full);

function integer clogb2(input integer bit_depth);
    begin
        for(clogb2 = 0;bit_depth > 0;clogb2 = clogb2 + 1)
            bit_depth = bit_depth >> 1;
    end
endfunction

localparam clog2_BUFFER_DEPTH = clogb2(BUFFER_DEPTH - 1);
localparam clog2_FIFO_WIDTH = clogb2(FIFO_WIDTH - 1);
localparam FIFO_NUM = ((DATA_WIDTH + FIFO_WIDTH -1)>>clog2_FIFO_WIDTH);

input clk;
input arstn;
input [DATA_WIDTH-1:0]data_in;
output [DATA_WIDTH-1:0]data_out;
input wrreq;
input rdreq;
output [clog2_BUFFER_DEPTH:0]usedw;
output empty;
output full;
wire [FIFO_WIDTH-1:0]din_temp[FIFO_NUM-1:0];
wire [FIFO_WIDTH*FIFO_NUM-1:0]dout_temp;

assign data_out[DATA_WIDTH-1:0] = dout_temp[DATA_WIDTH-1:0];

/* Generate the first FIFO */
assign din_temp[0] = data_in[FIFO_WIDTH-1:0];
SynFifo #
(
    .DATA_WIDTH(FIFO_WIDTH),
    .FIFO_DEPTH(BUFFER_DEPTH)
)Fifo_inst_0(
    .clk(clk),
    .arstn(arstn),
    .data_in(din_temp[0]),
    .wrreq(wrreq),
    .rdreq(rdreq),
    .data_out(dout_temp[FIFO_WIDTH-1:0]),
    .usedw(usedw),
    .empty(empty),
    .full(full)
);

generate
    begin:fifo_generate
        genvar i;
        if(FIFO_NUM > 1)
            begin
                for(i=1;i<FIFO_NUM - 1;i=i+1)
                    begin
                        assign din_temp[i] = data_in[(FIFO_WIDTH*i)+:FIFO_WIDTH];
                    end
                assign din_temp[FIFO_NUM-1] = {{(FIFO_WIDTH*FIFO_NUM-DATA_WIDTH){1'b0}},data_in[DATA_WIDTH-1:FIFO_WIDTH*(FIFO_NUM-1)]};
                
                for(i=1;i<FIFO_NUM;i=i+1)
                    begin
                        SynFifo #(
                            .DATA_WIDTH(FIFO_WIDTH),
                            .FIFO_DEPTH(BUFFER_DEPTH)
                        )Fifo_inst(
                            .clk(clk),
                            .arstn(arstn),
                            .data_in(din_temp[i]),
                            .wrreq(wrreq),
                            .rdreq(rdreq),
                            .data_out(dout_temp[FIFO_WIDTH*i+:FIFO_WIDTH]),
                            .usedw(),
                            .empty(),
                            .full()
                        );
                    end
            end
    end
endgenerate

endmodule












