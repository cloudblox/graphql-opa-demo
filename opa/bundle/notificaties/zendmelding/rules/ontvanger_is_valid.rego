package notificaties.zendmelding.rules

import rego.v1

import data.notificaties.zendmelding.config
import data.notificaties.zendmelding.constants as zendmelding_constants

import data.authz.global
import data.utils.common
import data.utils.graphql as _graphql

ontvanger_is_valid if {
	ontvanger_id_type = _graphql.mutation_obj_arg(config.query_selection, global.variables, "meldingInput", "ontvangerIDType") # regal ignore:line-length
	some allowed_ontvanger in zendmelding_constants.allowed_ontvangers
	ontvanger_id_type == allowed_ontvanger
	event_type_value := _graphql.mutation_obj_arg(config.query_selection, global.variables, "meldingInput", "eventType")
	some ontvanger_event_type in zendmelding_constants.event_types[ontvanger_id_type]
	event_type_value == ontvanger_event_type
}

error_messages contains msg if {
	config.operation
	common.contains_scope(config.scope, global.token.scopes)
	scope_has_ontvanger_type

	event_type_is_valid
	not ontvanger_is_valid

	msg := {
		"message": common.err("ontvanger is not valid.", config.operation),
		"extensions": {"code": common.errors.GRAPHQL_VALIDATION_FAILED},
	}
}
