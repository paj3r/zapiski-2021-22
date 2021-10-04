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

