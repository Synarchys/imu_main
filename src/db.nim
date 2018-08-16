
import jsffi, async, json, Tables


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
    
proc optTojs(o: PouchOptions): JsObject =
  result = newJsObject()
  result.skip_setup = o.skip_setup
  result.auto_compaction = o.auto_compaction
  if o.revs_limit == 0:
    result.revs_limit = 1000
  if o.name != nil:
    result.name = cstring(o.name)
  if o.adapter != nil:
    result.adapter = cstring(o.adapter)
  if o.deterministic_revs != nil:
    result.deterministic_revs = cstring(o.deterministic_revs)
  if o.username != nil:
    result.auth.username = cstring(o.username)
  if o.password != nil:
    result.auth.password = cstring(o.password)

  
proc newPouchDB(name: cstring, options: JsObject): JsObject {.importcpp: "new PouchDB(#, #)".}
proc newPouchDB(name: cstring): JsObject {.importcpp: "new PouchDB(#)".}

#proc info(db:PouchDB, cb:Callback){.importcpp:"#.info(#)".}
#proc log()
#var console {. importc, nodecl .}: JsObject

# #proc info*(db: JsObject): Future[JsObject] {.async, importcpp:"#.info()".}

# console.log("starting IMU")

# let db {.exportc.} = newPouchDB(cstring"myDB") 
# #echo "DB: " & db
# console.log("DB: ", db)

# db.info().then(proc(r: JsObject ) = console.log("DB_Info:", r))

# # db.info(proc(err, info: string) =
# #           if err != nil :
# #             console.log("Error: ", err)
# #           if info != nil :
# #             console.log("INFO: ", info))


proc createDB*(name: string, options: PouchOptions): PouchDB =
  result = newPouchDB(cstring(name), optToJs(options))

proc createDB*(name: string): PouchDB =
  result = newPouchDB(cstring(name))
