# Reference

## Concepts

The Sky Sublime interface is intentionally designed to be virtually identical to the base Sublime library. Both utilize a rule-based inference engine to convert various colloquial forms of HTTP structures into a specific target form, by passing through a canonical Sublime form. Instead of manually specifying every endpoint detail, creators provide a minimal, colloquial request or response that expresses their high-level intent.

The fundamental difference lies in the rulesets that are evaluated. Sky Sublime injects a specialized ruleset that operates on Sky API entities and concepts, such as resource spaces and locators. This ruleset exists in a separate equilibrium from the base Sky ruleset, evaluating deeply contextual Sky-specific rules (like automated authorization schemes, content-type negotiation based on API definitions, and URL encoding from resources) before yielding to standard protocol state transfer logic.

This process relies heavily on a builder pattern intertwined with the Athena rules engine. Builders collect initial colloquial inputs (such as a logical resource handle) and evaluate them against the combined registered rulebases. Once the engine reaches equilibrium, it emits a finalized `Value` object representing the fully resolved canonical request or response, seamlessly translating higher-level Sky API semantics into standardized HTTP.

## Request.Builder

### make

$make: input \to builder$

Instantiates a new request builder initialized with a colloquial `input` configuration. Within Sky Sublime, this input typically includes a logical `resource` object instead of a hardcoded URL. The builder acts as the entry point for the Athena rules engine, gathering this initial colloquial context to begin discovering the API description and inferring the canonical request.

The `resource` property should contain an `origin` (e.g., `"https://api.example.com"`), the `name` of the resource defined in the API description, and a `bindings` object mapping keys to values for path parameters.

```coffeescript
import assert from "node:assert"
import Sublime from "@dashkite/sublime"
import sky from "@dashkite/sky-sublime"

{ Request } = Sublime.make [ sky ]
builder = Request.Builder.make 
  resource:
    origin: "https://example.com"
    name: "greeting"
    bindings:
      name: "world"
  method: "post"
  content: { hello: "world" }

assert.equal builder.input.resource.name, "greeting"
```

## Response.Builder

### make

$make: input \to builder$

Instantiates a new response builder initialized with a colloquial `input` configuration, establishing the baseline state for inference. When using Sky Sublime, providing the original canonical `request` within the input allows the rules engine to automatically negotiate the correct response `content-type` based on the method and resource definitions found in the API description.

```coffeescript
import assert from "node:assert"
import Sublime from "@dashkite/sublime"
import sky from "@dashkite/sky-sublime"

{ Response } = Sublime.make [ sky ]

# Assuming originalRequest is a finalized Sublime Request with a resource
builder = Response.Builder.make
  request: originalRequest
  status: 200
  content: { success: true }

assert.equal builder.input.status, 200
```

## Locator

### decode

$decode: url \dashrightarrow locator$

Asynchronously decodes a target URL into a logical locator using discovery metadata. It resolves the API description from the URL's origin and parses the URL path to infer a specific resource name and its bindings. This transforms a literal network address into a structured handle that can be manipulated programmatically.

```coffeescript
import assert from "node:assert"
import Locator from "@dashkite/sky-sublime/locator"

locator = await Locator.decode "https://api.example.com/greetings/world"

assert.equal locator.name, "greeting"
assert.equal locator.bindings.name, "world"
```
