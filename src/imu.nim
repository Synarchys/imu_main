
include karax / prelude 
import karax / prelude

import navigation

proc createDOM(data: RouterData): VNode =
  result = buildHtml(tdiv()):
    Navigation()
   


setRenderer createDOM
