
include karax / prelude 
import karax / [prelude, kdom]
import sugar, jsffi

import signup
import navigation
import pouch 


import user_info

var console {. importc, nodecl .}: JsObject

proc home(): VNode =
  result = buildHtml(tdiv):
    text "You are at home"
    userinfo()


proc createDOM(data: RouterData): VNode =
  # echo data.hashPart
  result = buildHtml(tdiv(class="container")):
    #tdiv(class="py-5 text-center"):
      #img(class="d-block mx-auto mb-4", src="https://getbootstrap.com/assets/brand/bootstrap-solid.svg", alt="", width="72", height="72")
      #h2: text "Welcome to ImU"
    tdiv(class="row"):
      tdiv(class="col-sm"):
        a(href = "#/"):
          text "home"
      tdiv(class="col-sm"):
        a(href = "#/login"):
          text "Signin"
      tdiv(class="col-sm"):
        a(href = "#/signup"):
          text "Signup"
      tdiv(class="col-sm"):
        a(href = "#/userinfo"):
          text "User Info"
    case $(data.hashPart):
      of "":
        home()
      of "#/":
        home()
      of "#/login":
        loginForm()
      of "#/signup":
        p(class="lead"): text "Please sign up and we will contact you as soon as possible."
        singUpForm()
      of "#/contents":
        Navigation()
      of "#/userinfo":
        userinfo()
    

setRenderer createDOM
