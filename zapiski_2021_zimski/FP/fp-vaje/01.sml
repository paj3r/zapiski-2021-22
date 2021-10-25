fun implies (z : bool * bool) : bool =
    if #1 z = true andalso #2 z = false
    then false
    else true

fun obrni sez =
    let
        fun pomozna(sez,acc) =
            case sez of
                [] => acc
                | g::r => pomozna(r, g::acc)
    in
        pomozna(sez, [])
    end

fun factorial (n : int) : int =
    if n = 0
    then 1
    else n*factorial(n-1)

fun power (x : int, n : int) : int =
    if n = 0
    then 1
    else x*power(x, n-1)

fun gcd (a : int, b : int) : int =
    if b = 0 
    then a
    else gcd(b, a mod b)

    
fun partition (x, xs) =
let
    fun partition (xs, l, r) =
        if null xs
        then (obrni(l), obrni(r))
        else
            if (hd xs) < x
            then partition(tl xs, (hd xs)::l, r)
            else partition(tl xs, l, (hd xs)::r)
in
    partition (xs, [], [])
end

fun len(sez) =
    let 
        fun pomozna(sez,l) =
            if null sez
            then l
            else pomozna(tl sez, l+1)
    in
        pomozna(sez,0)
    end

fun last(sez) : int option =
    if null sez
    then NONE
    else if null(tl sez)
        then SOME(hd sez)
        else last (tl sez)

fun nth(sez:int list, ix:int): int option =
    if ix >= len(sez)
    then NONE
    else
        if (null sez) andalso (ix <> 0)
        then NONE
        else 
            if ix=0
            then SOME(hd sez)
            else nth((tl sez), (ix-1))

fun insert (sez:int list, loc:int, el:int):int list = 
    let 
        fun pomozna(sez, loc, el, compl) =
            if loc=0
            then pomozna(sez, (loc-1), el, el::compl)
            else 
                case sez of
                [] => obrni compl
            |   g::r => pomozna(r, (loc-1), el, g::compl)
    in  
        pomozna(sez, loc, el, [])
    end

fun delete (sez:int list, el:int):int list = 
    let
        fun pomozna(sez, el, acc) =
            case sez of
                [] => obrni acc
            |   g::r => if g = el
                        then pomozna(r, el, acc)
                        else pomozna(r, el, g::acc)
    in
        pomozna(sez, el,[])
    end

fun append (sez:int list, el:int):int list =
    insert(sez, len(sez), el)

fun reverse(sez:int list):int list =
    obrni(sez)

fun palindrome(sez:int list):bool =
    case sez of
        [] => true
    |   g::r => if null r
                then true
                else 
                    if g = (valOf(last r))
                    then palindrome(delete(r, (len(r)-1)))
                    else false
