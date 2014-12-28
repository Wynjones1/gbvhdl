library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_misc.all;
use work.types.all;
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
                     state_immediate, state_store);

    signal alu_in  : alu_in_if;
    signal alu_out : alu_out_if;
    signal state   : state_t;
begin
    alu0 : alu port map(alu_in, alu_out);

    alu_in.op    <= input.op;
    alu_in.i0    <= input.reg.a;
    alu_in.flags <= input.reg.f;
    output.reg.data <= alu_out.q & alu_out.flags;

    main_proc: process(clk, reset)
    variable count : integer := 0;
    begin
        if reset = '1' then
            state <= state_idle;
            output.reg.we <= '0';
            output.mem.we <= '0';
        elsif rising_edge(clk) then
            output.reg.we <= '0';
            output.done   <= '0';
            case state is
                when state_idle      =>
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

                when state_store =>
                    state           <= state_idle;
                    output.done     <= '1';
                    output.reg.we   <= '1';
                    output.reg.wsel <= register_af;
            end case;
        end if;
    end process;
end rtl;
