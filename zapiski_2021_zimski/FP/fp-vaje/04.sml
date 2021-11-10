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


(* Podan seznam xs agregira z začetno vrednostjo z in funkcijo f v vrednost f (f (f z s_1) s_2) s_3) ... *)
(* Aggregates xs with an initial value z and function f and returns f (f (f z s_1) s_2) s_3) ... *)
fun reduce f z l = foldl2 (swap f) z l

fun squares l = List.map (fn x => x*x) l

