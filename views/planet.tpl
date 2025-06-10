% include("mainheader.tpl",title=lookieplanet["displayedname"]+" - Bolygó - ")

<main class="paddedmain">
<div class="flexframe">

<div class="bigplanetcontainer"><div id="pcontainer"><img id="original" src="{{lookieplanet['image']}}" style="float: left;margin: -1px;"></div></div>
<div class="planetinfo">
    <div class="contenttitle">
        <h2>{{lookieplanet["displayedname"]}}</h2>
        <a href="../user/{{lookieplanet['owner']}}"><h3>{{lookieplanet["owner"]}}</h3></a>

        %if loggedin:
        %if curuser["username"]==lookieplanet["owner"]:
        <a href="/update/{{lookieplanet['code']}}" class="smallbutton">Szerkesztés</a>
        <a href="/delete/{{lookieplanet['code']}}" class="smallbutton">Bolygó törlése</a>
        %end
        %end

    </div>
    <div class="container" style="max-width: 600px;">

        %if lookieplanet["description"] != "":
        <div class="headerdiv"><h3>Leirás</h3></div>

        <p>{{lookieplanet["description"]}}</p>
        %end

        <p id="planseed" style="display: none;">{{lookieplanet["seed"]}}</p>

        <dl>
            <dt class="planetprstats">Kód : </dt>
            <dd> ({{lookieplanet["code"]}})</dd>
    </div>
    <div id="buttonbox">
        <button class="bigbutton" id="leftbutton" onclick="rotateleft()">&lt;</button>
        <button class="bigbutton" id="stopbutton" onclick="rotatestop()">■</button>
        <button class="bigbutton" id="rightbutton" onclick="rotateright()">&gt;</button>
            <a href="{{lookieplanet['image']}}" download="bolygo.png"><button class="bigbutton">LETÖLTÉS</button><a>
    </div>
    
    
</div>

</div>
</main>

<script src="./static/Simplex.js"></script>
<script src="./static/p5.min.js"></script>
<script src="./static/planetrotater.js"></script>
<script>

function setDouble(){
    
    const originalimg = document.getElementById("original");

    const canvas = document.createElement('canvas');
    canvas.width = originalimg.naturalWidth;
    canvas.height = originalimg.naturalHeight;
    canvas.getContext('2d').drawImage(originalimg, 0, 0);
    const dataURL = canvas.toDataURL();

    const rightcopy = document.createElement("img");
    rightcopy.src = dataURL;
    document.getElementById("pcontainer").appendChild(rightcopy);
}
setDouble()
</script>
</body>
</html>