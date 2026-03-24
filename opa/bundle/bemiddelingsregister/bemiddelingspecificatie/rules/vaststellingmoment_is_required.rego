package bemiddelingsregister.bemiddelingspecificatie.rules

import data.authz.global
import data.bemiddelingsregister.bemiddelingspecificatie.config
import data.utils.common
import data.utils.graphql as _graphql
import rego.v1

subentities := ["bemiddelingspecificatie", "regiehouder", "contactpersoon", "contactgegevens"]

vaststellingmoment_is_required if {
	_graphql.where_required_name(config.query_selection, "vaststellingMoment", "eq")

	bemiddeling_selection := _graphql.selection(config.query_selection, "bemiddeling")

	selections := _graphql.walk_selections_multi_args(bemiddeling_selection, subentities)
	count(selections) > 0
}

vaststellingmoment_is_required if {
	not _graphql.selection(config.query_selection, "bemiddeling")
}

vaststellingmoment_is_required if {
	bemiddeling_selection := _graphql.selection(config.query_selection, "bemiddeling")
	selections := _graphql.walk_selections_multi_args(bemiddeling_selection, subentities)

	count(selections) == 0
}

error_messages contains msg if {
	config.operation
	common.contains_scope(config.scope, global.token.scopes)

	not vaststellingmoment_is_required

	msg := {
		"message": common.err(
			"A where 'vaststellingMoment' equals is required when querying a subentity.", # regal ignore: line-length
			config.operation,
		),
		"extensions": {"code": common.errors.BAD_REQUEST},
	}
}
