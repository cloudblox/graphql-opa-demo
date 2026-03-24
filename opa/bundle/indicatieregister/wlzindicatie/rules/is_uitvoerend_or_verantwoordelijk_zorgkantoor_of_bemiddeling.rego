package indicatieregister.wlzindicatie.rules

import rego.v1

import data.authz.global
import data.indicatieregister.wlzindicatie.config
import data.pip.bemiddelingsregister as bemiddelingsregister_pip
import data.utils.common
import data.utils.graphql as _graphql
import data.utils.graphql.graphql_request

# POL113 & POL107
uzovi_pip_required if {
	subject_is_zorgkantoor
	id_is_required
	not has_initieelverantwoordelijkzorgkantoor
}

is_uitvoerend_or_verantwoordelijk_zorgkantoor_of_bemiddeling if {
	uzovi_pip_required

	wlz_indicatie_selection := _graphql.where_required_name_not_empty(
		config.query_selection,
		global.variables,
		"wlzindicatieID", "eq",
	)
	wlz_indicatie_id := _graphql.val_or_var(wlz_indicatie_selection, global.variables)
	bemiddelingsregister_pip.is_uitvoerend_or_verantwoordelijk_zorgkantoor_of_bemiddeling_by_wlz_indicatie_id(wlz_indicatie_id) # regal ignore:line-length
}

error_messages contains msg if {
	config.operation
	config.scope_allowed

	subject_is_zorgkantoor
	id_is_required
	not has_initieelverantwoordelijkzorgkantoor
	not is_uitvoerend_or_verantwoordelijk_zorgkantoor_of_bemiddeling

	msg := {
		"message": common.err("Subject is not listed as `verantwoordelijkzorgkantoor` or `uitvoerendzorgkantoor` of a `bemiddeling` with the specified `wlzindicatieID`", config.operation), # regal ignore:line-length
		"extensions": {"code": common.errors.UNAUTHORIZED},
	}
}
