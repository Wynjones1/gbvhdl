#!/usr/bin/env python2.7
from common import *
from random import randint, choice

registers = {\
"a"  : int("0000", 2),
"f"  : int("0001", 2),
"b"  : int("0010", 2),
"c"  : int("0011", 2),
"d"  : int("0100", 2),
"e"  : int("0101", 2),
"h"  : int("0110", 2),
"l"  : int("0111", 2),
"af" : int("1000", 2),
"bc" : int("1001", 2),
"de" : int("1010", 2),
"hl" : int("1011", 2),
"sp" : int("1100", 2),
"pc" : int("1101", 2),
}

def output_line(fp, reg_write, reg_read, we,
                write_data, read_data, reg_w_name, reg_r_name):
    fp.write("%s %s %s %s %s #%s %s\n" %
                    (to_bin(reg_write, 4),
                     to_bin(reg_read, 4),
                     "1" if we else "0",
                     to_bin(write_data, 16),
                     to_bin(read_data, 16),
                     reg_w_name,
                     reg_r_name))

class Registers(object):
    def __init__(self):
        self.regs = [0] * 8
        self.sp   = 0
        self.pc   = 0

    def write(self, reg, value):
        if reg == "af":
            self.regs[registers["a"]] = (value >> 8) & 0xff
            self.regs[registers["f"]] = (value >> 0) & 0xff
        elif reg == "bc":
            self.regs[registers["b"]] = (value >> 8) & 0xff
            self.regs[registers["c"]] = (value >> 0) & 0xff
        elif reg == "de":
            self.regs[registers["d"]] = (value >> 8) & 0xff
            self.regs[registers["e"]] = (value >> 0) & 0xff
        elif reg == "hl":
            self.regs[registers["h"]] = (value >> 8) & 0xff
            self.regs[registers["l"]] = (value >> 0) & 0xff
        elif reg == "sp":
            self.sp = value
        elif reg == "pc":
            self.pc = value
        else:
            self.regs[registers[reg]] = (value) & 0xff

    def read(self, reg):
        if reg == "af":
            return self.regs[registers["a"]] << 8 |  self.regs[registers["f"]];
        elif reg == "bc":
            return self.regs[registers["b"]] << 8 |  self.regs[registers["c"]];
        elif reg == "de":
            return self.regs[registers["d"]] << 8 |  self.regs[registers["e"]];
        elif reg == "hl":
            return self.regs[registers["h"]] << 8 |  self.regs[registers["l"]];
        elif reg == "sp":
            return self.sp
        elif reg == "pc":
            return self.pc
        else:
            return self.regs[registers[reg]];

    def random_op(self):
        we  = randint(0, 1)
        reg_write = choice(registers.keys())
        reg_read  = choice(registers.keys())
        write_data = randint(0, 0xffff)
        read_data = self.read(reg_read)
        if we:
            self.write(reg_write, write_data)
        return (registers[reg_write], registers[reg_read],
                we, write_data, read_data, reg_write, reg_read)


def main():
    fp = open("registers.txt", "w")
    reg = Registers()
    m = 1000000
    for i in xrange(m):
        if i % 10000 == 0:
            f = 100 * float(i) / float(m)
            print("%s" % f)
        output_line(fp, *reg.random_op())

if __name__ == "__main__":
    main()
