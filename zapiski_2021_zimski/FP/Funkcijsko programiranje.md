# Funkcijsko programiranje

# Predavanje 1

Jeziki: SML, Python, Racket

### Funkcijsko programiranje

Lastnosti funkcijskega programiranja: funkcije so objekti, podpora funkcijam višjega reda, uporaba rakurzije namesto zank, poudarek na delu s seznami, izogibanje "stranskim učinkom" programa(globalne spr. , lokalne spr.)

Prednosti funkcijeksega programiranja: 

 - lažji formalni dokaz pravilnosti
 - idempotenca funkcije (neodvisna od zunanjega okolja)
 - ni definiran vrstni red evalvacije, pozna (lazy) evalvacija
 - sočasno procesiranje -> boljša paralelizacija
 - pomagajo boljše razumeti programerske slike

### Standardni ML

Naložit je treba Sublime

Run programa je ubistvu REPL (Read, Eval, Print, Loop)
Sintaksa = Kako progam pravilno zapišemo
Semantika = kaj program pomeni

 - Preverba pravilnosti programa (Type checking)
 - evelvacija - izračun vrednosti

**ML** preverja semantiko z uporabo statičnega in dinamičnega okolja:

 - **Statično** : preverjanje pred izvajanjem (podatkovni tipi)
 - **Dinamično** : Preverjanje po izvajanju (vrednosti obstoječih spremenljivk)

val **x** = **c** ; **x** - ime spremenljivke, **c** - izraz

#### Pogojni stavki

Sintaksa if e1 then e2 else e3 ; 
**1. Pravilnost tipov**:

 - e1 mora biti tipa bool
 - e2 in e3 morata biti istega podatkovnega tipa (t)

**2. Način evalvacije**:

-  evalviraj vrednost e1 v v1
-  če je v1 enako true evalviraj e2 v v2 in vrni v2
-  če je v1 enako false evalviraj e3 v v3 in vrni v3

To je zato, da vedno vemo kakšnega podatkovnega tipa bo rezultat.


**Senčenje** - Lahko imamo definiranih več spremenljivk z istim imenom, od katerih so nekatere senčene (\<hidden\>) - *Slaba praksa*

**Negacija** - val a = ~5, ker operator - zahteva 2 argumenta

**Casting** - Real.fromInt(x)

#### Funkcije

fun obseg (r:real) = 2.0 * Math.pi * r (val obseg = fn: real -> real)

Funkcije nimajo zank, ampak se namesto njih uporablja rekurzija

**Primeri**:

```ocaml
	fun potenca (x:int, y:int) = 
		if y>0 then x*potenca(x, y-1) else return x

	fun sestejAB (a:int, b:int) = 
		if a=b then a else sestejAB(a, b-1) + b
```



## Predavanje 2

#### Podrobno o funkcijah

Funkcije se obravnavalo kot vrednosti, ki se evalvirajo kasneje.
Znak \* ne pomeni množenja (men se zdi da kartezični produkt).
Funkcije lahko kličejo samo funkkcije, ki so že definirane v kontekstu (definirane prej od same sebe).
Oznake tipov pogosto izpustimo, da jih SML sklepa sam.

#### Terke

Podatkovni tip **nespremenljive** dolžine, sestavljen iz komponent **različnih** podatkovnih tipov.
**Zapis terke** :  (e1, e2, ..., en), če je pod. tip e1:t1, ..., en:tn, je terka tipa t1 \* t2 \* ... \* tn
**dostop do elementov** terke e : \#n e   , kjer je n številka zaporedne komponente, e pa izraz-terka...

#### Seznam

Podatkovni tip **spremenljive** dolžine, sestavljen iz komponent **enakih** podatkovnih tipov.
**Zapis seznama s komponentami** : [v1, v2, ..., vn], vsi elementi tipa t1
**Zapis seznama s sintakso** glava::rep (v0 :: [v1, v2, ..., vn] == [v0, v1, v2, ..., vn]), **glava** je *element* **rep** je *seznam*.
null e -> vrn true, če je seznam prazen
hd e -> vrne prvi element seznama
tl e -> vrne rep seznama (brez prvega elementa)
:: - cons operator (concatination)

#### Lokalno okolje

funkcije uporabljajo globalno statično/dinamično okolje -> portebujemo konstrukt za izvedbo **lokalnih vezav** v funkciji: 
  - lepše programiranje
  - potrebne so samo lokalno
  - zaščita pred sprembami izven lokalnega okolja
  - v določenih primerih: punjo za performanse (sledi, ...)

**Izraz "let"**

- je samo izraz torej je lahko vsebina funkcije

  - **sintaksa** : let d1 d2 ... dn in e end
  - **preverjanje tipov**: preveri tip vezav d1, d2, ..., dn in telesa e v zunanjem statičnem okolju. Tip celega izraza let je tipa e
  - **evalvacija** : evalviraj zaporedoma vse vezave in telo e v zunanjeem okolju. Rezultat izraza let je evalvacija e.

