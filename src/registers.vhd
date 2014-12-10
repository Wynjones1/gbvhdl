library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.types.all;

entity registers is
    port( clk        : in std_logic;
          reset      : in std_logic;
          write_data : in reg16_t;
          read_data  : in reg16_t;
          we         : in std_logic;
end entity;

architecture rtl of registers is
begin
end rtl;
