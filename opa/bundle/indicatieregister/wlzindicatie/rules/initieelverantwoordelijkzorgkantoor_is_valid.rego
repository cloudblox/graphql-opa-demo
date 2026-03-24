package indicatieregister.wlzindicatie.rules

import rego.v1

import data.authz.global
import data.indicatieregister.wlzindicatie.config
import data.utils.common
import data.utils.graphql as _graphql

initieelverantwoordelijkzorgkantoor_is_valid if {
	not has_initieelverantwoordelijkzorgkantoor
}

initieelverantwoordelijkzorgkantoor_is_valid if {
	_graphql.where_required(
		config.query_selection,
		global.variables,
		"initieelVerantwoordelijkZorgkantoor", "eq", common.claim(global.token, "uzovi"),
	)
}

error_messages contains msg if {
	config.operation
	config.scope_allowed

	subject_is_zorgkantoor
	not initieelverantwoordelijkzorgkantoor_is_valid

	msg := {
		"message": common.err("Actor's uzovi does not equal `initieelVerantwoordelijkZorgkantoor`", config.operation),
		"extensions": {"code": common.errors.UNAUTHORIZED},
	}
}
