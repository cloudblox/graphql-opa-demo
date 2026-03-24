package notificaties.zendnotificatie.rules

import rego.v1

import data.notificaties.zendnotificatie.config

import data.authz.global
import data.utils.common
import data.utils.graphql as _graphql

instantie_type_claim_found if {
	instantie_type_claim_value := common.claim(global.token, "instantie_type")
	instantie_type_claim_value != null
}

error_messages contains msg if {
	config.operation
	common.contains_scope(config.scope, global.token.scopes)
	scope_has_ontvanger_type

	not instantie_type_claim_found

	msg := {
		"message": common.err("instantie_type claim not found.", config.operation),
		"extensions": {"code": common.errors.GRAPHQL_VALIDATION_FAILED},
	}
}
