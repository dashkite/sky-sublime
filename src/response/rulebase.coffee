import Scout from "@dashkite/scout"
import Request from "../request/builder"
import Rulebase from "@dashkite/athena"

rulebase = Rulebase.make

  clone: ( state ) -> state.clone()

rulebase.conditions

  "has request": -> @input.request?

rulebase.actions

  "set request": ->
    @output.request = await Request
      .make @input.request
      .get()

rulebase.rules

  "set request": [ "has request" ]

export default rulebase
