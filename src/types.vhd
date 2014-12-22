library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package types is
    subtype byte_t     is std_logic_vector( 7 downto 0);
    subtype word_t     is std_logic_vector(15 downto 0);
    subtype op_t       is std_logic_vector( 5 downto 0);
    subtype alu_op_t   is std_logic_vector( 4 downto 0);
    subtype register_t is std_logic_vector( 3 downto 0);
    subtype HI_BYTE    is natural range 15 downto 8;
    subtype LO_BYTE    is natural range  7 downto 0;

    -- Single register access
    constant register_a  : register_t := "0111";          -- 7
    constant register_f  : register_t := "0110";          -- 6
    constant register_b  : register_t := "0000";          -- 0
    constant register_c  : register_t := "0001";          -- 1
    constant register_d  : register_t := "0010";          -- 2
    constant register_e  : register_t := "0011";          -- 3
    constant register_h  : register_t := "0100";          -- 4
    constant register_l  : register_t := "0101";          -- 5
    constant register_hl_indirect : register_t := "0110"; -- 6
    -- Double register access
    constant register_af : register_t := "1111";
    constant register_bc : register_t := "1000";
    constant register_de : register_t := "1001";
    constant register_hl : register_t := "1010";
    constant register_sp : register_t := "1011";
    constant register_pc : register_t := "1100";

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
    function op_to_string( in_op : op_t ) return string;
    function instruction_to_string(instruction : byte_t) return string;
    function to_std_logic_vector(s: string) return std_logic_vector;
end;



