% include("mainheader.tpl",title="")

<%  
    curpage=pageinfo[0]
    pagesize=pageinfo[1]
    maxpages=pageinfo[2]
    maxplanets=pageinfo[3]

    prevpage=curpage-1
    nextpage=curpage+1
    
    lowrange=(curpage-1)*pagesize+1
    uprange=min((curpage)*pagesize,maxplanets)
%>

<main class="paddedmain">

    <h2 class="headerdiv">{{lowrange}} - {{uprange}} a {{maxplanets}} bolygóból</h2>

    <div class="pagination">
        %if prevpage != 0:
        <a class="bigbutton" href="/browse/page{{prevpage}}"><</a>
        %else:
        <a class="bigbuttondisabled" href=""><</a>
        %end
        %for i in range(1,maxpages+1):
            %if curpage != i:
                <a class="bigbutton" href="/browse/page{{i}}">{{i}}</a>
            %else:
            <a id="active" class="bigbutton" href="/browse/page{{i}}">{{i}}</a>
            %end
        %end
        %if nextpage <= maxpages:
        <a class="bigbutton" href="/browse/page{{nextpage}}">></a>
        %else:
        <a class="bigbuttondisabled" href="">></a>
        %end
    </div>

        <div class="container" style="border: none;">
        <ul>
            % for i in range(len(browplanets)):
            <li><a href="../planet/{{browplanets[i]['code']}}"><div  class="smallplanetcontainer"><img src="{{browplanets[i]['image']}}"></div><div class="pnames">{{browplanets[i]["displayedname"]}}</div></a></li>
            %end
        </ul>
        </div>
        
    <div class="pagination">
        %if prevpage != 0:
        <a class="bigbutton" href="/browse/page{{prevpage}}"><</a>
        %else:
        <a class="bigbuttondisabled" href=""><</a>
        %end
        %for i in range(1,maxpages+1):
            %if curpage != i:
                <a class="bigbutton" href="/browse/page{{i}}">{{i}}</a>
            %else:
            <a id="active" class="bigbutton" href="/browse/page{{i}}">{{i}}</a>
            %end
        %end
        %if nextpage <= maxpages:
        <a class="bigbutton" href="/browse/page{{nextpage}}">></a>
        %else:
        <a class="bigbuttondisabled" href="">></a>
        %end
    </div>
</main>
</body>
</html>