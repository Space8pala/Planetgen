<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../static/style.css">
    <title>{{title}}Üvegbolygó</title>
    <link rel="icon" type="image/x-icon" href="../static/favicon.ico">
</head>
<body>
<header>
    <a href="/" id="icontext"><img id="iconimg" src="../static/icon.png">Üvegbolygó</a>
</header>

<nav class="navbar">
    <ul>
        %if loggedin:
    <li class="dropdown"><a>Üdv, <b>{{curuser["displayedname"]}}</b>!</a>
        <div class="content">
            <a href="/user/{{curuser['username']}}">Profil</a>
            <a href="../settings">Beállítások</a>
            <a href="../logout">Kijelentkezés</a>
        </div>
    </li>
         %end

         <li><a href="/">Főoldal</a></li>
         <li><a href="../browse">Böngészés</a></li>

         %if loggedin==False:
    <li id="login" style="float: right;"><a href="../login">Belépés</a></li>
    <li id="register" style="float: right;"><a href="../register">Regisztráció</a></li>
        %end
    </ul>
</nav>