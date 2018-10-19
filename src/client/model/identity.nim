#
import jsonflow, uuidjs
import jsffi, json
import karax / [errors, kdom, kajax, vstyles]

var console {. importc, nodecl .}: JsObject
var identity_def: JsonNode

var iden_flow* = createFlow("identity")

proc load_def() =
  const headers = [(cstring"Content-Type", cstring"application/json")]
  ajaxGet("/models/identity.json",
          headers,
          proc(stat:int, resp:cstring) =
            identity_def = parseJson($resp)
            #console.log(resp)
  )

  
proc getDefinition*(): JsonNode =
  load_def()
  result = identity_def

