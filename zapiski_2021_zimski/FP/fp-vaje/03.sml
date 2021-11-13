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

fun unzip(lis:('a * 'b) list)=
    if null lis
    then ([],[])
    else
        let fun pomozna(lis, acc, bcc)=
                case lis of
                    [] => (acc, bcc)
                |   (a,b)::tl => pomozna(tl, acc@[a], bcc@[b])
        in
            pomozna(lis, [], [])
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

fun any(f, s)=
    case s of
        []=>false
    |   h::t=>
            if (f h)=true
            then true
            else any(f,t)

fun map(f, s)=
    let
        fun pomozna(f,s,acc)=
            case s of
                [] => acc
            |   h::t => pomozna(f,t,acc@[f h])
    in
        pomozna(f,s,[])
    end

fun filter(f, s)=
    let
        fun pomozna(f,s,acc)=
            case s of
                [] => acc
            |   h::t => if f h then pomozna(f,t,acc@[h]) else pomozna(f,t,acc)
    in
        pomozna(f,s,[])
    end

fun fold(f, z, s)=
    case s of
        h::t => if null t then f (z,h) else f (fold(f,z,t),h)
    |   _=>z

fun rotate(drevo, smer:direction)=
    if smer=L
    then
        case drevo of
            br(a,p,q)=>(case q of
                            br(b,n,c) => 
                                (let 
                                    val ttree = br(a,p,b)
                                in 
                                    br(ttree,n,c)
                                end)
                        |   _=>drevo
                        )
        |   lf=>drevo
    else
        case drevo of
            br(p,q,c)=>(case p of
                            br(a, n, b) => br(a, n, br(b,q,c))
                        |   _=>drevo
                        )
        |   lf=>drevo

fun rebalance(drevo) = drevo

fun avl (c, drevo, e)=drevo
