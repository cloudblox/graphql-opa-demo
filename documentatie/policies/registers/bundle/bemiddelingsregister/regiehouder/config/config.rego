package bemiddelingsregister.regiehouder.config

import rego.v1

import data.authz.global
import data.utils.graphql as _graphql

operation := _graphql.query_operation(global.query_ast, "regiehouder")

query_selection := value if {
	operation
	value := _graphql.selection(operation, "regiehouder")
}

scope := `registers/wlzbemiddelingsregister`
