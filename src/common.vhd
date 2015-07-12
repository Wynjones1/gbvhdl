library IEEE;
use IEEE.std_logic_1164.all;
use std.textio.all;
use work.types.all;

package common is
--    impure function init_mem(input_file : in string) return 
    function r_table(input : std_logic_vector(2 downto 0)) return register_t;
    function d_table(input : std_logic_vector(1 downto 0)) return register_t;
    function s_table(input : std_logic_vector(1 downto 0)) return register_t;
    function q_table(input : std_logic_vector(1 downto 0)) return register_t;
    function f_table(input : std_logic_vector(2 downto 0)) return alu_op_t;
    function l_table(input : std_logic_vector(2 downto 0)) return alu_op_t;

    function need_to_jump(cc : std_logic_vector(1 downto 0); flags : std_logic_vector(7 downto 4)) return boolean;

    function read_slv(file fp : text) return std_logic_vector;
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

    function need_to_jump(
        cc    : std_logic_vector(1 downto 0);
        flags : std_logic_vector(7 downto 4))
        return boolean is
    begin
        return ((cc = "00") and (flags(ZERO_BIT)  = '0')) or   -- NZ
               ((cc = "01") and (flags(ZERO_BIT)  = '1')) or   --  Z
               ((cc = "10") and (flags(CARRY_BIT) = '0')) or   -- NC
               ((cc = "11") and (flags(CARRY_BIT) = '1'));     --  C
    end function;

    function read_slv(file fp : text) return std_logic_vector is
        variable bv  : bit_vector(15 downto 0);
        variable slv : std_logic_vector(15 downto 0);
        variable li  : line;
    begin
        if endfile(fp) then
            return "UUUUUUUUUUUUUUUU";
        end if;
        readline(fp, li);
        read(li, bv);
        for i in 0 to 15 loop
            if bv(i) = '1' then
                slv(i) := '1';
            else
                slv(i) := '0';
            end if;
        end loop;
        return slv;
    end function;
end common;
