library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;
use work.types.all;

entity alu_tb is
end;

architecture rtl of alu_tb is
	component alu is
		port( op          : in  alu_op_t;
			  i0          : in  reg_t;
			  i1          : in  reg_t;
			  q           : out reg_t;
			  flags_in    : in  reg_t;
			  flags_out   : out reg_t);
	end component;
	signal clk       : std_logic;
	signal op        : alu_op_t;
	signal input     : std_logic_vector(16 downto 0) := (others => '0');
	signal i0        : reg_t := (others => '0');
	signal i1        : reg_t := (others => '0');
	signal q         : reg_t := (others => '0');
	signal flags_in  : reg_t := (others => '0');
	signal flags_out : reg_t := (others => '0');
begin
	alu0: alu
		port map (op, i0, i1, q, flags_in, flags_out);

	clkgen:
	process
	begin
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
	end process;

	gen_data:
	process(clk)
	begin
		if rising_edge(clk) then
			op    <= alu_op_or;
			input <= std_logic_vector( unsigned(input) + 1);
		end if;
	end process;

	i0 <= input( 7 downto 0);
	i1 <= input(15 downto 8);
	flags_in(CARRY_BIT) <= input(16);
end rtl;
