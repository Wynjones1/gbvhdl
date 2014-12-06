library IEEE;
use IEEE.std_logic_1164.all;

package types is
	subtype reg_t   is std_logic_vector( 7 downto 0);
	subtype reg16_t is std_logic_vector(15 downto 0);

	type op_t is (  op_adc,    op_add,  op_and,
					op_bit,    op_call, op_ccf,
					op_cp,     op_cpl,  op_daa,
					op_dec,    op_di,   op_ei,
					op_halt,   op_inc,  op_jp,
					op_jr,     op_ld,   op_lhd,
					op_nop,    op_or,   op_pop,
					op_prefix, op_push, op_res,
					op_ret,    op_reti, op_rla,
					op_rl,     op_rlca, op_rlc,
					op_rra,    op_rr,   op_rrca,
					op_rrc,    op_rst,  op_sbc,
					op_scf,    op_set,  op_sla,
					op_sra,    op_srl,  op_stop,
					op_sub,    op_swap, op_xor);

	type alu_op_t is (	alu_op_adc,   alu_op_add, alu_op_and,
						alu_op_bit,  alu_op_cp,  alu_op_cpl,
						alu_op_daa,  alu_op_or,  alu_op_rl,
						alu_op_rr,   alu_op_rrc, alu_op_sla,
						alu_op_sra,  alu_op_srl, alu_op_sub,
						alu_op_swap, alu_op_xor);

	constant CARRY_BIT      : integer := 4;
	constant HALF_CARRY_BIT : integer := 5;
	constant SUBTRACT_BIT   : integer := 6;
	constant ZERO_BIT       : integer := 7;
end;
