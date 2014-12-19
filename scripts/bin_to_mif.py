#!/usr/bin/env python2.7
import argparse
import sys

def to_bin(val, size = 8):
    out = ""
    i = 0
    while val >> i:
        out += "1" if ((val >> i) & 0x1) else "0"
        i += 1
    return out[::-1].zfill(size)

def main():
    parser = argparse.ArgumentParser(description="Convert binary file to mif")
    parser.add_argument("--input",  "-i", default = None, help="Input file")
    parser.add_argument("--output", "-o", default = None, help="Output file")

    args = parser.parse_args()

    ifp = open(args.input,"rb") if args.input  else sys.stdin
    ofp = open(args.output,"w") if args.output else sys.stdout

    byte = ifp.read(1)
    while byte != "":
        slv = to_bin(ord(byte))
        ofp.write("%s\n" % slv)
        byte = ifp.read(1)

if __name__ == "__main__":
    main()
