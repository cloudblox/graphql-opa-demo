This folder contains the register OPA policy bundle that is used in the nID application.

# Folder structure

```
policies/
 ├── bundle_name/ (for example registers)
 │   └─ bundle/
 │      ├─ main.rego
 │      ├─ router.rego
 │      ├─ global.rego
 │      └─ policy_initiative_name/ (for example bemiddelingsregister)
 │          └─ policy_name/ (for example bemiddeling)
 │              ├─ main.rego
 │              ├─ main_test.rego
 │              ├─ config.rego
 │              └─ rules/
 |                  ├─ policy_rule.rego
 |                  ├─ policy_rule.rego
 │      └─ utils/
 │          ├─ utility.rego
 │          ├─ utility.rego
 │      └─ tests/
 │          └─ features/
 │              └─ feature_policy_name/ (for example bemiddelingsregister)
 │                  ├─ policy_name.feature

```

|  Name | Info | 
|---|---|
| main.rego  | The main policy definition to define the main entrypoint, and defines values for authorizations results, including allowed status, response body, headers and HTTP status. |
| main_test.rego  | Defines OPA test case scenarios to validate the rego policy. <br> Every main rego file should always have a test file to perform validation on the policy. |
| router.rego | Policy to control access to various operations across different modules |
| global.rego  | Policy to ensure that incoming requests contains valid JWT tokens and Graphql queries. <br> The policy parses the GraphQL query from the input and assigns the abstract syntax tree to query_ast. |
| config.rego | Policy for handling authorization and query operations for the main rego policy, so that only the specified parts of the query are processed and authorized within the defined context. |
| rules folder | Contains policy rules that are used in the policy definition.  |
| utils folder | Contains utility helper functions to simplify and standardize common operations in other parts of the policy. It creates error messages, flattens arrays, checks scope prefixes, as well as setting of error constants |
| tests folder | Contains the feature integration tests for the policy bundle. More information can be found here: [Integration tests](../../tests/integration_tests/README.md)   |

