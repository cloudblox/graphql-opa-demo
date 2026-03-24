package notificaties.zendnotificatie.rules

import rego.v1

import data.notificaties.constants
import data.notificaties.helpers
import data.notificaties.zendnotificatie.config

import data.authz.global
import data.utils.common
import data.utils.graphql as _graphql

afzender_type_kvk_is_valid if {
	afzender_type_is_valid

	# ignore when not instantie_type is KVK
	instantie_type_claim_value := common.claim(global.token, "instantie_type")
	constants.instantie_type_map[instantie_type_claim_value] != "KVK"
}

afzender_type_kvk_is_valid if {
	afzender_type_is_valid
	valid_kvk
}

valid_kvk if {
	helpers.afzender_is_ciz
}

error_messages contains msg if {
	config.operation
	common.contains_scope(config.scope, global.token.scopes)
	scope_has_ontvanger_type

	afzender_type_is_valid
	not afzender_type_kvk_is_valid

	msg := {
		"message": common.err("afzender_type is not valid.", config.operation),
		"extensions": {"code": common.errors.GRAPHQL_VALIDATION_FAILED},
	}
}
