(*2017 1. kolokvij*)
(*1.*)
(*a*)
(*a: fn: a'->b'->c'*)
(*b: fn: d'->a'*)
(*c: d'*)
(*d: fn: e'->b'*)
(*e: e'*)
(*f : f'*)
(*nekaj: fn: (a'->b'->c')->(d'->a')->d'->(e'->b')->e'->f'->c'*)
fun nekaj a b c d e f = a (b c) (d e);
fun nekaj1 a b c d e _ = a (b c) (d e);
fun kvadrat (x,y) = nekaj (fn tx => fn ty => tx+ty) (fn tx=>(tx*tx)+(2*tx)) x (fn ty => ty*ty) y 0
(*2.*)
fun izloci sez =
    case sez of
        [] => []
    |   x::xs => (x,xs):: List.map (fn (x2,xs2) => (x2, x::xs2)) (izloci xs);
(*3.*)
datatype prvi = X of int | Y of prvi | Z of drugi
    and drugi = W of prvi | tretji

datatype rezultat = P | D


fun preveri_prvi i =
    case i of
        X _=> P
    |   Y x => preveri_prvi x
    |   Z x => preveri_drugi x

and preveri_drugi i =
    case i of
        tretji => D
    |   W x => preveri_prvi x

(*4.*)
(*
    a) Ne moremo klicati zares funkcije, saj ne moremo dostopati do X, Y, Z, W, ..., zato je sig neuporaben
    b) Vse deluje kot bi moralo, signature zajame vse izraze, ki smo jih definirali
    c) datatype prvi = X of int | Y of prvi | Z of drugi datatype drugi = W of prvi | tretji
    d) Rezultata funkcije ne bomo videli. rezultat bo na primer : val it : -
*)
(*2018 kolokvij 1*)
(*1.*)
(*g: fn int->a'*)
(*h: fn int->a'*)
(*[i,j]: bool option list*)
(*k : int*)
(*f: fn {g: int->string, h:int->string}*(bool option list')->int->int->string*)
fun f ({g=g,h=h}, [i,j]) k =
    if valOf i
    then fn x => g (k+x)
    else fn x => h (k-x) ^ "nil"
(*2.*)
datatype pot = Left of pot | Right of pot | Up of pot | Down of pot | start

fun coordinate p =
    let
        fun pomozna (po,x,y)=
            case po of
                start =>(x,y)
            |   Left t => pomozna(t,x-1,y)
            |   Right t => pomozna(t,x+1,y)
            |   Up t => pomozna(t,x,y+1)
            |   Down t => pomozna(t,x,y-1)

    in
        pomozna(p,0,0)
    end
(*3.*)
fun general c t f =
    if c
    then t
    else f

fun f1 c l1 l2 = general c (SOME (l1,l2)) NONE
fun f2 c l1 = general c l1 0
fun f3 c l1 = general (not c) (SOME l1) NONE
(*4.*)
fun filter f l = List.foldl (fn (x,acc) => if f x then x::acc else acc) [] l

(*2019 kolokvij*)
(*1.*)
(*a*)
(*[i,j]: ((a' option)*int) list *)
(*c::d: bool list*)
(*a: fn : int-> a' option*)
(*b: fn : a' option -> int*)
(*f1: fn ((int->a')*(int option->a')*bool list) -> int list-> b' -> a'*)
fun f1 (a,b,c::d) [i,j] =
    if c
    then fn a => b (SOME i)
    else fn b => a (j+1)
(*b*)
(*leks*) (*fun f v = fn w => 1 + v + w ====>  rez1 = (f 5) 6 = 12, rez2 = (f 5) 6 = 12*)
(*din*) (*rez1 = 12, rez2 = 14*)
(*2.*)
datatype ('a, 'b) chain = Node of {a: 'a ref, b: 'b}*('b, 'a) chain | final

fun chain_to_list c =
    case c of
        final => []
    |   x => [x]

(*3.*)
(*
    signature Podpis
    sig
        datatype barva = Pik | Karo | Srce | Kriz
        type karta = Joker
        val nova_karta : barva * int -> karta
        val dodaj_v_roke : karta -> karte
        val pokazi_roke : unit -> karte

    end
*)
(*4.*)
fun first_op sez =
    case sez of
        nil => [true]
    |   g::r => (not g)::(second_op r)
and second_op sez =
    case sez of
        nil => [false]
    |   g::r => (g)::(third_op r)
and third_op sez =
    case sez of
        nil => nil
    |   g::r => true::(first_op r)

fun op123 sez c1 a1 a2 =
    case sez of
        nil => c1::nil
    |   g::r => (a1 g)::(a2 r)

fun first_op2 sez =
    op123 sez true not (second_op)

exception MatematicnaTezava of int*string

fun deli3 (a1, a2) =
    if a2 = 0 
    then raise MatematicnaTezava(a1, "deljenje z 0")
    else a1 div a2

fun tabeliraj3 zacetna =
    Int.toString(deli3(zacetna,zacetna-5)) ^ "  " ^ tabeliraj3(zacetna-1) 
    handle MatematicnaTezava(a1, a2) => a2 ^ " stevila " ^ Int.toString(a1)
        
