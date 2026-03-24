package notificaties.zendnotificatie.rules

import rego.v1

import data.notificaties.constants
import data.notificaties.zendnotificatie.config

import data.authz.global
import data.utils.common
import data.utils.graphql as _graphql

scope_has_ontvanger_type if {
	ontvanger_id_type = _graphql.mutation_obj_arg(config.query_selection, global.variables, "notificatieInput", "ontvangerIDType") # regal ignore:line-length
	afzender_type := constants.instantie_type_map_to_scope[ontvanger_id_type]
	afzender_type != null
	new_scope = sprintf("organisaties/%s/notificaties/notificatie:create", [afzender_type])
	new_scope in global.token.scopes
}

error_messages contains msg if {
	config.operation
	common.contains_scope(config.scope, global.token.scopes)

	not scope_has_ontvanger_type

	msg := {
		"message": common.err("Scope for `ontvangerIDType` not valid.", config.operation),
		"extensions": {"code": common.errors.GRAPHQL_VALIDATION_FAILED},
	}
}
