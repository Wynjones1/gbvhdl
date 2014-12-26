library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_misc.all;
use IEEE.std_logic_textio.all;
use std.textio.all;
use work.types.all;
use work.interfaces.all;

entity load_logic_tb is
end;

architecture rtl of load_logic_tb is 
    component load_logic is
    port( clk    : in  std_logic;
          reset  : in  std_logic;
          input  : in  load_logic_in_if;
          output : out load_logic_out_if);
    end component;

    signal clk           : std_logic   := '0';
    signal reset         : std_logic   := '1';
    signal input         : load_in_if;
    signal output        : load_out_if;
    signal read_data_cmp : byte_t;
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
        file fp  : text open read_mode is "/home/stuart/VHDL/gbvhdl/testing/tests/load_store.txt";
        variable address_s : string(16 downto 1);
        variable we_s      : string( 1 downto 1);
        variable wdata_s   : string( 8 downto 1);
        variable rdata_s   : string( 8 downto 1);
        variable dummy     : string( 1 downto 1);
        variable l         : line;
    begin
        if reset = '1' then
            input.address <= (others => '0');
        elsif rising_edge(clk) then
            case state is
            when s0 =>
                if endfile(fp) then
                    state := s3;
                else
                    readline(fp, l);
                    read(l, address_s);
                    read(l, dummy);
                    read(l, we_s);
                    read(l, dummy);
                    read(l, wdata_s);
                    read(l, dummy);
                    read(l, rdata_s);

                    if we_s(1) = '1' then
                        input.we <= '1';
                    else
                        input.we <= '0';
                    end if;

                    input.address <= to_std_logic_vector(address_s);
                    input.data    <= to_std_logic_vector(wdata_s);
                    read_data_cmp <= to_std_logic_vector(rdata_s);
                    state         := s1;
                end if;
            when s1 =>
                    state := s0;
                    assert read_data_cmp = output.data;
                    lineno <= lineno + 1;
            when s2 =>
                    state := s0;
            when s3 =>
                report "End of simulation" severity failure;
            end case;
        end if;
    end process;

    load_logic_0: load_logic
        port map (clk, reset, input, output);
end rtl;
