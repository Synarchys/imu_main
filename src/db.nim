
import jsffi, async, json, Tables, sugar


type
  Callback = proc(err, info: string)
  PouchDB* = JsObject 
  PouchOptions* = object
    name*: string
    auto_compaction*: bool
    adapter*: string
    revs_limit*: int
    deterministic_revs*: string
    username*: string
    password*: string
    skip_setup*: bool
  PouchCB* = proc(err, resp: JsObject)
  
var console {. importc, nodecl .}: JsObject

proc optTojs(o: PouchOptions): JsObject =
  result = newJsObject()
  result.skip_setup = o.skip_setup
  result.auto_compaction = o.auto_compaction
  if o.revs_limit == 0:
    result.revs_limit = 1000
  if o.name != "":
    result.name = cstring(o.name)
  if o.adapter != "":
    result.adapter = cstring(o.adapter)
  if o.deterministic_revs != "":
    result.deterministic_revs = cstring(o.deterministic_revs)
  if o.username != "":
    result.auth.username = cstring(o.username)
  if o.password != "":
    result.auth.password = cstring(o.password)

  
proc newPouchDB(name: cstring, options: JsObject): JsObject {.importcpp: "new PouchDB(#, #)".}
proc newPouchDB(name: cstring): JsObject {.importcpp: "new PouchDB(#)".}

proc createDB*(name: string, options: PouchOptions): PouchDB =
  result = newPouchDB(cstring(name), optToJs(options))

proc createDB*(name: string): PouchDB =
  result = newPouchDB(cstring(name))

proc destroyDB*(db: PouchDB) =
  echo "Entering destroyDB"
  let resp = db.destroy() #.then()
  resp.then(proc(r:JsObject) = console.log(r)) 
  console.log(resp)
  
