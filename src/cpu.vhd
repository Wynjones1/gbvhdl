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
    signal instr_string : string(1 to 15);
begin
    alu0    : alu       port map(alu_op, alu_i0, alu_i1, alu_q, alu_flags_in, alu_flags_out);
    memory0 : memory    port map(clk, reset, mem_we, mem_addr, mem_din, mem_dout, mem_valid);
    reg0    : registers port map(clk, reset, reg_we, reg_wsel, reg_rsel, reg_wdata, pc, reg_rdata);

    instr_string <= instruction_to_string(mem_dout);

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
                    state     <= state_execute_instr;
                    reg_we    <= '1';
                    reg_wsel  <= register_pc;
                    if    std_match(mem_dout, "00000000") then  -- NOP   
                    elsif std_match(mem_dout, "00000111") then  -- RLCA  
                    elsif std_match(mem_dout, "00001111") then  -- RRCA  
                    elsif std_match(mem_dout, "00010000") then  -- STOP  
                    elsif std_match(mem_dout, "00010111") then  -- RLA   
                    elsif std_match(mem_dout, "00011000") then  -- JR   r8 
                    elsif std_match(mem_dout, "00011111") then  -- RRA   
                    elsif std_match(mem_dout, "00100111") then  -- DDA   
                    elsif std_match(mem_dout, "00101111") then  -- CPL   
                    elsif std_match(mem_dout, "00110100") then  -- INC  (HL) 
                    elsif std_match(mem_dout, "00110101") then  -- DEC  (HL) 
                    elsif std_match(mem_dout, "00110111") then  -- SCF   
                    elsif std_match(mem_dout, "00111111") then  -- CCF   
                    elsif std_match(mem_dout, "11000011") then  -- JP   d16 
                    elsif std_match(mem_dout, "11001001") then  -- RET   
                    elsif std_match(mem_dout, "11001011") then  -- CB    
                    elsif std_match(mem_dout, "11001101") then  -- CALL d16 
                    elsif std_match(mem_dout, "11011001") then  -- RETI  
                    elsif std_match(mem_dout, "11101000") then  -- ADD  SP r8
                    elsif std_match(mem_dout, "11101001") then  -- JP   PC (HL)
                    elsif std_match(mem_dout, "11110011") then  -- DI    
                    elsif std_match(mem_dout, "11111011") then  -- EI    
                    elsif std_match(mem_dout, "00000010") then  -- LD   (BC) A
                    elsif std_match(mem_dout, "00001000") then  -- LD   (d16) SP
                    elsif std_match(mem_dout, "00001010") then  -- LD   A (BC)
                    elsif std_match(mem_dout, "00010010") then  -- LD   (DE) A
                    elsif std_match(mem_dout, "00011010") then  -- LD   A (DE)
                    elsif std_match(mem_dout, "00100010") then  -- LD   (HL++) A
                    elsif std_match(mem_dout, "00101010") then  -- LD   A (HL++)
                    elsif std_match(mem_dout, "00110010") then  -- LD   (HL--)  A
                    elsif std_match(mem_dout, "00110110") then  -- LD   (HL) d8
                    elsif std_match(mem_dout, "00111010") then  -- LD   A (HL--)
                    elsif std_match(mem_dout, "11100010") then  -- LD   (C) A
                    elsif std_match(mem_dout, "11101010") then  -- LD   (d16) A
                    elsif std_match(mem_dout, "11110010") then  -- LD   A (C)
                    elsif std_match(mem_dout, "11111000") then  -- LD   HL SP + r8
                    elsif std_match(mem_dout, "11111001") then  -- LD   SP HL
                    elsif std_match(mem_dout, "11111010") then  -- LD   A (d16)
                    elsif std_match(mem_dout, "11100000") then  -- LDH  (d8) A
                    elsif std_match(mem_dout, "11110000") then  -- LDH  A (d8)
                    elsif std_match(mem_dout, "11010011") then  -- INVALID  
                    elsif std_match(mem_dout, "11011011") then  -- INVALID  
                    elsif std_match(mem_dout, "11011101") then  -- INVALID  
                    elsif std_match(mem_dout, "11100011") then  -- INVALID  
                    elsif std_match(mem_dout, "11100100") then  -- INVALID  
                    elsif std_match(mem_dout, "11101011") then  -- INVALID  
                    elsif std_match(mem_dout, "11101100") then  -- INVALID  
                    elsif std_match(mem_dout, "11101101") then  -- INVALID  
                    elsif std_match(mem_dout, "11110100") then  -- INVALID  
                    elsif std_match(mem_dout, "11111100") then  -- INVALID  
                    elsif std_match(mem_dout, "11111101") then  -- INVALID  
                    elsif std_match(mem_dout, "01110110") then  -- HALT  
                    elsif std_match(mem_dout, "01110---") then  -- LD   (HL) r'
                    elsif std_match(mem_dout, "001--000") then  -- JR   cc r8
                    elsif std_match(mem_dout, "110--000") then  -- RET  cc 
                    elsif std_match(mem_dout, "110--010") then  -- JP   cc d16
                    elsif std_match(mem_dout, "110--100") then  -- CALL cc d16
                    elsif std_match(mem_dout, "00--0001") then  -- LD   dd d16
                    elsif std_match(mem_dout, "00--0011") then  -- INC  ss 
                    elsif std_match(mem_dout, "00--1001") then  -- ADD  HL ss
                    elsif std_match(mem_dout, "00--1011") then  -- DEC  ss 
                    elsif std_match(mem_dout, "11--0001") then  -- POP  qq 
                    elsif std_match(mem_dout, "11--0101") then  -- PUSH qq 
                    elsif std_match(mem_dout, "00---100") then  -- INC  r 
                    elsif std_match(mem_dout, "00---101") then  -- DEC  r 
                    elsif std_match(mem_dout, "00---110") then  -- LD   r n
                    elsif std_match(mem_dout, "01---110") then  -- LD   r (HL)
                    elsif std_match(mem_dout, "10---110") then  -- f    A (HL)
                    elsif std_match(mem_dout, "11---110") then  -- f    A n
                    elsif std_match(mem_dout, "11---111") then  -- RST  t 
                    elsif std_match(mem_dout, "01------") then  -- LD   r r'
                    elsif std_match(mem_dout, "10------") then  -- f    A r'
                    end if;
                when state_execute_instr =>
                    state <= state_load_instr;
            end case;
        end if;
    end process;
end architecture;
