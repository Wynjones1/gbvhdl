library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.types.all;

entity cpu is
    port(clk        : in  std_logic;
         reset      : in  std_logic);
end entity;

architecture rtl of cpu is
    component alu is
        port( op          : in  alu_op_t;
              i0          : in  byte_t;
              i1          : in  byte_t;
              q           : out byte_t;
              flags_in    : in  byte_t;
              flags_out   : out byte_t);
    end component;
    component memory is
        port( clk      : in  std_logic;
              reset    : in  std_logic;
              we       : in  std_logic;
              address  : in  word_t;
              data_in  : in  byte_t;
              data_out : out byte_t;
              valid    : out std_logic);
    end component;
    component registers is
        port( clk        : in  std_logic;
              reset      : in  std_logic;
              we         : in  std_logic;
              write_sel  : in  register_t;
              read_sel   : in  register_t;
              write_data : in  word_t;
              pc_out     : out word_t;
              read_data  : out word_t);
    end component;

    type state_t is (state_load_instr, state_decode_instr, state_execute_instr);
    signal state : state_t;

    -- alu i/o signals
    signal alu_op        : alu_op_t := (others => '0');
    signal alu_i0        : byte_t   := (others => '0');
    signal alu_i1        : byte_t   := (others => '0');
    signal alu_q         : byte_t   := (others => '0');
    signal alu_flags_in  : byte_t   := (others => '0');
    signal alu_flags_out : byte_t   := (others => '0');
    -- memory i/o signals
    signal mem_we    : std_logic    := '0';
    signal mem_addr  : word_t       := (others => '0');
    signal mem_din   : byte_t       := (others => '0');
    signal mem_dout  : byte_t       := (others => '0');
    signal mem_valid : std_logic    := '0';
    -- register i/o signals
    signal reg_we    : std_logic    := '0';
    signal reg_wsel  : register_t   := (others => '0');
    signal reg_rsel  : register_t   := (others => '0');
    signal reg_wdata : word_t       := (others => '0');
    signal reg_rdata : word_t       := (others => '0');
    -- local signals
    signal pc        : word_t       := (others => '0');
    signal instr     : byte_t       := (others => '0');
begin
    alu0    : alu       port map(alu_op, alu_i0, alu_i1, alu_q, alu_flags_in, alu_flags_out);
    memory0 : memory    port map(clk, reset, mem_we, mem_addr, mem_din, mem_dout, mem_valid);
    reg0    : registers port map(clk, reset, reg_we, reg_wsel, reg_rsel, reg_wdata, pc, reg_rdata);

    control_proc:
    process(clk, reset)
    begin
        if reset = '1' then
            state         <= state_load_instr;
            alu_op        <= (others => '0');
            alu_i0        <= (others => '0');
            alu_i1        <= (others => '0');
            alu_flags_in  <= (others => '0');
            mem_we        <= '0';
            mem_addr      <= (others => '0'); 
            mem_din       <= (others => '0'); 
            reg_we        <= '0';
            reg_wsel      <= (others => '0');
            reg_rsel      <= (others => '0');
            reg_wdata     <= (others => '0');
        elsif rising_edge(clk) then
            case state is
                when state_load_instr    =>
                    mem_addr <= pc;
                    state    <= state_decode_instr;
                when state_decode_instr  =>
                    instr     <= mem_dout;
                    state     <= state_execute_instr;
                    reg_we    <= '1';
                    reg_wsel  <= register_pc;
                    if    mem_dout = "00000000" then -- nop
                    elsif mem_dout = "00000010" then -- load (BC) A
                    elsif mem_dout = "00000111" then -- rlca A
                    elsif mem_dout = "00001000" then -- load (nn) SP
                    elsif mem_dout = "00001010" then -- A (BC)
                    elsif mem_dout = "00010000" then -- stop
                    elsif mem_dout = "00010010" then -- load (DE) A
                    elsif mem_dout = "00010111" then -- rla A
                    elsif mem_dout = "00011000" then -- jr PC + e
                    elsif mem_dout = "00011010" then -- load A (DE)
                    elsif mem_dout = "00011111" then -- rra A
                    elsif mem_dout = "00100010" then -- load (HL++) A
                    elsif mem_dout = "00100111" then -- daa
                    elsif mem_dout = "00101010" then -- load A (HL++)
                    elsif mem_dout = "00101111" then -- cpl A
                    elsif mem_dout = "00110010" then -- load (HL--) A
                    elsif mem_dout = "00110100" then -- inc (HL)
                    elsif mem_dout = "00110101" then -- dec (HL)
                    elsif mem_dout = "00110110" then -- load (HL) n
                    elsif mem_dout = "00111010" then -- load A (HL--)
                    elsif mem_dout = "01110110" then -- halt
                    --These may be moved to the register ones
                    elsif mem_dout = "10000110" then -- add A (HL)
                    elsif mem_dout = "10001110" then -- adc A (HL)
                    elsif mem_dout = "10010110" then -- sub A (HL)
                    elsif mem_dout = "10011110" then -- sbc A (HL)
                    elsif mem_dout = "10100110" then -- and A (HL)
                    elsif mem_dout = "10101110" then -- xor A (HL)
                    elsif mem_dout = "10110110" then --  or A (HL)
                    elsif mem_dout = "10111110" then --  cp A (HL)
                    elsif mem_dout = "11000011" then --  jp nn
                    elsif mem_dout = "11000110" then -- add A n
                    elsif mem_dout = "11001001" then -- ret
                    elsif mem_dout = "11001101" then -- call nn
                    elsif mem_dout = "11001110" then -- adc A n
                    elsif mem_dout = "11010110" then -- sub A n
                    elsif mem_dout = "11011001" then -- reti
                    elsif mem_dout = "11011110" then -- sbc A n
                    elsif mem_dout = "11100000" then -- load (n) A
                    elsif mem_dout = "11100010" then -- load (FF00 + X) A
                    elsif mem_dout = "11100110" then -- and A n
                    elsif mem_dout = "11101000" then -- add SP + e
                    elsif mem_dout = "11101001" then -- jp PC (HL)
                    elsif mem_dout = "11101010" then -- load (nn) A
                    elsif mem_dout = "11101110" then -- xor A n
                    elsif mem_dout = "11110000" then -- load A (n)
                    elsif mem_dout = "11110010" then -- load A (FF00 + C)
                    elsif mem_dout = "11110110" then -- or A n
                    elsif mem_dout = "11111000" then -- load HL SP + e
                    elsif mem_dout = "11111001" then -- load SP HL
                    elsif mem_dout = "11111010" then -- load A (nn)
                    elsif mem_dout = "11111110" then -- cp A n
                    end if;
                when state_execute_instr =>
                    state <= state_load_instr;
            end case;
        end if;
    end process;
end architecture;
