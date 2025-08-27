import Scout from "@dashkite/scout"
import Athena from "@dashkite/athena"
import State from "@dashkite/sublime/state"

rulebase = Athena.make

  initialize: ( state ) -> State.make state

  clone: ( state ) -> state.clone()

  equal: ( a, b ) -> a.equal b
          
rulebase.conditions {}

rulebase.actions {}

rulebase.rules {}

export default rulebase
