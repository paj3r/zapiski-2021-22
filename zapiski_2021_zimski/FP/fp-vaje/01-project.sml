val _ = Control.Print.printDepth := 10;
val _ = Control.Print.printLength := 10;
val _ = Control.Print.stringDepth := 2000;
val _ = Control.polyEqWarn := false;


fun readFile filename =
  let val is = TextIO.openIn filename
  in 
    String.map (fn c => if Char.isGraph c orelse c = #" " orelse c = #"\n" then c else #" ")
      (TextIO.inputAll is)
    before TextIO.closeIn is
  end

exception NotImplemented;

fun obrni sez =
    let
        fun pomozna(sez,acc) =
            case sez of
                [] => acc
                | g::r => pomozna(r, g::acc)
    in
        pomozna(sez, [])
    end

fun split n sez =
    let
        fun pom (n2,sez2,acc)=
            if null sez2 then []
            else if n2 = 1 then obrni((hd sez2)::acc)::pom(n,(tl sez2),[])
                    else pom(n2-1, tl sez2, (hd sez2)::acc)
    in
        pom (n, sez, [])
    end

signature RING =
sig
  eqtype t
  val zero : t
  val one : t
  val neg : t -> t
  val inv : t -> t option
  val + : t * t -> t
  val * : t * t -> t
end;

functor Ring (val n : int) :> RING where type t = int =
struct
  type t = int
  val zero = 0
  val one = 1
  fun neg x = ~x mod n

  fun modularInverse (a, n) = 
  let
    fun while2(t, newt, r, newr)=
      if newr = 0
      then (t,r)
      else while2(newt, t - (r div newr)*newt, newr, r - (r div newr)*newr)
  in
    let
      fun topos (t,n) =
        if t < 0
        then topos (t+n, n)
        else t
      val tr = while2(0,1,n,a)
    in
      if (#2 tr) > 1
      then NONE
      else SOME (topos(#1 tr, n))
    end
  end

  fun inv x = modularInverse (x mod n, n)
  fun op + a =  Int.+ a mod n
  fun op * p =  Int.* p mod n
end;

signature MAT =
sig
  eqtype t
  structure Vec :
    sig
      val dot : t list -> t list -> t
      val add : t list -> t list -> t list
      val sub : t list -> t list -> t list
      val scale : t -> t list -> t list
    end
  val tr : t list list -> t list list
  val mul : t list list -> t list list -> t list list
  val id : int -> t list list
  val join : t list list -> t list list -> t list list
  val inv : t list list -> t list list option
end;

functor Mat (R : RING) :> MAT where type t = R.t =
struct
  type t = R.t
  structure Vec =
    struct
      fun dot a b =
        case a of
          [] => R.zero
        | h::t => case b of
                    [] => R.zero
                  | h1::t1 => R.+(R.*(h,h1) , dot t t1)
      fun add a b =
        case a of
          [] => []
        | h::t => case b of
                    [] => []
                  | h1::t1 => R.+(h,h1) :: add t t1

      fun sub a b =
        case a of
          [] => []
        | h::t => case b of
                    [] => []
                  | h1::t1 => R.+(h,R.neg(h1)) :: sub t t1
      fun scale n a =
        case a of
          [] => []
        | h::t => (R.* (h,n)) :: scale n t
    end

  fun tr l = 
    let
        val vrst = length l
        val stol = if vrst>0 then length (List.nth(l,0)) else 0
    in
        List.tabulate (stol, fn x => List.map (fn y => (List.nth (y,x))) l)
    end
  fun mul l1 l2 =
    List.map (fn x => List.map (fn y => Vec.dot x y) (tr l2)) l1
  fun id n = List.tabulate (n, fn x => List.tabulate(n, fn y => if x=y then R.one else R.zero))
  fun join a b = 
    case a of
      [] => b
    | h::t =>  case b of
        [] => a
      | h1::t1 => (h@h1) :: join t t1
      (*redukcija vrstic, permutacija vrstic, da je zgoraj levo enko*)
      (*redukcija: reduction v: (1xt) m: (l*(t+1)) -> m': l*t*)
      (*pivot : m: n*n -> m' : n*n rezultat ma v zgornjem kotu 1. Če inverz vrne some*)
      (*gauss: 2 acc: above[], curr[A|I], najprj pivot na curr, zreduciramo vse vstice pod to,
       če above ni prazna še above reduciramo. rek klic: gauss (reduce v' above @[v'(pivot vrstica brez 1 spredej)])
       reduce v' curr*)
  fun inv [] = NONE |
    inv m =
      let
      fun pivot (mat, acc) = 
        case mat of
          [] => NONE
        | h::t =>
          let
            val inverz = R.inv (hd h)
          in
            if isSome(inverz)
            then SOME ([Vec.scale (valOf(inverz)) h]@ t @ acc )
            else pivot (t,h::acc)
          end
      fun reduce (vekt, mat) = 
        case mat of
          [] => []
        | h::t => (Vec.sub (tl h) (Vec.scale (hd h) vekt))::reduce(vekt, t)
      fun gauss (above, curr) =
        let
          val piv = pivot (curr, [])
        in
          if null curr then SOME above
          else
            if isSome(piv)
            then case piv of
              SOME (h::t) => gauss((reduce ((tl h),above))@[(tl h)], reduce ((tl h), t))
            else NONE
        end
      in
       gauss([],join m (id (length m)))
      end
end;

structure RationalFiled :> RING where type t = IntInf.int * IntInf.int =
struct
  (* (a, b) <=> a/b *)
  type t = IntInf.int * IntInf.int
  open IntInf
  val zero = (0, 1) : t
  val one = (1, 1) : t
  fun neg (a, b) = (~a, b)
  fun inv ((0, _) : t) = NONE
    | inv (a, b) = SOME (b, a)
  fun gcd (a, 0) = a
    | gcd (a, b) = gcd (b, a mod b)
  fun rat (a, b) = 
    let val d = gcd (a, b)
    in (a div d, b div d) end

  fun (a, b) + (c, d) = let open IntInf in rat (a * d + c * b, b * d) end
  fun (a, b) * (c, d) = let open IntInf in rat (a * c, b * d) end
end

functor IntegerModRingMat (val n : int) :> MAT where type t = int =
struct
  structure R = Ring (val n = n)
  structure M = Mat (R)
  structure QM = Mat (RationalFiled)

  open M

  val n = IntInf.fromInt n
  fun bmod x = IntInf.toInt (IntInf.mod (x, n))

  fun inv m =
    Option.map
      (fn m =>
        map (map (fn (a, b) => R.* (bmod a, valOf (R.inv (bmod b))))) m)
      (QM.inv (map (map (fn x => (IntInf.fromInt x, 1))) m))
    handle Option => NONE
end

signature CIPHER =
sig
  type t
  val encrypt : t list list -> t list -> t list
  val decrypt : t list list -> t list -> t list option
  val knownPlaintextAttack : int -> t list -> t list -> t list list option
end;

functor HillCipherAnalyzer (M : MAT) :> CIPHER
  where type t = M.t
=
struct
  type t = M.t
  
  fun encrypt key plaintext = raise NotImplemented
  fun decrypt key ciphertext = raise NotImplemented
  fun knownPlaintextAttack keyLenght plaintext ciphertext = raise NotImplemented
end;


structure Trie :> 
sig
eqtype ''a dict
val empty : ''a dict
val insert : ''a list -> ''a dict -> ''a dict
val lookup : ''a list -> ''a dict -> bool
end
=
struct
  datatype ''a tree = N of ''a * bool * ''a tree list
  type ''a dict = ''a tree list

  val empty = [] : ''a dict

  fun insert w dict = raise NotImplemented
  fun lookup w dict = raise NotImplemented
end;

signature HILLCIPHER =
sig
  structure Ring : RING where type t = int
  structure Matrix : MAT where type t = Ring.t
  structure Cipher : CIPHER where type t = Matrix.t
  val alphabetSize : int
  val alphabet : char list
  val encode : string -> Cipher.t list
  val decode : Cipher.t list -> string
  val encrypt : Cipher.t list list -> string -> string
  val decrypt : Cipher.t list list -> string -> string option
  val knownPlaintextAttack :
      int -> string -> string -> Cipher.t list list option
  val ciphertextOnlyAttack : int -> string -> Cipher.t list list option
end

functor HillCipher (val alphabet : string) :> HILLCIPHER =
struct

(*printable characters*)
val alphabetSize = String.size alphabet
val alphabet = String.explode alphabet

structure Ring = Ring (val n = alphabetSize)
(* structure Matrix = Mat (Ring) *)
structure Matrix = IntegerModRingMat (val n = alphabetSize)
structure Cipher = HillCipherAnalyzer (Matrix)

fun encode txt = raise NotImplemented
fun decode code = raise NotImplemented

local
  fun parseWords filename =
    let val is = TextIO.openIn filename
      fun read_lines is =
        case TextIO.inputLine is of
          SOME line =>
            if String.size line > 1
            then String.tokens (not o Char.isAlpha) line @ read_lines is
            else read_lines is
          | NONE => []
    in List.map (String.map Char.toLower) (read_lines is) before TextIO.closeIn is end

  val dictionary = List.foldl (fn (w, d) => Trie.insert w d) Trie.empty (List.map String.explode (parseWords "hamlet.txt")) handle NotImplemented => Trie.empty
in
  fun encrypt key plaintext = raise NotImplemented
  fun decrypt key ciphertext = raise NotImplemented
  fun knownPlaintextAttack keyLenght plaintext ciphertext = raise NotImplemented
  fun ciphertextOnlyAttack keyLenght ciphertext = raise NotImplemented
  end
end;
