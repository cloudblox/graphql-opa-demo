package bemiddelingsregister.regiehouder

import rego.v1

import data.authz.global
import data.bemiddelingsregister.regiehouder.config
import data.bemiddelingsregister.regiehouder.rules
import data.utils.common
import data.utils.graphql as _graphql

base_rules if {
	config.operation
	common.contains_scope(config.scope, global.token.scopes)
}

allow if {
	base_rules

	rules.regiehouder_id_is_required
	rules.instelling_is_required
	rules.instelling_is_valid
	rules.overdracht_and_overdrachtspecificatie_not_allowed
	rules.only_own_bemiddeling
	rules.bemiddelingspecificatie_query_required
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
