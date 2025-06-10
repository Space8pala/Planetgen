<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="./static/style.css">
    <title>Belépés - Üvegbolygó</title>
    <link rel="icon" type="image/x-icon" href="../static/favicon.ico">
</head>
<body id="accrelbody">
    <main>
        <div class="accrelbox" id="loginbox">
            <div id="l1"><h1>Kérem jelentkezzen be<h1></div>
        <form class="loginform" action="/login" method="POST">

            <div><input class="darkinput" type="text" name="felhasznalonev" placeholder="Felhasználónév" pattern="\w{6,30}" required></div>

            <div><input class="darkinput" type="password" name="jelszo" placeholder="Jelszó" required></div>

            <div><input class="darkinputbutt" type="submit" id="bekuld"></div>
        </form>
        </div>
        %if err:
        <div style="top: 80%;left: 50%;display: inline;position: fixed;transform: translateX(-50%);"><h4>Téves felhasználónév vagy jelszó, kérem próbálkozzon újra<h4></h4></div>
        %end
    </main>
</body>
</html>