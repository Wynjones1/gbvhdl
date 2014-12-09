#!/usr/bin/env python2.7
import sys
import os
from ops    import *
from common import *

        

def get_result(fp, function):
    function_name = function.__name__
    print(function_name)
    for k in xrange(0x10):
        print("Flags : %s" % k)
        f = int_to_flags(k)
        for i in xrange(0x100):
            for j in xrange(0x100):
                flags, out    = function(j, i, f)
                op_string     = function_name
                input_string  = "%s %s %s" % (to_bin(j), to_bin(i), f)
                output_string = "%s %s"    % (to_bin(out), flags)
                fp.write("%s %s %s\n" % (op_string, input_string, output_string))

def test_data(file0, file1):
    fp0 = open(file0, "r")
    fp1 = open(file1, "r")
    lineno = 0
    while True:
        line0 = fp0.readline()
        line1 = fp1.readline()
        lineno  += 1
        if line0 != line1:
            if line0 == "" or line1 == "":
                print("Files different size")
                return
        #    print("Lines differ at line %d" % lineno)
            sys.stdout.write("%s : %s" % (file0.ljust(max(len(file0), len(file1))),line0))
            sys.stdout.write("%s : %s" % (file1.ljust(max(len(file0), len(file1))),line1))
            return
        if not line0:
            return
def main():
    ops = ( alu_op_adc,   alu_op_add, alu_op_and,
            alu_op_bit,  alu_op_cp,  alu_op_cpl,
            alu_op_daa,  alu_op_or,  alu_op_rl,
            alu_op_rr,   alu_op_rrc, alu_op_sla,alu_op_rlc,
            alu_op_sra,  alu_op_srl, alu_op_sub, alu_op_sbc,
            alu_op_swap, alu_op_set, alu_op_reset, alu_op_xor)
    for op in ops:
        with open("alu/%s.txt" % op.__name__, "w") as fp:
            get_result(fp, op)
    for i in os.listdir("alu"):
        test_data("../output/%s" % i, "alu/%s" % i)

if __name__ == "__main__":
    main()
