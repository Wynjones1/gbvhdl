library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;
use work.types.all;
use work.interfaces.all;

entity memory is
    port( clk    : in  std_logic;
          reset  : in  std_logic;
          input  : in  memory_in_if;
          output : out memory_out_if);
end entity;

architecture rtl of memory is
    type rom_t is array (0 to 65535) of byte_t;

    impure function init_mem(filename : in string) return rom_t is
        file input_file   : text open read_mode is filename;
        variable mif_line : line;
        variable temp_bv  : bit_vector(7 downto 0);
        variable rom      : rom_t;
    begin
        read_loop:
        for i in rom_t'range loop
            exit read_loop when endfile(input_file);
            readline(input_file, mif_line);
            read(mif_line, temp_bv);
            for j in 0 to 7 loop
                --rom(i) := to_stdlogicvector(temp_bv);
                if temp_bv(j) = '1' then
                    rom(i)(j) := '1';
                else
                    rom(i)(j) := '0';
                end if;
            end loop;
        end loop;
        return rom;
    end function;

    signal rom   : rom_t := init_mem("../bin/DMG_ROM.mif");
    signal index : integer range 0 to 255;
begin

    process(clk, reset)
    begin
        if reset = '1' then
            output.valid <= '0';
            rom <= init_mem("../bin/DMG_ROM.mif");
        elsif rising_edge(clk) then
            output.valid <= '1';
            if input.we = '1' then
                rom(index) <= input.data;
            end if;
        end if;
    end process;

    index       <= 0 when reset = '1' else to_integer(unsigned(input.address(LO_BYTE)));
    output.data <= (others => 'U') when reset = '1' else rom(index);
end rtl;
