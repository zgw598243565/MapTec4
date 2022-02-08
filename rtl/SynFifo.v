
module SynFifo #
(
    parameter DATA_WIDTH = 8,
    parameter FIFO_DEPTH = 256
)
(clk,arstn,data_in,wrreq,rdreq,data_out,usedw,empty,full);

function integer clogb2 (input integer bit_depth);
begin
    for(clogb2=0;bit_depth>0;clogb2=clogb2+1)
        bit_depth=bit_depth>>1;
end
endfunction

localparam clog2_FIFO_DEPTH=clogb2(FIFO_DEPTH-1);

input clk;
input arstn;
input [DATA_WIDTH-1:0]data_in;
input wrreq;
input rdreq;
output [DATA_WIDTH-1:0]data_out;
output reg [clog2_FIFO_DEPTH:0]usedw;
output empty;
output full;

(* ram_style = "bram" *) reg [DATA_WIDTH-1:0]mem[FIFO_DEPTH-1:0];

reg [clog2_FIFO_DEPTH-1:0]w_pointer;
reg w_phase;
reg [clog2_FIFO_DEPTH-1:0]r_pointer;
reg r_phase;
wire wr_en;
wire rd_en;
assign wr_en = wrreq & (~full);
assign rd_en = rdreq & (~empty);

/* Write Data */
always@(posedge clk or negedge arstn)
    begin
        if(~arstn)
           begin
                w_phase <= 1'b0;
                w_pointer <= 0;
           end
        else
            begin
                if(wr_en)
                    begin
                        if(w_pointer == FIFO_DEPTH - 1'b1)
                            begin
                                w_pointer <= 'd0;
                                w_phase <= ~w_phase;
                            end
                        else
                            w_pointer<= w_pointer + 1'b1;
                    end
            end
    end

always@(posedge clk)
    begin
        if(wr_en)
            mem[w_pointer]<=data_in;
    end

/* read data */
always@(posedge clk or negedge arstn)
    begin
        if(~arstn)
            begin
                r_pointer <= 0;
                r_phase <= 1'b0;
            end
        else
            begin
                if(rd_en)
                    begin
                        if(r_pointer == FIFO_DEPTH - 1'b1)
                            begin
                                r_pointer <= 'd0;
                                r_phase <= ~r_phase;
                            end
                        else
                            r_pointer <= r_pointer + 1'b1;
                    end
            end
    end

assign data_out = mem[r_pointer];
wire empty=(w_pointer==r_pointer)&&(w_phase^~r_phase);
wire full=(w_pointer==r_pointer)&&(w_phase^r_phase);

always@(*)
    begin
        if(w_phase == r_phase)
            begin
                usedw = w_pointer - r_pointer;
            end
        else
            begin
                usedw = FIFO_DEPTH - r_pointer + w_pointer;
            end
    end
endmodule













