package bemiddelingsregister.bemiddelingspecificatie.rules

import data.authz.global
import data.bemiddelingsregister.bemiddelingspecificatie.config
import data.bemiddelingsregister.helpers
import data.utils.common
import data.utils.date
import data.utils.graphql as _graphql
import rego.v1

_may_31_next_year(date) := result if {
	[year, _, _] := split(date, "-")
	result := sprintf("%d-05-31", [to_number(year) + 1])
}

_add_2_years(date) := result if {
	[year, month, day] := split(date, "-")
	result := sprintf("%d-%s-%s", [to_number(year) + 2, month, day])
}

ingangsdata_vars := vars if {
	toewijzing_ingangsdatum := _graphql.where_required_name(config.query_selection, "toewijzingIngangsdatum", "eq")
	ingangsdatum_var := _graphql.val_or_var(toewijzing_ingangsdatum, global.variables)

	vaststellingmoment := _graphql.where_required_name(config.query_selection, "vaststellingMoment", "eq")
	vaststellingmoment_var := _graphql.val_or_var(vaststellingmoment, global.variables)
	vaststellingdatum_var := date.dt_to_datum(vaststellingmoment_var)

	vars := {
		ingangsdatum_var,
		vaststellingdatum_var,
	}
}
