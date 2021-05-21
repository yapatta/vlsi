`include "define.h"
module dmactr (output reg [`BUS_ADDR_WIDTH-1:0] addr, // メモリ・I/Oアドレス
               output reg [`DATA_WIDTH-1:0] odata,    // 書き込みデータ
               input [`DATA_WIDTH-1:0] idata,         // 読み込みデータ
               output reg rw_,                        // リードライト信号
               output reg breq_,                      // バス要求
               input bgrt_,                           // バス許可
               input [`BUS_ADDR_WIDTH-1:0] dsaddr,    // DMA転送元アドレス
               input [`BUS_ADDR_WIDTH-1:0] ddaddr,    // DMA転送先アドレス
               input [1:0] dmode,                     // DMA転送モード
               input dreq_,                           // I/O側が生成する場合も
               output reg eop_,                       // DMA転送完了
               input reset_,
               input clk);

reg [2:0] state;

always @ (posedge clk)
    if (reset_ == `Enable_) begin
        // stateの初期化を怠るとちゃんと動かないので注意！
        state <= `Wait;
        breq_ <= `Disable_;
        end else begin
        case (state)
            `Wait:
            begin
                if (dreq_ == `Enable_) begin
                    breq_ <= `Enable_;
                    case (dmode)
                        `SingleM2M:
                        state <= `Read1;
                        `BurstM2M:
                        state <= `Read4;
                        default:
                        state <= `Wait;
                    endcase
                end
                eop_ <= `Disable_;
            end
            `Read1:
            if (bgrt_ == `Enable_) begin
                addr <= dsaddr;
                rw_ <= `Read;
                state <= `Write1;
            end
            `Write1:
            begin
                addr <= ddaddr;
                rw_ <= `Write;
                odata <= idata;
                state <= `Complete;
            end
            `Complete:
            begin
                eop_ <= `Enable_;
                breq_ <= `Disable_;
                state <= `Wait;
            end
        endcase
    end
endmodule

