package bemiddelingsregister.bemiddeling.rules

import rego.v1

import data.authz.global
import data.bemiddelingsregister.bemiddeling.config
import data.utils.common
import data.utils.graphql as _graphql

verantwoordelijkzorgkantoor_uzovi_claim_is_required if {
	common.claim(global.token, "uzovi")
}

error_messages contains msg if {
	config.operation
	common.contains_scope(config.scope, global.token.scopes)

	not is_indicatie_id_request_zorgaanbieder
	not is_indicatie_id_request_zorkantoor
	not verantwoordelijkzorgkantoor_uzovi_claim_is_required

	msg := {
		"message": common.err(
			"The 'uzovi' claim is not present in your token but required for the bemiddeling query.",
			config.operation,
		),
		"extensions": {"code": common.errors.UNAUTHORIZED},
	}
}
