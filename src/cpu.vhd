library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.types.all;

entity cpu is
	port(clk        : in  std_logic;
		 reset      : in  std_logic;
		 read_data  : in  reg_t;
		 addr       : out reg16_t;
		 we         : out std_logic;
		 write_data : out reg_t);
end entity;

architecture rtl of cpu is
	type state_t is (state_idle, state_read_instr, state_decode_instr);

	signal a, f, b, c, d, e, h, l  : reg_t;
	signal af, bc, de, hl, sp, pc  : reg16_t;
	signal state : state_t;
begin
	datapath_proc:
	process(clk, reset)
	begin
	end process;

	control_proc:
	process(clk, reset)
	begin
		if reset = '1' then
		elsif rising_edge(clk) then
			case state is
				when state_idle         =>
				when state_read_instr   =>
					addr  <= pc;
					state <= state_decode_instr;
				when state_decode_instr =>
			end case;
		end if;
	end process;

	af <= a & f;
	bc <= b & c;
	de <= d & e;
	hl <= h & l;
end architecture;
