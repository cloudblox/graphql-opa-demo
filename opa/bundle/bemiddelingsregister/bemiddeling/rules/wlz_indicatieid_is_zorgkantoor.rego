package bemiddelingsregister.bemiddeling.rules

import rego.v1

import data.authz.global
import data.bemiddelingsregister.bemiddeling.config
import data.utils.common
import data.utils.common.actors as common_actors
import data.utils.graphql as _graphql

wlz_indicatieid_is_zorgkantoor if {
	is_indicatie_id_request_zorkantoor
	_graphql.only_selections(
		config.query_selection,
		["wlzIndicatieID"],
	)
}

is_indicatie_id_request_zorkantoor if {
	common_actors.actor_is_vecozo
	_graphql.where_required_name_not_empty(
		config.query_selection,
		global.variables,
		"wlzIndicatieID", "eq",
	)
	has_verantwoordelijk_zorgkantoor_neq_value
	has_verantwoordelijk_uitvoerendzorgkantoor_or
	has_overdracht_verantwoordelijk_zorgkantoor_or
}

has_verantwoordelijk_zorgkantoor_neq_value := value if {
	graphql_value := _graphql.where_required_name_not_empty(
		config.query_selection,
		global.variables,
		"verantwoordelijkZorgkantoor", "neq",
	)
	value := _graphql.val_or_var(graphql_value, global.variables)
}

has_overdracht_verantwoordelijk_zorgkantoor_or if {
	_where := _graphql.children_arg(config.query_selection, "where")
	_or := _graphql.children(_where, "or")
	_args := _graphql.nameless_children_arg(_or, "overdracht")
	every filter in _args {
		filter.Name == "verantwoordelijkZorgkantoor"
		every child in filter.Value.Children {
			child.Name == "eq"
			val := _graphql.val_or_var(child.Value, global.variables)
			common.is_not_null_or_empty(val)
			val == has_verantwoordelijk_zorgkantoor_neq_value
		}
	}
}

has_verantwoordelijk_uitvoerendzorgkantoor_or if {
	_where := _graphql.children_arg(config.query_selection, "where")
	_or := _graphql.children(_where, "or")
	_args := _graphql.nameless_children_arg(_or, "bemiddelingspecificatie")
	every filter in _args {
		filter.Name == "some"
		children := _graphql.children(filter.Value.Children, "uitvoerendZorgkantoor")
		every child in children {
			child.Name == "eq"
			val := _graphql.val_or_var(child.Value, global.variables)
			common.is_not_null_or_empty(val)
			val == has_verantwoordelijk_zorgkantoor_neq_value
		}
	}
}

error_messages contains msg if {
	config.operation
	is_indicatie_id_request_zorkantoor

	not wlz_indicatieid_is_zorgkantoor

	msg := {
		"message": common.err("'bemiddelingspecificatie' some 'instelling' required and 'wlzIndicatieID' eq required ", config.operation), # regal ignore:line-length
		"extensions": {"code": common.errors.BAD_REQUEST},
	}
}
