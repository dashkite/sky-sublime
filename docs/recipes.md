# Sky Sublime Recipes

## Decoding a Target URL

Before building complex HTTP requests, it is often necessary to understand what resource a target URL points to. While base Sublime focuses on the structure of the request itself, Sky Sublime provides a `Locator` class to automatically decode literal URLs using Sky API descriptions discovered at their origin.

By using the `Locator.decode` method, the software discovers the API metadata and parses the URL path into a logical resource name and its bindings. This shifts you away from raw string manipulation and toward programmable resource handles that can be fed into the Sublime rules engine.

```coffeescript
import Locator from "@dashkite/sky-sublime/locator"

# decode the URL to discover the resource identity
locator = await Locator.decode "https://api.example.com/hello/dolly"

console.log locator.name
console.log locator.bindings.name
```

1. Import the `Locator` from `@dashkite/sky-sublime/locator`.
2. Await the `Locator.decode` method, passing in your target URL string.
3. Access the `name` and `bindings` properties on the resulting locator.

## Composing a Canonical Request

Base Sublime already excels at converting high-level intent into a strict, canonical network request. Sky Sublime builds directly on this foundation by injecting a ruleset capable of interpreting Sky resource definitions. Instead of manually specifying URLs and content types, you provide a colloquial `resource` object, and the Sky ruleset infers the rest.

By passing the exported Sky ruleset into `Sublime.make`, the builder leverages the Athena rules engine to fetch the API description, construct the URL, and enforce the required headers before yielding to the standard Sublime canonicalization process.

```coffeescript
import Sublime from "@dashkite/sublime"
import sky from "@dashkite/sky-sublime"

# initialize a standard Sublime environment, but inject the Sky ruleset
{ Request } = Sublime.make [ sky ]

request = await Request.Builder
  .make
    resource:
      origin: "https://api.example.com"
      name: "hello"
      bindings:
        name: "world"
    method: "put"
    content:
      greeting: "Hello, World"
  .get()

# the result is a standard Sublime canonical Request
console.log request.url.toString()
```

1. Initialize a Sublime environment and pass in the `sky` ruleset.
2. Provide a colloquial `resource` property containing the `origin`, `name`, and `bindings` to the `Request.Builder`.
3. Provide the `method` and any `content`.
4. Await the `.get()` method to evaluate the combined rulesets, run the automated API discovery, and produce the standard, finalized Sublime request.

## Constructing an Automated Response

Just like the request builder, the base Sublime response builder handles strict serialization and header management. Sky Sublime extends this by automating content-type negotiation for responses based on the Sky API description.

Pass the original inbound Sublime request to the `Response.Builder` along with your content. The injected Sky rules evaluate the available response types for the request's specific resource and method, automatically setting the appropriate `content-type` header before standard Sublime finalizes the response.

```coffeescript
import Sublime from "@dashkite/sublime"
import sky from "@dashkite/sky-sublime"

# initialize a standard Sublime environment, injecting the Sky ruleset
{ Response } = Sublime.make [ sky ]

# the request parameter contains the incoming canonical Sublime request
response = await Response.Builder
  .make
    request: request
    status: 200
    content: "Hello, World"
  .get()

# the result is a standard Sublime canonical Response with automated headers
console.log response.headers.get "content-type"
```

1. Initialize a Sublime environment and pass in the `sky` ruleset.
2. Provide the original canonical `request` to the `Response.Builder`.
3. Include the HTTP `status` and the colloquial response `content`.
4. Await the builder's `.get()` method to produce a properly typed, canonical Sublime response.

## Negotiating Required Authorizations

Secure network interactions require strict adherence to the target API's authentication models. While base Sublime handles generic header construction, Sky Sublime leverages its injected ruleset to negotiate authorization automatically based on the constraints defined in the target API's description.

Provide an `authorization` property within the colloquial request. The Sky rules cross-reference your provided authorization schemes against the supported challenges defined in the API metadata. It halts the builder and throws an error if the requirements are unmet, ensuring insecure requests never leave your system.

```coffeescript
import Sublime from "@dashkite/sublime"
import sky from "@dashkite/sky-sublime"

# initialize a standard Sublime environment, injecting the Sky ruleset
{ Request } = Sublime.make [ sky ]

# passing authorization specifiers to ensure they match API constraints
request = await Request.Builder
  .make
    resource:
      origin: "https://api.example.com"
      name: "secure_endpoint"
    method: "post"
    authorization: [
      { challenge: { scheme: "foo" } }
    ]
  .get()

console.log request.headers.get "authorization"
```

1. Initialize a Sublime environment and pass in the `sky` ruleset.
2. Provide a colloquial `resource` property and `method` to the `Request.Builder`.
3. Supply an `authorization` array outlining the schemes you intend to use.
4. Await the builder's `.get()` method to allow the Sky ruleset to validate the schemes against the API description before the standard Sublime rules generate the final header.
