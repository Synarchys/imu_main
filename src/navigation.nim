include karax / prelude 
import karax / prelude


import json, strutils, macros, jsffi, async, tables

from sugar import `=>`, `->`

import db


var console {. importc, nodecl .}: JsObject

var myDB {.exportc.} = createDB("myDB")
myDB.info().then((r: JsObject ) => console.log("DB_Info:", r))

# myDB.destroyDB()
# console.log(resp)

proc navigation(): VNode =
  result = buildHtml(nav(class="navbar navbar-expand-lg navbar-light bg-light")):
    text "nav bar"
    
proc content(): VNode =
  result = buildHtml(tdiv(class="card")):
    tdiv(class="card-body"):
      h3(class="card-title"): text "card title"
      h6(class="card-subtitle mb2 text-muted"): text "Subtitle"
      
proc Navigation*(): VNode =
  result = buildHtml(tdiv()):
    navigation()
    for i in 1..20:
      content()

