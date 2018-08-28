
include karax / prelude 
import karax / prelude

import signup
#import navigation

proc createDOM(data: RouterData): VNode =
  result = buildHtml(tdiv(class="container")):
    tdiv(class="row"):
      tdiv(class="col-sm"):
        a(href = ""):
          text "home / login"
      tdiv(class="col-sm"):
        a(href = "#/signup"):
          text "signup"
      
    if data.hashPart == "":
      loginForm()
    elif data.hashPart == "#/signup":
      singUpForm()
    #   Navigation()
    

setRenderer createDOM
