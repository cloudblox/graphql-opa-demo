package bemiddelingsregister.client.rules

import data.authz.global
import data.bemiddelingsregister.client.config
import data.bemiddelingsregister.client.helpers
import data.utils.common
import data.utils.graphql as _graphql
import rego.v1

# BRA0010 - Require verantwoordelijkZorgkantoor.
verantwoordelijkzorgkantoor_has_valid_uzovi if {
	helpers.some_bemiddeling_is(
		config.query_selection,
		global.variables,
		"verantwoordelijkZorgkantoor", "eq", common.claim(global.token, "uzovi"),
	)
}

error_messages contains msg if {
	config.operation
	common.contains_scope(config.scope, global.token.scopes)

	verantwoordelijkzorgkantoor_is_required
	not verantwoordelijkzorgkantoor_has_valid_uzovi

	msg := {
		"message": common.err(
			"A where 'verantwoordelijkZorgkantoor' equals is required and must be set to your uzovi.",
			config.operation,
		),
		"extensions": {"code": common.errors.BAD_REQUEST},
	}
}
