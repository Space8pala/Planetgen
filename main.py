from bottle import run, route, template, static_file, request, redirect, error
import sqlite3
import random
import math
import datetime

conn = sqlite3.connect("database_used.db")

loggedin=False
loginerror=False

err=""
conf=""

curuser={}
#current user

pagesize=12
pnum=1
#for "browse"

lookieuser={}
lookieplanet={}
#for looking at profiles and planets

@route("/browse/static/<filename>")
@route("/user/static/<filename>")
@route("/planet/static/<filename>")
@route("/static/<filename>")
def static(filename):
    return static_file(filename, root="./views/static")

@route("/")
@route("/home")
def homepage():
    plancode=""
    if loggedin:
        plancode = plancodegen()
    return template("index",plancode=plancode, loggedin=loggedin,curuser=curuser)

@route("/browse/page<pnum>")
def browser(pnum):
    rawplanets = conn.execute('''SELECT username, siteside_id, name, description, image FROM PLANETS 
                              INNER JOIN USERS ON USERS.id=PLANETS.owner_id
                              INNER JOIN PLANET_IMAGES ON PLANET_IMAGES.p_code=PLANETS.siteside_id''').fetchall()
    print(rawplanets)
    #it might be a good idea to only fetch rows that I will need to show, however, I do not know how to do that -
    #as even "fetchmany()" doesnt allow you to set a starting row.
    #I /could/ use the ids of the rows to locate where I am supposed to start from, but that breaks down the second -
    #I start deleting things from the database

    #I could have a regularly updated view that sorts planets based on id, but that seems like a massive hassle, -
    #since that would only make sense for a large database. And this is supposed to be a proof of concept.. I think.
    #might do it if I have the time later tbh, since it /is/ a very interesting issue and I'm cuious about the solution
    browplanets=[]
    for i in range((int(pnum)-1)*pagesize,(int(pnum)*pagesize)):
        if i>=len(rawplanets):
            break
        rawplanet=rawplanets[i]
        planet= {
            "displayedname" : rawplanet[2] if rawplanet[2] != "" else f"({rawplanet[1]})",
            "owner" : rawplanet[0],
            "code" : rawplanet[1],
            "name" : rawplanet[2],
            "description" : rawplanet[3],
            "image" : rawplanet[4],
        }
        browplanets.append(planet)

    #I am putting pagination in a list cause its getting cluttered down there
    pageinfo=[int(pnum),pagesize,math.ceil(len(rawplanets)/pagesize),len(rawplanets)]

    if (len(browplanets)!=0) or (pnum=="1"):
        return template("browse", pageinfo=pageinfo, browplanets=browplanets, loggedin=loggedin, curuser=curuser)
    else:
        return redirect("../404")


@route("/browse")
def setpagenum():
    return redirect("/browse/page1")


@route("/login")
def login():
    return template("./views/login",err=loginerror)


@route("/login", method="POST")
def do_login():
    username = request.forms.get("felhasznalonev")
    password = request.forms.get("jelszo")
    tryuser = conn.execute(f'SELECT * FROM USERS WHERE (username="{username}" AND password="{password}")').fetchone()
    if tryuser != None:
        global loggedin 
        loggedin = True
        global curuser
        curuser = {
            "userid" : tryuser[0],
            "displayedname" : tryuser[4] if tryuser[4] != "" else tryuser[1],
            "username" : tryuser[1],
            "password" : tryuser[2],
            "email" : tryuser[3],
            "displayname" : tryuser[4],
            "bio" : tryuser[5],
            "joined on" : tryuser[6],
            "admin?" : bool(tryuser[7]),
        }
        print(curuser)
        loginerror=False
        return redirect("/")
    else:
        loginerror=True
        return template("login",err=loginerror)


@route("/register")
def register():
    return template("register",err=err)

