package bemiddelingsregister.overdracht.rules

import data.authz.global
import data.bemiddelingsregister.overdracht.config
import data.utils.common
import data.utils.graphql as _graphql
import rego.v1

# Checks that only the root 'bemiddeling' entity is queried, and not any other bemiddelingen via the client.
only_own_bemiddeling if {
	client_selection := _graphql.selection(config.query_selection, "bemiddeling")
	count(_graphql.walk_selections(client_selection, "bemiddeling")) == 0
}

error_messages contains msg if {
	config.operation
	common.contains_scope(config.scope, global.token.scopes)

	not only_own_bemiddeling

	msg := {
		"message": common.err("You may only query your own 'bemiddeling'.", config.operation),
		"extensions": {"code": common.errors.BAD_REQUEST},
	}
}
