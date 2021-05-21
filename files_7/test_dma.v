`timescale 1ns/10ps
`include "define.h"
module test ();
    
    reg [`BUS_ADDR_WIDTH-1:0] addr;
    reg [`DATA_WIDTH-1:0] idata;
    wire [`DATA_WIDTH-1:0] odata;
    reg rw_, breq_;
    wire bgrt_, eop_;
    reg dreq_;
    reg clk, reset_;
    reg [`BUS_ADDR_WIDTH-1:0] dsaddr, ddaddr;
    reg [1:0] dmode;
    
    top u0 (addr, idata, odata, rw_, breq_, bgrt_, dsaddr, ddaddr, dmode, dreq_, eop_, reset_, clk);
    
    always begin
        clk <= 1; #1; clk <= 0; #1;
    end
    
    initial begin
        #1;
        $dumpfile("dump.vcd");
        $dumpvars(0, test.u0);
        
        reset_ <= `Enable_;
        #2;
        reset_ <= `Disable_;
        dreq_ <= `Disable_;
        breq_ <= `Enable_;
        #2;
        
        // プロセッサによる処理
        rw_ <= `Write;
        addr <= 10'h150;
        idata <= 8'h99;
        
        #2;
        
        rw_ <= `Read;
        addr <= 10'h150;
        idata <= 0; #10;
        
        $display("addr = %h odata = %h", addr, odata);
        
        #2;
        rw_ <= `Write;
        addr <= 10'h151;
        idata <= 8'h90;
        
        #2;
        
        rw_ <= `Read;
        addr <= 10'h151;
        idata <= 0; #10;
        
        // odata取れた
        $display("addr = %h odata = %h", addr, odata);
        
		#2;
        rw_ <= `Write;
        addr <= 10'h152;
        idata <= 8'h50;
        
        #2;
        
        rw_ <= `Read;
        addr <= 10'h152;
        idata <= 0; #10;
        
        // odata取れた
        $display("addr = %h odata = %h", addr, odata);
        
        // DMAによる処理
        
        // DMA転送 Memory-to-Memory
        #10;
        breq_ <= `Disable_;
        dreq_ <= `Enable_;
        // dmode <= `SingleM2M;
        dmode <= `BurstM2M;
        dsaddr <= 10'h150;
        ddaddr <= 10'h160;
        
        #2;
        dreq_ <= `Disable_;
        #20;
        // 読み取り
        breq_ <= `Enable_;
        rw_ <= `Read;
        addr <= 10'h160;
        
        #12;
        $display("addr = %h odata = %h", addr, odata);
        
        #2
        // 読み取り
        breq_ <= `Enable_;
        rw_ <= `Read;
        addr <= 10'h161;
        
        #12;
        $display("addr = %h odata = %h", addr, odata);
        
        #2
        // 読み取り
        breq_ <= `Enable_;
        rw_ <= `Read;
        addr <= 10'h162;
        
        #12;
        $display("addr = %h odata = %h", addr, odata);
        

        $finish;
        
    end
endmodule
    
