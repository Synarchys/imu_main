#
import jsonflow, uuidjs
import jsffi, json

import requestjs
 
var console {. importc, nodecl .}: JsObject
var identity_def: JsonNode

var iden_flow* = createFlow("identity")

proc load_def(cb: proc(r: JsonNode)) =
  const headers = [(cstring"Content-Type", cstring"application/json")]
  ajaxGet("/models/identity.json",
          headers,
          proc(stat:int, resp:cstring) =
            identity_def = parseJson($resp)
            cb(identity_def)
            console.log(resp)
  )

  
proc getDefinition*(cb: proc(r: JsonNode)) =
  load_def(cb)
  #cb(identity_def)

