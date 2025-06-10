% include("mainheader.tpl",title=lookieuser["displayedname"]+" - ")

<main class="paddedmain">
    <div class="contenttitle">
        <h2>{{lookieuser["displayedname"]}}</h2>
        %if lookieuser["displayname"] != "":
        <h3>{{lookieuser["username"]}}</h3>
        %end
    </div>

    <div class="container">
        %if lookieuser["bio"] != "":
        <div class="headerdiv"><h3>Leirás</h3></div>
        <p>{{lookieuser["bio"]}}</p>
        %end
        <i>Csatlakozott : {{lookieuser["joined on"]}}</i>
    </div>

    %if lookieuser["planets"] != []:
    <div class="container">
        <div class="headerdiv"><h3>Bolygók</h3></div>
        <ul>
        % for i in range(len(lookieuser["planets"])):
        <li><a href="/planet/{{lookieuser['planets'][i][0]}}"><div class="smallplanetcontainer"><img src="{{lookieuser['planets'][i][2]}}"></div><div class="pnames">{{lookieuser["planets"][i][1]}}</div></a></li>
        %end
        </ul>
    </div>
    %end
</main>

</body>
</html>