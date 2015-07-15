#!/usr/bin/env python2.7
from random import randint, choice, seed
from common import *

class Memory(object):
    def __init__(self, filename):
        self.data = []
        fp = open(filename, "rb")
        byte = fp.read(1)
        while byte != "":
            self.data.append(ord(byte))
            byte = fp.read(1)

    def read(self, address):
        return self.data[address]

    def write(self, address, data):
        self.data[address] = data

    def random_op(self):
        address    = randint(0, 0xff)
        write_en   = randint(0, 1)
        write_data = randint(0, 0xff)
        read_data  = self.read(address)
        if write_en:
            self.write(address, write_data)

        return (to_bin(address, 16), to_bin(write_en, 1),
                to_bin(write_data,8),to_bin(read_data, 8))

def main():
    seed(0)
    mem = Memory("../../bin/DMG_ROM.bin")
    output = open("memory.txt", "w")
    m = 1000000
    for i in xrange(m):
        if i % 10000 == 0:
            f = 100 * float(i) / float(m)
            print("%s" % f)
        op = mem.random_op()
        output.write("%s %s %s %s\n" % op)

if __name__ == "__main__":
    main()
