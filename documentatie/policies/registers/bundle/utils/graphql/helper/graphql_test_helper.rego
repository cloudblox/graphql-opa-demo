package utils.graphql.helper

import rego.v1

operation_by_selection_set_alias(ast, alias) := operation if {
	some operation in ast.Operations
	some selection_set in operation.SelectionSet
	selection_set.Alias == alias
}
