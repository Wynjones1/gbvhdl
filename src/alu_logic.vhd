library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_misc.all;
use work.types.all;
use work.common.all;
use work.interfaces.all;
use std.textio.all;

entity alu_logic is
    port( clk    : in  std_logic;
          reset  : in  std_logic;
          input  : in  alu_logic_in_if;
          output : out alu_logic_out_if);
end entity;

architecture rtl of alu_logic is
    component alu is
        port( input : in alu_in_if; output : out alu_out_if);
    end component;

    type state_t is (state_idle, state_register,
                     state_indirect_0, state_indirect_1,
                     state_immediate, state_cb_0, state_cb_reg,
                     state_cb_store_reg, state_cb_store_indirect,
                     state_cb_store_flags,
                     state_cb_indirect, state_store);

    signal alu_in  : alu_in_if;
    signal alu_out : alu_out_if;
    signal state   : state_t;
    signal alu_op  : alu_op_t;
begin
    alu0 : alu port map(alu_in, alu_out);
    alu_in.op <= alu_op;

    main_proc: process(clk, reset)
        variable out_reg : register_t;
    begin
        if reset = '1' then
            state <= state_idle;
            output.reg.we <= '0';
            output.mem.we <= '0';
        elsif rising_edge(clk) then
            output.reg.we <= '0';
            output.mem.we <= '0';
            output.done   <= '0';
            case state is
                when state_idle      =>
                    alu_op    <= input.op;
                    alu_in.i0    <= input.reg.a;
                    alu_in.flags <= input.reg.f;
                    if input.en = '1' then
                        case input.mode is
                            when "00" =>
                                state <= state_register;
                                output.reg.rsel0 <= input.rsel;
                            when "01" =>
                                state <= state_immediate;
                                output.mem.address <= std_logic_vector(unsigned(input.reg.pc) + 1);
                            when "10" =>
                                state <= state_indirect_0;
                                output.reg.rsel0 <= register_hl;
                            when "11" =>
                                state <= state_cb_0;
                                output.mem.address <= std_logic_vector(unsigned(input.reg.pc) + 1);
                            when others =>
                        end case;
                    else
                        state <= state_idle;
                    end if;

                when state_register  =>
                    state        <= state_store;
                    alu_in.i1    <= input.reg.d0(LO_BYTE);

                when state_indirect_0 =>
                    state <= state_indirect_1;
                    output.mem.address <= input.reg.d0;

                when state_indirect_1 =>
                    state <= state_store;
                    alu_in.i1 <= input.mem.data;

                when state_immediate =>
                    state <= state_store;
                    alu_in.i1 <= input.mem.data;

                when state_cb_0 =>
                    case input.mem.data(7 downto 6) is
                        when "00" => -- logic
                            alu_op <= l_table(input.mem.data(5 downto 3));
                        when "01" => -- bit
                            alu_op <= alu_op_bit;
                            alu_in.i1 <= "00000" & input.mem.data(5 downto 3);
                        when "10" => -- set
                            alu_op <= alu_op_set;
                            alu_in.i1 <= "00000" & input.mem.data(5 downto 3);
                        when "11" => -- reset
                            alu_op <= alu_op_reset;
                            alu_in.i1 <= "00000" & input.mem.data(5 downto 3);
                        when others =>
                            alu_op <= (others => 'U');
                    end case;

                    if input.mem.data(2 downto 0) = "110" then -- (HL)
                        output.mem.address <= input.reg.hl;
                        state <= state_cb_indirect;
                    else
                        out_reg := r_table(input.mem.data(2 downto 0));
                        output.reg.rsel0 <= out_reg;
                        state <= state_cb_reg;
                    end if;

                when state_cb_reg      =>
                    alu_in.i0 <= input.reg.d0(LO_BYTE);
                    if alu_op = alu_op_bit then
                        state <= state_cb_store_flags;
                    else
                        state <= state_cb_store_reg;
                    end if;

                when state_cb_store_reg =>
                    state                    <= state_cb_store_flags;
                    output.reg.we            <= '1';
                    output.reg.wsel          <= out_reg;
                    output.reg.data(LO_BYTE) <= alu_out.q;

                when state_cb_indirect =>
                    alu_in.i0 <= input.mem.data;
                    if alu_op = alu_op_bit then
                        state <= state_cb_store_flags;
                    else
                        state <= state_cb_store_indirect;
                    end if;

                when state_cb_store_indirect =>
                    state <= state_cb_store_flags;
                    output.mem.we      <= '1';
                    output.mem.address <= input.reg.hl;
                    output.mem.data    <= alu_out.q;

                when state_cb_store_flags =>
                    state <= state_idle;
                    output.done     <= '1';
                    output.reg.we   <= '1';
                    output.reg.wsel <= register_f;
                    output.reg.data(LO_BYTE) <= alu_out.flags;

                when state_store =>
                    state           <= state_idle;
                    output.done     <= '1';
                    output.reg.we   <= '1';
                    output.reg.wsel <= register_af;
                    output.reg.data <= alu_out.q & alu_out.flags;
            end case;
        end if;
    end process;
end rtl;
