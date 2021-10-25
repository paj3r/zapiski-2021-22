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

fun last(sez) =
    if null sez
    then NONE
    else if null(tl sez)
        then SOME(hd sez)
        else last (tl sez)

fun nth(sez:int list, ix:int) =
    if (null sez) andalso (ix /= 0)
    then NONE
    else 
        if ix=0
        then SOME(hd sez)
        else nth((tl sez), (ix-1))