package body types is

    function to_std_logic_vector(s: string) return std_logic_vector is 
        variable slv: std_logic_vector(s'high-s'low downto 0);
        variable k: integer;
    begin
        k := s'high-s'low;
        for i in s'range loop
            if s(i) = '1' then
                slv(k) := '1';
            else
                slv(k) := '0';
            end if;
        k := k - 1;
        end loop;
        return slv;
    end to_std_logic_vector; 

    function alu_op_to_string( in_op : alu_op_t ) return string is
    begin
		case in_op is
            when alu_op_adc   => return "alu_op_adc";
            when alu_op_add   => return "alu_op_add";
            when alu_op_and   => return "alu_op_and";
            when alu_op_bit   => return "alu_op_bit";
            when alu_op_cp    => return "alu_op_cp";
            when alu_op_cpl   => return "alu_op_cpl";
            when alu_op_daa   => return "alu_op_daa";
            when alu_op_or    => return "alu_op_or";
            when alu_op_rl    => return "alu_op_rl";
            when alu_op_rr    => return "alu_op_rr";
            when alu_op_rrc   => return "alu_op_rrc";
            when alu_op_sla   => return "alu_op_sla";
            when alu_op_rlc   => return "alu_op_rlc";
            when alu_op_sra   => return "alu_op_sra";
            when alu_op_srl   => return "alu_op_srl";
            when alu_op_sub   => return "alu_op_sub";
            when alu_op_sbc   => return "alu_op_sbc";
            when alu_op_swap  => return "alu_op_swap";
            when alu_op_set   => return "alu_op_set";
            when alu_op_reset => return "alu_op_reset";
            when alu_op_xor   => return "alu_op_xor";
            when others       => return "INVALID";
        end case;
	 end alu_op_to_string;

     function op_to_string( in_op : op_t ) return string is
     begin
        case in_op is
            when op_add    => return "op_add";
            when op_and    => return "op_and";
            when op_bit    => return "op_bit";
            when op_call   => return "op_call";
            when op_ccf    => return "op_ccf";
            when op_cp     => return "op_cp";
            when op_cpl    => return "op_cpl";
            when op_daa    => return "op_daa";
            when op_dec    => return "op_dec";
            when op_di     => return "op_di";
            when op_ei     => return "op_ei";
            when op_halt   => return "op_halt";
            when op_inc    => return "op_inc";
            when op_jp     => return "op_jp";
            when op_jr     => return "op_jr";
            when op_ld     => return "op_ld";
            when op_lhd    => return "op_lhd";
            when op_nop    => return "op_nop";
            when op_or     => return "op_or";
            when op_pop    => return "op_pop";
            when op_prefix => return "op_prefix";
            when op_push   => return "op_push";
            when op_res    => return "op_res";
            when op_ret    => return "op_ret";
            when op_reti   => return "op_reti";
            when op_rla    => return "op_rla";
            when op_rl     => return "op_rl";
            when op_rlca   => return "op_rlca";
            when op_rlc    => return "op_rlc";
            when op_rra    => return "op_rra";
            when op_rr     => return "op_rr";
            when op_rrca   => return "op_rrca";
            when op_rrc    => return "op_rrc";
            when op_rst    => return "op_rst";
            when op_sbc    => return "op_sbc";
            when op_scf    => return "op_scf";
            when op_set    => return "op_set";
            when op_sla    => return "op_sla";
            when op_sra    => return "op_sra";
            when op_srl    => return "op_srl";
            when op_stop   => return "op_stop";
            when op_sub    => return "op_sub";
            when op_swap   => return "op_swap";
            when op_xor    => return "op_xor";
            when others    => return "INVALID";
        end case;
     end op_to_string;

     function instruction_to_string(instruction : byte_t) return string is
     begin
            if    instruction = x"00" then return "NOP            ";
            elsif instruction = x"01" then return "LD BC d16      ";
            elsif instruction = x"02" then return "LD (BC) A      ";
            elsif instruction = x"03" then return "INC BC         ";
            elsif instruction = x"04" then return "INC B          ";
            elsif instruction = x"05" then return "DEC B          ";
            elsif instruction = x"06" then return "LD B n         ";
            elsif instruction = x"07" then return "RLCA           ";
            elsif instruction = x"08" then return "LD (d16) SP    ";
            elsif instruction = x"09" then return "ADD BC ss      ";
            elsif instruction = x"0a" then return "LD A (BC)      ";
            elsif instruction = x"0b" then return "DEC BC         ";
            elsif instruction = x"0c" then return "INC C          ";
            elsif instruction = x"0d" then return "DEC C          ";
            elsif instruction = x"0e" then return "LD C n         ";
            elsif instruction = x"0f" then return "RRCA           ";
            elsif instruction = x"10" then return "STOP           ";
            elsif instruction = x"11" then return "LD DE d16      ";
            elsif instruction = x"12" then return "LD  (DE) A     ";
            elsif instruction = x"13" then return "INC DE         ";
            elsif instruction = x"14" then return "INC D          ";
            elsif instruction = x"15" then return "DEC D          ";
            elsif instruction = x"16" then return "LD D n         ";
            elsif instruction = x"17" then return "RLA            ";
            elsif instruction = x"18" then return "JR r8          ";
            elsif instruction = x"19" then return "ADD DE ss      ";
            elsif instruction = x"1a" then return "LD A (DE)      ";
            elsif instruction = x"1b" then return "DEC DE         ";
            elsif instruction = x"1c" then return "INC E          ";
            elsif instruction = x"1d" then return "DEC E          ";
            elsif instruction = x"1e" then return "LD E n         ";
            elsif instruction = x"1f" then return "RRA            ";
            elsif instruction = x"20" then return "JR NZ r8       ";
            elsif instruction = x"21" then return "LD HL d16      ";
            elsif instruction = x"22" then return "LD (HL++) A    ";
            elsif instruction = x"23" then return "INC HL         ";
            elsif instruction = x"24" then return "INC H          ";
            elsif instruction = x"25" then return "DEC H          ";
            elsif instruction = x"26" then return "LD H n         ";
            elsif instruction = x"27" then return "DDA            ";
            elsif instruction = x"28" then return "JR Z r8        ";
            elsif instruction = x"29" then return "ADD HL ss      ";
            elsif instruction = x"2a" then return "LD A (HL++)    ";
            elsif instruction = x"2b" then return "DEC HL         ";
            elsif instruction = x"2c" then return "INC L          ";
            elsif instruction = x"2d" then return "DEC L          ";
            elsif instruction = x"2e" then return "LD L n         ";
            elsif instruction = x"2f" then return "CPL            ";
            elsif instruction = x"30" then return "JR NC r8       ";
            elsif instruction = x"31" then return "LD SP d16      ";
            elsif instruction = x"32" then return "LD (HL--)  A   ";
            elsif instruction = x"33" then return "INC SP         ";
            elsif instruction = x"34" then return "INC (HL)       ";
            elsif instruction = x"35" then return "DEC (HL)       ";
            elsif instruction = x"36" then return "LD (HL) d8     ";
            elsif instruction = x"37" then return "SCF            ";
            elsif instruction = x"38" then return "JR C r8        ";
            elsif instruction = x"39" then return "ADD SP ss      ";
            elsif instruction = x"3a" then return "LD A (HL--)    ";
            elsif instruction = x"3b" then return "DEC SP         ";
            elsif instruction = x"3c" then return "INC A          ";
            elsif instruction = x"3d" then return "DEC A          ";
            elsif instruction = x"3e" then return "LD A n         ";
            elsif instruction = x"3f" then return "CCF            ";
            elsif instruction = x"40" then return "LD B B         ";
            elsif instruction = x"41" then return "LD B C         ";
            elsif instruction = x"42" then return "LD B D         ";
            elsif instruction = x"43" then return "LD B E         ";
            elsif instruction = x"44" then return "LD B H         ";
            elsif instruction = x"45" then return "LD B L         ";
            elsif instruction = x"46" then return "LD B (HL)      ";
            elsif instruction = x"47" then return "LD B A         ";
            elsif instruction = x"48" then return "LD C B         ";
            elsif instruction = x"49" then return "LD C C         ";
            elsif instruction = x"4a" then return "LD C D         ";
            elsif instruction = x"4b" then return "LD C E         ";
            elsif instruction = x"4c" then return "LD C H         ";
            elsif instruction = x"4d" then return "LD C L         ";
            elsif instruction = x"4e" then return "LD C (HL)      ";
            elsif instruction = x"4f" then return "LD C A         ";
            elsif instruction = x"50" then return "LD D B         ";
            elsif instruction = x"51" then return "LD D C         ";
            elsif instruction = x"52" then return "LD D D         ";
            elsif instruction = x"53" then return "LD D E         ";
            elsif instruction = x"54" then return "LD D H         ";
            elsif instruction = x"55" then return "LD D L         ";
            elsif instruction = x"56" then return "LD D (HL)      ";
            elsif instruction = x"57" then return "LD D A         ";
            elsif instruction = x"58" then return "LD E B         ";
            elsif instruction = x"59" then return "LD E C         ";
            elsif instruction = x"5a" then return "LD E D         ";
            elsif instruction = x"5b" then return "LD E E         ";
            elsif instruction = x"5c" then return "LD E H         ";
            elsif instruction = x"5d" then return "LD E L         ";
            elsif instruction = x"5e" then return "LD E (HL)      ";
            elsif instruction = x"5f" then return "LD E A         ";
            elsif instruction = x"60" then return "LD H B         ";
            elsif instruction = x"61" then return "LD H C         ";
            elsif instruction = x"62" then return "LD H D         ";
            elsif instruction = x"63" then return "LD H E         ";
            elsif instruction = x"64" then return "LD H H         ";
            elsif instruction = x"65" then return "LD H L         ";
            elsif instruction = x"66" then return "LD H (HL)      ";
            elsif instruction = x"67" then return "LD H A         ";
            elsif instruction = x"68" then return "LD L B         ";
            elsif instruction = x"69" then return "LD L C         ";
            elsif instruction = x"6a" then return "LD L D         ";
            elsif instruction = x"6b" then return "LD L E         ";
            elsif instruction = x"6c" then return "LD L H         ";
            elsif instruction = x"6d" then return "LD L L         ";
            elsif instruction = x"6e" then return "LD L (HL)      ";
            elsif instruction = x"6f" then return "LD L A         ";
            elsif instruction = x"70" then return "LD (HL) B      ";
            elsif instruction = x"71" then return "LD (HL) C      ";
            elsif instruction = x"72" then return "LD (HL) D      ";
            elsif instruction = x"73" then return "LD (HL) E      ";
            elsif instruction = x"74" then return "LD (HL) H      ";
            elsif instruction = x"75" then return "LD (HL) L      ";
            elsif instruction = x"76" then return "HALT           ";
            elsif instruction = x"77" then return "LD (HL) A      ";
            elsif instruction = x"78" then return "LD A B         ";
            elsif instruction = x"79" then return "LD A C         ";
            elsif instruction = x"7a" then return "LD A D         ";
            elsif instruction = x"7b" then return "LD A E         ";
            elsif instruction = x"7c" then return "LD A H         ";
            elsif instruction = x"7d" then return "LD A L         ";
            elsif instruction = x"7e" then return "LD A (HL)      ";
            elsif instruction = x"7f" then return "LD A A         ";
            elsif instruction = x"80" then return "ADD A B        ";
            elsif instruction = x"81" then return "ADD A C        ";
            elsif instruction = x"82" then return "ADD A D        ";
            elsif instruction = x"83" then return "ADD A E        ";
            elsif instruction = x"84" then return "ADD A H        ";
            elsif instruction = x"85" then return "ADD A L        ";
            elsif instruction = x"86" then return "ADD A (HL)     ";
            elsif instruction = x"87" then return "ADD A A        ";
            elsif instruction = x"88" then return "ADC A B        ";
            elsif instruction = x"89" then return "ADC A C        ";
            elsif instruction = x"8a" then return "ADC A D        ";
            elsif instruction = x"8b" then return "ADC A E        ";
            elsif instruction = x"8c" then return "ADC A H        ";
            elsif instruction = x"8d" then return "ADC A L        ";
            elsif instruction = x"8e" then return "ADC A (HL)     ";
            elsif instruction = x"8f" then return "ADC A A        ";
            elsif instruction = x"90" then return "SUB A B        ";
            elsif instruction = x"91" then return "SUB A C        ";
            elsif instruction = x"92" then return "SUB A D        ";
            elsif instruction = x"93" then return "SUB A E        ";
            elsif instruction = x"94" then return "SUB A H        ";
            elsif instruction = x"95" then return "SUB A L        ";
            elsif instruction = x"96" then return "SUB A (HL)     ";
            elsif instruction = x"97" then return "SUB A A        ";
            elsif instruction = x"98" then return "SBC A B        ";
            elsif instruction = x"99" then return "SBC A C        ";
            elsif instruction = x"9a" then return "SBC A D        ";
            elsif instruction = x"9b" then return "SBC A E        ";
            elsif instruction = x"9c" then return "SBC A H        ";
            elsif instruction = x"9d" then return "SBC A L        ";
            elsif instruction = x"9e" then return "SBC A (HL)     ";
            elsif instruction = x"9f" then return "SBC A A        ";
            elsif instruction = x"a0" then return "AND A B        ";
            elsif instruction = x"a1" then return "AND A C        ";
            elsif instruction = x"a2" then return "AND A D        ";
            elsif instruction = x"a3" then return "AND A E        ";
            elsif instruction = x"a4" then return "AND A H        ";
            elsif instruction = x"a5" then return "AND A L        ";
            elsif instruction = x"a6" then return "AND A (HL)     ";
            elsif instruction = x"a7" then return "AND A A        ";
            elsif instruction = x"a8" then return "XOR A B        ";
            elsif instruction = x"a9" then return "XOR A C        ";
            elsif instruction = x"aa" then return "XOR A D        ";
            elsif instruction = x"ab" then return "XOR A E        ";
            elsif instruction = x"ac" then return "XOR A H        ";
            elsif instruction = x"ad" then return "XOR A L        ";
            elsif instruction = x"ae" then return "XOR A (HL)     ";
            elsif instruction = x"af" then return "XOR A A        ";
            elsif instruction = x"b0" then return "OR A B         ";
            elsif instruction = x"b1" then return "OR A C         ";
            elsif instruction = x"b2" then return "OR A D         ";
            elsif instruction = x"b3" then return "OR A E         ";
            elsif instruction = x"b4" then return "OR A H         ";
            elsif instruction = x"b5" then return "OR A L         ";
            elsif instruction = x"b6" then return "OR A (HL)      ";
            elsif instruction = x"b7" then return "OR A A         ";
            elsif instruction = x"b8" then return "CP A B         ";
            elsif instruction = x"b9" then return "CP A C         ";
            elsif instruction = x"ba" then return "CP A D         ";
            elsif instruction = x"bb" then return "CP A E         ";
            elsif instruction = x"bc" then return "CP A H         ";
            elsif instruction = x"bd" then return "CP A L         ";
            elsif instruction = x"be" then return "CP A (HL)      ";
            elsif instruction = x"bf" then return "CP A A         ";
            elsif instruction = x"c0" then return "RET NZ         ";
            elsif instruction = x"c1" then return "POP BC         ";
            elsif instruction = x"c2" then return "JP NZ d16      ";
            elsif instruction = x"c3" then return "JP d16         ";
            elsif instruction = x"c4" then return "CALL NZ d16    ";
            elsif instruction = x"c5" then return "PUSH BC        ";
            elsif instruction = x"c6" then return "ADD A n        ";
            elsif instruction = x"c7" then return "RST 00H        ";
            elsif instruction = x"c8" then return "RET Z          ";
            elsif instruction = x"c9" then return "RET            ";
            elsif instruction = x"ca" then return "JP Z d16       ";
            elsif instruction = x"cb" then return "CB             ";
            elsif instruction = x"cc" then return "CALL Z d16     ";
            elsif instruction = x"cd" then return "CALL d16       ";
            elsif instruction = x"ce" then return "ADC A n        ";
            elsif instruction = x"cf" then return "RST 08H        ";
            elsif instruction = x"d0" then return "RET NC         ";
            elsif instruction = x"d1" then return "POP DE         ";
            elsif instruction = x"d2" then return "JP NC d16      ";
            elsif instruction = x"d3" then return "INVALID        ";
            elsif instruction = x"d4" then return "CALL NC d16    ";
            elsif instruction = x"d5" then return "PUSH DE        ";
            elsif instruction = x"d6" then return "SUB A n        ";
            elsif instruction = x"d7" then return "RST 10H        ";
            elsif instruction = x"d8" then return "RET C          ";
            elsif instruction = x"d9" then return "RETI           ";
            elsif instruction = x"da" then return "JP C d16       ";
            elsif instruction = x"db" then return "INVALID        ";
            elsif instruction = x"dc" then return "CALL C d16     ";
            elsif instruction = x"dd" then return "INVALID        ";
            elsif instruction = x"de" then return "SBC A n        ";
            elsif instruction = x"df" then return "RST 18H        ";
            elsif instruction = x"e0" then return "LDH (d8) A     ";
            elsif instruction = x"e1" then return "POP HL         ";
            elsif instruction = x"e2" then return "LD (C) A       ";
            elsif instruction = x"e3" then return "INVALID        ";
            elsif instruction = x"e4" then return "INVALID        ";
            elsif instruction = x"e5" then return "PUSH HL        ";
            elsif instruction = x"e6" then return "AND A n        ";
            elsif instruction = x"e7" then return "RST 20H        ";
            elsif instruction = x"e8" then return "ADD SP r8      ";
            elsif instruction = x"e9" then return "JP PC (HL)     ";
            elsif instruction = x"ea" then return "LD (d16) A     ";
            elsif instruction = x"eb" then return "INVALID        ";
            elsif instruction = x"ec" then return "INVALID        ";
            elsif instruction = x"ed" then return "INVALID        ";
            elsif instruction = x"ee" then return "XOR A n        ";
            elsif instruction = x"ef" then return "RST 28H        ";
            elsif instruction = x"f0" then return "LDH A (d8)     ";
            elsif instruction = x"f1" then return "POP AF         ";
            elsif instruction = x"f2" then return "LD A (C)       ";
            elsif instruction = x"f3" then return "DI             ";
            elsif instruction = x"f4" then return "INVALID        ";
            elsif instruction = x"f5" then return "PUSH AF        ";
            elsif instruction = x"f6" then return "OR A n         ";
            elsif instruction = x"f7" then return "RST 30H        ";
            elsif instruction = x"f8" then return "LD HL SP + r8  ";
            elsif instruction = x"f9" then return "LD SP HL       ";
            elsif instruction = x"fa" then return "LD A (d16)     ";
            elsif instruction = x"fb" then return "EI             ";
            elsif instruction = x"fc" then return "INVALID        ";
            elsif instruction = x"fd" then return "INVALID        ";
            elsif instruction = x"fe" then return "CP A n         ";
            else  return                          "RST 48H        ";
            end if;
     end function;

end types;
