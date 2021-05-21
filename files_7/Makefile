VERILOG_SRCS := $(wildcard *.v)

top:	define.h top.v slaves.v addrdec.v sram.v timer.v busarb.v
	iverilog test_dma.v define.h top.v dmactr.v slaves.v addrdec.v sram.v timer.v busarb.v
	vvp a.out

format: *.v .verilog-format.properties
	for file in $(VERILOG_SRCS); do verilog-format -f "$$file" -s .verilog-format.properties; done

clean:
	rm -f a.out dump.vcd
