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

​	fun potenca (x:int, y:int) = 
​		if y>0 then x*potenca(x, y-1) else return x

​	fun sestejAB (a:int, b:int) = 
​		if a=b then a else sestejAB(a, b-1) + b

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

