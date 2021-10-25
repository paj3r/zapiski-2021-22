(* Vrne naslednika števila n. *)
fun next (n : int) : int =
    n + 1;

(* Vrne vsoto števil a in b. *)
fun add (a : int, b : int) : int =
    a + b;

(* Vrne true, če sta vsaj dva argumenta true, drugače vrne false *)
fun bool_to_int (a: bool) : int = if a then 1 else 0;
fun majority (a : bool, b : bool, c : bool) : bool = 
    if (bool_to_int(a)+bool_to_int(b)+bool_to_int(c)) > 1
    then true 
    else false;
(* Vrne mediano argumentov - števila tipa real brez (inf : real), (~inf : real), (nan : real) in (~0.0 : real)
   namig: uporabi Real.max in Real.min *)
fun median (a : real, b : real, c : real) : real = 
    Real.min(Real.min(Real.max(a, b), Real.max(a, c)), Real.max(b, c))
    


(* Preveri ali so argumenti veljavne dolžine stranic nekega trikotnika - trikotnik ni izrojen *)
fun triangle (a : int, b : int, c : int)  : bool = 
    if a > b 
    then if a > c 
        then if a < (a + b) then true else false
        else if c < (a + b) then true else false
    else if b > c
        then if b < (a + c) then true else false
        else if c < (a + b) then true else false