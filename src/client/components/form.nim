#
include karax / prelude 
import karax / prelude
import karax / [errors, kdom, kajax, vstyles]

import sugar, jsffi, json, uuidjs

import ../model/identity

var console {. importc, nodecl .}: JsObject

proc field(def: JsonNode): VNode =
  let name = def.getOrDefault("name").getStr()
  let label = def.getOrDefault("label").getStr()
  let ftype = def.getOrDefault("type").getStr()
  let hint = def.getOrDefault("hint").getStr()
  let id = genUUID() & name
  result = buildHtml(tdiv()):
    tdiv(class="form-group"):
      label(`for`=name): text(label)
      let iid = id & name
      let hid = id & hint
      input(`type`=ftype, class="form-control",id = iid, aria-describedby=hid)
      small( id=hid, class="form-text text-muted"): text(hint)
      
var model: JsonNode = getDefinition()

proc Form*():VNode =
  if model == nil:
    model = getDefinition()
#  else:
#    console.log($model)

  result = buildHtml(tdiv()):
    text "Identity"
    if model != nil :
      h1: text model.getOrDefault("title").getStr()
      if model.contains("fields") and model["fields"].len > 0:
        for f in model["fields"].items:
          field(f)
      button(`type`="submit", class="align-self-center btn btn-primary"): text "Save"
    
    


