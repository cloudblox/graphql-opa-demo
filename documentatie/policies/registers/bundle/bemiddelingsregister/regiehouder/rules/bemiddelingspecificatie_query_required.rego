package bemiddelingsregister.regiehouder.rules

import data.authz.global
import data.bemiddelingsregister.regiehouder.config
import data.utils.common
import data.utils.graphql as _graphql
import rego.v1

subentities := ["bemiddelingspecificatie", "regiehouder", "contactpersoon", "contactgegevens"]

bemiddelingspecificatie_query_required if {
	not _graphql.selection(config.query_selection, "bemiddeling")
}

bemiddelingspecificatie_query_required if {
	bemiddeling_selection := _graphql.selection(config.query_selection, "bemiddeling")
	selections := _graphql.walk_selections_multi_args(bemiddeling_selection, subentities)

	count(selections) == 0
}

error_messages contains msg if {
	config.operation
	common.contains_scope(config.scope, global.token.scopes)

	not bemiddelingspecificatie_query_required

	msg := {
		"message": common.err(
			"other 'bemiddelingspecificaties', 'regiehouder', contactpersoon' and 'contactgegevens' must be queried with a 'bemiddelingspecificatie' query.", # regal ignore: line-length
			config.operation,
		),
		"extensions": {"code": common.errors.BAD_REQUEST},
	}
}
