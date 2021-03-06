library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;
use work.types.all;
use work.common.all;
use work.interfaces.all;

entity cpu is
    port(clk        : in  std_logic;
         reset      : in  std_logic);
end entity;

architecture rtl of cpu is
    component alu is
        port( input : in alu_in_if; output : out alu_out_if);
    end component;
    component memory is
        port( clk    : in  std_logic;
              reset  : in  std_logic;
              input  : in  memory_in_if;
              output : out memory_out_if);
    end component;
    component registers is
    port( clk    : in  std_logic;
          reset  : in  std_logic;
          input  : in  registers_in_if;
          output : out registers_out_if);
    end component;
    component load_logic is
    port( clk    : in std_logic;
          reset  : in std_logic;
          input  : in load_logic_in_if;
          output : out load_logic_out_if);
    end component;
    component alu_logic is
    port( clk    : in std_logic;
          reset  : in std_logic;
          input  : in  alu_logic_in_if;
          output : out alu_logic_out_if);
    end component;

    type state_t is (state_load_instr, state_decode_instr,
                     state_execute_instr, state_wait_for_load,
                     state_rel_jump, state_call_0, state_call_1,
                     state_dec_double_0, state_dec_double_1,
                     state_inc_double_0, state_inc_double_1,
                     state_ret_0, state_ret_1, state_ret_2,
                     state_push_0, state_push_1, state_push_2,
                     state_pop_0, state_pop_1, state_pop_2, state_pop_3,
                     state_call_2, state_call_3, state_call_4,
                     state_wait_for_alu, state_increment_pc);
    signal state : state_t;

    -- alu i/o signals
    signal alu_in  :alu_logic_in_if;
    signal alu_out :alu_logic_out_if;
    -- memory i/o signals
    signal mem_in     : memory_in_if;
    signal mem_in_mux : memory_in_if;
    signal mem_out    : memory_out_if;
    -- register i/o signals
    signal reg_in     : registers_in_if;
    signal reg_in_mux : registers_in_if;
    signal reg_out    : registers_out_if;

    -- load store i/o signals
    signal load_in  : load_logic_in_if;
    signal load_out : load_logic_out_if;
    -- local signals
    signal pc           : word_t       := (others => '0');
    signal instr_string : string(1 to 15);
    signal immediate    : word_t;
    -- instruction decode signals
    signal r0,r1 : register_t;
    signal f     : alu_op_t;
    signal t     : std_logic_vector(2 downto 0);
    signal cc, dd, qq, ss : register_t;
    -- load_process signals
    signal load_init    : std_logic := '0';
    signal load_cmd     : std_logic_vector(3 downto 0) := (others => '0');
    signal load_arg0    : word_t := (others => '0');
    signal load_arg1    : word_t := (others => '0');
    signal load_reg_out : register_t;
    signal load_en      : std_logic := '0';
    signal alu_en       : std_logic := '0';
    signal instr_size   : integer range 1 to 3;

    signal qq_temp : register_t; -- TODO: Clean up this.
    signal reg_temp : word_t;

