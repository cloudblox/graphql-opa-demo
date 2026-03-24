package indicatieregister.wlzindicatie

import rego.v1

import data.authz.global
import data.indicatieregister.wlzindicatie.config
import data.indicatieregister.wlzindicatie.rules
import data.utils.common
import data.utils.graphql as _graphql

allow if {
	config.operation
	config.scope_allowed

	rules.is_instelling_or_zorgkantoor
	rules.id_is_required

	valid
}

valid if {
	rules.initieelverantwoordelijkzorgkantoor_is_required
	rules.initieelverantwoordelijkzorgkantoor_is_valid
}

valid if {
	rules.is_instelling_of_bemiddeling
}

valid if {
	rules.is_uitvoerend_or_verantwoordelijk_zorgkantoor_of_bemiddeling
}

# error messages
error_messages contains msg if {
	config.operation
	not config.scope_allowed
	msg := common.scope_not_allowed_error_msg(config.operation)
}

error_messages contains msg if {
	some msg in rules.error_messages
	msg
}
