SRCDIR       := ../src/
SRC          := $(shell find $(SRCDIR) -type f -name "*.vhd")
OUT          := $(patsubst  %.vhd,%.o,$(SRC))
FILE         := memory_tb
FILE         := alu_tb
WAVE         := --wave=waves.ghw
WAVE         := --vcd=waves.vcd
TIME         := 4ms
GHDL_FLAGS   := --ieee=synopsys
ASSERT_LEVEL := warning

all: $(OUT)
	ghdl -a $(GHDL_FLAGS) $(FILE).vhd
	ghdl -e $(GHDL_FLAGS) -o $(FILE).out $(FILE)

%.o : %.vhd
	ghdl -a $(GHDL_FLAGS) $<

run: all
	./$(FILE).out $(WAVE) --stop-time=$(TIME) --assert-level=$(ASSERT_LEVEL)

view:
	#vcd2fst -v waves.vcd -f waves.fst
	#gtkwave waves.fst
	gtkwave waves.ghw

clean:
	ghdl --clean 
	rm -f *.cf *.vcd *.o *.ghw *.fst *.out