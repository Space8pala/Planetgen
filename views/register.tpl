<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="./static/style.css">
    <title>Regisztráció - Üvegbolygó</title>
    <link rel="icon" type="image/x-icon" href="../static/favicon.ico">
</head>
<body id="accrelbody">
<main>

        <div class="accrelbox">
                <div id="l1"><h1>Regisztráció<h1></div>
            <form class="registerform" action="/register" method="POST">
                <div><input class="darkinput" type="text" id="felhasznalonev" name="felhasznalonev" placeholder="Felhasználónév" pattern="\w{6,30}" required></div>

                <div><input class="darkinput" type="email" id="emailcim" name="emailcim" placeholder="Email cím" minlength="6" maxlength="20" pattern="[a-z0-9._%+\-]+@[a-z0-9.\-]+\.[a-z]{2,}$" required></div>
            
                <div><input class="darkinput" type="password" id="jelszo" name="jelszo" placeholder="Jelszó" pattern="\W{6,20}" required></div>

                <div><input class="darkinput" type="password" id="jelszorep" name="jelszorep" placeholder="Jelszó újra" required></div>
            
                <div><input class="darkinputbutt" type="submit" id="bekuld"></div>
            </form>
        </div>

        %if err=="taken_username":
        <div style="top: 80%;left: 50%;display: inline;position: fixed;transform: translateX(-50%);"><h4>A beírt felhasználónév már használatban van, kérem próbálkozzon újra!<h4></h4></div>
        %end
        %if err=="taken_email":
        <div style="top: 80%;left: 50%;display: inline;position: fixed;transform: translateX(-50%);"><h4>A beírt email cím már használatban van, kérem próbálkozzon újra!<h4></h4></div>
        %end
        %if err=="passwords_dont_match":
        <div style="top: 80%;left: 50%;display: inline;position: fixed;transform: translateX(-50%);"><h4>A jelszavak nem egyeznek, kérem próbálkozzon újra!<h4></h4></div>
        %end

</main>
</body>
</html>