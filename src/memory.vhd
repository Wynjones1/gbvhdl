library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;
use work.types.all;

entity memory is
    port( clk      : in  std_logic;
          reset    : in  std_logic;
          we       : in  std_logic;
          address  : in  word_t;
          data_in  : in  byte_t;
          data_out : out byte_t;
          valid    : out std_logic);
end entity;

architecture rtl of memory is
    type rom_t is array (0 to 255) of byte_t;

    impure function init_mem(filename : in string) return rom_t is
        file input_file   : text open read_mode is filename;
        variable mif_line : line;
        variable temp_bv  : bit_vector(7 downto 0);
        variable rom      : rom_t;
    begin
        for i in rom_t'range loop
            readline(input_file, mif_line);
            read(mif_line, temp_bv);
            rom(i) := to_stdlogicvector(temp_bv);
        end loop;
        return rom;
    end function;

    signal rom   : rom_t := init_mem("../bin/DMG_ROM.mif");
    signal index : integer range 0 to 255;
begin

    process(clk, reset)
    begin
        if reset = '1' then
            valid <= '0';
            --for i in 0 to 255 loop
            --    rom(i) <= (others
            --end loop
            --rom <= (others => (others => '0'));
            rom <= init_mem("../bin/DMG_ROM.mif");
        elsif rising_edge(clk) then
            valid <= '1';
            if we = '1' then
                rom(index) <= data_in;
            end if;
        end if;
    end process;

    --index    <= to_integer(unsigned(address(LO_BYTE)));
    index    <= 0;
    data_out <= rom(index);
end rtl;
