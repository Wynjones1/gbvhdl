#!/usr/bin/env python2.7
import sys

def process_line(line):
    bit = ""
    s_line = line.strip().split(",")
    for i in xrange(8):
        bit += s_line[i]
    print(bit)
def main():
    for line in sys.stdin:
        process_line(line)

if __name__ == "__main__":
    main()
