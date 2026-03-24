package bemiddelingsregister.bemiddelingspecificatie.rules

import data.authz.global
import data.bemiddelingsregister.bemiddelingspecificatie.config
import data.utils.common
import data.utils.graphql as _graphql
import rego.v1

pgb_percentage_not_in_bemiddelingen if {
	bemiddeling_selection := _graphql.selection(config.query_selection, "bemiddeling")

	selections := _graphql.walk_selection(bemiddeling_selection, "bemiddelingspecificatie")
	not _graphql.walk_selection(selections, "pgbPercentage")
}

pgb_percentage_not_in_bemiddelingen if {
	bemiddeling_selection := _graphql.selection(config.query_selection, "bemiddeling")

	selections := _graphql.walk_selection(bemiddeling_selection, "bemiddelingspecificatie")
	count(_graphql.walk_selection(selections, "pgbPercentage")) == 0
}

pgb_percentage_not_in_bemiddelingen if {
	bemiddeling_selection := _graphql.selection(config.query_selection, "bemiddeling")

	not _graphql.walk_selection(bemiddeling_selection, "bemiddelingspecificatie")
}

pgb_percentage_not_in_bemiddelingen if {
	not _graphql.selection(config.query_selection, "bemiddeling")
}

error_messages contains msg if {
	config.operation
	common.contains_scope(config.scope, global.token.scopes)

	not pgb_percentage_not_in_bemiddelingen

	msg := {
		"message": common.err("You may only query your own 'pgbPercentage'.", config.operation), # regal ignore: line-length
		"extensions": {"code": common.errors.BAD_REQUEST},
	}
}
