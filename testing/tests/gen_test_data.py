#!/usr/bin/env python2.7
import sys


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
	q          = a & b
	out = {}
	out["carry"]      = 0
	out["zero"]       = (q == 0)
	out["half_carry"] = 1
	out["subtract"]   = 0
	return (Flags(**out), q & 0xff)

def get_result(fp, function):
	function_name = function.__name__
	print(function_name)
	for k in xrange(0x10):
		print("Flags : %s" % k)
		f = int_to_flags(k)
		for i in xrange(0x100):
			for j in xrange(0x100):
				flags, out    = function(i, j, f)
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
		if lineno % 100000 == 0:
			print("Processing line %s" % lineno)
		if line0 != line1:
			if line0 == "" or line1 == "":
				print("Files different size")
				return
			print("Lines differ at line %d" % lineno)
			print("%s : %s" % (file0.ljust(max(len(file0), len(file1))),line0))
			print("%s : %s" % (file1.ljust(max(len(file0), len(file1))),line1))
			return
		if not line0:
			return
def main():
	ops = ( alu_op_adc,   alu_op_add, alu_op_and)
	ops = (alu_op_and,)
		#	alu_op_bit,  alu_op_cp,  alu_op_cpl,
		#	alu_op_daa,  alu_op_or,  alu_op_rl,
		#	alu_op_rr,   alu_op_rrc, alu_op_sla,alu_op_rlc,
		#	alu_op_sra,  alu_op_srl, alu_op_sub, alu_op_sbc,
		#	alu_op_swap, alu_op_set, alu_op_reset, alu_op_xor)
	for op in ops:
		with open("tests/alu/%s.txt" % op.__name__, "w") as fp:
			get_result(fp, op)
	test_data("./out.txt", "tests/alu/add.txt")

if __name__ == "__main__":
	main()
