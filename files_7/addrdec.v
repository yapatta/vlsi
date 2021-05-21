`include "define.h"
module addrdec (input [`BUS_ADDR_WIDTH-1:0] addr,
                output cs0_,
                output cs1_,
                output cs2_,
                output cs3_);
assign  cs0_ = (~addr[8] & ~addr[9]) ? `Enable_ : `Disable_;
assign  cs1_ = (addr[8] & ~addr[9]) ? `Enable_ : `Disable_;
assign  cs2_ = (~addr[8] & addr[9]) ? `Enable_ : `Disable_;
assign  cs3_ = (addr[8] & addr[9]) ? `Enable_ : `Disable_;
endmodule
