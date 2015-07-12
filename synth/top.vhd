library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;

entity top is
    port( clk   : in  std_logic;
          reset : in  std_logic;
          an    : out std_logic_vector(3 downto 0);
          disp  : out std_logic_vector(6 downto 0);
          dp    : out std_logic;
          ss    : out std_logic;
          sck   : out std_logic;
          mosi  : out std_logic;
          miso  : in  std_logic;
          sddat : out std_logic_vector(1 downto 0);
          wp    : in  std_logic;
          cd    : in  std_logic;
          led   : out std_logic_vector(7 downto 0);
          HS    : out std_logic;
          VS    : out std_logic;
          colour: out std_logic_vector(7 downto 0));
end top;

architecture rtl of top is
    component clk_gen is
        generic( CLOCK_SPEED : integer := 50_000_000;
                 REQUIRED_HZ : integer := 1);
        port( clk     : in std_logic;
              reset   : in std_logic;
              clk_out : out std_logic);
    end component;

    component ssd is
        port( clk    : in  std_logic;
              reset  : in  std_logic;
              input  : in  std_logic_vector(15 downto 0);
              an_sel : out std_logic_vector( 3 downto 0);
              output : out std_logic_vector( 6 downto 0));
    end component;

    component vga is
        port(clk   : in  std_logic;
             reset : in  std_logic;
             en    : out std_logic;
             HS    : out std_logic;
             VS    : out std_logic;
             pix_x : out integer;
             pix_y : out integer);
    end component;

    constant CLK_HZ   : integer := 50_000_000;
    signal clk_1khz   : std_logic;
    signal clk_1hz    : std_logic;
    signal clk_200hz  : std_logic;
    signal clk_25Mhz  : std_logic;
    signal sck_s      : std_logic;

    signal shift_data : std_logic_vector(7 downto 0) := (others => '0');
    signal clk_count  : integer := 0;
    signal led_s      : std_logic_vector(7 downto 0);
    signal ssd_value  : unsigned(15 downto 0);

    signal cmd_buffer : std_logic_vector(47 downto 0);
    signal vga_en     : std_logic;
    signal pix_x      : integer := 0;
    signal pix_y      : integer := 0;
    signal colour_s   : std_logic_vector(7 downto 0);
begin
    clk_gen_1khz:clk_gen
        generic map ( REQUIRED_HZ => 400_000)
        port    map (clk, reset, clk_1khz);

    clk_gen_200hz:clk_gen
        generic map ( REQUIRED_HZ => 200)
        port    map (clk, reset, clk_200hz);

    clk_gen_1hz:clk_gen
        generic map ( REQUIRED_HZ => 1)
        port    map (clk, reset, clk_1hz);

    clk_gen_25Mhz: clk_gen
        generic map ( REQUIRED_HZ => 25_000_000)
        port    map (clk, reset, clk_25Mhz);

    led <= led_s;
    sck <= not clk_1khz;
    ssd1 : ssd
        port map (clk_200hz, reset, std_logic_vector(ssd_value), an, disp);

    dp <= '1';

    sddat <= "11";

    vga0 : vga
        port map (clk_25mhz, reset, vga_en, HS, VS, pix_x, pix_y);

    main:
    process(clk_1khz, reset)
        type state_t is (state_idle, state_wait_74,
                         state_send_cmd, state_wait_for_resp,
                         state_done, state_read_resp, state_init);
        variable state     : state_t := state_idle;
        variable ret_state : state_t;
        variable count     : integer := 0;
        constant cmd0      : std_logic_vector(47 downto 0) := "010000000000000000000000000000000000000010010101";
        constant cmd1      : std_logic_vector(47 downto 0) := "010000010000000000000000000000000000000000000001";
    begin
        if reset = '1' then
            ssd_value <= x"0000";
            mosi      <= '1';
            ss        <= '1';
            led_s     <= (others => '0');
            state     := state_idle;
            count     := 0;
        elsif rising_edge(clk_1khz) then
            case state is
                when state_idle =>
                    state     := state_wait_74;
                    count     := 74;
                    mosi      <= '1';
                    ss        <= '1';
                    ssd_value(15 downto 12) <= x"0";

                when state_wait_74 =>
                    mosi      <= '1';
                    ss        <= '1';
                    count := count - 1;
                    if count = 0 then
                        state      := state_send_cmd;
                        ret_state  := state_init;
                        count      := 48;
                        cmd_buffer <= cmd0;
                        ss         <= '0';
                    else
                        state := state_wait_74;
                    end if;
                    ssd_value(15 downto 12) <= x"1";

                when state_send_cmd =>
                    count := count - 1;
                    mosi  <= cmd_buffer(count);
                    ss    <= '0';
                    if count = 0 then
                        state := state_wait_for_resp;
                        count := 7;
                    else
                        state := state_send_cmd;
                    end if;
                    ssd_value(15 downto 12) <= x"2";

                when state_wait_for_resp =>
                    mosi <= '1';
                    ss   <= '0';
                    if miso = '0' then
                        state := state_read_resp;
                        led_s(count) <= miso;
                        count := count - 1;
                    else
                        state := state_wait_for_resp;
                    end if;
                    ssd_value(15 downto 12) <= x"3";

                when state_read_resp =>
                    mosi <= '1';
                    ss   <= '0';
                    led_s(count) <= miso;
                    if count = 0 then
                        state := ret_state;
                    else
                        count := count - 1;
                        state := state_read_resp;
                    end if;
                    ssd_value(15 downto 12) <= x"4";

                when state_init =>
                    state      := state_send_cmd;
                    ret_state  := state_done;
                    count      := 48;
                    cmd_buffer <= (others => '1'); --cmd1;
                    led_s      <= (others => '0');
                    ss         <= '0';
                    ssd_value(15 downto 12) <= x"5";
                    ssd_value(11 downto 8)  <= x"5";

                when state_done =>
                    state := state_done;
                    ssd_value(15 downto 12) <= x"6";
            end case;
        end if;
    end process;

    colour_gen:
    process(pix_x, pix_y)
    begin
        if pix_x = 0 or pix_x = 639 or 
           pix_y = 0 or pix_y = 479 then
            colour_s <= "00000111";
        else
            colour_s <= std_logic_vector(to_unsigned(pix_y, 4) & 
                                         to_unsigned(pix_x, 4));
        end if;
    end process;

    colour <= colour_s when vga_en = '1' else (others => '0');
end rtl;
