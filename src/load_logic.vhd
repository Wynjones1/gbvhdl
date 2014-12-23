library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.types.all;

entity load_logic is
    port(   clk       : in std_logic;
          reset       : in std_logic;
             en       : in std_logic;
             i0_indir : in std_logic);
end entity;

architecture rtl of load_logic is
begin
end architecture;
