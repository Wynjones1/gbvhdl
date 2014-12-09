#!/usr/bin/env python2.7

def to_bin(x, width = 8):
    out = bin(x)[2:]
    return out.zfill(width);

class Flags(object):
    def __init__(self, zero, subtract, half_carry, carry):
        self.carry      = 1 if carry      else 0
        self.zero       = 1 if zero       else 0
        self.half_carry = 1 if half_carry else 0
        self.subtract   = 1 if subtract   else 0

    def __repr__(self):
        return "%s%s%s%s0000" % (self.zero, self.subtract, self.half_carry, self.carry)

def int_to_flags(i):
    d = {"carry"      : (i >> 0) & 0x1,
         "half_carry" : (i >> 1) & 0x1,
         "subtract"   : (i >> 2) & 0x1,
         "zero"       : (i >> 3) & 0x1}
    return Flags(**d)
