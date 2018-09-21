
include karax / prelude 
import karax / [prelude, kdom]
import sugar, jsffi

import signup
import navigation

var console {. importc, nodecl .}: JsObject

proc createDOM(data: RouterData): VNode =
  # echo data.hashPart
  result = buildHtml(tdiv(class="container")):
    tdiv(class="py-5 text-center"):
      img(class="d-block mx-auto mb-4", src="https://getbootstrap.com/assets/brand/bootstrap-solid.svg", alt="", width="72", height="72")
      h2: text "Welcome to ImU"
      p(class="lead"): text "Please sign up and we will contact you as soon as possible."
      singUpForm()
    # tdiv(class="row"):
    #   tdiv(class="col-sm"):
    #     a(href = ""):
    #       text "home"
    #   tdiv(class="col-sm"):
    #     a(href = "#/login"):
    #       text "Signin"
    #   tdiv(class="col-sm"):
    #     a(href = "#/signup"):
    #       text "Signup"
    # case $(data.hashPart):
    #   of "":
    #     tdiv:
    #       text "this is home"
    #   of "#/login":
    #     loginForm()
    #   of "#/signup":
    #     singUpForm()
    #   of "#/contents":
    #     Navigation()
    

setRenderer createDOM
