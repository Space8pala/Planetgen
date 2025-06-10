% include("mainheader.tpl",title="")

<main class="paddedmain">

    <div class="submitdivhidden" id="saveform">
        <form class="container" id="saveplanet" action="/planet/{{plancode}}" method="POST">
            <div class="headerdiv"><h3>Bolygó mentése</h3></div>

            <div class="formgroup">
            <label for="planname">Név (nem kötelező)</label><br>
            <input class="darkinput" type="text" id="planname" name="planname" pattern="\w{2,23}"></div><br>

            <div class="formgroup"> 
            <label for="planbio">Leirás (nem kötelező)</label><br>
            <textarea class="darkinput" id="plandesc" name="plandesc" cols="40" rows="8" style="resize: none;" maxlength="200"></textarea></div><br>
            <input type="hidden" id="planseed" name="planseed">
            <input type="hidden" id="planimg" name="planimg">
                Ékezetes betűk használata nem ajánlott!<br><br>
            <input onclick="getimage()" class="darkinputbutt" type="submit">
        </form>
    </div>

    <div class="flexframe" style="flex-direction: column;">
        <div class="bigplanetcontainer" style="overflow: hidden;"><div id="pcontainer"></div></div>

            <div class="buttonbox">
                <div><button class="bigbutton" id="leftbutton" onclick="rotateleft()">&lt;</button></div>
                <div><button class="bigbutton" id="stopbutton" onclick="rotatestop()">■</button></div>
                <div><button class="bigbutton" id="rightbutton" onclick="rotateright()">&gt;</button></div>
                <div><a id="downloadplan" href="#" download="bolygo.png"><button class="bigbutton">LETÖLTÉS</button></a></div>
                %if loggedin == True:
                <div><button id="savebutton" class="bigbutton" onclick="reavealSaveform()">MENTÉS</button></div>
                <div><button id="cancelbutton" class="bigbuttonhidden" onclick="hideSaveform()">MÉGSE</button></div>
                % end
            </div>
            %if loggedin == False:
            <div><h4>A bolygók online mentéséhez kérem jelentkezzen be!</h4></div>
            %end
    </div>
</main>

<script src="./static/revealsaveform.js"></script>
<script src="./static/planetrotater.js"></script>
<script src="./static/Simplex.js"></script>
<script src="./static/p5.min.js"></script>
<script>
function splitmix32(a) {
return function() {
    a |= 0;
    a = a + 0x9e3779b9 | 0;
    let t = a ^ a >>> 16;
    t = Math.imul(t, 0x21f0aaad);
    t = t ^ t >>> 15;
    t = Math.imul(t, 0x735a2d97);
    return ((t = t ^ t >>> 15) >>> 0) / 4294967296;
    }
}
   
seed = (Math.random()*2**32)>>>0
console.log(seed)
const prng = splitmix32(seed)
Simplex.setRng(prng)
const submitseed = document.getElementById("planseed").value = seed;

function FractalBrownianMotion(x, y, z, numOctaves) {
    let result = 0.0;
    let amplitude = 0.6;
    let frequency = 4;

    for (let octave = 0; octave < numOctaves; octave++) {
        const n = amplitude * Simplex.noise(x*frequency,y*frequency,z*frequency);
        result += n;
        
        amplitude *= 0.4;
        frequency *= 1.8;
    }

    return result;
}
function drawNoise3D(size,x,y){
    width=size[0]
    height=size[1]

    //Noise range
    const x1 = 0, x2 = 1;
    const y1 = 0, y2 = 1;				
    const dx = x2 - x1;
    const dy = y2 - y1;
    
    //Sample noise at smaller intervals
    const s = x / width;
    const t = y / height;

    // Calculate our 3D coordinates
    const nx = x1 + Math.cos (s * 2 * Math.PI) * dx / (2 * Math.PI);
    const ny = x1 + Math.sin (s * 2 * Math.PI) * dx / (2 * Math.PI);
    const nz = t;

    let v = FractalBrownianMotion(nx, ny, nz, 9);
    
    return v;
}

function randomColor(relation,relatedTo){
    let c;
    switch(relation){
        case "same-lighter": c = color(hue(relatedTo),saturation(relatedTo)-5,lightness(relatedTo)+15)
            break;
        case "same-darker": c = color(hue(relatedTo),saturation(relatedTo)+5,lightness(relatedTo)-15)
            break;
        case "lighter": c = color(prng()*360,prng()*60,lightness(relatedTo)+15)
            break;
        case "darker": c = color(prng()*360,prng()*60,lightness(relatedTo)-15)
            break;
        default:
            c = color(prng()*360,prng()*60,prng()*100)
    }
    return c
}

class TerrainType {
    constructor(minHeight, maxHeight) {
        this.minHeight = minHeight;
        this.maxHeight = maxHeight;
    }
    setColor(color){
        this.color = color;
    }
    }

let levels =[];
let deepTerrain
let waterTerrain;
let sandTerrain;
let grassTerrain;
let treesTerrain;

function setup(){
    let map1=createCanvas(1100,550);
    map1.parent("pcontainer")
    pixelDensity(1);
    colorMode(HSL);

    deepTerrain =
        new TerrainType(0.1, 0.25, "none");
    waterTerrain =
        new TerrainType(0.25, 0.45, "lighter");
    sandTerrain =
        new TerrainType(0.45, 0.5, "none");
    grassTerrain =
        new TerrainType(0.5, 0.65, "none");
    treesTerrain =
        new TerrainType(0.65, 100, "lighter");

    deepTerrain.setColor(randomColor("none",deepTerrain.color))
    waterTerrain.setColor(randomColor("same-lighter",deepTerrain.color))
    sandTerrain.setColor(randomColor("none",deepTerrain.color))
    grassTerrain.setColor(randomColor("lighter",waterTerrain.color))
    treesTerrain.setColor(randomColor("same-lighter",grassTerrain.color))

    levels.push(deepTerrain,waterTerrain,sandTerrain,grassTerrain,treesTerrain)
    
    noLoop();
}

function draw() {
    loadPixels();
    for (let y=0; y < height; y++){
        for (let x = 0; x < width; x++){
            let index = ( x + y * width ) * 4;
            let r = drawNoise3D([width,height],x,y);
            //r is going to range ~>0.1 and ~>1
            for (let i in levels){
                if (r < levels[i].maxHeight){
                    terrainColor=levels[i].color
                break
                }
            }
            set(x,y,terrainColor)
        }
    }
    updatePixels();
    setDouble();
    noLoop();
}

function setDouble(){
    const originalimg = document.getElementById("defaultCanvas0");
    const dataURL = originalimg.toDataURL("image/png");

    const submiting = document.getElementById("planimg").value = dataURL;
    const downloading = document.getElementById("downloadplan").href = dataURL;

    const newimg = document.createElement("img");
    newimg.src = dataURL;
    document.getElementById("pcontainer").appendChild(newimg);
}
</script>   
</body>
</html>