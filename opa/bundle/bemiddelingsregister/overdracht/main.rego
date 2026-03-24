package bemiddelingsregister.overdracht

import rego.v1

import data.authz.global
import data.bemiddelingsregister.overdracht.config
import data.bemiddelingsregister.overdracht.rules
import data.utils.common
import data.utils.graphql as _graphql

base_rules if {
	config.operation
	common.contains_scope(config.scope, global.token.scopes)
}

# POL109, POL114: BRA0010
allow if {
	base_rules

	rules.verantwoordelijkzorgkantoor_is_required
	rules.verantwoordelijkzorgkantoor_uzovi_claim_is_required
	rules.verantwoordelijkzorgkantoor_has_valid_uzovi
	rules.only_own_bemiddeling

	rules.overdrachtid_is_required
	rules.overdrachtdatum_is_required
	rules.overdrachtdatum_filter_is_required
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
