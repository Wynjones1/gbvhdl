SRCDIR       := ../src
SRC          := ../synth/vga.vhd ../synth/ssd.vhd ../synth/clock_gen.vhd ../synth/top.vhd $(SRCDIR)/types.vhd $(SRCDIR)/interfaces.vhd $(SRCDIR)/common.vhd $(shell find $(SRCDIR) -type f -name "*.vhd")
OUT          := $(patsubst  %.vhd,%.o,$(SRC))
FILE         := memory_tb
FILE         := alu_tb
FILE         := registers_tb
FILE         := cpu_tb
FILE         := sdcard_tb
WAVE         := --vcd=waves.vcd
WAVE         := --wave=waves.ghw
#TIME         := --stop-time=2000ns;
GHDL_FLAGS   := --ieee=synopsys
ASSERT_LEVEL := warning
ASSERT_LEVEL := failure

all: $(OUT)
	ghdl -a $(GHDL_FLAGS) $(FILE).vhd
	ghdl -e $(GHDL_FLAGS) -o $(FILE).out $(FILE)

%.o : %.vhd
	ghdl -a $(GHDL_FLAGS) $<

run: all
	./$(FILE).out $(WAVE) $(TIME) --assert-level=$(ASSERT_LEVEL)

view:
	#vcd2fst -v waves.vcd -f waves.fst
	#gtkwave waves.fst
	gtkwave waves.ghw

clean:
	ghdl --clean 
	rm -f *.cf *.vcd *.o *.ghw *.fst *.out *.txt
