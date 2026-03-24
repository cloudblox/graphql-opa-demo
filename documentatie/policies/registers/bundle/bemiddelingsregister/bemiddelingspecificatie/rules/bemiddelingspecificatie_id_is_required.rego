package bemiddelingsregister.bemiddelingspecificatie.rules

import data.authz.global
import data.bemiddelingsregister.bemiddelingspecificatie.config
import data.utils.common
import data.utils.graphql as _graphql
import rego.v1

# BRA0001-BRA0009
bemiddelingspecificatie_id_is_required if {
	# Check if instelling is set to the token subject.
	_graphql.where_required_name_not_empty(config.query_selection, global.variables, "bemiddelingspecificatieID", "eq")
}

error_messages contains msg if {
	config.operation
	common.contains_scope(config.scope, global.token.scopes)

	not bemiddelingspecificatie_id_is_required

	msg := {
		"message": common.err("A where 'bemiddelingspecificatieID' equals is required.", config.operation),
		"extensions": {"code": common.errors.BAD_REQUEST},
	}
}
