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

<ADATBÁZIS SZERKEZET>
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
