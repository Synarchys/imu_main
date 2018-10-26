#
import jsonflow, uuidjs
import jsffi, json

import requestjs
export jsonflow 
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
            echo "about to send"
            iden_flow.send(%*{"id": "asd","model_definition": identity_def})
            #console.log(resp)
  )

  
proc getDefinition*(cb: proc(r: JsonNode)) =
  load_def(cb)

proc callApi(r:JsonNode) =
  echo "something has changed, replicate data. \n=========="
  echo $r
  echo "=============="

discard iden_flow.subscribe(callApi)
