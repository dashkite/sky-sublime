# Sky Sublime

*Sublime Request/Response Support For Sky*

[![Hippocratic License HL3-CORE](https://img.shields.io/static/v1?label=Hippocratic%20License&message=HL3-CORE&labelColor=5e2751&color=bc8c3d)](https://firstdonoharm.dev/version/3/0/core.html)

## Purpose

Sky Sublime extends `@dashkite/sublime` with rules for using discovery and API descriptions. It can automatically determine URLs, methods, content types, and authorization based on a resource name and discovery metadata.

## Installation

Use your favorite package manager to install `@dashkite/sky-sublime`.

## Usage

```coffee
import Sublime from "@dashkite/sublime"
import SkySublime from "@dashkite/sky-sublime"

# Create a Sublime instance with Sky rules
{ Request, Response } = Sublime.make [ SkySublime ]

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
console.log request.url.toString() # e.g., https://api.example.com/greetings/world
```

## Other Resources

- [Reference](docs/reference.md)

## Status

Not suitable for production use. Please report bugs and feature requests via the issue tracker.
