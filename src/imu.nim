
import vdom, karax, karaxdsl, kajax 

import sugar, json

proc navigation(): VNode =
  result = buildHtml(nav(class="navbar navbar-expand-lg navbar-light bg-light")):
    text "nav bar"
    
proc content(): VNode =
  result = buildHtml(tdiv(class="card")):
    tdiv(class="card-body"):
      h3(class="card-title"): text "card title"
      h6(class="card-subtitle mb2 text-muted"): text "Subtitle"
      
proc MainContainer(): VNode =
  result = buildHtml(tdiv()):
    navigation()
    for i in 1..20:
      content()


proc createDOM(data: RouterData): VNode =
  result = buildHtml(tdiv()):
    MainContainer()


setRenderer createDOM
