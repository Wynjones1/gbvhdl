library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use std.textio.all;
use work.types.all;

entity registers_tb is
end;

architecture rtl of registers_tb is
    component registers is
        port( clk        : in  std_logic;
              reset      : in  std_logic;
              write_data : in  word_t;
              read_data  : out word_t;
              we         : in  std_logic;
              reg_sel    : in  register_t);
    end component;

    signal clk        :  std_logic;
    signal reset      :  std_logic;
    signal write_data :  word_t;
    signal read_data  :  word_t;
    signal we         :  std_logic;
    signal reg_sel    :  register_t;
begin
    reset_gen : process
    begin
        reset <= '0';
        wait for 40 ns;
        reset <= '1';
        wait for 40 ns;
        reset <= '0';
        wait;
    end process;

    clk_gen : process
    begin
        if clk = '1' then
            clk <= '0';
            wait for 10 ns;
        else
            clk <= '1';
            wait for 10 ns;
        end if;
    end process;

    run_test : process(clk, reset)
        type state_t is (s0, s1, s2);
        variable state : state_t := s0;
    begin
        if reset = '1' then
            we <= '0';
            reg_sel <= register_a;
        elsif rising_edge(clk) then
            case state is
            when s0 =>
                we <= '1';
                write_data <= "1111111110101010";
                state := s1;
            when s1 =>
                we      <= '0';
                reg_sel <= std_logic_vector(unsigned(reg_sel) + 1);
                state   := s0;
                if reg_sel = register_pc then
                    state := s2;
                end if;
            when s2 =>
                report "End of simulation" severity failure;
            end case;
        end if;
    end process;
    registers_0 : registers
        port map (clk, reset, write_data, read_data, we, reg_sel);

end rtl;
