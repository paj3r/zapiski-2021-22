import networkx as nx
import math
def euc_dist(x1, y1, x2, y2):
    return math.sqrt((x1-x2)*(x1-x2) + (y1-y2)*(y1-y2))
filename = "./ps3in/simple1.tsp"
file = open(filename, "r")
it = file.read().split("\n")
n_nodes = 0
nodes = []
for i in range(len(it)):
    if it[i][0] != "%" and n_nodes != 0:
        nodes.append(it[i].split(" "))
    if it[i][0] != "%" and n_nodes == 0:
        n_nodes = int(it[i])
print(nodes)
G = nx.Graph()
for i in range(n_nodes):
    for j in range(n_nodes):
        if i > j:
            G.add_edge(int(nodes[i][0]), int(nodes[j][0]), weight = euc_dist(int(nodes[i][1]), int(nodes[j][1]), int(nodes[i][2]), int(nodes[j][2])))
for weight in G.edges.data("weight"):
    print(weight)



