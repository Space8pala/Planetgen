    ---<ÁLTALÁNOS>---
A Plangen/Üvegbolygó applikáció fő céja Szimplex zaj felhasználása bolygók generálására.
Emellett lehetővé teszi a generált bolygók mentését, megosztását.

<ELINDÍTÁS>
Az alkalmazás elindításához a main.py fájlt kell lefuttattni, majd az alkalmazás elérhető lesz http://localhost:8080/ - on
A használt adatbázis változtatását a /views/static mappában a használni kívánt adatbázist "database_used.db"-re nevezésével lehet megváltoztatni.

<FUNKCIÓK>
-Fiók
    -Regisztráció
    -Bejelentkezés
    -Fiók szerkesztése (felhasználónév, jelszó ...stb)
-Bolygók
    -Generálása
    -Letöltése
    -Fiókba mentése
    -Adatai szerkesztése
    -Törlése
-Mentett bolygók között böngészés

<TECHNIKAI ESZKÖZÖK>
-Bottle (backend)
-Sqlite (adatbázis)

<HASZNÁLT KÖNYVTÁRAK>
-p5-min
-Stefan Gustavson Simplex java implementációjának js portja



    ---<FELÉPÍTÉS>---
-<ADATBÁZIS SZERKEZET>-
=> PLANETS
    -id (int)
    -owner_id (int) [joins USERS.id]
    -siteside_id (text)
    -name (text)
    -description (text)
    -seed (int)
=> USERS
    -id (int)
    -username (text)
    -password (text)
    -email (text)
    -displayname (text)
    -bio (text)
    -joined_on (text)
    -admin (int)
=> PLANET_IMAGES
    -id (int)
    -p_code (text) [joins PLANETS.siteside_id]
    -image (text)


-<OLDALAK>-
<fejléc>
A fejléc a bejelentkezés és regisztráció oldalakon kívül mindegyik oldalon látható. 
Elnavigálhatunk vele a böngészésre és a főoldalra, valamint bejelentkezés függvényében vagy a regisztráció és bejelentkezés, 
vagy a profil és beállítások oldalra. Ezek mellett ki is jelentkezhetünk. (A kijelentkezés átírányít a főoldalra)


<FŐOLDAL>
A főoldal az első oldal amit látunk az applikáció elindítása után.
Pár másodperc betöltést követve megjelenik a generált bolygó az oldal közepén.
A bolygó alatti gombokkal lehetséges azt forgatni, vagy a képet letölteni.
Ha be van jelentkezve akkor a mentés gomb is látható.

Mind a 3 forgatást vezényelő gomb a generált képet tartalmazó 'div' osztályának változtatásával működik. 
Az új osztályoknak egy CSS animáció tulajdonsága van.

Ehhez hasonlóan a mentés gomb is egy a gombnyomásig láthatatlan 'form' elem osztályát változtatja láthatóvá.
Benne megadható a bolygónak a neve és leírása (ezek közül egyik sem kötelező) két 'input' mezőben.
Emellett két nem látható mezőben tárolja az alkalmazás a bolygó seed-jét és a kép base64 string-é alakított verzióját.
Ezek mellett a szerver generál egy egyéni, maggal nem összefüggő, 4 jegyű kis- nagybetűkből és számokból álló stringet, ami a bolygónak az alkalmazáson belül használt azonosítója lesz (siteside_id az adatbázisban). Ezt a szerver nem a 'form'-on keresztül továbbítja, hanem a bolygónézet url-jének a végére teszi.
Beküldés után a át lesz irányítva a bolygónézetbe.


<BÖNGÉSZÉS>
Itt az adatbázisban elmentett bolygók között lehet nézelődni. A bolygók sorrendje az adatbázis sorrendje alapján van. 
Egy esetleges jövőbeli frissítésben lehetséges lenne a bolygó készítés időpontja, vagy név alapján rendezésének megvalósítása (tessék olvasni: most nem volt rá ídőm, de meg fogom csinálni mert érdekel)
A böngésző egyszerre csak egy adott mennyiségű bolygót jelenít meg (alap: 12), így több lapra van bontva (pl.: browse/page1).
A fejlécben szerepel hogy mennyi bolygó látható jelenleg, alatta pedig lehetséges a böngésző lapjai között váltogatni.
Ezek alatt pedig megjelennek a bolygók. A bolygókat megjelenítési nevük (lásd.: köv bekezdés) és a lementett képük képviseli.
Bár lehetséges lenne, hogy a bolygókat mag alapján újrageneráljuk, gyakorlatban ez sokkal időigényesebb mint szimplán betölteni a képet.
Egy bolygóra kattintva át lesz irányítva a bolygónézetbe.


