
import strutils, json, sequtils, jsffi
import dom except Event
include karax / prelude

import  karax / [errors, kdom, kajax, vstyles]
import karax / [vdom, karax, karaxdsl, jstrutils, compact, localstorage]

from sugar import `=>`
var console {. importc, nodecl .}: JsObject

const
  HOST = "http://local.imu.ai:13000/couchdb"
  loginUrl = HOST & "/_session"
  signUrl = HOST & "/_users/ai.imu.user:"
  inviteUrl = HOST & "/invites/ai.imu.invite:"

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
    firstname*: kstring
    lastname*: kstring
    email*: kstring
    username*: kstring
    password*: kstring
    verify*: kstring
    statusCode*: int # default code, 
    response*: JsonNode
      
var
  appState = AppState(statusCode: 0, firstname: "", lastname: "", email:"", username: "", password:"")
  alertClass = "alert alert-success fade"
  alertText = ""

proc loginField(desc, id, field, class: kstring; validator: proc (field: kstring): proc (),
               onkeyup:proc(ev: Event, n: VNode)=nil): VNode =
  var inputType = ""
  if id == "password" or id == "verify":
    inputType = "password"
  else:
    inputType = "text"
  
  var inputText = buildHtml():
    input(`type`=inputType,
          id=id,
          class="form-control",
          placeholder=field,
          aria-label=field,
          aria-describedby="basic-addon1",
          onchange=validator(id))

  if onkeyup != nil:
    inputText.addEventHandler(EventKind.onkeyup, onkeyup)

  let id = "lbl_" & $field
  
  result = buildHtml(tdiv(class="input-group mb-3")):
    tdiv(class="input-group-prepend"):
      span(class="input-group-text", id=id):
        text desc
    inputText
        
proc validateNotEmpty(field: kstring): proc () =
  result = proc () =
    let x = getVNodeById(field)
    if x.text == "":
      errors.setError(field, $field & " must not be empty")
    else:
      errors.setError(field, "")
  
proc singUpAction(ev: Event, n: VNode) =
  let u = %*{ "firstname": $appState.firstname,
              "lastname": $appState.lastname,
              "email": $appState.email,
              "name": $appState.email,
              "roles": [], "type": "user"}
  let
    url = inviteUrl & $appState.email
    body = cstring($u)
  ajaxPut(url ,@[],  cstring($u),
          proc(stat:int, resp:cstring) =
            appState.statusCode = stat
            appState.response = parseJson($resp)
            if stat < 400:
              appState.firstname = ""
              appState.lastname = ""
              appState.email = "")

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
  if appState.statusCode >= 400:
    let r = appState.response
    errors.setError("login", r["reason"].getStr)  
    alertText = r["error"].getStr & " - " & r["reason"].getStr
    alertClass = alertDangerShowClass
  elif appState.statusCode == 200 or appState.statusCode == 201:
    alertClass = alertSuccessShow
    alertText = "Logged in."
  result = buildHtml():
    tdiv(class=alertClass, role="alert"):
      text alertText

proc singUpForm*(): VNode =
  result = buildHtml(tdiv(class="md-2")):
    Alert()
    form(class="form-label-group"):
      tdiv(class="row"):
        tdiv(class="col-md-6 mb-3"):
          loginField("First Name :", "firstName", appState.firstname, "form-control", validateNotEmpty,
                     onkeyup = proc(ev: Event, n: VNode) =
                       appState.firstname = n.value)
        tdiv(class="col-md-6 mb-3"):
          loginField("Last Name :", "lastname", appState.lastname, "form-control", validateNotEmpty,
                     onkeyup = proc(ev: Event, n: VNode) =
                       appState.lastname = n.value)
      tdiv(class="mb-3"):
        loginField("Email :", "email", appState.email, "form-control", validateNotEmpty,
                   onkeyup = proc(ev: Event, n: VNode) =
                     appState.email = n.value)
          
      button(class=btnClass, onclick = singUpAction):
        text "Submit"
      
proc loginForm*(): VNode =
  result = buildHtml(tdiv(class="input-group mb-3")):
    Alert()
    loginField("Name :", "username", appState.username, "input-group-text", validateNotEmpty)
    loginField("Password: ", "password",appState.password, "input-group-text",
               validateNotEmpty,
               proc(ev: Event, n: VNode) =
                 if cast[KeyboardEvent](ev).keyCode == 13:
                   loginAction())
    button(class="btn btn-dark", onclick = loginAction):
        text "Login"
