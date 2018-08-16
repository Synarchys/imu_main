
import jsffi, async, json, Tables


type
  Callback = proc(err, info: string)
  PouchDB* = JsObject 
    
  
proc newPouchDB(name: cstring, options: JsObject): JsObject {.importcpp: "new PouchDB(#)".}

#proc info(db:PouchDB, cb:Callback){.importcpp:"#.info(#)".}
#proc log()
# var console {. importc, nodecl .}: JsObject

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


proc createDB*(name: string, options: Table[string,string]): PouchDB =
  result = newPouchDB(cstring(name), toJs(options))

