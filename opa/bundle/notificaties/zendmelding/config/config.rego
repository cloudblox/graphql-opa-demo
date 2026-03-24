package notificaties.zendmelding.config

import rego.v1

import data.authz.global
import data.utils.graphql as _graphql

operation := _graphql.mutation_operation(global.query_ast, "zendMelding")

query_selection := value if {
	operation
	value := _graphql.selection(operation, "zendMelding")
}

scope := `organisaties/[^\\s/:]+/meldingen/melding:create`
