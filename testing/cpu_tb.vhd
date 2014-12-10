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
             reset      : in  std_logic;
             read_data  : in  byte_t;
             addr       : out reg16_t;
             we         : out std_logic;
             write_data : out byte_t);
    end component;

    signal clk        : std_logic;
    signal reset      : std_logic;
    signal read_data  : byte_t;
    signal addr       : reg16_t;
    signal we         : std_logic;
    signal write_data : byte_t;
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
        port map (clk, reset, read_data, addr, we, write_data);
end rtl;