<BOLYGÓ>
Itt ismét nagyban látjuk a bolygót, valamint mellette a bolygó megjelenítési nevét (alkalmazás által adott kód, vagy felhasználó által adott név),
alatta pedig a tulajdonos nevét (felhasználónév vagy becenév). A tulajdonos nevére kattintva át lesz irányítva a felhasználó profiljára.
Ez alatt jelenik meg a bolygó leirása (ha van), valamint a kódja.
Ez alatt pedig a főoldalról ismerős forgató gombok, valamint a letöltés.

Ha a be van jelentkezve, és a bolygó az öné, akkor megjelenik még két gomb: bolygó szerkestése, bolygó törlése.
Szerkesztéssel a bolygó nevét és leirását lehet változtatni.
Törléssel, a jelszava megadáse után a bolygót véglegesen törli fiókjáról.


<FELHASZNÁLÓ>
Itt látható a felhasználó beceneve (ha van) és neve, alatta pedig a leirása (ha van) és csatlakozási dátuma.
Ez alatt pedig fel van sorolva a felhasználó bolygói, a böngészés oldalhoz hasonlóan.


<BEÁLLÍTÁSOK>
A felhasználó itt meg tudja változtatni becenevét, leirását, felhasználónevét, email címét és jelszavát.


<BEJELENTKEZÉS>
Ha már van a felhasználónak fiókja, a felhasználónév és a jelszó beirásával itt tud bejelentkezni.
Félreírás esetén a program nem figyeli külön, hogy a felhasználónévben, vagy a jelszóban van-e hiba.


<REGISZTRÁCIÓ>
Ha még nincs fiókja, akkor itt tud készíteni egyet.
Meg kell adni egy felhasználónevet, email címet és egy jelszót.
A program külön követi, hogy foglalt-e a felhasználónév, foglalt-e az email cím, és megeggyezik-e a jelszó a jelszó megerősítéssel.


---<A BOLYGÓ GENERÁLÁSRÓL BŐVEBBEN>---
A bolygó rajzolásához a p5-min JavaScript könyvtárat használom, két for loop segítségével végig iterálom a bolygó rajzfelületeként szolgáló 'canvas' elem pixeleit.
Egy adott pixel három függvényen kell átmennie mielőtt a 'canvas'-ba beletesszük:
-Simplex.noise(x,y,z)
-FractalBrownianMotion(x, y, z, numOctaves)
-drawNoise3D(size,x,y) //size = canvasz mérete

Az első egyszerű, x y z (azaz 3 dimenzós) koordinátákba eső zaj értékét kapjuk meg, ez a rajzolás fő része.
A második a térképen látható kisebb részletekért felel. Többször meghívja az első algoritmust ugyanarra a pontra, de más méretű zajjal, majd ezek értékét összeadja (minnél részletesebb a zaj, annál kevesebb lesz az értéke. Ez a videó jól demonstrálja: https://youtu.be/lctXaT9pxA0?si=_Y_Y0cC9fs2m5Bpp&t=490 ).
A harmadik biztosítja hogy a zaj az Y tengely mentén tükrös legyen. Ennek az elméleti részét a következő oldal magyarázza el jól: https://ronvalstar.nl/creating-tileable-noise-maps

A fentiek alapján egy fekete fehér bolygót kapunk. Ezt a pixelek értéke alapján 5 sávra osztom, és mindegyik sávnak adok egy random színt (valójában csak 3 random szín, mivel a második és az utolsó sáv az elöttinek egy árnyalata lesz)


---<A ZAJ ALGORITMUSRÓL BŐVEBBEN>---
(Minden forrásom a Perlin zajról beszél. Ez azért van, mert a élettartamának nagy részén azt használtam a bolygó generáláshoz. A Simplex-re váltás oka nagyon egyszerű: szebb eredményeket adott. A kettő algoritmus roppant hasonló)
https://rtouti.github.io/graphics/perlin-noise-algorithm
https://youtu.be/ikwNrFvnL3g?si=uBiPAAo-m1FQ8Hvp
