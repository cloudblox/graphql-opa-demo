package bemiddelingsregister.overdracht.rules

import data.authz.global
import data.bemiddelingsregister.overdracht.config
import data.utils.common
import data.utils.graphql as _graphql
import rego.v1

overdrachtid_is_required if {
	_graphql.where_required_name_not_empty(config.query_selection, global.variables, "overdrachtID", "eq")
}

error_messages contains msg if {
	config.operation
	common.contains_scope(config.scope, global.token.scopes)

	not overdrachtid_is_required

	msg := {
		"message": common.err("A where 'overdrachtID' equals is required and must have a value.", config.operation),
		"extensions": {"code": common.errors.BAD_REQUEST},
	}
}