@route("/register", method="POST")
def do_register():
    username = request.forms.get("felhasznalonev")
    email = request.forms.get("emailcim")
    password = request.forms.get("jelszo")
    passconf = request.forms.get("jelszorep")

    global err

    if (username,) in conn.execute("SELECT username FROM USERS").fetchall():
        err="taken_username"
        return template("register",err=err)
    
    elif (email,) in conn.execute("SELECT email FROM USERS").fetchall():
        err="taken_email"
        return template("register",err=err)
    
    elif password!=passconf:
        err="passwords_dont_match"
        return template("register",err=err)
    
    else:
        err=""
        now = datetime.datetime.now()
        conn.execute(f'''INSERT INTO USERS (username, password, email, joined_on) VALUES
                    ("{username}","{password}","{email}","{now.strftime("%Y-%m-%d")}");''')
        uid=conn.execute(f'''SELECT id FROM USERS WHERE username="{username}"''')
        global loggedin 
        loggedin = True
        global curuser
        curuser = {
            "userid" : uid,
            "displayedname" : username,
            "username" : username,
            "password" : password,
            "email" : email,
            "displayname" : "",
            "bio" : "",
            "joined on" : now.strftime("%Y-%m-%d"),
            "admin?" : False,
        }
        conn.commit()
        return redirect("/")


@route("/logout")
def logout():
    global loggedin
    loggedin = False
    global curuser
    curuser = {}
    global err
    err = ""
    global conf
    conf =""
    return redirect("/")


@route("/settings")
def settings():
    if loggedin:
        return template("settings",curuser=curuser, loggedin=loggedin,conf=conf,err=err)
    else:
        return redirect("login")
    
@route("/settings/update_profile", method="POST")
def update_profile():
    displayname = request.forms.get("displayname")
    bio = request.forms.get("bio")

    if loggedin:
        curuser["displayedname"] = displayname if displayname!="" else curuser["username"]
        curuser["displayname"] = displayname
        curuser["bio"] = bio
    
    #noone fucking BREATHE on this code
    #"loggedin" is always true, logically there is no reason for the if statement, i know this!
    #BUT FOR SOME REASON if I dont access the value of "loggedin" in some way it gets turned to false and the contents of curuser get eaten
    #I dont know why it does that, I dont know why this fixes it, this is stupid.
    #until I figure out something that makes sense I will be using it tho

    conn.execute(f'''UPDATE USERS 
                SET displayname="{curuser["displayname"]}",bio="{curuser["bio"]}"
                WHERE id="{curuser["userid"]}"''')
    conn.commit()

    global conf
    conf="updated_profile"

    return redirect("../settings")

@route("/settings/change_username", method="POST")
def change_username():
    newuname = request.forms.get("newuname")
    confnew  = request.forms.get("confnewuname")
    trypassw = request.forms.get("curpassw")

    global err
    global conf
    conf=""

    if newuname!=confnew:
        err="usernames_dont_match"
    
    elif (newuname,) in conn.execute("SELECT username FROM USERS").fetchall():
        err="taken_username"
    
    elif trypassw!=curuser["password"]:
        err="incorrect_password"
    
    else:
        if loggedin:
                curuser["displayedname"] = curuser["displayname"] if curuser["displayname"]!="" else newuname
                curuser["username"] = newuname

        conn.execute(f'''UPDATE USERS 
                SET username="{curuser["username"]}"
                WHERE id="{curuser["userid"]}"''')
        conn.commit()

        conf="updated_username"
        err=""

    return redirect("../settings")

@route("/settings/change_email", method="POST")
def change_email():
    newemail = request.forms.get("newemail")
    confnew  = request.forms.get("confnewemail")
    trypassw = request.forms.get("curpassw")

    global err
    global conf
    conf=""

    if newemail!=confnew:
        err="emails_dont_match"
    
    elif (newemail,) in conn.execute("SELECT email FROM USERS").fetchall():
        err="taken_email"
    
    elif trypassw!=curuser["password"]:
        err="incorrect_password"
    
    else:
        if loggedin:
                curuser["email"] = newemail

        conn.execute(f'''UPDATE USERS 
                SET email="{curuser["email"]}"
                WHERE id="{curuser["userid"]}"''')
        conn.commit()

        conf="updated_email"
        err=""
    
    return redirect("../settings")

