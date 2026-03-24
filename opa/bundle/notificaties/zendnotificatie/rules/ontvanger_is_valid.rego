package notificaties.zendnotificatie.rules

import rego.v1

import data.authz.global
import data.notificaties.constants
import data.notificaties.helpers
import data.notificaties.zendnotificatie.config
import data.notificaties.zendnotificatie.constants as zendnotificatie_constants
import data.utils.common
import data.utils.graphql as _graphql

ontvanger_is_valid if {
	client_mutatie_valid_ontvanger

	event_type_value := _graphql.mutation_obj_arg(config.query_selection, global.variables, "notificatieInput", "eventType") # regal ignore:line-length
	ontvanger_id_type := _graphql.mutation_obj_arg(config.query_selection, global.variables, "notificatieInput", "ontvangerIDType") # regal ignore:line-length
	some ontvanger_event_type in zendnotificatie_constants.event_types[ontvanger_id_type]
	event_type_value == ontvanger_event_type
}

client_mutatie_valid_ontvanger if {
	client_mutatie_request
	ontvanger_is_vecozo
}

client_mutatie_valid_ontvanger if {
	not client_mutatie_request
}

ontvanger_is_vecozo if {
	ontvanger_id := _graphql.mutation_obj_arg(config.query_selection, global.variables, "notificatieInput", "ontvangerID") # regal ignore:line-length
	ontvanger_id == helpers.vecozo_kvk_nummer
}

error_messages contains msg if {
	config.operation
	common.contains_scope(config.scope, global.token.scopes)
	scope_has_ontvanger_type

	event_type_is_valid
	not ontvanger_is_valid

	msg := {
		"message": common.err("ontvanger_type is not valid.", config.operation),
		"extensions": {"code": common.errors.GRAPHQL_VALIDATION_FAILED},
	}
}
