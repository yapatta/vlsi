`include "define.h"

module sram (input [`MEM_ADDR_WIDTH-1:0] addr,
             input [`DATA_WIDTH-1:0] idata,
             output [`DATA_WIDTH-1:0] odata,
             input cs_,
             input rw_,
             input clk);

reg [`DATA_WIDTH-1:0] mem [(1<<`MEM_ADDR_WIDTH)-1:0];

assign odata = mem[addr];

always @ (posedge clk)
    if (cs_ == `Enable_ && rw_ == `Write)
        mem[addr] <= idata;

endmodule
