package notificaties.zendmelding

import rego.v1

import data.authz.global
import data.notificaties.zendmelding.config
import data.notificaties.zendmelding.rules
import data.utils.common
import data.utils.graphql as _graphql

allow if {
	config.operation
	common.contains_scope(config.scope, global.token.scopes)
	rules.scope_has_ontvanger_type

	rules.instantie_type_claim_found
	rules.afzender_type_is_valid
	rules.afzender_type_kvk_is_valid
	rules.afzender_id_is_valid
	rules.event_type_is_valid
	rules.ontvanger_is_valid
}

# error messages
error_messages contains msg if {
	config.operation
	not common.contains_scope(config.scope, global.token.scopes)
	msg := common.scope_not_allowed_error_msg(config.operation)
}

error_messages contains msg if {
	some msg in rules.error_messages
	msg
}
