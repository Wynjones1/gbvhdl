library IEEE;
use IEEE.std_logic_1164.all;
use work.types.all;

package common is
--    impure function init_mem(input_file : in string) return 
    function r_table(input : std_logic_vector(2 downto 0)) return register_t;
    function d_table(input : std_logic_vector(1 downto 0)) return register_t;
    function s_table(input : std_logic_vector(1 downto 0)) return register_t;
    function q_table(input : std_logic_vector(1 downto 0)) return register_t;
    function f_table(input : std_logic_vector(2 downto 0)) return alu_op_t;
    function l_table(input : std_logic_vector(2 downto 0)) return alu_op_t;
end;

-- TODO: Maybe add report for invalid values.
package body common is
    function r_table(input : std_logic_vector(2 downto 0)) return register_t is
    begin
        case input is
            when "111"  => return register_a;
            when "000"  => return register_b;
            when "001"  => return register_c;
            when "010"  => return register_d;
            when "011"  => return register_e;
            when "100"  => return register_h;
            when "101"  => return register_l;
            when others => return register_l; -- TODO: Fix
        end case;
    end function;

    function d_table(input : std_logic_vector(1 downto 0)) return register_t is
    begin
        case input is
            when "00"   => return register_bc;
            when "01"   => return register_de;
            when "10"   => return register_hl;
            when "11"   => return register_sp;
            when others => return register_sp; -- TODO: Fix
        end case;
    end function;

    function s_table(input : std_logic_vector(1 downto 0)) return register_t is
    begin
        return d_table(input);
    end function;

    function q_table(input : std_logic_vector(1 downto 0)) return register_t is
    begin
        case input is
            when "00"   => return register_bc;
            when "01"   => return register_de;
            when "10"   => return register_hl;
            when "11"   => return register_af;
            when others => return register_af; -- TODO: Fix
        end case;
    end function;

    function f_table(input : std_logic_vector(2 downto 0)) return alu_op_t is
    begin
        case input is
            when "000"  => return alu_op_add;
            when "001"  => return alu_op_adc;
            when "010"  => return alu_op_sub;
            when "011"  => return alu_op_sbc;
            when "100"  => return alu_op_and;
            when "101"  => return alu_op_xor;
            when "110"  => return alu_op_or;
            when "111"  => return alu_op_cp;
            when others => return alu_op_invalid;
        end case;
    end function;

    function l_table(input : std_logic_vector(2 downto 0)) return alu_op_t is
    begin
        case input is
            when "000"  => return alu_op_rlc;
            when "001"  => return alu_op_rrc;
            when "010"  => return alu_op_rl;
            when "011"  => return alu_op_rr;
            when "100"  => return alu_op_sla;
            when "101"  => return alu_op_sra;
            when "110"  => return alu_op_swap;
            when "111"  => return alu_op_srl;
            when others => return alu_op_invalid;
        end case;
    end function;
end common;