Uporablja se za definiranje lokalnih spremenljivk v funkciji.
Uvedemo pojem dosega spremenljivke (angl. scope).
V lokalnem okolju imamo lahku tudi vezave lokalnih funkcij.

## Predavanje 3

#### (ne)učinkovitost rekurzije

Težave lahko nastopijo pri večkratnih rekurzivnih klicih. Primer: Največji element seznama (v naraščujočem gre v 2^n rekurzij, v padajočem gre v n rekurzij) boljša funkcija:

```ocaml
	fun najvecji_el (sez: int list) =
		if null sez
		then 0
		else if null (tl sez)
		then hd sez
		else let val max_rep = najvecji_el(tl sez)
			in
				if hd sez > max_rep
				then hd sez
				else max_rep
			end
```

To je kot da delamo temp spremenljivke v Javi, tukaj se imenuje lokalno okolje.

#### Podatkovni tip "opcija"

Vprašanje je kaj vrniti kot najmaanjši element praznega seznama, zaporedno mesto elementa, ki ga ni.
Rešitev v SML: opcija, vezana na podatkovni tip: 

- SOME \<rezultat\>, če rezultat obstaja (SOME e, e tipa t -> tip t option)
- NONE, če rezultat ni veljaven (tip 'a option)

```ocaml
	fun najvecji_el (sez: int list) =
		if null sez
		then NONE
		else let val max_rep = najvecji_el(tl sez)
			in
				if isSome(max_rep) andalso valOf(max_rep) > hd sez
				then max_rep
				else SOME (hd sez)
			end
```

```ocaml
	fun najdi(sez: int lst, el:int) =
		if null sez
		then NONE
		else if (hd sez = el)
		then SOME 1
		else let val preostanek = najdi(tl sez, el)
			in
				if isSome preostanek
				then SOME(valOf(preostanek) + 1)
				else NONE
			end
```

#### Zapis (angl. record)

Podatkovni tip s poljubnim številom imenovanih polj, ki hranijo vrednosti (lahko različnih podatkovnih podtipov)

Zapis zapisa: {polje1 = e1,  polje2=e2, ..., poljen = en}
Če je podatkovni tip komponent enak e1:t1, ..., en:tn, ima celotni zapis podatkovni tip polje1 : t1, ...
*vrstni red polj ni pomemben, tipi lahko enostavni ali sestavljeni, podani so lahko izrazi, ki se evalvirajo v vrednosti, SML implicitno deklarira novi tip zapisa.*
Dostop do elementa zapisa e : \#ime_polja e

```ocaml
	fun izpis_studenta (zapis : {absolvent:bool, ime:string, ocene:(string * int), starost:int}):
	(#ime zapis) ^ " je star " ^ Int.toString(#starost zapis) ^ " let. "
```

##### Sinonimi za podatkovne tipe

Pogosto uporabljene in kompleksne (dolge) nazive podatkovnih tipov lahko poimenujemo z lastnim imenom in si poenostavimo delo.

```ocaml
	type student = {absolvent:bool, ime:string, ocene:(string * int), starost:int}
	fun izpis_studenta (zapis : student):
	(#ime zapis) ^ " je star " ^ Int.toString(#starost zapis) ^ " let. "
```

Terka je posebna oblika zapisa:

```ocaml
	{1="ena", 2="dva"} == ("ena", "dva") : string*string (*je terka*)
	{1="ena", 3="dva"} : {1:string, 3:string}            (*ni terka*)
```

#### Lastni podatkovni tipi

datatype ; **type** - sinonim podatkovnega tipa, **datatype** - nov podatkoni tip
datatype lahko ponuja alternative, ustvari nove funkcije ob inicializacji (konstruktorje).

```ocaml
	datatype prevozno_sredstvo = Bus of int | Avto of string*string | Pes
	Bus 18; (*val it = Bus 18 : prevozno_sredstvo*)
	Avto ("Volvo", "moder"); (*val it = Avto ("Volvo", moder) : prevozno_sredstvo*)
	Pes; (*val it = Pes : prevozno_sredstvo*)
```

Pri preverjanju lahko sproti preverjamo ali pa uporabljamo stavek *case*.

#### Stavek case

Primerja podani izraz e0 za ujemanje z vzorci p1, ..., pn. Rezultat je samo eden izraz na desni strani vzorca, s katerim se e0 ujema. Vse veje morajo biti istega podatkovnega tipa. Soremenljivke v vzorcu dobijo dejanske vrednosti glede na podani argument.

```ocaml
	fun obdelaj_prevoz (x: prevozno_sredstvo) =
	case x of
		Bus i => i+10
	  | Avto (s1, s2) => String.size s1 + String.size s2
	  | Pes => 0
```

case se uporablja za "pattern matching". datatype lahko definiramo tudi rekurzivno (primer: aritmetični izrazi)

``` ocaml
	datatype izraz = Konstanta of int
				   | Negiraj of izraz
				   | Plus of izraz*izraz
				   | Minus of izraz*izraz
				   | Krat of izraz*izraz
				   | Deljeno of izraz*izraz
				   | Ostanek of izraz*izraz
	fun eval e =
		case e of
        	Konstanta i => i
          | Negiraj e => ~(eval e)
          | Plus (e1, e2) => (eval e1) + (eval e2)
          | Minus (e1, e2) => (eval e1) - (eval e2)
          | Krat (e1, e2) => (eval e1) * (eval e2)
          | Deljeno (e1, e2) => (eval e1) / (eval e2)
          | Ostanek (e1, e2) => (eval e1) % (eval e2)
```

Opcija in seznam sta običajna polimorfna datatypa.
exception SeznamJePrazen - exception vezava, prožimo z raise SeznamJePrazen

## Predavanje 4

#### Izjeme

```ocaml
exception DeljenjeZNic

fun deli1 (a1, a2) =
	if a2 = 0
	then raise DeljenjeZNic
	else a1 div a2
	
fun tabeliraj1 zacetna =
	deli1(zacetna, zacetna-5)::tabeliraj1(zacetna-1)
	handle DeljenjeZNic => [999]
```

Izjeme imajo podatkovni tip *exn*. 

```ocaml
exception MatematicnaTezava of int*string

fun deli3 (a1, a2) =
	if a2 = 0
	then raise MatematicnaTezava(a1, "deljenje z 0")
	else a1 div a2
	
fun tabeliraj3 zacetna =
	Int.toString(deli3(zacetna, zacetna-5)) ^ " " ^ tabeliraj1(zacetna-1)
	handle MatematicnaTezava(a1, a2) = > a2 ^ " stevila " ^ Int.toString(a1)
```

#### Repna rekurzija

Je bolj učunkovita od drugih oblik rekurzije. Pri vsakm klicu funkcije se funkcijski okvir s kontekstor potisne na sklad; ko se funkcija zaključi se kontekst odstrani s sklada. Pri repni rekurziji se okvir samo zamenja z novim, ker kličoča funkcija konteksta ne potrebuje več.

Primer navadne:

```ocaml
fun potenca (x,y) = if y=0 then 1 else x * potenca(x,y-1)
```

Primer repne:

```ocaml
fun potenca_repna (x,y) =
	let
		fun pomozna (x,y,acc) =  (*akumulator acc*)
			if y=0
			then acc
			else pomozna(x, y-1, acc*x)
		in
			pomozna(x,y,1)
		end
```

Rekurzivna implementacija z lokalno pomožno funkcijo, ki sprejema en dodatni argument, ki mu rečemo **akumulator**, v katerega se shranjuje vrednost.

Repna rekurzija:
 - po izvedbi rekurzivnega klica v repu rekurzije, ni potrebno izvesti ve nobenih dodatnih operacij
 - rep funkcije definiramo rekurzivno:
    - v izrazu fun f p = e je telo e v repu
    - v izrazu

```ocaml
fun obrni sez = 
	case sez of 
		[] => []
	|	g::r => (obrni r) @ [g]
	
fun obrni_repno sez =
	let 
		fun pomozna (sez,acc) =
			case sez of
				[] => acc
			|	g::r => pomozna(r, gacc)
	in 
		pomozna(sez, [])
	end
```

## Predavanje 5

#### Funkcije višjega reda

```ocaml
fun operacija1 x = x*x*x
fun operacija2 x = x+1
fun operacija3 x = ~x

val zbirka_operacij = (operacija1, "lala", operacija3, 144)

fun izvedi1 podatek =
	(#1 zbirka_operacij) ((#3 zbirka_operacij) podatek)
	
fun izvedi2 (pod, funkcija) =
	funkcija (pod+100)
```

Tudi funkcije so **objekti**. Koristno za ločeno pogramiranje pogostih operacij ki jih uporabimo kot zunanjo funkcijo. Funkcijam, ki sprejemajo funkcije ali vračajo funkcije, pravimo **Funkcije višjega reda**. Funkcije imajo **funkcijsko ovojnico** - struktura, v kateri hraijo kontekst, v katerem so bile definirane.

#### Funkcije kot argumenti funkcij

Funkcije so lahko argumenti drugih funkcije -> bolj splošna programska koda. Funkcije višjega reda so lahko polimorfne.

```ocaml
fun zmnozi_nkrat (x,n) =
	if n=0
	then x
	else x * zmnozi_nkrat (x, n-1)
	
fun sestej_nkrat (x,n) =
	if n=0
	then x
	else x + sestej_nkrat (x, n-1)
	
fun rep_nti (sez, n) = 
	if n=0
	then sez
	else tl (rep_nti(sez, n-1))
	
(*refaktorizacija programske kode - posploševaje v funkcijo višjega reda*)

fun nkrat (f, x, n) =
	if n=0
	then x
	else f (x,  nkrat (f, x, n-1))

fun pomnozi (x,y) = x*y
fun sestej (x,y) = x+y
fun rep (x,y) = tl y

fun zmnozi_nkrat_kratka (x,n) =
	nkrat(pomnozi, x, n)
	
fun sestej_nkrat_kratka (x,n) =
	nkrat(sestej, x, n)

fun rep_nti_kratka (sez, n) =
	nkrat(rep, sez, n)
```

```ocaml
fun odloci x =
	if x>10
	then (let fun prva x = 2*x in prva end)
	else (let fun druga x = x div 2 in druga end)
	
(*
	val odloci = fn : int -> int -> int
	val odloci = fn : int -> (int -> int) 
*)

(*alternativa*)
fun zmnozi_nkrat_kratka (x,n) =
	nkrat(let fun pomnozi(x,y) = x*y in pomnozi end, x, n)
```



#### Anonimne funkcije

Deklaracija: fn (x,y) => x+y+1

```ocaml
fun sestej_nkrat_kratka (x,n) =
	nkrat(op +, x, n)

fun rep_nti_kratka (sez, n) =
	nkrat(fn (x,y) => tl y, sez, n)
```

 Namesto ločenih deklaracij funkcij (fun), lahko funkcije deklariramo na mestu, kjer jih potrebujemo (brez imenovanja - anonimno).

```ocaml
fun prstej sez = 
	case sez of
	[] => 0
|	glava::rep => 1 + prestej rep

fun sestej_sez sez
	case sez of
	[] => 0
|	glava::rep => glava + sestej_sez rep

(*posplošimo*)
fun predelaj_seznam (f,sez) =
	case sez of
	[] => 0
|	glava::rep => (f sez) + predelaj_seznam (f,rep)

fun prestej_super sez  = predelaj_seznam(fn _ => 1, sez)
fun sestej_seznam_super sez = predelaj_seznam((*op*)hd, sez)
```

#### Funkcija Map

Preslika seznam v drugi enak seznam, tako, da na vsakem elementu uporabi preslikavo f.

```ocaml
fun map (f, sez) =
	case sez of
	[] => []
|	glava::rep => (f glava)::map(f, rep)
(*podatkovni tip funkcije map *)
val map = fn : (a' -> b') * a' list -> b' list
```

#### Funkcija Filter

Preslika seznam v drugi seznam tako, da v novem seznamu ohrani samo tiste elemente, katere je predikat (funkcija, ki vrača bool) resničen.

```ocaml
fun filter (f, sez) =
	case sez of
	[] => []
|	glava::rep => 
		if (f glava)
		then glava::filter(f,rep)
		else filter(f,rep)
(*podatkovni tip funkcije filter *)
val map = fn : (a' -> bool) * a' list -> a' list
```

#### Funkcija Fold

Znana tudi pod imenom reduce. Združi elemente seznama v končni rezultat. Na elementih iizvede funkcijo f, ki upošteva trenutni rezultat in vrednost naslednjega elementa

```ocaml
fun fold (f, acc, sez) =
	case sez of
	[] => acc
|	glava::rep => fold(f, f(glava, acc), rep)

fold(fn(el,a)=> el+a, 0, [1,5,32,4,3,4])(*seštej seznam*)
fold(fn(el,a)=> el*a, 1, [1,5,32,4,3,4])(*zmnoži seznam*)
fold(fn(el,a)=> if el mod 2=0 then a+1 else a, 1, [1,5,32,4,3,4])(*sodi elementi*)
fold(fn(el,_)=> el) (*zadnji element*)
```

#### Doseg vrednosti

Funkcije kot prvo-razredni objekti so zmogljivo orodje. Definirati moramo semantiko pri določanju vrednosti smrepenljivk v funkciji. Imamo dve možnosti:

```ocaml
(*DINAMIČNI DOSEG, uporablja vrednosti v okolju, kjer jo kličemo*)
val a = 1
fun f1 x = x+a
val rez1 = f1 3
val a = 5
val rez2 = f1 3
(*rez1 = 4, rez2 = 8*)

(*LEKSIKALNI DOSEG, uporablja vrednosti v okolju, kjer so definirane*)
val a = 1
fun f1 x = x+a
val rez1 = f1 3
val a = 5
val rez2 = f1 3
(*rez1 = 4, rez2 = 4*)
```

#### Funkcijska ovojnica

Pri deklaraciji funkcije torje ni dovolj, da shranimo le programsko kodo funkcije, temveč je potrebno shraniti tudi trenutno okolje. **Funkcijska ovojnica** = koda funkcije + trenutno okolje.
Klic funkcije = evalvacija kode f v okolju env, ki sta del funkcijske ovojnice (f, env)

#### Leksikalni doseg

funkcija uporablja vrednosti spremenljivk v okolju, kjer je definirana.
V zgodovini sta bili obe možnosti, danes prevladuje leksikalni doseg, kjer je bolj zmogljiv.
**Prednosti** leksikalnega dosega:

 - Imena spremenljivk v funkciji so neodvisna od imen zunanjih spremenljivk
 - Funkcija je neodvisna od imen uporabljenih spremenljivk
 - Tip funkcije lahko določimo ob njeni deklaraciji
 - Ovojnica shrani podatke, ki jih potrebuje za kasnejšo izvedbo

#### Currying

Ime meode, naziv dbila po matematiku Haskell Curryju. Funkcije sprejemajo natanko en argument - če želimo podati več vrednosti v argumentu, smo jih običajno zapisali v terko.

```ocaml
fun vmejah_terka (min, max, sez) = 
	filter(fn x => x>min andalso x<max, sez)
(*tipa:*)
fn: int * int * int list -> int list
	
fun vmejah_curry min =
	fn max =>
		fn sez =>
			filter(fn x => x>min andalso x<max, sez)
(*tipa:*)
fn: int -> int -> int list -> int list

(*Lepše*)
fun vmejah_terka min max sez = 
	filter(fn x => x>min andalso x<max, sez)
	
(*Delna aplikacija*)
val od5do10 = vmejah_curry 5 10 (*zdej je od5do10 funkcija k vrača el. med 5 in 10*)
```

## Predavanje 6

#### Delna aplikacija funkcij

Ko uporabljamo currying pri klicu funkcije podamo manj argumentov kot jih funkcija ima.
Rezultat je delna aplikacija oz. funkcija, ki "čaka" na argumente.

#### Mutacija

Spreminjanje vrednosti seznama naknadno npr najprej s1, nato kličemo s1 v rez, rez se spremeni. Sml tega ne dela, čeprav uporablja reference.
SML lahko uporablja mutacijo.

```ocaml
ref e (*izdelava spremenljivke*)
el := e2 (*sprememba vsebine*)
!e (*vrne vrednost*)
```

Mutacije ne uporabljamo, razen če ni nujno potrebno: povzročajo stranske učinke in težave pri določanju podatkovnih tipov.

#### Določanje podatkovnih tipov

Cilj: vsaki deklaraciji (zaporedoma) določiti tip, ki bo skladen s tpi preostalih deklaracij.
Tipizacija glede na statičnost:

	- **Statično tipizirani jeziki** (ML, Java, C++, C#): preverjajo pravilnost podatkovnih tipovin opozorijo na napake v programu pred izvedbo
	- **Dinamično tipizirani jeziki** (Racket, Python, JS, Ruby): Izvajajo manj (ali nič) preverb pravilnosti podatkovnih tipov, večino preverjanj se izvede pri izvajanju

Tipizacja glede na implicitnost:

 - **Implicitno tipiziran jezik** (ML) : podatkovnih tipov nam ni potrebno eksplicitno zapisati
 - **Eksplicitno tipiziran jezik** (Java, C++, ...): Potreben ekspliciten zapis tipov

Ker je ML implicitno tipiziran ima mehanizem za samodejno določanje podatkovnih tipov.

## Predavanje 7

#### Moduli

```ocaml
fun liho x =
	if x=0
	then false
	else sodo (x-1)
fun sodo x =
	if x=0
	then true
	else liho (x-1)
```

Ne prevede se, ker funkcija sodo ni vezana v trenutnu, ko je poklicana. 
Rešitev :

```ocaml
fun liho x =
	if x=0
	then false
	else sodo (x-1)
and sodo x =
	if x=0
	then true
	else liho (x-1)
```

Deluje tudi za podatkovne tipe

```ocaml
datatype tip1 = <def>
and tip2 = <def>
and tip3 = <def>
```

**Moduli** omogočajo : 

	- Organiziranje programske kode v smiselne celote
	- Preprečevanje senčenja (isto ime v večih modulih)

Znotraj modaula se sklicujemo na deklarirane objekte enako, kot smo se prej v "zunanjem" okolju. Iz "zunanjega" okolja se na deklaracije v modulu sklicujemo z uporabo predpone "ImeModula.ime". Deluje  podobno kot Java class.
Sintaksa za deklaracijo modula:

```ocaml
structure MyModule
struct
	<deklaracija val, fun, datatype, ...>
end
(*Primer*)
structure Nizi =
struct
	val prazni_niz=""
	fun prvacrka niz =
		hd (String.explode niz)
end
```

#### Javno dostopne deklaracije

Modulu lahko določimo, katere deklaracije so na razpolago "javnosti" in katere so zaseble (public in private v Javi). Seznam javnih deklaracij strnemo v podpis modula (signature), nato podpis pripišemo modulu

```ocaml
signature PolinomP =
sig
	datatype polinom = Nicla | Pol of (int*int) list
	val novipolinom : int list -> polinom
	val mnozi : polinom -> int -> polinom
	val izpisi : polinom -> string
end

Structure Polinom :> PolinomP =
struct
	<deklaracija>
end
```

V podpisu določimo samo podatkovne tipe deklaracij. Podpis mora biti skladen z vsebino modula, sicer preverjanje tipov nebo uspešno.

#### Skrivanje implementacije

Uporaba podpisov modulov je koristna, ker z njim skrivamo implementacijo, ker je lastnost dobre in robustne programske opreme. S skrivanjem implementacije dosežemo:

	1. Uporabnik ne pozna načina implementacije operacij; lahko jo tudi kasneje spremenimo
	2. Uporabniku onemogočimo, da uporablja modul na napačen način

**Ustreznost modula in podpisa**:

	1. Vsi ne-abstraktni tipi, ki smo jih navedli v podpisu, morajo biti v modulu (datatype)
	2. Vsi abstraktni tipi iz podpisa (type) so implementirani v modulu s type ali datatpe
	3. Vsaka deklaracija vrednosti (val) v podpisu se nahaja v modulu (v modulu je lahko bolj splošnega tipa)
	4. Vsaka izjema (exception) v podpisu se nahaja tudi v modulu

za kolokvij: refaktirozacija polj, rekurzivno vezanje vzorcev, določanje pod. tipa funkcije, ugotavljanje kaj funkcija vrne v leksikalnem/dinamičnem dosegu, moduli, repna, čelna rekurzija

### Racket

Je funkcijski jezik - vse je izraz, ovojnice, anonimne funkcije, currying. Je dinamično tipiziran: uspešno prevede več programov, vendar se večina napak zgodi šele pri izvajanju.

Primeren za učenje novih konceptov: zakasnjena evalvacija, tokovi, makri, memoizacija
Naslednik jezika Scheme.

```scheme
#lang racket
; to je komentar

# |
VEč
vrstični
komentar
| #
(define x "Hello world")

(define q 3)

> (+ q 2) ;vse operacije se izvajajo infiksno deluje tudi (+ 2 3 4 ...)

(define sestej1 ; funkcija za seštevanje dveh števil
  (lambda (a b)
    (+ a b)))
> (sestej1 5 12); klic funkcije

(define (sestej2 a b) ; alternativna sestej1
  (+ a b))
;#f in #t sta false in true
(if (< 2 3) "Danes je lep dan" 55) ;; primer if stavka (vrne lahko različne tipe)

(define (potenca x n)
  (if (= n 0)
      1
      (* x (potenca x (- n 1)))))
```

Različni pomeni izrazov v odvisnosti od oklepajev:

```scheme
e ; izraz
(e) ; klic funkcije e, ki sprejme 0 argumentov
((e)); klic rezultata funkcije e , ki prejme 0 argumentov
```

**Oklepaji** omogočajo nedvoumno sintakso(pripriteta operatorjev) in predstavitev v drevesni obliki (razlčenjevanje)

#### Osnove

Izrazi :

 - Atomi - konstante, izrazi, ...
 - rezervirane besede - lambda, define, if, ...
 - zaporedja izraov v oklepajih (e1 e2 e4)

Logične vrednosti #t in #f

#### Seznami in pari

seznnami in pari se tvorijo z istim konstruktorjem (cons) <- prednosti dinamično tipiziranega jezika

```scheme
cons ; konstruktor
null ; prazen element
null? ; ali je seznam prazen
car ; glava
cdr ; rep
; funkcija za tvorjenje seznama
(list e1 e2 ... en)
```

## Predavanje 8

#### Dinamično tipiziranje

Racket pri prevajanju ne preverja podatkovnih tipov.
**Slabost:** uspešno lahko prevede programe, pri katerih pride do napake pri izvajanju.
**Prednost:** naredimo lahko bolj fleksibilne programe, ki niso odvisni od pravil sistema za statično tipiziranje (fleksibilne strukture brez deklaracije tipov)

#### Stavek cond

Namesto vgnezdenih if stavkov, podobno kot pattern matching

```scheme
(cond [pogoj1 e1]
      [pogoj2 e2]
      ...
      [pogojn en])
```

Podobno kot switch stavek.

#### Lokalno okolje

Definiranje lokalnega okolja za različnee potrebe (kot let in end v SML)

```scheme
let ;;izrazi se evalvacijo v okolju PRED izrazom let
let* ;; izrazi se evalvirajo kot rezultat predhodnih deklaracij (tako dela SML)
letrec ;; izrazi se evalvirajo v okolju, ki vključuje vse podane deklaracije (vzajeemna rekurzija)
define ;; semantika ekvivalentna kot pri letrec, le drugačna sintaksa
```

letrec in define podobno kot vzajemmna rekurzija v SML. pozor: Izrazi se evalvirajo v vrstnem redu takrat morajo biti spremenjivke definirane; izjema so funkcije: telo se izvede šele ob klicu funkcije
(globalne) deklaracije v programski datoteki se obnašajo kot letrec.

Z letrec se vse spremenljivke naenkrat naložiijo v statično okolje, ampak, to ne pomeni, da so vezave vrednosti storjene. npr.

```scheme
;; to se prevede, ampak program reče, da spremenljivka d ni evalvirana
(define (test-letrec a)
letrec ([b 3]
        [c (+ d 1)]
        [d (+ a 1)])
  (+ a d))
;; se prevede in deluje, ker je funkcija
(define (test-letrec a)
letrec ([b 3]
        [c lambda(x) (+ a b d x)]
        [d (+ a 1)])
  (+ c d))
```

#### Zakasnjena evalvacija

(angl. Lazy evaluation)

semantika programskega jezika mora opredeljevati kdaj se izrazi evalvirajo.
Spomnimo se primera deklaracij (deffine x e):

	- če je e aritmetični izraz se ta evalvira tkoj ob vezavi, v x se shrani rezultat(takojšnja ali zgodna evalvacija angl. eager evaluation)
	- Če je e funkcija, torej (lambda ...) se telo evalvira šele ob klicu (x) (Zakasnjena evalvacija angl delayed evaluation)

## Predavanje 9

```scheme
; zaporedje izrazov
(begin e1 e2 ... en)
; par katerega komponente lahko spreminjamo kot en arraylist je to
mcons ; konstruktor
mcar ; glava
mcdr ; rep
mpair? ; je par?
set-mcar! ; nastavi novo glavo
set-mcdr! ; nastavi novi rep
```

#### Zakasnitev in sprožitev

Mehanizem je že vgrajen v Racket. Delay prejme zakasnitveno funkcij in vrne par s komponentama: bool: intikator ali je izraz evalviran, zakasnitvena funkcija ali evalviran izrraz

```scheme
;ZAKASNITEV
(define (my-delay thunk)
  (mcons #f thunk))
;Sprožitev
(define (my-force prom)
  (if (mcar prom)
      (mcdr prom)
      (begin (set-mcar! prom #t)
             (set-mcdr! prom ((mcdr prom)))
             (mcdr prom))))
```

#### Tokovi

**Tok:**  neskončno zaporedje vrednosti (npr. naravna pptevila), ki ga ne moremo definirati s podajanjem vseh vreddnosti. Ideja: podajmo le (trenutno) vrednost in zakasnimo evalvacijo (thunk) za izračun naslednje vrednosti. Definiramo kot par *'(vrednost . funkcija-za-naslednji)*

```scheme
; tok enk
(define enke (cons 1 (lambda () enke)))
; tok naravnih števil
(define naravna
  (letrec ([f (lambda (x) (cons x (lambda () (f (+ x 1)))))])
    (f 1)))
;izpisi
(define (izpisi n tok)
  (if (> n 1)
      (begin
       (displayIn (car tok))
       (izpisi (- n 1) ((cdr tok))))
      (displayIn (car tok))))
```

#### Memoizacija

Če funkcija pri istih argumentih svakič vrača isti odgovor in nima stranskih učinkov, lahko shranimo odgovore za večkratno uporabo.
Implementacija:

 - Uporabimo seznam parov dosedanjih rešitev '((arg1, odg1), ... , (argn, odgn))'
   	- Ne želimo, da je globalno dostopen
    - ne sme biti v rekurzivni funkciji, kje bo spraznil z vsakim klicem
 - Če rešitev obstaja, jo beremo iz seznama (Pomagamo si z vgrajeno funkcijo assoc)
 - Če rešitve še ni, jo izračunamo -> dopolnimo seznam rešitev
   	- Za dopolnitev seznama potrebujemo mutacijo (set!)

## Predavanje 10

#### Makro

Makro definira, kako sintakso v programskem jeziku preslikamo v drugo sintakso:

- orodje, ki ga ponuja prog. jezik
- razširitev jezika z novimi ključnimi besedami
- impementacija sintaktičnih olepšav

Programski jeziki (racket, C, ...) imajo posebno sintaks za definiranje makrov.
Postopek razširitve makro definicij se izvede pred prevajanjem in izvajanjem programa. Primeri:

- Lasten if stavek: *(moj-if pogoj then e1 else e2)*

  ```scheme
  (define-syntax moj-if
  	(syntax-rules (then else)
      	[(moj-if e1 then e2 else e3)
           (if e1 e2 e3)]))
  ```

- trojni if: *(if3 pog then e1 elsif pogoj2 then e2 else e3)*

  ```scheme
  (define-syntax if3
  	(syntax-rules (then elsif else)
      	[(if3 pogoj1 then e1 elsif pogoj2 then e2 else e3)
           (if pogoj1 e2 (if pogoj2 e2 e3))]))
  ```

- elementi toka: *(prvi tok), (drugi tok), (tretji tok)*

  ```scheme
  (define-syntax prvi
  	(syntax-rules ()
      	[(prvi e)
           (car e)]))
  (define-syntax drugi
  	(syntax-rules ()
      	[(drugi e)
           (cdr (cdr e)]))
  (define-syntax tretji
  	(syntax-rules ()
      	[(tretji e)
           (cdr ((cdr ((car e)))))]))
  ```

- komentiranje spremenljivk: *(anotiraj xyz "trenutni stevec")*

  ```scheme
  (define-syntax anotiraj
  	(syntax-rules ()
      	[(anotiraj e s)
           e]))
  ```

#### Definicije makrov

Rezervirana baseda *define-syntax*. Preostae ključne besede opredelimo s *syntax-rules*.
V [...] podamo vzorce za makro razširitev.

##### 1. Makro / funkcija

```scheme
(define-syntax my-delaym 
	(syntax-rules ()
     	[(my-delaym e)
         (mcons #f (lambda () e))]))
;(my-delaym (+ 3 2))
(define (my-delay thunk)
  (mcons #f thunk))
;(my-delay (lambda () (+ 3 2)))
```

##### 2. prioriteta izračunov

Racket težav s prioriteto nima, ker uporablja infiksno notacijo, ki opredeljuje prioriteto operacij

##### 3. način evalvacije

Pri macrotu se ob vsakem pojavu spremenljivke kliče spremenljivka, zato rašji uporabljamo funkcije ali pa lokalno okolje.

##### 4. semantika dosega

Kaj se zgodi če makro uporablja iste spremenljivke, ki nastopajo že v funkciji?
Naivna makro rešitev (uporabljena v C; je enakovredna find&replace) lahko povzroči težave.

#### Lastni podatkovni tipi

Je dinamično tipiziran, zato eksplicitna definicija alternativ ni potrebna.
Preprosta rešitev:

 - Simulacija alternativ z seznami oblike (tip vrednost1 ... vrednostn)
 - Izdelava funkcij za preverjanje podatkovnega tipa in funkcij za dostop do elementov

```scheme
; datatype prevozno_sredstvo = Bus of int | Avto of string*string | Pes
;konstruktor
(define (Bus n) (list "bus" n))
(define (Avto tip barva) (list "avto" tip barva))
(define (Pes) (list "pes"))
; preverjanje podatkovnega tipa
(define (Bus? x) (eq (car x) "bus"))
(define (Avto? x) (eq (car x) "avto"))
(define (Pes? x) (eq (car x) "pes"))
; funkcije za dostop do elementov
(define (Bus-n x) (car (cdr x)))
(define (Avto-tip x) (car (cdr x)))
(define (Avto-barva x) (car (cdr (cdr x))))
```

## Predavanje 11

#### Razširitve

1. definiranje spremenljivk
2. definiranje lokalnih okolij
3. definiranje funkcij (funkcijskih ovojnic)
4. definiranje makrov

#### Lokalno okolje

```scheme
(define (jais2 e)
  (letrec ([jais (lambda e env)
                 (cond |[(konst? e) e]
                       |[(bool? e) e]
                       |[(sestej? e) (let ([v1 (jais (sestej-e1 e) env)]
                                           [v2 (jais (sestej-e2 e) env)]
                                           )
                                       (if (and (konst? v1) (konst? v2))
                                           (konst (+ (konst-int v1)
                                                     (konst-int v2)))
                                           (error "seštevanec ni celo število")))])])
    (jais e null)))
```

## Predavanje 12

#### Funkcije z različnim številom argumentov

**Poljubno št. argumentov** podamo z imenom spremenljivke brez oklepaja. V funkciji so vsi ti argumenti podani v seznamu, ki sledi ključni besedi lambda.

```scheme
(define izpisi
  (lambda sez
    (displayIn sez)))

(define vsotamulti
  (lambda stevila
    (apply + stevila)))

(define mnozilnik
  (lambda (ime faktor . stevila)
    (printf "-a-a-a-a"
            "Zivjo "
            ime
            ", tvoj rezultat je"
            (map (lambda (x) (* x faktor)) ))))
```

