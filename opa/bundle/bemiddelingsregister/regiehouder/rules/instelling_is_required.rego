package bemiddelingsregister.regiehouder.rules

import data.authz.global
import data.bemiddelingsregister.regiehouder.config
import data.utils.common
import data.utils.graphql as _graphql
import rego.v1

instelling_is_required if {
	_graphql.where_required_name_not_empty(config.query_selection, global.variables, "instelling", "eq")
}

error_messages contains msg if {
	config.operation
	common.contains_scope(config.scope, global.token.scopes)

	not instelling_is_required

	msg := {
		"message": common.err(
			"A where 'instelling' equals is required.",
			config.operation,
		),
		"extensions": {"code": common.errors.BAD_REQUEST},
	}
}
