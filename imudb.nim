# imu state management

#[

A NoSQL database to store json objects representing the state on fhe application.

createFlow(name: kstring, options: JsonNode): DataFlow

put(fow: DataFlow, id: kstring, doc: JsonNode, cb:proc(doc: JsonNode))
seek(fow: DataFlow, id: kstring, doc: JsonNode, cb:proc(doc: JsonNode))
evict(fow: DataFlow, id: kstring, cb:proc(doc: JsonNode))
halt(fow: DataFlow)
destroy(fow: DataFlow)
subscribe(fow: DataFlow, id: kstring="*", cb: proc(doc: JsonNode))

]#


import json

type
  DataFlow* = ref object
    id: string
    options: seq[string, string]
    documents: seq[string, JsonNode]
    subscribers: seq[string, proc(d: JsonNode)]

  DataRouter* = ref object

proc createFlow*(id: string, options: seq[string, string]): DataFlow =
  result = DataFlow(id = id, options = options)

