import Scout from "@dashkite/scout"
import { Accept } from "@dashkite/media-type"
import Athena from "@dashkite/athena"
import State from "@dashkite/sublime/state"

rules = Athena.make

  initialize: ( state ) -> State.make state

  clone: ( state ) -> state.clone()

  equal: ( a, b ) -> a.equal b

rules     

  .condition
    name: "has resource"
    run: -> @input.resource?

  .condition
    name: "has content"
    run: -> @input.content?

  .condition
    name: "has content-type"
    run: -> ( @input.headers?[ "content-type" ])?
  
  .condition
    name: "has accept"
    run: -> ( @input.headers?[ "accept" ])?

  .condition
    name: "content-type ready"
    run: -> ( @working.headers?.get "content-type" )?

  .condition
    name: "api ready"
    run: -> @_.api?

  .condition
    name: "method ready"
    run: -> @output.method?

  .condition
    name: "method not allowed"
    run: ->
      !( Scout.method [ @input.resource.name, @output.method ], @_.api )?

  .condition
    name: "has authorization specifier"
    run: -> @input.authorization?

  .condition
    name: "authorization specifier ready"
    run: -> @working.authorization?

  .condition
    name: "authorization header ready"
    run: -> ( @working.headers?.get "authorization" )?

  .condition
    name: "supported authorization specifier"
    when: [
      "has authorization specifier"
      "authorization specifier ready"
    ]
    run: do ({ schemes } = {}) ->
      schemes = ( specifiers ) ->
        new Set specifiers.map ( specifier ) -> 
          specifier.challenge.scheme
      ->
        specified = schemes @input.authorization
        supported = schemes @working.authorization
        ( supported.intersection specified ).size > 0

  .condition
    name: "supported authorization header"
    when: [
      "authorization specifier ready"
      "authorization header ready"
    ]
    run: ->
      authorization = @working.headers.get "authorization"
      @working
        .authorization
        .some ( specifier ) -> 
          specifier?.challenge?.scheme == authorization.scheme 

  .condition
    name: "unsupported content-type"
    when: [
      "method ready"
      "api ready"
      "content-type ready"
    ]

    run: ->
      types = Scout.types [ 
        @input.resource.name
        @output.method
        "request"
      ], @_.api
      ! Accept
        .make types
        .supported @working.headers.get "content-type"    

  .action
    name: "load api"
    when: [ "has resource", "!api ready" ]
    run: ->
      @_.api ?= await Scout.discover @input.resource.origin

  .action
    name: "set url"
    when: [ "has resource" ]
    run: ->
      target = Scout.encode @input.resource, @_.api
      @output.url = ( new URL target, @_.api.origin ).toString()

  .action
    name: "set content-type"
    when: [
      "has content"
      "!has content-type" 
      "method ready"
      "api ready"
    ]
    run: ->
      types = Scout.types [ 
        @input.resource.name
        @output.method
        "request"
      ], @_.api
      @working.headers.set "content-type", types[0]
      @output.headers = @working.headers.data

  .action
    name: "set accept"
    when: [
      "!has accept"
      "method ready"
      "api ready"
    ]
    run: ->
      try
        types = Scout.types [ 
          @input.resource.name
          @output.method
          "response"
        ], @_.api
        @working.headers.set "accept", Accept.make types
        @output.headers = @working.headers.data

  .action
    name: "set authorization specifiers"
    when: [ 
      "!authorization specifier ready"
      "method ready"
      "api ready" 
    ]    
    run: ->
      schemes = Scout.authorization [
        @input.resource.name
        @output.method
      ], @_.api
      if schemes?
        @working.authorization =
          schemes.map ( scheme ) -> challenge: { scheme }

  .action
    name: "throw method not allowed"
    when: [
      "api ready"
      "method ready"
      "method not allowed"
    ]
    run: -> @throw new Error "sublime: method not allowed"

  .action
    name: "throw missing authorization header"
    when: [
      "supported authorization specifier"
      "!authorization header ready"
    ]
    run: -> @throw new Error "sublime: missing authorization header"

  .action
    name: "throw unsupported authorization specifier"
    when: [ "!supported authorization specifier" ]
    run: -> @throw new Error "sublime: unsupported authorization specifier"

  .action
    name: "throw unsupported authorization header"
    when: [ "!supported authorization header" ]
    run: -> @throw new Error "sublime: unsupported authorization header"
    
  .action
    name: "throw unsupported content-type"
    when: [ "unsupported content-type" ]
    run: -> @throw new Error "sublime: unsupported content-type"

rules

export default rules