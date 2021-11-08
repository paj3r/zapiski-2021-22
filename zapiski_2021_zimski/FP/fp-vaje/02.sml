datatype number = Zero | Succ of number | Pred of number

datatype tree = Node of int * tree * tree | Leaf of int

fun toInt(n:number)=
    case n of
        Zero => 0
    |   Pred x => toInt(x)-1
    |   Succ x => toInt(x)+1

fun simp (n:number) =
    let         
        fun build(n:int, acc:number)=
            if n = 0
            then acc
            else    if n > 0
                    then build(n-1, Succ(acc))
                    else build(n+1, Pred(acc))
    in
        build(toInt(n), Zero)
    end

fun neg (n:number) =
    let
        fun pomozna(x, acc) =
            case x of
                Zero => acc
            |   Pred y => pomozna(y, Succ(acc))
            |   Succ y => pomozna(y, Pred(acc))
    in
        pomozna(n,Zero)
    end

fun add (a:number, b:number) =
    let
        fun pomozna(a, b, acc) =
            case a of
                Zero=> (case b of
                            Zero => acc
                        |   Succ y => pomozna(a, y, Succ(acc))
                        |   Pred y => pomozna(a, y, Pred(acc)))
            |   Succ y => pomozna(y, b, Succ(acc))
            |   Pred y => pomozna(y, b, Pred(acc))
    in
        pomozna(a, b, Zero)
    end

fun comp (a:number, b:number) =
    let
        fun pomozna(a, b)=
            case a of
                Zero => (case b of Zero => EQUAL | Pred x => GREATER | Succ x => LESS)
            |   Pred x => (case b of Zero => LESS | Pred y => pomozna(x, y) | Succ y => LESS)
            |   Succ x => (case b of Zero => GREATER | Succ y => pomozna(x, y) | Pred y => GREATER)
    in
        pomozna(simp(a), simp(b))
    end

fun contains(t, x) =
    case t of
        Leaf l => if l = x then true else false
    |   Node (n, l, r) => if n = x then true else contains(l, x) orelse contains(r, x)

fun countLeaves(t) =
    case t of
        Leaf l => 1
    |   Node (n, l, r) => countLeaves(l) + countLeaves(r)

fun countBranches(t) =
    case t of
        Leaf l => 0
    |   Node (n, l, r) => countBranches(l)+countBranches(r)+2

fun height(t) =
    case t of
        Leaf l => 1
    |   Node (n, l, r) => if height(l)>height(r) then 1+height(l) else 1+height(r)

fun toList(t) =
    case t of 
        Leaf l => [l]
    |   Node (n, l, r) => toList(l) @ [n] @ toList(r)

fun isBalanced(t) = 
    case t of
        Leaf l => true
    |   Node (n, l, r) => if abs ((height l)-height(r)) <= 1 then true else false

fun maxTree(t) =
    case t of
        Leaf l => l
    |   Node (n, l, r) =>
            if n>maxTree(l) andalso n>maxTree(r)
            then n
            else   
                if maxTree(r)<maxTree(l)
                then maxTree(l)
                else maxTree(r)

fun minTree(t) =
    case t of
        Leaf l => l
    |   Node (n, l, r) =>
            if n<minTree(l) andalso n<minTree(r)
            then n
            else   
                if minTree(r)<minTree(l)
                then minTree(r)
                else minTree(l)



fun isBST(t) = 
    case t of
        Leaf l => true
    |   Node (n, l, r) => if minTree(r)>n andalso maxTree(l)<n then isBST(l) andalso isBST(r) else false