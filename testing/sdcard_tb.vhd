library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_misc.all;
use IEEE.std_logic_textio.all;
use std.textio.all;
use work.types.all;

entity sdcard_tb is
end;

architecture rtl of sdcard_tb is
    component top is
        port( clk    : in  std_logic;
              reset  : in  std_logic;
              an     : out std_logic_vector(3 downto 0);
              disp   : out std_logic_vector(6 downto 0);
              dp     : out std_logic;
              ss     : out std_logic;
              sck    : out std_logic;
              mosi   : out std_logic;
              miso   : in  std_logic;
              sddat  : out std_logic_vector(1 downto 0);
              wp     : in std_logic;
              cd     : in std_logic;
              led    : out std_logic_vector(7 downto 0);
              HS     : out std_logic;
              VS     : out std_logic;
              colour : out std_logic_vector(7 downto 0));
    end component;
    signal clk    : std_logic := '0';
    signal reset  : std_logic := '1';
    signal an     : std_logic_vector(3 downto 0) := (others => '0');
    signal disp   : std_logic_vector(6 downto 0) := (others => '0');
    signal dp     : std_logic := '0';
    signal ss     : std_logic := '0';
    signal sck    : std_logic := '0';
    signal mosi   : std_logic := '0';
    signal miso   : std_logic := '0';
    signal sddat  : std_logic_vector(1 downto 0) := (others => '0');
    signal wp     : std_logic := '0';
    signal cd     : std_logic := '0';
    signal led    : std_logic_vector(7 downto 0) := (others => '0');
    signal HS     : std_logic;
    signal VS     : std_logic;
    signal colour : std_logic_vector(7 downto 0);
begin
    top0 : top
    port map (clk, reset, an, disp, dp, ss, sck, mosi, miso, sddat, wp, cd, led, HS, VS, colour);

    clkgen:
    process
    begin
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
    end process;

    rstgen:
    process
    begin
        reset <= '1';
        wait for 10 ns;
        reset <= '0';
        wait;
    end process;
     
end rtl;
