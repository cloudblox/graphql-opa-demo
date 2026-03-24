package notificaties.zendnotificatie.rules

import rego.v1

import data.notificaties.helpers
import data.notificaties.zendnotificatie.config
import data.notificaties.zendnotificatie.constants

import data.authz.global
import data.utils.common
import data.utils.graphql as _graphql

client_mutatie_request if {
	event_type_value := _graphql.mutation_obj_arg(config.query_selection, global.variables, "notificatieInput", "eventType") # regal ignore:line-length
	event_type_value == "MUTATIE_CLIENT"
}

mutatie_client_afzender_is_valid if {
	client_mutatie_request

	afzender_id_value := _graphql.mutation_obj_arg(config.query_selection, global.variables, "notificatieInput", "afzenderID") # regal ignore:line-length
	some uzovi in constants.afzender_ids
	afzender_id_value == uzovi
}

mutatie_client_afzender_is_valid if {
	not client_mutatie_request
}

error_messages contains msg if {
	config.operation
	common.contains_scope(config.scope, global.token.scopes)
	scope_has_ontvanger_type

	afzender_type_is_valid
	not mutatie_client_afzender_is_valid

	msg := {
		"message": common.err("afzender_id is not valid for `MUTATIE_CLIENT`.", config.operation),
		"extensions": {"code": common.errors.GRAPHQL_VALIDATION_FAILED},
	}
}
