library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_misc.all;
use work.types.all;
use work.interfaces.all;

entity alu is
    port( input : in alu_in_if; output : out alu_out_if);
end entity;

architecture rtl of alu is
    signal flags : byte_t;
    signal q     : byte_t;
    signal i0    : byte_t;
    signal i1    : byte_t;
begin
    output.flags <= flags;
    output.q     <= q;
    i0 <= input.i0;
    i1 <= input.i1;
    process(flags, q, i0, i1, input)
        constant RES_WIDTH : integer := input.i0'length + 1;
        variable res_slv   : std_logic_vector(RES_WIDTH - 1 downto 0);
        variable res       : unsigned(RES_WIDTH - 1 downto 0);
        variable i0_int    : unsigned(input.i0'length - 1 downto 0);
        variable i1_int    : unsigned(input.i1'length - 1 downto 0);
        variable carry     : unsigned(0 downto 0);
    begin
        i0_int    := unsigned(input.i0);
        i1_int    := unsigned(input.i1);
        carry     := unsigned(input.flags(CARRY_BIT downto CARRY_BIT));
        flags <= input.flags;
        q <= (others => '0');
        case input.op is
            when alu_op_add  =>
                res     := ('0' & i0_int) + ('0' & i1_int);
                res_slv := std_logic_vector(res);
                q <= res_slv(7 downto 0);
                flags(CARRY_BIT) <= res(8);
                flags(ZERO_BIT)  <= nor_reduce(res_slv(7 downto 0));
                res(4 downto 0) := ('0' & i0_int(3 downto 0)) + i1_int(3 downto 0);
                flags(HALF_CARRY_BIT) <= res(4);
                flags(SUBTRACT_BIT)   <= '0';

            when alu_op_adc =>
                res     := (('0' & i0_int) + i1_int) + carry;
                res_slv := std_logic_vector(res);
                q <= res_slv(7 downto 0);
                flags(CARRY_BIT) <= res(8);
                flags(ZERO_BIT)  <= nor_reduce(res_slv(7 downto 0));
                res(4 downto 0) := ('0' & i0_int(3 downto 0)) + i1_int(3 downto 0) + carry;
                flags(HALF_CARRY_BIT) <= res(4);
                flags(SUBTRACT_BIT)   <= '0';

            when alu_op_and  =>
                q <= i0 and i1;
                flags(ZERO_BIT)       <= nor_reduce(i0 and i1);
                flags(SUBTRACT_BIT)   <= '0';
                flags(CARRY_BIT)      <= '0';
                flags(HALF_CARRY_BIT) <= '1';

            when alu_op_bit  =>
                q <= (others => '0');
                flags(ZERO_BIT)       <= not i0(to_integer(i1_int(2 downto 0)));
                flags(SUBTRACT_BIT)   <= '0';
                flags(HALF_CARRY_BIT) <= '1';

            when alu_op_cp   => -- compare op, no output at q
                q <= (others => '0');
                if i0_int < i1_int then
                    flags(CARRY_BIT) <= '1';
                else
                    flags(CARRY_BIT) <= '0';
                end if;

                if i0_int(3 downto 0) < i1_int(3 downto 0) then
                    flags(HALF_CARRY_BIT) <= '1';
                else
                    flags(HALF_CARRY_BIT) <= '0';
                end if;
                flags(ZERO_BIT)     <= nor_reduce(std_logic_vector(i0_int - i1_int));
                flags(SUBTRACT_BIT) <= '1';

            when alu_op_cpl  =>
                q <= not i0;
                flags(HALF_CARRY_BIT) <= '1';
                flags(SUBTRACT_BIT)   <= '1';

            when alu_op_daa  =>
                res := (others => '0');
                res_slv := std_logic_vector(res);
                
                q <= res_slv(7 downto 0);
                flags(ZERO_BIT)   <= nor_reduce(res_slv);
                flags(HALF_CARRY_BIT) <= '0';

            when alu_op_or   => 
                q <= i0 or i1;
                flags(CARRY_BIT)      <= '0';
                flags(HALF_CARRY_BIT) <= '0';
                flags(SUBTRACT_BIT)   <= '0';
                flags(ZERO_BIT)       <= nor_reduce(i0 or i1);

            when alu_op_rl   =>
                q <= i0(6 downto 0) & input.flags(CARRY_BIT);
                flags(CARRY_BIT)      <= i0(7);
                flags(HALF_CARRY_BIT) <= '0';
                flags(SUBTRACT_BIT)   <= '0';
                flags(ZERO_BIT)       <= nor_reduce(i0(6 downto 0) & input.flags(CARRY_BIT));

            when alu_op_rlc  =>
                q <= i0(6 downto 0) & i0(7);
                flags(CARRY_BIT)      <= i0(7);
                flags(HALF_CARRY_BIT) <= '0';
                flags(SUBTRACT_BIT)   <= '0';
                flags(ZERO_BIT)       <= nor_reduce(i0);

            when alu_op_rr   =>
                q <= input.flags(CARRY_BIT) & i0(7 downto 1);
                flags(CARRY_BIT)      <= i0(0);
                flags(HALF_CARRY_BIT) <= '0';
                flags(SUBTRACT_BIT)   <= '0';
                flags(ZERO_BIT)       <= nor_reduce(input.flags(CARRY_BIT) & i0(7 downto 1));

            when alu_op_rrc  =>
                q <= i0(0) & i0(7 downto 1);
                flags(CARRY_BIT)      <= i0(0);
                flags(HALF_CARRY_BIT) <= '0';
                flags(SUBTRACT_BIT)   <= '0';
                flags(ZERO_BIT)       <= nor_reduce(i0);

            when alu_op_sla  =>
                q <= i0(6 downto 0) & '0';
                flags(CARRY_BIT)      <= i0(7);
                flags(HALF_CARRY_BIT) <= '0';
                flags(SUBTRACT_BIT)   <= '0';
                flags(ZERO_BIT)       <= nor_reduce(i0(6 downto 0));

            when alu_op_sra  =>
                q <= i0(7) & i0(7 downto 1);
                flags(CARRY_BIT)      <= i0(0);
                flags(HALF_CARRY_BIT) <= '0';
                flags(SUBTRACT_BIT)   <= '0';
                flags(ZERO_BIT)       <= nor_reduce(i0(7 downto 1));

            when alu_op_srl  =>
                q <= '0' & i0(7 downto 1);
                flags(CARRY_BIT)      <= i0(0);
                flags(HALF_CARRY_BIT) <= '0';
                flags(SUBTRACT_BIT)   <= '0';
                flags(ZERO_BIT)       <= nor_reduce(i0(7 downto 1));

            when alu_op_sub  =>
                res(7 downto 0) := i0_int - i1_int;
                res_slv := std_logic_vector(res);
                q <= res_slv(7 downto 0);

                if i0_int < i1_int then
                    flags(CARRY_BIT) <= '1';
                else
                    flags(CARRY_BIT) <= '0';
                end if;

                if i0_int(3 downto 0) < i1_int(3 downto 0) then
                    flags(HALF_CARRY_BIT) <= '1';
                else
                    flags(HALF_CARRY_BIT) <= '0';
                end if;

                flags(ZERO_BIT)     <= nor_reduce(res_slv(7 downto 0));
                flags(SUBTRACT_BIT) <= '1';

            when alu_op_sbc =>
                res(7 downto 0) := ((i0_int - i1_int) - carry);
                res_slv := std_logic_vector(res);
                q <= res_slv(7 downto 0);

                if i0_int < (i1_int + carry) then
                    flags(CARRY_BIT) <= '1';
                else
                    flags(CARRY_BIT) <= '0';
                end if;

                if i0_int(3 downto 0) < (('0' & i1_int(3 downto 0)) + carry)  then
                    flags(HALF_CARRY_BIT) <= '1';
                else
                    flags(HALF_CARRY_BIT) <= '0';
                end if;

                flags(SUBTRACT_BIT) <= '1';
                flags(ZERO_BIT)     <= nor_reduce(res_slv(7 downto 0));

            when alu_op_swap =>
                q(3 downto 0) <= i0(7 downto 4);
                q(7 downto 4) <= i0(3 downto 0);
                flags(CARRY_BIT)      <= '0';
                flags(HALF_CARRY_BIT) <= '0';
                flags(SUBTRACT_BIT)   <= '0';
                flags(ZERO_BIT)       <= nor_reduce(i0);
                
            when alu_op_set =>
                q <= i0;
                q(to_integer(i1_int(2 downto 0))) <= '1';
                
            when alu_op_reset =>
                q <= i0;
                q(to_integer(i1_int(2 downto 0))) <= '0';

            when alu_op_xor  =>
                q <= i0 xor i1;
                flags(CARRY_BIT)      <= '0';
                flags(HALF_CARRY_BIT) <= '0';
                flags(SUBTRACT_BIT)   <= '0';
                flags(ZERO_BIT)       <= nor_reduce(i0 xor i1);

            when others =>
                q <= (others => 'X');
        end case;
    end process;
end rtl;
