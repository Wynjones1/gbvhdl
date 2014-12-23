library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use std.textio.all;
use work.types.all;

entity cpu_tb is
end;

architecture rtl of cpu_tb is
    component cpu is
        port(clk        : in  std_logic;
             reset      : in  std_logic);
    end component;

    signal clk        : std_logic;
    signal reset      : std_logic;

    type temp_rcd is
        record
            a : std_logic;
            b : std_logic;
            c : std_logic;
        end record;

    signal a : temp_rcd;
begin
    reset_gen : process
    begin
        reset <= '1';
        wait for 40 ns;
        reset <= '0';
        wait;
    end process;

    clk_gen: process
    begin
        if clk = '1' then
            clk <= '0';
            wait for 10 ns;
        else
            clk <= '1';
            wait for 10 ns;
        end if;
    end process;

    cpu_0 : cpu
        port map (clk, reset);
end rtl;
