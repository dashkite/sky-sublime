import Request from "@dashkite/sublime/request"

import content from "../content"
import rulebase from "./rulebase"

class Builder extends Request

  @rulebases [ rulebase, content ]

export default Builder