begin
    memory0 : memory     port map(clk, reset, mem_in_mux, mem_out);
    reg0    : registers  port map(clk, reset, reg_in_mux, reg_out);
    alu0    : alu_logic  port map(clk, reset, alu_in,     alu_out);
    load0   : load_logic port map(clk, reset, load_in,    load_out);

    load_in.reg <= reg_out;
    load_in.mem <= mem_out;
    alu_in.reg  <= reg_out;
    alu_in.mem  <= mem_out;

    mem_in_mux  <= load_out.mem when load_en = '1' else
                   alu_out.mem  when alu_en  = '1' else
                   mem_in;

    reg_in_mux  <= load_out.reg when load_en = '1' else
                   alu_out.reg  when alu_en  = '1' else
                   reg_in;

    r0 <= r_table(mem_out.data(5 downto 3));
    f  <= f_table(mem_out.data(5 downto 3));
    -- t  <= t_table(mem_out.data(5 downto 3));
    dd <= d_table(mem_out.data(5 downto 4));
    qq <= q_table(mem_out.data(5 downto 4));
    ss <= s_table(mem_out.data(5 downto 4));
    -- cc <= c_table(mem_out.data(4 downto 3));
    r1 <= r_table(mem_out.data(2 downto 0));

    control_proc:
    process(clk, reset)
        variable next_instr : word_t;
        variable temp_addr  : word_t;
    begin
        if reset = '1' then
            state     <= state_load_instr;
            alu_in.en <= '0';
            mem_in.we <= '0'; --   <= (we => '0', others => (others => '0'));
            reg_in.we <= '0'; --   <= (we => '0', others => (others => '0'));
        elsif rising_edge(clk) then
            reg_in.we  <= '0';
            mem_in.we  <= '0';
            case state is
                when state_load_instr    =>
                    mem_in.address <= reg_out.pc;
                    state    <= state_decode_instr;
                when state_decode_instr  =>
                    --report instr_string severity note;
                    instr_string <= instruction_to_string(mem_out.data);
                    state        <= state_execute_instr;
                    instr_size   <= 1;
                    reg_in.wsel  <= register_pc;
                    if    std_match(mem_out.data, "00000000") then  -- NOP   
                        reg_in.we   <= '1';
                        reg_in.data <= std_logic_vector(unsigned(reg_out.pc) + 1);
                        state       <= state_increment_pc;
                    elsif std_match(mem_out.data, "00000111") then  -- RLCA  
                        state <= state_wait_for_alu;
                        alu_in.en   <= '1';
                        alu_en      <= '1';
                        alu_in.mode <= "00";
                        alu_in.op   <= alu_op_rlc;
                        alu_in.rsel <= register_a;
                    elsif std_match(mem_out.data, "00001111") then  -- RRCA  
                        state <= state_wait_for_alu;
                        alu_in.en   <= '1';
                        alu_en      <= '1';
                        alu_in.mode <= "00";
                        alu_in.op   <= alu_op_rrc;
                        alu_in.rsel <= register_a;
                    elsif std_match(mem_out.data, "00010000") then  -- STOP  
                    elsif std_match(mem_out.data, "00010111") then  -- RLA   
                        state <= state_wait_for_alu;
                        alu_in.en   <= '1';
                        alu_en      <= '1';
                        alu_in.mode <= "00";
                        alu_in.op   <= alu_op_rl;
                        alu_in.rsel <= register_a;
                    elsif std_match(mem_out.data, "00011000") then  -- JR   r8 
                        instr_size <= 2;
                        state <= state_rel_jump;
                        mem_in.address <= std_logic_vector(unsigned(reg_out.pc) + 1);
                    elsif std_match(mem_out.data, "00011111") then  -- RRA   
                    elsif std_match(mem_out.data, "00100111") then  -- DDA   
                    elsif std_match(mem_out.data, "00101111") then  -- CPL   
                    elsif std_match(mem_out.data, "00110100") then  -- INC  (HL) 
                        state <= state_wait_for_alu;
                        alu_in.en   <= '1';
                        alu_en      <= '1';
                        alu_in.mode <= "10";
                        alu_in.rsel <= register_hl;
                    elsif std_match(mem_out.data, "00110101") then  -- DEC  (HL) 
                    elsif std_match(mem_out.data, "00110111") then  -- SCF   
                    elsif std_match(mem_out.data, "00111111") then  -- CCF   
                    elsif std_match(mem_out.data, "11000011") then  -- JP   d16 
                    elsif std_match(mem_out.data, "11001001") then  -- RET   
                        state <= state_ret_0;
                        mem_in.address <= reg_out.sp;

                    elsif std_match(mem_out.data, "11001011") then  -- CB
                        state <= state_wait_for_alu;
                        alu_in.en   <= '1';
                        alu_en      <= '1';
                        alu_in.mode <= "11";
                        alu_in.op   <= alu_op_cb;
                        instr_size  <= 2;
                    elsif std_match(mem_out.data, "11001101") then  -- CALL d16 
                        state <= state_call_0;
                        -- TODO: We could start the loads here.
                    elsif std_match(mem_out.data, "11011001") then  -- RETI  
                    elsif std_match(mem_out.data, "11101000") then  -- ADD  SP r8
                    elsif std_match(mem_out.data, "11101001") then  -- JP   PC (HL)
                    elsif std_match(mem_out.data, "11110011") then  -- DI    
                    elsif std_match(mem_out.data, "11111011") then  -- EI    
                    elsif std_match(mem_out.data, "00000010") then  -- LD   (BC) A
                        load_in.en       <= '1';
                        load_en          <= '1';
                        state            <= state_wait_for_load;
                        load_in.r0       <= register_bc;
                        load_in.r1       <= register_a;
                        load_in.indirect <= "01";
                        load_in.inc_dec  <= "00";

                    elsif std_match(mem_out.data, "00001000") then  -- LD   (d16) SP
                        load_in.en       <= '1';
                        load_en          <= '1';
                        state            <= state_wait_for_load;
                        load_in.r0       <= register_d16;
                        load_in.r1       <= register_sp;
                        load_in.indirect <= "01";
                        load_in.inc_dec  <= "00";
                        instr_size       <= 3;

                    elsif std_match(mem_out.data, "00001010") then  -- LD   A (BC)
                        load_in.en       <= '1';
                        load_en          <= '1';
                        state            <= state_wait_for_load;
                        load_in.r0       <= register_a;
                        load_in.r1       <= register_bc;
                        load_in.indirect <= "10";
                        load_in.inc_dec  <= "00";

                    elsif std_match(mem_out.data, "00010010") then  -- LD   (DE) A
                        load_in.en       <= '1';
                        load_en          <= '1';
                        state            <= state_wait_for_load;
                        load_in.r0       <= register_de;
                        load_in.r1       <= register_a;
                        load_in.indirect <= "01";
                        load_in.inc_dec  <= "00";

                    elsif std_match(mem_out.data, "00011010") then  -- LD   A (DE)
                        load_in.en       <= '1';
                        load_en          <= '1';
                        state            <= state_wait_for_load;
                        load_in.r0       <= register_a;
                        load_in.r1       <= register_de;
                        load_in.indirect <= "10";
                        load_in.inc_dec  <= "00";

                    elsif std_match(mem_out.data, "00100010") then  -- LD   (HL++) A
                        load_in.en       <= '1';
                        load_en          <= '1';
                        state            <= state_wait_for_load;
                        load_in.r0       <= register_hl;
                        load_in.r1       <= register_a;
                        load_in.indirect <= "01";
                        load_in.inc_dec  <= "01";

                    elsif std_match(mem_out.data, "00101010") then  -- LD   A (HL++)
                        load_in.en       <= '1';
                        load_en          <= '1';
                        state            <= state_wait_for_load;
                        load_in.r0       <= register_a;
                        load_in.r1       <= register_hl;
                        load_in.indirect <= "10";
                        load_in.inc_dec  <= "01";

                    elsif std_match(mem_out.data, "00110010") then  -- LD   (HL--)  A
                        load_in.en       <= '1';
                        load_en          <= '1';
                        state            <= state_wait_for_load;
                        load_in.r0       <= register_hl;
                        load_in.r1       <= register_a;
                        load_in.indirect <= "01";
                        load_in.inc_dec  <= "10";

                    elsif std_match(mem_out.data, "00110110") then  -- LD   (HL) d8
                        load_in.en       <= '1';
                        load_en          <= '1';
                        state            <= state_wait_for_load;
                        load_in.r0       <= register_hl;
                        load_in.r1       <= register_d8;
                        load_in.indirect <= "10";
                        load_in.inc_dec  <= "00";
                        instr_size       <= 2;

                    elsif std_match(mem_out.data, "00111010") then  -- LD   A (HL--)
                        load_in.en       <= '1';
                        load_en          <= '1';
                        state            <= state_wait_for_load;
                        load_in.r0       <= register_sp;
                        load_in.r1       <= register_hl;
                        load_in.indirect <= "00";
                        load_in.inc_dec  <= "01";

                    elsif std_match(mem_out.data, "11100010") then  -- LD   (C) A
                        load_in.en       <= '1';
                        load_en          <= '1';
                        state            <= state_wait_for_load;
                        load_in.r0       <= register_c;
                        load_in.r1       <= register_a;
                        load_in.indirect <= "01";
                        load_in.inc_dec  <= "00";

                    elsif std_match(mem_out.data, "11101010") then  -- LD   (d16) A
                        load_in.en       <= '1';
                        load_en          <= '1';
                        state            <= state_wait_for_load;
                        load_in.r0       <= register_d16;
                        load_in.r1       <= register_a;
                        load_in.indirect <= "01";
                        load_in.inc_dec  <= "00";
                        instr_size       <= 3;

                    elsif std_match(mem_out.data, "11110010") then  -- LD   A (C)
                        load_in.en       <= '1';
                        load_en          <= '1';
                        state            <= state_wait_for_load;
                        load_in.r0       <= register_a;
                        load_in.r1       <= register_c;
                        load_in.indirect <= "10";
                        load_in.inc_dec  <= "00";

                    elsif std_match(mem_out.data, "11111000") then  -- LD   HL SP + r8
                        load_in.en       <= '1';
                        load_en          <= '1';
                        state            <= state_wait_for_load;
                        load_in.r0       <= register_hl;
                        load_in.r1       <= register_sp;
                        load_in.indirect <= "00";
                        load_in.inc_dec  <= "11";
                        instr_size       <= 2;

                    elsif std_match(mem_out.data, "11111001") then  -- LD   SP HL
                        load_in.en       <= '1';
                        load_en          <= '1';
                        state            <= state_wait_for_load;
                        load_in.r0       <= register_sp;
                        load_in.r1       <= register_hl;
                        load_in.indirect <= "00";
                        load_in.inc_dec  <= "00";

                    elsif std_match(mem_out.data, "11111010") then  -- LD   A (d16)
                        load_in.en       <= '1';
                        load_en          <= '1';
                        state            <= state_wait_for_load;
                        load_in.r0       <= register_a;
                        load_in.r1       <= register_d16;
                        load_in.indirect <= "10";
                        load_in.inc_dec  <= "00";
                        instr_size       <= 3;

                    elsif std_match(mem_out.data, "11100000") then  -- LDH  (d8) A
                        load_in.en       <= '1';
                        load_en          <= '1';
                        state            <= state_wait_for_load;
                        load_in.r0       <= register_d8;
                        load_in.r1       <= register_a;
                        load_in.indirect <= "01";
                        load_in.inc_dec  <= "00";
                        instr_size       <= 2;

                    elsif std_match(mem_out.data, "11110000") then  -- LDH  A (d8)
                        load_in.en       <= '1';
                        load_en          <= '1';
                        state            <= state_wait_for_load;
                        load_in.r0       <= register_a;
                        load_in.r1       <= register_d8;
                        load_in.indirect <= "10";
                        load_in.inc_dec  <= "00";
                        instr_size       <= 2;

                    elsif std_match(mem_out.data, "11010011") then  -- INVALID  
                    elsif std_match(mem_out.data, "11011011") then  -- INVALID  
                    elsif std_match(mem_out.data, "11011101") then  -- INVALID  
                    elsif std_match(mem_out.data, "11100011") then  -- INVALID  
                    elsif std_match(mem_out.data, "11100100") then  -- INVALID  
                    elsif std_match(mem_out.data, "11101011") then  -- INVALID  
                    elsif std_match(mem_out.data, "11101100") then  -- INVALID  
                    elsif std_match(mem_out.data, "11101101") then  -- INVALID  
                    elsif std_match(mem_out.data, "11110100") then  -- INVALID  
                    elsif std_match(mem_out.data, "11111100") then  -- INVALID  
                    elsif std_match(mem_out.data, "11111101") then  -- INVALID  
                    elsif std_match(mem_out.data, "01110110") then  -- HALT  
                    elsif std_match(mem_out.data, "01110---") then  -- LD   (HL) r'
                        load_in.en       <= '1';
                        load_en          <= '1';
                        state            <= state_wait_for_load;
                        load_in.r0       <= register_hl;
                        load_in.r1       <= r1;
                        load_in.indirect <= "01";
                        load_in.inc_dec  <= "00";

                    elsif std_match(mem_out.data, "001--000") then  -- JR   cc r8
                        instr_size <= 2;
                        if need_to_jump(mem_out.data(4 downto 3), reg_out.f(7 downto 4)) then
                                state <= state_rel_jump;
                                mem_in.address <= std_logic_vector(unsigned(reg_out.pc) + 1);
                        else
                            reg_in.we   <= '1';
                            reg_in.wsel <= register_pc;
                            reg_in.data <= std_logic_vector(unsigned(reg_out.pc) + 2);
                            state       <= state_increment_pc;
                        end if;

                    elsif std_match(mem_out.data, "110--000") then  -- RET  cc 
                    elsif std_match(mem_out.data, "110--010") then  -- JP   cc d16
                    elsif std_match(mem_out.data, "110--100") then  -- CALL cc d16
                    elsif std_match(mem_out.data, "00--0001") then  -- LD   dd d16
                        load_in.en       <= '1';
                        load_en          <= '1';
                        state            <= state_wait_for_load;
                        load_in.r0       <= dd;
                        load_in.r1       <= register_d16;
                        load_in.indirect <= "00";
                        load_in.inc_dec  <= "00";
                        instr_size       <= 3;

                    elsif std_match(mem_out.data, "00--0011") then  -- INC  ss 
                        state <= state_inc_double_0;
                        reg_in.rsel0 <= ss;

                    elsif std_match(mem_out.data, "00--1001") then  -- ADD  HL ss
                    elsif std_match(mem_out.data, "00--1011") then  -- DEC  ss 
                        state <= state_dec_double_0;
                        reg_in.rsel0 <= ss;

                    elsif std_match(mem_out.data, "11--0001") then  -- POP  qq 
                        state <= state_pop_0;
                        mem_in.address <= reg_out.sp;
                        qq_temp <= qq;

                    elsif std_match(mem_out.data, "11--0101") then  -- PUSH qq 
                        state <= state_push_0;
                        reg_in.rsel0 <= qq;

                    elsif std_match(mem_out.data, "00---100") then  -- INC  r 
                        state <= state_wait_for_alu;
                        alu_in.en   <= '1';
                        alu_en      <= '1';
                        alu_in.mode <= alu_mode_register;
                        alu_in.rsel <= r0;
                        alu_in.op   <= alu_op_inc;

                    elsif std_match(mem_out.data, "00---101") then  -- DEC  r 
                        state <= state_wait_for_alu;
                        alu_in.en   <= '1';
                        alu_en      <= '1';
                        alu_in.mode <= alu_mode_register;
                        alu_in.rsel <= r0;
                        alu_in.op   <= alu_op_dec;

                    elsif std_match(mem_out.data, "00---110") then  -- LD   r n
                        load_in.en       <= '1';
                        load_en          <= '1';
                        state            <= state_wait_for_load;
                        load_in.r0       <= r0;
                        load_in.r1       <= register_d8;
                        load_in.indirect <= "00";
                        load_in.inc_dec  <= "00";
                        instr_size       <= 2;

                    elsif std_match(mem_out.data, "01---110") then  -- LD   r (HL)
                        load_in.en       <= '1';
                        load_en          <= '1';
                        state            <= state_wait_for_load;
                        load_in.r0       <= r0;
                        load_in.r1       <= register_hl;
                        load_in.indirect <= "10";
                        load_in.inc_dec  <= "00";

                    elsif std_match(mem_out.data, "10---110") then  -- f    A (HL)
                        alu_in.op   <= f;
                        alu_in.en   <= '1';
                        alu_en      <= '1';
                        alu_in.mode <= "10";
                        state <= state_wait_for_alu;

                    elsif std_match(mem_out.data, "11---110") then  -- f    A n
                        alu_in.op   <= f;
                        alu_in.en   <= '1';
                        alu_en      <= '1';
                        alu_in.mode <= "01";
                        state <= state_wait_for_alu;
                        instr_size       <= 2;

                    elsif std_match(mem_out.data, "11---111") then  -- RST  t 
                    elsif std_match(mem_out.data, "01------") then  -- LD   r r'
                        load_in.en       <= '1';
                        load_en          <= '1';
                        state            <= state_wait_for_load;
                        load_in.r0       <= r0;
                        load_in.r1       <= r1;
                        load_in.indirect <= "00";
                        load_in.inc_dec  <= "00";

                    elsif std_match(mem_out.data, "10------") then  -- f    A r'
                        state       <= state_wait_for_alu;
                        alu_in.op   <= f;
                        alu_in.rsel <= r1;
                        alu_in.en   <= '1';
                        alu_in.mode <= "00";
                        alu_en      <= '1';

                    end if;
                when state_execute_instr =>
                    state <= state_load_instr;

                when state_wait_for_load =>
                    load_in.en <= '0';
                    if load_out.done = '1' then
                        state       <= state_increment_pc;
                        alu_en      <= '0';
                        load_en     <= '0';
                        reg_in.we   <= '1';
                        reg_in.data <= std_logic_vector(unsigned(reg_out.pc) + instr_size);
                    else
                        state <= state_wait_for_load;
                    end if;

                when state_wait_for_alu =>
                    alu_in.en <= '0';
                    if alu_out.done = '1' then
                        state       <= state_increment_pc;
                        alu_en      <= '0';
                        load_en     <= '0';
                        reg_in.we   <= '1';
                        reg_in.data <= std_logic_vector(unsigned(reg_out.pc) + instr_size);
                    else
                        state <= state_wait_for_alu;
                    end if;

                when state_rel_jump =>
                    state <= state_increment_pc;
                    reg_in.we   <= '1';
                    reg_in.wsel <= register_pc;
                    reg_in.data <= std_logic_vector( unsigned(reg_out.pc) + unsigned(resize(signed(mem_out.data), 16)) + 2);

                when state_call_0 =>
                    -- Calculate return instruction
                    next_instr     := std_logic_vector(unsigned(reg_out.pc) + 3);
                    state          <= state_call_1;
                    -- Write top byte of return address.
                    mem_in.we      <= '1';
                    mem_in.address <= std_logic_vector(unsigned(reg_out.sp) - 1);
                    mem_in.data    <= next_instr(HI_BYTE);

                when state_call_1 =>
                    temp_addr       := std_logic_vector(unsigned(reg_out.sp) - 2);
                    state           <= state_call_2;
                    -- Write bottom byte of return address.
                    mem_in.we      <= '1';
                    mem_in.address <= temp_addr;
                    mem_in.data    <= next_instr(LO_BYTE);
                    -- Adjust the stack pointer
                    reg_in.we      <= '1';
                    reg_in.wsel    <= register_sp;
                    reg_in.data    <= temp_addr;

                when state_call_2 =>
                    -- Set up read of first immediate byte.
                    state <= state_call_3;
                    mem_in.address <= std_logic_vector(unsigned(reg_out.pc) + 1);

                when state_call_3 =>
                    state <= state_call_4;
                    temp_addr(LO_BYTE) := mem_out.data;
                    -- Set up read of second immediate byte.
                    mem_in.address <= std_logic_vector(unsigned(reg_out.pc) + 2);

                when state_call_4 =>
                    state              <= state_increment_pc;
                    temp_addr(HI_BYTE) := mem_out.data;
                    reg_in.we          <= '1';
                    reg_in.wsel        <= register_pc;
                    reg_in.data        <= temp_addr;

                when state_push_0 =>
                    state <= state_push_1;
                    mem_in.we      <= '1';
                    mem_in.address <= std_logic_vector(unsigned(reg_out.sp) - 1);
                    mem_in.data    <= reg_out.d0(HI_BYTE);

                when state_push_1 =>
                    state <= state_push_2;
                    temp_addr      := std_logic_vector(unsigned(reg_out.sp) - 2);
                    mem_in.we      <= '1';
                    mem_in.address <= temp_addr;
                    mem_in.data    <= reg_out.d0(LO_BYTE);
                    reg_in.we      <= '1';
                    reg_in.wsel    <= register_sp;
                    reg_in.data    <= temp_addr;

                when state_push_2 =>
                    state <= state_increment_pc;
                    reg_in.we          <= '1';
                    reg_in.wsel        <= register_pc;
                    reg_in.data        <= std_logic_vector(unsigned(reg_out.pc) + 1);

                when state_pop_0 =>
                    state <= state_pop_1;
                    mem_in.address <= std_logic_vector(unsigned(reg_out.sp) + 1);
                    reg_temp(LO_BYTE) <= mem_out.data;

                when state_pop_1 =>
                    state       <= state_pop_2;
                    reg_in.we   <= '1';
                    reg_in.wsel <= qq_temp;
                    reg_in.data <= mem_out.data & reg_temp(LO_BYTE);

                when state_pop_2 =>
                    state       <= state_pop_3;
                    reg_in.we   <= '1';
                    reg_in.wsel <= register_sp;
                    reg_in.data <= std_logic_vector(unsigned(reg_out.sp) + 2);

                when state_pop_3 =>
                    state <= state_increment_pc;
                    reg_in.we <= '1';
                    reg_in.wsel <= register_pc;
                    reg_in.data <= std_logic_vector(unsigned(reg_out.pc) + 1);

                when state_inc_double_0 =>
                    state <= state_inc_double_1;
                    reg_in.we   <= '1';
                    reg_in.wsel <= ss;
                    reg_in.data <= std_logic_vector(unsigned(reg_out.d0) + 1);

                when state_inc_double_1 =>
                    state <= state_increment_pc;
                    reg_in.we   <= '1';
                    reg_in.wsel <= register_pc;
                    reg_in.data <= std_logic_vector(unsigned(reg_out.pc) + 1);

                when state_dec_double_0 =>
                    state <= state_dec_double_1;
                    reg_in.we   <= '1';
                    reg_in.wsel <= ss;
                    reg_in.data <= std_logic_vector(unsigned(reg_out.d0) - 1);

                when state_dec_double_1 =>
                    state <= state_increment_pc;
                    reg_in.we   <= '1';
                    reg_in.wsel <= register_pc;
                    reg_in.data <= std_logic_vector(unsigned(reg_out.pc) + 1);

                when state_ret_0 =>
                    state <= state_ret_1;
                    reg_temp(LO_BYTE) <= mem_out.data;
                    mem_in.address    <= std_logic_vector(unsigned(reg_out.sp) + 1);

                when state_ret_1 =>
                    state <= state_ret_2;
                    reg_in.we   <= '1';
                    reg_in.wsel <= register_pc;
                    reg_in.data <= mem_out.data & reg_temp(LO_BYTE);

                when state_ret_2 =>
                    state <= state_increment_pc;
                    reg_in.we <= '1';
                    reg_in.wsel <= register_sp;
                    reg_in.data <= std_logic_vector(unsigned(reg_out.sp) + 2);

                when state_increment_pc =>
                    state <= state_load_instr;

            end case;
        end if;
    end process;
end architecture;
