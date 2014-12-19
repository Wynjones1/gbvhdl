library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.types.all;

entity registers is
    port( clk        : in  std_logic;
          reset      : in  std_logic;
          we         : in  std_logic;
          write_sel  : in  register_t;
          read_sel   : in  register_t;
          write_data : in  word_t;
          pc_out     : out word_t;
          read_data  : out word_t);
end entity;

architecture rtl of registers is
    signal af : word_t;
    signal bc : word_t;
    signal de : word_t;
    signal hl : word_t;
    signal sp : word_t;
    signal pc : word_t;
begin
    write: process(clk, reset)
    begin
        if reset = '1' then
            af <= (others => '0');
            bc <= (others => '0');
            de <= (others => '0');
            hl <= (others => '0');
            sp <= (others => '0');
            pc <= (others => '0');
        elsif rising_edge(clk) then
            if we = '1' then
                case write_sel is
                when register_a  => af(HI_BYTE) <= write_data(LO_BYTE);
                when register_f  => af(LO_BYTE) <= write_data(LO_BYTE);
                when register_b  => bc(HI_BYTE) <= write_data(LO_BYTE);
                when register_c  => bc(LO_BYTE) <= write_data(LO_BYTE);
                when register_d  => de(HI_BYTE) <= write_data(LO_BYTE);
                when register_e  => de(LO_BYTE) <= write_data(LO_BYTE);
                when register_h  => hl(HI_BYTE) <= write_data(LO_BYTE);
                when register_l  => hl(LO_BYTE) <= write_data(LO_BYTE);
                when register_af => af <= write_data;
                when register_bc => bc <= write_data;
                when register_de => de <= write_data;
                when register_hl => hl <= write_data;
                when register_sp => sp <= write_data;
                when register_pc => pc <= write_data;
                when others =>
                end case;
            end if;
        end if;
    end process;

    output : process(read_sel, af, bc, de, hl, sp, pc)
    begin
        read_data <= (others => '0');
        case read_sel is
        when register_a  => read_data(LO_BYTE) <= af(HI_BYTE);
        when register_f  => read_data(LO_BYTE) <= af(LO_BYTE);
        when register_b  => read_data(LO_BYTE) <= bc(HI_BYTE);
        when register_c  => read_data(LO_BYTE) <= bc(LO_BYTE);
        when register_d  => read_data(LO_BYTE) <= de(HI_BYTE);
        when register_e  => read_data(LO_BYTE) <= de(LO_BYTE);
        when register_h  => read_data(LO_BYTE) <= hl(HI_BYTE);
        when register_l  => read_data(LO_BYTE) <= hl(LO_BYTE);
        when register_af => read_data <= af;
        when register_bc => read_data <= bc;
        when register_de => read_data <= de;
        when register_hl => read_data <= hl;
        when register_sp => read_data <= sp;
        when register_pc => read_data <= pc;
        when others =>
        end case;
    end process;

    pc_out <= pc;
end rtl;
