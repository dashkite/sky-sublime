# Sky Sublime

*Sublime Request/Response Support For Sky*

[![Hippocratic License HL3-CORE](https://img.shields.io/static/v1?label=Hippocratic%20License&message=HL3-CORE&labelColor=5e2751&color=bc8c3d)](https://firstdonoharm.dev/version/3/0/core.html)

Sky Sublime extends the Sublime request and response representation with rules for Sky discovery and API descriptions. It automatically determines target URLs, validates HTTP methods, and negotiates content types and authorization based on a resource name and discovery metadata.

## Features

- Evaluates requests dynamically using Athena rules.
- Automatically loads API descriptions via Scout discovery.
- Encodes resource parameters to determine target URLs.
- Sets appropriate `content-type` and `accept` headers automatically.
- Validates methods and content types against API descriptions.
- Generates authorization challenges and validates credentials.

## Installation

```bash
pnpm install @dashkite/sky-sublime
```

## Usage

Use Sky Sublime to automatically configure a Sublime request using a resource definition instead of a hardcoded URL.

```coffeescript
import Sublime from "@dashkite/sublime"
import sky from "@dashkite/sky-sublime"

# Create a Sublime instance with Sky rules
{ Request, Response } = Sublime.make [ sky ]

# Build a request using a resource
request = await Request.Builder
  .make
    resource:
      origin: "https://api.example.com"
      name: "greeting"
      bindings: { name: "world" }
    method: "POST"
    content: { message: "hello" }
  .get()

# The URL is encoded based on the API description discovered at the origin
console.log request.url.toString()
```

## Other Resources

- [Reference](docs/reference.md)
- [Recipes](docs/recipes.md)
- [Technical Notes](docs/technical-notes.md)
- [Testing](docs/testing.md)
