library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.types.all;
use work.interfaces.all;

entity registers is
    port( clk    : in  std_logic;
          reset  : in  std_logic;
          input  : in  registers_in_if;
          output : out registers_out_if);
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
            if input.we = '1' then
                case input.wsel is
                when register_a  => af(HI_BYTE) <= input.data(LO_BYTE);
                when register_f  => af(LO_BYTE) <= input.data(LO_BYTE);
                when register_b  => bc(HI_BYTE) <= input.data(LO_BYTE);
                when register_c  => bc(LO_BYTE) <= input.data(LO_BYTE);
                when register_d  => de(HI_BYTE) <= input.data(LO_BYTE);
                when register_e  => de(LO_BYTE) <= input.data(LO_BYTE);
                when register_h  => hl(HI_BYTE) <= input.data(LO_BYTE);
                when register_l  => hl(LO_BYTE) <= input.data(LO_BYTE);
                when register_af => af <= input.data;
                when register_bc => bc <= input.data;
                when register_de => de <= input.data;
                when register_hl => hl <= input.data;
                when register_sp => sp <= input.data;
                when register_pc => pc <= input.data;
                when others =>
                end case;
            end if;
        end if;
    end process;

    output_proc : process(input)
    begin
        output.d0 <= (others => '0');
        output.d1 <= (others => '0');
        case input.rsel0 is
        when register_a  => output.d0(LO_BYTE) <= af(HI_BYTE);
        when register_f  => output.d0(LO_BYTE) <= af(LO_BYTE);
        when register_b  => output.d0(LO_BYTE) <= bc(HI_BYTE);
        when register_c  => output.d0(LO_BYTE) <= bc(LO_BYTE);
        when register_d  => output.d0(LO_BYTE) <= de(HI_BYTE);
        when register_e  => output.d0(LO_BYTE) <= de(LO_BYTE);
        when register_h  => output.d0(LO_BYTE) <= hl(HI_BYTE);
        when register_l  => output.d0(LO_BYTE) <= hl(LO_BYTE);
        when register_af => output.d0 <= af;
        when register_bc => output.d0 <= bc;
        when register_de => output.d0 <= de;
        when register_hl => output.d0 <= hl;
        when register_sp => output.d0 <= sp;
        when register_pc => output.d0 <= pc;
        when others =>
        end case;

        case input.rsel1 is
        when register_a  => output.d1(LO_BYTE) <= af(HI_BYTE);
        when register_f  => output.d1(LO_BYTE) <= af(LO_BYTE);
        when register_b  => output.d1(LO_BYTE) <= bc(HI_BYTE);
        when register_c  => output.d1(LO_BYTE) <= bc(LO_BYTE);
        when register_d  => output.d1(LO_BYTE) <= de(HI_BYTE);
        when register_e  => output.d1(LO_BYTE) <= de(LO_BYTE);
        when register_h  => output.d1(LO_BYTE) <= hl(HI_BYTE);
        when register_l  => output.d1(LO_BYTE) <= hl(LO_BYTE);
        when register_af => output.d1 <= af;
        when register_bc => output.d1 <= bc;
        when register_de => output.d1 <= de;
        when register_hl => output.d1 <= hl;
        when register_sp => output.d1 <= sp;
        when register_pc => output.d1 <= pc;
        when others =>
        end case;
    end process;

    output.pc <= pc;
    output.a  <= af(HI_BYTE);
    output.f  <= af(LO_BYTE);
    output.sp <= sp;
    output.hl <= hl;
end rtl;
