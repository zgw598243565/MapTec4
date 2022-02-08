module LineAlign #(
    parameter DATA_WIDTH = 14,
    parameter BUFFER_DEPTH = 256,
    parameter FIFO_WIDTH = 8,
    parameter LINE_NUM = 3,
    parameter IMAGE_WIDTH = 128
    
)(clk,arstn,data_in,datain_valid,data_out,dataout_valid);
function integer clogb2(input integer bit_depth);
    begin
        for(clogb2 = 0;bit_depth >0; clogb2 = clogb2+1)
            bit_depth = bit_depth >> 1;
    end
endfunction

localparam DATAOUT_WIDTH = DATA_WIDTH*LINE_NUM;
localparam clog2_BUFFER_DEPTH = clogb2(BUFFER_DEPTH - 1);

input clk;
input arstn;
input [DATA_WIDTH - 1:0]data_in;
input datain_valid;
output [DATAOUT_WIDTH-1:0]data_out;
output dataout_valid;
wire [DATA_WIDTH-1:0]temp_dout[LINE_NUM-1:0];
wire [clog2_BUFFER_DEPTH:0]temp_usedw[LINE_NUM-1:0];
wire [LINE_NUM-1:0]temp_rd_req;
wire [LINE_NUM-1:0]temp_wr_req;
wire [LINE_NUM-1:0]temp_empty;
wire [LINE_NUM-1:0]temp_valid;
wire [LINE_NUM-2:0]temp_dout_valid;
wire temp_rd_req0;
wire temp_rd_req1;

/* The First Line Buffer */
assign data_out[DATA_WIDTH-1:0] = temp_dout[0];
LineBuffer #(
    .DATA_WIDTH(DATA_WIDTH),
    .BUFFER_DEPTH(BUFFER_DEPTH),
    .FIFO_WIDTH(FIFO_WIDTH)
)Inst_LineBuffer_first(
    .clk(clk),
    .arstn(arstn),
    .data_in(data_in),
    .wrreq(temp_wr_req[0]),
    .data_out(temp_dout[0]),
    .rdreq(temp_rd_req[0]),
    .usedw(temp_usedw[0]),
    .empty(temp_empty[0]),
    .full()
);

assign temp_rd_req0 = temp_valid[0] & temp_wr_req[0];
assign temp_rd_req1 = ~(datain_valid | temp_empty[0]);
assign temp_wr_req[0] = datain_valid;
assign temp_valid[0] = (IMAGE_WIDTH == temp_usedw[0]) ? 1:0;
assign temp_rd_req[0] = temp_rd_req0 | temp_rd_req1;

/* generate Other Line Buffer */
generate
    begin
        genvar i;
        for(i=1;i<LINE_NUM;i=i+1)
            begin
                assign data_out[(DATA_WIDTH*i)+:DATA_WIDTH] = temp_dout[i];
                LineBuffer #(
                    .DATA_WIDTH(DATA_WIDTH),
                    .BUFFER_DEPTH(BUFFER_DEPTH),
                    .FIFO_WIDTH(FIFO_WIDTH)
                )Inst_LineBuffer(
                    .clk(clk),
                    .arstn(arstn),
                    .data_in(temp_dout[i-1]),
                    .wrreq(temp_wr_req[i]),
                    .data_out(temp_dout[i]),
                    .rdreq(temp_rd_req[i]),
                    .usedw(temp_usedw[i]),
                    .empty(temp_empty[i]),
                    .full()
                );
                
                assign temp_valid[i] = (IMAGE_WIDTH == temp_usedw[i]) ? 1:0;
                assign temp_wr_req[i] = (~temp_empty[i-1]) & temp_rd_req[i-1];
                assign temp_rd_req[i] = temp_valid[i] & temp_wr_req[i];
                assign temp_dout_valid[i-1] = temp_rd_req[i];
            end
    end
endgenerate

assign dataout_valid = (~temp_empty[0]) & (&temp_dout_valid[LINE_NUM-2:0]);
endmodule














