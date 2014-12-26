library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_misc.all;
use work.types.all;
use work.interfaces.all;

entity alu_logic is
    port( clk : in std_logic;
          reset : in std_logic;
          input : in alu_logic_input_if;
          output : in alu_logic_output_if);
end entity;

architecture rtl of alu_logic
begin
end rtl;
