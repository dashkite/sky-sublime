import assert from "@dashkite/assert"
import {test, success} from "@dashkite/amen"
import print from "@dashkite/amen-console"
import Runner from "@dashkite/runner"
import express from "express"

import Sierra from "@dashkite/sierra"
import Registry from "@dashkite/registry"

import * as Sky from "../src"
import Locator from "../src/locator"

import scenarios from "./scenarios"

import api from "./api"

# set up simple local server to return an API description
server = ->
  new Promise ( resolve, reject ) ->
    try
      express()
        .get "/", ( _, response ) -> response.send api
        .listen 3000, resolve
    catch error
      reject error

do ->

  await server()

  print await test "Sky Sublime", 

    await do ->

      authorizers = Sierra.make()
      authorizers.add "foo", 
        matches: -> true
        get: -> 
          scheme: "foo"
          token: "123"
      await Registry.set "authorizers", authorizers

      Runner

        .make scenarios

        .apply

          "Sky Locator": 
            "*": ({ input }) ->
              Locator.decode input
              
          "Sky Request":
            "*": ({ input }) ->
              Sky.Request
                .make input
                .get()

          "Sky Response":
            "*": ({ input }) ->
              Sky.Response
                .make input
                .get()

  process.exit if success then 0 else 1
