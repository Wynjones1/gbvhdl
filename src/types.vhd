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

    type alu_op_t is (  alu_op_adc,   alu_op_add, alu_op_and,
                        alu_op_bit,  alu_op_cp,  alu_op_cpl,
                        alu_op_daa,  alu_op_or,  alu_op_rl,
                        alu_op_rr,   alu_op_rrc, alu_op_sla,alu_op_rlc,
                        alu_op_sra,  alu_op_srl, alu_op_sub, alu_op_sbc,
                        alu_op_swap, alu_op_set, alu_op_reset, alu_op_xor);

    constant CARRY_BIT      : integer := 4;
    constant HALF_CARRY_BIT : integer := 5;
    constant SUBTRACT_BIT   : integer := 6;
    constant ZERO_BIT       : integer := 7;
	 
	 function alu_op_to_string( in_op : alu_op_t ) return string;
     function string_to_alu_op( in_string : string) return alu_op_t;
end;

package body types is
	 function alu_op_to_string( in_op : alu_op_t ) return string is
	 begin
		case in_op is
            when alu_op_adc   => 
                return "alu_op_adc";
            when alu_op_add   => 
                return "alu_op_add";
            when alu_op_and   => 
                return "alu_op_and";
            when alu_op_bit   => 
                return "alu_op_bit";
            when alu_op_cp    => 
                return "alu_op_cp";
            when alu_op_cpl   => 
                return "alu_op_cpl";
            when alu_op_daa   => 
                return "alu_op_daa";
            when alu_op_or    => 
                return "alu_op_or";
            when alu_op_rl    => 
                return "alu_op_rl";
            when alu_op_rr    => 
                return "alu_op_rr";
            when alu_op_rrc   => 
                return "alu_op_rrc";
            when alu_op_sla   => 
                return "alu_op_sla";
            when alu_op_rlc   => 
                return "alu_op_rlc";
            when alu_op_sra   => 
                return "alu_op_sra";
            when alu_op_srl   => 
                return "alu_op_srl";
            when alu_op_sub   => 
                return "alu_op_sub";
            when alu_op_sbc   => 
                return "alu_op_sbc";
            when alu_op_swap  => 
                return "alu_op_swap";
            when alu_op_set   => 
                return "alu_op_set";
            when alu_op_reset => 
                return "alu_op_reset";
            when alu_op_xor   =>
                return "alu_op_xor";
        end case;
	 end alu_op_to_string;

	 function string_to_alu_op( in_string : string) return alu_op_t is
	 begin
		case in_string is
            when "alu_op_adc" =>
                return alu_op_adc; 
            when "alu_op_add" =>
                return alu_op_add; 
            when "alu_op_and" =>
                return alu_op_and; 
            when "alu_op_bit" =>
                return alu_op_bit; 
            when "alu_op_cpl" =>
                return alu_op_cpl; 
            when "alu_op_cp" =>
                return alu_op_cp; 
            when "alu_op_daa" =>
                return alu_op_daa; 
            when "alu_op_or" =>
                return alu_op_or; 
            when "alu_op_rrc" =>
                return alu_op_rrc; 
            when "alu_op_rr" =>
                return alu_op_rr; 
            when "alu_op_sla" =>
                return alu_op_sla; 
            when "alu_op_rlc" =>
                return alu_op_rlc; 
            when "alu_op_rl" =>
                return alu_op_rl; 
            when "alu_op_sra" =>
                return alu_op_sra; 
            when "alu_op_srl" =>
                return alu_op_srl; 
            when "alu_op_sub" =>
                return alu_op_sub; 
            when "alu_op_sbc" =>
                return alu_op_sbc; 
            when "alu_op_swap" =>
                return alu_op_swap; 
            when "alu_op_set" =>
                return alu_op_set; 
            when "alu_op_reset" =>
                return alu_op_reset; 
            when "alu_op_xor" =>
                return alu_op_xor;
            when others =>
                report "Error invalid alu op" severity failure;
                return alu_op_xor;
        end case;
	 end string_to_alu_op;
end types;
