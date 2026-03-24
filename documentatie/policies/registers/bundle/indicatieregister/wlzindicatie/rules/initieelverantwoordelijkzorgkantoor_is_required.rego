package indicatieregister.wlzindicatie.rules

import rego.v1

import data.authz.global
import data.indicatieregister.wlzindicatie.config
import data.utils.common
import data.utils.graphql as _graphql

has_initieelverantwoordelijkzorgkantoor if {
	_graphql.where_required_name(
		config.query_selection,
		"initieelVerantwoordelijkZorgkantoor", "eq",
	)
}

initieelverantwoordelijkzorgkantoor_is_required if {
	has_initieelverantwoordelijkzorgkantoor
}

initieelverantwoordelijkzorgkantoor_is_required if {
	is_uitvoerend_or_verantwoordelijk_zorgkantoor_of_bemiddeling
}

error_messages contains msg if {
	config.operation
	config.scope_allowed

	subject_is_zorgkantoor
	not initieelverantwoordelijkzorgkantoor_is_required

	msg := {
		"message": common.err("`initieelVerantwoordelijkZorgkantoor` is required, or actor must be listed as part of a bemiddeling", config.operation), # regal ignore:line-length
		"extensions": {"code": common.errors.UNAUTHORIZED},
	}
}
