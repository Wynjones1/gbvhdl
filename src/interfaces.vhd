library IEEE;
use IEEE.std_logic_1164.all;
use work.types.all;

package interfaces is
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
end;
