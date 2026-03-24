package notificaties.zendnotificatie.rules

import rego.v1

import data.notificaties.zendnotificatie.config
import data.notificaties.zendnotificatie.constants as zendnotificatie_constants

import data.authz.global
import data.notificaties.helpers
import data.utils.common
import data.utils.graphql as _graphql

event_type_is_valid if {
	event_type_value := _graphql.mutation_obj_arg(config.query_selection, global.variables, "notificatieInput", "eventType") # regal ignore:line-length

	some event_type in helpers.all_event_types(zendnotificatie_constants.event_types)
	event_type == event_type_value
}

error_messages contains msg if {
	config.operation
	common.contains_scope(config.scope, global.token.scopes)
	scope_has_ontvanger_type

	not event_type_is_valid

	msg := {
		"message": common.err("event_type is not valid.", config.operation),
		"extensions": {"code": common.errors.GRAPHQL_VALIDATION_FAILED},
	}
}
