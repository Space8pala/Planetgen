function rotateright(){
    if (document.getElementById("pcontainer").classList.contains("leftrotating")){
        document.getElementById("pcontainer").classList.remove("leftrotating")
    }
    document.getElementById("pcontainer").classList.add("rightrotating")
}

function rotatestop(){
    if (document.getElementById("pcontainer").classList.contains("rightrotating")){
        document.getElementById("pcontainer").classList.remove("rightrotating")
    }
    if (document.getElementById("pcontainer").classList.contains("leftrotating")){
        document.getElementById("pcontainer").classList.remove("leftrotating")
    }
}

function rotateleft(){
    if (document.getElementById("pcontainer").classList.contains("rightrotating")){
        document.getElementById("pcontainer").classList.remove("rightrotating")
    }
    document.getElementById("pcontainer").classList.add("leftrotating")
}