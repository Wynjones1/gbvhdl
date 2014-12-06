#!/usr/bin/env python2.7
import random

xres = 160
yres = 144

with open("src/fb.rom", "w") as fp:
	for y in xrange(yres):
		for x in xrange(xres):
			fp.write("1" if (random.randint(0,1) == 0) else "0")
		fp.write("\n")

with open("src/mem.rom", "w") as fp:
	for y in xrange(2 ** 16):
		for x in xrange(8):
			fp.write("1" if (random.randint(0,1) == 0) else "0")
		fp.write("\n")
