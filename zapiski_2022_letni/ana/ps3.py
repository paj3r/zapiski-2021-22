import networkx as nx
import math
import itertools
import random


def euc_dist(x1, y1, x2, y2):
    return math.sqrt((x1 - y1) * (x1 - y1) + (x2 - y2) * (x2 - y2))


def exact(G, n_node):
    lst = range(1, n_node + 1)
    perms = itertools.permutations(lst)
    min = 1000000000
    min_p = []
    for p in perms:
        sum = 0
        for n in range(1, len(p)):
            sum += float(G.get_edge_data(p[n - 1], p[n])['weight'])
        sum += float(G.get_edge_data(p[len(p) - 1], p[0])['weight'])
        if sum < min:
            min = sum
            min_p = p
    return min


def greedy(G, n_node):
    min = 100000000
    min_g = 0
    for g in G.edges.data("weight"):
        if g[2] < min:
            min = g[2]
            min_g = g
    visited = []
    start = min_g[round(random.random())]
    visited.append(start)
    cur = start
    sum = 0
    while len(visited) < n_node:
        edges = G.edges(cur)
        mini = 100000
        nxt = cur
        for e in edges:
            if e[0] != cur and e[0] in visited:
                continue
            if e[1] != cur and e[1] in visited:
                continue
            if float(G.get_edge_data(e[0], e[1])['weight']) < mini:
                mini = float(G.get_edge_data(e[0], e[1])['weight'])
                if e[0] == cur:
                    nxt = e[1]
                else:
                    nxt = e[0]
        sum+=mini
        cur=nxt
        visited.append(cur)
    sum+= G.get_edge_data(start, nxt)['weight']
    return sum

def two_apx(G, n_node):
    T = nx.minimum_spanning_tree(G)
    walk = []
    for e in T.edges():
        walk.append(e[0])
        walk.append(e[1])
    walk.append(walk[0])
    visited=[]
    visited.append(walk[0])
    sum = 0
    for n in walk:
        if n in visited or n == walk[0]:
            continue
        else:
            visited.append(n)
    for n in range(1, len(visited)):
        sum += float(G.get_edge_data(visited[n-1], visited[n])['weight'])
    sum += float(G.get_edge_data(visited[len(visited) - 1], visited[0])['weight'])
    return sum

def one_pf_apx(G, n_node):
    T = nx.minimum_spanning_tree(G)
    Todd=[]
    for e in T.nodes():
        if len(T.edges(e))%2==1:
            Todd.append(e)
    Mt = nx.Graph()
    for i in range(len(Todd)):
        for j in range(len(Todd)):
            if j > i:
                t = G.get_edge_data(Todd[i], Todd[j])
                Mt.add_edge(Todd[i], Todd[j], weight = t['weight'])
    M = nx.min_weight_matching(Mt)
    for e in M:
        T.add_edge(e[0], e[1], weight=float(G.get_edge_data(e[0], e[1])['weight']))
    r = nx.eulerian_path(T)
    #print(r)
    S = []
    fp=True
    for i in r:
        if fp:
            S.append(i[0])
            fp=False
        S.append(i[1])
    visited = []
    visited.append(S[0])
    sum = 0
    for n in S:
        if n in visited or n == S[0]:
            continue
        else:
            visited.append(n)
    for n in range(1, len(visited)):
        sum += float(G.get_edge_data(visited[n-1], visited[n])['weight'])
    sum += float(G.get_edge_data(visited[len(visited) - 1], visited[0])['weight'])
    return sum


filename = "./ps3in/simple5.tsp"
file = open(filename, "r")
it = file.read().split("\n")
n_nodes = 0
nodes = []
for i in range(len(it)):
    if it[i][0] != "%" and n_nodes != 0:
        nodes.append(it[i].split(" "))
    if it[i][0] != "%" and n_nodes == 0:
        n_nodes = int(it[i])
G = nx.Graph()
for i in range(n_nodes):
    for j in range(n_nodes):
        if i > j:
            G.add_edge(int(nodes[i][0]), int(nodes[j][0]),
                       weight=euc_dist(int(nodes[i][1]), int(nodes[j][1]), int(nodes[i][2]), int(nodes[j][2])))
#for weight in G.edges.data("weight"):
    #print(weight)
print("Exact: "+str(exact(G, n_nodes)))
print("Greedy: "+ str(greedy(G, n_nodes)))
print("2-approx: "+str(two_apx(G,n_nodes)))
print("1.5-approx: "+str(one_pf_apx(G,n_nodes)))
