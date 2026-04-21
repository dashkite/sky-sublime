# Reference

Sky Sublime adds rules to the Sublime rulebase. These rules are activated when you pass `SkySublime` to `Sublime.make`.

## Request

When using Sky Sublime, the request builder accepts additional input properties.

### resource
$resource \to object$

A resource specifier used for discovery and URL encoding.

- `origin`: The origin of the API.
- `name`: The name of the resource.
- `bindings`: Key-value pairs for path parameters.

## Locator

### decode
$decode: url \dashrightarrow locator$

Asynchronously decodes a URL into a locator using discovery metadata.

```coffee
locator = await Locator.decode "https://api.example.com/greetings/world"
console.log locator.name # greeting
console.log locator.bindings.name # world
```
