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
reg [3:0] rwc4;

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
                        begin
                            state <= `Read1;
                        end
                        `BurstM2M:
                        begin
                            state <= `Read4;
                            rwc4 <= 4;
                        end
                        default:
                        begin
                            state <= `Wait;
                        end
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
            `Read4:
            if (bgrt_ == `Enable_) begin
                addr <= dsaddr;
                rw_ <= `Read;
                state <= `Write4;
            end
            `Write1:
            begin
                addr <= ddaddr;
                rw_ <= `Write;
                odata <= idata;
                state <= `Complete;
            end
            `Write4:
            begin
                addr <= ddaddr;
                rw_ <= `Write;
                odata <= idata;
                rwc4 <= rwc4 - 1;
                if (rwc4 == 0)
                    state <= `Complete;
                else
                    state <= `Read4;
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

