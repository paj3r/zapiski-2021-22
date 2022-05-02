from sympy import Line, Point2D, Segment, Polygon

def algo1(s1tt, s2tt):
    s1 = Polygon(*s1tt)
    s2 = Polygon(*s2tt)

    if s1.contains(s2):
        return s1
    if s2.contains(s1):
        return s2


def algo2(s1tt, s2tt):
    s1 = Polygon(*s1tt)
    s2 = Polygon(*s2tt)
    print(s1.sides)
    inter = False
    for t in s1.sides:
        for t2 in s2.sides:
            l1 = Line(t.points[0], t.points[1])
            l2 = Line(t2.points[0], t2.points[1])
            if len(l1.intersection(l2))!=0:
                return True
    return inter
filename = "input.txt"

f = open(filename, "r")
raw = f.read().split("\n")
x1=raw[0].split(" ")
x2=raw[1].split(" ")
y1=raw[2].split(" ")
y2=raw[3].split(" ")
s1t = []
s2t = []
for i in range(len(x2)):
    s1t.append((float(x1[i]), float(y1[i])))
    s2t.append((float(x2[i]), float(y2[i])))
print(algo2(s1t, s2t))


