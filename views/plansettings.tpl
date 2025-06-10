% include("mainheader.tpl",title="")

<main class="paddedmain">
    <div class="container">
        <div class="headerdiv"><h3>Bolygó szerkesztése</h3></div>
        <form action="/update/{{lookieplanet['code']}}" method="POST">

            <div class="formgroup">
            <label for="displayname">Név:</label><br>
            <input class="darkinput" type="text" id="planname" name="planname" value="{{lookieplanet['name']}}" pattern="\w{2,23}"></div><br>

            <div class="formgroup">
            <label for="bio">Leirás</label><br>
            <textarea class="darkinput" id="description" name="description" cols="40" rows="8" style="resize: none;" maxlength="200">{{lookieplanet["description"]}}</textarea></div><br>

            <input class="darkinputbutt" type="submit">
        </form>
    </div>

</main>
    
</body>
</html>