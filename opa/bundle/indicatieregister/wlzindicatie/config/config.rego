package indicatieregister.wlzindicatie.config

import rego.v1

import data.authz.global
import data.utils.common
import data.utils.graphql as _graphql

operation := _graphql.query_operation(global.query_ast, "wlzIndicatie")

query_selection := value if {
	operation
	value := _graphql.selection(operation, "wlzIndicatie")
}

deprecated_scope := `registers/wlzindicatieregister/indicaties:read`

scope := `registers/wlzindicatieregister/indicaties/indicatie:read`

scope_allowed if {
	common.contains_scope(deprecated_scope, global.token.scopes)
}

scope_allowed if {
	common.contains_scope(scope, global.token.scopes)
}
