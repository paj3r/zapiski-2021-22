import os

import numpy as np
from itertools import combinations
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
    num_edg2 = num_edg.copy()
    l = len(num_edg)
    while sum < ver:
        m = max(num_edg2)
        num_edg2.remove(m)
        sum += m
    bot = l-len(num_edg2)
    ver_lst = range(ver)
    covering = []
    for i in range(bot, ver):
        covering = []
        covered = []
        comb = combinations(ver_lst, bot)
        num_no_edg = 0
        no_edg_ix = []
        for k in range(0, len(num_edg)):
            if num_edg[k] == 0:
                num_no_edg += 1
                no_edg_ix.append(k)
        for j in list(comb):
            b = False
            for el in no_edg_ix:
                if el in j:
                    b = True
            if b:
                continue
            covering = []
            covered = []
            for vr in j:
                covering.append(vr)
                if vr not in covered:
                    covered.append(vr)
                for ed in range(0, edg):
                    if edges[ed][0] == vr and (not edges[ed][1] in covered):
                        covered.append(edges[ed][1])
                    if edges[ed][1] == vr and (not edges[ed][0] in covered):
                        covered.append(edges[ed][0])
            if len(covered) >= ver-num_no_edg:
                for i in no_edg_ix:
                   covered.append(i)
                   covering.append(i)
                break
        bot+=1
        if len(covered) >= ver - num_no_edg:
            break
    return covering


def greedy(ver, edg, edges):
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
    covered = []
    covering = []
    num_no_edg = 0
    for i in range(0, len(num_edg)):
        if num_edg[i] == 0:
            num_no_edg+=1
    while len(covered) < ver-num_no_edg:
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
    return covering


def naivni(ver, edg, edges):
    ver = int(ver)
    edg = int(edg)
    edges = list(map(lambda sub: list(map(int, sub)), edges))
    v_uncov = list(range(ver))
    cov = []
    while len(v_uncov) > 0:
        noedg = True
        for e in edges:
            if e[0] in v_uncov:
                noedg = False
                v_uncov.remove(e[0])
                if e[1] in v_uncov:
                    v_uncov.remove(e[1])
                cov.append(e[0])
        if noedg:
            for el in v_uncov:
                cov.append(el)
                v_uncov.remove(el)
    return cov

def two_aprox(ver, edg, edges):
    ver = int(ver)
    edg = int(edg)
    edges = list(map(lambda sub: list(map(int, sub)), edges))
    v_uncov = list(range(ver))
    cov = []
    while len(v_uncov) > 0:
        noedg = True
        for e in edges:
            if e[0] in v_uncov:
                noedg = False
                v_uncov.remove(e[0])
                if e[1] in v_uncov:
                    v_uncov.remove(e[1])
                cov.append(e[0])
                cov.append(e[1])
        if noedg:
            for el in v_uncov:
                cov.append(el)
                v_uncov.remove(el)
    return cov


folder = "./ps2in"
# natančna z spodnjo mejo
# nenatančno: naivni, logn, 2apx
print("Graph | Exact | Naive | Greedy | 2-approx")
for file in os.listdir(folder):
    fn = os.path.join(folder, file)
    if os.path.isfile(fn):
        f = open(fn, "r")
        it = f.read().split("\n")
        ver = it[0]
        edg = it[1]
        edges = []
        for i in range(2, len(it)):
            edges.append(it[i].split(" "))
        edges = edges[:-1]
        print(file + " | "+str(len(natancni(ver, edg, edges))) + " | " +str(len(naivni(ver, edg, edges))) +
              " | "+str(len(greedy(ver, edg, edges))) + " | " +str(len(two_aprox(ver, edg, edges))))
