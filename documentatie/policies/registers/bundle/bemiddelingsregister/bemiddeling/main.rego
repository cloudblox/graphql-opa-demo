package bemiddelingsregister.bemiddeling

import rego.v1

import data.authz.global
import data.bemiddelingsregister.bemiddeling.config
import data.bemiddelingsregister.bemiddeling.rules
import data.utils.common
import data.utils.graphql as _graphql

base_rules if {
	# Base rules for bemiddeling register
	config.operation
	common.contains_scope(config.scope, global.token.scopes)
}

allow if {
	base_rules

	# POL111 bemiddeling register query of a verantwoordelijk zorgkantoor
	rules.verantwoordelijkzorgkantoor_uzovi_claim_is_required
	rules.verantwoordelijkzorgkantoor_is_required
	rules.verantwoordelijkzorgkantoor_has_valid_uzovi
}

allow if {
	base_rules

	# POL104 PIP request for indicatieregister to check if the zorgaanbieder is instelling of bemiddeling
	# This POL can only be used as a PIP request from the PDP11
	rules.wlz_indicatieid_is_instelling
}

allow if {
	base_rules

	# POL107/113 PIP request for indicatieregister to check if
	# zorgkantoor is uitvoerend or verantwoordelijk zorgkantoor of bemiddeling
	# This POL can only be used as a PIP request from the PDP
	rules.wlz_indicatieid_is_zorgkantoor
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
