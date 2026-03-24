package bemiddelingsregister.overdracht.rules

import data.authz.global
import data.bemiddelingsregister.overdracht.config
import data.utils.common
import data.utils.graphql as _graphql
import rego.v1

subentities := ["regiehouder", "contactpersoon", "contactgegevens", "bemiddelingspecificatie"]
subentities_bemspec := ["regiehouder", "contactpersoon", "contactgegevens"]

overdrachtdatum_is_required if {
	_graphql.where_required_name_not_empty(config.query_selection, global.variables, "overdrachtDatum", "eq")

	selections := _graphql.walk_selections_multi_args(config.query_selection, subentities)
	count(selections) >= 0
}

overdrachtdatum_is_required if {
	not config.query_selection.Name == "overdracht"
}

overdrachtdatum_is_required if {
	bemiddeling_selection := _graphql.selection(config.query_selection, "bemiddeling")
	count(_graphql.walk_selections_multi_args(bemiddeling_selection, subentities)) == 0

	overdrachtspec_selection := _graphql.walk_selection(config.query_selection, "overdrachtspecificatie")
	count(_graphql.walk_selections_multi_args(overdrachtspec_selection, subentities_bemspec)) == 0
	_overdracht_bemiddeling_subentity(overdrachtspec_selection)
}

_overdracht_bemiddeling_subentity(bemspec_selection) if {
	not _graphql.walk_selection(bemspec_selection, "bemiddeling")
}

_overdracht_bemiddeling_subentity(bemspec_selection) if {
	overdracht_bemiddeling_selection := _graphql.walk_selection(bemspec_selection, "bemiddeling")
	count(_graphql.walk_selections_multi_args(overdracht_bemiddeling_selection, subentities)) == 0
}

error_messages contains msg if {
	config.operation
	common.contains_scope(config.scope, global.token.scopes)

	not overdrachtdatum_is_required

	msg := {
		"message": common.err(
			"A where 'overdrachtDatum' equals is required when querying a subentity of an 'overdracht'.", # regal ignore: line-length
			config.operation,
		),
		"extensions": {"code": common.errors.BAD_REQUEST},
	}
}
