package bemiddelingsregister.bemiddeling.rules

import data.authz.global
import data.bemiddelingsregister.bemiddeling.config
import data.bemiddelingsregister.bemiddeling.helpers
import data.utils.common
import data.utils.graphql as _graphql
import rego.v1

verantwoordelijkzorgkantoor_is_required if {
	_graphql.where_required_name(config.query_selection, "verantwoordelijkZorgkantoor", "eq")
}

verantwoordelijkzorgkantoor_is_required if {
	helpers.some_bemiddeling(config.query_selection, global.variables, "verantwoordelijkZorgkantoor", "eq")
}

error_messages contains msg if {
	config.operation
	common.contains_scope(config.scope, global.token.scopes)

	not is_indicatie_id_request_zorgaanbieder
	not is_indicatie_id_request_zorkantoor
	not verantwoordelijkzorgkantoor_is_required

	msg := {
		"message": common.err("A where 'verantwoordelijkZorgkantoor' equals is required.", config.operation),
		"extensions": {"code": common.errors.BAD_REQUEST},
	}
}
