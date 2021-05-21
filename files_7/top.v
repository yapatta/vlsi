module top (input [`BUS_ADDR_WIDTH-1:0] addr0,
            input [`DATA_WIDTH-1:0] idata0,
            output [`DATA_WIDTH-1:0] odata0,
            input rw0_,
            input breq0_,
            output bgrt0_,
            input [`BUS_ADDR_WIDTH-1:0] dsaddr, // DMA転送元アドレス
            input [`BUS_ADDR_WIDTH-1:0] ddaddr, // DMA転送先アドレス
            input [1:0] dmode,                  // DMA転送モード
            input dreq_,                        // I/O側が生成する場合も
            output eop_,                        // DMA転送完了
            input reset_,
            input clk);

wire [`DATA_WIDTH-1:0] odata, idata;
wire [`BUS_ADDR_WIDTH-1:0] addr;
wire rw_;

// マスタデバイス１（DMAコントローラ）
wire [`BUS_ADDR_WIDTH-1:0] addr1;
wire [`DATA_WIDTH-1:0] idata1;
wire [`DATA_WIDTH-1:0] odata1;
wire rw1_, breq1_, bgrt1_;

assign odata0 = odata;
assign odata1 = odata;

assign addr  = (bgrt0_ == `Enable_) ? addr0 : addr1;   // addr0もしくはaddr1（bgrtをもらった方）
assign idata = (bgrt0_ == `Enable_) ? idata0 : idata1; // idata0もしくはidata1（bgrtをもらった方）
assign rw_   = (bgrt0_ == `Enable_) ? rw0_ : rw1_;     // rw0_もしくはrw1_（bgrtをもらった方）
slaves u0 (addr, idata, odata, rw_, reset_, clk);
busarb u1 (breq0_, breq1_, bgrt0_, bgrt1_, reset_, clk);
dmactr u2 (addr1, idata1, odata1, rw1_, breq1_, bgrt1_, dsaddr, ddaddr, dmode, dreq_, eop_, reset_, clk);

endmodule
