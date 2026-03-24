package bemiddelingsregister.helpers

import data.utils.common
import data.utils.date
import data.utils.graphql as _graphql
import rego.v1

# For ingangsdatum: check if actor's toewijzingingangsdatum is before queried the (toewijzing)einddatum of the subentity
where_toewijzingingangsdatum_overlaps(q, vars, ingang_datum) if {
	where := _graphql.children_arg(q, "where")
	_and := _graphql.children(where, "and")

	not _graphql.nameless_children_arg_in(_and, ["einddatum", "toewijzingEinddatum"])
	_or := _graphql.nameless_children_arg(_and, "or")

	# Makes sure every instance of a date overlap filter is checked
	every child in _or {
		filter_instance := _graphql.children_in(child.Value.Children, ["einddatum", "toewijzingEinddatum"])
		_einddatum_eq_or_gt(filter_instance, vars, ingang_datum)
	}
}

# Same function as above, is used when the and operator is omitted in the query
where_toewijzingingangsdatum_overlaps(q, vars, ingang_datum) if {
	where := _graphql.children_arg(q, "where")
	not _graphql.children_in(where, ["einddatum", "toewijzingEinddatum"])

	_or := _graphql.children(where, "or")

	every child in _or {
		filter_instance := _graphql.children_in(child.Value.Children, ["einddatum", "toewijzingEinddatum"])
		_einddatum_eq_or_gt(filter_instance, vars, ingang_datum)
	}
}

# Checks if an input variable matches either the given toewijzingingangsdatum or vastellingdatum
_einddatum_eq_or_gt(obj, vars, ingang_data) if {
	every filter in obj {
		# Makes sure that the right type of overlap is checked
		filter.Name in ["gt", "gte"]

		filter_date_var := _graphql.val_or_var(filter.Value, vars)

		# ingang_data is a list with both the toewijzingingangsdatum and vaststellingMoment
		some input_var in ingang_data
		date.compare_time_equals(filter_date_var, input_var)
	}
}

# Checks if the query checks whether the einddatum is null if it uses an "eq" comparison
_einddatum_eq_or_gt(obj, vars, ingang_data) if {
	every filter in obj {
		filter.Name == "eq"
		common.is_null_value(_graphql.val_or_var(filter.Value, vars))
	}
}
