package notificaties.zendnotificatie.rules

import rego.v1

import data.notificaties.constants
import data.notificaties.helpers
import data.notificaties.zendnotificatie.config

import data.authz.global
import data.utils.common
import data.utils.graphql as _graphql

ciz_allowed_event_types := {"NIEUWE_INDICATIE_ZORGKANTOOR", "VERVALLEN_INDICATIE_ZORGKANTOOR"}

event_type_afzender_ciz_is_valid if {
	not helpers.afzender_is_ciz

	event_type_value := _graphql.mutation_obj_arg(config.query_selection, global.variables, "notificatieInput", "eventType") # regal ignore:line-length

	every event_type in ciz_allowed_event_types {
		event_type != event_type_value
	}
}

event_type_afzender_ciz_is_valid if {
	helpers.afzender_is_ciz

	event_type_value := _graphql.mutation_obj_arg(config.query_selection, global.variables, "notificatieInput", "eventType") # regal ignore:line-length

	some event_type in ciz_allowed_event_types
	event_type == event_type_value
}

error_messages contains msg if {
	config.operation
	common.contains_scope(config.scope, global.token.scopes)
	scope_has_ontvanger_type

	not event_type_afzender_ciz_is_valid
	helpers.afzender_is_ciz

	msg := {
		"message": common.err(
			sprintf(
				"event_type for afzender CIZ not valid, should be: '%s'",
				[concat(" or ", ciz_allowed_event_types)],
			),
			config.operation,
		),
		"extensions": {"code": common.errors.GRAPHQL_VALIDATION_FAILED},
	}
}

error_messages contains msg if {
	config.operation
	common.contains_scope(config.scope, global.token.scopes)
	scope_has_ontvanger_type

	not event_type_afzender_ciz_is_valid
	not helpers.afzender_is_ciz

	msg := {
		"message": common.err("ontvanger_type is not valid.", config.operation),
		"extensions": {"code": common.errors.GRAPHQL_VALIDATION_FAILED},
	}
}
