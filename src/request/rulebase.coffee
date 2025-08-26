import Scout from "@dashkite/scout"
import Rulebase from "@dashkite/athena"

rulebase = Rulebase.make

  clone: ( state ) -> state.clone()
     
rulebase.conditions

  "has resource": -> @input.resource?

  "api ready": -> @api?

  "method ready": -> @output.method?

  "method not allowed": ->
    !( Scout.method [ @input.resource.name, @output.method ], @api )?

rulebase.actions

  "load api": ->
    @api ?= await Scout.discover @input.resource.origin

  "set url": ->
    target = Scout.encode @input.resource, @api
    @output.url = ( new URL target, @api.origin ).toString()

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