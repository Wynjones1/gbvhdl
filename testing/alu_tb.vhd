library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_misc.all;
use IEEE.std_logic_textio.all;
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

	procedure output_data(name             : string;
						  i0               : std_logic_vector(7 downto 0);
						  i1               : std_logic_vector(7 downto 0);
						  q                : std_logic_vector(7 downto 0);
						  flags_in         : std_logic_vector(7 downto 0);
						  flags_out        : std_logic_vector(7 downto 0);
						  file output_file : text) is
		variable tmp : line;
	begin
		write(tmp, name);
		write(tmp, string'(" "));
		write(tmp, i0);
		write(tmp, string'(" "));
		write(tmp, i1);
		write(tmp, string'(" "));
		write(tmp, flags_in);
		write(tmp, string'(" "));
		write(tmp, q);
		write(tmp, string'(" "));
		write(tmp, flags_out);
		writeline(output_file, tmp);
	end procedure;

	signal clk       : std_logic;
	signal op        : alu_op_t;
	signal input     : std_logic_vector((8 + 8 + 4) - 1 downto 0) := (others => '0');
	signal i0        : reg_t := (others => '0');
	signal i1        : reg_t := (others => '0');
	signal q         : reg_t := (others => '0');
	signal flags_in  : reg_t := (others => '0');
	signal flags_out : reg_t := (others => '0');
	file   log : text open write_mode is "out.txt";
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
		type state_t is (state_0, state_1);
		variable state : state_t := state_0;
	begin
		if rising_edge(clk) then
			case state is
				when state_0 =>
					op    <= alu_op_adc;
					state := state_1;
				when state_1 =>
					state := state_0;
					output_data("alu_op_adc", i0, i1, q, flags_in, flags_out, log);
					input <= std_logic_vector( unsigned(input) + 1);
					if and_reduce(input) = '1' then
						report "End of simulation" severity failure;
					end if;
			end case;
		end if;
	end process;

	i0 <= input( 7 downto 0);
	i1 <= input(15 downto 8);
	flags_in <= input(19 downto 16) & "0000";
end rtl;
