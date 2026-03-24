package bemiddelingsregister.overdracht.rules

import data.authz.global
import data.bemiddelingsregister.overdracht.config
import data.utils.common
import data.utils.graphql as _graphql
import rego.v1

verantwoordelijkzorgkantoor_is_required if {
	_graphql.where_required_name(config.query_selection, "verantwoordelijkZorgkantoor", "eq")
}

error_messages contains msg if {
	config.operation
	common.contains_scope(config.scope, global.token.scopes)

	not verantwoordelijkzorgkantoor_is_required

	msg := {
		"message": common.err("A where 'verantwoordelijkZorgkantoor' equals is required.", config.operation),
		"extensions": {"code": common.errors.BAD_REQUEST},
	}
}
