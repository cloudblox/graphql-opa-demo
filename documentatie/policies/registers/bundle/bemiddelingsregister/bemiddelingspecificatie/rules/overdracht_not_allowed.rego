package bemiddelingsregister.bemiddelingspecificatie.rules

import data.authz.global
import data.bemiddelingsregister.bemiddelingspecificatie.config
import data.utils.common
import data.utils.graphql as _graphql
import rego.v1

overdracht_not_allowed if {
	not _graphql.selection(config.query_selection, "bemiddeling")
}

overdracht_not_allowed if {
	bemiddeling_selection := _graphql.selection(config.query_selection, "bemiddeling")
	count(_graphql.walk_selection(bemiddeling_selection, "overdracht")) == 0
}

overdracht_not_allowed if {
	bemiddeling_selection := _graphql.selection(config.query_selection, "bemiddeling")
	not _graphql.walk_selection(bemiddeling_selection, "overdracht")
}

overdrachtspecificatie_not_allowed if {
	count(_graphql.walk_selection(config.query_selection, "overdrachtspecificatie")) == 0
}

overdrachtspecificatie_not_allowed if {
	not _graphql.walk_selection(config.query_selection, "overdrachtspecificatie")
}

overdracht_and_overdrachtspecificatie_not_allowed if {
	overdracht_not_allowed
	overdrachtspecificatie_not_allowed
}

error_messages contains msg if {
	config.operation
	common.contains_scope(config.scope, global.token.scopes)

	not overdracht_and_overdrachtspecificatie_not_allowed

	msg := {
		"message": common.err("'overdracht' and 'overdrachtSpecificatie' may not be queried as part of this query.", config.operation), # regal ignore: line-length
		"extensions": {"code": common.errors.BAD_REQUEST},
	}
}
