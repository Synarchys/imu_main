# user information related components

include karax / prelude 
import karax / [prelude, kdom]
import sugar, jsffi, json, asyncjs 
import pouch


var options = newJsObject()
options.name = kstring"userinfo"
var infodb = newPouchDB(options)

console.log(infodb)

var a: JsObject 

var ch = infodb.changes()
ch.`on`("change",
        proc(d: JsObject) =
          console.log("Changes: ", d)
)

var selected  = JsObject()
selected["name"] = kstring"firstload"


proc userform(u: JsObject): VNode =
  console.log("u in render: ", u)
  var name = u["name"].to(cstring)
  proc validateName(ev: Event, n: VNode) =
    console.log("Validate: ",  ev, n)
    name = cstring n.text
    console.log("name after validation: ", name)
    
  proc addName(ev: Event, n: VNode) =
    #console.log("addName: ", ev, n)
    console.log("Name in addName: ", name)
    var selected = newJsObject()
    infodb.get("selected",
      proc(err, resp: JsObject) =
        console.log("Doc: ",resp, " Error: ", err)
        if err == nil:
          selected.name = name 
          selected["_id"] = kstring"selected"
          selected["_rev"] = resp["_rev"]
          infodb.put(selected,
            proc(err, resp: JsObject) =
              console.log("Resp: ",resp, " Error: ", err)
          )
        )
  console.log("Name in render: ", name)
  result = buildHtml(tdiv(class="md-2")):
    form(class="form-label-group"):
      tdiv(class="row"):
        tdiv(class="col-md-6 mb-3"):
          input(
            `type`= "text", id="input1",
            class="form-control", placeholder="a name",
            aria-label="a label", aria-describedby="basic-addon1",
            value = name, onkeyup=validateName
          )
          
      button(class="btn btn-dark", onClick=addName):
        text "Add"


        
proc userinfo*(): Vnode =
  infodb.get("selected",
    proc(err, resp:JsObject) =
      if resp != nil:
        selected = resp
        console.log("got selected: ", selected)
      if err != nil:
        selected["name"] = "noname"
        console.log("err in get main: ", err)
  )
  
  result = buildHtml(tdiv()):
    h2: text "User Information"
    tdiv:
      userform(selected)



#proc catch(){.importcpp, noDecl.}

# proc put(db, doc: JsObject):Future[JsObject]{.importcpp:"#.put(#)", async.}

# proc putS(s:JsObject){.async.}=
#   try:  
#     var response = await put(infodb, s)
#     console.log("response: ", response)
#   except:
#     console.log("error:", getCurrentException())

# var a = putS(selected)
# console.log("a:", a)
    
# proc fetchDoc(d: JsObject, id: string): Future[JsObject] {.async.} =
#   var r: Future[JsObject] 
#   proc fetch(err, resp: JsObject) {.async.}=
#     if err != nil:
#       console.log("Could not get document, ", err)
#     console.log(resp)
#     r = resp  
#   infodb.get(cstring(id), fetch)
#   r 

# proc storeDoc(db, doc: JsObject): JsObject =
#   var r: JsObject
#   if doc["_id"] != nil: 
#     r = db.fetchDoc(doc["_id"].to(string))
#     if r != nil:
#       console.log("found doc:", r)
#       doc["_rev"] = r["_rev"]
#   proc store(err, resp: JsObject) =
#     if err != nil:
#       console.log("Could not put document, ", err)
#     console.log(resp)
#   infodb.put(doc, store)





#selected = infodb.fetchDoc("selected")


#====        
# var myDB {.exportc.} = createDB("myDB")
# myDB.info().then((r: JsObject ) => console.log("DB_Info:", r))

# proc getInfo(err, resp: JsObject) =
#   console.log("get error: ", err)
#   console.log("get resp: ", resp)
  
# myDB.get("info", getInfo)


# proc putInfo(err, resp: JsObject) =
#   console.log("put error: ", err)
#   console.log("put resp: ", resp)
  
# var data = newJsObject()
# data["_id"] = cstring"info"
# data["title"] = cstring"Heroes"
# console.log("Data: ", data)
# myDB.put(data, putInfo)

# var op =  PouchOptions()
# op.name = "dbname"
# op.username = "username"
# op.password = "password"

# var opjs = toJs(op)

# console.log("opt to js" , opjs)
# var otherdb = newPouchDB("something", opjs)
# console.log("otherdb: ", otherdb)

  

# proc d(err, resp: JsObject) =
#     console.log("destroy: ", err, resp)
#     if err != nil:
#       console.log("err:", err)
#     if resp != nil:
#       console.log("resp:", resp)

            
            
# otherdb.destroy(d)
  
