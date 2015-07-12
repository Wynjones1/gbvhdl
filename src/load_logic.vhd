library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.types.all;
use work.interfaces.all;

entity load_logic is
    port( clk    : in std_logic;
          reset  : in std_logic;
          input  : in  load_logic_in_if;
          output : out load_logic_out_if);
end entity;

architecture rtl of load_logic is
    type state_t is (load_idle, load_n_0, load_nn_0, load_r_0, load_indirect, load_have_b, load_n_1, load_nn_1, load_r_1, load_have_a);
    signal state : state_t := load_idle;
    signal a16   : word_t  := (others => '0'); -- write address
begin
    main: process(clk)
        variable d16   : word_t; -- write data
    begin
        if reset = '1' then
            output.mem.address <= (others => '0');
            state <= load_idle;
        elsif rising_edge(clk) then
            output.mem.we <= '0';
            output.reg.we <= '0';
            output.done   <= '0';
            case state is
                when load_idle =>
                    if input.en = '1' then
                        if input.r1 = register_d8 or input.r1 = register_d16 then
                            state <= load_n_0;
                            output.mem.address <= std_logic_vector(unsigned(input.reg.pc) + 1);
                        else
                            state <= load_r_0;
                            output.reg.rsel0 <= input.r1;
                        end if;
                    else
                        state <= load_idle;
                    end if;

                when load_n_0 =>
                    d16(LO_BYTE) := input.mem.data;
                    if input.r1 = register_d16 then
                        state <= load_nn_0;
                        output.mem.address <= std_logic_vector(unsigned(input.reg.pc) + 2);
                    elsif input.indirect = "10" then
                        state <= load_indirect;
                        output.mem.address <= x"ff" & input.mem.data;
                    else
                        state <= load_have_b;
                    end if;

                when load_nn_0 =>
                    d16(HI_BYTE) := input.mem.data;
                    if input.indirect = "10" then
                        state <= load_indirect;
                        output.mem.address <= d16;
                    else
                        state <= load_have_b;
                    end if;

                when load_r_0 =>
                    if input.indirect = "10" then
                        state <= load_indirect;
                        if input.r0(3) = '1' then -- 16bit register
                            output.mem.address <= input.reg.d0;
                        else
                            output.mem.address <= x"ff" & input.reg.d0(LO_BYTE);
                        end if;
                    else
                        state <= load_have_b;
                        d16   := input.reg.d0;
                    end if;

                when load_indirect =>
                    state <= load_have_b;
                    d16(LO_BYTE) := input.mem.data;

                when load_have_b =>
                    if input.r0 = register_d8 or input.r0 = register_d16 then
                        state <= load_n_1;
                        output.mem.address <= std_logic_vector(unsigned(input.reg.pc) + 1);
                    else
                        state <= load_r_1;
                        output.reg.rsel0 <= input.r0;
                    end if;

                when load_n_1 =>
                    if input.r0 = register_d16 then
                        state <= load_have_a;
                        output.mem.address <= x"ff" & input.mem.data;
                    else
                        state <= load_nn_1;
                        a16(LO_BYTE) <= input.mem.data;
                        output.mem.address <= std_logic_vector(unsigned(input.reg.pc) + 2);
                    end if;

                when load_nn_1 =>
                    state <= load_have_a;
                    a16(HI_BYTE) <= input.mem.data;

                when load_r_1 =>
                    if input.indirect = "01" then
                        state <= load_have_a;
                        if input.r0(3) = '1' then -- 16bit
                            output.mem.address <= input.reg.d0;
                        else
                            output.mem.address <= x"ff" & input.reg.d0(LO_BYTE);
                        end if;
                    else
                        state         <= load_idle;
                        output.reg.we <= '1';
                        output.reg.wsel   <= input.r0;
                        output.reg.data   <= d16;
                        output.done       <= '1';
                    end if;

                when load_have_a =>
                    state              <= load_idle;
                    output.mem.we      <= '1';
                    output.mem.address <= a16;
                    output.mem.data    <= d16(LO_BYTE);
                    output.done <= '1';

                    if input.inc_dec = "01" then
                        output.reg.we   <= '1';
                        output.reg.wsel <= input.r0;
                        output.reg.data <= std_logic_vector(unsigned(input.reg.hl) + 1);
                    elsif input.inc_dec = "10" then
                        output.reg.we   <= '1';
                        output.reg.wsel <= input.r0;
                        output.reg.data <= std_logic_vector(unsigned(input.reg.hl) - 1);
                    end if;
            end case;
        end if;
    end process;
end architecture;
