library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_misc.all;
use IEEE.std_logic_textio.all;
use std.textio.all;
use work.types.all;

entity registers_tb is
end;

architecture rtl of registers_tb is
    component registers is
    port( clk        : in  std_logic;
          reset      : in  std_logic;
          we         : in  std_logic;
          write_sel  : in  register_t;
          read_sel   : in  register_t;
          write_data : in  word_t;
          read_data  : out word_t);
    end component;

    signal clk            : std_logic  := '0';
    signal reset          : std_logic  := '1';
    signal we             : std_logic  := '0';
    signal write_data     : word_t     := (others => '0');
    signal read_data      : word_t     := (others => '0');
    signal read_data_cmp  : word_t     := (others => '0');
    signal write_sel      : register_t := (others => '0');
    signal read_sel       : register_t := (others => '0');
    signal lineno         : integer    := 0;
begin
    reset_gen : process
    begin
        reset <= '1';
        wait for 40 ns;
        reset <= '0';
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
        type state_t is (s0, s1, s2, s3);
        variable state  : state_t := s0;
        file input      : text open read_mode is "/home/stuart/VHDL/gbvhdl/testing/tests/registers.txt";
        variable reg_s  : string( 4 downto 1);
        variable data_s : string(16 downto 1);
        variable we_s   : string( 1 downto 1);
        variable dummy  : string( 1 downto 1);
        variable l      : line;
    begin
        if reset = '1' then
            we <= '0';
            write_sel <= register_a;
            read_sel  <= register_a;
        elsif rising_edge(clk) then
            case state is
            when s0 =>
                if endfile(input) then
                    state := s3;
                else
                    readline(input, l);
                    read(l, reg_s);
                    write_sel <= to_std_logic_vector(reg_s);
                    read(l, dummy);
                    read(l, reg_s);
                    read_sel <= to_std_logic_vector(reg_s);
                    read(l, dummy);
                    read(l, we_s);
                    if we_s(1) = '1' then
                        we <= '1';
                    else
                        we <= '0';
                    end if;
                    read(l, dummy);
                    read(l, data_s);
                    write_data <= to_std_logic_vector(data_s);
                    read(l, dummy);
                    read(l, data_s);
                    read_data_cmp  <= to_std_logic_vector(data_s);
                    state := s1;
                end if;
            when s1 =>
                    state := s0;
                    assert read_data_cmp = read_data;
                    lineno <= lineno + 1;
            when s2 =>
                    state := s0;
            when s3 =>
                report "End of simulation" severity failure;
            end case;
        end if;
    end process;

    registers_0 : registers
        port map (clk, reset, we, write_sel, read_sel, write_data, read_data);

end rtl;
