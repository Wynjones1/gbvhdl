library IEEE;
use IEEE.std_logic_1164.all;
use work.types.all;

package interfaces is
    -- ALU
    type alu_in_if is
        record
            op    : alu_op_t;
            i0    : byte_t;
            i1    : byte_t;
            flags : byte_t;
        end record;
    type alu_out_if is
        record
            q     : byte_t;
            flags : byte_t;
        end record;

    -- Memory
    type memory_in_if is
        record
            we      : std_logic;
            address : word_t;
            data    : byte_t;
        end record;
    type memory_out_if is
        record
            data  : byte_t;
            valid : std_logic;
        end record;

    -- Registers
    type registers_in_if is
        record
            we    : std_logic;
            wsel  : register_t;
            rsel0 : register_t;
            rsel1 : register_t;
            data  : word_t;
        end record;
    type registers_out_if is
        record
            d0 : word_t;
            d1 : word_t;
            a  : byte_t;
            f  : byte_t;
            sp : word_t;
            pc : word_t;
        end record;

    -- Load Logic
    type load_logic_in_if is
        record
            en       : std_logic;
            r0       : register_t;
            r1       : register_t;
            indirect : std_logic_vector(1 downto 0);
            inc_dec  : std_logic_vector(1 downto 0);
            reg      : registers_out_if;
            mem      : memory_out_if;
        end record;
    type load_logic_out_if is
        record
            reg  : registers_in_if;
            mem  : memory_in_if;
            done : std_logic;
            i0   : word_t;
            i1   : word_t;
        end record;
end;
