library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.types.all;

entity cpu is
    port(clk        : in  std_logic;
         reset      : in  std_logic;
         read_data  : in  reg_t;
         addr       : out reg16_t;
         we         : out std_logic;
         write_data : out reg_t);
end entity;

architecture rtl of cpu is
    component alu is
        port( op          : in  alu_op_t;
              i0          : in  reg_t;
              i1          : in  reg_t;
              q           : out reg_t;
              flags_in    : in  reg_t;
              flags_out   : out reg_t);
    end component;


    signal a, f, b, c, d, e, h, l  : reg_t;
    signal af, bc, de, hl, sp, pc  : reg16_t;
begin
    datapath_proc:
    process(clk, reset)
    begin
        if reset = '1' then
            a  <= (others => '0');
            f  <= (others => '0');
            b  <= (others => '0');
            c  <= (others => '0');
            d  <= (others => '0');
            e  <= (others => '0');
            h  <= (others => '0');
            l  <= (others => '0');
            sp <= (others => '0');
            pc <= (others => '0');
        elsif rising_edge(clk) then
        end if;
    end process;

    control_proc:
    process(clk, reset)
        type state_t is (state_idle, state_read_instr, state_decode_instr);
        variable state : state_t;
    begin
        if reset = '1' then
        elsif rising_edge(clk) then
            case state is
                when state_idle         =>
                when state_read_instr   =>
                    addr  <= pc;
                    state := state_decode_instr;
                when state_decode_instr =>
            end case;
        end if;
    end process;

    af <= a & f;
    bc <= b & c;
    de <= d & e;
    hl <= h & l;
end architecture;