@route("/settings/change_password", method="POST")
def change_password():
    newpassw = request.forms.get("newpassw")
    confnew  = request.forms.get("confnewpassw")
    trypassw = request.forms.get("curpassw")

    global err
    global conf
    conf=""

    if newpassw!=confnew:
        err="passwords_dont_match"
    
    elif trypassw!=curuser["password"]:
        err="incorrect_password"
    
    else:
        if loggedin:
                curuser["password"] = newpassw

        conn.execute(f'''UPDATE USERS 
                SET password="{curuser["password"]}"
                WHERE id="{curuser["userid"]}"''')
        conn.commit()

        conf="updated_password"
        err=""
    return redirect("../settings")


@route("/user/<accname>")
def account(accname):
    rawuser = conn.execute(f'''SELECT * FROM USERS WHERE username="{accname}"''').fetchone()
    if rawuser!=None:
        lookieuser = {
            "displayedname" : rawuser[4] if rawuser[4] != "" else rawuser[1],
            "username" : rawuser[1],
            "password" : rawuser[2],
            "email" : rawuser[3],
            "displayname" : rawuser[4],
            "bio" : rawuser[5],
            "joined on" : rawuser[6],
            "admin?" : bool(rawuser[7]),
            "planets" : [],
        }
        rawplanets = conn.execute(f'''SELECT siteside_id, name, image  FROM PLANETS
                                INNER JOIN USERS ON USERS.id=PLANETS.owner_id
                                INNER JOIN PLANET_IMAGES ON PLANET_IMAGES.p_code=PLANETS.siteside_id
                                WHERE PLANETS.owner_id="{rawuser[0]}"''').fetchall()
        lookieplanets=[]
        for i in range(len(rawplanets)):
                                #CODE               DISPLAYEDNAME                                                           IMAGE
            lookieplanets.append((rawplanets[i][0],(rawplanets[i][1] if rawplanets[i][1]!="" else f"({rawplanets[i][0]})"), rawplanets[i][2]))
        lookieuser["planets"]=lookieplanets
        return template("user",lookieuser=lookieuser,loggedin=loggedin,curuser=curuser)
    else:
        return redirect("../404")


@route("/planet/<planetcode>")
def planet(planetcode):
    rawplanet = conn.execute(f'''SELECT username, siteside_id, name, description, seed, image FROM PLANETS
                                INNER JOIN USERS ON USERS.id=PLANETS.owner_id
                                INNER JOIN PLANET_IMAGES ON PLANET_IMAGES.p_code=PLANETS.siteside_id
                                WHERE siteside_id="{planetcode}"''').fetchone()
    #TECHNICALLY it would be more interesting for me to load the planet based on the seed alone and not use the saved image - 
    #but the image is already saved to save "browse" from collapsing, so not using it wont really save any space
    #also it would be slow as hell
    if rawplanet!=None:
        lookieplanet= {
            "displayedname" : rawplanet[2] if rawplanet[2] != "" else f"({rawplanet[1]})",
            "owner" : rawplanet[0],
            "code" : rawplanet[1],
            "name" : rawplanet[2],
            "description" : rawplanet[3],
            "seed" : rawplanet[4],
            "image" : rawplanet[5]
        }
        return template("planet",lookieplanet=lookieplanet,loggedin=loggedin,curuser=curuser)
    else:
        redirect("../404")

@route("/planet/<planetcode>", method="POST")
def get_planet(planetcode):
    planname=request.forms.get("planname")
    plandesc=request.forms.get("plandesc")
    planseed=int(request.forms.get("planseed"))
    planimg=request.forms.get("planimg")
    planowner=curuser["username"]

    lookieplanet= {
            "displayedname" : planname if planname != "" else f"({planetcode})",
            "owner" : planowner,
            "code" : planetcode,
            "name" : planname,
            "description" : plandesc,
            "seed" : planseed,
            "image" : planimg
        }
    
    conn.execute(f'''INSERT INTO PLANETS (owner_id, siteside_id, name, description, seed) VALUES
                ({curuser["userid"]},"{lookieplanet["code"]}","{lookieplanet["name"]}",
                "{lookieplanet["description"]}",{lookieplanet["seed"]})''')
    conn.commit()
    conn.execute(f'''INSERT INTO PLANET_IMAGES (p_code, image) VALUES 
                 ("{lookieplanet["code"]}","{lookieplanet['image']}")''')
    #I made it so that PLANET_IMAGES identifies the given planet by its code rather than its id to save me the headache of having
    #to figure out a planet's id after making it (again, I cant just use max() cause deletion is a thing)
    conn.commit()

    return template("planet",lookieplanet=lookieplanet,loggedin=loggedin,curuser=curuser)

