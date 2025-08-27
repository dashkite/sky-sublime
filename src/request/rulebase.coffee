import Scout from "@dashkite/scout"
import Athena from "@dashkite/athena"
import State from "@dashkite/sublime/state"

rulebase = Athena.make

  initialize: ( state ) -> State.make state

  clone: ( state ) -> state.clone()

  equal: ( a, b ) -> a.equal b
     
rulebase.conditions

  "has resource": -> @input.resource?

  "api ready": -> @_.api?

  "method ready": -> @output.method?

  "method not allowed": ->
    !( Scout.method [ @input.resource.name, @output.method ], @_.api )?

rulebase.actions

  "load api": ->
    @_.api ?= await Scout.discover @input.resource.origin

  "set url": ->
    target = Scout.encode @input.resource, @_.api
    @output.url = ( new URL target, @_.api.origin ).toString()

  "throw method not allowed": ->
    @throw new Error "sublime: method not allowed"

rulebase.rules

  "load api": [ "has resource", "!api ready" ]

  "set url": [ "has resource" ]

  "throw method not allowed": [
    "api ready"
    "method ready"
    "method not allowed"
  ]

export default rulebase