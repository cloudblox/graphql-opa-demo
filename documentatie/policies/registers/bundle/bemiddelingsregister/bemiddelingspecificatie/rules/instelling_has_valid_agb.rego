package bemiddelingsregister.bemiddelingspecificatie.rules

import data.authz.global
import data.bemiddelingsregister.bemiddelingspecificatie.config
import data.utils.common
import data.utils.graphql as _graphql
import rego.v1

# BRA0001 & BRA0006 - Bemiddelingspecificatie query has a instelling
# or uitvoerendZorgkantoor clause with correct agb code.
instelling_has_valid_agb if {
	_graphql.where_required(
		config.query_selection, global.variables, "instelling", "eq",
		common.claim(global.token, "agb"),
	)

	_graphql.where_required_name_not_empty(
		config.query_selection, global.variables,
		"instelling", "eq",
	)
}

instelling_has_valid_agb if {
	not _graphql.where_required_name(config.query_selection, "instelling", "eq")
}

error_messages contains msg if {
	config.operation
	common.contains_scope(config.scope, global.token.scopes)

	not instelling_has_valid_agb
	zorgaanbieder_is_required

	msg := {
		"message": common.err("A where 'instelling' equals is required and set to your agb.", config.operation), # regal ignore: line-length
		"extensions": {"code": common.errors.BAD_REQUEST},
	}
}
