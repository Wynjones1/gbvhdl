library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;

entity ssd is
    port( clk    : in  std_logic;
          reset  : in  std_logic;
          input  : in  std_logic_vector(15 downto 0);
          an_sel : out std_logic_vector(3 downto 0);
          output : out std_logic_vector(6 downto 0));
end entity;

architecture rtl of ssd is
    signal cur      : std_logic_vector(3 downto 0);
    signal an_sel_s : std_logic_vector(3 downto 0) := "1110";
begin
    process(cur)
    begin
        case cur is
            when x"0"   => output <= "1000000";
            when x"1"   => output <= "1111001";
            when x"2"   => output <= "0100100";
            when x"3"   => output <= "0110000";
            when x"4"   => output <= "0011001";
            when x"5"   => output <= "0010010";
            when x"6"   => output <= "0000010";
            when x"7"   => output <= "1111000";
            when x"8"   => output <= "0000000";
            when x"9"   => output <= "0010000";
            when x"A"   => output <= "0001000";
            when x"B"   => output <= "0000011";
            when x"C"   => output <= "1000110";
            when x"D"   => output <= "0100001";
            when x"E"   => output <= "0000110";
            when others => output <= "0001110";
        end case;
    end process;

    process(clk, reset)
    begin
        if reset = '1' then
            an_sel_s <= "1110";
        elsif rising_edge(clk) then
            case an_sel_s is
                when "1110"=>
                    an_sel_s <= "1101";
                    cur      <= input( 7 downto  4);
                when "1101" =>
                    an_sel_s <= "1011";
                    cur      <= input(11 downto  8);
                when "1011" =>
                    an_sel_s <= "0111";
                    cur      <= input(15 downto 12);
                when "0111" =>
                    an_sel_s <= "1110";
                    cur      <= input( 3 downto  0);
                when others =>
                    an_sel_s <= "1110";
                    cur      <= input( 3 downto  0);
            end case;
        end if;
    end process;

    an_sel <= "1111" when reset = '1' else an_sel_s;
end rtl;
