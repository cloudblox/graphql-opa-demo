package indicatieregister.wlzindicatie.rules

import rego.v1

import data.authz.global
import data.indicatieregister.wlzindicatie.config
import data.utils.common
import data.utils.date
import data.utils.graphql as _graphql

id_is_required if {
	_graphql.where_required_name_not_empty(
		config.query_selection,
		global.variables,
		"wlzindicatieID", "eq",
	)
}

error_messages contains msg if {
	config.operation
	config.scope_allowed

	not id_is_required

	msg := {
		"message": common.err("A where 'wlzindicatieID' is required.", config.operation),
		"extensions": {"code": common.errors.UNAUTHORIZED},
	}
}
