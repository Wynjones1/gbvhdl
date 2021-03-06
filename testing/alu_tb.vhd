library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_misc.all;
use IEEE.std_logic_textio.all;
use std.textio.all;
use work.types.all;
use work.interfaces.all;

entity alu_tb is
end;

architecture rtl of alu_tb is
    component alu is
        port(input  : in  alu_in_if;
             output : out alu_out_if);
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
    signal input     : alu_in_if;
    signal output    : alu_out_if;
begin
    alu0: alu
        port map (input, output);

    clkgen:
    process
    begin
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
    end process;
     
--    gen_data:
--    process
--        type state_t is (state_read_op, state_load_input, state_read_output);
--        variable state    : state_t := state_read_op;
--          file log          : text open read_mode is "/home/stuart/VHDL/gbvhdl/testing/input.txt";
--          file outfile      : text;
--          variable tmp_line : line;
--    begin
--        case state is
--            when state_read_op =>
--                    if endfile(log) then
--                        report "End of simulation." severity failure;
--                    end if;
--                    readline(log, tmp_line);
--                    file_open(outfile, "/home/stuart/VHDL/gbvhdl/testing/output/" & tmp_line.all & ".txt", WRITE_MODE);
--                    op    <= string_to_alu_op(tmp_line.all);
--                    state := state_load_input;
--                    wait for 10 ns;
--            when state_load_input =>
--               state := state_read_output;
--               wait for 10 ns;
--                when state_read_output =>
--               state := state_load_input;
--               output_data(tmp_line.all, i0, i1, q, flags_in, flags_out, outfile);
--               input <= std_logic_vector( unsigned(input) + 1);
--               if and_reduce(input) = '1' then
--                        state := state_read_op;
--                        file_close(outfile);
--               end if;
--               wait for 10 ns;
--        end case;
--    end process;
--
--    i0 <= input( 7 downto 0);
--    i1 <= input(15 downto 8);
--    flags_in <= input(19 downto 16) & "0000";
end rtl;
