package bemiddelingsregister.bemiddelingspecificatie.rules

import data.authz.global
import data.bemiddelingsregister.bemiddelingspecificatie.config
import data.utils.common
import data.utils.graphql as _graphql
import rego.v1

zorgaanbieder_is_required if {
	_graphql.where_required_name(config.query_selection, "instelling", "eq")
}

uitvoerendzorgkantoor_is_required if {
	_graphql.where_required_name(config.query_selection, "uitvoerendZorgkantoor", "eq")
}

uitvoerendzorgkantoor_or_zorgaanbieder_is_required if {
	zorgaanbieder_is_required
}

uitvoerendzorgkantoor_or_zorgaanbieder_is_required if {
	uitvoerendzorgkantoor_is_required
}

error_messages contains msg if {
	config.operation
	common.contains_scope(config.scope, global.token.scopes)

	not uitvoerendzorgkantoor_or_zorgaanbieder_is_required

	msg := {
		"message": common.err(
			"A 'instelling' or 'uitvoerendZorgkantoor' equals is required and must be set to your agb or uzovi respectively.",
			config.operation,
		),
		"extensions": {"code": common.errors.BAD_REQUEST},
	}
}
