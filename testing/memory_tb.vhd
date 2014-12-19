library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_misc.all;
use IEEE.std_logic_textio.all;
use std.textio.all;
use work.types.all;

entity memory_tb is
end;

architecture rtl of memory_tb is 
    component memory is
        port( clk      : in  std_logic;
              reset    : in  std_logic;
              we       : in  std_logic;
              address  : in  word_t;
              data_in  : in  byte_t;
              data_out : out byte_t;
              valid    : out std_logic);
    end component;

    signal clk           : std_logic   := '0';
    signal reset         : std_logic   := '0';
    signal we            : std_logic   := '0';
    signal address       : word_t      := (others => '0');
    signal data_in       : byte_t      := (others => '0');
    signal data_out      : byte_t      := (others => '0');
    signal read_data_cmp : byte_t      := (others => '0');
    signal valid         : std_logic   := '0';
    signal lineno        : integer := 0;
begin
    reset_gen : process
    begin
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
        type state_t is (s0, s1, s2, s3);
        variable state  : state_t := s0;
        file input      : text open read_mode
                            is "/home/stuart/VHDL/gbvhdl/testing/tests/memory.txt";
        variable address_s : string(16 downto 1);
        variable we_s      : string( 1 downto 1);
        variable wdata_s   : string( 8 downto 1);
        variable rdata_s   : string( 8 downto 1);
        variable dummy     : string( 1 downto 1);
        variable l         : line;
    begin
        if reset = '1' then
        elsif rising_edge(clk) then
            case state is
            when s0 =>
                if endfile(input) then
                    state := s3;
                else
                    readline(input, l);
                    read(l, address_s);
                    read(l, dummy);
                    read(l, we_s);
                    read(l, dummy);
                    read(l, wdata_s);
                    read(l, dummy);
                    read(l, rdata_s);

                    if we_s(1) = '1' then
                        we <= '1';
                    else
                        we <= '0';
                    end if;

                    address       <= to_std_logic_vector(address_s);
                    data_in       <= to_std_logic_vector(wdata_s);
                    read_data_cmp <= to_std_logic_vector(rdata_s);
                    state         := s1;
                end if;
            when s1 =>
                    state := s0;
                    assert read_data_cmp = data_out;
                    lineno <= lineno + 1;
            when s2 =>
                    state := s0;
            when s3 =>
                report "End of simulation" severity failure;
            end case;
        end if;
    end process;

    memory_0 : memory
        port map (clk, reset, we, address, data_in, data_out, valid);
end rtl;
