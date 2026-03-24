package bemiddelingsregister.bemiddelingspecificatie.rules

import data.authz.global
import data.bemiddelingsregister.bemiddelingspecificatie.config
import data.utils.common
import data.utils.graphql as _graphql
import rego.v1

# BRA0001 & BRA0006 - Bemiddelingspecificatie query has a instelling
# or uitvoerendZorgkantoor clause with correct agb code.
uitvoerendzorgkantoor_has_valid_uzovi if {
	# Check if instelling is set to the token subject.
	_graphql.where_required(
		config.query_selection,
		global.variables,
		"uitvoerendZorgkantoor", "eq", common.claim(global.token, "uzovi"),
	)
}

error_messages contains msg if {
	config.operation
	common.contains_scope(config.scope, global.token.scopes)

	uitvoerendzorgkantoor_is_required
	not uitvoerendzorgkantoor_has_valid_uzovi

	msg := {
		"message": common.err("A where 'uitvoerendZorgkantoor' equals is required and set to your uzovi.", config.operation),
		"extensions": {"code": common.errors.BAD_REQUEST},
	}
}
