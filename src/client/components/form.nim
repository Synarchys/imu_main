#
include karax / prelude 
import karax / prelude

import sugar, jsffi, json, uuidjs

import ../model/identity

var console {. importc, nodecl .}: JsObject
var data = %*{"id": genUUID()}

             
proc field(def: JsonNode): VNode =
  let name = def.getOrDefault("name").getStr()
  let label = def.getOrDefault("label").getStr()
  let ftype = def.getOrDefault("type").getStr()
  let hint = def.getOrDefault("hint").getStr()
  let id = genUUID() & name
  let contents = data["fields"].getOrDefault(name).getStr()
  let value = kstring data["fields"].getOrDefault(name).getStr()
  proc change(ev: Event, n: VNode) =
    data["fields"][name]  = newJString($n.value)
  result = buildHtml(tdiv()):
    tdiv(class="form-group"):
      label(`for`=name): text(label)
      let iid = id & name
      let hid = id & hint
      input(`type`=ftype, class="form-control",id = iid, aria-describedby=hid, value=contents, onChange=change, value = value)
      small( id=hid, class="form-text text-muted"): text(hint)
      
var model: JsonNode

proc Form*():VNode =
  if model == nil:
    getDefinition(proc(r: JsonNode)=
        #echo "now in callback"
        #echo $r
        model = r
        data["name"] = model["name"]
        data["fields"] = newJObject()
        kxi.redraw()
    )
#  else:
#    console.log($model)
  proc click() =
    console.log("click: ", $data)
    kxi.redraw()
  result = buildHtml(tdiv()):
    text "Identity"
    if model != nil :
      h1: text model.getOrDefault("title").getStr()
      if model.contains("fields") and model["fields"].len > 0:
        for f in model["fields"].items:
          field(f)
      button(`type`="submit", class="align-self-center btn btn-primary", onClick=click): text "Save"
    
    


