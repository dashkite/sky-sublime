# Testing

This document outlines the testing strategy for the Sky Sublime package.

## Testing Approach

The testing strategy relies on an integration approach, utilizing a local `express` server to provide a mock API description (`api.yaml`). This allows the tests to exercise the full discovery and encoding pipeline without relying on external network resources.

The tests are defined declaratively using `@dashkite/runner` and a `scenarios.yaml` file. This data-driven approach cleanly separates the test cases from the execution logic, making it easy to add new scenarios for URLs, requests, and responses. 

The test runner evaluates each scenario, executing the corresponding Sublime builders or `Locator.decode` methods, and then uses `@dashkite/assert` to verify the resulting structures against the expected outcomes.

## Running Tests

To run the test suite, execute the following command:

```bash
npx genie test
```

This will invoke the `genie test` command, which automatically compiles the source code and runs the test runner against the defined scenarios.
