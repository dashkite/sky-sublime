import assert from "@dashkite/assert"
import {test, success} from "@dashkite/amen"
import print from "@dashkite/amen-console"
import Runner from "@dashkite/runner"
import express from "express"

import Sierra from "@dashkite/sierra"
import Registry from "@dashkite/registry"
import Sublime from "@dashkite/sublime"

import sky from "../src"
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

      { Request, Response } = Sublime.make [ sky ]

      Runner

        .make scenarios

        .apply

          "Sky Locator": 
            "*": ({ input }) ->
              Locator.decode input
              
          "Sky Request":
            "*": ({ input }) ->
              Request.Builder
                .make input
                .get()

          "Sky Response":
            "*": ({ input }) ->
              Response.Builder
                .make input
                .get()

  process.exit if success then 0 else 1
