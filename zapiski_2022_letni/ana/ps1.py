import math
import sys


def reduce_nq_sat(n):
    fields=n*n
    for i in range(1,fields+1):
        #rows
        row = math.ceil(i / n)
        sr = math.floor(i / n)+1
        for j in range(sr, (row*n)+1):
            if i == j or j==0:
                continue
            print("-{0} -{1} 0".format(i,j))
        #cols
        sc= i % n
        for j in range(sc, fields, n):
            if i==j or j==0:
                continue
            print("-{0} -{1} 0".format(i,j))
    #todo diags
    print("================")
    for k in range(0, n * 2):
        lst = ""
        for j in range(0, k + 1):
            i=k-j
            if i<n and j<n:
                lst+=(str((i+1)+j*n)+" ")
        print(lst)

    print("================")
    for i in range(n,0,-1):
        lst = ""
        for j in range()
    for (int i = b.length - 1; i > 0; i--) {
        String temp = "";
    for (int j = 0, x = i; x <= b.length - 1; j++, x++) {
    temp = temp+b[x][j];
    }
    System.out.println(temp)
    }
reduce_nq_sat(int(sys.argv[1]))