import Scout from "@dashkite/scout"
import Athena from "@dashkite/athena"
import State from "@dashkite/sublime/state"

rulebase = Athena.make

  initialize: ( state ) -> State.make state

  clone: ( state ) -> state.clone()

  equal: ( a, b ) -> a.equal b
     
rulebase.conditions

  "has resource": -> @input.resource?

  "has content": -> @input.content?

  "has content-type": -> ( @working.headers?.get "content-type" )?

  "api ready": -> @_.api?

  "method ready": -> @output.method?

  "unsupported content-type": ->
    types = Scout.types [ 
      @input.resource.name
      @output.method
      "request" 
    ], @_.api
    ( @working.headers.get "content-type" ) in types

rulebase.actions

  "set content-type": ->
    types = Scout.types [ 
      @input.resource.name
      @output.method
      "request" 
    ], @_.api
    @working.headers.set "content-type", types[0]
    @output.headers = @working.headers.data

  "throw unsupported content-type": ->
    @throw new Error "sublime: unsupported content-type"

rulebase.rules

  "set content-type": [
    "has content"
    "method ready"
    "api ready"
    "!has content-type" 
  ]

  "unsupported content-type": [
    "method ready"
    "api ready"
    "has content-type"
  ]

  "throw unsupported content-type": [
    "unsupported content-type"
  ]

export default rulebase