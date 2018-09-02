
import strutils, json, sequtils
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
  loginUrl = HOST & "/_session"
  signUrl = HOST & "/_users/org.couchdb.user:"

# Style Consts
const
  btnClass = "btn btn-dark"
  alertDangerClass = "alert alert-danger"
  alertDangerShowClass = alertDangerClass & " show"
  alertDangerFadeClass = alertDangerClass & " fade"
  alertSuccess = "alert alert-success show"
  alertSuccessShow = alertSuccess & " show"
  alertSuccessFade = alertSuccess & " fade"
  
type
  AppState = ref object
    statusCode*: int # default code, 
    response*: JsonNode
      
var
  appState = AppState(statusCode: 0) 
  alertClass = "alert alert-success fade"
  alertText = ""

# curl -vX PUT $HOST/mydatabase \
#      --cookie AuthSession=YW5uYTo0QUIzOTdFQjrC4ipN-D-53hw1sJepVzcVxnriEw \
#      -H "X-CouchDB-WWW-Authenticate: Cookie" \
#      -H "Content-Type:application/x-www-form-urlencoded"
  
# Create database: curl -X PUT $HOST/{dbname}

# Create admin user
# curl -X PUT $HOST/_node/$NODENAME/_config/admins/anna -d '"secret"'
proc loginField(desc, field, class: kstring; validator: proc (field: kstring): proc (),
               onkeyup:proc(ev: Event, n: VNode)=nil): VNode =
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
          onchange=validator(field),
          onkeyup=onkeyup)
        
proc validateNotEmpty(field: kstring): proc () =
  result = proc () =
    let x = getVNodeById(field)
    if x.text == "":
      errors.setError(field, field & " must not be empty")
    else:
      errors.setError(field, "")
      
proc singUpAction(ev: Event, n: VNode) =
  ev.preventDefault()
  let
    username = $getVNodeById("username").value()
    password = getVNodeById("password")
    verify = getVNodeById("verify")    
  # TODO: validate password == verify
  let u = %*{"name": username,
              "password": $password.value(),
              "roles": [], "type": "user"}  
  let
    url = signUrl & username
    body = cstring($u)
  ajaxPut(url ,@[],  cstring($u),
          proc(stat:int, resp:cstring) =
            appState.statusCode = stat
            appState.response = parseJson($resp)
            let r = parseJson($resp)
  )

# curl -vX POST $HOST/_session \
# -H 'Content-Type:application/x-www-form-urlencoded' \
# -d 'name=anna&password=secret'
proc loginAction() =
  let
    user = $getVNodeById("username").value()
    pass = $getVNodeById("password").value()
    data = "name=" & user & "&password=" & pass  
  ajaxPost(loginUrl, [(cstring"Content-Type", cstring"application/x-www-form-urlencoded")],
           data=data,
           proc(stat:int, resp:cstring) =
             appState.statusCode = stat
             appState.response = parseJson($resp))

proc Alert: VNode =
  # TODO: add timer to hide alert message
  if appState.statusCode == 401:
    let r = appState.response
    errors.setError("login", r["reason"].getStr)  
    alertText = r["error"].getStr & " - " & r["reason"].getStr
    alertClass = alertDangerShowClass
  elif appState.statusCode == 200:
    alertClass = alertSuccessShow
    alertText = "Logged in."
  result = buildHtml():
    tdiv(class=alertClass, role="alert"):
      text alertText

proc singUpForm*(): VNode =
  result = buildHtml(tdiv):
    Alert()
    form(id="signup-form"):
      loginField("Name :", username, "input", validateNotEmpty)
      loginField("Password: ", password, "password", validateNotEmpty)
      loginField("Verify: ", password, "verify", validateNotEmpty)    
      button(class=btnClass, onclick = singUpAction):
        text "Submit"
      
proc loginForm*(): VNode =
  result = buildHtml(tdiv(class="input-group mb-3")):
    Alert()
    loginField("Name :", username, "input-group-text", validateNotEmpty)
    loginField("Password: ", password, "input-group-text",
               validateNotEmpty,
               proc(ev: Event, n: VNode) =
                 if cast[KeyboardEvent](ev).keyCode == 13:
                   loginAction())
    button(class="btn btn-dark", onclick = loginAction):
        text "Login"

