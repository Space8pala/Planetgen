

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
-Bolygó generálása és mentése, adatinak szerkesztése és törlése
-Bolygó képének letöltése
-Mentett bolygók között böngészés

<TECHNIKAI>
-Bottle (backend)
-Sqlite (adatbázis)

<HASZNÁLT INTERPRETER>
-Vs Code

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
Emellett két nem látható mezőben tárolja az alkalmazás a bolygó seed-jét és a kép base64 string-é alakított verzióját
Beküldés után a át lesz irányítva a bolygónézetbe.


<BÖNGÉSZÉS>
Itt az adatbázisban elmentett bolygók között lehet nézelődni. A bolygók sorrendje az adatbázis sorrendje alapján van. 
Egy esetleges jövőbeli frissítésben lehetséges lenne a bolygó készítés időpontja, vagy név alapján rendezésének megvalósítása (tessék olvasni: most nem volt rá ídőm, de meg fogom csinálni)
A böngésző egyszerre csak egy adott mennyiségű bolygót jelenít meg (alap: 12), így több lapra van bontva (pl.: browse/page1).
A fejlécben szerepel hogy mennyi bolygó látható jelenleg, alatta pedig lehetséges a böngésző lapjai között váltogatni.
Ezek alatt pedig megjelennek a bolygók. A bolygókat megjelenítési nevük (lásd.: köv bekezdés) és a lementett képük képviseli.
Bár lehetséges lenne, hogy a bolygókat mag alapján újrageneráljuk, gyakorlatban ez sokkal időigényesebb mint szimplán betölteni a képet.
Egy bolygóra kattintva át lesz irányítva a bolygónézetbe.


<BOLYGÓ>
Itt ismét nagyban látjuk a bolygót, valamint mellette a bolygó megjelenítési nevét (alkalmazás által adott kód, vagy felhasználó által adott név),
alatta pedig a tulajdonos nevét (felhasználónév vagy becenév). A tulajdonos nevére kattintva át lesz irányítva a felhasználó profiljára.
Ez alatt jelenik meg a bolygó leirása (ha van), valamint a kódja (alkalmazás által generált, maggal nem összefüggő, 4 jegyű kis- nagybetűkből és számokból álló string)
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
