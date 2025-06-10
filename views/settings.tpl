% include("mainheader.tpl",title="Beállítások - ")

<main class="paddedmain">
        %if conf != "":
        <div class="container">
        A változtatásai mentve lettek
        </div>
        %end
    <div class="container">
        <div class="headerdiv"><h3>Profil szerkesztése</h3></div>
        
        <form action="/settings/update_profile" method="POST">

            <div class="formgroup">
            <label for="displayname">Becenév:</label><br>
            <input class="darkinput" type="text" id="displayname" name="displayname" value="{{curuser['displayname']}}" pattern="\w{2,23}"></div><br>

            <div class="formgroup">
            <label for="bio">Leirás</label><br>
            <textarea class="darkinput" id="bio" name="bio" cols="40" rows="8" style="resize: none;" maxlength="200">{{curuser["bio"]}}</textarea></div><br>

            <input class="darkinputbutt" type="submit">
        </form>
    </div>
    <div class="container">
        <div class="headerdiv"><h3>Felhesználónév megváltoztatása</h3></div>
        <form action="/settings/change_username" method="POST">
            
            <div class="formgroup" style="margin-bottom: 18px;">
            Jelenlegi felhasználónév:<br>
            <small>{{curuser["username"]}}</small><br></div>

            <div class="formgroup">
            <label for="newuname">Új felhasználónév:</label><br>
            <input class="darkinput" type="text" id="newuname" name="newuname" pattern="\w{6,30}" required></div><br>

            <div class="formgroup">
            <label for="confnewuname">Új felhasználónév megerősítése:</label><br>
            <input class="darkinput" type="text" id="confnewuname" name="confnewuname" required></div><br>

            <div class="formgroup">
            <label for="curpassw">Jelenlegi jelszó:</label><br>
            <input class="darkinput" type="password" id="curpassw" name="curpassw" required></div><br>

            <input class="darkinputbutt" type="submit"> 
            %if err=="usernames_dont_match":
            A beírt felhasználónevek nem egyeznek.
            %end
            %if err=="taken_username":
            A beírt felhasználónév már foglalt.
            %end
            %if err=="incorrect_password":
            Hibás jelszó.
            %end
        </form>
    </div>
    <div class="container">
        <div class="headerdiv"><h3>Email megváltoztatása</h3></div>
        <form action="/settings/change_email" method="POST">
            
            <div class="formgroup" style="margin-bottom: 18px;">
            Jelenlegi email cím:<br>
            <small>{{curuser["email"]}}</small><br></div>

            <div class="formgroup">
            <label for="newemail">Új email cím:</label><br>
            <input class="darkinput" type="email" id="newemail" name="newemail" pattern="[a-z0-9._%+\-]+@[a-z0-9.\-]+\.[a-z]{2,}$" required></div><br>
            
            <div class="formgroup">
            <label for="confnewemail">Új email cím megerősítése:</label><br>
            <input class="darkinput" type="email" id="confnewemail" name="confnewemail" required></div><br>

            <div class="formgroup">
            <label for="curpassw">Jelenlegi jelszó:</label><br>
            <input class="darkinput" type="password" id="curpassw" name="curpassw" required></div><br>

            <input class="darkinputbutt" type="submit">
            %if err=="emails_dont_match":
            A beírt email címek nem egyeznek.
            %end
            %if err=="taken_email":
            A beírt email cím már használatban van.
            %end
            %if err=="incorrect_password":
            Hibás jelszó.
            %end
        </form>
    </div>
    <div class="container">
        <div class="headerdiv"><h3>Jelszó megváltoztatása</h3></div>
        <form action="/settings/change_password" method="POST">

            <div class="formgroup">
            <label for="newpassw">Új jelszó:</label><br>
            <input class="darkinput" type="password" id="newpassw" name="newpassw" required></div><br>

            <div class="formgroup">
            <label for="confnewpassw">Új jelszó megerősítése:</label><br>
            <input class="darkinput" type="password" id="confnewpassw" name="confnewpassw" required></div><br>

            <div class="formgroup">
            <label for="curpassw">Jelenlegi jelszó:</label><br>
            <input class="darkinput" type="password" id="curpassw" name="curpassw" required></div><br>

            <input class="darkinputbutt" type="submit">
            %if err=="passwords_dont_match":
            A beírt jelszavak nem egyeznek.
            %end
            %if err=="incorrect_password":
            Hibás jelszó.
            %end
        </form>
    </div>

</main>
    
</body>
</html>