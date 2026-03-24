package bemiddelingsregister.bemiddeling.rules

import rego.v1

import data.authz.global
import data.bemiddelingsregister.bemiddeling.config
import data.utils.common
import data.utils.common.actors as common_actors
import data.utils.graphql as _graphql

wlz_indicatieid_is_instelling if {
	is_indicatie_id_request_zorgaanbieder
	_graphql.where_required_name_subentity(
		config.query_selection,
		"bemiddelingspecificatie",
		"some", "instelling", "eq",
	)
	_graphql.only_selections(
		config.query_selection,
		["wlzIndicatieID"],
	)
}

is_indicatie_id_request_zorgaanbieder if {
	common_actors.actor_is_vecozo
	_graphql.where_required_name_not_empty(
		config.query_selection,
		global.variables,
		"wlzIndicatieID", "eq",
	)
}

error_messages contains msg if {
	config.operation
	is_indicatie_id_request_zorgaanbieder
	not wlz_indicatieid_is_instelling
	not is_indicatie_id_request_zorkantoor

	msg := {
		"message": common.err("'bemiddelingspecificatie' some 'instelling' required and 'wlzIndicatieID' eq required ", config.operation), # regal ignore:line-length
		"extensions": {"code": common.errors.BAD_REQUEST},
	}
}
