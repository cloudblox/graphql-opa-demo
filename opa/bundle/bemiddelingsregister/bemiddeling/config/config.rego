package bemiddelingsregister.bemiddeling.config

import rego.v1

import data.authz.global
import data.utils.graphql as _graphql

operation := _graphql.query_operation(global.query_ast, "bemiddeling")

query_selection := value if {
	operation
	value := _graphql.selection(operation, "bemiddeling")
}

scope := `registers/wlzbemiddelingsregister`
