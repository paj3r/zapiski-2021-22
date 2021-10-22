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
