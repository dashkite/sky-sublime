import Scout from "@dashkite/scout"
import { Accept } from "@dashkite/media-type"
import Athena from "@dashkite/athena"
import State from "@dashkite/sublime/state"

# TODO check for expected response status

rules = Athena.make

  initialize: ( state ) -> State.make state

  clone: ( state ) -> state.clone()

  equal: ( a, b ) -> a.equal b
          
rules

  .condition
    name: "request ready"
    run: -> @output.request?

  .condition
    name: "has content"
    run: -> @input.content?

  .condition
    name: "has content-type"
    run: -> ( @input.headers?[ "content-type" ])?

  .condition
    name: "has resource"
    when: [ "request ready" ]
    run: -> @input.request?.resource?

  .condition
    name: "has method"
    when: [ "request ready" ]
    run: -> @output.request?.method?
  
  .condition
    name: "api ready"
    run: -> @_.api?

  .action
    name: "load api"
    when: [ "has resource", "!api ready" ]
    run: -> @_.api ?= await Scout.discover @input.request.resource.origin

  .action
    name: "set content-type"
    when: [
      "has content"
      "!has content-type"
      "has method"
      "api ready"
    ]
    run: ->
      types = Scout.types [ 
        @input.request.resource.name
        @output.request.method
        "response"
      ], @_.api
      @working.headers.set "content-type", types[0]
      @output.headers = @working.headers.data

export default rules


