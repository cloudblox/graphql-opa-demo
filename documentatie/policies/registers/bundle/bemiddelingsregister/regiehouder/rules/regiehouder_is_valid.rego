package bemiddelingsregister.regiehouder.rules

import data.authz.global
import data.bemiddelingsregister.regiehouder.config
import data.utils.common
import data.utils.graphql as _graphql
import rego.v1

instelling_is_valid if {
	_graphql.where_required(
		config.query_selection, global.variables, "instelling", "eq",
		common.claim(global.token, "agb"),
	)

	_graphql.where_required_name_not_empty(
		config.query_selection, global.variables,
		"instelling", "eq",
	)
}

error_messages contains msg if {
	config.operation
	common.contains_scope(config.scope, global.token.scopes)

	instelling_is_required
	not instelling_is_valid

	msg := {
		"message": common.err("A where 'instelling' equals is required and set to your agb.", config.operation), # regal ignore: line-length
		"extensions": {"code": common.errors.BAD_REQUEST},
	}
}