@route("/update/<planetcode>")
def plansettings(planetcode):
    rawplanet = conn.execute(f'''SELECT username, siteside_id, name, description FROM PLANETS
                                INNER JOIN USERS ON USERS.id=PLANETS.owner_id
                                WHERE siteside_id="{planetcode}"''').fetchone()
    if rawplanet!=None:
        lookieplanet= {
            "displayedname" : rawplanet[2] if rawplanet[2] != "" else f"({rawplanet[1]})",
            "owner" : rawplanet[0],
            "code" : rawplanet[1],
            "name" : rawplanet[2],
            "description" : rawplanet[3],
        }
        if loggedin and lookieplanet["owner"]==curuser["username"]:
            return template("plansettings",lookieplanet=lookieplanet,loggedin=loggedin,curuser=curuser)
        else:
            redirect(f"/planet/{planetcode}")
    else:
        redirect("../404")

@route("/update/<planetcode>", method="POST")
def change_plansettings(planetcode):
    name=request.forms.get("planname")
    description=request.forms.get("description")

    rawplanet = conn.execute(f'''SELECT username, siteside_id, name, description FROM PLANETS
                                    INNER JOIN USERS ON USERS.id=PLANETS.owner_id
                                    WHERE siteside_id="{planetcode}"''').fetchone()
    if rawplanet!=None:
        lookieplanet= {
            "displayedname" : rawplanet[2] if rawplanet[2] != "" else f"({rawplanet[1]})",
            "owner" : rawplanet[0],
            "code" : rawplanet[1],
            "name" : name,
            "description" : description,
        }

        conn.execute(f'''UPDATE PLANETS SET name="{lookieplanet["name"]}",description="{lookieplanet["description"]}"
                     WHERE siteside_id="{lookieplanet["code"]}"''')
        conn.commit()

        return template("plansettings",lookieplanet=lookieplanet,loggedin=loggedin,curuser=curuser)
    
@route("/delete/<planetcode>")
def deleteplanet(planetcode):
    rawplanet = conn.execute(f'''SELECT username, siteside_id, name FROM PLANETS
                                INNER JOIN USERS ON USERS.id=PLANETS.owner_id
                                WHERE siteside_id="{planetcode}"''').fetchone()
    if rawplanet!=None:
        lookieplanet= {
            "displayedname" : rawplanet[2] if rawplanet[2] != "" else f"({rawplanet[1]})",
            "owner" : rawplanet[0],
            "code" : rawplanet[1],
            "name" : rawplanet[2],
        }
        if loggedin and lookieplanet["owner"]==curuser["username"]:
            return template("plandelete",lookieplanet=lookieplanet,loggedin=loggedin,curuser=curuser)
        else:
            redirect(f"/planet/{planetcode}")
    else:
        redirect("../404")
    

@route("/delete/<planetcode>",method="POST")
def do_deleteplanet(planetcode):
    trypass = request.forms.get("password")
    if trypass==curuser["password"]:
        conn.execute(f'DELETE FROM PLANETS WHERE siteside_id="{planetcode}"')
        conn.commit()
        return redirect("/")
    else:
        return redirect("/planet/<planetcode>")

def plancodegen():
    rawcodes = conn.execute('SELECT siteside_id FROM PLANETS').fetchall()
    codes=[]
    for i in range(len(rawcodes)):
        codes.append(rawcodes[i][0])
    existingcode=True
    while(existingcode):
        gencode=""
        for i in range(0,4):
            #|ASCII CODES|
            # 0-9 -> 48-57 9
            # A-Z -> 65-90 25
            # a-z -> 97-122 25
            chartype=random.randint(1,5)
            if chartype==1:
                char = chr(random.randint(97,122))
            elif chartype==2:
                char = chr(random.randint(65,90))
            else:
                char = chr(random.randint(48,57))
            gencode+=char
        if gencode not in codes:
            existingcode=False
            return gencode

@error(404)
def error404(error):
    return template("404")


if __name__=="__main__":    
    run(reloader=True, debug=True, host="localhost",port=8080)

conn.close()
