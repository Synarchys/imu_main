
include karax / prelude 
import karax / prelude

import signup
import navigation

proc createDOM(data: RouterData): VNode =
  echo data.hashPart
  result = buildHtml(tdiv(class="container")):
    tdiv(class="row"):
      tdiv(class="col-sm"):
        a(href = ""):
          text "home / login"
      tdiv(class="col-sm"):
        a(href = "#/signup"):
          text "signup"
    case $(data.hashPart):
      of "":
        loginForm()
      of "#/signup":
        singUpForm()
      of "#/contents":
        Navigation()
    

setRenderer createDOM
