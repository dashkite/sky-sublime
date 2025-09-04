import Scout from "@dashkite/scout"
import { Accept } from "@dashkite/media-type"
import Athena from "@dashkite/athena"
import State from "@dashkite/sublime/state"

rulebase = Athena.make

  initialize: ( state ) -> State.make state

  clone: ( state ) -> state.clone()

  equal: ( a, b ) -> a.equal b
          
rulebase.conditions

  "request ready": -> @output.request?

  "has content": -> @input.content?

  "has content-type": -> ( @input.headers?[ "content-type" ])?

  "has resource": -> @input.request?.resource?

  "has method": -> @output.request?.method?
  
  "api ready": -> @_.api?

rulebase.actions

  "load api": ->
    @_.api ?= await Scout.discover @input.request.resource.origin

  "set content-type": ->
    types = Scout.types [ 
      @input.request.resource.name
      @output.request.method
      "response"
    ], @_.api
    @working.headers.set "content-type", types[0]
    @output.headers = @working.headers.data

rulebase.rules

  "has resource": [ "request ready" ]

  "load api": [ "has resource", "!api ready" ]

  "has method": [ "request ready" ]

  "set content-type": [
    "has content"
    "!has content-type" 
    "has method"
    "api ready"
  ]

export default rulebase


