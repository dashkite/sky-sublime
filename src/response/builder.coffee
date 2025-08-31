import { Response } from "@dashkite/sublime"

import content from "../content"
import rulebase from "./rulebase"

class Builder extends Response

  @rulebases [ rulebase, content ]

export default Builder
