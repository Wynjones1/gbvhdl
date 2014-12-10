library IEEE;
use IEEE.std_logic_1164.all;

package types is
    subtype reg_t    is std_logic_vector( 7 downto 0);
    subtype reg16_t  is std_logic_vector(15 downto 0);
    subtype op_t     is std_logic_vector( 5 downto 0);
    subtype alu_op_t is std_logic_vector( 4 downto 0);

    constant op_add    : op_t := "000000";
    constant op_and    : op_t := "000001";
    constant op_bit    : op_t := "000010";
    constant op_call   : op_t := "000011";
    constant op_ccf    : op_t := "000100";
    constant op_cp     : op_t := "000101";
    constant op_cpl    : op_t := "000110";
    constant op_daa    : op_t := "000111";
    constant op_dec    : op_t := "001000";
    constant op_di     : op_t := "001001";
    constant op_ei     : op_t := "001010";
    constant op_halt   : op_t := "001011";
    constant op_inc    : op_t := "001100";
    constant op_jp     : op_t := "001101";
    constant op_jr     : op_t := "001110";
    constant op_ld     : op_t := "001111";
    constant op_lhd    : op_t := "010000";
    constant op_nop    : op_t := "010001";
    constant op_or     : op_t := "010010";
    constant op_pop    : op_t := "010011";
    constant op_prefix : op_t := "010100";
    constant op_push   : op_t := "010101";
    constant op_res    : op_t := "010110";
    constant op_ret    : op_t := "010111";
    constant op_reti   : op_t := "011000";
    constant op_rla    : op_t := "011001";
    constant op_rl     : op_t := "011010";
    constant op_rlca   : op_t := "011011";
    constant op_rlc    : op_t := "011100";
    constant op_rra    : op_t := "011101";
    constant op_rr     : op_t := "011110";
    constant op_rrca   : op_t := "011111";
    constant op_rrc    : op_t := "100000";
    constant op_rst    : op_t := "100001";
    constant op_sbc    : op_t := "100010";
    constant op_scf    : op_t := "100011";
    constant op_set    : op_t := "100100";
    constant op_sla    : op_t := "100101";
    constant op_sra    : op_t := "100110";
    constant op_srl    : op_t := "100111";
    constant op_stop   : op_t := "101000";
    constant op_sub    : op_t := "101001";
    constant op_swap   : op_t := "101010";
    constant op_xor    : op_t := "101011";

    constant alu_op_adc   : alu_op_t := "00000";
    constant alu_op_add   : alu_op_t := "00001";
    constant alu_op_and   : alu_op_t := "00010";
    constant alu_op_bit   : alu_op_t := "00011";
    constant alu_op_cp    : alu_op_t := "00100";
    constant alu_op_cpl   : alu_op_t := "00101";
    constant alu_op_daa   : alu_op_t := "00110";
    constant alu_op_or    : alu_op_t := "00111";
    constant alu_op_rl    : alu_op_t := "01000";
    constant alu_op_rr    : alu_op_t := "01001";
    constant alu_op_rrc   : alu_op_t := "01010";
    constant alu_op_sla   : alu_op_t := "01011";
    constant alu_op_rlc   : alu_op_t := "01100";
    constant alu_op_sra   : alu_op_t := "01101";
    constant alu_op_srl   : alu_op_t := "01110";
    constant alu_op_sub   : alu_op_t := "01111";
    constant alu_op_sbc   : alu_op_t := "10000";
    constant alu_op_swap  : alu_op_t := "10001";
    constant alu_op_set   : alu_op_t := "10010";
    constant alu_op_reset : alu_op_t := "10011";
    constant alu_op_xor   : alu_op_t := "10100";

    constant CARRY_BIT      : integer := 4;
    constant HALF_CARRY_BIT : integer := 5;
    constant SUBTRACT_BIT   : integer := 6;
    constant ZERO_BIT       : integer := 7;
	 
	function alu_op_to_string( in_op : alu_op_t ) return string;
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
            when others =>
                return "INVALID";
        end case;
	 end alu_op_to_string;
end types;
