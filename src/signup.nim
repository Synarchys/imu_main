
import json, sequtils
import dom except Event
include karax / prelude

import  karax / [errors, kdom, kajax, vstyles]
import karax / [vdom, karax, karaxdsl, jstrutils, compact, localstorage]

from sugar import `=>`


const
  username = kstring"username"
  password = kstring"password"
  verify = kstring"password"
  HOST = "http://local.imu.ai:24042/couchdb"
  
var loggedIn: bool

# curl -vX PUT $HOST/mydatabase \
#      --cookie AuthSession=YW5uYTo0QUIzOTdFQjrC4ipN-D-53hw1sJepVzcVxnriEw \
#      -H "X-CouchDB-WWW-Authenticate: Cookie" \
#      -H "Content-Type:application/x-www-form-urlencoded"
  
proc loginField(desc, field, class: kstring;
                validator: proc (field: kstring): proc ()): VNode =
  var inputType = ""
  if field == "password" or field == "verify":
    inputType = "password"
  else:
    inputType = "text"
  
  result = buildHtml(tdiv(class="input-group mb-3")):
    tdiv(class="input-group-prepend"):
      span(class="input-group-text", id="lbl_"&field):
        text desc
    input(`type`=inputType,
          id=field,
          class="form-control",
          placeholder=field,
          aria-label=field,
          aria-describedby="basic-addon1",
          onchange=validator(field))
        
proc validateNotEmpty(field: kstring): proc () =
  result = proc () =
    let x = getVNodeById(field)
    if x.text == "":
      errors.setError(field, field & " must not be empty")
    else:
      errors.setError(field, "")
      
proc singUp(ev: Event, n: VNode) =
  ev.preventDefault()
  let
    username = $getVNodeById("username").value()
    password = getVNodeById("password")
    verify = getVNodeById("verify")
    url = HOST & "/_users/org.couchdb.user:" & username

  # TODO: validate password == verify
  let u = %*{"name": username,
              "password": $password.value(),
              "roles": [], "type": "user"}
  
  let body = cstring($u)
  ajaxPut(url ,@[],  cstring($u),
          proc(stat:int, resp:cstring) =
            let r = parseJson($resp)
            if stat == 201:
              # success
              # {"ok":true,"id":"org.couchdb.user:demian","rev":"7-8ca091452eba898db2d06a7f3d09252a"}
              echo "user created!!"
            else:
              # show Error
              # {"error":"conflict","reason":"Document update conflict."}
              echo "error :("
            echo(resp)
  )

proc singUpForm*(): VNode =
  result = buildHtml(tdiv):
    form(id="signup-form"):
      loginField("Name :", username, "input", validateNotEmpty)
      loginField("Password: ", password, "password", validateNotEmpty)
      loginField("Verify: ", password, "verify", validateNotEmpty)    
      button(onclick = singUp, class="btn btn-dark"):
        text "Submit"

type
  LoginForm = ref object of VComponent
    
var
  alertClass = "alert alert-success fade"
  alertText = ""

proc loginAction(x: VComponent) =
  let self = x     
  let
    user = $getVNodeById("username").value()
    pass = $getVNodeById("password").value()
    url = HOST & "/_session"
    data = "name=" & user & "&password=" & pass

  # curl -vX POST $HOST/_session \
  # -H 'Content-Type:application/x-www-form-urlencoded' \
  # -d 'name=anna&password=secret'    
  ajaxPost(url, [(cstring"Content-Type", cstring"application/x-www-form-urlencoded")],
           data=data,
           proc(stat:int, resp:cstring) =
             # TODO: add timer to hide alert message
             let r = parseJson($resp)
             if stat == 401:
               errors.setError("login", r["reason"].getStr)
               alertClass = "alert alert-danger show"
               alertText = r["error"].getStr & " - " & r["reason"].getStr
             else:
               alertClass = "alert alert-success show"
               echo $resp
               alertText = "Success!"
               
             markDirty(self)
             redraw()
  )
  
proc render(x: VComponent): VNode =  
  result = buildHtml(tdiv(class="input-group mb-3")):
    tdiv(class=alertClass, role="alert"):
      text alertText
    loginField("Name :", username, "input-group-text", validateNotEmpty)
    loginField("Password: ", password, "input-group-text", validateNotEmpty)
    button(class="btn btn-dark",
           onclick = () => loginAction(x)):
        text "Login"

proc loginForm*(): VNode =
  result = buildHtml():
    newComponent(LoginForm, render)
