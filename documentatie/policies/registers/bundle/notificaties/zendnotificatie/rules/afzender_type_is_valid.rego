package notificaties.zendnotificatie.rules

import rego.v1

import data.notificaties.constants
import data.notificaties.zendnotificatie.config
import data.notificaties.zendnotificatie.constants as zendnotificatie_constants

import data.authz.global
import data.utils.common
import data.utils.graphql as _graphql

afzender_type_is_valid if {
	instantie_type_claim_value := common.claim(global.token, "instantie_type")
	afzender_id_type := constants.instantie_type_map[instantie_type_claim_value]
	afzender_id_type_value := _graphql.mutation_obj_arg(config.query_selection, global.variables, "notificatieInput", "afzenderIDType") # regal ignore:line-length
	afzender_id_type_value == afzender_id_type
	some allowed_afzender_id_type in zendnotificatie_constants.allowed_afzender_id_types
	afzender_id_type_value == allowed_afzender_id_type
}

error_messages contains msg if {
	config.operation
	common.contains_scope(config.scope, global.token.scopes)
	scope_has_ontvanger_type

	not afzender_type_is_valid

	msg := {
		"message": common.err("afzender_type is not valid.", config.operation),
		"extensions": {"code": common.errors.GRAPHQL_VALIDATION_FAILED},
	}
}
