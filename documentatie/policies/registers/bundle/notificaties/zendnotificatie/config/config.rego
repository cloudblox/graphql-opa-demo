package notificaties.zendnotificatie.config

import rego.v1

import data.authz.global
import data.utils.graphql as _graphql

operation := _graphql.mutation_operation(global.query_ast, "zendNotificatie")

query_selection := value if {
	operation
	value := _graphql.selection(operation, "zendNotificatie")
}

scope := `organisaties/[^\\s/:]+/notificaties/notificatie:create`
