
include karax / prelude 
import karax / [prelude, kdom]
import sugar, jsffi

#import navigation
import ./components / form

proc createDOM(data: RouterData): VNode =
  #echo data.hashPart
  result = buildHtml(tdiv(class="container")):
    h1: text "ImU"
    Form()
    

setRenderer createDOM
