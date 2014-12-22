#!/usr/bin/env python2.7
import sys
import copy
import string

def needs_expand(bits):
    for i in bits:
        if i not in "01":
            return True
    return False

def bit_to_int(bits):
    out = ""
    for i in bits: out += i
    return int(out, 2)

r_table = (
    ("111", "A"),
    ("000", "B"),
    ("001", "C"),
    ("010", "D"),
    ("011", "E"),
    ("100", "H"),
    ("101", "L"))

d_table = (
    ("00", "BC"),
    ("01", "DE"),
    ("10", "HL"),
    ("11", "SP"))

q_table = (
    ("00", "BC"),
    ("01", "DE"),
    ("10", "HL"),
    ("11", "AF"))

s_table = (
    ("00", "BC"),
    ("01", "DE"),
    ("10", "HL"),
    ("11", "SP"))

b_table = (
    ("000", "0"),
    ("001", "1"),
    ("010", "2"),
    ("011", "3"),
    ("100", "4"),
    ("101", "5"),
    ("110", "6"),
    ("111", "7"))

c_table = (
    ("00", "NZ"),
    ("01", "Z" ),
    ("10", "NC"),
    ("11", "C" ))

f_table = (
    ("000", "ADD"),
    ("001", "ADC"),
    ("010", "SUB"),
    ("011", "SBC"),
    ("100", "AND"),
    ("101", "XOR"),
    ("110", "OR" ),
    ("111", "CP" ))

t_table = (
    ("000", "00H"),
    ("001", "08H"),
    ("010", "10H"),
    ("011", "18H"),
    ("100", "20H"),
    ("101", "28H"),
    ("110", "30H"),
    ("111", "48H"))

l_table = (
   ("000", "RLC"), 
   ("001", "RRC"), 
   ("010", "RL"), 
   ("011", "RR"), 
   ("100", "SLA"), 
   ("101", "SRA"), 
   ("110", "SWAP"), 
   ("111", "SRL"))

def expand(code, lsb, msb, table, rename):
    out = []
    for i, j in table:
        new         = copy.deepcopy(code)
        bits        = code["bits"]
        new["bits"] = bits[:lsb] + [i for i in i] + bits[msb + 1:]
        new[rename] = j
        out += expand_bits([new])
    return out

"""
    bit name arg0 arg1
"""
def expand_bits(codes):
    out = []
    for code in codes:
        bit = code["bits"]
        if needs_expand(bit):
            if bit[2] == "f":
                out += expand(code, 2, 4, f_table, "name")
            elif bit[2] == "l":
                out += expand(code, 2, 4, l_table, "name")
            elif bit[2] == "b":
                out += expand(code, 2, 4, b_table, "arg0")
            elif bit[2] == "t":
                out += expand(code, 2, 4, t_table, "arg0")
            elif bit[2] == "r":
                out += expand(code, 2, 4, r_table, "arg0")
            elif bit[5] == "r":
                out += expand(code, 5, 7, r_table, "arg0")
            elif bit[5] == "r'":
                out += expand(code, 5, 7, r_table, "arg1")
            elif bit[3] == "c":
                out += expand(code, 3, 4, c_table, "arg0")
            elif bit[2] == "s":
                out += expand(code, 2, 3, s_table, "arg0")
            elif bit[2] == "q":
                out += expand(code, 2, 3, q_table, "arg0")
            elif bit[2] == "d":
                out += expand(code, 2, 3, d_table, "arg0")
            else:
                print(bit)
                raise Exception("Error")
        else:
            out.append(code)
    return out

def gen_test_range(var, bits):
    out = ""
    for i in bits:
        if i in "10":
            out += i
        else:
            out += "-"
    return 'std_match(%s, "%s")'  % (var, out)
    if needs_expand(bits):
        if bits[2] in "rbl":
            if bits[5] in "r'":
                return '%s(7 downto 6) = "%s"' % (var, out[:2])
            else:
                return '%s(7 downto 6) = "%s" and %s(2 downto 0) = "%s"' % (var, out[:2], var, out[5:])
        elif bits[2] in "dqs'":
            return '%s(7 downto 6) = "%s" and %s(3 downto 0) = "%s"' % (var, out[:2], var, out[4:])
        elif bits[2] in "ft'":
            if bits[5] in "r'":
                return '%s(7 downto 6) = "%s"' % (var, out[:2])
            else:
                return '%s(7 downto 6) = "%s" and %s(2 downto 0) = "%s"' % (var, out[:2], var, out[5:])
        elif bits[3] in "c'":
            return '%s(7 downto 5) = "%s" and %s(2 downto 0) = "%s"' % (var, out[:3], var, out[5:])
        elif bits[5] in "r'":
            return '%s(7 downto 3) = "%s"' % (var, out[:5])
        else:
            print(bits)
            raise Exception("Error")
    else:
        return '%s = "%s"' % (var, out)

downto_sort = ([], [], [])

def vhdl_output(code):
    var = "mem_dout"
    comment = "%s %s %s"  % (code["name"].ljust(4), code["arg0"], code["arg1"])
    s0 = "elsif %s then " % (gen_test_range(var, code["bits"]))
    s1 = "%s -- %s"       % (s0, comment)
    downto_sort[s1.count("downto")].append(s1)

def process_line(line):
    bit = ""
    s_line = line.strip().split(",")
    try:
        pos = int(s_line[0])
        op  = s_line[10]
        code = {
            "name" : s_line[10],
            "arg0" : s_line[11],
            "arg1" : s_line[12],
            "bits" : s_line[2:10],
        }
        full = "%s %s %s" % (code["name"], code["arg0"], code["arg1"])
        bit = expand_bits([code])
        vhdl_output(code)
        return bit
    except ValueError:
        return None

def output_html(m, n):
    fp = open("out.html", "w")
    fp.write("<html>\n")
    fp.write("<head>\n")
    fp.write("<link rel='stylesheet' type='text/css' href='out.css'>\n")
    fp.write("</head>\n")
    fp.write("<table width=100%>\n")
    for i in xrange(16):
        fp.write("<tr>\n")
        for j in xrange(16):
            idx = 16 * i + j
            fp.write("<td title='%s' width=6%%>%s</td>" % (hex(idx), m[idx]))
        fp.write("\n")
        fp.write("</tr>\n")
    fp.write("</table>\n")
    fp.write("<table width=100%>\n")
    for i in xrange(16):
        fp.write("<tr>\n")
        for j in xrange(16):
            fp.write("<td width=6%%>%s</td>" % n[16 * i + j])
        fp.write("\n")
        fp.write("</tr>\n")
    fp.write("</table>\n")
    fp.write("</html>\n")

def main():
    fp = open("all_ops.csv", "r")
    t = [0] * 256;
    m = [None] * 256 
    n = [None] * 256
    a = [None] * 256
    b = m
    for line in fp:
        if line[0] == "#":
            continue
        p = process_line(line)
        if p:
            for i in p:
                idx = bit_to_int(i["bits"])
                a[idx] = i
                b[idx] = "%s %s %s" % (i["name"], i["arg0"], i["arg1"])
        else:
            break
            b = n

    output_html(m, n)
    for i in downto_sort:
        for j in i:
            print(j)

if __name__ == "__main__":
    main()
