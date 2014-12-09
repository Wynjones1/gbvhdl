#!/usr/bin/env python2.7
from common import *

def alu_op_add(a, b, flags):
    q          = a + b
    out = {}
    out["carry"]      = 1 if q > 0xff else 0
    out["zero"]       = q & 0xff == 0
    out["half_carry"] = 1 if ((a & 0xf) + (b & 0xf) > 0xf) else 0
    out["subtract"]   = 0
    return (Flags(**out), q & 0xff)

def alu_op_adc(a, b, flags):
    q          = a + b + flags.carry;
    out = {}
    out["carry"]      = 1 if q > 0xff else 0
    out["zero"]       = q & 0xff == 0
    out["half_carry"] = 1 if ((a & 0xf) + (b & 0xf) + flags.carry > 0xf) else 0
    out["subtract"]   = 0
    return (Flags(**out), q & 0xff)

def alu_op_and(a, b, flags):
    q   = a & b
    out = {}
    out["carry"]      = 0
    out["zero"]       = (q == 0)
    out["half_carry"] = 1
    out["subtract"]   = 0
    return (Flags(**out), q)

def alu_op_bit(a, b, flags):
    out = {}
    out["carry"]      = flags.carry
    out["zero"]       = ((a >> (b & 0x7)) & 0x1) == 0
    out["half_carry"] = 1
    out["subtract"]   = 0
    return (Flags(**out), 0)

def alu_op_cp(a, b, flags):
    out = {}
    out["carry"]      = (a < b)
    out["zero"]       = (a == b)
    out["half_carry"] = (a & 0xf) < (b & 0xf)
    out["subtract"]   = 1
    return (Flags(**out), 0)

def alu_op_cpl(a, b, flags):
    out = {}
    out["carry"]      = flags.carry
    out["zero"]       = flags.zero
    out["half_carry"] = 1
    out["subtract"]   = 1
    return (Flags(**out), 0xff - a)

def alu_op_daa(a, b, flags):
    out = {}
    out["carry"]      = flags.carry
    out["zero"]       = 1
    out["half_carry"] = 0
    out["subtract"]   = flags.subtract
    return (Flags(**out), 0x00)

def alu_op_or(a, b, flags):
    out = {}
    q = a | b
    out["carry"]      = 0
    out["zero"]       = (q == 0)
    out["half_carry"] = 0
    out["subtract"]   = 0
    return (Flags(**out), q & 0xff)

def alu_op_rl(a, b, flags):
    out = {}
    q = 0xff & ((a << 1) | flags.carry)
    out["carry"]      = (a >> 7) & 0x1
    out["zero"]       = (q == 0)
    out["half_carry"] = 0
    out["subtract"]   = 0
    return (Flags(**out), q)

def alu_op_rr(a, b, flags):
    out = {}
    q = 0xff & ((flags.carry << 7) | (a >> 1))
    out["carry"]      = (a & 0x1)
    out["zero"]       = (q == 0)
    out["half_carry"] = 0
    out["subtract"]   = 0
    return (Flags(**out), q)

def alu_op_rrc(a, b, flags):
    out = {}
    q = 0xff & (((a & 0x1) << 7) | (a >> 1))
    out["carry"]      = (a & 0x1)
    out["zero"]       = (q == 0)
    out["half_carry"] = 0
    out["subtract"]   = 0
    return (Flags(**out), q)

def alu_op_sla(a, b, flags):
    out = {}
    q = 0xff & (a << 1)
    out["carry"]      = (a >> 7) & 0x1
    out["zero"]       = (q == 0)
    out["half_carry"] = 0
    out["subtract"]   = 0
    return (Flags(**out), q)

def alu_op_rlc(a, b, flags):
    out = {}
    q = 0xff & (((a >> 7) & 0x1) | (a << 1))
    out["carry"]      = (a >> 7) & 0x1
    out["zero"]       = (q == 0)
    out["half_carry"] = 0
    out["subtract"]   = 0
    return (Flags(**out), q)

def alu_op_sra(a, b, flags):
    out = {}
    q = 0xff & ((a & (1 << 7)) | a >> 1)
    out["carry"]      = a & 0x1
    out["zero"]       = (q == 0)
    out["half_carry"] = 0
    out["subtract"]   = 0
    return (Flags(**out), q)

def alu_op_srl(a, b, flags):
    out = {}
    q = a >> 1
    out["carry"]      = a & 0x1
    out["zero"]       = (q == 0)
    out["half_carry"] = 0
    out["subtract"]   = 0
    return (Flags(**out), q)

def alu_op_sub(a, b, flags):
    out = {}
    q = a - b
    if a < b:
        q += 0x100
    out["carry"]      = a < b
    out["zero"]       = (q == 0)
    out["half_carry"] = a & 0xf < b & 0xf
    out["subtract"]   = 1
    return (Flags(**out), q)

def alu_op_sbc(a, b, flags):
    q = a - b - flags.carry;
    h = (a & 0xf) - (b & 0xf) - flags.carry
    if q < 0:
        q += 0x100
    out = {}
    out["carry"]      = a < (b + flags.carry) & 0xff
    out["zero"]       = (q == 0)
    out["half_carry"] = (h < 0)
    out["subtract"]   = 1
    return (Flags(**out), q)

def alu_op_swap(a, b, flags):
    out = {}
    q = ((a & 0xf) << 4) | ((a & 0xf0) >> 4)
    out["carry"]      = 0
    out["zero"]       = (q == 0)
    out["half_carry"] = 0
    out["subtract"]   = 0
    return (Flags(**out), q)

def alu_op_set(a, b, flags):
    out = {}
    q = a | (1 << (b & 0x7))
    out["carry"]      = flags.carry 
    out["zero"]       = flags.zero
    out["half_carry"] = flags.half_carry
    out["subtract"]   = flags.subtract
    return (Flags(**out), q & 0xff)

def alu_op_reset(a, b, flags):
    out = {}
    q = a & (0xff - (1 << (b & 0x7)))
    out["carry"]      = flags.carry 
    out["zero"]       = flags.zero
    out["half_carry"] = flags.half_carry
    out["subtract"]   = flags.subtract
    return (Flags(**out), q & 0xff)

def alu_op_xor(a, b, flags):
    out = {}
    q = a ^ b
    out["carry"]      = 0
    out["zero"]       = (q == 0)
    out["half_carry"] = 0
    out["subtract"]   = 0
    return (Flags(**out), q)
