# Introduction

This README describes how to test the nID policies.

# Creating/updating a nID policy locally

**Prerequisites**
- [Open Policy Agent](https://marketplace.visualstudio.com/items?itemName=tsandall.opa) extension in VSCode
- When using Windows
    - Open Policy Agent ([OPA Installation and usage](https://sangkeon.github.io/opaguide/chap2/installandusage.html))
    - go [Go installation](https://go.dev/doc/install)
- When using Linux (WSL)
    - Open Policy Agent ([OPA Installation and usage](https://sangkeon.github.io/opaguide/chap2/installandusage.html))
    - go [Go installation](https://go.dev/doc/install)
    - jq (sudo apt-get install jq)

## Testing an OPA Policy

Writing tests for OPA policies can speed up the development proces of new rules, and reduce the amount of time it takes to modify rules as new requirements are necessary.

The verify an OPA policy, OPA provides a framework to write tests for policies. This can be done by using ```opa test```

## Test format

To be able to test a policy, a test rego file must be created in the same directory as the policy rego file, for example:

```bash
main.rego
main_test.rego
```

**Rego test file**
Test are expressed as standard Rego rules with a convention that the rule is name is prefixed with ```test_``` for example:

```bash
package testpackage 

test_something if {
    # test logic
}
```

**OPA test command**
To run the OPA test, the following commands can be used:
In the policies directory, run

```bash
source .env.test
```

Then in the directory you want to test run
```bash
opa test . -v 
```

The opa test command runs all of the tests (rules prefixed with test_) found in Rego files passed on the command line. If directories are passed as command line arguments, opa test will load their file contents recursively.

By default, opa test reports the number of tests executed and displays all of the tests that have passed, failed or errored:

```bash
data.example.test_pass: PASS (288ns)
data.example.test_failure: FAIL (253ns)
data.example.test_error: ERROR (289ns)

--------------------------------------------------------------------------------
PASS: 1/3
FAIL: 1/3
ERROR: 1/3
```

- When the test rule generates a true value, the test result is marked as PASS.
- If the test rule is undefined or generates a non-true value the test result is reported as FAIL.
- If the test encounters a runtime error, the test result is marked as an ERROR.

## Testing nID policies

Each rego policy file should also have a corresponding test rego file. The following example shows a code structure for a test rego policy:

```bash
package testpolicy.policyaction_test

import data.authz.global

import data.authz as sut

test_something if {
    res := sut.result.allowed 
        with global.query_ast as graphql.parse_query(query)
        with global.variables as variables
        with input.attributes.request.http.headers.authorization as token

    print(res)
}

token := "Bearer eyJhbGciOiJSUz......"

query := `mutation exampleQuery($Input: Input!) {
    exampleQuery(Input: $Input) {
        name
        address
        country
        ....
    }
}`

variables := {"Input": {
    "timestamp": "2022-01-01T00:00:00Z",
    ...
}}

```

When `test_something` evaluates to true, then the OPA test has Passed succesfully.

Some tips when testing OPA policies locally:

- Use breakpoints with the `print(variable)` often and multiple times in the policy rego file(s) and test rego files for debugging, to know at what point the test validation fails, or when a rule has not been evaluated.

- When a policy references data or functions from other policy files or packages, these files can be included in the opa test command, for example:

```bash
opa test . -v ../../utils ../../global.rego ../constants.rego
```

- Variable `sut`: usually the sut value refers to the main bundle package (in this case data.authz). When testing a individual policy this must be changed to the individuals policy package, for example:

```bash
import data.notificaties.zendmelding as sut
```

- Variable `print(res)`: To view the output of the result value `res`, the res variable must be changed to the output result from the sut package, which is usually either of:
  - `res := sut.allow`
  - `res := sut.result.allowed`
  - `res := sut.error_messages`

- Variable `token`: when a new token is necessary for testing a policy, then this value needs to be replaced. A new token can be created with the [create_token](../tests/src/helpers/create_token/) GO app:
  - Edit the example_claims.json with the correct claims
  - `go run create_token.go`
  - The new token will be copied to the clipboard, which can be used directly to token line in the test rego file.
- Use the [.editorconfig](../../.editorconfig) in your editor or IDE, to use the same styling and formats for creating and editing policies. For example in VSCode, instelling the [EditorConfig extension](https://marketplace.visualstudio.com/items?itemName=EditorConfig.EditorConfig) is enough to make use of the editorconfig template in this repository.
