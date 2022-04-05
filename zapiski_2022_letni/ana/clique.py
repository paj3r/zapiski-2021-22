import math
import sys

with open(sys.argv[1]) as file:
    lines = file.readlines()
k = int(sys.argv[2])
fr = []
to = []
for ln in lines:
    t = ln.split(" ")
    fr.append(int(t[0])+1)
    to.append(int(t[1])+1)
nodes = max(max(fr), max(to))
out = []
for r in range(0, k):
    lst = ""
    for j in range(1, nodes + 1):
        lst += str(j + (nodes * r)) + " "
    out.append(lst + "0")
for i in range(1, nodes + 1):
    lst = ""
    for r in range(0, k):
        lst = ""
        for s in range(r + 1, k):
            lst = ""
            lst += "-" + str(i + (nodes * r)) + " " + "-" + (str(i + nodes * s)) + " "
            out.append(lst + "0")

for i in range(1, nodes + 1):
    for j in range(i + 1, nodes + 1):
        for r in range(0, k):
            for s in range(0, k):
                exists = False
                if r == s:
                    continue
                for edges in range(0, len(fr)):
                    if (to[edges] == i and fr[edges] == j) or (to[edges] == j and fr[edges] == i):
                        exists = True
                if not exists:
                    out.append("-" + str(i + (nodes * r)) + " -" + (str(j + nodes * s)) + " 0")

print("p cnf {0} {1}".format(nodes * k, len(out)))
for k in range(0, len(out)):
    print(out[k])
