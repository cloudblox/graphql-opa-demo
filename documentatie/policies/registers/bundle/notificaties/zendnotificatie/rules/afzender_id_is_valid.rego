package notificaties.zendnotificatie.rules

import rego.v1

import data.notificaties.constants
import data.notificaties.helpers
import data.notificaties.zendnotificatie.config

import data.authz.global
import data.utils.common
import data.utils.graphql as _graphql

afzender_id_is_valid if {
	instantie_type_claim_value := common.claim(global.token, "instantie_type")
	instantie_claim_id_value := constants.instantie_claim_id_map[instantie_type_claim_value]
	afzender_id_claim_value := common.claim(global.token, instantie_claim_id_value)
	afzender_id_value := _graphql.mutation_obj_arg(config.query_selection, global.variables, "notificatieInput", "afzenderID") # regal ignore:line-length
	afzender_id_claim_value == afzender_id_value
}

error_messages contains msg if {
	config.operation
	common.contains_scope(config.scope, global.token.scopes)
	scope_has_ontvanger_type

	mutatie_client_afzender_is_valid
	not afzender_id_is_valid

	msg := {
		"message": common.err("afzender_id is not valid.", config.operation),
		"extensions": {"code": common.errors.GRAPHQL_VALIDATION_FAILED},
	}
}
