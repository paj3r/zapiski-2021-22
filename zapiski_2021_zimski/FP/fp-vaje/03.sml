datatype natural = Succ of natural | One;
exception NotNaturalNumber;

datatype 'a bstree = br of 'a bstree * 'a * 'a bstree | lf;
datatype direction = L | R;

fun zip(a, b)=
    let
        fun pomozna(a, b, acc)=
            if null a orelse null b
            then acc
            else pomozna(tl a, tl b, acc@[(hd a, hd b)])
    in
        pomozna(a,b,[])
    end

fun unzip(l:('a * 'b) list)=
    if null l
    then ([],[])
    else
        let
            val ta = #1 (hd l)
            val tb = #2 (hd l)
            val tal = (tl l)
            fun pomozna(l, acc, bcc)=
                if null l
                then (acc, bcc)
                else pomozna(tal, acc@[ta], bcc@[tb])
        in
            pomozna(l, [], [])
        end

fun subtract(a, b):natural=
    case b of
        One => (case a of
                    One => raise NotNaturalNumber
                |   Succ n => n
                )
    |   Succ n => (case a of
                    One => raise NotNaturalNumber
                |   Succ m => subtract(m,n))