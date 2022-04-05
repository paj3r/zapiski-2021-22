import math
import sys


def reduce_nq_sat(n):
    fields = n * n
    out = []
    for i in range(0, n):
        lst = ""
        for j in range(1, n + 1):
            lst += str(j + i * n) + " "
        out.append(lst+"0")
    for i in range(1,n+1):
        lst=""
        for j in range(0,n):
            lst += str(i + j * n) + " "
        out.append(lst + "0")
    for i in range(1, fields + 1):
        # rows
        row = math.ceil(i / n)
        sr = math.floor(i / n) + 1
        for j in range(sr, (row * n) + 1):
            if i == j or j == 0 or j < i:
                continue
            out.append("-{0} -{1} 0".format(i, j))
        # cols
        sc = i % n
        for j in range(sc, fields, n):
            if i == j or j == 0 or j < i:
                continue
            out.append("-{0} -{1} 0".format(i, j))
    # diags
    for k in range(0, n * 2):
        lst = []
        for j in range(0, k + 1):
            i = k - j
            if i < n and j < n:
                lst.append(str((i + 1) + j * n) + " ")
        if len(lst) > 1:
            for t in range(0, len(lst)):
                temp = lst[t]
                for n1 in range(t + 1, len(lst)):
                    out.append("-{0} -{1} 0".format(temp, lst[n1]))

    for i in range(n - 1, 0, -1):
        lst = []
        j = 0
        for x in range(i, n, 1):
            lst.append(str(x + (j * n) + 1) + " ")
            j += 1
        if len(lst) > 1:
            for t in range(0, len(lst)):
                temp = lst[t]
                for n1 in range(t + 1, len(lst)):
                    out.append("-{0} -{1} 0".format(temp, lst[n1]))
    for i in range(0, n, 1):
        lst = []
        j = 0
        for y in range(i, n, 1):
            lst.append(str(j + (y * n) + 1) + " ")
            j += 1
        if len(lst) > 1:
            for t in range(0, len(lst)):
                temp = lst[t]
                for n1 in range(t + 1, len(lst)):
                    out.append("-{0} -{1} 0".format(temp, lst[n1]))
    print("p cnf {0} {1}".format(fields, len(out)))
    for k in range(0, len(out)):
        print(out[k])


reduce_nq_sat(int(sys.argv[1]))
