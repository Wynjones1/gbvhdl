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
begin
    alu0    : alu       port map(alu_op, alu_i0, alu_i1, alu_q, alu_flags_in, alu_flags_out);
    memory0 : memory    port map(clk, reset, mem_we, mem_addr, mem_din, mem_dout, mem_valid);
    reg0    : registers port map(clk, reset, reg_we, reg_wsel, reg_rsel, reg_wdata, reg_rdata);

    control_proc:
    process(clk, reset)
    begin
        if reset = '1' then
            state         <= state_load_instr;
            alu_op        <= (others => '0');
            alu_i0        <= (others => '0');
            alu_i1        <= (others => '0');
            alu_q         <= (others => '0');
            alu_flags_in  <= (others => '0');
            alu_flags_out <= (others => '0');
            mem_we        <= '0';
            mem_addr      <= (others => '0'); 
            mem_din       <= (others => '0'); 
            mem_dout      <= (others => '0'); 
            mem_valid     <= '0';
            reg_we        <= '0';
            reg_wsel      <= (others => '0');
            reg_rsel      <= (others => '0');
            reg_wdata     <= (others => '0');
            reg_rdata     <= (others => '0');
        elsif rising_edge(clk) then
            case state is
                when state_load_instr    =>
                when state_decode_instr  =>
                when state_execute_instr =>
            end case;
        end if;
    end process;
end architecture;
