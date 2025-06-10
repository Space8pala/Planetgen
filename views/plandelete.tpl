% include("mainheader.tpl",title="Bolygó törlése - ")
<main class="paddedmain">
    <h2 class="headerdiv">Véglegesen törölné {{lookieplanet["displayedname"]}}-t?<h2>
    <form action="/delete/{{lookieplanet['code']}}" method="POST" class="container">
        <div class="formgroup">
            <label for="password">Megerősítéshez kérjük írja be jelszavát:</label><br>
            <input class="darkinput" type="password" id="password" name="password"></div><br>
        <input class="darkinputbutt" type="submit">
    </form>
</main>
    
</body>
</html>