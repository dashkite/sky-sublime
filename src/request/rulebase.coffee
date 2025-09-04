import Scout from "@dashkite/scout"
import { Accept } from "@dashkite/media-type"
import Athena from "@dashkite/athena"
import State from "@dashkite/sublime/state"

rulebase = Athena.make

  initialize: ( state ) -> State.make state

  clone: ( state ) -> state.clone()

  equal: ( a, b ) -> a.equal b
     
rulebase.conditions

  "has resource": -> @input.resource?

  "has content": -> @input.content?

  "has content-type": -> ( @input.headers?[ "content-type" ])?
  
  "has accept": -> ( @input.headers?[ "accept" ])?

  "content-type ready": -> ( @working.headers?.get "content-type" )?

  "api ready": -> @_.api?

  "method ready": -> @output.method?

  "method not allowed": ->
    !( Scout.method [ @input.resource.name, @output.method ], @_.api )?

  "unsupported content-type": ->
    types = Scout.types [ 
      @input.resource.name
      @output.method
      "request"
    ], @_.api
    ! Accept
       .make types
       .supported @working.headers.get "content-type"

rulebase.actions

  "load api": ->
    @_.api ?= await Scout.discover @input.resource.origin

  "set url": ->
    target = Scout.encode @input.resource, @_.api
    @output.url = ( new URL target, @_.api.origin ).toString()

  "throw method not allowed": ->
    @throw new Error "sublime: method not allowed"

  "set content-type": ->
    types = Scout.types [ 
      @input.resource.name
      @output.method
      "request"
    ], @_.api
    @working.headers.set "content-type", types[0]
    @output.headers = @working.headers.data

  "set accept": ->
    try
      types = Scout.types [ 
        @input.resource.name
        @output.method
        "response"
      ], @_.api
      @working.headers.set "accept", Accept.make types
      @output.headers = @working.headers.data

  "throw unsupported content-type": ->
    @throw new Error "sublime: unsupported content-type"

rulebase.rules

  "load api": [ "has resource", "!api ready" ]

  "set url": [ "has resource" ]

  "throw method not allowed": [
    "api ready"
    "method ready"
    "method not allowed"
  ]

  "set content-type": [
    "has content"
    "!has content-type" 
    "method ready"
    "api ready"
  ]

  "set accept": [
    "!has accept"
    "method ready"
    "api ready"
  ]

  "unsupported content-type": [
    "method ready"
    "api ready"
    "content-type ready"
  ]

  "throw unsupported content-type": [
    "unsupported content-type"
  ]

export default rulebase