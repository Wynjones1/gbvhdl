library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_misc.all;
use work.types.all;

entity alu is
	port( op          : in  alu_op_t;
		  i0          : in  reg_t;
		  i1          : in  reg_t;
		  q           : out reg_t;
		  flags_in    : in  reg_t;
		  flags_out   : out reg_t);
end entity;

-- report "res " & integer'image(res);

architecture rtl of alu is
begin
	process(op, i0, i1, flags_in)
		constant RES_WIDTH : integer := i0'length + 1;
		variable res_slv   : std_logic_vector(RES_WIDTH - 1 downto 0);
		variable res       : unsigned(RES_WIDTH - 1 downto 0);
		variable i0_int    : unsigned(i0'length - 1 downto 0);
		variable i1_int    : unsigned(i1'length - 1 downto 0);
		variable carry     : unsigned(0 downto 0);
	begin
		i0_int    := unsigned(i0);
		i1_int    := unsigned(i1);
		carry     := unsigned(flags_in(CARRY_BIT downto CARRY_BIT));
		flags_out <= flags_in;
		case op is
			when alu_op_add  =>
				res     := ('0' & i0_int) + i1_int;
				res_slv := std_logic_vector(res);
				q <= res_slv(7 downto 0);
				flags_out(CARRY_BIT) <= res(8);
				flags_out(ZERO_BIT)  <= nor_reduce(res_slv(7 downto 0));
				res(4 downto 0) := ('0' & i0_int(3 downto 0)) + i1_int(3 downto 0);
				flags_out(HALF_CARRY_BIT) <= res(4);

			when alu_op_adc =>
				res     := (('0' & i0_int) + i1_int) + carry;
				res_slv := std_logic_vector(res);
				q <= res_slv(7 downto 0);
				flags_out(CARRY_BIT) <= res(8);
				flags_out(ZERO_BIT)  <= nor_reduce(res_slv(7 downto 0));
				res(4 downto 0) := ('0' & i0_int(3 downto 0)) + i1_int(3 downto 0) + carry;
				flags_out(HALF_CARRY_BIT) <= res(4);

			when alu_op_and  =>
				q <= i0 and i1;
				flags_out(ZERO_BIT)       <= nor_reduce(i0 and i1);
				flags_out(SUBTRACT_BIT)   <= '0';
				flags_out(CARRY_BIT)      <= '0';
				flags_out(HALF_CARRY_BIT) <= '1';

			when alu_op_bit  => -- bit test, no output at q
				flags_out(ZERO_BIT)       <= not i0(to_integer(i1_int(2 downto 0)));
				flags_out(SUBTRACT_BIT)   <= '0';
				flags_out(HALF_CARRY_BIT) <= '1';

			when alu_op_cp   => -- compare op, no output at q
				if i0_int < i1_int then
					flags_out(CARRY_BIT) <= '1';
				else
					flags_out(CARRY_BIT) <= '0';
				end if;

				if i0_int(3 downto 0) < i1_int(3 downto 0) then
					flags_out(HALF_CARRY_BIT) <= '1';
				else
					flags_out(HALF_CARRY_BIT) <= '0';
				end if;
				flags_out(ZERO_BIT)     <= nor_reduce(std_logic_vector(i0_int - i1_int));
				flags_out(SUBTRACT_BIT) <= '1';

			when alu_op_cpl  =>
				q <= not i0;
				flags_out(HALF_CARRY_BIT) <= '1';
				flags_out(SUBTRACT_BIT)    <= '1';
			when alu_op_daa  =>

			when alu_op_or   => 
				q <= i0 or i1;
				flags_out(ZERO_BIT)       <= nor_reduce(i0 or i1);
				flags_out(SUBTRACT_BIT)   <= '0';
				flags_out(CARRY_BIT)      <= '0';
				flags_out(HALF_CARRY_BIT) <= '1';

			when alu_op_rl   =>
				q <= i0(6 downto 0) & flags_in(CARRY_BIT);
				flags_out(CARRY_BIT)      <= i0(7);
				flags_out(HALF_CARRY_BIT) <= '0';
				flags_out(ZERO_BIT)       <= flags_in(CARRY_BIT) nor nor_reduce(i0(6 downto 0));
				flags_out(SUBTRACT_BIT)   <= '0';

			when alu_op_rr   =>
				q <= flags_in(CARRY_BIT) & i0(7 downto 1);
				flags_out(CARRY_BIT)      <= i0(0);
				flags_out(HALF_CARRY_BIT) <= '0';
				flags_out(ZERO_BIT)       <= flags_in(CARRY_BIT) nor nor_reduce(i0(7 downto 1));
				flags_out(SUBTRACT_BIT)   <= '0';

			when alu_op_rrc  =>
				q <= i0(0) & i0(7 downto 1);
				flags_out(CARRY_BIT)      <= i0(0);
				flags_out(HALF_CARRY_BIT) <= '0';
				flags_out(ZERO_BIT)       <= nor_reduce(i0);
				flags_out(SUBTRACT_BIT)   <= '0';

			when alu_op_sla  =>
				q <= i0(6 downto 0) & '0';
				flags_out(CARRY_BIT)      <= i0(7);
				flags_out(HALF_CARRY_BIT) <= '0';
				flags_out(ZERO_BIT)       <= nor_reduce(i0(6 downto 0));
				flags_out(SUBTRACT_BIT)   <= '0';

			when alu_op_sra  =>
				q <= i0(7) & i0(7 downto 1);
				flags_out(CARRY_BIT)      <= i0(0);
				flags_out(HALF_CARRY_BIT) <= '0';
				flags_out(ZERO_BIT)       <= nor_reduce(i0(7 downto 1));
				flags_out(SUBTRACT_BIT)   <= '0';

			when alu_op_srl  =>
				q <= '0' & i0(7 downto 1);
				flags_out(CARRY_BIT)      <= i0(0);
				flags_out(HALF_CARRY_BIT) <= '0';
				flags_out(ZERO_BIT)       <= nor_reduce(i0(7 downto 1));
				flags_out(SUBTRACT_BIT)   <= '0';

			when alu_op_sub  =>
				res     := '0' & (i0_int - i1_int);
				res_slv := std_logic_vector(res);
				q <= res_slv(7 downto 0);

				if i0_int < i1_int then
					flags_out(CARRY_BIT) <= '1';
				else
					flags_out(CARRY_BIT) <= '0';
				end if;

				if i0_int(3 downto 0) < i1_int(3 downto 0) then
					flags_out(HALF_CARRY_BIT) <= '1';
				else
					flags_out(HALF_CARRY_BIT) <= '0';
				end if;

				flags_out(ZERO_BIT)     <= nor_reduce(res_slv(7 downto 0));
				flags_out(SUBTRACT_BIT) <= '1';

			when alu_op_swap =>
				q(3 downto 0) <= i0(7 downto 4);
				q(7 downto 4) <= i0(3 downto 0);
				flags_out(ZERO_BIT)       <= nor_reduce(i0);
				flags_out(CARRY_BIT)      <= '0';
				flags_out(SUBTRACT_BIT)   <= '0';
				flags_out(HALF_CARRY_BIT) <= '0';

			when alu_op_xor  =>
				res_slv(7 downto 0)       := i0 xor i1;
				flags_out(ZERO_BIT)       <= nor_reduce(res_slv(7 downto 0));
				flags_out(SUBTRACT_BIT)   <= '0';
				flags_out(CARRY_BIT)      <= '0';
				flags_out(HALF_CARRY_BIT) <= '1';
		end case;
	end process;
end rtl;
