
function reavealSaveform(){
    document.getElementById("saveform").classList.remove("submitdivhidden")
    document.getElementById("saveform").classList.add("submitdivvisible")
    
    document.getElementById("savebutton").classList.remove("bigbutton")
    document.getElementById("savebutton").classList.add("bigbuttonhidden")
    
    document.getElementById("cancelbutton").classList.remove("bigbuttonhidden")
    document.getElementById("cancelbutton").classList.add("bigbutton")
}

function hideSaveform(){
    document.getElementById("saveform").classList.remove("submitdivvisible")
    document.getElementById("saveform").classList.add("submitdivhidden")
    
    document.getElementById("cancelbutton").classList.remove("bigbutton")
    document.getElementById("cancelbutton").classList.add("bigbuttonhidden")
    
    document.getElementById("savebutton").classList.remove("bigbuttonhidden")
    document.getElementById("savebutton").classList.add("bigbutton")
}

