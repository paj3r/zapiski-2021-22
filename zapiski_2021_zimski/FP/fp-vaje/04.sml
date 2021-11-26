(*val f =fn x =>fn y => x*y*)
fun f x = fn y => x*y
(*fun f x y = x*y*)
fun curry f x y = f (x,y)

(*fun curry f x y = f (x,y)*)

fun uncurry f (x,y) = f x y

fun swap f x y = f y x

fun compose (f,g) = fn x => f (g x)

fun apply (f,x) = f x

fun apply2 f x = f x

fun foldl f z (h::t) =
    foldl f (f(h,z)) t | foldl _ z [] = z

fun foldl2 f z (h::t) =
    foldl2 f (f h z) t | foldl2 _ z [] = z

fun foldr f z (h::t) =  
    f (h, (foldr f z t)) | foldr _ z [] = z

fun foldr2 f z (h::t) =
    f h (foldr2 f z t) | foldr2 _ z [] = z


(* Aggregates xs with an initial value z and function f and returns f (f (f z s_1) s_2) s_3) ... *)
fun reduce f z l = foldl2 (swap f) z l

fun squares l = List.map (fn x => x*x) l

fun onlyEven l = List.filter (fn x => if (x mod 2) = 0 then true else false) l

fun bestString f l = 
    let
        fun pomozna f (x,y) =
            if f (x,y) = true
            then x
            else y
    in
        List.foldl (pomozna f) "" l
    end

fun largestString l = bestString (fn (x,y)=> x>y) l

fun longestString l = bestString (fn (x,y)=> size x>size y) l

fun quicksort f l =
    case l of 
        [] => []
    |   h::t => let
                    val (l,r) = List.partition (fn y => if f (h,y)=LESS then false else true) t
                in
                    (quicksort f l) @ [h] @ (quicksort f r)
                end

fun dot l1 l2 = List.foldl (fn (x,y) => x+y) 0 (ListPair.map (fn (x,y) => x*y) (l1,l2))

fun transpose l = 
    let
        val vrst = length l
        val stol = if vrst>0 then length (List.nth(l,0)) else 0
    in
        List.tabulate (stol, fn x => List.map (fn y => (List.nth (y,x))) l)
    end

fun multiply l1 l2 =
    List.map (fn x => List.map (fn y => dot x y) (transpose l2)) l1

fun group l = [(hd(l),1)]

fun equivalenceClasses f l = [[hd(l)], [hd(l)]]

