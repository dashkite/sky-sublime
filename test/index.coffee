import assert from "@dashkite/assert"
import {test, success} from "@dashkite/amen"
import print from "@dashkite/amen-console"
import Runner from "@dashkite/runner"
import express from "express"

import * as Sky from "../src"

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

      Runner

        .make scenarios

        .apply

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
