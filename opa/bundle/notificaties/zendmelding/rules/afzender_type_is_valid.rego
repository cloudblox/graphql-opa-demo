package notificaties.zendmelding.rules

import rego.v1

import data.notificaties.constants
import data.notificaties.zendmelding.config

import data.authz.global
import data.utils.common
import data.utils.graphql as _graphql

afzender_type_is_valid if {
	instantie_type_claim_value := common.claim(global.token, "instantie_type")
	afzender_id_type := constants.instantie_type_map[instantie_type_claim_value]
	afzender_id_type_value := _graphql.mutation_obj_arg(config.query_selection, global.variables, "meldingInput", "afzenderIDType") # regal ignore:line-length
	afzender_id_type_value == afzender_id_type
}

# POL216
afzender_type_is_valid if {
	common.has_actor_claim(global.token, constants.vecozo_silvester_gebruikersnummers)

	instantie_type_claim_value := common.claim(global.token, "instantie_type")
	instantie_type_claim_value == "Zorgkantoor"

	afzender_id_type_value := _graphql.mutation_obj_arg(config.query_selection, global.variables, "meldingInput", "afzenderIDType") # regal ignore:line-length
	afzender_id_type_value == "AGB"

	ontvanger_id_type_value := _graphql.mutation_obj_arg(config.query_selection, global.variables, "meldingInput", "ontvangerIDType") # regal ignore:line-length
	ontvanger_id_type_value == "UZOVI"
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
