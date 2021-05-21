`include "define.h"
module timer (input [`MEM_ADDR_WIDTH-1:0] addr,
              input [`DATA_WIDTH-1:0] idata,
              output [`DATA_WIDTH-1:0] odata,
              input cs_,
              input rw_,
              input clk,
              input rst_);

reg [31:0] count;
reg en;
wire clear, start, stop;

assign clear = (cs_ == `Enable_ && rw_ == `Write && addr == 4 && idata == 1);
assign start = (cs_ == `Enable_ && rw_ == `Write && addr == 4 && idata == 2);
assign stop  = (cs_ == `Enable_ && rw_ == `Write && addr == 4 && idata == 4);

// 一つのregは一箇所のalwaysで実行、二重書きがなくなる
always @ (posedge clk)
    if (rst_ == `Enable_)
        count <= 0;
    else if (clear)
        count <= 0;
    else if (en)
        count <= count + 1;


always @ (posedge clk)
    if (rst_ == `Enable_)
        en <= 0;
    else if (start)
        en <= `Enable;
    else if (stop)
        en <= `Disable;

assign odata = 
(addr == 0) ? count[7:0] :
(addr == 1) ? count [15:8] :
(addr == 2) ? count [23:16] :
(addr == 3) ? count [31:24] : 0;
endmodule
