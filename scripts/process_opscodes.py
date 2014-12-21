#!/usr/bin/env python2.7
import sys

def needs_expand(bits):
    for i in bits:
        if i not in "01":
            return True
    return False

def bit_to_int(bits):
    out = ""
    for i in bits: out += i
    return int(out, 2)

r_table = (       # r
    ("111", "A"),
    ("000", "B"),
    ("001", "C"),
    ("010", "D"),
    ("011", "E"),
    ("100", "H"),
    ("101", "L"))

d_reg_table = (   # ss
    ("00", "BC"),
    ("01", "DE"),
    ("10", "HL"),
    ("11", "SP"))

q_reg_table = (
    ("00", "BC"),
    ("01", "DE"),
    ("10", "HL"),
    ("11", "AF"))

s_reg_table = (
    ("00", "BC"),
    ("01", "DE"),
    ("10", "HL"),
    ("11", "SP"))

b_table = (       # bbb
    ("000", "0"),
    ("001", "1"),
    ("010", "2"),
    ("011", "3"),
    ("100", "4"),
    ("101", "5"),
    ("110", "6"),
    ("111", "7"))

c_table = ( #cc
    ("00", "NZ"),
    ("01", "Z" ),
    ("10", "NC"),
    ("11", "C" ))

f_table = ( #f
    ("000", "add"),
    ("001", "adc"),
    ("010", "sub"),
    ("011", "sbc"),
    ("100", "and"),
    ("101", "xor"),
    ("110", "or" ),
    ("111", "cp" ))

t_table = (
    ("000", "00H"),
    ("001", "08H"),
    ("010", "10H"),
    ("011", "18H"),
    ("100", "20H"),
    ("101", "28H"),
    ("110", "30H"),
    ("111", "48H"))

def expand(bits, lsb, msb, table):
    out = []
    for i in table:
        out += expand_bits([bits[:lsb] + [i for i in i[0]] + bits[msb:]])
    return out

def expand_bits(bits):
    out = []
    for bit in bits:
        if needs_expand(bit):
            if bit[2] == "f":
                out += expand(bit, 2, 5, f_table)
            elif bit[2] == "b":
                out += expand(bit, 2, 5, b_table)
            elif bit[2] == "t":
                out += expand(bit, 2, 5, t_table)
            elif bit[2] in "r":
                out += expand(bit, 2, 5, r_table)
            elif bit[5] in "r'":
                out += expand(bit, 5, 8, r_table)
            elif bit[3] in "c":
                out += expand(bit, 3, 6, b_table)
                #for i in xrange(4):
                #    rep = bin(i)[2:].zfill(2)
                #    rep_l = [i for i in rep]
                #    new = bit[:3] + rep_l + bit[5:]
                #    out += expand_bits([new])
            elif bit[3] in "sqd":
                for i in xrange(4):
                    rep = bin(i)[2:].zfill(2)
                    rep_l = [i for i in rep]
                    new = bit[:2] + rep_l + bit[4:]
                    out += expand_bits([new])
            else:
                print(bit)
                raise Exception("Error")
        else:
            out.append(bit)
    return out

def process_line(line):
    bit = ""
    s_line = line.strip().split(",")
    try:
        pos = int(s_line[0])
        op  = s_line[10]
        bit = expand_bits([s_line[2:10]])
        return (pos, bit, op)
    except ValueError:
        return None

def output_html(m):
    fp = open("out.html", "w")
    fp.write("<html>\n")
    fp.write("<head>\n")
    fp.write("<link rel='stylesheet' type='text/css' href='out.css'>\n")
    fp.write("</head>\n")
    fp.write("<table width=100%>\n")
    for i in xrange(16):
        fp.write("<tr>\n")
        for j in xrange(16):
            fp.write("<td width=6%%>%s</td>" % m[16 * i + j])
        fp.write("\n")
        fp.write("</tr>\n")
    fp.write("</table>\n")
    fp.write("</html>\n")

def main():
    fp = open("all_ops.csv", "r")
    t = [0] * 256;
    m = [None] * 256 
    for line in fp:
        p = process_line(line)
        if p:
            name = p[2]
            for i in p[1]:
                idx = bit_to_int(i)
                m[idx] = name
        else:
            break

    output_html(m)

    with open("counts.txt", "w") as fp:
        for i, j in enumerate(t):
            fp.write("%s %s\n" % (hex(i), j))

if __name__ == "__main__":
    main()
