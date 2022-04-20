import numpy as np
def natancni(ver, edg, edges):
    ver = int(ver)
    edg = int(edg)
    edges = list(map(lambda sub: list(map(int, sub)), edges))
    num_edg = []
    #spodnja meja
    for i in range(0, ver):
        num_edg.append(0)
        for j in range(0, edg):
            if edges[j][0] == i or edges[j][1] == i:
                num_edg[i] += 1
    sum = 0
    l = len(num_edg)
    while sum < ver:
        m = max(num_edg)
        num_edg.remove(m)
        sum += m
    print(l-len(num_edg))
    #parsing
    edg_tab=np.zeros((ver, ver))
    for i in range(0, edg):
        edg_tab[edges[i][0]][edges[i][1]] = 1
        edg_tab[edges[i][1]][edges[i][0]] = 1

def naivni(ver, edg, edges):
    ver = int(ver)
    edg = int(edg)
    edges = list(map(lambda sub: list(map(int, sub)), edges))
    num_edg = []
    # spodnja meja
    for i in range(0, ver):
        num_edg.append(0)
        for j in range(0, edg):
            if edges[j][0] == i or edges[j][1] == i:
                num_edg[i] += 1
    sum = 0
    num_edg2 = num_edg.copy()
    l = len(num_edg)
    while sum < ver:
        m = max(num_edg2)
        num_edg2.remove(m)
        sum += m
    #print(l - len(num_edg2))
    covered = []
    covering = []
    num_no_edg = 0
    print(num_edg)
    for i in range(0, len(num_edg)):
        if num_edg[i] == 0:
            num_no_edg+=1
    while len(covered) < ver-num_no_edg:
        print(len(covered))
        m = num_edg.index(max(num_edg))
        num_edg[m] = 0
        if not m in covering:
            covering.append(m)
        if not m in covered:
            covered.append(m)
        for i in range(0, edg):
            if edges[i][0] == m and (not edges[i][1] in covered):
                covered.append(edges[i][1])
            if edges[i][1] == m and (not edges[i][0] in covered):
                covered.append(edges[i][0])
    print(covering)








f = open("./ps2in/small_01.graph", "r")
# natančna z spodnjo mejo
# nenatančno: naivni, logn, 2apx
it = f.read().split("\n")
ver = it[0]
edg = it[1]
edges = []
for i in range(2, len(it)):
    edges.append(it[i].split(" "))
edges = edges[:-1]
naivni(ver, edg, edges)
