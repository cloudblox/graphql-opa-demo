package bemiddelingsregister.bemiddelingspecificatie

import rego.v1

import data.authz.global
import data.bemiddelingsregister.bemiddelingspecificatie.config
import data.bemiddelingsregister.bemiddelingspecificatie.rules
import data.utils.common
import data.utils.date
import data.utils.graphql as _graphql

base_rules if {
	config.operation
	common.contains_scope(config.scope, global.token.scopes)
}

# POL105, POL106: BRA0006-BRA0009
valid_entity if {
	rules.uitvoerendzorgkantoor_is_required
	rules.uitvoerendzorgkantoor_has_valid_uzovi
}

# POL102, POL103: BRA0001-BRA0005
valid_entity if {
	rules.zorgaanbieder_is_required
	rules.instelling_has_valid_agb
}

# POL102, POL103, POL105, POL106: BRA0001-BRA0009
allow if {
	base_rules
	valid_entity

	rules.bemiddelingspecificatie_id_is_required
	rules.overdracht_and_overdrachtspecificatie_not_allowed
	rules.only_own_bemiddeling

	# Check whether subentities are queried, and if so, if valid toewijzingsdata are given as well
	rules.toewijzingingangsdatum_is_required
	rules.vaststellingmoment_is_required

	# POL103, POL106, subentity datefilter specific rules
	rules.toewijzingeinddatum_is_required
	rules.toewijzingsdatum_filter_is_requried
	rules.query_today_still_allowed

	# POL103 specific policy
	rules.pgb_percentage_not_in_bemiddelingen
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
