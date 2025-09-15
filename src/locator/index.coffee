import Scout from "@dashkite/scout"
import XURL from "@dashkite/sublime/xurl"

class Locator extends XURL

  @decode: ( url ) ->
    self = new @ url
    api = await Scout.discover self.origin
    Object.assign self,
      Scout.decode self.target, api
    self

export default Locator