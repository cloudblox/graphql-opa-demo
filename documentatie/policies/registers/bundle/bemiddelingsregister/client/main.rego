package bemiddelingsregister.client

import rego.v1

import data.authz.global
import data.bemiddelingsregister.client.config
import data.bemiddelingsregister.client.rules
import data.utils.common
import data.utils.graphql as _graphql

allow if {
	config.operation
	common.contains_scope(config.scope, global.token.scopes)

	rules.verantwoordelijkzorgkantoor_uzovi_claim_is_required
	rules.verantwoordelijkzorgkantoor_is_required
	rules.verantwoordelijkzorgkantoor_has_valid_uzovi
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
